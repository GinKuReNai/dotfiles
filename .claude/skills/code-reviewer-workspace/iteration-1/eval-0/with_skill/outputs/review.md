## コードレビュー

### 総評

全体として構造はシンプルで読みやすいですが、**セキュリティ上の重大な脆弱性（SQLインジェクション）** と **パフォーマンス上の問題（N+1問題）** の2点が存在しており、本番投入前に必ず修正が必要です。良い点として、関数が単一責任の原則に従って分割されている点は評価できます。

---

### 詳細コメント

- `[MUST]` **`get_user` 関数:3行目** — SQLインジェクション脆弱性があります。f文字列でユーザー入力を直接SQL文字列に埋め込んでいるため、悪意のある `user_id`（例: `1 OR 1=1`）を渡された場合、意図しないデータの取得・改ざん・削除が可能になります。プレースホルダーを使ったパラメータ化クエリに変更してください。

  ```python
  # NG（現状）
  result = conn.execute(f"SELECT * FROM users WHERE id = {user_id}")

  # OK（修正案）
  result = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,))
  # ORMやライブラリによっては :id や %s を使う場合もあります
  ```

  参考: [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)

- `[MUST]` **`process_users` 関数 / `get_user` 関数** — N+1問題が発生しています。`process_users` がループ内で `get_user` を呼ぶたびにDBコネクションの確立・クエリ実行・切断が繰り返されます。`user_ids` の件数が多い場合、DBへの負荷とレイテンシが線形に増加します。一括取得（`WHERE id IN (...)`）でまとめてフェッチするよう変更してください。

  ```python
  def get_users(user_ids):
      if not user_ids:
          return []
      conn = db.connect()
      placeholders = ",".join("?" * len(user_ids))
      result = conn.execute(
          f"SELECT * FROM users WHERE id IN ({placeholders})", tuple(user_ids)
      )
      users = result.fetchall()
      conn.close()
      return users
  ```

- `[MUST]` **`get_user` 関数:4〜5行目** — 例外が発生した場合（クエリエラーなど）、`conn.close()` が呼ばれずコネクションリークが起きます。`try/finally` または `with` 文（コンテキストマネージャ）を使用して、必ずリソースが解放されるようにしてください。

  ```python
  def get_user(user_id):
      conn = db.connect()
      try:
          result = conn.execute("SELECT * FROM users WHERE id = ?", (user_id,))
          return result.fetchone()
      finally:
          conn.close()
  ```

- `[SHOULD]` **`get_user` 関数:1行目** — `SELECT *` は将来カラムが追加・削除された際に予期しない挙動を招く可能性があります。必要なカラムを明示的に指定することを推奨します（例: `SELECT id, name, email FROM users WHERE id = ?`）。これはパフォーマンス改善にも寄与します。

- `[SHOULD]` **`get_user` 関数** — `user_id` の型・値バリデーションがありません。`None` や負数、文字列が渡された場合の挙動が不明確です。呼び出し元でのバリデーションが保証されていない場合は、関数内で早期リターンやエラーハンドリングを検討してください。

  ```python
  def get_user(user_id: int):
      if not isinstance(user_id, int) or user_id <= 0:
          raise ValueError(f"Invalid user_id: {user_id}")
      ...
  ```

- `[IMO]` **`get_user` 関数** — DBコネクション管理を各関数内で行うよりも、コネクションプールやDIでコネクションを注入するパターンの方が、テストのしやすさ・リソース管理の面で優れています。設計の方向性によりますが、中長期的には検討の価値があります。

- `[LGTM]` **全体** — `get_user` と `process_users` を分離し、単一責任の原則（SRP）に従ってコードが整理されている点は良いです。

---

### まとめ

| 優先度 | 内容 |
|--------|------|
| 🔴 MUST | `get_user` のSQLをパラメータ化クエリに変更（SQLインジェクション対策） |
| 🔴 MUST | `process_users` をバルクフェッチ（`IN` 句）に変更（N+1問題解消） |
| 🔴 MUST | `conn.close()` を `try/finally` または `with` 文で保護（コネクションリーク防止） |
| 🟡 SHOULD | `SELECT *` を必要カラムの明示指定に変更 |
| 🟡 SHOULD | `user_id` の入力バリデーション追加 |

**次のアクション**: まずセキュリティ上の脆弱性（SQLインジェクション・コネクションリーク）を優先して修正し、次にN+1問題のバルクフェッチ化に対応することをお勧めします。
