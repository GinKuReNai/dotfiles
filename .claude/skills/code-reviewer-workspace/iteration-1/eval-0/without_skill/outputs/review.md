# Code Review

## Critical Issues

### 1. SQL Injection Vulnerability (`get_user`)
```python
result = conn.execute(f"SELECT * FROM users WHERE id = {user_id}")
```
Using an f-string to interpolate `user_id` directly into the SQL query allows SQL injection. If `user_id` is user-controlled input, an attacker can manipulate the query.

**Fix:** Use parameterized queries:
```python
result = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,))
```

---

## Design Issues

### 2. N+1 Query Problem (`process_users`)
`process_users` calls `get_user` in a loop, resulting in one DB connection and query per user. For large lists this is very slow.

**Fix:** Fetch all users in a single query:
```python
def process_users(user_ids):
    conn = db.connect()
    placeholders = ",".join("?" * len(user_ids))
    result = conn.execute(f"SELECT * FROM users WHERE id IN ({placeholders})", user_ids)
    users = result.fetchall()
    conn.close()
    return users
```

### 3. No Error Handling / Connection Leak
If `conn.execute()` raises an exception, `conn.close()` is never called, leaking the connection.

**Fix:** Use a context manager:
```python
def get_user(user_id):
    with db.connect() as conn:
        result = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,))
        return result.fetchone()
```

---

## Minor Issues

### 4. `SELECT *` is fragile
Selecting all columns couples the caller to the schema. Prefer explicit columns:
```python
"SELECT id, name, email FROM users WHERE id = ?"
```

### 5. No `None` handling
`fetchone()` returns `None` if no user is found. `process_users` will silently include `None` entries in the result list. Consider filtering or raising an error.
