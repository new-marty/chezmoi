# SSH

共有の `~/.ssh/config` には、どのマシンでも使える既定値だけを置いている。鍵、エージェント、接続先ホストは `~/.ssh/config.local` に書く。このファイルは chezmoi の管理外で、リポジトリにも入らない。

## 共有の設定に入っているもの

すべてのホストに対して次を設定している。

- `ServerAliveInterval 60` と `ServerAliveCountMax 3`。NAT やファイアウォール越しでも、アイドル中の接続が切れないようにする。
- `ControlMaster auto`、`ControlPath ~/.ssh/sockets/%C`、`ControlPersist 10m`。ホストごとに 1 本の接続を使い回すので、同じホストへの 2 回目の `ssh` や `git fetch` はハンドシェイクなしで始まる。`~/.ssh/sockets` は chezmoi がパーミッション 700 で作る。

## マシンごとの設定は `config.local` に書く

共有の設定は、1 行目で `~/.ssh/config.local` を読み込む。ssh は各オプションについて最初に見つけた値を使うので、`config.local` に書いた値が上の既定値より優先される。ファイルがなければ ssh は読み飛ばす。

パスワードマネージャーの SSH エージェントを使い、GitHub 用の鍵と非公開のホストを設定する例:

```ssh-config
# 全ホスト共通のエージェント。ソケットのパスは使っているエージェントの説明に従う。
Host *
    IdentityAgent "~/path/to/agent.sock"

Host github.com
    IdentityFile ~/.ssh/id_ed25519.pub
    IdentitiesOnly yes

Host homeserver
    HostName 192.0.2.10
    User me
```

秘密鍵がエージェントの中にあるなら、`IdentityFile` には公開鍵を指定できる。ssh はエージェントに対して、その鍵だけを使うよう求める。このファイルは `chmod 600 ~/.ssh/config.local` で他人に読めないようにしておく。

## SSH 鍵でコミットに署名する

コミット署名は、マシン固有の git 設定ファイル `~/.gitconfig` に書く。chezmoi はこのファイルを最初に一度作るだけで、その後は変更しない。git は共有の `~/.config/git/config` の後にこちらを読むので、同じ項目は `~/.gitconfig` の値が優先される。

```ini
[user]
    signingkey = ssh-ed25519 AAAA... (公開鍵)
[commit]
    gpgsign = true
[gpg]
    format = ssh
[gpg "ssh"]
    allowedSignersFile = ~/.ssh/allowed_signers
```

秘密鍵を持つエージェントが専用の署名プログラムを必要とする場合は、同じファイルに `gpg.ssh.program` も設定する。`~/.ssh/allowed_signers` には、`git log --show-signature` が信頼する鍵を 1 行に 1 つずつ書く。

```
you@example.com ssh-ed25519 AAAA...
```

## 設定を確かめる

```bash
ssh -G github.com | grep -E '^(identityagent|identityfile|controlpath) '
ssh -T git@github.com
git log --show-signature -1
```
