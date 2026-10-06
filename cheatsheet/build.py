#!/usr/bin/env python3
"""Builds cheatsheet/index.html: five A4 landscape pages, identical on screen and paper.

Edit this file or style.css, then run:  python3 cheatsheet/build.py cheatsheet/index.html
and check the print with:  just cheatsheet-pdf
"""
import html, sys

OUT = sys.argv[1]

# ---------------------------------------------------------------- helpers
def K(t, mode=""):
    cls = f"k {mode}".strip()
    return f'<span class="{cls}">{t}</span>'

A = '<span class="to">→</span>'
def E(t): return f"<em>{t}</em>"
VIMTAG = '<span class="vimtag">vim</span>'

# ---------------------------------------------------------------- Vim page: modes as round trips
# ---------------------------------------------------------------- mini screens (HTML)
def scr(body, status="", kind="", cls=""):
    """A small terminal screen: body lines (HTML, white-space: pre) and Vim's bottom line."""
    st = f'<div class="st {kind}">{status or "&nbsp;"}</div>'
    return f'<div class="scr {cls}"><div class="body">{body}</div>{st}</div>'

def tscr(panes, bar, cls="", cols=""):
    """A small tmux screen: panes (list of HTML bodies) and the green status bar."""
    style = f' style="grid-template-columns: {cols}"' if cols else ""
    inner = "".join(f'<div class="pane{" on" if i == len(panes) - 1 else ""}">{p}</div>' for i, p in enumerate(panes))
    return f'<div class="scr tmx {cls}"><div class="panes"{style}>{inner}</div><div class="tbar">{bar}</div></div>'

def pair(a, b):
    return f'<div class="pair">{a}<span class="to big">→</span>{b}</div>'

def CB(ch): return f'<span class="cb">{ch}</span>'   # block cursor (Normal)
def CI(): return '<span class="ci"></span>'          # bar cursor (Insert)

def modes_svg():
    def screen(x, y, w, h, lines, status, scolor, sbg="none"):
        out = [f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="var(--soft)" stroke="var(--line)"/>']
        for i, ln in enumerate(lines):
            out.append(f'<text x="{x+8}" y="{y+18+i*16}" font-size="12.5" class="mono" fill="var(--ink)" xml:space="preserve">{ln}</text>')
        out.append(f'<rect x="{x+1}" y="{y+h-19}" width="{w-2}" height="18" fill="{sbg}"/>')
        out.append(f'<line x1="{x}" y1="{y+h-19}" x2="{x+w}" y2="{y+h-19}" stroke="var(--line)"/>')
        out.append(f'<text x="{x+8}" y="{y+h-6}" font-size="12" class="mono" fill="{scolor}" font-weight="700" xml:space="preserve">{status}</text>')
        return "".join(out)
    o = []
    # Normal: one tall screen on the left
    o.append(f'<rect x="2" y="2" width="168" height="256" rx="10" fill="var(--normal-bg)" stroke="var(--normal)" stroke-width="2.5"/>')
    o.append('<text x="86" y="26" text-anchor="middle" font-size="16" font-weight="700" fill="var(--ink)">NORMAL</text>')
    o.append('<text x="86" y="44" text-anchor="middle" font-size="12" fill="var(--ink)">move, delete, copy</text>')
    o.append(screen(14, 56, 144, 70, ["server {", "  listen 80;", "}"], " ", "var(--muted)"))
    o.append('<rect x="37" y="79" width="7.5" height="15" fill="var(--ink)"/><text x="37" y="90" font-size="12.5" class="mono" fill="var(--paper)">l</text>')
    o.append('<text x="86" y="146" text-anchor="middle" font-size="11.5" fill="var(--muted)">block cursor</text>')
    o.append('<text x="86" y="161" text-anchor="middle" font-size="11.5" fill="var(--muted)">bottom line is empty</text>')
    o.append('<text x="86" y="200" text-anchor="middle" font-size="12" fill="var(--ink)">Lost? press</text>')
    o.append('<text x="86" y="220" text-anchor="middle" font-size="16" class="mono" fill="var(--ink)">Esc  Esc</text>')
    o.append('<text x="86" y="238" text-anchor="middle" font-size="12" fill="var(--ink)">to come back here</text>')
    rows = [
        ("i  a  o", "Esc", "insert", "INSERT", "type text",
         ["server {", '  listen 8080;', "}"], "-- INSERT --", "var(--insert)", "none"),
        ("v  V", "Esc  d  y", "visual", "VISUAL", "select text",
         ["server {", '  listen 80;', "}"], "-- VISUAL --", "var(--visual)", "none"),
        (":", "Enter  Esc", "command", "COMMAND", "run a command",
         ["server {", '  listen 80;', "}"], ":wq", "var(--ink)", "var(--command-bg)"),
    ]
    for r, (enter, leave, cls, name, what, lines, status, scol, sbg) in enumerate(rows):
        y = 2 + r * 88
        cy = y + 40
        o.append(f'<line x1="174" y1="{cy-10}" x2="300" y2="{cy-10}" stroke="var(--{cls})" stroke-width="2.4" marker-end="url(#mh)"/>')
        o.append(f'<text x="237" y="{cy-17}" text-anchor="middle" font-size="15" class="mono" fill="var(--ink)">{enter}</text>')
        o.append(f'<line x1="300" y1="{cy+10}" x2="176" y2="{cy+10}" stroke="var(--normal)" stroke-width="2.4" marker-end="url(#mh)"/>')
        o.append(f'<text x="237" y="{cy+29}" text-anchor="middle" font-size="13" class="mono" fill="var(--ink)">{leave}</text>')
        o.append(f'<rect x="304" y="{y}" width="214" height="80" rx="10" fill="var(--{cls}-bg)" stroke="var(--{cls})" stroke-width="2"/>')
        o.append(f'<text x="314" y="{y+18}" font-size="13.5" font-weight="700" fill="var(--ink)">{name}</text>')
        o.append(f'<text x="{314 + len(name)*10 + 8}" y="{y+18}" font-size="11.5" fill="var(--ink)">{what}</text>')
        o.append(screen(314, y + 25, 194, 50, lines[1:2], status, scol, sbg))
        if cls == "insert":
            o.append(f'<line x1="{322+13*7.5}" y1="{y+30}" x2="{322+13*7.5}" y2="{y+46}" stroke="var(--insert)" stroke-width="2"/>')
        if cls == "visual":
            o.append(f'<rect x="{322+9*7.5}" y="{y+31}" width="{15.5}" height="15" fill="var(--visual)" opacity=".35"/>')
    return f'''<svg viewBox="0 0 520 262" role="img" aria-label="Vim starts in Normal mode, with a block cursor and an empty bottom line. i, a or o goes to Insert mode, where the bottom line shows -- INSERT -- and you type text; Esc comes back. v or V goes to Visual mode, -- VISUAL --, to select text; Esc, d or y comes back. A colon goes to Command mode, where you type the command on the bottom line; Enter or Esc comes back.">
        <defs><marker id="mh" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto"><path d="M0 0 L10 5 L0 10 z" fill="context-stroke"/></marker></defs>
        {"".join(o)}
      </svg>'''

# ---------------------------------------------------------------- Vim page: motions on one line (kept from the version the owner liked)
LINE = "    proxy_pass backend_server timeout;"
def line_svg():
    X0, CW, CUR = 170, 9.6, 20
    def cx(i): return round(X0 + CW * i + CW / 2, 1)
    rows = [("0", "start of line", 0), ("^", "first character", 4), ("b", "start of word", 15),
            ("e", "end of word", 28), ("w", "next word", 30), ("$", "end of line", 37)]
    parts = []
    for r, (k, lab, t) in enumerate(rows):
        y = 34 + r * 31
        parts.append(f'<text x="8" y="{y}" font-size="17" class="mono" fill="var(--normal)">{html.escape(k)}</text>')
        parts.append(f'<text x="32" y="{y}" font-size="13.5" fill="var(--ink)">{lab}</text>')
        parts.append(f'<rect x="{X0-4}" y="{y-15}" width="{round(CW*len(LINE)+8,1)}" height="21" rx="4" fill="var(--soft)"/>')
        parts.append(f'<rect x="{round(X0+CW*CUR,1)}" y="{y-14}" width="{CW}" height="19" fill="none" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="2 1.5"/>')
        parts.append(f'<rect x="{round(X0+CW*t,1)}" y="{y-14}" width="{CW}" height="19" fill="var(--normal)" opacity=".45"/>')
        parts.append(f'<text x="{X0}" y="{y}" font-size="16" class="mono" fill="var(--ink)" xml:space="preserve" textLength="{round(CW*len(LINE),1)}" lengthAdjust="spacingAndGlyphs">{LINE}</text>')
        sx, tx, top = cx(CUR), cx(t), y - 16
        parts.append(f'<path d="M{sx} {top} Q{(sx+tx)/2} {top-11} {tx} {top}" fill="none" stroke="var(--normal)" stroke-width="1.6" marker-end="url(#ah2)"/>')
    return f'''<svg viewBox="0 0 540 200" role="img" aria-label="Motions on one line, starting with the cursor on the n of backend_server: 0 goes to the start of the line, ^ to the first character, b to the start of the word, e to the end of the word, w to the next word, $ to the end of the line.">
        <defs><marker id="ah2" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0 0 L10 5 L0 10 z" fill="var(--normal)"/></marker></defs>
        {"".join(parts)}
      </svg>'''

# ---------------------------------------------------------------- Vim page: moving through a file
def file_svg():
    stubs = []
    ys = [16, 30, 44, 58, 72, 86, 100, 114, 128, 142, 156, 170, 184, 198, 212, 226, 240, 254, 268, 282]
    widths = [70, 54, 80, 62, 48, 76, 66, 58, 82, 52, 70, 60, 74, 50, 68, 78, 56, 64, 72, 46]
    for y, w in zip(ys, widths):
        stubs.append(f'<line x1="58" y1="{y}" x2="{58+w}" y2="{y}" stroke="var(--line)" stroke-width="3" stroke-linecap="round"/>')
    return f'''<svg viewBox="0 0 330 300" role="img" aria-label="Moving through a file. gg goes to the first line and G to the last. :42 goes to line 42. Ctrl-u and Ctrl-d move the screen half a screen up or down. /word finds the next match below; n goes to the next match and N to the previous one.">
        <defs><marker id="fh" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto"><path d="M0 0 L10 5 L0 10 z" fill="context-stroke"/></marker></defs>
        <rect x="46" y="6" width="112" height="288" rx="6" fill="var(--soft)" stroke="var(--line)"/>
        <g font-size="11" class="mono" fill="var(--muted)" text-anchor="end">
          <text x="40" y="20">1</text><text x="40" y="132">42</text><text x="40" y="286">300</text>
        </g>
        {"".join(stubs)}
        <rect x="50" y="121" width="104" height="14" rx="3" fill="var(--normal-bg)" stroke="var(--normal)"/>
        <rect x="40" y="93" width="124" height="70" rx="5" fill="none" stroke="var(--visual)" stroke-width="1.6" stroke-dasharray="4 3"/>
                <rect x="92" y="221" width="26" height="10" rx="2" fill="var(--command-bg)" stroke="var(--command)"/>
        <rect x="78" y="263" width="26" height="10" rx="2" fill="var(--command-bg)" stroke="var(--command)"/>
        <path d="M90 231 Q70 247 86 263" fill="none" stroke="var(--command)" stroke-width="1.6" marker-end="url(#fh)"/>
        <line x1="170" y1="93" x2="170" y2="60" stroke="var(--visual)" stroke-width="2" marker-end="url(#fh)"/>
        <line x1="170" y1="163" x2="170" y2="196" stroke="var(--visual)" stroke-width="2" marker-end="url(#fh)"/>
        <g stroke="var(--muted)" stroke-width="1" stroke-dasharray="2 3">
          <line x1="160" y1="16" x2="184" y2="16"/><line x1="156" y1="128" x2="184" y2="128"/><line x1="120" y1="226" x2="184" y2="226"/><line x1="160" y1="282" x2="184" y2="282"/>
        </g>
        <g font-size="15" class="mono" fill="var(--ink)">
          <text x="190" y="21">gg</text><text x="190" y="72">Ctrl-u</text><text x="190" y="133">:42</text>
          <text x="190" y="186">Ctrl-d</text><text x="190" y="231">/word</text><text x="190" y="287">G</text>
        </g>
        <g font-size="12.5" fill="var(--muted)">
          <text x="214" y="21">first line</text><text x="190" y="88">half a screen up</text><text x="222" y="133">line 42</text>
          <text x="190" y="202">half a screen down</text><text x="240" y="231">search</text>
          <text x="190" y="248"><tspan class="mono" fill="var(--ink)">n</tspan> next match  <tspan class="mono" fill="var(--ink)">N</tspan> back</text>
          <text x="206" y="287">last line</text>
        </g>
      </svg>'''

# ---------------------------------------------------------------- Vim page: verb + where as before/after
def vb(before, after):
    return f'<code class="before">{before}</code>{A}<code class="after">{after}</code>'
VERBS = [
    (K("dw", "n"), "delete to the next word",
     vb('proxy_pass <span class="cur">b</span><del>ackend_server </del>timeout;', 'proxy_pass timeout;')),
    (K("d$", "n"), "delete to the end of the line",
     vb('proxy_pass <span class="cur">b</span><del>ackend_server timeout;</del>', 'proxy_pass ')),
    (K("dd", "n"), "delete the whole line",
     vb('<del>proxy_pass backend_server timeout;</del>', '<span class="gone">(line removed; p puts it back)</span>')),
    (K("cw", "i") + E("api") + K("Esc", "n"), "change to the end of the word",
     vb('proxy_pass <span class="cur">b</span><mark>ackend_server</mark> timeout;', 'proxy_pass <ins>api</ins> timeout;')),
    (K('ci"', "i") + E("/srv") + K("Esc", "n") + VIMTAG, "change inside the quotes",
     vb('root "/var/<span class="cur">w</span>ww";'.replace('/var/<span class="cur">w</span>ww', '<mark>/var/<span class="cur">w</span>ww</mark>'), 'root "<ins>/srv</ins>";')),
    (K("yy", "n") + K("p", "n"), "copy the line, paste below",
     vb('allow 10.0.0.1;', 'allow 10.0.0.1;<br><ins>allow 10.0.0.1;</ins>')),
]

def verb_rows():
    out = []
    for keys, what, demo in VERBS:
        out.append(f'<div class="vrow"><div class="vkeys">{keys}</div><div class="vwhat">{what}</div><div class="vdemo">{demo}</div></div>')
    return "\n".join(out)

# ---------------------------------------------------------------- tmux page
def tmux_svg():
    return '''<svg viewBox="0 0 720 330" role="img" aria-label="The tmux screen. After C-b: percent splits a pane left and right, double quote top and bottom, o moves to the next pane, the arrow keys to the pane in that direction, z zooms, x closes. The status line lists windows: c makes one, n and p move between them, 0 to 9 jump to one. The session name is on the left: d detaches.">
        <rect x="20" y="16" width="400" height="290" rx="8" fill="var(--soft)" stroke="var(--line)" stroke-width="1.5"/>
        <rect x="26" y="22" width="190" height="248" rx="4" fill="var(--paper)" stroke="var(--line)"/>
        <rect x="222" y="22" width="192" height="120" rx="4" fill="var(--paper)" stroke="var(--line)"/>
        <rect x="222" y="148" width="192" height="122" rx="4" fill="var(--paper)" stroke="var(--pane)" stroke-width="2.5"/>
        <g font-size="12" class="mono" fill="var(--muted)">
          <text x="36" y="44">$ tail -f app.log</text>
          <text x="232" y="44">$ vi nginx.conf</text>
          <text x="232" y="170" fill="var(--ink)">$ ▌</text>
        </g>
        <text x="318" y="236" text-anchor="middle" font-size="13" fill="var(--pane)">current pane</text>
        <rect x="26" y="276" width="388" height="24" rx="3" fill="var(--paper)" stroke="var(--line)"/>
        <rect x="30" y="279" width="62" height="18" rx="3" fill="none" stroke="var(--session)" stroke-width="2"/>
        <text x="61" y="292" text-anchor="middle" font-size="12" class="mono" fill="var(--session)">[work]</text>
        <rect x="100" y="279" width="58" height="18" rx="3" fill="none" stroke="var(--window)" stroke-width="1.2" stroke-dasharray="3 2"/>
        <text x="129" y="292" text-anchor="middle" font-size="12" class="mono" fill="var(--window)">0:zsh</text>
        <rect x="164" y="279" width="66" height="18" rx="3" fill="var(--window)" opacity=".18"/>
        <rect x="164" y="279" width="66" height="18" rx="3" fill="none" stroke="var(--window)" stroke-width="2"/>
        <text x="197" y="292" text-anchor="middle" font-size="12" class="mono" fill="var(--ink)">1:logs*</text>
        <g stroke="var(--muted)" stroke-width="1" fill="none">
          <polyline points="219,90 236,90 236,62 440,62"/>
          <polyline points="320,145 440,145 440,120"/>
          <polyline points="414,180 440,180"/>
          <polyline points="230,288 440,288 440,262"/>
          <polyline points="61,300 61,318 440,318"/>
        </g>
        <g font-size="15" fill="var(--ink)">
          <text x="448" y="57"><tspan class="mono" font-size="17">%</tspan>   split left | right</text>
          <text x="448" y="115"><tspan class="mono" font-size="17">"</tspan>   split top / bottom</text>
          <text x="448" y="173"><tspan class="mono" font-size="17" fill="var(--pane)">o</tspan>   next pane</text>
          <text x="448" y="193" font-size="13.5">arrow keys  that direction</text>
          <text x="448" y="212" font-size="13.5"><tspan class="mono">z</tspan>  zoom in or out</text>
          <text x="448" y="231" font-size="13.5"><tspan class="mono">x</tspan>  close the pane</text>
          <text x="448" y="257"><tspan class="mono" font-size="17" fill="var(--window)">c</tspan>   new window</text>
          <text x="448" y="277" font-size="13.5"><tspan class="mono">n</tspan> next  <tspan class="mono">p</tspan> previous  <tspan class="mono">0…9</tspan> jump</text>
          <text x="448" y="315"><tspan class="mono" font-size="17" fill="var(--session)">d</tspan>   detach, it keeps running</text>
        </g>
      </svg>'''

def ssh_svg():
    return '''<svg viewBox="0 0 300 300" role="img" aria-label="ssh in and start tmux with tmux new -s work. Detach with C-b d, or lose the connection: the work keeps running on the server. ssh in again and tmux a -t work brings it back.">
        <defs><marker id="ah3" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto"><path d="M0 0 L10 5 L0 10 z" fill="var(--muted)"/></marker></defs>
        <rect x="10" y="6" width="280" height="40" rx="8" fill="var(--soft)"/>
        <text x="22" y="31" font-size="14" class="mono" fill="var(--ink)">ssh server</text>
        <rect x="10" y="68" width="280" height="40" rx="8" fill="var(--soft)" stroke="var(--session)" stroke-width="2"/>
        <text x="22" y="93" font-size="14" class="mono" fill="var(--ink)">tmux new -s work</text><text x="184" y="93" font-size="12.5" fill="var(--muted)">start, named work</text>
        <rect x="10" y="130" width="280" height="40" rx="8" fill="var(--soft)"/>
        <text x="22" y="148" font-size="12.5" fill="var(--muted)"><tspan class="mono" font-size="14" fill="var(--session)">C-b d</tspan>  or the connection drops</text>
        <text x="22" y="164" font-size="12.5" fill="var(--muted)">the work keeps running on the server</text>
        <rect x="10" y="192" width="280" height="40" rx="8" fill="var(--soft)"/>
        <text x="22" y="210" font-size="12.5" fill="var(--muted)">ssh in again, then</text>
        <text x="22" y="226" font-size="14" class="mono" fill="var(--ink)">tmux ls</text><text x="96" y="226" font-size="12.5" fill="var(--muted)">list the sessions</text>
        <rect x="10" y="254" width="280" height="40" rx="8" fill="var(--soft)" stroke="var(--session)" stroke-width="2"/>
        <text x="22" y="279" font-size="14" class="mono" fill="var(--ink)">tmux a -t work</text><text x="170" y="279" font-size="12.5" fill="var(--muted)">back where you were</text>
        <g stroke="var(--muted)" stroke-width="1.5">
          <line x1="150" y1="46" x2="150" y2="66" marker-end="url(#ah3)"/><line x1="150" y1="108" x2="150" y2="128" marker-end="url(#ah3)"/>
          <line x1="150" y1="170" x2="150" y2="190" marker-end="url(#ah3)"/><line x1="150" y1="232" x2="150" y2="252" marker-end="url(#ah3)"/>
        </g>
      </svg>'''

# ---------------------------------------------------------------- recipes
def BA(before, after):
    return f'<div class="ba"><span>before</span><code>{before}</code><span>after</span><code>{after}</code></div>'
def R(title, steps, why, ba="", vim=False):
    v = VIMTAG if vim else ""
    return f'<article class="recipe"><h4>{title}{v}</h4><div class="strip">{steps}</div>{ba}<p class="why">{why}</p></article>'


# ---------------------------------------------------------------- Vim modes page: where typing starts, what gets selected
def mini(lines): return '<code class="mini">' + lines + '</code>'
def SEL(t): return f'<span class="vsel">{t}</span>'
INSERT_ROWS = [
    ("i", "before the cursor", mini("  listen " + CI() + "80;")),
    ("a", "after the cursor", mini("  listen 8" + CI() + "0;")),
    ("I", "at the start of the line", mini("  " + CI() + "listen 80;")),
    ("A", "at the end of the line", mini("  listen 80;" + CI())),
    ("o", "on a new line below", mini("  listen 80;\n  " + CI() + "\n}")),
    ("O", "on a new line above", mini("server {\n  " + CI() + "\n  listen 80;")),
]
VISUAL_ROWS = [
    ("v", "characters, from the cursor to where you move", mini("listen " + SEL("80;") + "\n" + SEL("listen 4") + "43;")),
    ("V", "whole lines", mini(SEL("listen 80;") + "\n" + SEL("listen 443;"))),
    ("Ctrl-v", "a block of columns", mini("listen " + SEL("80") + ";\nlisten " + SEL("44") + "3;")),
]
def key_rows(rows, mode):
    out = []
    for k, what, demo in rows:
        out.append(f'<div class="krow"><span class="k {mode} kk">{k}</span><span class="kwhat">{what}</span>{demo}</div>')
    return '<div class="krows">' + "".join(out) + '</div>'

# ---------------------------------------------------------------- tmux page: copy storyboard
LOG = ["12:01 GET /health 200", "12:02 ERROR db timeout", "12:02 retry 1", "12:03 GET /api 200"]
def copy_story():
    def body(cursor_line=None, sel=False, prompt=False):
        lines = []
        for i, ln in enumerate(LOG):
            if sel and i == 1:
                ln = '12:02 <span class="sel">ERROR db timeout</span>'
            elif cursor_line == i:
                ln = ln[:6] + CB(ln[6]) + ln[7:]
            lines.append(ln)
        lines.append("$ " + ('<span class="paste">ERROR db timeout</span>' if prompt else "") + CI() if prompt else "$ ")
        return "\n".join(lines)
    frames = [
        ("C-b [", "enter copy mode", tscr([body() ], '<span class="pos">[0/120]</span>', cls="copy"), "top right shows where you are"),
        ("k  /ERROR", "move to the text", tscr([body(cursor_line=1)], '<span class="pos">[2/120]</span>', cls="copy"), "Ctrl-u Ctrl-d page, / searches"),
        ("Space  $", "select it", tscr([body(sel=True)], '<span class="pos">[2/120]</span>', cls="copy"), "Space starts, motions extend"),
        ("Enter  C-b ]", "copy, then paste", tscr([body(prompt=True)], "<b>[0]</b> 0:bash*"), "Enter copies and leaves; C-b ] pastes"),
    ]
    out = []
    for n, (keys, what, frame, note) in enumerate(frames, 1):
        out.append(f'<figure class="frame"><figcaption><b>{n}</b> <span class="k">{keys}</span> {what}</figcaption>{frame}<p class="cap">{note}</p></figure>')
    return '<div class="story">' + "".join(out) + '</div>'

# ---------------------------------------------------------------- recipes with screens
def R2(title, steps, visual, why, vim=False):
    v = VIMTAG if vim else ""
    return f'<article class="recipe"><h4>{title}{v}</h4><div class="strip">{steps}</div>{visual}<p class="why">{why}</p></article>'

def ins(t): return f'<ins>{t}</ins>'
def dl(t): return f'<del>{t}</del>'
def vs(t): return f'<span class="vsel">{t}</span>'

VIM_RECIPES = [
    R2("Change a value",
       K("vi redis.conf") + A + K("/maxclients", "c") + K("Enter", "n") + A + K("w", "n") + K("cw", "i") + E("20000") + K("Esc", "n") + A + K(":wq", "c"),
       pair(scr("port 6379\n" + CB("m") + "axclients 10000\nsave 900 1", "/maxclients", "cmd"),
            scr("port 6379\nmaxclients " + ins("20000") + "\nsave 900 1", '"redis.conf" written')),
       "w steps from the name onto the value; cw replaces just that word."),
    R2("Comment out a line",
       K("/listen 80", "c") + K("Enter", "n") + A + K("I", "i") + E("#") + K("Esc", "n") + A + K(":wq", "c"),
       pair(scr("server {\n  " + CB("l") + "isten 80;\n}", "/listen 80", "cmd"),
            scr("server {\n  " + ins("# ") + "listen 80;\n}", '"site.conf" written')),
       "I types at the start of the line, wherever the cursor is."),
    R2("Comment out several lines",
       K("Ctrl-v", "v") + K("jj", "v") + A + K("I", "i") + E("#") + K("Esc", "n"),
       pair(scr(vs("l") + "isten 80;\n" + vs("l") + "isten 443;\n" + vs("s") + "erver_name a;", "-- VISUAL BLOCK --", "vis"),
            scr(ins("#") + "listen 80;\n" + ins("#") + "listen 443;\n" + ins("#") + "server_name a;", "")),
       "Ctrl-v selects a column; text typed after I lands on every line when you press Esc.", vim=True),
    R2("Copy a line, then edit the copy",
       K("yy", "n") + K("p", "n") + A + K("w", "n") + K("C", "i") + E("10.0.0.2;") + K("Esc", "n"),
       pair(scr(CB("a") + "llow 10.0.0.1;\ndeny all;", ""),
            scr("allow 10.0.0.1;\nallow " + ins("10.0.0.2;") + "\ndeny all;", "")),
       "p pastes below (P above). C replaces to the end of the line."),
    R2("Delete lines",
       K("3dd", "n") + E("3 lines from the cursor") + E("or") + K(":2,4d", "c"),
       pair(scr("a = 1\n" + dl(CB("b") + " = 2") + "\n" + dl("c = 3") + "\n" + dl("d = 4") + "\ne = 5", ""),
            scr("a = 1\n" + CB("e") + " = 5", "3 fewer lines")),
       "Vim reports how many lines went. p puts them back below."),
    R2("Replace everywhere, one at a time",
       K(":%s/old/new/gc", "c") + K("Enter", "n") + A + E("each match:") + K("y", "n") + E("or") + K("n", "n"),
       pair(scr("host = <span class=\"vsel\">old</span>.lan\nbackup = old.lan", "replace with new (y/n)?", "cmd"),
            scr("host = " + ins("new") + ".lan\nbackup = " + ins("new") + ".lan", "2 substitutions")),
       "% every line, g every match on a line, c asks each time."),
    R2("Read a log from the end",
       K("view app.log") + A + K("G", "n") + K("?ERROR", "c") + K("Enter", "n") + A + K("n", "n") + E("older"),
       pair(scr("12:01 ERROR disk full\n12:05 ok\n12:09 " + CB("E") + "RROR timeout\n12:10 ok", "?ERROR", "cmd"),
            scr("12:01 " + CB("E") + "RROR disk full\n12:05 ok\n12:09 ERROR timeout\n12:10 ok", "?ERROR", "cmd")),
       "view is read-only. ? searches upwards, so n goes further back. :q leaves."),
    R2("Saved, but no permission",
       K(":w !sudo tee % &gt;/dev/null", "c") + K("Enter", "n") + A + K("L", "n"),
       pair(scr("127.0.0.1 localhost\n10.0.0.5 db", "E212: Can't open file", "err"),
            scr("127.0.0.1 localhost\n10.0.0.5 db", "W12: changed (L)oad", "cmd")),
       "For a root file opened without sudo. L loads the version you just saved.", vim=True),
    R2("Throw your changes away",
       K(":q", "c") + E("refused?") + A + K(":e!", "c") + E("or") + K(":q!", "c"),
       pair(scr("port = " + ins("9999") + "\nmode = prod", "E37: No write since…", "err"),
            scr("port = 8080\nmode = prod", ':e! reloaded "app.ini"')),
       ":e! goes back to the saved file; :q! leaves without saving. The disk is untouched."),
]

def tbody(*lines): return "\n".join(lines)
BAR0 = '<b>[0]</b> 0:bash*'
TMUX_RECIPES = [
    R2("A job that survives logout",
       K("tmux new -s deploy") + A + E("start the job") + A + K("C-b d") + A + E("later") + K("tmux a -t deploy"),
       pair(tscr([tbody("$ ./deploy.sh", "uploading… 42%")], '<b>[deploy]</b> 0:bash*'),
            tscr([tbody("$ tmux a -t deploy", "", "uploading… 87%")], '<b>[deploy]</b> 0:bash*')),
       "In between, the shell said [detached (from session deploy)] and the job kept running."),
    R2("Edit while watching the log",
       K("C-b %") + A + K("tail -f app.log") + A + K("C-b o") + A + K("vi app.conf"),
       pair(tscr([tbody("$ " + CI())], BAR0),
            tscr([tbody("12:01 GET /", "12:02 ERROR", "12:02 retry"), tbody("port = 80", "mode = prod")], BAR0)),
       "C-b o jumps between the panes; C-b z zooms the one you are in."),
    R2("Copy an error from the scrollback",
       K("C-b [") + K("?ERROR") + K("Enter") + A + K("Space") + K("$") + K("Enter") + A + K("C-b ]"),
       pair(tscr([tbody("12:01 GET /", '12:02 <span class="sel">ERROR db timeout</span>', "$ ")], '<span class="pos">[2/120]</span>'),
            tscr([tbody("12:01 GET /", "12:02 ERROR db timeout", '$ <span class="paste">ERROR db timeout</span>' + CI())], BAR0)),
       "The same steps as on the tmux page, ending at your prompt."),
    R2("Type in every pane at once",
       K("C-b :") + E("setw synchronize-panes on") + A + E("type once") + A + E("… off"),
       pair(tscr([tbody("web1 $ "), tbody("web2 $ "), tbody("web3 $ " + CI())], BAR0, cols="1fr 1fr 1fr"),
            tscr([tbody("web1 $ uptime"), tbody("web2 $ uptime"), tbody("web3 $ uptime" + CI())], BAR0, cols="1fr 1fr 1fr")),
       "Each pane has its own ssh session; what you type goes to all of them."),
    R2("Name things so you find them",
       K("C-b $") + E("session") + K("C-b ,") + E("window") + A + K("C-b w") + E("pick one"),
       pair(tscr([tbody("$ " + CI())], '<b>[0]</b> 0:bash 1:bash*'),
            tscr([tbody("$ " + CI())], '<b>[deploy]</b> 0:api 1:logs*')),
       "tmux ls and C-b s show these names, so you attach to the right one."),
    R2("Close what you no longer need",
       K("C-b x") + E("then") + K("y") + E("pane") + A + K("C-b &amp;") + E("window"),
       pair(tscr([tbody("logs"), tbody("vi " + CI())], 'kill-pane 1? (y/n)'),
            tscr([tbody("logs" + CI())], BAR0)),
       "exit in the last pane of a window closes the window too. tmux kill-session -t old ends a session."),
]

# ---------------------------------------------------------------- page assembly
def page(id_, title, lead, body):
    return f'''<div class="scroll"><div class="sheet">
<section class="page" id="{id_}" aria-labelledby="{id_}-h">
  <header class="ph"><h2 id="{id_}-h">{title}</h2><p>{lead}</p></header>
{body}
</section>
</div></div>'''

vim_body = f'''  <div class="g modesgrid">
    <div class="cell area-a"><h3>The modes <small>Vim opens in Normal. Lost? Press Esc twice.</small></h3>
      {modes_svg()}
    </div>
    <div class="cell area-b"><h3>Where typing starts <small>Insert mode · cursor on the 8 of <code>  listen 80;</code></small></h3>
      {key_rows(INSERT_ROWS, "i")}
      <p class="cap">The pink bar is where your text goes. Press <span class="k n">Esc</span> when you are done.</p>
    </div>
    <div class="cell area-c"><h3>What gets selected <small>Visual mode · start on the 8, then press <span class="k n">j</span></small></h3>
      {key_rows(VISUAL_ROWS, "v")}
      <p class="cap">Then act on the selection: <span class="k n">d</span> delete · <span class="k n">y</span> copy · <span class="k i">c</span> change · <span class="k n">&gt;</span> indent. <span class="k n">Esc</span> cancels.</p>
    </div>
    <div class="cell area-d"><h3>Quit and undo</h3>
      <div class="ess">
        <div class="c"><b>:wq</b><span>save and quit</span></div>
        <div class="c"><b>:q!</b><span>quit without saving</span></div>
        <div class="n"><b>u</b><span>undo</span></div>
        <div class="n"><b>Ctrl-r</b><span>redo</span></div>
      </div>
      <p class="cap">On a bare server <kbd>vi</kbd> is often minimal: arrow keys in Insert mode type letters, so press Esc and use h j k l. Keys marked {VIMTAG} need Vim, not busybox vi.</p>
      <div class="mac"><h4>Only on this Mac</h4><p><span class="k">Esc</span> also switches to English input · <span class="k">Space</span>+<span class="k">/</span> opens this sheet · <kbd>vimtutor</kbd> is a 30-minute lesson</p></div>
    </div>
  </div>'''

move_body = f'''  <div class="g movegrid">
    <figure class="cell area-a"><h3>Moving along a line <small>dashed: where the cursor starts · green: where the key takes it</small></h3>
      {line_svg()}
      <p class="cap"><b>h j k l</b> move one step left, down, up, right. <span class="k n">f</span><kbd>x</kbd> jumps to the next x on the line and <span class="k n">;</span> repeats it. A number repeats a motion: <span class="k n">3w</span> is three words on.</p>
    </figure>
    <div class="cell area-b"><h3>Moving through a file <small>blue dashes: the part on screen</small></h3>
      {file_svg()}
    </div>
    <div class="cell area-c"><h3>Verb + where <small>delete <span class="k">d</span> · change <span class="k">c</span> · copy <span class="k">y</span>, then a motion. The same key twice means the whole line.</small></h3>
      <div class="verbs">
{verb_rows()}
      </div>
      <p class="cap"><span class="k n">p</span> pastes what was deleted or copied · <span class="k n">x</span> deletes one character · <span class="k n">.</span> repeats the last change · <span class="k n">u</span> undoes it</p>
    </div>
    <div class="cell area-d"><h3>Also worth knowing <small>the rest of vimtutor's first chapter that helps on a server</small></h3>
      <div class="ess seven">
        <div class="n"><b>r<em>x</em></b><span>replace one char</span></div>
        <div class="n"><b>%</b><span>matching bracket</span></div>
        <div class="c"><b>:s/a/b/g</b><span>this line only</span></div>
        <div class="c"><b>:w x.bak</b><span>save a copy</span></div>
        <div class="n"><b>Ctrl-g</b><span>where am I?</span></div>
        <div class="c"><b>:e Tab</b><span>complete a name</span></div>
        <div class="c"><b>:help w</b><span>help; :q closes</span></div>
      </div>
    </div>
  </div>'''

tmux_body = f'''  <div class="g tmuxgrid">
    <figure class="cell area-a"><h3>Press <span class="k pre">C-b</span>, let go, then one key</h3>
      {tmux_svg()}
    </figure>
    <figure class="cell area-b"><h3>When ssh drops, nothing is lost</h3>
      {ssh_svg()}
    </figure>
    <div class="cell area-c"><h3>Scroll back and copy <small>q leaves copy mode without copying</small></h3>
      {copy_story()}
    </div>
    <div class="cell area-d"><h3>When you are stuck <small>after <span class="k pre">C-b</span></small></h3>
      <div class="ess three">
        <div><b>?</b><span>every key (q closes)</span></div>
        <div><b>/</b><span>what the next key does (3.1+)</span></div>
        <div><b>:</b><span>type a tmux command</span></div>
      </div>
      <p class="cap">Nothing responds? You are in copy mode or a menu: press <span class="k">q</span> or <span class="k">Esc</span>. To reach a tmux opened inside this one, press <span class="k pre">C-b</span> twice.</p>
    </div>
    <div class="cell area-e mac"><h4>Only on this Mac: no C-b needed</h4><p><span class="k">Opt+hjkl</span> move between panes · <span class="k">Opt+1…9</span> go to a window · <span class="k">Opt+n</span> new window · <span class="k">Opt+z</span> zoom · <span class="k">Opt+/</span> short key list · <span class="k">Space</span>+<span class="k">/</span> this sheet · the bottom line of tmux lists the keys you can press next</p></div>
  </div>'''

vim_recipes_body = f'''  <div class="g recipes r3">
    {"".join(VIM_RECIPES)}
  </div>'''
tmux_recipes_body = f'''  <div class="g recipes t3">
    {"".join(TMUX_RECIPES)}
  </div>'''

CSS = open(__file__.replace("build.py", "style.css")).read()

doc = f'''<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Vim and tmux map</title>
<!--
  Five A4 landscape pages that look the same on screen and on paper
  (just cheatsheet-pdf): Vim modes, Vim moving and editing, tmux, Vim recipes, tmux recipes. Sizes are in
  cqw (a share of the page width), so the screen shows the printed page scaled.
  Colour means mode in Vim (normal, insert, visual, command) and level in tmux
  (session, window, pane). Dashed boxes are Mac-only; everything else works on
  a bare server. "vim" marks keys that need Vim rather than a minimal vi.
-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible:wght@400;700&family=JetBrains+Mono:wght@500;700&display=swap">
<style>
{CSS}
</style>
</head>
<body>
<nav class="nav"><h1>Vim and tmux map</h1><a href="#vim">Vim modes</a><a href="#vim-move">Vim moving</a><a href="#tmux">tmux</a><a href="#vim-recipes">Vim recipes</a><a href="#tmux-recipes">tmux recipes</a><p>Each page is one A4 landscape sheet: <kbd>just cheatsheet-pdf</kbd>.</p></nav>
{page("vim", "Vim: modes", "Colour shows the mode. Check you are in Normal mode (green) before you type a command.", vim_body)}
{page("vim-move", "Vim: moving and editing", "All of these keys work in Normal mode (green).", move_body)}
{page("tmux", "tmux", 'Colour shows the level: <span style="color:var(--session)">session</span> ⊃ <span style="color:var(--window)">window</span> ⊃ <span style="color:var(--pane)">pane</span>.', tmux_body)}
{page("vim-recipes", "Vim recipes", "Real tasks, key by key. Each key is coloured by the mode it leaves you in; grey means type it as shown. Start in Normal mode.", vim_recipes_body)}
{page("tmux-recipes", "tmux recipes", "Real tasks, key by key. <span class=\"k pre\">C-b …</span> means press C-b, let go, then the key.", tmux_recipes_body)}
</body>
</html>
'''
open(OUT, "w").write(doc)
