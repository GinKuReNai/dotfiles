#!/usr/bin/env python3
"""
GitHub Issues 自動生成スクリプト

設計ドキュメントからタスクを抽出し、原子性を持った GitHub Issues を生成します。
"""

import argparse
import json
import re
import subprocess
from pathlib import Path
from typing import Dict, List, Optional


class Issue:
    """GitHub Issue の表現"""

    def __init__(
        self,
        title: str,
        body: str,
        labels: List[str],
        depends_on: Optional[List[int]] = None,
    ):
        self.title = title
        self.body = body
        self.labels = labels
        self.depends_on = depends_on or []

    def to_gh_command(self) -> str:
        """gh issue create コマンドの生成"""
        labels_str = ",".join(f'"{label}"' for label in self.labels)
        depends_str = "\n\n## 依存関係\n" + "\n".join(
            f"Depends on #{dep}" for dep in self.depends_on
        ) if self.depends_on else ""

        escaped_body = self.body.replace('"', '\\"').replace("\n", "\\n")

        return f'''gh issue create \\
  --title "{self.title}" \\
  --body "{escaped_body}{depends_str}" \\
  --label {labels_str}'''

    def __repr__(self) -> str:
        return f"Issue(title={self.title}, labels={self.labels}, depends={self.depends_on})"


def parse_prd(prd_path: Path) -> Dict:
    """PRD ドキュメントのパース"""
    content = prd_path.read_text(encoding="utf-8")

    prd_data = {
        "title": "",
        "core_features": {"P0": [], "P1": [], "P2": []},
        "constraints": [],
    }

    # タイトルを抽出（簡易実装）
    title_match = re.search(r"^#\s+(.+?)\s+PRD", content, re.MULTILINE)
    if title_match:
        prd_data["title"] = title_match.group(1)

    # Core Features を抽出
    sections = re.split(r"^##\s+", content, flags=re.MULTILINE)
    for section in sections:
        if section.startswith("Core Features"):
            # P0, P1, P2 セクションを抽出
            for priority in ["P0", "P1", "P2"]:
                pattern = rf"###\s+{priority}.*?$(.+?)$"
                features = re.findall(pattern, section, re.MULTILINE | re.DOTALL)
                prd_data["core_features"][priority] = [
                    f.strip("- ").strip() for f in features
                ]

    return prd_data


def parse_architecture(arch_path: Path) -> Dict:
    """アーキテクチャドキュメントのパース"""
    content = arch_path.read_text(encoding="utf-8")

    tech_stack = {}

    # 技術スタックを抽出（簡易実装）
    sections = re.split(r"^###\s+", content, flags=re.MULTILINE)
    for section in sections:
        section_lines = section.strip().split("\n")
        if section_lines:
            category = section_lines[0].strip()
            tech_stack[category] = []

            for line in section_lines[1:]:
                tech_match = re.match(r"^\*\s+\*\*\s+(.+?)\*\*:?\s*(.+)$", line)
                if tech_match:
                    tech_name = tech_match.group(1).strip()
                    reason = tech_match.group(2).strip() if tech_match.group(2) else ""
                    tech_stack[category].append({"name": tech_name, "reason": reason})

    return {"tech_stack": tech_stack}


def parse_database(db_path: Path) -> Dict:
    """データベーススキーマドキュメントのパース"""
    content = db_path.read_text(encoding="utf-8")

    tables = {}

    # テーブルごとのスキーマを抽出（簡易実装）
    table_sections = re.split(r"^###\s+", content, flags=re.MULTILINE)
    for section in table_sections:
        table_name = section.strip().split("\n")[0].lower()
        if table_name and table_name != "er diagram":
            tables[table_name] = {
                "fields": [],
                "indexes": [],
                "foreign_keys": [],
            }

            # フィールド、インデックス、外部キーを抽出
            # （簡易実装のため、詳細なパースはスキップ）

    return {"tables": tables}


def parse_api_spec(api_path: Path) -> Dict:
    """APIスペックドキュメントのパース"""
    content = api_path.read_text(encoding="utf-8")

    endpoints = []

    # エンドポイントを抽出（簡易実装）
    lines = content.split("\n")
    for line in lines:
        if line.startswith("| ") and "POST" in line or "GET" in line:
            parts = [p.strip() for p in line.split("|")]
            if len(parts) >= 3:
                method = parts[1]
                path = parts[2]
                summary = parts[3] if len(parts) > 3 else ""
                endpoints.append({"method": method, "path": path, "summary": summary})

    return {"endpoints": endpoints}


def generate_issues_from_prd(prd_data: Dict) -> List[Issue]:
    """PRD から Issues を生成"""
    issues = []

    # P0 機能の Issues
    for i, feature in enumerate(prd_data["core_features"]["P0"], 1):
        issues.append(
            Issue(
                title=f"feat: {feature} の実装",
                body=f"""## 概要
{feature} を実装する。

## 完了条件
- {feature} が正常に動作する
- 必要なテストがパスする
- ドキュメントが更新されている

## 優先度
P0（必須機能）
""",
                labels=["type:feature"],
            )
        )

    # 基盤 Issues（アーキテクチャ、DB、API）
    base_issues = [
        Issue(
            title="refactor: プロダクトアーキテクチャの確定",
            body="""## 概要
選定した技術スタックとシステム構成を確定する。

## 完了条件
- architecture.md が更新されている
- 技術選定の理由が文書化されている
- システム構成図が作成されている
""",
            labels=["type:refactor"],
        ),
        Issue(
            title="refactor: データベーススキーマの設計",
            body="""## 概要
ER 図とスキーマ定義を作成する。

## 完了条件
- database.md が更新されている
- ER 図が作成されている
- スキーマ定義が完了している
- インデックス設計がされている
""",
            labels=["type:refactor", "scope:backend"],
        ),
        Issue(
            title="refactor: API エンドポイントの設計",
            body="""## 概要
API スペックを作成する。

## 完了条件
- api-spec.md が更新されている
- エンドポイント一覧が作成されている
- リクエスト/レスポンス形式が定義されている
- エラーハンドリングが設計されている
""",
            labels=["type:refactor", "scope:backend"],
        ),
    ]

    return base_issues + issues


def generate_issues_from_architecture(arch_data: Dict, dependency_issue_id: int) -> List[Issue]:
    """アーキテクチャから Issues を生成"""
    issues = []

    # フロントエンドの基盤構築
    issues.append(
        Issue(
            title="refactor: フロントエンド開発環境の構築",
            body="""## 概要
フロントエンドの開発環境をセットアップする。

## 完了条件
- ビケージがインストールされている
- 開発コマンドが動作する
- 基本的なディレクトリ構成が作成されている
- 環境変数が設定されている
""",
            labels=["type:refactor", "scope:frontend"],
            depends_on=[dependency_issue_id],
        )
    )

    # バックエンドの基盤構築
    issues.append(
        Issue(
            title="refactor: バックエンド開発環境の構築",
            body="""## 概要
バックエンドの開発環境をセットアップする。

## 完了条件
- ビケージがインストールされている
- 開発コマンドが動作する
- 基本的なディレクトリ構成が作成されている
- 環境変数が設定されている
- データベース接続が設定されている
""",
            labels=["type:refactor", "scope:backend"],
            depends_on=[dependency_issue_id],
        )
    )

    return issues


def generate_issues_from_database(db_data: Dict, dependency_issue_id: int) -> List[Issue]:
    """データベーススキーマから Issues を生成"""
    issues = []

    # マイグレーション
    issues.append(
        Issue(
            title="refactor: データベースマイグレーションの実装",
            body="""## 概要
データベースの初期マイグレーションを作成する。

## 完了条件
- マイグレーションスクリプトが作成されている
- テーブルが正しく作成される
- 外部キー制約が正しく設定されている
- インデックスが作成されている
""",
            labels=["type:refactor", "scope:backend"],
            depends_on=[dependency_issue_id],
        )
    )

    return issues


def generate_issues_from_api(api_data: Dict, dependency_issue_id: int) -> List[Issue]:
    """API スペックから Issues を生成"""
    issues = []

    # 認証エンドポイントの実装
    for endpoint in api_data["endpoints"]:
        issues.append(
            Issue(
                title=f"feat: {endpoint['method']} {endpoint['path']} の実装",
                body=f"""## 概要
{endpoint['summary']} を実装する。

## 完了条件
- {endpoint['method']} {endpoint['path']} エンドポイントが正常に動作する
- リクエスト/レスポンスがスペック通りである
- 必要なバリデーションが実装されている
- エラーハンドリングが適切である
""",
                labels=["type:feature", "scope:backend"],
                depends_on=[dependency_issue_id],
            )
        )

    return issues


def main():
    parser = argparse.ArgumentParser(
        description="設計ドキュメントから GitHub Issues を生成する"
    )
    parser.add_argument("--prd", type=Path, required=True, help="PRD ファイルのパス")
    parser.add_argument(
        "--architecture", type=Path, required=True, help="アーキテクチャ ファイルのパス"
    )
    parser.add_argument(
        "--database", type=Path, required=True, help="データベース ファイルのパス"
    )
    parser.add_argument(
        "--api-spec", type=Path, required=True, help="API スペック ファイルのパス"
    )
    parser.add_argument(
        "--ui-flow", type=Path, required=True, help="UI Flow ファイルのパス"
    )
    parser.add_argument(
        "--create",
        action="store_true",
        help="実際に GitHub Issues を作成する（指定なしだらコマンドのみ表示）",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("github_issues_commands.sh"),
        help="コマンド出力ファイルのパス",
    )

    args = parser.parse_args()

    # ドキュメントのパース
    print("設計ドキュメントをパース中...")
    prd_data = parse_prd(args.prd)
    arch_data = parse_architecture(args.architecture)
    db_data = parse_database(args.database)
    api_data = parse_api_spec(args.api_spec)
    # ui_flow_data = parse_ui_flow(args.ui_flow)  # 未実装

    # Issues の生成
    print("Issues を生成中...")
    all_issues: List[Issue] = []

    # PRD からの基盤 Issues
    prd_issues = generate_issues_from_prd(prd_data)
    all_issues.extend(prd_issues)

    # 依存関係を管理するためのマッピング
    issue_id_map = {}
    current_id = 1
    for issue in all_issues:
        issue_id_map[frozenset(issue.title)] = current_id
        current_id += 1

    # アーキテクチャからの Issues（依存関係付き）
    arch_base_id = issue_id_map.get(
        frozenset("refactor: プロダクトアーキテクチャの確定")
    )
    if arch_base_id:
        arch_issues = generate_issues_from_architecture(arch_data, arch_base_id)
        all_issues.extend(arch_issues)

    # データベースからの Issues（依存関係付き）
    db_base_id = issue_id_map.get(
        frozenset("refactor: データベーススキーマの設計")
    )
    if db_base_id:
        db_issues = generate_issues_from_database(db_data, db_base_id)
        all_issues.extend(db_issues)

    # API からの Issues（依存関係付き）
    api_base_id = issue_id_map.get(frozenset("refactor: API エンドポイントの設計"))
    if api_base_id:
        api_issues = generate_issues_from_api(api_data, api_base_id)
        all_issues.extend(api_issues)

    # コマンドの生成
    print(f"\n生成された Issues: {len(all_issues)}\n")

    commands = []
    for i, issue in enumerate(all_issues, 1):
        print(f"{i}. {issue.title}")
        print(f"   ラベル: {', '.join(issue.labels)}")
        if issue.depends_on:
            print(f"   依存: {issue.depends_on}")
        commands.append(issue.to_gh_command())
        print()

    # 出力
    output_content = "#!/bin/bash\n# GitHub Issues 作成スクリプト\n\n"
    output_content += "# 各コマンドを順次実行するか、必要なコマンドのみ実行してください\n\n"
    output_content += "\n".join(commands)

    args.output.write_text(output_content, encoding="utf-8")
    print(f"コマンドは {args.output} に出力されました。")

    if args.create:
        # 実際に Issues を作成する
        print("\n実際に GitHub Issues を作成しますか？ (y/n): ", end="")
        # ここでは確認をスキップして作成する場合は、以下のコマンドを使用
        for issue in all_issues:
            try:
                result = subprocess.run(
                    issue.to_gh_command(),
                    shell=True,
                    check=True,
                    capture_output=True,
                    text=True,
                )
                print(f"✓ {issue.title} を作成しました")
            except subprocess.CalledProcessError as e:
                print(f"❌ {issue.title} の作成に失敗しました: {e.stderr}")


if __name__ == "__main__":
    main()
