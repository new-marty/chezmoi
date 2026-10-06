# Git

共有の git 設定は `~/.config/git/config` にある。名前、メールアドレス、署名は `~/.gitconfig` に書く。git はこちらを後に読むので、こちらの値が優先される（[導入と設定の詳細](setup.md#git-の-gitconfig-は自分のもの)を参照）。git 用のシェルのエイリアスは[エイリアス](aliases.md#git)にある。

## 共有の設定で変わる動作

| 設定                                     | 効果                                                         |
| ---------------------------------------- | ------------------------------------------------------------ |
| `init.defaultBranch = main`              | 新しいリポジトリは `main` から始まる                         |
| `pull.rebase = true`                     | `git pull` はマージではなくリベースする                      |
| `rebase.autoStash = true`                | コミットしていない変更は、リベースの前に退避され後で戻る     |
| `push.default = current`、`push.autoSetupRemote = true` | 新しいブランチで `git push` すると、同じ名前のブランチがリモートに作られる |
| `fetch.prune = true`                     | リモートで消えたブランチは、fetch のときに手元でも消える     |
| `commit.verbose = true`                  | コミットメッセージを書くエディタに差分が表示される           |
| `merge.conflictstyle = diff3`            | コンフリクトの表示に共通の祖先も含まれる                     |
| `core.excludesfile = ~/.gitignore_global` | 共通の無視リストがすべてのリポジトリに効く                  |
| `credential.helper = osxkeychain`        | HTTPS の認証情報は macOS のキーチェーンに保存される          |

`core.editor` は Cursor か VS Code で、chezmoi がファイルを書くときに決まる。[エディタの決まり方](setup.md#エディタの決まり方)を参照。

## git のエイリアス

| エイリアス    | 実行するもの                                              |
| ------------- | --------------------------------------------------------- |
| `git co`      | `checkout`                                                |
| `git ci`      | `commit`                                                  |
| `git st`      | `status -sb`                                              |
| `git br`      | `branch`                                                  |
| `git df`      | `diff`                                                    |
| `git lg`      | 1 コミット 1 行のグラフ付きログ                           |
| `git lga`     | 同じものを全ブランチについて                              |
| `git last`    | 最後のコミット                                            |
| `git unstage` | `reset HEAD --`                                           |
| `git amend`   | `commit --amend --no-edit`                                |
| `git undo`    | `reset --soft HEAD~1`（最後のコミットを取り消し、変更は残す） |
| `git wip`     | `add -A` して `WIP` というメッセージでコミットする        |
| `git please`  | `push --force-with-lease`                                 |
| `git cleanup` | 今のブランチにマージ済みのローカルブランチを消す。今のブランチと、名前に `main`、`master`、`develop` を含むものは残す |
| `git aliases` | エイリアスの一覧                                          |

## delta

chezmoi が git の設定を書くときに [delta](https://dandavison.github.io/delta/) が入っていれば、git は `diff`、`log`、`show`、`reflog` のページャに delta を使う。左右に並べた表示と行番号つきで、`n` と `N` でファイル間を移動できる。一度だけ使わないときは `git --no-pager diff` とする。delta を後から入れたら、もう一度 `chezmoi apply` を実行する。

## lazygit

[lazygit](https://github.com/jesseduffield/lazygit) が入っていれば `lg` で開く。中のキーは `?` で確認できる。`tmux` スイッチを入れていれば、`Ctrl+b` のあと `g` で tmux のポップアップに開く。
