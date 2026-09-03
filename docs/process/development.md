# Development Process

- Status: Current

## Principles

- 1 Issueは1つの独立して検証可能な成果とする。
- 1 Pull Requestは原則として1 Issueだけを扱う。
- 人間の明示承認なしにIssue化、実装、merge、deployへ進まない。
- `main`を現在の正本とし、作業branchや古いlocal HEADと区別する。

## Phases

```text
相談・アイデア
  -> Review（read-only）
  -> 人間がIssue化を判断
  -> Plan（Issueと必要な文書計画）
  -> 人間が対象Issueを選択
  -> Assess（read-onlyの実装前評価）
  -> 人間が実装開始を承認
  -> Implement（1 Issue / 1 Pull Request）
  -> 人間がreview・merge
  -> Release
```

## Review

- Product、現在文書、コード、Issue、Pull Request、Decision Recordとの整合と重複を確認する。
- 採用、修正、見送りを人間が選べる材料を返す。

## Plan

- 検証可能な最小Issueへ分ける。
- 恒久契約が変わる場合は、実装前に現在文書とDecision Recordを更新する文書計画を用意する。

## Assess

- Issueの目的、対象、対象外、完了条件、依存、文書、検証方法が実装可能な状態か確認する。
- 未承認の要求・仕様・設計変更、重複、証拠不足があれば実装しない。

## Implement

- 承認済みIssueの範囲だけを変更する。
- コードと同時に影響する仕様、操作、運用文書を確認する。
- 検証結果をPull Requestへ記録し、自動mergeしない。
