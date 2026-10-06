#!/usr/bin/env python3
"""Builds cheatsheet/index.html: four A4 landscape pages, identical on screen and paper.

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
def modes_svg():
    rows = [
        ("i  a  o", "INSERT", "type text", "Esc", "insert", "i before the cursor, a after it, o on a new line below"),
        ("v  V", "VISUAL", "select text", "Esc  or  d / y", "visual", "v selects characters, V whole lines; d deletes them, y copies"),
        (":", "COMMAND", ":w  :q  :42", "Enter / Esc", "command", "Enter runs the command, Esc cancels it"),
    ]
    out = []
    for r, (enter, name, inside, leave, cls, note) in enumerate(rows):
        y = 8 + r * 78
        cy = y + 21
        out.append(f'<rect x="2" y="{y}" width="78" height="42" rx="10" fill="var(--normal-bg)" stroke="var(--normal)" stroke-width="2"/>')
        out.append(f'<text x="41" y="{cy+5}" text-anchor="middle" font-size="13" font-weight="700" fill="var(--ink)">NORMAL</text>')
        out.append(f'<line x1="82" y1="{cy}" x2="182" y2="{cy}" stroke="var(--{cls})" stroke-width="2.4" marker-end="url(#mh)"/>')
        out.append(f'<text x="131" y="{cy-8}" text-anchor="middle" font-size="16" class="mono" fill="var(--ink)">{html.escape(enter)}</text>')
        out.append(f'<rect x="186" y="{y}" width="128" height="42" rx="10" fill="var(--{cls}-bg)" stroke="var(--{cls})" stroke-width="2"/>')
        out.append(f'<text x="250" y="{cy-2}" text-anchor="middle" font-size="14" font-weight="700" fill="var(--ink)">{name}</text>')
        out.append(f'<text x="250" y="{cy+14}" text-anchor="middle" font-size="12" class="{"mono" if cls=="command" else ""}" fill="var(--ink)">{html.escape(inside)}</text>')
        out.append(f'<line x1="316" y1="{cy}" x2="434" y2="{cy}" stroke="var(--normal)" stroke-width="2.4" marker-end="url(#mh)"/>')
        out.append(f'<text x="375" y="{cy-8}" text-anchor="middle" font-size="14" class="mono" fill="var(--ink)">{html.escape(leave)}</text>')
        out.append(f'<rect x="438" y="{y}" width="78" height="42" rx="10" fill="var(--normal-bg)" stroke="var(--normal)" stroke-width="2"/>')
        out.append(f'<text x="477" y="{cy+5}" text-anchor="middle" font-size="13" font-weight="700" fill="var(--ink)">NORMAL</text>')
        out.append(f'<text x="2" y="{y+60}" font-size="12.5" fill="var(--muted)">{html.escape(note)}</text>')
    return f'''<svg viewBox="0 0 520 236" role="img" aria-label="Vim starts in Normal mode. i, a or o goes to Insert mode and Esc comes back. v or V goes to Visual mode; Esc, d or y comes back. A colon goes to Command mode; Enter runs the command and Esc cancels, both come back to Normal.">
        <defs><marker id="mh" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto"><path d="M0 0 L10 5 L0 10 z" fill="context-stroke"/></marker></defs>
        {"".join(out)}
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

VIM_RECIPES = [
    R("Change a value", K("vi nginx.conf") + A + K("/worker_conn", "c") + K("Enter", "n") + A + K("w", "n") + K("cw", "i") + E("2048") + K("Esc", "n") + A + K(":wq", "c"),
      "w steps from the name onto the value; cw replaces just that word.",
      BA('worker_connections <mark>1024</mark>;', 'worker_connections <ins>2048</ins>;')),
    R("Comment out a line", K("/listen 80", "c") + K("Enter", "n") + A + K("I", "i") + E("#") + K("Esc", "n") + A + K(":wq", "c"),
      "I types at the start of the line, wherever the cursor is.",
      BA('    listen 80;', '    <ins>#</ins> listen 80;')),
    R("Comment out several lines", K("Ctrl-v", "v") + K("jjj", "v") + A + K("I", "i") + E("#") + K("Esc", "n"),
      "Ctrl-v selects a column. What you type after I appears on every line when you press Esc.",
      BA('listen 80;<br>listen 443;<br>server_name old;', '<ins>#</ins>listen 80;<br><ins>#</ins>listen 443;<br><ins>#</ins>server_name old;'), vim=True),
    R("Copy a line, then edit the copy", K("yy", "n") + K("p", "n") + A + K("w", "n") + K("C", "i") + E("10.0.0.2;") + K("Esc", "n"),
      "p pastes below the cursor, P above. C replaces everything to the end of the line.",
      BA('allow 10.0.0.1;', 'allow 10.0.0.1;<br>allow <ins>10.0.0.2;</ins>')),
    R("Delete lines", K("5dd", "n") + E("5 lines from here") + E("or") + K(":10,20d", "c") + E("lines 10–20"),
      "Line numbers help here: :set nu shows them."),
    R("Replace everywhere, one at a time", K(":%s/old/new/gc", "c") + K("Enter", "n") + A + E("answer") + K("y", "n") + E("or") + K("n", "n"),
      "% means every line, g every match on a line, c asks each time. Without c, all are replaced at once."),
    R("Read a log from the end", K("view app.log") + A + K("G", "n") + K("?ERROR", "c") + K("Enter", "n") + A + K("n", "n") + E("older") + K("N", "n") + E("newer"),
      "view opens read-only. ? searches upwards, so n keeps going back in time. Leave with :q."),
    R("Saved, but no permission", K(":w !sudo tee % &gt;/dev/null", "c") + K("Enter", "n") + A + K("L", "n"),
      "For a root file opened without sudo. Vim then warns that the file changed: L loads the saved version.", vim=True),
    R("Throw your changes away", K(":e!", "c") + E("back to the saved file") + E("or") + K(":q!", "c") + E("just leave"),
      "Nothing reaches the disk until :w, so the file is untouched either way."),
]

TMUX_RECIPES = [
    R("A job that survives logout", K("tmux new -s deploy") + A + E("start the job") + A + K("C-b d") + A + E("later") + K("tmux a -t deploy"),
      "The job keeps running on the server after you detach or the connection drops."),
    R("Edit while watching the log", K("C-b %") + A + K("tail -f app.log") + A + K("C-b o") + A + K("vi app.conf"),
      "C-b o switches between the two panes; C-b z zooms the one you are in."),
    R("Copy an error from the scrollback", K("C-b [") + K("?error") + K("Enter") + A + K("Space") + K("$") + K("Enter") + A + K("C-b ]"),
      "With vi keys: Space starts the selection, $ extends it to the line end, Enter copies, C-b ] pastes."),
    R("Type in every pane at once", K("C-b :") + E("setw synchronize-panes on") + A + E("type") + A + E("… off"),
      "Runs the same command on several servers, each ssh-ed in its own pane."),
    R("Name things so you find them", K("C-b ,") + E("window") + K("C-b $") + E("session") + A + K("C-b w") + E("pick one"),
      "tmux ls and C-b s show the names too."),
    R("Close what you no longer need", K("C-b x") + E("pane") + K("C-b &amp;") + E("window") + E("then") + K("y") + A + K("tmux kill-session -t old"),
      "Typing exit in the last pane of a window closes the window as well."),
]

# ---------------------------------------------------------------- page assembly
def page(id_, title, lead, body):
    return f'''<div class="scroll"><div class="sheet">
<section class="page" id="{id_}" aria-labelledby="{id_}-h">
  <header class="ph"><h2 id="{id_}-h">{title}</h2><p>{lead}</p></header>
{body}
</section>
</div></div>'''

vim_body = f'''  <div class="g vimgrid">
    <div class="cell area-a"><h3>The modes <small>Vim opens in Normal. Lost? Press Esc twice.</small></h3>
      {modes_svg()}
      <h3>Quit and undo</h3>
      <div class="ess four">
        <div class="c"><b>:wq</b><span>save and quit</span></div>
        <div class="c"><b>:q!</b><span>quit without saving</span></div>
        <div class="n"><b>u</b><span>undo</span></div>
        <div class="n"><b>Ctrl-r</b><span>redo</span></div>
      </div>
    </div>
    <figure class="cell area-b"><h3>Moving along a line <small>dashed: where the cursor starts · green: where the key takes it</small></h3>
      {line_svg()}
      <p class="cap"><b>h j k l</b> move one step left, down, up, right. <span class="k n">f</span><kbd>x</kbd> jumps to the next x on the line and <span class="k n">;</span> repeats it. A number repeats a motion: <span class="k n">3w</span> is three words on.</p>
      <p class="cap">On a bare server <kbd>vi</kbd> is often minimal: arrow keys in Insert mode type letters, so press Esc and use h j k l. Keys marked {VIMTAG} need Vim, not busybox vi.</p>
      <div class="mac"><h4>Only on this Mac</h4><p><span class="k">Esc</span> also switches to English input · <span class="k">Space</span>+<span class="k">/</span> opens this sheet · <kbd>vimtutor</kbd> is a 30-minute lesson</p></div>
    </figure>
    <div class="cell area-c"><h3>Verb + where <small>delete <span class="k">d</span> · change <span class="k">c</span> · copy <span class="k">y</span>, then a motion. The same key twice means the whole line.</small></h3>
      <div class="verbs">
{verb_rows()}
      </div>
      <p class="cap"><span class="k n">p</span> pastes what was deleted or copied · <span class="k n">x</span> deletes one character · <span class="k n">.</span> repeats the last change · <span class="k n">u</span> undoes it</p>
    </div>
    <div class="cell area-d"><h3>Moving through a file <small>blue dashes: the part on screen</small></h3>
      {file_svg()}
    </div>
  </div>'''

tmux_body = f'''  <div class="g tmuxgrid">
    <figure class="cell area-a"><h3>Press <span class="k pre">C-b</span>, let go, then one key</h3>
      {tmux_svg()}
    </figure>
    <figure class="cell area-b"><h3>When ssh drops, nothing is lost</h3>
      {ssh_svg()}
    </figure>
    <div class="cell area-c"><h3>Scroll back and copy</h3>
      <div class="strip big">{K("C-b [", "pre")}{A}{E("move")}{K("Ctrl-u")}{K("Ctrl-d")}{K("/word")}{A}{K("Space")}{E("start selecting")}{A}{K("Enter")}{E("copy")}{A}{K("C-b ]", "pre")}{E("paste")}</div>
      <p class="cap">Press <span class="k">q</span> to leave without copying. A server's tmux uses these vi keys only if EDITOR or VISUAL contained vi when it started; switch with <kbd>C-b :</kbd> <kbd>setw -g mode-keys vi</kbd>.</p>
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
  Four A4 landscape pages that look the same on screen and on paper
  (just cheatsheet-pdf): Vim, tmux, Vim recipes, tmux recipes. Sizes are in
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
<nav class="nav"><h1>Vim and tmux map</h1><a href="#vim">Vim</a><a href="#tmux">tmux</a><a href="#vim-recipes">Vim recipes</a><a href="#tmux-recipes">tmux recipes</a><p>Each page is one A4 landscape sheet: <kbd>just cheatsheet-pdf</kbd>.</p></nav>
{page("vim", "Vim", "Colour shows the mode. Check you are in Normal mode (green) before you type a command.", vim_body)}
{page("tmux", "tmux", 'Colour shows the level: <span style="color:var(--session)">session</span> ⊃ <span style="color:var(--window)">window</span> ⊃ <span style="color:var(--pane)">pane</span>.', tmux_body)}
{page("vim-recipes", "Vim recipes", "Real tasks, key by key. Each key is coloured by the mode it leaves you in; grey means type it as shown. Start in Normal mode.", vim_recipes_body)}
{page("tmux-recipes", "tmux recipes", "Real tasks, key by key. <span class=\"k pre\">C-b …</span> means press C-b, let go, then the key.", tmux_recipes_body)}
</body>
</html>
'''
open(OUT, "w").write(doc)
