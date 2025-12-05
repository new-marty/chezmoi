# Modern CLI Tools

These are modern replacements for traditional Unix commands with better UX.

## lazygit (alias: `lg`)

A simple terminal UI for git commands.

```bash
lg          # Open lazygit in current repo
lazygit     # Full command
```

### Key Operations

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `a` | Stage all files |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `b` | Branch operations |
| `m` | Merge |
| `r` | Rebase |
| `s` | Stash |
| `?` | Show all keybindings |
| `q` | Quit |

### Common Workflow

```bash
lg
# a (stage all) → c (commit) → type message → Enter → p (push)
```

---

## dust (alias: `du`)

A more intuitive disk usage analyzer with visual bars.

```bash
dust              # Current directory
dust ~/Downloads  # Specific directory
dust -n 10        # Top 10 entries only
dust -s           # Apparent size
dust -r           # Reverse order
dust -H           # Show hidden files
```

**Output example:**
```
  4.0G ┌── node_modules    │████████████████████ │  45%
  2.1G ├── .git            │██████████           │  24%
  1.5G ├── dist            │███████              │  17%
```

---

## duf (alias: `df`)

A better disk free utility with beautiful output.

```bash
duf                     # Show all mounted filesystems
duf --only local        # Show only local filesystems
duf /                   # Show specific path
duf --hide-mp "/System/*"  # Hide specific filesystems
duf --json              # JSON output
```

---

## procs (alias: `ps`)

A modern replacement for ps with colors and tree view.

```bash
procs              # Show all processes
procs node         # Search by process name
procs --tree       # Show process tree
procs --watch      # Watch mode (like top)
procs --sortd cpu  # Sort by CPU usage
procs --sortd mem  # Sort by memory usage
procs --tcp        # Find processes using ports
procs --user $(whoami)  # Filter by user
```

---

## btm / bottom (alias: `top`)

A graphical system monitor for the terminal.

```bash
btm     # Start bottom
top     # Aliased to btm
```

### Key Operations

| Key | Action |
|-----|--------|
| `e` | Expand selected widget |
| `h/l` | Move left/right between widgets |
| `j/k` | Scroll down/up |
| `/` | Search processes |
| `t` | Toggle tree view |
| `s` | Sort menu |
| `dd` | Kill selected process |
| `?` | Help |
| `q` | Quit |

**Widgets:** CPU, Memory, Network I/O, Disk I/O, Temperature, Process list

---

## tldr

Simplified, community-driven man pages with practical examples.

```bash
tldr git        # Get quick help for a command
tldr tar        # Common examples
tldr ffmpeg
tldr docker
tldr --update   # Update tldr cache
```

**Example output:**
```
tar
Archiving utility.

- Create an archive:
  tar cf target.tar file1 file2 file3

- Extract an archive:
  tar xf source.tar
```

---

## httpie (alias: `http`)

A user-friendly HTTP client for the terminal.

```bash
# GET request
http httpbin.org/get

# GET with query parameters
http httpbin.org/get name==john age==30

# POST with JSON data
http POST httpbin.org/post name=john age:=30

# POST with form data
http -f POST httpbin.org/post name=john

# Custom headers
http httpbin.org/get "Authorization: Bearer token123"

# Download file
http --download example.com/file.zip

# Follow redirects
http --follow example.com

# Show only response body/headers
http --body httpbin.org/get
http --headers httpbin.org/get
```

**JSON syntax:**
- `name=value` - String
- `age:=30` - Integer/Boolean/JSON
- `data:='{"key": "value"}'` - Raw JSON

---

## delta

Git diff enhancer - automatically used for `git diff`, `git log`, `git show`.

**Features:**
- Syntax highlighting
- Side-by-side view
- Line numbers
- Navigate with n/N

```bash
git diff              # Delta is auto-configured
# n = next file, N = previous file

git diff --no-pager   # Temporarily disable delta
```

