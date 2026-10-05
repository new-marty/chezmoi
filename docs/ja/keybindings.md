# キーバインド

この dotfiles が zsh に追加するキーバインドの一覧。どのキーも、表の「必要なもの」にあるツールが入っていないと役に立たない。ターミナルで `keys` と打つと、この表の短い版が出る。

| キー     | 動作                                                       | 必要なもの     |
| -------- | ---------------------------------------------------------- | -------------- |
| `Ctrl+G` | 決まったテンプレートの一覧からコマンドを選ぶ               | fzf            |
| `Ctrl+S` | 今いるディレクトリのプロジェクトに合わせた候補から選ぶ     | fzf            |
| `Ctrl+F` | よく使うコマンドの上位 20 件から選ぶ                       | fzf            |
| `Ctrl+N` | navi のチートシートからコマンドを選ぶ                      | navi           |
| `Ctrl+R` | 履歴を検索する                                             | peco           |
| `Ctrl+H` | ディレクトリやセッションで絞り込みながら履歴を検索する     | atuin          |
| `Ctrl+U` | 最近いたディレクトリに移動する                             | peco           |
| `Tab`    | fzf の一覧で補完する。ファイルやフォルダの中身も表示する   | sheldon、fzf   |

選んだコマンドは実行されず、コマンドラインに入るだけだ。Enter を押す前に手直しできる。

## Ctrl+G: コマンドテンプレート

git、docker、pnpm、chezmoi、システム系など、よく使うコマンドが 100 個ほど並ぶ。一覧は `~/.zsh/suggestions.zsh` の `show_command_templates` にある。自分のコマンドを足すときは `chezmoi edit ~/.zsh/suggestions.zsh` で編集する。

## Ctrl+S: プロジェクトに合わせた候補

今いるディレクトリのファイルを見て、合いそうなコマンドを出す。

| 見つかったファイル   | 候補                                        |
| -------------------- | ------------------------------------------- |
| `package.json`       | `pnpm install`、`pnpm run dev`、build、test |
| `Dockerfile`         | `docker build -t`、`docker run -p`          |
| `docker-compose.yml` | `docker-compose up -d`、down、logs          |
| `.git`               | `git status`、add、commit、push             |
| `Makefile`           | `make`、install、clean、test                |
| `requirements.txt`   | `pip3 install -r requirements.txt`、venv    |
| `go.mod`             | `go run .`、build、test、`go mod tidy`      |
| `Cargo.toml`         | `cargo run`、build、test、check             |

どれもなければ、`ls -la` などの汎用的なコマンドを出す。

## Ctrl+N: navi のチートシート

`~/.config/navi/cheats/cheats.cheat` のチートシート（git、pnpm、docker、brew、terraform、kubernetes など）を開く。このファイルは `navi` スイッチで入る。[導入と設定の詳細](setup.md#オプトインのスイッチ)を参照。

## Ctrl+R と Ctrl+H の違い

`Ctrl+R` は、このシェルの履歴をあいまい検索で絞り込むだけの単純なものだ。`Ctrl+H` は atuin を開く。今いるディレクトリやセッションで絞り込めるほか、マシン間で履歴を同期できる。上矢印キーは zsh の通常の動作のままで、atuin には割り当てていない。

## そのほかのキーバインド

tmux（`tmux` スイッチ）はプレフィックスに `Ctrl+\` を使い、独自のショートカットを持つ。tmux の中で `Opt+/` を押すと一覧が出る。lazygit や btm の中のキーは、それぞれ `?` で確認できる。
