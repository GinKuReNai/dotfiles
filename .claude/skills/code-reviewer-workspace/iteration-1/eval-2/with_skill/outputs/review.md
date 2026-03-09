## コードレビュー

### 総評

全体的にシンプルで読みやすい TTL 付きのインメモリキャッシュ実装です。`sync.Mutex` によるスレッドセーフな設計、定期的なクリーンアップループなど、基本的な要件は満たされています。一方で、読み取り操作でも排他ロックを取得しているため不要な競合が発生しうる点、および goroutine のライフサイクル管理がない点が主な懸念事項です。

---

### 詳細コメント

- `[MUST]` **cache.go: `cleanupLoop`** — goroutine の停止手段がなく、`Cache` のライフサイクルとデカップリングされていません。`Cache` が GC されても goroutine は永久に動き続けるため、メモリリークやリソースリークに繋がります。`context.Context` や `done` チャネルを使った停止機構を追加し、`NewCache` の引数または `Stop()` メソッドとして公開することを推奨します。

  ```go
  type Cache struct {
      mu    sync.RWMutex
      items map[string]Item
      done  chan struct{}
  }

  func NewCache() *Cache {
      c := &Cache{
          items: make(map[string]Item),
          done:  make(chan struct{}),
      }
      go c.cleanupLoop()
      return c
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
              c.mu.Lock()
              for k, v := range c.items {
                  if time.Now().After(v.ExpiresAt) {
                      delete(c.items, k)
                  }
              }
              c.mu.Unlock()
          case <-c.done:
              return
          }
      }
  }
  ```

- `[SHOULD]` **cache.go: `Cache.mu`** — `Get` はデータの読み取りのみなので、`sync.Mutex`（排他ロック）ではなく `sync.RWMutex` を使用することでリードヘビーなユースケースのスループットが大幅に向上します。`Set` と `cleanupLoop` では `Lock()`/`Unlock()` を、`Get` では `RLock()`/`RUnlock()` をそれぞれ使ってください。

  ```go
  type Cache struct {
      mu    sync.RWMutex
      items map[string]Item
  }

  func (c *Cache) Get(key string) (interface{}, bool) {
      c.mu.RLock()
      defer c.mu.RUnlock()
      // ...
  }
  ```

- `[SHOULD]` **cache.go: `cleanupLoop`** — `ticker.Stop()` が呼ばれていないため、goroutine が停止した後もタイマーリソースが解放されません。`defer ticker.Stop()` を追加してください（上記のコード例に含まれています）。

- `[SHOULD]` **cache.go: `Item.Value`** — `interface{}` はジェネリクスが導入された Go 1.18 以降では `any` というエイリアスが推奨されます。またプロダクションコードでは型パラメータを使った `Cache[V any]` にすることで型安全性が向上します。Go バージョンが 1.18 未満であれば現状のままで問題ありません。

  ```go
  // Go 1.18+
  type Cache[V any] struct { ... }
  type Item[V any] struct {
      Value     V
      ExpiresAt time.Time
  }
  ```

- `[IMO]` **cache.go: `Get` の期限切れアイテム** — `Get` で期限切れを検出した際に `delete(c.items, key)` で即時削除すると、クリーンアップループを待たずにメモリを解放できます。ただし、この場合は `RLock` から `Lock` への昇格が必要になるため、`sync.Mutex` に戻すか、ロックを取り直す実装が必要です。

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

- `[ASK]` **cache.go: `Set` の TTL=0 の扱い** — `ttl` に `0` や負の値が渡された場合、`ExpiresAt` が過去になり `Get` で即座に `false` が返ります。これは意図した仕様でしょうか？バリデーションを入れるか、ゼロ値を「有効期限なし」として扱う仕様にするかを明確にしておくことを推奨します。

- `[LGTM]` **cache.go: `Set` / `Get` のロック設計** — `defer c.mu.Unlock()` を使用することでパニック時もロックが確実に解放される、堅牢な実装になっています。

- `[LGTM]` **cache.go: `NewCache`** — コンストラクタパターンで `items` マップを初期化しており、nil マップへの書き込みパニックを防いでいます。基礎が丁寧に実装されています。

---

### まとめ

**対応が必要な点（優先度順）：**

1. **[MUST]** `cleanupLoop` goroutine の停止機構を追加する（`Stop()` メソッドまたは `context.Context` の受け取り）
2. **[SHOULD]** `sync.Mutex` → `sync.RWMutex` に変更し、`Get` で `RLock` を使う
3. **[SHOULD]** `defer ticker.Stop()` を `cleanupLoop` に追加する
4. **[SHOULD]** Go 1.18+ であれば `interface{}` → `any` / ジェネリクスへの移行を検討する

**次のアクション：**
- `Stop()` メソッドを実装してテストで `defer c.Stop()` が呼べるようにする
- `sync.RWMutex` への切り替え後、並行テスト（`-race` フラグ）でデータレースがないことを確認する
- `ttl` のバリデーション仕様をドキュメント or コメントで明確にする
