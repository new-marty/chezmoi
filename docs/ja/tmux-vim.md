# tmux と Vim を覚える

目指すのは、素のキー（何も入っていないサーバーの tmux と vi で通じるキー）を使えるようになること。手に馴染むまでは、手元の Mac でヒントを出す。Vim は素のキーをすべてそのまま使う。tmux も、プラグインや Mac のクリップボードのためにキーが要るところを除けば素のまま。その例外には「Mac」の印を付けている（コピーモードの `v` と `y`、`C-b Space` の which-key（素では次のレイアウト）、`C-b C-r` の再読み込み）。

## 打っている間のヒント

| 場所 | 出るもの |
| ---- | -------- |
| tmux（`tmux` スイッチ） | ステータス行の2段目に、今の状態で使えるキーが出る。何も押していないとき、`C-b` の後、Mac だけのモード（`C-b P` `W` `S` `R`）、コピーモードで中身が変わる。 |
| Neovim（`nvim` スイッチ） | `d` `y` `c` `g` `z` `"` `Ctrl-w` などの後に、続けて押せるキーを which-key が並べる。precognition は `w` `b` `e` `^` `$` の行き先に印を付ける（`:Precognition toggle`）。`jjjj` のような打ち方には hardtime がよりよい動きを示す（`:Hardtime toggle`）。 |
| Vim（`vim` スイッチ） | 打ちかけのコマンドが右下に出る（`showcmd`）。 |
| VS Code / Cursor | VSCodeVim はステータスバーにモードを出すだけで、キーごとのヒントはない。チートシートを使う。 |

## チートシート

ソースディレクトリの `cheatsheet/index.html` は、画面でも紙でも同じ A4 のページになる。これは生成したもので、直すときは `cheatsheet/build.py` か `style.css` を編集して `python3 cheatsheet/build.py cheatsheet/index.html` を実行する。

- 開く: `Space`+`/`（Karabiner。英数入力のとき）、`just cheatsheet`、tmux の中なら `Opt+/` で短い文字版。`justfile` スイッチを選んでいないマシンでは `just --justfile "$(chezmoi source-path)/justfile" cheatsheet` と打つ。
- キーを並べるのではなく図で示す。Vim のモードの地図（ページ全体で色がモードを表す）、実際の1行とファイルの中での動き方、動詞と範囲の表、tmux の画面とその部分ごとのキー、変更前後のテキストを添えた実例集。点線の枠は Mac だけ。
- 印刷: `just cheatsheet-pdf` が Chrome で A4 横の6ページ（Vim のモード、Vim の動きと編集、tmux、実例集。設定の書き換えやログアウト後も続く作業など）を `~/Downloads/tmux-vim-cheatsheet.pdf` に書く。場所を変えるときは `just cheatsheet-pdf ~/Desktop/sheet.pdf` のように渡す。

1日に覚えるのは1〜2個にする（"Learn Vim Progressively"）。手帖は英語で書いてある。

## 使い始める

1. `vim` と `nvim`（と `tmux`）を opt-in して apply する。Neovim は最初の起動でプラグインを GitHub から入れる。ネットワークがなければプラグインなしで起動する。
2. VS Code / Cursor: VSCodeVim（`vscodevim.vim`）を入れる。VS Code には `just vscode-extensions` が `vscode/extensions.txt` のほかの拡張と一緒に入れる。Cursor には `cursor --install-extension vscodevim.vim` で入れる（Open VSX から入る）。`just vim-key-repeat` を実行してエディタを開き直すと、`j` を押し続けたときにアクセントのメニューではなく繰り返しになる。Vim のキーをしばらく止めたいときは、コマンドパレットで「Vim: Toggle Vim Mode」を実行する。
3. Karabiner（`karabiner` スイッチ）: ターミナル、VS Code、Cursor では、`Esc` と `Ctrl+[` で入力も英数に切り替わる。ノーマルモードに日本語が入らない。日本語の変換中に `Esc` を押すと、変換は取り消される。
4. Ghostty は左の Option キーを Alt として送る。tmux の `Opt+…` のキーにはこれが要る。代わりに、左の Option キーでは `å` のような文字を打てなくなる。`\` のように Option で打つ文字がある配列では、右の Option キーを使う。
5. `sudoedit` や `crontab -e` でも Vim を使うなら、`~/.zshenv.local` に `export EDITOR=vim VISUAL=vim` と書く。リポジトリはほかの人のために `nano` のままにしてある。`.zshrc` が `bindkey -e` を設定するので、どちらでもプロンプトのキーは Emacs 風のまま変わらない。

## サーバーの tmux を中で開いたとき

手元の tmux の中でサーバーの tmux を開くと、プレフィックスはどちらも同じになる。`C-b C-b` で内側の tmux に送る。
