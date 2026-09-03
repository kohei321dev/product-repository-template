# Documentation

- Standard-Version: 1
- Status: Current

このディレクトリは、プロダクトの現在の契約と、恒久的な判断理由を管理するSource of Truthです。

## Reading order

1. [`product.md`](product.md): なぜ、誰のために、何を作るか
2. [`requirements.md`](requirements.md): 何を満たす必要があるか
3. [`specifications/`](specifications/README.md): 外部から観測できる振る舞い
4. [`architecture.md`](architecture.md): どのように構成するか
5. [`security.md`](security.md): 守る対象と安全境界
6. [`decisions/`](decisions/README.md): なぜその判断を選んだか
7. [`process/`](process/development.md): 変更をどう進めるか
8. [`operations/`](operations/README.md): どう運用・復旧するか
9. [`guides/`](guides/README.md): どう利用・管理するか

## Document map

| Path              | Responsibility                               | Update trigger              |
| ----------------- | -------------------------------------------- | --------------------------- |
| `product.md`      | 利用者、課題、価値、対象、非対象、成功条件   | プロダクト目的やscopeの変更 |
| `requirements.md` | 機能・非機能要件、制約、release gate         | 実現必須事項の変更          |
| `specifications/` | UI、API、schema、入出力、errorなどの外部仕様 | 観測可能な振る舞いの変更    |
| `architecture.md` | component、data、integration、deployment境界 | 内部責務や技術構成の変更    |
| `security.md`     | 認証、認可、secret、privacy、脅威、保持      | 安全境界やdata取扱いの変更  |
| `decisions/`      | context、判断、代替案、結果、見直し条件      | 長期間残すべき判断          |
| `process/`        | Issue、Pull Request、release、文書更新方法   | 開発・承認プロセスの変更    |
| `operations/`     | deploy、monitor、incident、rollback、backup  | 運用手順や運用条件の変更    |
| `guides/`         | 利用者・管理者向け操作方法                   | 操作手順の変更              |

## History and status

- 現在の正しい状態は、日付やversionをファイル名へ付けず、同じパスで更新する。
- 変更理由はIssue、Pull Request、Decision Recordを相互にリンクして残す。
- `latest`、`final`、`new`、`v2`などを現行文書名に使用しない。
- 過去文書が必要な場合はGit履歴を優先し、特別な理由がある場合だけ`archive/`へ置く。
- 会話のraw logを保存せず、必要な事実と判断だけを文書化する。

## Naming

- パスは英小文字のkebab-caseを使用する。
- 本文は日本語でよい。
- Decision Recordは`decisions/0001-short-title.md`の4桁連番とする。
- 日付はDecision Record、research、運用証跡など時点が意味を持つ文書だけに使用する。
