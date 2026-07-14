#!/usr/bin/env bash
# tmux help popup — invoked by Ctrl-a /
# Uses 'less' so the cheat sheet is scrollable and q closes it naturally.

B='\033[1m'       # bold
C='\033[1;34m'    # bold blue (section headers)
R='\033[0m'       # reset
D='\033[2m'       # dim

help=$(printf "
${C}── Panes ───────────────────────────────────────${R}
  ${B}|${R}         Split vertical (side-by-side)
  ${B}-${R}         Split horizontal (stacked)
  ${B}h/j/k/l${R}   Move between panes (vim-style)
  ${B}H/J/K/L${R}   Resize pane (repeatable)
  ${B}z${R}         Zoom pane fullscreen (toggle)
  ${B}q${R}         Flash pane numbers; press number to jump
  ${B}x${R}         Kill pane
  ${B}Tab${R}       Cycle panes forward
  ${B}{ / }${R}     Swap pane left / right

${C}── Windows ─────────────────────────────────────${R}
  ${B}c${R}         New window (opens in current dir)
  ${B}n / p${R}     Next / previous window
  ${B}Space${R}     Last used window
  ${B}< / >${R}     Move window left / right (repeatable)
  ${B},${R}         Rename window
  ${B}&${R}         Kill window
  ${B}1-9${R}       Jump to window by number

${C}── Sessions ────────────────────────────────────${R}
  ${B}s${R}         Session tree picker
  ${B}S${R}         Create new named session
  ${B}\$${R}         Rename current session
  ${B}d${R}         Detach (session stays alive)
  ${B}X${R}         Kill current session

${C}── Layouts ─────────────────────────────────────${R}
  ${B}M-1${R}       main-vertical  (nvim left, panes right)
  ${B}M-2${R}       main-horizontal
  ${B}M-3${R}       even-horizontal
  ${B}M-4${R}       even-vertical
  ${B}G${R}         Quick split: nvim + 40-col right pane

${C}── Copy mode  (prefix+Enter to enter) ──────────${R}
  ${B}v${R}         Begin selection
  ${B}V${R}         Select whole line
  ${B}C-v${R}       Rectangle selection
  ${B}y${R}         Yank to system clipboard
  ${B}C-u / C-d${R} Half-page up / down
  ${B}/ / ?${R}     Search forward / backward
  ${B}n / N${R}     Next / previous search match
  ${B}Escape${R}    Exit copy mode

${C}── Pane utilities ──────────────────────────────${R}
  ${B}b${R}         Break pane into its own window
  ${B}@${R}         Pull a pane from another window into this one
  ${B}C-s${R}       Save pane scrollback to ~/tmux-capture.txt
  ${B}Y${R}         Toggle synchronize-panes (type in all panes at once)

${C}── Scratchpad ───────────────────────────────────${R}
  ${B}t${R}         Toggle floating scratch terminal (Ctrl-d to close)

${C}── Misc ─────────────────────────────────────────${R}
  ${B}r${R}         Reload tmux.conf
  ${B}P${R}         Paste from system clipboard
  ${B}/${R}         This help popup
  ${B}?${R}         List ALL bindings (built-in, verbose)

${D}  q or Escape to close${R}
")

echo -e "$help" | less -R --prompt="  tmux keys — q to close"
