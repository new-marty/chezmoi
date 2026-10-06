# tmux と Vim の学習環境：調査と計画

状態: 調査・計画のみ。実装はまだしていない（2026-10 時点）。
起票: `backlog.md` の「tmux と Vim を、サーバーでもそのまま使える形で覚える環境を作る」。

## 目的

手元の Mac では補助（ヒント表示・プラグイン）を厚くして覚えやすくし、
何も入っていないサーバーでも同じ手つきで保守作業（設定ファイルの数行の修正、ログを読む、
crontab を直す）ができるようにする。

判断の基準は 1 つ:「`vi` と素の tmux しかないサーバーで同じキーが通じるか」。
手元だけの便利機能は使ってよいが、それに置き換えてサーバーで通じるキーを潰さない。

---

## 1. 今のリポジトリの状態（調査結果）

### tmux（`tmux` スイッチ、`private_dot_config/tmux/tmux.conf`）

すでに「ヒントが常に見える」環境はかなりできている。貼り付けられた案の Layer 1/2 は、
ほぼ実装済みと言ってよい。

| 項目 | 今の設定 | サーバー（素の tmux） |
|------|---------|---------------------|
| プレフィックス | `Ctrl+\` | `Ctrl-b` |
| ヒントバー | 下に 2 段。2 段目が Zellij 風のヒント（モードに入ると内容が変わる） | なし（`prefix ?`） |
| 一覧 | `Opt+/` でチートシート（`~/.config/tmux/cheatsheet.md`）をポップアップ | `prefix ?` |
| which-key | `tmux-which-key` プラグイン、`prefix Space` | なし |
| ペイン移動 | `Opt+hjkl`（プレフィックス不要）、`prefix p` → `hjkl` | `prefix o`、`prefix 矢印` |
| 分割 | `prefix p` → `d` / `D` | `prefix %` / `prefix "` |
| ウィンドウ | `Opt+1-9`、`Opt+n`、`prefix w` → … | `prefix c` / `n` / `p` / `0-9` |
| セッション | `prefix s` → … | `prefix s`（一覧）、`prefix d` |
| コピーモード | vi キー、`v` / `y` | 既定は emacs キー（`mode-keys` は `EDITOR` が vi を含めば vi） |

サーバーとずれている点:

- **既定のキーを上書きしている**: `prefix p`（既定は前のウィンドウ）、`prefix w`（既定は
  ウィンドウ一覧）、`prefix s`（既定はセッション一覧）、`prefix r`（既定は refresh-client）を
  独自のモードやリロードに使っている。手元で `prefix w` を覚えると、サーバーでは別の
  動作になる。
- **既定のキーを教えていない**: ヒントバーとチートシートには `"` `%` `c` `n` `o` `z` `d` `?`
  が出てこない。既定のキーの多くは今も効く（上書きしていないので）が、見る機会がない。
- 一番よく使う操作が `Opt+…`（プレフィックス不要）に寄っていて、これはサーバーに無い。

要確認（実機で見る）:

- **Ghostty で `Opt` キーが tmux に届いているか**。`private_dot_config/ghostty/config.tmpl` に
  `macos-option-as-alt` の設定が無い。設定が無いと macOS の Option は `˙ ∆ ˚ ¬` のような
  文字を送るので、`Opt+hjkl` などが効いていない可能性がある（Karabiner 側で変換して
  いるなら効く）。
- **vim-tmux-navigator との衝突**。このプラグインはプレフィックス無しの `Ctrl+h/j/k/l` を
  ペイン移動に取る。`dot_zshrc` は `Ctrl+H` を atuin に割り当てているので、tmux の中では
  atuin が開けず、`Ctrl+L`（画面クリア）も効かなくなっているはず。プラグインの版によっては
  `Ctrl+\`（前のペイン）も取り、プレフィックスと重なる。Vim / Neovim 側に対になる
  プラグインが無い今は、このプラグインの利点も無い。

### Vim / Neovim

- リポジトリに Vim / Neovim の設定は無い（`.vimrc`、`.config/nvim` とも無し）。
- `EDITOR` / `VISUAL` は `nano`（`dot_zshenv.tmpl`）。`sudoedit`、`crontab -e`、`less` の `v`
  は nano で開く。git の `core.editor` は Cursor / VS Code、`merge.tool` は `nvimdiff`。
- tmux-resurrect に `@resurrect-strategy-nvim 'session'` があるが、Neovim の設定は無い。
- VS Code / Cursor の拡張一覧に VSCodeVim は無い。

### このリポジトリの約束事で効いてくるもの（`CLAUDE.md`）

- 新しいアプリの設定は opt-in のスイッチが要る（`.chezmoidata/optin.toml`）。Vim の設定を
  足すなら `vim`（や `nvim`）スイッチを作る。CI の `fresh-apply` は表から自動で拾う。
- コア（zsh, git, ssh, editorconfig）はスイッチの外。`EDITOR` を変えるのはコアの変更になり、
  知らない人の環境にも効く。
- 任意のツールへの alias は `command -v` で守る。

---

## 2. 貼り付けられた案の評価

方針（手元は厚く、サーバーで通じる核を鍛える）はそのまま採用する。細部は次の点を直す。

| 案の内容 | 問題 | 直し方 |
|---------|------|-------|
| `status-right` に `"=%horiz` `%=vert` | ステータスの文字列は strftime を通るので `%` が日付書式として消える。また `"` は上下分割、`%` は左右分割で、ラベルが逆に読める | `%%` と書く。ラベルは「`"` 上下 / `%` 左右」 |
| `status-position top`、1 行のヒント | 今の 2 段ヒントバーの方が多機能 | 今のバーを残し、既定キーを足す |
| `tmux split-window -h -p 28` | `-p` は tmux 3.1 で非推奨 | `-l 28%` |
| `tmux-learn` で右ペインに常時チートシート | `Opt+/` のポップアップと役割が重なる | 作るなら任意の関数。優先度は低い |
| 練習は `vim -u NONE file` | `-u NONE` だと `compatible` が立ったまま（vi 互換）になり、`u` が「元に戻す／やり直す」の切り替えになるなど通常の Vim と挙動が違う | `vim --clean`（設定を読まず、既定の `defaults.vim` だけ読む）。加えて本物の `vi` も触る（下記） |
| サーバー＝vim がある前提 | Ubuntu/Debian の最小構成は `vim-tiny`（`vi` で起動、vi 互換モード、シンタックス無し）、Alpine やコンテナは busybox `vi`、`nano` だけのこともある | 練習の一部を `vi` で行う。`u` の挙動の違いと `:q!` での脱出を体で覚える |
| 「持ち歩ける `.vimrc`」に `set mouse=a` | マウスに頼らない練習と矛盾する | 外す |
| `sudoedit` を使う | `EDITOR` が nano なので nano が開く | `EDITOR` をどうするか決める（判断 D5） |
| Neovim + kickstart.nvim | 学習用としては良いが、見た目は控えめ。lazy.nvim が `~/.config/nvim/lazy-lock.json` を書き換える | D4 で LazyVim を推奨に変更。lock ファイルの扱いは D4 に書いた |
| which-key.nvim | tmux の which-key と同じ発想で、学習には良い | 採用（LazyVim に最初から入っている） |
| VSCodeVim を Cursor で | 普段の作業が全部 Vim キーになり、移行コストが大きい | 最初は入れない。端末の Vim で慣れてから考える |

---

## 3. 決めること（推奨つき）

### D1. 手元の tmux のプレフィックス

- **A（推奨）: `Ctrl+\` のまま**。手元の tmux の中から ssh してサーバーの tmux を開く
  （入れ子）とき、プレフィックスが違うので両方そのまま操作できる。サーバーとの差は
  「最初の 1 打だけ」と割り切り、2 打目は既定と同じにする（D2）。
- B: `Ctrl-b` に戻す。指はサーバーと完全に同じになるが、入れ子では外側が全部取るので、
  `F12` で外側のキーを止める仕組みなどが要る。

### D2. 上書きしている既定キー（`p` `w` `s` `r`）

- **A（推奨）: 既定に戻し、モードは別のキーへ**（例: `P` / `W` / `S`、リロードは `prefix R` を
  リサイズモードと分けるため別キー、または `Opt+r`）。手元で覚えた `prefix w` がサーバーでも
  ウィンドウ一覧になる。
- B: 今のまま。

### D3. ヒントバーとチートシート

- **推奨**: 既定のキーを主役にする。1 段目（または `HINT_DEFAULT`）に
  `c 新規  n/p 次/前  " 上下  % 左右  o 次ペイン  z ズーム  d デタッチ  ? 全部` を出し、
  `Opt+…` は「手元だけの近道」として区別して載せる。
- チートシートに「手元 → サーバー」の対応表と Vim の章を足す（`Opt+/` で読める）。

### D4. Vim の環境 — 決定: 見た目のリッチな Neovim

本人の方針（2026-10）: Vim でも Neovim でもよい。基礎が学べるなら、それ以上の機能が
あってよい。UI がリッチでワクワクし、使う機会が増えるならむしろその方がよい。

素の Vim の小さな `.vimrc` から始める案はやめ、最初から見た目と使い心地の良い Neovim に
する。サーバーで通じる基礎は、Neovim でも同じキーで身につく（`hjkl` `ciw` `dd` `:wq` などは
共通）。崩してはいけないのは「基本のキーを割り当て直さない」ことだけ。

土台の候補:

| 候補 | 見た目・使い心地 | 学びやすさ | 手間 |
|------|-----------------|-----------|------|
| **LazyVim（推奨）** | 最初からダッシュボード、ステータスライン、バッファのタブ、通知・コマンド欄のポップアップ（noice）、ファイルツリー、あいまい検索、which-key、LSP、lazygit 連携までそろう | which-key でキーが常に見える。`:LazyExtras` で機能を後から足せる | 少ない。更新は LazyVim 側が追う |
| kickstart.nvim + UI プラグインを自分で足す | 足した分だけ | `init.lua` 1 つで全部読めるので、設定の中身を学ぶには一番良い | 多い。リッチにするほど自分で保守 |
| AstroNvim / NvChad | LazyVim と同程度 | 同程度 | LazyVim と同程度。情報量で LazyVim が勝る |

LazyVim を採るときに手当てすること（サーバーと指がずれる箇所）:

- flash.nvim が normal / visual の `s` を「ジャンプ」に取る。vi の `s`（1 文字消して入力）が
  手元で使えなくなるので、`s` の割り当てを外して flash は別キー（例: `<leader>j`）にするか、
  受け入れるかを決める。推奨は外す。
- `H` / `L` がバッファ切り替えになる（vi では画面の上端・下端へ移動）。保守作業では
  ほとんど使わないので受け入れてよい。
- mini.pairs が括弧や引用符を自動で閉じる。サーバーでは閉じないことだけ知っておく。
- `<C-s>` で保存できるが、`:w` を使う習慣にする（チートシートにも `:w` だけ載せる）。

学習を楽しくする追加（どれも手元だけ、キーは変えない）:

- **precognition.nvim**: カーソル行の上に `w` `b` `e` `^` `$` などで飛べる位置を薄く表示する。
  「どのキーでどこへ行くか」を見ながら覚えられる。慣れたら切る（トグルできる）。
- **hardtime.nvim**: `jjjj` や矢印キーの連打を止め、`5j` や `}` などの良い動きを提案する。
  最初はヒント表示だけのモードで入れる。
- **vim-be-good**: 動きの練習ゲーム（`:VimBeGood`）。
- Neovim 同梱の `:Tutor`（vimtutor）を最初に 1 周する。

テーマ: Ghostty と VS Code は poimandres、tmux は catppuccin mocha。Neovim はどちらにも
合わせられる（poimandres.nvim / catppuccin.nvim）ので、着手時にどちらに揃えるか決める。

chezmoi での置き方:

- `nvim` スイッチを作り、`private_dot_config/nvim/`（`init.lua`、`lua/config/*.lua`、
  `lua/plugins/*.lua`）を管理する。`dirs = [".config/nvim"]`。
- Neovim が自分で書くファイル（`lazy-lock.json`、`lazyvim.json`）は管理しない。chezmoi は
  管理していないファイルには触らないので、置いたままでよい。版を固定したくなったら
  `lazy-lock.json` だけ管理に入れ、更新後に `chezmoi re-add` で戻す。
- プラグインは初回起動時に GitHub から取ってくる。CI の `fresh-apply` は nvim を起動しない
  ので影響しない。
- 必要なもの: Neovim（LazyVim が求める版。着手時に確認）、git、Nerd Font（Ghostty 側）、
  ripgrep・fd・lazygit（`just doctor` の一覧にすでにある）。

サーバー側: Neovim は無い前提。手元で覚えたキーを `vim --clean` と `vi` で確かめる練習は
続ける（下の「5」）。サーバーに置く用の数行の `.vimrc`（`showcmd` `number` `hlsearch`
`incsearch` `syntax on`）はリポジトリでは管理せず、ドキュメントに貼れる形で載せるだけにする。

### D5. `EDITOR` / `VISUAL`

- **A（推奨）: リポジトリは `nano` のまま、本人の `~/.zshenv.local` で `nvim` にする**。
  知らない人の環境を変えずに済み、`sudoedit` `crontab -e` でも毎日 Neovim に触れる
  （`sudoedit` は自分の権限でエディタを開くので、自分の Neovim 設定がそのまま効く）。
- B: リポジトリで `nvim` があれば `nvim`、無ければ `nano` にする（`lookPath` で判定。
  コアの変更なので README の説明も要る）。
- git の `core.editor`（Cursor / VS Code）は今回は変えない。コミットメッセージも Neovim で
  書きたくなったら、`~/.gitconfig` で上書きする。

### D6. vim-tmux-navigator

Neovim を入れるので、tmux のペインと Neovim の分割を `Ctrl+h/j/k/l` で行き来できる
このプラグインには意味が出る。ただし `Ctrl+H`（atuin）と `Ctrl+L`（画面クリア）との
衝突は残る。

- **A（推奨）: 残し、Neovim 側にも対のプラグインを入れる**。atuin は `Ctrl+H` から別のキーへ
  移す（例: `Ctrl+E` など空いているキー。上矢印は `omz` スイッチの history-substring-search が使う）。画面クリアは `prefix Ctrl+L` に逃がす（プラグインの
  README にある定番の回避策）。
- B: 外して、手元の移動は `Opt+hjkl`（tmux）と `Ctrl+w hjkl`（Neovim 既定）で行う。
  `Ctrl+w` はサーバーの Vim でもそのまま通じる。
- フェーズ 0 で、今の衝突が本当に起きているかを先に確かめる。

---

## 4. 実装の段取り（決定後）

### フェーズ 0: 実機確認（Mac、10 分）

1. `tmux -V`、`vim --version | head -1` を記録する。
2. tmux の中で `Opt+h`、`Ctrl+H`、`Ctrl+L`、`Ctrl+\` → `?` がそれぞれ何をするか確かめる。
3. 結果で D6 と Ghostty の `macos-option-as-alt` の要否を決める。

### フェーズ 1: tmux（`tmux` スイッチ内の変更のみ）

- `private_dot_config/tmux/tmux.conf`: D2 のキー移動、D3 のヒントバー、D6 のプラグイン削除。
- `private_dot_config/tmux/cheatsheet.md`: 既定キーの章、「手元 → サーバー」対応表。
- 必要なら `private_dot_config/ghostty/config.tmpl` に `macos-option-as-alt = left`。
- ドキュメント: `docs/{ja,en}/keybindings.md` の tmux の段落。

### フェーズ 2: Neovim（新しい `nvim` スイッチ）

- LazyVim の starter を元に `private_dot_config/nvim/` を作る。D4 の手当て（flash の `s`）、
  学習用プラグイン（precognition、hardtime はヒントのみ、vim-be-good）、テーマを入れる。
- `.chezmoidata/optin.toml` に `[optin_paths.nvim]` を足す（`files` は管理するファイルを全部、
  `dirs = [".config/nvim"]`）。CI の `fresh-apply` が `files` と `chezmoi managed` の一致を
  自動で検査する。
- `just doctor` の一覧に `nvim` を足す。`v` などの alias を作るなら `command -v nvim` で守る。
- D6 の A を選んだら、Neovim 側の navigator と atuin のキー移動もここで行う。
- チートシートに Vim の章（下の「核」）と、LazyVim で手元だけ違うキーの一覧。
- ドキュメント: `docs/{ja,en}/setup.md` のスイッチ表、`keybindings.md`。
- D5 で A を選んだら、`~/.zshenv.local` の書き方を setup.md に一行添える。

### フェーズ 3: 練習の素材（任意）

- `vim-drill` のようなシェル関数: 練習用の nginx 設定・YAML・ログ・crontab の写しを一時
  ディレクトリに作り、`vim --clean` で開く。`command -v vim` で守る。置き場所は
  `dot_zsh/commands.zsh`（コア）になるので、入れるかは別に決める。

---

## 5. 覚える核と練習の運用

### Vim（`vi` でも通じるもの）

```text
移動     h j k l   w b e   0 ^ $   gg G   :42   /pat n N
入力     i a o O   Esc
編集     x  dd dw d$  cc cw ci"  r  yy p  .  u Ctrl-r（vi では u の繰り返し）
選択     v V  →  d y >（行頭に # を足すのは V で選んで :s/^/#/）
保存     :w  :q  :wq  :q!  ZZ
置換     :%s/old/new/gc（c で 1 件ずつ確認）
```

### tmux（素の tmux）

```text
Ctrl-b c 新規  n/p 次/前  0-9 移動  , 名前  & 閉じる
Ctrl-b " 上下分割  % 左右分割  o 次ペイン  矢印 移動  z ズーム  x 閉じる
Ctrl-b d デタッチ  s セッション一覧  w ウィンドウ一覧  [ コピーモード  ? 一覧
tmux ls / tmux a -t 名前
```

### 練習の題材（`vim --clean` と `vi` で）

1. YAML / nginx の設定を 1 行だけ変える
2. ブロックをコメントアウトする
3. ログを開いて `/ERROR` と `n` で原因を追う
4. `.env` や crontab の打ち間違いを直す
5. 末尾に 1 行足す（`G` `o` 入力 `:wq`）
6. root 所有のファイルを `sudoedit` で直す（`sudo vim` にしない）

週 3 回 15 分程度。普段のちょっとした編集（設定ファイル、メモ、`sudoedit`）は手元の
Neovim で行い、使う回数を増やす。大きな開発は Cursor のままでよい。ssh 先での編集は
必ず Vim / vi で行う。

---

## 6. 未決のまま残すこと

- D1〜D3、D5、D6 の選択（本人が決める）。D4 は決定済み（LazyVim を推奨）。
- LazyVim の flash の `s` を外すか、Neovim のテーマを poimandres と catppuccin のどちらに
  揃えるか。
- フェーズ 3 の練習用関数をコアに入れるか。
