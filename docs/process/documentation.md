# Documentation Process

- Status: Current

## Change classification

すべてのIssueとPull Requestを次のいずれかへ分類します。

- `DOC_UPDATE_REQUIRED`: 現在の要求、仕様、設計、セキュリティ、運用、操作方法のいずれかが変わる
- `NO_DOC_CHANGE`: 現行文書の契約内のbug修正または実装不足。理由を記録する

Decision Recordの要否は別に`DR_REQUIRED`または`DR_NOT_REQUIRED`として判断します。

## Update matrix

| Change                                    | Required documents                                                     |
| ----------------------------------------- | ---------------------------------------------------------------------- |
| 利用者、課題、価値、scope、non-goal       | `product.md`、`requirements.md`、必要なDecision Record                 |
| 機能要件、非機能要件、release gate        | `requirements.md`、関連仕様、test、必要なDecision Record               |
| UI、API、schema、入出力、error            | `specifications/`、`requirements.md`、必要に応じてguides               |
| component、data、provider、deployment境界 | `architecture.md`、`security.md`、operations、Decision Record          |
| 認証、認可、secret、privacy、retention    | `security.md`、requirements、architecture、operations、Decision Record |
| deploy、monitor、incident、rollback       | `operations/`、release process、必要なDecision Record                  |
| 利用者・管理者の操作                      | `guides/`、関連仕様                                                    |
| Issue・Pull Request・承認フロー           | `process/`、必要なDecision Record                                      |

## Timing

1. Issueで文書影響を予測する。
2. 恒久契約変更は、必要に応じて文書だけの計画Pull Requestで先に承認する。
3. 実装Pull Requestで実際の差分と文書を再照合する。
4. merge前に要求、仕様、設計、実装、操作・運用手順の整合を確認する。
5. 実装によって採用が確定するDecision Recordは、実装Pull Requestで`Accepted`へ更新する。

## Prohibited patterns

- `latest`、`final`、`new`、`v2`を付けた現行文書の複製
- 同じ契約をREADME、AGENTS、Issue、複数docsへ重複記載すること
- raw chat logを判断記録の代わりに保存すること
- secretやprivate情報を証拠として文書へ貼ること
