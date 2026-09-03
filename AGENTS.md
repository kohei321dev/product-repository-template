# Repository Instructions

## Required reading

計画、評価、実装の前に、次を順に確認する。

1. `README.md`
2. `docs/README.md`
3. `docs/product.md`
4. `docs/requirements.md`
5. 変更に関係する`docs/specifications/*`
6. `docs/architecture.md`と`docs/security.md`
7. 関連する`docs/decisions/*`
8. 変更種別に応じた`docs/process/*`、`docs/operations/*`、`docs/guides/*`

文書間で矛盾がある場合は推測で補完せず、矛盾と必要な判断を報告して停止する。

## Source of truth

- `docs/product.md`、`docs/requirements.md`、`docs/specifications/*`、`docs/architecture.md`、`docs/security.md`は現在の承認済み状態を表す。
- `docs/decisions/*`は判断理由と変更履歴を表し、単独では現在仕様を置き換えない。
- Issueは提案と完了条件、Pull Requestとcommitは変更証跡を表す。
- `docs/research/*`と`docs/archive/*`は現在の正本ではない。

## Change rules

- Issue、commit、Pull Requestのタイトルと本文は日本語にする。
- 1 Issueを1つの独立した成果へ分け、1 Pull Requestは原則として1 Issueだけを扱う。
- 実装前に既存Issue、Pull Request、Decision Recordとの重複を確認する。
- `main`へ直接変更せず、branchとPull Requestを使用する。
- 各変更を`DOC_UPDATE_REQUIRED`または`NO_DOC_CHANGE`へ分類し、後者には理由を記載する。
- Product、要求、外部仕様、責務境界、データ、セキュリティ、運用の恒久変更は、実装前に文書と必要なDecision Recordを承認可能な状態へする。
- 実装Pull Requestでは、コードだけでなく影響する仕様、操作、運用文書も再確認する。
- 自動merge、deploy、repository settings変更、secret変更は、人間が明示的に承認しない限り行わない。

## Safety

`.env*`、secret、token、password、接続文字列、private URL、個人情報、顧客情報、raw provider response、raw production logを読み取ったり出力したりしない。必要な証拠は秘匿化した最小限の要約として扱う。
