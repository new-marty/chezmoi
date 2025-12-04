# 完璧な chezmoi 移行タスク一覧

## 🔴 必須タスク（移行を完了するために必要）

### 1. パス参照の修正

chezmoi で管理されているファイル内に、まだ `~/dotfiles` への参照が残っています。

- [ ] **`dot_zsh/commands.zsh`** (34 行目)

  - `~/dotfiles/Brewfile` → `$(chezmoi source-path)/Brewfile` に変更
  - `brew bundle dump` コマンドのパスを修正
  - chezmoi のテンプレート機能を使って `{{ .chezmoi.sourceDir }}/Brewfile` に変更

- [ ] **`dot_zshenv.tmpl`** (21 行目)

  - `export BAT_CONFIG_PATH="$HOME/dotfiles/bat/bat.conf"` → 削除または修正
  - `bat.conf` ファイルが存在しないため、この設定を削除するか、bat 設定を chezmoi に追加
  - または `{{ .chezmoi.sourceDir }}/private_dot_config/bat/bat.conf` に変更（bat.conf を作成する場合）

- [ ] **`dot_zsh/alias.zsh`** (help 関数内、153-154 行目)

  - `~/dotfiles/README.md` への参照を修正
  - `chezmoi cd` コマンドを使うか、GitHub リポジトリ URL に変更
  - または `~/.local/share/chezmoi/README.md` に変更

- [ ] **`dot_zsh/suggestions.zsh`** (32 行目)

  - `cd ~/dotfiles` → `chezmoi cd` に変更（chezmoi コマンドを使う）
  - または `cd ~/.local/share/chezmoi` に変更

- [ ] **`private_dot_config/sheldon/plugins.toml`** (4 行目)

  - `local = "~/dotfiles/.zsh"` → `local = "~/.zsh"` に変更
  - chezmoi で管理されているパスに修正

- [ ] **`dot_zsh/steeef-poimandres.md`** (74, 78 行目)

  - プロンプト例のパス表示 `~/dotfiles` → `~/.local/share/chezmoi` または `chezmoi cd` に更新
  - または、ドキュメント内の例なのでそのままでも可

- [ ] **`private_dot_config/navi/cheats/cheats.cheat`** (206, 209, 212, 215 行目)
  - `~/.dotfiles/` への参照を `~/.local/share/chezmoi/` または適切なパスに修正

### 2. 未移行のファイルの追加

以下のファイル/ディレクトリはまだ chezmoi で管理されていません。

- [ ] **VSCode 設定**

  - `~/dotfiles/vscode/vscode.css` → `private_dot_config/vscode/vscode.css` として追加
  - `~/dotfiles/vscode/vscode.js` → `private_dot_config/vscode/vscode.js` として追加
  - `~/dotfiles/.vscode/settings.json` → `private_dot_config/vscode/settings.json` として追加（**漏れていた！**）
  - 配置先: VSCode の設定ディレクトリは `~/Library/Application Support/Code/User/` (macOS)
  - 実際の配置先を確認してから適切な場所に配置
  - VSCode のカスタム CSS/JS は `~/.vscode/` または設定ディレクトリに配置する必要がある

- [ ] **Raycast スクリプト**

  - `~/dotfiles/raycast/toggle-ghostty.sh` → `private_dot_config/raycast/scripts/toggle-ghostty.sh` として追加
  - 配置先: `~/.config/raycast/scripts/` (macOS)
  - 実行権限を付与する必要がある場合は `run_` プレフィックスを使用

- [ ] **bat 設定ファイル**
  - `bat.conf` を作成して chezmoi で管理するか、設定削除するか決定
  - 作成する場合: `private_dot_config/bat/bat.conf` として追加
  - 削除する場合: `dot_zshenv.tmpl` から `BAT_CONFIG_PATH` の設定を削除

### 3. Git リポジトリへのコミット・プッシュ

chezmoi のリポジトリを GitHub にプッシュする必要があります。

- [ ] **`.gitignore` の作成・確認**

  - 機密情報を含むファイルがコミットされないように確認
  - `.secrets` は既にテンプレートとして管理されているが、確認が必要
  - `*.tmpl` ファイル内に機密情報が含まれていないか確認
  - `.chezmoiignore` ファイルの作成も検討

- [ ] **Git リポジトリの初期化（未初期化の場合）**

  ```bash
  cd ~/.local/share/chezmoi
  git init
  git branch -M main
  ```

- [ ] **初回コミット**

  ```bash
  cd ~/.local/share/chezmoi
  git add .
  git commit -m "Initial chezmoi migration from dotfiles"
  ```

- [ ] **GitHub リポジトリの作成**

  - GitHub で新しいリポジトリを作成（例: `chezmoi-dotfiles`）

- [ ] **リモートへのプッシュ**

  ```bash
  git remote add origin git@github.com:yumabuchi/chezmoi-dotfiles.git
  git push -u origin main
  ```

- [ ] **chezmoi のリモート設定**
  ```bash
  chezmoi git remote add origin git@github.com:yumabuchi/chezmoi-dotfiles.git
  ```

### 4. マルチマシン対応（個人 Mac／会社 Mac／Windows／Linux）

- [ ] **マシン識別データの作成**

  - `.chezmoidata.yaml` ファイルを作成
  - ホスト名、OS、マシンタイプなどのフラグを定義
  - 例:
    ```yaml
    hostname: "{{ .chezmoi.hostname }}"
    os: "{{ .chezmoi.os }}"
    is_work_mac: false # 手動で設定、またはホスト名から自動判定
    is_personal_mac: true
    is_windows: false
    is_linux: false
    ```
  - ホスト名や環境変数から自動判定するテンプレートロジックを検討

- [ ] **Brewfile のテンプレート化とマルチマシン対応**

  - `Brewfile` → `Brewfile.tmpl` に変換
  - 共通パッケージとマシン固有パッケージを分離
  - 構造例:

    ```brewfile
    # Common packages
    {{- range .brewfile.common }}
    brew "{{ . }}"
    {{- end }}

    # Personal Mac only
    {{- if .chezmoidata.is_personal_mac }}
    {{- range .brewfile.personal_mac }}
    brew "{{ . }}"
    {{- end }}
    {{- end }}

    # Work Mac only
    {{- if .chezmoidata.is_work_mac }}
    {{- range .brewfile.work_mac }}
    brew "{{ . }}"
    {{- end }}
    {{- end }}
    ```

  - または、`Brewfile.common`, `Brewfile.personal_mac`, `Brewfile.work_mac` に分割して `run_once_install_brew.sh.tmpl` で結合

- [ ] **brew ラッパーの修正（chezmoi 対応）**

  - `dot_zsh/commands.zsh` の `brew` 関数を修正
  - `chezmoi source-path` を使って Brewfile のパスを取得
  - 実装例:
    ```zsh
    brew() {
      command brew "$@"
      if [[ "$1" == "install" || "$1" == "upgrade" || "$1" == "uninstall" ]]; then
        local brewfile_path="$(chezmoi source-path)/Brewfile"
        echo "Updating Brewfile at $brewfile_path..."
        command brew bundle dump --force --file="$brewfile_path"
      fi
    }
    ```
  - テンプレートファイルの場合は、実際の Brewfile を生成してから更新する仕組みを検討

- [ ] **Windows/Linux のパッケージ管理対応**

  - Windows: `winget-export.json` または `choco-packages.txt` を作成
  - Linux(Ubuntu): `apt-packages.txt` を作成
  - `run_once_install_packages.sh.tmpl` で OS 判定して適切なパッケージマネージャーを実行
  - 例:
    ```bash
    {{- if eq .chezmoi.os "linux" }}
    # Install apt packages
    xargs -a apt-packages.txt sudo apt-get install -y
    {{- else if eq .chezmoi.os "windows" }}
    # Install winget packages
    winget import winget-export.json
    {{- end }}
    ```

- [ ] **設定ファイルの OS 分岐**

  - `dot_zprofile` や `dot_zshenv.tmpl` で OS 判定を追加
  - フォント、ターミナル設定、キーバインドなど OS ごとの差分をテンプレート化
  - 例: `{{ if eq .chezmoi.os "darwin" }}...{{ end }}`
  - キーチェーンや認証周りの差分も確認

- [ ] **1Password 連携**

  - `.secrets` の運用方針を 1Password に統一（`op inject` などの利用を検討）
  - `dot_secrets.tmpl` を 1Password から注入するように変更
  - chezmoi の暗号化は 1Password で代替するか併用するか決定
  - 機密情報をテンプレートに埋め込まないルールを明文化
  - `run_once_setup_secrets.sh.tmpl` で 1Password から secrets を取得するスクリプトを作成

- [ ] **初期セットアップ手順の整理**

  - `README.md` を作成・更新
  - 「新規マシンでの手順」を統一（chezmoi init → apply → brew/apt/winget 実行）
  - Brewfile テンプレートの選択手順と `brew` ラッパーの挙動を追記
  - セットアップスクリプト `run_once_setup.sh.tmpl` を作成（オプション）

- [ ] **漏れチェック（この Mac で完結）**
  - `rg "~/dotfiles"` / `rg "dotfiles"` で参照漏れがないか再確認
  - `chezmoi diff` / `chezmoi apply -n` で差分とテンプレート評価を確認
  - `brew bundle dump --file=$(chezmoi source-path)/Brewfile` を実行し `chezmoi diff` で整合性確認
  - 旧 `~/dotfiles` 配下に必要なスクリプト/設定が残っていないか目視
  - `.secrets` を 1Password から注入する手順を試し、README/TODO に反映

## 🟡 推奨タスク（移行をより良くするために）

### 5. 動作確認とテスト

- [ ] **chezmoi apply の動作確認（dry-run）**

  - `chezmoi apply --dry-run` でエラーがないか確認
  - 予期しない変更がないか確認
  - エラーが出た場合は修正して再確認

- [ ] **chezmoi apply の実際の適用**

  - `chezmoi apply` で実際に適用
  - すべてのファイルが正しく配置されるか確認
  - シンボリックリンクが残っていないか確認
  - エラーが出た場合は修正

- [ ] **シェルの動作確認**

  - シェルを再起動（`exec $SHELL -l` または新しいターミナルを開く）
  - `.zshrc` が正しく読み込まれるか確認
  - すべてのエイリアスと関数が動作するか確認
  - `help` コマンドが正しく動作するか確認
  - カスタムコマンド（`fcat`, `ts2mp4`, `mkcd`, `cdf` など）が動作するか確認

- [ ] **brew ラッパーの動作確認**

  - `brew install <package>` を実行して Brewfile が正しく更新されるか確認
  - `chezmoi source-path` が正しく動作するか確認
  - Brewfile のパスが正しいか確認（`$(chezmoi source-path)/Brewfile`）
  - `chezmoi diff` で Brewfile の変更が正しく検出されるか確認

- [ ] **設定ファイルの動作確認**

  - Ghostty 設定が正しく読み込まれるか確認
  - Sheldon プラグインが正しく読み込まれるか確認
  - navi の cheat sheets が正しく読み込まれるか確認
  - VSCode 設定が正しく適用されるか確認（移行後）

- [ ] **環境変数の確認**
  - `echo $BAT_CONFIG_PATH` で正しいパスが設定されているか確認（または削除されているか確認）
  - その他の環境変数が正しく設定されているか確認

### 6. ドキュメントの更新

- [ ] **README.md の更新**
  - 新しい chezmoi ベースのセットアップ手順を記載
  - 古い `setup.sh` の代わりに chezmoi を使う手順を記載

### 7. クリーンアップ

- [ ] **古いファイルの整理**
  - `~/dotfiles/setup.sh` - もう使わない可能性がある
  - `~/dotfiles/Makefile` - テスト用、必要か確認
  - `~/dotfiles/README.md`, `README-ja.md` - ドキュメント、必要に応じて chezmoi リポジトリに移動
- [ ] **移行ドキュメントの整理**

  - `MIGRATION.md` と `MIGRATION_PLAN.md` は削除済み。必要なら簡易メモを README に統合

- [ ] **シンボリックリンクの確認**
  - すべてのシンボリックリンクが削除されているか確認
  - 残っている場合は削除

### 8. テンプレート機能の活用

- [ ] **環境ごとの差分管理**

  - ホスト名や OS ごとの設定をテンプレートで管理
  - 例: `{{ if eq .chezmoi.hostname "work-pc" }}`

- [ ] **.secrets のセキュアな管理**
  - 1Password などのパスワードマネージャーとの統合
  - または、chezmoi の暗号化機能を使用

### 9. 追加の設定ファイルと改善

- [ ] **chezmoi の自動コミット設定**

  - `~/.config/chezmoi/chezmoi.toml` を作成
  - 自動コミット・プッシュの設定を追加（オプション）

  ```toml
  [git]
      autoCommit = true
      autoPush = false  # セキュリティのため false 推奨
  ```

- [ ] **chezmoi のエイリアス追加**

  - `dot_zsh/alias.zsh` に chezmoi 用のエイリアスを追加
  - 例: `alias cm='chezmoi'`, `alias cma='chezmoi apply'`, `alias cmcd='chezmoi cd'`

- [ ] **chezmoi の補完設定**
  - zsh の補完ファイルを追加（chezmoi が提供している場合）

### 10. 追加の設定ファイル

- [ ] **bat 設定ファイル**

  - `bat.conf` を作成して chezmoi で管理
  - または、BAT_CONFIG_PATH の設定を削除

- [ ] **その他の設定ファイル**
  - 必要に応じて他の設定ファイルも chezmoi で管理

## 📝 チェックリスト

移行を完了するための最小限のタスク：

1. ✅ chezmoi のインストールと初期化
2. ✅ 既存のシンボリックリンクの削除
3. ✅ dotfiles ファイルの chezmoi への追加
4. ✅ 設定ディレクトリの chezmoi への追加
5. ✅ .secrets のテンプレート化
6. ✅ Brewfile の追加
7. ⚠️ **パス参照の修正** ← 未完了（最優先）
8. ⚠️ **brew ラッパーの修正** ← 未完了（chezmoi 対応）
9. ⚠️ **未移行ファイルの追加** ← 未完了
10. ⚠️ **Git リポジトリへのコミット・プッシュ** ← 未完了
11. ⚠️ **マルチマシン対応** ← 未完了（.chezmoidata.yaml, Brewfile.tmpl）
12. ✅ 動作確認（一部完了）
13. ✅ 移行ドキュメントの作成

## 🎯 優先順位

### フェーズ 1: 基本動作の確立（最優先）

1. **パス参照の修正** - 動作に影響するため最優先
2. **brew ラッパーの修正** - chezmoi source-path を使うように修正
3. **Git リポジトリへのコミット・プッシュ** - バックアップのため

### フェーズ 2: 完全性の確保（高優先度）

4. **未移行ファイルの追加** - VSCode 設定、Raycast スクリプトなど
5. **bat 設定の決定** - 作成するか削除するか

### フェーズ 3: マルチマシン対応（中優先度）

6. **マシン識別データの作成** - .chezmoidata.yaml
7. **Brewfile のテンプレート化** - マシンごとのパッケージ管理
8. **Windows/Linux 対応** - 他の OS での動作確認

### フェーズ 4: 改善と最適化（低優先度）

9. **ドキュメントの更新** - README.md の作成・更新
10. **クリーンアップ** - 古いファイルの整理
11. **自動化設定** - chezmoi の自動コミット設定など

## 📋 実装の詳細

### brew ラッパーの実装方針

現在の `brew` ラッパーは `~/dotfiles/Brewfile` を更新していますが、chezmoi 対応では：

1. **chezmoi source-path を使用**

   ```zsh
   brewfile_path="$(chezmoi source-path)/Brewfile"
   ```

2. **テンプレートファイルの場合の考慮**

   - `Brewfile.tmpl` の場合は、実際の `Brewfile` を生成してから更新
   - または、`brew bundle dump` の結果をテンプレートに反映する仕組みを検討

3. **マルチマシン対応**
   - マシンごとに異なる Brewfile を管理する場合の考慮

### マルチマシン対応の実装方針

1. **.chezmoidata.yaml の構造**

   ```yaml
   hostname: "{{ .chezmoi.hostname }}"
   os: "{{ .chezmoi.os }}"
   arch: "{{ .chezmoi.arch }}"
   is_work_mac: false
   is_personal_mac: true
   ```

2. **Brewfile の分割方法**

   - 方法 1: 単一の `Brewfile.tmpl` で条件分岐
   - 方法 2: `Brewfile.common`, `Brewfile.personal_mac`, `Brewfile.work_mac` に分割
   - 方法 3: `.chezmoidata.yaml` にパッケージリストを定義

3. **brew ラッパーの動作**
   - 現在のマシンタイプに応じた Brewfile を更新
   - または、共通 Brewfile のみ更新し、マシン固有は手動管理

## 🔧 実装例

### brew ラッパーの実装例（chezmoi 対応版）

```zsh
# dot_zsh/commands.zsh に追加・修正
brew() {
    # Run the original brew command
    command brew "$@"

    # If the command was an install or upgrade, update the Brewfile
    if [[ "$1" == "install" || "$1" == "upgrade" || "$1" == "uninstall" ]]; then
        local source_dir
        if command -v chezmoi >/dev/null 2>&1; then
            source_dir=$(chezmoi source-path)
        else
            source_dir="$HOME/.local/share/chezmoi"
        fi

        local brewfile_path="$source_dir/Brewfile"

        # If Brewfile.tmpl exists, use the actual Brewfile location
        if [[ -f "$source_dir/Brewfile.tmpl" ]]; then
            # For template files, we might want to update the actual Brewfile
            # or handle it differently based on your setup
            brewfile_path="$source_dir/Brewfile"
        fi

        echo "Updating Brewfile at $brewfile_path..."
        command brew bundle dump --force --file="$brewfile_path"

        # Optionally: show chezmoi diff
        if command -v chezmoi >/dev/null 2>&1; then
            echo "Run 'chezmoi diff' to see changes"
        fi
    fi
}
```

### .chezmoidata.yaml の実装例

```yaml
# .chezmoidata.yaml
hostname: "{{ .chezmoi.hostname }}"
os: "{{ .chezmoi.os }}"
arch: "{{ .chezmoi.arch }}"

# マシンタイプの判定（ホスト名ベース、または手動設定）
is_work_mac: {{ if contains .chezmoi.hostname "work" }}true{{ else }}false{{ end }}
is_personal_mac: {{ if not (contains .chezmoi.hostname "work") }}true{{ else }}false{{ end }}
is_windows: {{ if eq .chezmoi.os "windows" }}true{{ else }}false{{ end }}
is_linux: {{ if eq .chezmoi.os "linux" }}true{{ else }}false{{ end }}

# パッケージリスト（オプション）
brewfile:
  common:
    - "git"
    - "zsh"
    - "fzf"
  personal_mac:
    - "spotify"
    - "discord"
  work_mac:
    - "slack"
    - "microsoft-teams"
```

### Brewfile.tmpl の実装例

```brewfile
# Brewfile.tmpl
# Common packages for all machines
{{- range .brewfile.common }}
brew "{{ . }}"
{{- end }}

# Personal Mac only
{{- if .chezmoidata.is_personal_mac }}
{{- range .brewfile.personal_mac }}
brew "{{ . }}"
{{- end }}
{{- end }}

# Work Mac only
{{- if .chezmoidata.is_work_mac }}
{{- range .brewfile.work_mac }}
brew "{{ . }}"
{{- end }}
{{- end }}

# Or use direct conditionals
{{- if eq .chezmoi.os "darwin" }}
tap "homebrew/cask"
cask "1password"
{{- end }}
```

## 📚 参考リソース

- [chezmoi 公式ドキュメント](https://www.chezmoi.io/)
- [chezmoi テンプレート構文](https://www.chezmoi.io/user-guide/templating/)
- [Wantedly 記事](https://en-jp.wantedly.com/companies/wantedly/post_articles/990055)
- [Zenn 記事](https://zenn.dev/ryo_kawamata/articles/introduce-chezmoi)

## ✅ 完了チェックリスト

移行が完了したら、以下を確認：

### 基本動作確認

- [ ] すべての `~/dotfiles` 参照が削除または修正されている
- [ ] `brew` コマンドが正しく Brewfile を更新する
- [ ] `chezmoi apply` でエラーが出ない
- [ ] `chezmoi diff` で予期しない差分がない
- [ ] `chezmoi verify` でエラーが出ない（設定されている場合）

### ファイル移行確認

- [ ] すべての設定ファイルが chezmoi で管理されている
  - [ ] `.zshrc`, `.zshenv`, `.zprofile` ✅
  - [ ] `.zsh/*` ディレクトリ ✅
  - [ ] `Brewfile` ✅
  - [ ] `.config/ghostty/*` ✅
  - [ ] `.config/sheldon/*` ✅
  - [ ] `.config/navi/*` ✅
  - [ ] `.vscode/settings.json` ⚠️ **漏れていた！追加必要**
  - [ ] `vscode.css`, `vscode.js` ⚠️
  - [ ] `raycast/scripts/toggle-ghostty.sh` ⚠️
  - [ ] `.secrets` (テンプレート化済み) ✅

### 動作確認

- [ ] シェルが正しく起動する
- [ ] すべてのエイリアスと関数が動作する
- [ ] `brew` ラッパーが正しく動作する
- [ ] Ghostty 設定が正しく読み込まれる
- [ ] Sheldon プラグインが正しく読み込まれる
- [ ] VSCode 設定が正しく適用される（移行後）

### 環境再現確認

- [ ] 新しいマシンで `chezmoi init` → `chezmoi apply` で環境が再現できる
- [ ] `brew bundle install` でパッケージがインストールされる
- [ ] すべての設定ファイルが正しい場所に配置される

### Git とバックアップ

- [ ] Git リポジトリにプッシュされている
- [ ] `.gitignore` が適切に設定されている
- [ ] 機密情報がコミットされていない

### ドキュメント

- [ ] README.md にセットアップ手順が記載されている
- [ ] 各マシンでの初期セットアップ手順が明確

## 🔍 最終確認: 漏れチェックと動作確認

移行完了前に以下を実行して漏れがないか確認：

### ステップ 1: ファイル漏れチェック

- [ ] **dotfiles ディレクトリに残っている重要なファイルがないか確認**

  ```bash
  cd ~/dotfiles
  find . -type f -not -path "*/\.git/*" -not -name ".DS_Store" -not -name "*.md" -not -name "Makefile" -not -name "setup.sh"
  ```

  - 重要なファイルが残っていないか確認
  - 残っている場合は chezmoi に追加

- [ ] **chezmoi で管理されていない設定ファイルがないか確認**

  ```bash
  chezmoi managed
  ```

  - ホームディレクトリの設定ファイルが chezmoi で管理されているか確認

- [ ] **すべての dotfiles 参照が修正されているか確認**

  ```bash
  rg -i "dotfiles|~/dotfiles|\$HOME/dotfiles" ~/.local/share/chezmoi
  ```

  - 参照が残っている場合は修正

- [ ] **実際のホームディレクトリにシンボリックリンクが残っていないか確認**
  ```bash
  ls -la ~ | grep "^l"
  ```
  - シンボリックリンクが残っている場合は削除

### ステップ 2: chezmoi apply の動作確認

- [ ] **dry-run でエラーがないか確認**

  ```bash
  chezmoi apply --dry-run
  ```

  - エラーが出た場合は修正
  - 予期しない変更がないか確認

- [ ] **実際に apply して動作確認**
  ```bash
  chezmoi apply
  ```
  - エラーが出た場合は修正
  - すべてのファイルが正しく配置されるか確認

### ステップ 3: シェルとコマンドの動作確認

- [ ] **シェルを再起動して動作確認**

  ```bash
  exec $SHELL -l
  # または新しいターミナルを開く
  ```

  - `.zshrc` が正しく読み込まれるか確認
  - エラーが出ないか確認

- [ ] **すべてのエイリアスと関数が動作するか確認**

  ```bash
  help          # helpコマンドが動作するか
  fcat --help   # fcatコマンドが動作するか
  ts2mp4 --help # ts2mp4コマンドが動作するか
  mkcd test     # mkcdコマンドが動作するか
  ```

  - 各コマンドが正しく動作するか確認

- [ ] **brew ラッパーが正しく動作するか確認**
  ```bash
  brew install --cask test-package  # テスト用のパッケージをインストール
  # Brewfileが更新されるか確認
  chezmoi diff
  # 正しく更新されていれば、Brewfileの変更が表示される
  ```
  - Brewfile が正しいパスに更新されるか確認
  - `chezmoi source-path` が正しく動作するか確認

### ステップ 4: 設定ファイルの動作確認

- [ ] **Ghostty 設定が正しく読み込まれるか確認**

  - Ghostty を起動して設定が適用されているか確認

- [ ] **Sheldon プラグインが正しく読み込まれるか確認**

  ```bash
  sheldon source
  ```

  - エラーが出ないか確認

- [ ] **navi の cheat sheets が正しく読み込まれるか確認**

  ```bash
  navi
  ```

  - cheat sheets が表示されるか確認

- [ ] **VSCode 設定が正しく適用されるか確認（移行後）**
  - VSCode を起動して設定が適用されているか確認

### ステップ 5: 環境変数の確認

- [ ] **環境変数が正しく設定されているか確認**
  ```bash
  echo $BAT_CONFIG_PATH  # 正しいパスが設定されているか、または削除されているか
  echo $PATH             # PATHが正しく設定されているか
  ```
  - 各環境変数が正しく設定されているか確認

## ⚠️ 重要な注意事項

### 漏れていたファイル

1. **`.vscode/settings.json`** - dotfiles にあったが、chezmoi に移行されていなかった
   - 追加先: `private_dot_config/vscode/settings.json`
   - 配置先: `~/Library/Application Support/Code/User/settings.json` (macOS)

### この TODO を完了すれば移行は完了するか？

**はい、この TODO を完了すれば個人 Mac での chezmoi 移行は完了します。ただし、以下の点に注意：**

1. **VSCode 設定ファイルの追加** - `.vscode/settings.json` が漏れていたので追加が必要
2. **実際の動作確認は必須** - TODO のタスクを完了した後、必ず「🔍 最終確認: 漏れチェックと動作確認」セクションの手順を実行してください
3. **他のマシンでの確認** - 個人 Mac で動作確認後、他のマシンでも必要に応じて確認
4. **環境変数の確認** - 現在の環境で設定されている環境変数で、chezmoi で管理されていないものがないか確認

### 移行完了の定義

以下のすべてが完了したら、移行完了とみなします：

1. ✅ すべての TODO タスクが完了している
2. ✅ 「🔍 最終確認: 漏れチェックと動作確認」のすべてのステップが完了している
3. ✅ `chezmoi apply` でエラーが出ない
4. ✅ シェルが正しく起動し、すべてのコマンドが動作する
5. ✅ `brew` ラッパーが正しく Brewfile を更新する
6. ✅ すべての設定ファイルが正しく読み込まれる

### 確実に漏れがないようにするための追加チェック

TODO を完了した後、以下を実行：

```bash
# 1. dotfilesディレクトリの全ファイルリストとchezmoiの全ファイルリストを比較
diff <(cd ~/dotfiles && find . -type f -not -path "*/\.git/*" | sort) \
     <(cd ~/.local/share/chezmoi && find . -type f -not -path "*/\.git/*" -not -name "*.md" | sort)

# 2. 実際のホームディレクトリの設定ファイルがchezmoiで管理されているか確認
chezmoi managed | grep -E "\.(zshrc|zshenv|zprofile|secrets)"

# 3. すべてのパス参照が正しいか確認
chezmoi execute-template '{{ .chezmoi.sourceDir }}'
```
