# PROJECT_NAME

このリポジトリは、`kohei321dev/product-repository-template`から作成するプロダクトリポジトリのひな形です。

## 初期設定

新しいリポジトリを作成したら、最初の文書Pull Requestで次を行います。

1. `PROJECT_NAME`を正式なサービス名へ置き換える。
2. `docs/product.md`で利用者、課題、価値、対象、非対象を定義する。
3. `docs/requirements.md`で検証可能な機能要件・非機能要件を定義する。
4. `docs/architecture.md`と`docs/security.md`へ初期境界を記載する。
5. 使用する技術、package manager、test、build、deploy手順をこのREADMEへ追加する。
6. License、repository visibility、branch rules、secret、deployment設定を個別に確認する。

GitHubのTemplate repositoryはファイルをコピーしますが、`PROJECT_NAME`などの文字列を自動置換しません。

## Documentation

最初に[`docs/README.md`](docs/README.md)を読み、変更に関係する現在文書とDecision Recordを確認してください。

## Development

<!-- package manager、install、local run、test、buildコマンドを記載する -->

## Documentation validation

Windows PowerShell:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-docs.ps1
```

PowerShell 7:

```powershell
pwsh ./scripts/validate-docs.ps1
```

## Security

secret、token、password、接続文字列、private URL、個人情報、raw provider response、raw logをGitへ保存しません。

## Repository defaults

`kohei321dev`配下では、Issue Form、Pull Requestテンプレート、Contribution、Security、Support方針をPublicリポジトリ`kohei321dev/.github`から継承します。リポジトリ固有の例外が必要な場合だけ、ローカルの`.github/ISSUE_TEMPLATE/`またはPull Requestテンプレートを追加します。
