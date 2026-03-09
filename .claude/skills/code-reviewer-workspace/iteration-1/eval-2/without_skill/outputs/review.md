# Go Cache Code Review

## Summary

The code implements a simple in-memory TTL cache with mutex-based locking and a background cleanup goroutine. It's functional and readable, but has several issues worth addressing.

---

## Issues

### 1. Goroutine Leak — `cleanupLoop` runs forever with no way to stop it

The goroutine started in `NewCache()` runs indefinitely. There is no context, channel, or `Stop()` method to signal it to exit. If a `Cache` instance goes out of scope, the goroutine keeps running and holds a reference to the `Cache`, preventing garbage collection.

```go
// Problem: no way to stop this
go c.cleanupLoop()
```

**Fix:** Accept a `context.Context` or expose a `Stop()` method using a done channel.

```go
type Cache struct {
    mu    sync.Mutex
    items map[string]Item
    done  chan struct{}
}

func (c *Cache) Stop() {
    close(c.done)
}

func (c *Cache) cleanupLoop() {
    ticker := time.NewTicker(5 * time.Minute)
    defer ticker.Stop()
    for {
        select {
        case <-ticker.C:
            c.cleanup()
        case <-c.done:
            return
        }
    }
}
```

---

### 2. `ticker` is Never Stopped

`time.NewTicker` allocates resources. The current `cleanupLoop` never calls `ticker.Stop()`, which leaks the ticker's goroutine and channel.

```go
ticker := time.NewTicker(5 * time.Minute)
// ticker.Stop() is never called
```

**Fix:** Always defer `ticker.Stop()` (as shown above).

---

### 3. `sync.Mutex` Should Be Replaced with `sync.RWMutex`

`Get` is a read-only operation but acquires a full write lock. Under concurrent read-heavy workloads this unnecessarily serializes all reads.

```go
// Both Get and Set use the same exclusive lock
c.mu.Lock()
```

**Fix:** Use `sync.RWMutex` and `RLock`/`RUnlock` in `Get`.

```go
type Cache struct {
    mu    sync.RWMutex
    items map[string]Item
}

func (c *Cache) Get(key string) (interface{}, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    ...
}
```

---

### 4. Expired Items Are Not Deleted on `Get`

When `Get` finds an expired item it returns `nil, false` but leaves the stale entry in the map. Expired entries accumulate until the cleanup ticker runs (up to 5 minutes later), wasting memory in workloads with many unique keys.

**Fix:** Delete the expired item lazily on read.

```go
func (c *Cache) Get(key string) (interface{}, bool) {
    c.mu.Lock()
    defer c.mu.Unlock()
    item, ok := c.items[key]
    if !ok {
        return nil, false
    }
    if time.Now().After(item.ExpiresAt) {
        delete(c.items, key)
        return nil, false
    }
    return item.Value, true
}
```

(Note: if you adopt `RWMutex`, lazy deletion in `Get` requires upgrading to a write lock or using a separate write path.)

---

### 5. No `Delete` Method

There is no way for callers to explicitly remove an item before its TTL expires. This is a standard cache operation that should be provided.

```go
func (c *Cache) Delete(key string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    delete(c.items, key)
}
```

---

### 6. `interface{}` Should Be `any` (Minor / Style)

Since Go 1.18, `any` is the idiomatic alias for `interface{}`. This is cosmetic but keeps the code current.

---

### 7. Zero TTL Is Silently Accepted

Calling `Set(key, value, 0)` creates an item that is immediately expired. There is no guard against this, which is likely a caller bug.

**Fix:** Either document the behavior clearly, return an error, or treat `ttl <= 0` as "no expiry" / panic in debug builds.

---

## What Works Well

- Correct use of `defer c.mu.Unlock()` avoids lock leaks on early returns.
- The `Item` struct cleanly separates value storage from expiry metadata.
- The cleanup loop correctly iterates and deletes in-place (safe in Go).
- The package structure is clean and minimal.

---

## Priority Summary

| # | Issue | Severity |
|---|-------|----------|
| 1 | Goroutine leak / no Stop() | High |
| 2 | Ticker never stopped | High |
| 3 | Mutex should be RWMutex | Medium |
| 4 | Expired items not evicted on Get | Medium |
| 5 | No Delete method | Medium |
| 6 | `interface{}` → `any` | Low |
| 7 | Zero TTL silently accepted | Low |
