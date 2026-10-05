# シェルコマンド

この dotfiles が zsh の関数として定義しているコマンド。定義は `~/.zsh/commands.zsh` と `~/.zsh/alias.zsh` にある。

## update-dev

開発ツールをまとめて更新する。各段階はそのツールが入っているときだけ動き、途中で 1 つ失敗しても残りは続ける。

```bash
update-dev            # すべての段階を実行する
update-dev --dry-run  # 実行せず、コマンドだけを表示する（-n でも同じ）
```

| 段階       | 実行するコマンド                                           |
| ---------- | ---------------------------------------------------------- |
| Homebrew   | `brew update`、`brew upgrade`、`brew cleanup`              |
| chezmoi    | `chezmoi update --apply`                                   |
| sheldon    | `sheldon lock --update` のあと、プラグインのキャッシュを消す |
| atuin      | `atuin sync`                                               |
| mise       | `mise self-update --yes`、`mise upgrade`                   |
| npm        | `npm update -g`                                            |
| tldr       | `tldr --update`                                            |

終わったら `rs` でシェルを再起動すると、新しい版が使われる。

## mkcd

ディレクトリを作り、そこへ移動する。

```bash
mkcd my-project
```

## cdf

今いる場所より下のディレクトリを fzf で一覧にし、選んだところへ移動する。fd と fzf が必要で、ホームディレクトリの中でしか動かない。

```bash
cdf
```

## fcat

指定したパスの下にあるファイルの中身を、ファイル名の見出しをつけてすべて表示する。複数のファイルをまとめてチャットや issue に貼るときに使う。

```bash
fcat src/                 # src/ の下のすべてのファイル
fcat -i src/              # .gitignore で無視されるファイルを除く
fcat -n '*.js' src/       # パターンに合うファイルだけ
fcat -c src/main.js       # 出力をクリップボードにコピーする
fcat -o out.txt lib/      # 出力をファイルに書く
```

| オプション                 | 効果                                               |
| -------------------------- | -------------------------------------------------- |
| `-i`, `--ignore-gitignore` | `.gitignore` で無視されるファイルを除く（既定ではすべて表示） |
| `-n`, `--name PATTERN`     | 名前がパターンに合うファイルだけ。`find -name` と同じ書き方 |
| `-o`, `--output FILE`      | 画面ではなく `FILE` に書く                         |
| `-c`, `--clipboard`        | クリップボードにコピーする（`pbcopy`）             |
| `-h`, `--help`             | ヘルプを表示する                                   |

## ts2mp4

今いるディレクトリの `.ts` 動画をすべて `.mp4` に変換する。ffmpeg で中身をそのままコピーするので、再エンコードはしない。ffmpeg が必要。変換先の `.mp4` がすでにあるファイルは、`-f` を付けない限り飛ばす。

```bash
ts2mp4                # ./mp4/ に書く
ts2mp4 -o converted   # ./converted/ に書く
ts2mp4 -f             # 既存の .mp4 を上書きする
```

## help、keys、docs

| コマンド | 動作                                                                   |
| -------- | ---------------------------------------------------------------------- |
| `help`   | 自作コマンド、エイリアス、キーバインドの一覧を表示する                 |
| `keys`   | キーバインドの一覧だけを表示する                                       |
| `docs`   | このドキュメントを `c` と同じエディタで開く。エディタがなければ Finder で開く |
