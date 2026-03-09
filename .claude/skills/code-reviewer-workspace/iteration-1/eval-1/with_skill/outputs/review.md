## コードレビュー

### 総評

認証処理の基本的な骨格（ユーザー検索 → パスワード照合 → JWT発行）は適切に構成されています。
ただし、**パスワードの平文ログ出力**と**エラーの握りつぶし**という2点において重大なセキュリティ・信頼性上の問題があり、本番環境へのデプロイ前に必ず修正が必要です。

---

### 詳細コメント

- `[MUST]` **auth.ts:10** — `console.log` でパスワード平文を出力しています。ログはアプリケーションサーバーや監視ツールなど複数の場所に保存・転送されるため、平文パスワードがログに残ることは深刻な情報漏えいリスクになります。この行は削除してください。ユーザーのログイン成功を記録したい場合は、メールアドレスのみ（あるいは匿名化したユーザーIDのみ）をログに残すようにしましょう。

  ```typescript
  // NG
  console.log(`User logged in: ${email}, password: ${password}`);

  // OK
  console.log(`User logged in: userId=${user.id}`);
  ```

  > 参考: [OWASP — Logging Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Logging_Cheat_Sheet.html)

- `[MUST]` **auth.ts:12-14 (catch ブロック)** — `catch (e)` でエラーを握りつぶしています。DBへの接続失敗・bcrypt の処理エラーなど、予期しない例外が発生しても呼び出し元には `undefined` が返るだけで、問題の検知が不可能になります。エラーは必ずログに記録し、適切に再スロー（または意味のある例外型に変換）してください。

  ```typescript
  // NG
  catch (e) {
    // ignore error
  }

  // OK
  catch (e) {
    console.error('Authentication error:', e);
    throw new Error('Authentication failed');
  }
  ```

- `[SHOULD]` **auth.ts:2 (関数シグネチャ)** — 戻り値の型が明示されていません。TypeScript の型安全性を最大限に活かすため、戻り値の型を明示することを推奨します。現状では `undefined` が返る可能性（catch ブロックが何も返さない）も型に現れていないため、呼び出し元でのハンドリング漏れが起きやすくなっています。

  ```typescript
  async function authenticateUser(email: string, password: string): Promise<string | null>
  ```

- `[SHOULD]` **auth.ts:2 (認証失敗時のレスポンス)** — 「ユーザーが存在しない」場合と「パスワードが間違っている」場合を区別せずに `null` を返している点は意図的であれば良い設計です。ただし、呼び出し元がエラー理由を把握できるよう、`null` の代わりに識別可能なエラー型（カスタム例外 or discriminated union）を返す設計も検討に値します。

- `[ASK]` **auth.ts:5** — `db.users.findOne({ email })` でメールアドレスの大文字/小文字を区別しない比較が行われているかどうか確認できますか？ `User@example.com` と `user@example.com` が別ユーザーとして扱われると、ユーザー体験の問題になる場合があります。DB側のコレーション設定やクエリのオプションを確認することをお勧めします。

- `[LGTM]` **auth.ts:7-8** — `bcrypt.compare` を使ってパスワードの照合を行っており、パスワードハッシュを正しく扱っています。平文パスワードをDB保存していない点は適切な実装です。

---

### まとめ

#### 必須対応（MUST）

1. **パスワード平文ログの削除**: `console.log` のパスワード出力を即時削除する
2. **エラーハンドリングの実装**: `catch` ブロックでエラーをログに記録し、適切に再スローする

#### 推奨対応（SHOULD）

3. 戻り値の型アノテーションを追加する（`Promise<string | null>`）
4. メールアドレスの大文字/小文字正規化の考慮

**2点の MUST 対応が完了するまで本番マージは控えることを強く推奨します。**
