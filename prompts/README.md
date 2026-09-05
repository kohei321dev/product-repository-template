# 既存リポジトリの文書移行手順

このREADMEは、既存のプロダクトリポジトリに散在する文書を、`kohei321dev/product-repository-template`の標準構成へ移す人間向け手順です。

AIエージェントへ渡す指示本文は、[`repository-docs-migration.md`](repository-docs-migration.md)にあります。

## リポジトリごとの責務

| Repository                                | Responsibility                                                                                   |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------ |
| `kohei321dev/.github`                     | Issue Form、Issue chooser、Pull Requestテンプレート、CONTRIBUTING、SECURITY、SUPPORTの共通既定値 |
| `kohei321dev/product-repository-template` | `docs/`の標準構成、Decision Record、文書更新プロセス、検証、既存リポジトリの移行手順             |

文書移行の手順とAI向けプロンプトは、文書構成の基準を持つ`product-repository-template`で管理します。`.github`へ同じ内容を複製しません。

## 移行の原則

- 既存リポジトリを作り直さず、現在のremote default branchから文書だけのPull Requestとして移行する。
- GitHubの`Use this template`で既存リポジトリを置き換えない。
- テンプレートの例文をプロダクトの事実としてコピーしない。
- すべての既存文書に移行先、統合先、保存先、または残す理由を割り当てる。
- 要件、仕様、設計、Decision Recordに矛盾がある場合は、AIに推測させず人間が判断する。
- `PLAN`と`IMPLEMENT`を分け、Issue番号と人間の明示承認がそろうまでファイルを変更しない。
- Pull Requestのmergeとdeployは人間が行う。

## 全体の流れ

```text
対象リポジトリでPLANを実行
        ↓
全文書の移行台帳とIssue案を確認
        ↓
対象リポジトリにIssueを作成して人間が承認
        ↓
同じプロンプトをIMPLEMENTで再実行
        ↓
文書移行Pull Requestを人間がレビュー
        ↓
問題がなければ人間がmerge
```

## 1. 対象リポジトリを確認する

GitHub上の正確な`owner/repository`、default branch、対象サービス名を確認します。表示名とrepository slugを混同しないでください。

SpotDiggzの場合は次の値です。

```text
Repository: kohei321dev/spot-diggz
Service: SpotDiggz
Default branch: main
```

## 2. 対象リポジトリでAIエージェントを起動する

CodexなどのAIエージェントに、対象リポジトリのrootをworkspaceとして開かせます。

ローカルcloneを使う場合は、移行対象と重なる未commit変更がないことを確認します。未commit変更がある場合は、内容を消したり退避したりせず、AIエージェントを停止させて人間が扱いを決めます。

## 3. PLANを実行する

[`repository-docs-migration.md`](repository-docs-migration.md)の`## Custom prompt`直下にあるコードブロック全体をコピーして、対象リポジトリのAIエージェントへ渡します。

SpotDiggzの最初の入力は次のとおりです。

```text
- STAGE: PLAN
- TARGET_REPOSITORY: kohei321dev/spot-diggz
- TARGET_SERVICE: SpotDiggz
- DEFAULT_BRANCH: main
- ISSUE_NUMBER:
- HUMAN_APPROVAL: none
```

`PLAN`はread-onlyです。この段階ではファイル、branch、Issue、Pull Request、repository settingsを変更しません。

AIエージェントはremote `main`、既存文書、Decision Record、Issue、Pull Request、実装との関係を調べ、少なくとも次を報告します。

- 現在の基準Commit SHA
- 既存文書の全件一覧
- 旧パスから新パスへの移行台帳
- `MOVE`、`MERGE`、`SPLIT`、`KEEP`、`ARCHIVE`などの分類
- 文書間、または文書と実装の矛盾
- `Not applicable`と`Incomplete`の候補と根拠
- 変更予定ファイルと検証計画
- 対象リポジトリへ登録するIssue本文案

## 4. PLAN結果を判定する

| Result                          | Human action                                                          |
| ------------------------------- | --------------------------------------------------------------------- |
| `AWAITING_MIGRATION_APPROVAL`   | 移行台帳とIssue案をレビューし、問題がなければIssueを作る              |
| `REPLAN_REQUIRED`               | 矛盾や範囲変更を人間が判断し、条件を更新してPLANをやり直す            |
| `DUPLICATE`                     | 既存IssueまたはPull Requestを確認し、新しい移行作業を重複して作らない |
| `BLOCKED_REMOTE_UNVERIFIED`     | GitHub接続、remote、default branchを確認してからPLANをやり直す        |
| `BLOCKED_REFERENCE_UNAVAILABLE` | 固定されたテンプレートCommitへアクセスできる状態にしてPLANをやり直す  |

`AWAITING_MIGRATION_APPROVAL`以外の結果で、`IMPLEMENT`へ進んではいけません。

## 5. 移行台帳をレビューする

Issueを作る前に、少なくとも次を確認します。

- 追跡対象の既存文書が一件ずつ台帳に載っている。
- 削除予定ファイルにも、移行先、統合先、または履歴として残す場所がある。
- プロダクトの事実がテンプレートやコードから推測で作られていない。
- 現行仕様と、未承認の提案・調査・過去資料が分離されている。
- ADR・Decision Recordの番号、日付、Status、本文、関連Issue・Pull Request、置換関係が維持される。
- `Not applicable`には理由と再検討条件がある。
- 情報不足は`Not applicable`ではなく`Incomplete`になっている。
- プロダクトコード、依存関係、インフラ、repository settingsが変更対象に入っていない。

判断できない項目があればIssue化を急がず、AIエージェントへ追加調査または`REPLAN_REQUIRED`としての再計画を依頼します。

## 6. 対象リポジトリにIssueを作成する

SpotDiggzのGitHub repositoryで`Issues`、`New issue`、共通の`変更提案`Issue Formを順に開きます。

PLANが生成したIssue本文案と移行台帳を転記し、次を確認します。

- 背景、目的、対象範囲、対象外が明確である。
- 受け入れ条件と検証方法がある。
- 変更予定文書とDecision Record要否がある。
- 実装開始条件に、人間の明示承認が必要と書かれている。

内容を承認する場合は、Issueへ次のコメントを残します。

```text
この移行台帳、対象範囲、受け入れ条件で文書移行の実装を承認します。
```

Issueを作っただけでは承認済みとみなしません。承認コメントを残した後、そのIssue番号を次の手順で指定します。

## 7. IMPLEMENTを実行する

同じ[`repository-docs-migration.md`](repository-docs-migration.md)のコードブロック全体を、対象リポジトリのAIエージェントへもう一度渡します。

入力を次のように変更します。`<approved issue number>`は実際のIssue番号へ置き換えます。

```text
- STAGE: IMPLEMENT
- TARGET_REPOSITORY: kohei321dev/spot-diggz
- TARGET_SERVICE: SpotDiggz
- DEFAULT_BRANCH: main
- ISSUE_NUMBER: <approved issue number>
- HUMAN_APPROVAL: approved
```

AIエージェントは、開始前にremote `main`とIssue・Pull Requestの状態を再確認します。PLAN後に前提が変わっていた場合は、編集せず`REPLAN_REQUIRED`として停止します。

前提が一致している場合だけ、専用branchで文書を移し、内部リンクと文書indexを更新し、検証を行い、一つのIssueに対応する一つのPull Requestを作ります。

## 8. Pull Requestをレビューする

正常にPull Requestまで作成された場合の結果は`PR_REVIEW`です。次を人間が確認します。

- Pull Requestが承認したIssueだけを扱っている。
- 移行台帳の全項目がPull Requestの差分と対応している。
- 単純移動でGit履歴が不必要に失われていない。
- ADR・Decision Recordの番号と内容が維持されている。
- `docs/README.md`から現在文書へ辿れる。
- root READMEから`docs/README.md`へ辿れる。
- 壊れた内部リンクがない。
- 文書構造検証、repository固有の検証、GitHub Actionsが成功している。
- `.github`の共通Issue FormやPull Requestテンプレートが理由なく複製されていない。
- プロダクトコード、secret、repository settingsが変更されていない。

問題がなければ人間がmergeします。AIエージェントに自動mergeやdeployをさせません。

## 9. merge後の運用へ切り替える

移行後は、すべてのIssueとPull Requestで文書影響を確認します。

- 現在の要求、仕様、設計、セキュリティ、運用、操作方法が変わる場合は`DOC_UPDATE_REQUIRED`とする。
- 文書変更が不要な場合は`NO_DOC_CHANGE`とし、その理由を記載する。
- 恒久的な判断変更は、必要なDecision Recordと現在文書を同じ変更系列で更新する。
- 実装Pull Requestのmerge前に、コードと関係文書が一致していることを再確認する。

詳細は[`docs/process/documentation.md`](../docs/process/documentation.md)を参照してください。

## 他のリポジトリへ適用する場合

同じ手順をSayDeckや321dev-blogへ適用できます。入力の`TARGET_REPOSITORY`と`TARGET_SERVICE`だけを正確な値へ変更し、必ずリポジトリごとにPLANから始めます。

複数リポジトリを一つのIssueやPull Requestで同時に移行しません。
