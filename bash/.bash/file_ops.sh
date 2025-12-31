#
# mkcd — create a directory (including parents) and change into it
#
# Design:
# - Uses `mkdir -p` so nested paths work and existing dirs are not errors
# - Only runs `cd` if `mkdir` succeeds (`&&`)
# - Explicit argument check to avoid accidental `cd $HOME`
#
# Usage:
#   mkcd ~/projects/foo
#   mkcd ./build/output
#
mkcd() {
  # Require exactly one argument: the directory to create
  [ -z "$1" ] && {
    echo "Usage: mkcd <dir>"
    return 1
  }

  mkdir -p "$1" && cd "$1"
}


#
# mkcp — create a directory (including parents) and copy files into it
#
# Design:
# - First argument is always the destination directory
# - Remaining arguments are passed verbatim to `cp`
# - Does not rely on `$_` (which is shell-state dependent and fragile)
# - Works with one or many source files
#
# Usage:
#   mkcp ~/.config/lazygit config.yml
#   mkcp ./dist app.js style.css index.html
#
mkcp() {
  # Require a destination directory + at least one source file
  [ "$#" -lt 2 ] && {
    echo "Usage: mkcp <dir> <files...>"
    return 1
  }

  mkdir -p "$1" && cp "${@:2}" "$1"
}


#
# mkmv — create a directory (including parents) and move files into it
#
# Design:
# - Mirrors mkcp exactly, but uses `mv`
# - Supports moving files or directories
# - Atomic in intent: no move happens if mkdir fails
# - Keeps shell functions orthogonal and predictable
#
# Usage:
#   mkmv ~/archive logs.txt
#   mkmv ./src/old *.c *.h
#
mkmv() {
  # Require a destination directory + at least one source path
  [ "$#" -lt 2 ] && {
    echo "Usage: mkmv <dir> <files...>"
    return 1
  }

  mkdir -p "$1" && mv "${@:2}" "$1"
}

#
# lslhoctal — `ls -lh` with numeric (octal) permission display
#
# Purpose:
#   This function augments `ls -lh` by prepending the file’s permission
#   bits in *octal* form (the same format used by `chmod`), making it easy
#   to visually map symbolic permissions (rwxr-xr-x) to numeric modes (755).
#
# Usage examples:
#   lslhoctal
#   lslhoctal file.txt
#   lslhoctal /usr/bin/*
#   lslhoctal -d */
#
# Sample output:
#   755 -rwxr-xr-x  1 user group  12K Jan  1 script.sh
#   644 -rw-r--r--  1 user group 1.2K Jan  1 notes.txt
#   4755 -rwsr-xr-x 1 root root   52K Jan  1 passwd
#
#
# Permissions mental model (user / group / others):
#
#   Unix permissions are divided into three *independent* classes:
#
#     user   → the file owner
#     group  → users in the file’s group
#     other  → everyone else
#
#   Each class has three possible permissions:
#
#     r = read   (4)
#     w = write  (2)
#     x = execute (1)
#
#   These values are *additive* within each class.
#
#
# Octal permission codes explained:
#
#   An octal mode is usually written as three digits (sometimes four):
#
#     [special][user][group][other]
#
#   Examples:
#
#     755
#       user  = 7 → r(4) + w(2) + x(1)
#       group = 5 → r(4) + x(1)
#       other = 5 → r(4) + x(1)
#
#     644
#       user  = 6 → r(4) + w(2)
#       group = 4 → r(4)
#       other = 4 → r(4)
#
#
# Special permission bits (leading digit):
#
#   The optional *leading* octal digit represents special modes:
#
#     4 → setuid  (s on user execute bit)
#     2 → setgid  (s on group execute bit)
#     1 → sticky  (t on other execute bit)
#
#   Examples:
#
#     4755 → setuid + 755
#     2775 → setgid + 775
#     1777 → sticky + 777  (e.g. /tmp)
#
#
# How this function works:
#
#   - Runs `ls -lh --color=always` to preserve standard formatting
#   - Uses `awk` to:
#       • Parse the symbolic permission string (e.g. rwxr-xr-x)
#       • Convert each permission triplet into its octal value
#       • Detect setuid, setgid, and sticky bits
#       • Prepend the computed octal mode to each output line
#
#   No filesystem metadata is modified — this is a pure display helper.
#
lslhoctal() {
  ls -lh --color=always "$@" | awk '
  function tri(p, r, w, x,   n) {
    n = 0
    if (substr(p, r, 1) == "r") n += 4
    if (substr(p, w, 1) == "w") n += 2
    c = substr(p, x, 1)
    if (c == "x" || c == "s" || c == "t") n += 1
    return n
  }
  function special(p,   su, sg, st, n) {
    su = substr(p, 4, 1)  # user execute position
    sg = substr(p, 7, 1)  # group execute position
    st = substr(p,10, 1)  # other execute position
    n = 0
    if (su == "s" || su == "S") n += 4
    if (sg == "s" || sg == "S") n += 2
    if (st == "t" || st == "T") n += 1
    return n
  }
  {
    p = $1
    sp = special(p)
    u  = tri(p, 2, 3, 4)
    g  = tri(p, 5, 6, 7)
    o  = tri(p, 8, 9,10)

    if (sp > 0) printf "%d%03d %s\n", sp, (u*100 + g*10 + o), $0
    else        printf "%03d %s\n", (u*100 + g*10 + o), $0
  }'
}
