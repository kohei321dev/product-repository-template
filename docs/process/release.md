# Release Process

- Status: Draft

## Preconditions

- 対象IssueとPull Requestが一致している。
- 必須test、static check、buildが成功している。
- 要求、仕様、設計、security、操作・運用文書が実装と一致している。
- migration、rollback、data compatibilityを確認している。
- secret、runtime設定、外部service変更は承認済みの経路で実施する。

## Release

<!-- build artifact、Preview、承認、production昇格手順 -->

## Post-release verification

<!-- health、主要flow、metrics、log、data integrityの確認 -->

## Rollback

<!-- rollback条件、対象artifact、dataの扱い、確認手順 -->

## Record

release commit、artifact versionまたはdigest、実施時刻、確認結果、未解決事項を、secretを含めず記録します。
