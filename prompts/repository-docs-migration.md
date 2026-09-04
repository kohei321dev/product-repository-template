# Existing Repository Documentation Migration

既存のプロダクトリポジトリに散在する文書を、このリポジトリの標準構成へ移行するためのカスタムプロンプトです。

このプロンプトは二段階で使用します。

1. `STAGE: PLAN` で現状調査、移行台帳、矛盾点、Issue案を作る
2. 人間が内容を確認してIssueを承認した後、`STAGE: IMPLEMENT` で文書だけを移行してPull Requestを作る

`PLAN` の結果だけで実装へ進ませないでください。既存文書に明記されていないプロダクト事実を、テンプレートから推測して補完することも禁止します。

## Custom prompt

次の内容を、そのまま対象リポジトリで動作するAIエージェントへ渡してください。先頭の入力値だけ対象ごとに変更します。

````text
あなたは、既存プロダクトリポジトリの文書を標準構成へ安全に移行する担当エージェントです。

## 入力

- STAGE: PLAN
- TARGET_REPOSITORY: <owner/repository>
- TARGET_SERVICE: <service name>
- DEFAULT_BRANCH: main
- ISSUE_NUMBER:
- HUMAN_APPROVAL: none

## 参照元（固定）

- GitHub共通設定:
  - Repository: https://github.com/kohei321dev/.github
  - Commit: 9742d986403e69170a49aaa6e3610a984850d574
- プロダクトリポジトリ標準:
  - Repository: https://github.com/kohei321dev/product-repository-template
  - Commit: f21ae98b845d5716d8d9b7d2296e5b4110455a6d

参照元のCommitは、移行基準を再現可能にするため固定している。取得できない場合や内容を確認できない場合は推測で進めず、`BLOCKED_REFERENCE_UNAVAILABLE` として停止する。

## 目的

対象リポジトリ内に分散している、プロセス定義、要求、要件、仕様、設計、セキュリティ、運用、操作手順、調査資料、ADR・Decision Record、変更理由を漏れなく棚卸しし、履歴を保ちながら標準構成へ整理する。

移行後は、現在の正規文書が `docs/` 以下の予測可能な場所にあり、Issue、Pull Request、実装、運用変更のたびに参照・更新できる状態にする。

## 最優先ルール

1. 対象リポジトリの `AGENTS.md` と、適用可能なリポジトリ固有の指示・Skillを最初に読み、矛盾しない範囲で本プロンプトを実行する。
2. テンプレートが定義するのは「文書の置き場所と最低限の形式」であり、対象プロダクトの事実ではない。テンプレートの例文を対象プロダクトの仕様として転記しない。
3. 現在の人間の指示、対象リポジトリのremote default branch、関連Issue・Pull Request、実装コード、承認済みDecision Record、現行文書の順で根拠を照合する。一つの情報源だけで現行仕様を断定しない。
4. local HEADをremote `main`と同一視しない。開始時にremoteを取得し、remote default branchの最新Commit SHAを記録する。
5. 文書の欠落を推測で埋めない。根拠が足りない項目は `Incomplete`、対象外と根拠を確認できた項目は `Not applicable` とする。
6. 既存文書、ADR、Issue、Pull Requestへの参照とGit履歴を可能な限り保持する。単純な移動は `git mv` を使う。
7. 矛盾を黙って解消しない。未承認の提案・調査メモを現行要件や仕様へ昇格させない。
8. secret、token、password、秘密鍵、`.env` の値、private URL、個人情報、顧客情報、raw provider response、機密ログを読取結果や文書へ転載しない。発見した場合は内容を出力せず、パスと種類だけを安全に報告して停止条件を判断する。
9. この作業でプロダクトコード、依存関係、インフラ、repository settings、デプロイ設定の意味を変更しない。対象は文書構成、文書内容の整理、文書検証だけとする。
10. merge、deploy、Issue close、branch protection変更、secret登録は行わない。

## 正規の文書構成

最低限、次を対象リポジトリに用意する。

```text
AGENTS.md
docs/
├── README.md
├── product.md
├── requirements.md
├── architecture.md
├── security.md
├── specifications/
│   └── README.md
├── decisions/
│   ├── README.md
│   └── TEMPLATE.md
├── process/
│   ├── development.md
│   ├── documentation.md
│   └── release.md
├── operations/
│   └── README.md
└── guides/
    └── README.md
```

必要な場合だけ次を追加できる。

- `docs/designs/`: UI、画面、データ、APIなどの詳細設計
- `docs/research/`: 未承認の調査、比較、実験結果
- `docs/archive/`: 現行ではないが履歴として残す資料

新しいMarkdownファイル名は、小文字英数字のkebab-caseにする。既存のDecision Recordは、内容と追跡可能性を優先し、タイトルの `DR-0001`、`ADR-0001`、`ADR 0001` は無理に書き換えない。

## 各文書の責務

- `docs/product.md`: 解決する課題、利用者、提供価値、対象範囲、対象外、現在の状態
- `docs/requirements.md`: 機能要件、非機能要件、制約、検証可能な受け入れ条件
- `docs/specifications/`: UI、API、データ、外部連携、振る舞いなど実装が従う現行仕様
- `docs/architecture.md`: システム境界、構成要素、責務、依存、データフロー、配置
- `docs/security.md`: 保護対象、信頼境界、認証・認可、secret管理、脅威、残存リスク
- `docs/decisions/`: 技術選定だけでなく、要件変更、仕様変更、機能追加、リアーキテクチャ、運用変更の理由と選択肢
- `docs/process/`: Issueから実装、文書更新、レビュー、リリースまでの手順と完了条件
- `docs/operations/`: deploy、monitoring、backup、障害対応、rollback、保守
- `docs/guides/`: 利用者・管理者・開発者向けの操作手順

## GitHub共通テンプレートの扱い

`kohei321dev/.github` のIssue Form、Issue chooser、Pull Requestテンプレート、`CONTRIBUTING.md`、`SECURITY.md`、`SUPPORT.md`は、共通既定値として参照する。

- 各プロダクトへ `.github/ISSUE_TEMPLATE/` や共通Pull Requestテンプレートを複製しない。
- 対象リポジトリにローカル版がある場合は、意図的な上書きか、古い重複かを調査する。
- プロダクト固有の入力項目や運用が必要なら、理由を移行Issueに記載し、人間の承認を得るまで削除・置換しない。
- 共通既定値が適用される条件を満たすか確認し、確認できない場合はその事実を報告する。

## 値がない項目の書き方

単独の「該当なし」だけを記載してはならない。対象外である根拠を確認できた場合は、次の形式にする。

```markdown
- Status: Not applicable
- Reason: <なぜ現在のプロダクトには該当しないか>
- Revisit when: <どの条件になれば再検討するか。恒久的なら Never under current scope>
```

情報がないだけの場合は `Not applicable` ではなく、次の形式にする。

```markdown
- Status: Incomplete
- Missing evidence: <確認できていない情報>
- Required decision: <誰が何を決める必要があるか>
```

稼働中のプロダクトでは、原則として `product.md` と `requirements.md` 全体を `Not applicable` にしない。コードから推測した内容は「観測した実装」であると明示し、承認済み要件として扱わない。

## 全文書の棚卸し

追跡対象になっているファイルを中心に、少なくとも次を検索する。

- root、`docs/`、`.github/`、任意のサブディレクトリにあるMarkdown、MDX、text、HTML
- ADR、RFC、Decision、design、spec、requirements、roadmap、TODO、runbook、manual、guide、notes、research
- OpenAPI・AsyncAPI・GraphQL schemaなど、人間向け仕様の正規情報源になっているファイル
- README、CONTRIBUTING、SECURITY、SUPPORT、AGENTS、およびそれらの生成元
- 文書を参照するIssue・Pull Request・コード内リンク

無視対象、vendor、build output、dependency、binary、秘密情報は収集対象にしない。

各文書を次のいずれかに分類し、すべてを移行台帳へ記載する。

- `MOVE`: 一つの旧ファイルを内容を保って新しい場所へ移す
- `MERGE`: 複数の旧文書を一つの正規文書へ統合する
- `SPLIT`: 一つの旧文書を責務ごとに複数の正規文書へ分ける
- `KEEP`: 標準上も現在の場所が適切なため残す
- `ARCHIVE`: 現行仕様ではないため履歴領域へ移す
- `NOT_APPLICABLE`: 対象外である根拠と再検討条件を正規文書へ記す
- `CONFLICT_REQUIRES_DECISION`: 情報源が矛盾し、人間の判断が必要

削除予定の文書にも必ず移行先、統合先、または履歴を残す理由を割り当てる。対応先のない削除は禁止する。

## Decision Recordの移行

- ID、日付、Status、決定内容、背景、選択肢、結果、関連Issue・Pull Request、置換関係を保持する。
- 既存のADR番号を振り直さない。同じIDが衝突する場合は自動解決せず停止する。
- 既存タイトル形式は維持してよい。新規レコードだけ `DR-NNNN: Title` を使う。
- 追跡用metadataが不足している場合は、根拠を確認できる項目だけ補う。決定本文を書き換えない。
- 採用済みの判断を新しい文書で上書きしない。変更が必要なら新しいDecision Recordを提案し、旧記録を `Superseded` にする手順をIssueへ記載する。
- 日付順だけで現行性を決めず、Status、置換関係、実装、Issue・Pull Requestを照合する。

## AGENTS.mdの扱い

- 標準テンプレートの責務と対象リポジトリ固有のコマンド・制約を統合する。
- 既存 `AGENTS.md` が生成物なら直接編集せず、生成元を特定して更新する。
- 生成元が不明、または生成結果と手書き内容が衝突する場合は停止し、人間の判断を求める。
- `AGENTS.md` に、変更前に `docs/README.md` と関係文書を確認すること、変更後に文書影響を判定すること、必要な文書とDecision Recordを同じPull Requestで更新することを明記する。

## STAGE: PLAN

この段階は厳密にread-onlyで行う。ファイル、Issue、Pull Request、branch、repository settingsを作成・編集・削除しない。

### 調査手順

1. 対象repository、default branch、visibility、remote、remote default branchの最新SHAを確認する。
2. local branch、local HEAD、working treeの状態を確認し、remoteとの差分を分離する。
3. `AGENTS.md`、root README、文書生成元、検証コマンドを確認する。
4. remote default branchを基準に全文書を棚卸しする。
5. open/closed Issue、open/merged/closed Pull Request、Decision Recordを検索し、重複作業と未反映の変更を確認する。
6. 実装コードは、文書の真偽と欠落を確認するためだけに読む。コードから要件を捏造しない。
7. 標準テンプレートとの差分と、GitHub共通テンプレートに対するローカル上書きを確認する。
8. 文書間・文書と実装間の矛盾、秘密情報、生成物、壊れた内部リンク、重複IDを洗い出す。
9. 最小でレビュー可能な移行単位を決める。原則として一つの文書移行Issueと一つの文書Pull Requestにまとめるが、意味上独立した大規模な競合がある場合は分割案を示す。

### 出力形式

次の順で日本語で報告する。

1. `Result`: 次のいずれか一つ
   - `AWAITING_MIGRATION_APPROVAL`
   - `REPLAN_REQUIRED`
   - `DUPLICATE`
   - `BLOCKED_REMOTE_UNVERIFIED`
   - `BLOCKED_REFERENCE_UNAVAILABLE`
2. 基準情報
   - 対象repository
   - remote default branchと確認したCommit SHA
   - local branch、local HEAD、working tree
   - 参照テンプレートのCommit SHA
3. 現状要約
4. 全文書移行台帳（省略禁止）

   | Current path | Classification | Destination | Current role/status | Evidence | Planned action |
   | --- | --- | --- | --- | --- | --- |

5. GitHub共通テンプレートとの差分とローカル上書きの扱い
6. Decision Record一覧と、番号・Status・置換関係の問題
7. 矛盾、未確定事項、秘密情報リスク、停止条件
8. 変更予定ファイル一覧
9. 文書ごとの移行方針
10. 検証計画
11. rollback方針
12. 推奨するIssue本文。次を含める。
    - 背景
    - 目的
    - 対象範囲
    - 対象外
    - 移行台帳へのリンクまたは表
    - 受け入れ条件
    - 検証方法
    - 文書影響
    - Decision Record要否
    - 実装開始条件
13. 人間に必要な判断。ない場合は `None`

`AWAITING_MIGRATION_APPROVAL` でも実装を開始しない。人間が移行台帳とIssue範囲を確認し、Issue番号と明示的な承認を与えるまで停止する。

## STAGE: IMPLEMENT

次の全条件を満たす場合だけ開始する。

- `ISSUE_NUMBER` に、人間が選択した対象リポジトリのIssue番号がある
- `HUMAN_APPROVAL: approved` が明記されている
- Issue本文に範囲、移行台帳、受け入れ条件、検証方法、実装開始条件がある
- remote default branchの最新状態で重複Issue・Pull Requestと競合がない
- 対象範囲に重なる未commitのlocal変更がない

満たさない場合は編集せず、不足条件を報告して停止する。

### 実施手順

1. remote default branchを再取得し、PLAN時点からの変更、関連Issue・Pull Request、Decision Recordを再確認する。
2. Issueの範囲と現状がずれていれば `REPLAN_REQUIRED` として停止する。
3. remote default branchの最新Commitから専用branchまたは安全なworktreeを作る。
4. 標準テンプレートを参照し、対象プロダクトの既存情報だけで正規文書を作成・更新する。
5. 単純移動は `git mv`、統合・分割は移行台帳どおりに行い、必要な旧パス参照と内部リンクを更新する。
6. `docs/README.md` を文書の入口にし、各文書の目的、Status、更新契機、関連Decision Recordへたどれるようにする。
7. root READMEから `docs/README.md` への導線を追加する。
8. `docs/process/documentation.md` に、すべてのIssue・Pull Requestで文書影響を確認し、必要な文書とDecision Recordを同じPull Requestで更新する規則を記載する。
9. 標準の `scripts/validate-docs.ps1` と `.github/workflows/docs-check.yml` を対象repositoryへ適合させる。既存CIを壊さず、同等検証が既にある場合は重複させない。
10. プロダクトコードを変更せず、文書だけの小さな日本語commitにまとめる。
11. 文書構造検証、内部リンク確認、対象リポジトリ既定の軽量検証、`git diff --check`を実行する。
12. Issue一件に対してPull Request一件を作成し、Issueをリンクする。

### Pull Request本文に必ず含めるもの

- 基準にしたremote default branchのCommit SHA
- 参照テンプレート二件とCommit SHA
- Issue番号
- 移行概要
- 旧パスから新パスへの移行台帳
- `Not applicable` と `Incomplete` の一覧と根拠
- 保持したDecision Recordと追跡情報
- 意図的に残したローカルGitHubテンプレートと理由
- 実行した検証と結果
- 未解決事項
- rollback方法
- `Closes #<ISSUE_NUMBER>`

### 完了時の出力形式

1. `Result`: `PR_REVIEW`、`REPLAN_REQUIRED`、`BLOCKED` のいずれか
2. Issue URL
3. branch名
4. Commit SHA一覧
5. Pull Request URL
6. 変更ファイルと移行要約
7. 検証結果
8. 未解決事項
9. 人間が次に確認する項目

Pull Request作成後は停止し、mergeやdeployを行わない。

## 即時停止条件

次のいずれかに該当したら、安全に取得できた事実だけを報告して編集を停止する。

- remote default branchまたは固定参照Commitを確認できない
- 対象範囲に重なる未commit変更がある
- 同じ移行を行うopen Pull Request、または内容が重複するIssueがある
- 文書移動だけでは済まず、プロダクトの意味・要件・仕様を変更する必要がある
- 承認済み情報源どうしに未解決の矛盾がある
- Decision Record IDが衝突している
- `AGENTS.md` などの生成元を特定できない
- 秘密情報を安全に除外できない
- Issueの範囲を超える変更が必要
````

## Input examples

### SayDeck

```text
- STAGE: PLAN
- TARGET_REPOSITORY: kohei321dev/saydeck
- TARGET_SERVICE: SayDeck
- DEFAULT_BRANCH: main
- ISSUE_NUMBER:
- HUMAN_APPROVAL: none
```

### SpotDiggz

```text
- STAGE: PLAN
- TARGET_REPOSITORY: kohei321dev/spot-diggz
- TARGET_SERVICE: SpotDiggz
- DEFAULT_BRANCH: main
- ISSUE_NUMBER:
- HUMAN_APPROVAL: none
```

### 321dev-blog

```text
- STAGE: PLAN
- TARGET_REPOSITORY: kohei321dev/321dev-blog
- TARGET_SERVICE: 321DevBlog
- DEFAULT_BRANCH: main
- ISSUE_NUMBER:
- HUMAN_APPROVAL: none
```

PLANの報告を確認してIssueを承認した後、同じプロンプトの入力を次のように変更して再実行します。

```text
- STAGE: IMPLEMENT
- ISSUE_NUMBER: <approved issue number>
- HUMAN_APPROVAL: approved
```
