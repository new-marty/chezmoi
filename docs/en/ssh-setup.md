# SSH

The shared `~/.ssh/config` holds only defaults that suit any machine. Keys,
agents and hosts go in `~/.ssh/config.local`, which chezmoi does not manage and
the repository never contains.

## What the shared config sets

For every host:

- `ServerAliveInterval 60` and `ServerAliveCountMax 3` keep idle connections
  open through NAT and firewalls.
- `ControlMaster auto`, `ControlPath ~/.ssh/sockets/%C` and
  `ControlPersist 10m` reuse one connection per host, so a second `ssh` or
  `git fetch` to the same host starts without a new handshake. chezmoi creates
  `~/.ssh/sockets` with mode 700.

## Machine-specific settings in `config.local`

The shared config includes `~/.ssh/config.local` on its first line. ssh keeps
the first value it finds for each option, so anything set in `config.local`
overrides the defaults above. If the file does not exist, ssh skips it.

An example with an SSH agent from a password manager, a key for GitHub and a
private host:

```ssh-config
# Agent for every host. Use the socket path your agent documents.
Host *
    IdentityAgent "~/path/to/agent.sock"

Host github.com
    IdentityFile ~/.ssh/id_ed25519.pub
    IdentitiesOnly yes

Host homeserver
    HostName 192.0.2.10
    User me
```

`IdentityFile` can point at the public key when the private key lives in the
agent; ssh then asks the agent for that key only. Keep the file private:
`chmod 600 ~/.ssh/config.local`.

## Signing commits with an SSH key

Commit signing is configured in `~/.gitconfig`, the machine's own git file.
chezmoi creates it once and never changes it, and git reads it after the shared
`~/.config/git/config`, so its values win:

```ini
[user]
    signingkey = ssh-ed25519 AAAA... (the public key)
[commit]
    gpgsign = true
[gpg]
    format = ssh
[gpg "ssh"]
    allowedSignersFile = ~/.ssh/allowed_signers
```

If the private key is held by an agent that needs its own signing program, set
`gpg.ssh.program` there as well. `~/.ssh/allowed_signers` lists the keys that
`git log --show-signature` should trust, one per line:

```
you@example.com ssh-ed25519 AAAA...
```

## Checking the result

```bash
ssh -G github.com | grep -E '^(identityagent|identityfile|controlpath) '
ssh -T git@github.com
git log --show-signature -1
```
