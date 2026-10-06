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
| Neovim + kickstart.nvim | lazy.nvim が `~/.config/nvim/lazy-lock.json` を書き換える。chezmoi で管理すると毎回 diff が出る | 採るなら lock ファイルを管理対象に入れ `chezmoi re-add` で戻す運用か、管理から外す |
| which-key.nvim | tmux の which-key と同じ発想で、学習には良い | Neovim を入れるなら採用 |
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

### D4. Vim の環境

- **A（推奨、先にやる）: `vim` スイッチで小さな `~/.vimrc`**。キーを変えない設定だけ
  （`showcmd` `showmode` `number` `ruler` `hlsearch` `incsearch` `syntax on`）。
  macOS 同梱の vim は 9.0 系で、`~/.config/vim/vimrc`（XDG）を読むのは 9.1.0327 以降なので、
  置き場所は `~/.vimrc`。サーバーにもそのまま貼れる。
- B（後で）: `nvim` スイッチで Neovim（kickstart.nvim を元にした最小構成 + which-key.nvim）。
  `Esc` `hjkl` と基本オペレーターは割り当て直さない。A に慣れてから。
- 両方入れる場合も、練習は `vim --clean` と `vi` で行う。

### D5. `EDITOR` / `VISUAL`

- **A（推奨）: リポジトリは `nano` のまま、本人の `~/.zshenv.local` で `vim` にする**。
  知らない人の環境を変えずに済み、`sudoedit` `crontab -e` `git rebase -i` 以外の場面でも
  毎日 Vim に触れる。
- B: リポジトリの既定を `vim` にする（コアの変更。README の説明も要る）。

### D6. vim-tmux-navigator

- **推奨: 外す**。Vim 側の対になるプラグインが無く、`Ctrl+H`（atuin）と `Ctrl+L` を潰している。
  Neovim を入れる時点（D4-B）で、両側そろえて入れ直すか決める。

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

### フェーズ 2: Vim（新しい `vim` スイッチ）

- `dot_vimrc` を追加し、`.chezmoidata/optin.toml` に
  `[optin_paths.vim] files = [".vimrc"]` を足す。CI の `fresh-apply` が自動で検査する。
- チートシートに Vim の章（下の「核」）。
- ドキュメント: `docs/{ja,en}/setup.md` のスイッチ表。
- D5 で A を選んだら、`~/.zshenv.local` の書き方を README か setup.md に一行添える。

### フェーズ 3: 練習の素材（任意）

- `vim-drill` のようなシェル関数: 練習用の nginx 設定・YAML・ログ・crontab の写しを一時
  ディレクトリに作り、`vim --clean` で開く。`command -v vim` で守る。置き場所は
  `dot_zsh/commands.zsh`（コア）になるので、入れるかは別に決める。

### フェーズ 4: Neovim（D4-B を選んだ場合）

- `nvim` スイッチ、`private_dot_config/nvim/`、`lazy-lock.json` の扱い、D6 の再判断。

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

週 3 回 15 分程度。普段の作業は Cursor のままでよく、ssh 先での編集は必ず Vim で行う。

---

## 6. 未決のまま残すこと

- D1〜D6 の選択（本人が決める）。
- フェーズ 3 の練習用関数をコアに入れるか。
- Neovim をいつ入れるか（フェーズ 2 の後、慣れ具合で決める）。
