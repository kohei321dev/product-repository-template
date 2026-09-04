# Decision Records

このディレクトリは、技術選定だけでなく、Product、Requirement、Specification、Architecture、Security、Process、Operationに関する恒久的な判断理由を管理します。

## When to write

次のいずれかに該当する場合はDecision Recordを作成します。

- 複数の妥当な選択肢とtrade-offがある
- 後から変更するcostが高い
- Product scope、要求、外部仕様、責務境界、data、security、公開範囲が変わる
- 外部service、課金、運用、migration、rollbackへ影響する
- 複数のIssue、component、releaseへ影響する

小さな文言修正、現行仕様内のbug修正、局所的なrefactoringには通常不要です。

## Naming and status

- File: `0001-short-title.md`
- Title: `DR-0001: Title`
- Status: `Proposed` / `Accepted` / `Superseded` / `Deprecated` / `Rejected`

新規記録には`DR-0001`を使用します。既存リポジトリから移行するArchitecture Decision Recordは、参照互換性を保つため`ADR-0001`または`ADR 0001`のタイトルを維持して構いません。ID、status、date、判断内容を変更せず、不足する追跡metadataだけを補います。

判断を上書きして履歴を消しません。責務や最終目標が変わる場合は新しいDecision Recordを作り、旧記録を`Superseded`にします。

## Index

| ID  | Status | Date | Type | Title | Issue | Pull Request | Superseded by |
| --- | ------ | ---- | ---- | ----- | ----- | ------------ | ------------- |

新規作成時は[`TEMPLATE.md`](TEMPLATE.md)を使用します。
