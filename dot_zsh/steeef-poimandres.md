# Steeef Theme + Poimandres Color Integration

This document explains how the steeef zsh theme is optimized for Ghostty's poimandres color theme to avoid conflicts and ensure visual harmony.

## Color Mapping

In a truecolor terminal (`COLORTERM=truecolor`: Ghostty, iTerm2, the VS Code and
Cursor terminals) the theme writes the colors below as hex values (`%F{#89ddff}`),
so the prompt looks the same whatever palette the terminal has. Other terminals
get the palette numbers.

The steeef theme uses specific palette numbers that correspond to poimandres colors:

### Poimandres Palette (from ghostty/poimandres.ghostty)

```
palette 0  = #1b1e28  (dark background)
palette 1  = #d0679d  (pink)
palette 2  = #5de4c7  (green/teal)
palette 3  = #fffac2  (yellow/cream)
palette 4  = #89ddff  (blue)
palette 5  = #fcc5e9  (light pink)
palette 8  = #a6accd  (gray - foreground)
palette 9  = #d0679d  (bright pink)
palette 10 = #5de4c7  (bright green/teal)
palette 11 = #fffac2  (bright yellow/cream)
palette 13 = #fcc5e9  (bright light pink)
```

### Steeef Theme Color Usage

```
turquoise  = %F{10}  # Bright teal for branch names
orange     = %F{11}  # Cream/yellow for hostname
purple     = %F{13}  # Light pink (not used in main prompt)
hotpink    = %F{1}   # Pink for untracked files indicator
limegreen  = %F{2}   # Teal for directory path
red        = %F{9}   # Bright pink for errors/root user
blue       = %F{4}   # Blue for username and python env
```

### Prompt Elements Color Assignment

- **Username**: Blue (%F{4}) - normal user, Red (%F{9}) - root user
- **Hostname**: Cream/Yellow (%F{11})
- **Directory**: Teal (%F{2})
- **Git Branch**: Teal (%F{10})
- **Git Status**: Orange (%F{11}) for staged, Pink (%F{1}) for untracked
- **Python Env**: Blue (%F{4})
- **Time**: Gray (%F{8})
- **Error Code**: Red (%F{9})

## Avoiding Configuration Conflicts

### What Ghostty Controls

- Terminal color palette (0-15)
- Background color (#1b1e28)
- Foreground color (#a6accd)
- Cursor color (#ffb473)
- Selection colors

### What Steeef Controls

- Prompt text colors (using palette references)
- Git status indicators
- User/host/directory display format

### No Conflicts Because

1. Ghostty sets the **color values** (what #d0679d looks like)
2. Steeef references **color numbers** (%F{1} = palette 1)
3. No color values are hardcoded in steeef theme
4. Both work together harmoniously

## Visual Result

```
yumabuchi at Marty in ~/dotfiles ((main●●) ●)                    13:03:04
$
```

- `yumabuchi` (blue) `at` (white) `Marty` (cream) `in` (white) `~/dotfiles` (teal)
- `((main●●) ●)` - branch in teal, indicators in orange/pink
- Time in subtle gray
- All colors sourced from poimandres palette

## Customization Notes

To modify colors:

1. **Change terminal colors**: Edit `ghostty/poimandres.ghostty`
2. **Change prompt layout**: Edit `.zsh/steeef.zsh-theme`
3. **Never hardcode hex colors** in steeef theme - always use palette numbers

This ensures consistency and prevents conflicts between terminal and prompt theming.
