# SSH Configuration with 1Password - Setup Guide

This repository uses 1Password SSH Agent for secure SSH key management across multiple machines.

## Architecture

- **SSH Config**: Managed by chezmoi, templates based on machine type
- **SSH Keys**: Stored in 1Password, machine-specific (macbook, work, ubuntu, etc.)
- **Commit Signing**: Automatic SSH-based signing with 1Password

## Initial Setup (New Machine)

### 1. Determine Machine Type

Choose a machine type identifier:

- `macbook` - Personal MacBook
- `work` - Work MacBook
- `ubuntu` - Ubuntu machine
- `windows` - Windows machine
- `unraid` - Unraid server

### 2. Configure chezmoi

Edit `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    # Set machine type flags
    is_personal_mac = true  # or false
    is_work_mac = false     # or false

    # Git configuration
    git_name = "Your Name"
    git_email = "your@email.com"

    # SSH Configuration (will be updated after key generation)
    ssh_public_keys = []
    ssh_signing_key = ""

[git]
    autoCommit = true
    autoPush = true

[onepassword]
    command = "op"
```

### 3. Apply chezmoi Configuration

```bash
chezmoi apply
```

This creates:

- `~/.ssh/config` - SSH configuration with 1Password Agent
- `~/.ssh/sockets/` - ControlMaster socket directory
- `~/.ssh/allowed_signers` - Git commit signature verification
- `~/.gitconfig` - Git configuration with commit signing

### 4. Generate SSH Key

```bash
# Replace MACHINE with your machine type (macbook, work, etc.)
MACHINE="macbook"

ssh-keygen -t ed25519 \
  -C "${MACHINE}-2025" \
  -f ~/.ssh/id_ed25519_${MACHINE}
```

### 5. Register Public Key to GitHub

```bash
# For authentication
gh ssh-key add ~/.ssh/id_ed25519_${MACHINE}.pub \
  -t "$(hostname) - ${MACHINE}"

# For commit signing
gh ssh-key add ~/.ssh/id_ed25519_${MACHINE}.pub \
  -t "$(hostname) - ${MACHINE} (Signing)" \
  --type signing
```

### 6. Save SSH Key to 1Password

**Option A: Using 1Password GUI** (Recommended)

1. Open 1Password app
2. New Item → SSH Key
3. Add Private Key → Import a Key File
4. Select `~/.ssh/id_ed25519_${MACHINE}`
5. **Important**: Add `github.com` to "Websites & Apps" field
6. Save with title like "macbook SSH Key"

**Option B: Using 1Password CLI**

_Note: SSH Key type cannot be created via CLI. Create as Secure Note instead, then manually convert in GUI._

### 7. Update chezmoi Configuration with Public Key

Get your public key:

```bash
cat ~/.ssh/id_ed25519_${MACHINE}.pub
```

Edit `~/.config/chezmoi/chezmoi.toml` and add:

```toml
[data]
    # ... existing config ...

    ssh_public_keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... macbook",
        # Add more keys as you set up additional machines
    ]
    ssh_signing_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... macbook"
```

Apply the updated configuration:

```bash
chezmoi apply --force ~/.ssh/allowed_signers ~/.gitconfig
```

### 8. Enable 1Password SSH Agent

1. Open 1Password app
2. Settings (⌘,) → Developer
3. Check "Use the SSH agent"
4. Verify "SSH Agent is running" badge appears

### 9. Verify Setup

```bash
# Test SSH connection to GitHub
ssh -T git@github.com
# Expected: "Hi <username>! You've successfully authenticated..."

# Test commit signing
cd /tmp
git init test-repo && cd test-repo
git commit --allow-empty -m "Test commit"
git log --show-signature -1
# Expected: "Good "git" signature for your@email.com..."
```

## Adding Additional Machines

When setting up a new machine:

1. Follow steps 1-6 above with the new machine type
2. Add the new public key to `chezmoi.toml`:

```toml
ssh_public_keys = [
    "ssh-ed25519 AAAAC3...existing... macbook",
    "ssh-ed25519 AAAAC3...new-key... work",  # Add new key
]
```

3. Commit and push from any machine:

```bash
cd ~/.local/share/chezmoi
git add .config/chezmoi/chezmoi.toml  # if tracking config
git commit -m "Add work machine SSH public key"
git push
```

4. On all machines, pull the update:

```bash
chezmoi update
```

## Machine-Specific Configuration

### Personal Mac

- Includes: OrbStack integration, and `~/.ssh/config.local` for home servers
- `~/.ssh/config.local` is not managed by chezmoi, so their addresses stay out of
  this repository. Create it by hand on a new machine (`chmod 600`). The `mini` and `m1`
  shell functions read the Tailscale addresses of `Host mini` and `Host m1` from it.
- GitHub: Direct `github.com` access

### Work Mac

- GitHub: Separate hosts (`github.com-personal`, `github.com-work`)
- No OrbStack or personal server configs

### Ubuntu/Windows/Unraid

- Basic SSH Agent configuration only
- Add custom server configs as needed

## Troubleshooting

### SSH Agent Socket Not Found

```bash
# Check 1Password SSH Agent status
ls -la ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Restart 1Password
killall "1Password"
open -a "1Password"
```

### Commits Not Signed

```bash
# Verify signing key is configured
git config --get user.signingkey

# Verify allowed_signers exists
cat ~/.ssh/allowed_signers

# Re-apply templates
chezmoi apply --force ~/.gitconfig ~/.ssh/allowed_signers
```

### Permission Denied (publickey)

1. Verify 1Password SSH Agent is running
2. Check that SSH Key item in 1Password has `github.com` in "Websites & Apps"
3. Test SSH config:

```bash
ssh -G github.com | grep identityagent
```

## Security Notes

- Private keys are only stored in 1Password, not on disk
- Each machine has a unique SSH key
- 1Password prompts for approval on first SSH use per application
- Commit signatures are automatically verified via `allowed_signers`

## References

- [1Password SSH Agent Documentation](https://developer.1password.com/docs/ssh/)
- [chezmoi Documentation](https://www.chezmoi.io/)
- [GitHub SSH Documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
