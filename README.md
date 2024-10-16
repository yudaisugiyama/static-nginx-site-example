# static-nginx-site-example

## ブランチ構成

### `main` ブランチ (本番環境)
- **用途**: リリース可能な安定版コードが含まれるブランチ。
- **デプロイ**: `main` ブランチに変更が加わると、本番環境（Cloud Run）に自動デプロイされます。
- **運用ルール**: 直接コミットは禁止されており、`develop` ブランチからのプルリクエストを経てマージされます。

### `develop` ブランチ (ステージング環境)
- **用途**: 開発中のコードを管理するブランチ。
- **デプロイ**: `develop` ブランチに変更が加わると、ステージング環境（Vercel）に自動デプロイされます。

## 開発の流れ

### 新機能の追加やバグ修正
1. `develop` ブランチから新しい機能用のブランチを作成します。
    ```zsh
    git checkout develop
    git pull origin develop
    git checkout -b feature/your-feature-name
    ```

2. 開発が完了したら、`develop` ブランチへのプルリクエストを作成します。

3. コードレビューを経て、問題がなければ `develop` ブランチにマージされます。

4. `develop` ブランチの安定版が確認された後、`main` ブランチにプルリクエストを作成して本番リリースを行います。

## SEO対策ドキュメント
より詳細なSEOガイドラインについては、Googleの公式ガイドを参照してください。  
[SEOスターターガイド](https://developers.google.com/search/docs/fundamentals/seo-starter-guide?hl=ja)
