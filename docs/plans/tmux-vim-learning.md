# tmux と Vim の学習環境：調査メモ

状態: 調査のみ。どの案を採るかは決めていない。実装もしていない（2026-10 時点）。
起票: `backlog.md` の「tmux と Vim を、サーバーでもそのまま使える形で覚える環境を作る」。

このメモは事実と選択肢を並べるだけで、推奨や結論は書かない。選ぶのは本人。

## 目的（本人の言葉から）

- 手元の Mac では補助（ヒント表示・プラグイン）を厚くして覚えやすくする。
- 何も入っていないサーバーでも、同じ手つきで保守作業（設定ファイルの数行の修正、ログを
  読む、crontab を直す）ができるようにする。
- Vim は Vim でも Neovim でも何でもよい。基礎が学べるなら、それ以上の機能があってもよい。
  UI がリッチでワクワクし、使いやすくなって使う機会が増えるなら、むしろその方がよい。

---

## 1. 今のリポジトリの状態

### tmux（`tmux` スイッチ、`private_dot_config/tmux/tmux.conf`）

「ヒントが常に見える」仕組みはすでにある。

| 項目 | 今の設定 | 素の tmux（サーバー） |
|------|---------|---------------------|
| プレフィックス | `Ctrl+\` | `Ctrl-b` |
| ヒントバー | 下に 2 段。2 段目が Zellij 風のヒント（モードに入ると内容が変わる） | なし（`prefix ?` で一覧） |
| 一覧 | `Opt+/` でチートシート（`~/.config/tmux/cheatsheet.md`）をポップアップ | `prefix ?` |
| which-key | `tmux-which-key` プラグイン、`prefix Space` | なし |
| ペイン移動 | `Opt+hjkl`（プレフィックス不要）、`prefix p` → `hjkl` | `prefix o`、`prefix 矢印` |
| 分割 | `prefix p` → `d` / `D` | `prefix %`（左右）/ `prefix "`（上下） |
| ウィンドウ | `Opt+1-9`、`Opt+n`、`prefix w` → … | `prefix c` / `n` / `p` / `0-9` |
| セッション | `prefix s` → … | `prefix s`（一覧）、`prefix d` |
| コピーモード | vi キー、`v` / `y` | 既定は emacs キー（サーバー起動時に `EDITOR` / `VISUAL` が vi を含めば vi） |

素の tmux と違う点:

- 既定のキーの上書き: `prefix p`（既定は前のウィンドウ）、`prefix w`（既定はウィンドウ
  一覧）、`prefix s`（既定はセッション一覧）、`prefix r`（既定は refresh-client）を独自の
  モードや設定の再読み込みに使っている。
- ヒントバーとチートシートに、既定のキー（`"` `%` `c` `n` `o` `z` `d` `?`）が出てこない。
  上書きしていないキーは今も効く。
- よく使う操作は `Opt+…`（プレフィックス不要）にまとめてあり、これはサーバーには無い。

実機での確認が要るもの（このクラウド環境からは確かめられない）:

- Ghostty で `Opt` キーが tmux に届いているか。`private_dot_config/ghostty/config.tmpl` に
  `macos-option-as-alt` が無い。Ghostty はこれが未設定のとき、その時点の入力ソースが US
  配列なら Option を Alt として送り、US 以外の配列なら送らない（入力ソースを切り替えると
  その場で変わる）。送らないときの Option は `˙ ∆ ˚ ¬` のような文字になり、`Opt+hjkl` などは
  効かない。JIS 配列や日本語入力のときにどちらになるかは、実機で確かめる必要がある。
  Karabiner 側で変換していれば、この設定に関係なく効く。
- vim-tmux-navigator との衝突。このプラグインは、プレフィックス無しの `Ctrl+h/j/k/l` を
  ペイン移動に、`Ctrl+\` を前のペインへの移動に、既定で割り当てる（プラグインの
  `vim-tmux-navigator.tmux` で確認）。
  - `dot_zshrc` は `Ctrl+H` を atuin に割り当てているので、tmux の中では atuin が開かない
    可能性がある。
  - `Ctrl+L`（画面クリア）は、プラグインが代わりに `prefix Ctrl+L` へ割り当てる
    （`@vim_navigator_prefix_mapping_clear_screen`）。
  - `Ctrl+\` はこの設定のプレフィックスと同じキー。プレフィックスとプラグインの割り当ての
    どちらが効くかは実機で確かめる必要がある。プラグイン側は
    `@vim_navigator_mapping_prev` で別のキーに変えられる。
  - Vim / Neovim 側には今、対になるプラグインが無い。

### Vim / Neovim

- リポジトリに Vim / Neovim の設定は無い（`.vimrc`、`.config/nvim` とも無し）。
- `EDITOR` / `VISUAL` は `nano`（`dot_zshenv.tmpl`）。`sudoedit`、`crontab -e`、`less` の `v`
  は nano で開く。git の `core.editor` は Cursor / VS Code、`merge.tool` は `nvimdiff`。
- tmux-resurrect に `@resurrect-strategy-nvim 'session'` があるが、Neovim の設定は無い。
- VS Code / Cursor の拡張一覧に VSCodeVim は無い。

### シェル

- `Ctrl+H` は atuin、`Ctrl+R` は peco の履歴検索。
- `omz` スイッチを選ぶと、上下の矢印キーは history-substring-search に割り当てられる。

### このリポジトリの約束事で関係するもの（`CLAUDE.md`、`.chezmoidata/optin.toml`）

- アプリの設定は opt-in のスイッチの裏に置く。Vim / Neovim の設定を足すなら新しい
  スイッチが要る。CI の `fresh-apply` は `optin.toml` から自動で拾い、`files` と
  `chezmoi managed` の一致を検査する。
- 複数の案から 1 つを選ばせる仕組み（`[optin_choices.<name>]`）がある。既定値は持てず、
  ちょうど 1 つ選ばないと apply が止まる。
- コア（zsh, git, ssh, editorconfig）はスイッチの外。`EDITOR` を変えるのはコアの変更になり、
  知らない人の環境にも効く。本人だけの設定は `~/.zshenv.local` に置ける。
- 任意のツールへの alias は `command -v` で守る。
- `omz` と `editor-builtin` の説明によると、拡張やフォントを入れられない Mac、GitHub から
  clone できない Mac がある。

---

## 2. 最初に貼られた案の検証結果

方針（手元は厚く、サーバーで通じる核を鍛える）とは別に、細部の事実関係を確かめた。

| 案の内容 | 確かめたこと |
|---------|-------------|
| `status-right` に `"=%horiz` `%=vert` | ステータスの文字列は strftime を通るので、`%` は日付の書式として扱われる。文字として出すには `%%` と書く。`"` は上下分割、`%` は左右分割 |
| `status-position top`、1 行のヒント | 今の設定は下に 2 段のヒントバーで、案より情報量が多い |
| `tmux split-window -h -p 28` | `-p` は tmux 3.1 で非推奨。代わりは `-l 28%` |
| `tmux-learn`（右ペインに常時チートシート） | `Opt+/` のポップアップと役割が重なる |
| 練習は `vim -u NONE file` | `-u NONE` では `compatible` が立ったまま（vi 互換）になり、`u` が「元に戻す／やり直す」の切り替えになるなど、通常の Vim と挙動が違う。設定を読まずに通常の挙動で起動するのは `vim --clean`（既定の `defaults.vim` だけ読む） |
| サーバーには vim がある前提 | Ubuntu/Debian の最小構成は `vim-tiny`（`vi` で起動、vi 互換モード、シンタックス表示なし）、Alpine やコンテナは busybox の `vi`、`nano` だけのこともある |
| 持ち歩く `.vimrc` に `set mouse=a` | マウスに頼らない練習という案自身の方針とは向きが逆 |
| `sudoedit` を使う | `EDITOR` / `SUDO_EDITOR` のエディタが開く。今は nano。`sudoedit` はエディタを自分の権限で起動するので、自分の Vim / Neovim 設定が効く |
| `~/.vimrc` の置き場所 | macOS 同梱の vim は 9.0 系。`~/.config/vim/vimrc`（XDG）を読むのは 9.1.0327 以降なので、同梱 vim に読ませるなら `~/.vimrc` |

---

## 3. 選択肢

各項目は並べるだけで、どれを採るかは決めていない。

### 3-1. 手元の tmux のプレフィックス

| 案 | 内容 | 利点 | 欠点 |
|----|------|------|------|
| `Ctrl+\` のまま | 今の設定 | 手元の tmux からサーバーの tmux を開いた入れ子でも、プレフィックスが違うので両方そのまま操作できる | 最初の 1 打がサーバーと違う |
| `Ctrl-b` に戻す | 素の tmux と同じ | 指がサーバーと完全に同じになる | 入れ子では外側が全部取るので、外側のキーを一時的に止める仕組み（`F12` で切り替える定番の設定など）が要る |

### 3-2. 上書きしている既定キー（`p` `w` `s` `r`）

| 案 | 内容 |
|----|------|
| 既定に戻し、独自のモードを別のキーへ移す | 例: `P` / `W` / `S`（素の tmux では未使用）。手元の `prefix w` がサーバーと同じ動作になる。今のモードを使う指の癖は変わる |
| 今のまま | 手元とサーバーで `prefix p/w/s/r` の意味が違うまま |

### 3-3. ヒントバーとチートシートの中身

- ヒントバーに既定のキーを出す／出さない。出す場合、`Opt+…` の近道と区別して並べるか。
- チートシートに「手元 → サーバー」の対応表や Vim の章を足すか。

### 3-4. Vim / Neovim の環境

本人の条件: 基礎が学べること。それ以上の機能やリッチな UI はあってよい。

| 案 | 見た目・使い心地 | 学びやすさ | 保守の手間 |
|----|-----------------|-----------|-----------|
| 素の Vim + 数行の `.vimrc` | 控えめ | サーバーとほぼ同じ | 最小 |
| Neovim + LazyVim | 最初からダッシュボード、ステータスライン、バッファのタブ、通知やコマンド欄のポップアップ（noice）、ファイルツリー、あいまい検索、which-key、LSP、lazygit 連携がそろう | which-key でキーが見える。`:LazyExtras` で後から機能を足せる | 少ない。更新は LazyVim 側が追う |
| Neovim + kickstart.nvim（＋UI プラグインを自分で足す） | 足した分だけ | `init.lua` 1 つで全部読めるので、設定の中身も学べる | リッチにするほど自分で保守する |
| Neovim + AstroNvim / NvChad | LazyVim と同程度 | 同程度 | 同程度。日本語・英語の情報量は LazyVim が多い |

LazyVim の既定で、vi と動作が違うキー（手元とサーバーで指がずれる所）。LazyVim の
`lua/lazyvim/config/keymaps.lua` と `lua/lazyvim/plugins/editor.lua` で確認した:

- `s`（normal / visual / operator）: flash.nvim のジャンプ。`S` は treesitter での選択。
  operator 待ちの `r`、`R` も flash が取る。vi では `s` は 1 文字消して入力モードに入り、
  `S` は行を消して入力モードに入る。設定で外せる。
- `H` / `L`（`<S-h>` / `<S-l>`）: 前後のバッファへ切り替え。vi では画面の上端・下端へ移動。
- `<C-h/j/k/l>`: 分割したウィンドウ間の移動（`<C-w>h/j/k/l` と同じ）。vi の `<C-w>h` などは
  そのまま使える。
- `<C-s>`: 保存（normal / insert / visual）。vi の端末では出力停止になることがある
  （`Ctrl+Q` で再開）。
- `<esc>`: 検索の強調表示も消す。入力モードを抜ける動作は vi と同じ。
- mini.pairs が括弧や引用符を自動で閉じる。vi では閉じない。

Neovim で使える、学習用の追加プラグイン（キーは変えない）:

| 名前 | 内容 |
|------|------|
| precognition.nvim | カーソル行の上に、`w` `b` `e` `^` `$` などで飛べる位置を薄く表示する。表示は切り替えられる |
| hardtime.nvim | `jjjj` や矢印キーの連打を止め、より良い動きを提案する。止めずにヒントだけ出すモードもある |
| vim-be-good | 動きを練習するゲーム（`:VimBeGood`） |
| `:Tutor` | Neovim 同梱の vimtutor |

Neovim を chezmoi で管理するときの事実:

- 置き場所は `~/.config/nvim/`（ソースは `private_dot_config/nvim/`）。新しいスイッチと、
  `optin.toml` の `files`（管理するファイル全部）と `dirs = [".config/nvim"]` が要る。
- lazy.nvim 系は `lazy-lock.json`（LazyVim はさらに `lazyvim.json`）を自分で書き換える。
  管理に入れると更新のたびに `chezmoi diff` に差分が出るので、`chezmoi re-add` で戻すか、
  管理から外す（chezmoi は管理していないファイルには触らない）かのどちらかになる。
- プラグインは初回起動時に GitHub から clone する。GitHub から clone できない Mac では、
  プラグイン前提の構成はそのままでは動かない。
- アイコン表示には Nerd Font が要る。フォントを入れられない Mac ではアイコンが化ける
  （LazyVim はアイコンを切る設定がある）。
- CI の `fresh-apply` は nvim を起動しないので、プラグインの取得は CI に影響しない。
- テーマ: Ghostty と VS Code は poimandres、tmux は catppuccin mocha。Neovim には
  どちらのテーマもある（poimandres.nvim / catppuccin.nvim）。
- LazyVim の README（2026-10 時点）が挙げる要件: Neovim 0.11.2 以上（LuaJIT 版）、
  Git 2.19.0 以上、nvim-treesitter 用の C コンパイラ。Nerd Font は任意。lazygit、ripgrep、
  fd などは要件ではなく、あると機能が増える。要件は時期で上がる。

### 3-5. `EDITOR` / `VISUAL`

| 案 | 影響 |
|----|------|
| リポジトリは `nano` のまま、本人の `~/.zshenv.local` で変える | 知らない人の環境は変わらない |
| リポジトリで、入っていれば vim / nvim、無ければ `nano` にする（`lookPath`） | コアの変更。README の説明も要る |
| 変えない | `sudoedit`、`crontab -e` は nano のまま |

git の `core.editor`（Cursor / VS Code）は `c` alias と同じ規則で決まっていて、変えるなら
両方そろえて変える約束がある（`CLAUDE.md`）。

### 3-6. vim-tmux-navigator

| 案 | 内容 |
|----|------|
| 外す | `Ctrl+H`（atuin）と `Ctrl+L` が戻る。手元の移動は `Opt+hjkl`（tmux）と `Ctrl+w hjkl`（Vim 既定、サーバーでも通じる） |
| 残し、Neovim 側にも対のプラグインを入れる | tmux のペインと Neovim の分割を同じキーで行き来できる。atuin を別のキーへ移す必要がある（上矢印は `omz` の history-substring-search が使う）。画面クリアは `prefix Ctrl+L` になる。`Ctrl+\` はプレフィックスと重なるので、`@vim_navigator_mapping_prev` で変えるかを決める |
| 今のまま | Vim 側のプラグインが無いので、衝突だけが残る |

---

## 4. どの案でも共通の作業の場所

選択が決まったときに触るファイルの見当。

- tmux: `private_dot_config/tmux/tmux.conf`、`private_dot_config/tmux/cheatsheet.md`、
  場合により `private_dot_config/ghostty/config.tmpl`（`macos-option-as-alt`）。
- Vim / Neovim: 新しいソース（`dot_vimrc` か `private_dot_config/nvim/`）、
  `.chezmoidata/optin.toml`、`justfile` の `doctor` の一覧。
- ドキュメント: `docs/{ja,en}/keybindings.md`、`docs/{ja,en}/setup.md`。
- 実機確認（このクラウド環境ではできない）: `tmux -V`、`vim --version`、`nvim --version`、
  tmux の中での `Opt+h` / `Ctrl+H` / `Ctrl+L` / `Ctrl+\` の動作。

---

## 5. 覚える核（参考）

選択に関わらず、サーバーで通じるキー。

### Vim（`vi` でも通じるもの）

```text
移動     h j k l   w b e   0 ^ $   gg G   :42   /pat n N
入力     i a o O   Esc
編集     x  dd dw d$  cc cw ci"  r  yy p  .  u Ctrl-r（vi 互換モードでは u の繰り返し）
選択     v V  →  d y >
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

### 保守作業の練習題材（最初の案から）

1. YAML / nginx の設定を 1 行だけ変える
2. ブロックをコメントアウトする
3. ログを開いて `/ERROR` と `n` で原因を追う
4. `.env` や crontab の打ち間違いを直す
5. 末尾に 1 行足す（`G` `o` 入力 `:wq`）
6. root 所有のファイルを `sudoedit` で直す

---

## 6. 本人が決めること

- 3-1 プレフィックス
- 3-2 既定キーの上書き
- 3-3 ヒントバー・チートシートの中身
- 3-4 Vim / Neovim の土台。Neovim なら、vi と動作が違うキーをどう扱うか、学習用
  プラグインを入れるか、テーマ、clone やフォントの入れられない Mac をどう扱うか
- 3-5 `EDITOR`
- 3-6 vim-tmux-navigator

---

## 7. 確かめた一次情報

- vim-tmux-navigator: <https://github.com/christoomey/vim-tmux-navigator>（`vim-tmux-navigator.tmux`）
- LazyVim: <https://github.com/LazyVim/LazyVim>（`README.md`、`lua/lazyvim/config/keymaps.lua`、
  `lua/lazyvim/plugins/editor.lua`）
- Ghostty の `macos-option-as-alt` の既定値: Ghostty のソースの変更履歴（公式サイトの
  設定リファレンスは、この環境のネットワーク制限で読めなかった）
