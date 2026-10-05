# Git

The shared git settings are in `~/.config/git/config`. Your name, email and
signing go in `~/.gitconfig`, which git reads afterwards, so its values win
(see [Setup in detail](setup.md#git-gitconfig-is-yours)). The shell aliases for
git are in [Aliases](aliases.md#git).

## Behaviour the shared config sets

| Setting                                  | Effect                                                       |
| ---------------------------------------- | ------------------------------------------------------------ |
| `init.defaultBranch = main`              | new repositories start on `main`                             |
| `pull.rebase = true`                     | `git pull` rebases instead of merging                        |
| `rebase.autoStash = true`                | uncommitted changes are stashed and restored around a rebase |
| `push.default = current`, `push.autoSetupRemote = true` | `git push` on a new branch creates it on the remote with the same name |
| `fetch.prune = true`                     | branches deleted on the remote are removed locally on fetch  |
| `commit.verbose = true`                  | the commit message editor shows the diff                     |
| `merge.conflictstyle = diff3`            | conflict markers include the common ancestor                 |
| `core.excludesfile = ~/.gitignore_global` | the global ignore list is applied in every repository       |
| `credential.helper = osxkeychain`        | HTTPS credentials are stored in the macOS Keychain           |

`core.editor` is Cursor or VS Code, chosen when chezmoi writes the file; see
[How the editor is chosen](setup.md#how-the-editor-is-chosen).

## git aliases

| Alias         | Runs                                                       |
| ------------- | ---------------------------------------------------------- |
| `git co`      | `checkout`                                                 |
| `git ci`      | `commit`                                                   |
| `git st`      | `status -sb`                                               |
| `git br`      | `branch`                                                   |
| `git df`      | `diff`                                                     |
| `git lg`      | graph log, one line per commit                             |
| `git lga`     | the same for all branches                                  |
| `git last`    | the last commit                                            |
| `git unstage` | `reset HEAD --`                                            |
| `git amend`   | `commit --amend --no-edit`                                 |
| `git undo`    | `reset --soft HEAD~1` (undo the last commit, keep changes) |
| `git wip`     | `add -A` and commit with the message `WIP`                 |
| `git please`  | `push --force-with-lease`                                  |
| `git cleanup` | delete local branches merged into the current one, except the current one and any whose name contains `main`, `master` or `develop` |
| `git aliases` | list all aliases                                           |

## delta

When [delta](https://dandavison.github.io/delta/) is installed at the time
chezmoi writes the git config, git uses it as the pager for `diff`, `log`,
`show` and `reflog`, with side-by-side view and line numbers. Press `n` and `N`
to jump between files. `git --no-pager diff` skips it once. If you install delta
later, run `chezmoi apply` again.

## lazygit

`lg` opens [lazygit](https://github.com/jesseduffield/lazygit) when it is
installed. Press `?` inside it for the keys. With the `tmux` switch, `Ctrl+\`
then `g` opens it in a tmux popup.
