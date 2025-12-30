# ---------------------------------------------------------------------------
# dice — Diceware-style passphrase generator
#
# PURPOSE
# -------
# Generate high-entropy, human-memorable passphrases using the Diceware method.
# This tool selects random words from the EFF Diceware wordlist and outputs
# them as a space-separated phrase suitable for:
#
#   - encryption passphrases (e.g. GPG, age, backups)
#   - long-lived secrets
#   - passwords that must be typed or remembered by humans
#
#
# SECURITY MODEL
# --------------
# - Entropy source:
#   Randomness is provided by `shuf`, which draws from the system CSPRNG
#   (typically /dev/urandom on Linux). This is suitable for cryptographic use.
#
# - Wordlist:
#   Uses the EFF large Diceware wordlist (7,776 words).
#   Each word contributes ~12.9 bits of entropy.
#
#     6 words ≈ 77 bits   (good)
#     7 words ≈ 90 bits   (excellent, recommended)
#     8 words ≈ 103 bits  (overkill for most uses)
#
# - Threat model:
#   Designed to resist OFFLINE brute-force attacks.
#   Assumes the attacker may obtain the encrypted data and attempt guessing.
#
#   This tool does NOT protect against:
#     - keylogging on a compromised system
#     - phishing / social engineering
#     - weak storage or reuse of the generated passphrase
#
#
# RELIABILITY & TRUST
# -------------------
# - EFF Diceware wordlist:
#   Maintained and published by the Electronic Frontier Foundation.
#   The list is static, widely audited, and specifically designed for Diceware.
#
# - shuf:
#   Part of GNU coreutils.
#   Uses a cryptographically secure random source on modern Linux systems.
#
# - Local storage:
#   The wordlist is downloaded once and stored per-user under:
#     $XDG_DATA_HOME/dice/   (defaults to ~/.local/share/dice/)
#
#   No root privileges are required.
#
#
# USAGE
# -----
# Generate a single word (mostly for testing):
#
#   dice
#
# Generate a 7-word passphrase (recommended):
#
#   dice -q 7
#
# Example output:
#
#   grid overturn state careless given cactus plunging nursery
#
# Words are space-separated and printed on a single line for easy copying.
#
#
# NOTES
# -----
# - Random-looking or "weird" words are NOT required for security.
#   Familiar words are fine — unpredictability comes from randomness,
#   not obscurity.
#
# - Do not modify or "improve" the words (capitalization, leetspeak, etc.).
#   That reduces entropy.
#
# - This tool intentionally avoids complexity and ceremony.
#   Simplicity reduces mistakes and security foot-guns.
#
# ---------------------------------------------------------------------------

dice() {
    # Respect XDG data dir, fall back to ~/.local/share
    XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    WORDLIST_DIR="$XDG_DATA_HOME/dice"
    WORDLIST="$WORDLIST_DIR/eff_large_wordlist.txt"
    WORDLIST_URL="https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt"

    # Default number of words
    COUNT=7
    OPTIND=1

    # Parse flags: only -q (quantity) is supported
    while getopts "q:" opt; do
        case "$opt" in
            q) COUNT="$OPTARG" ;;
            *) return 1 ;;
        esac
    done

    # Validate COUNT: must be a non-empty, all-digits integer
    case "$COUNT" in
        ''|*[!0-9]*)
            echo "dice: quantity must be a positive integer" >&2
            return 1
            ;;
    esac

    # If the wordlist is not readable, attempt to create the directory
    # and download the official EFF wordlist. Errors are reported to stderr
    # and the function returns non-zero on failure.
    if [ ! -r "$WORDLIST" ]; then
        echo "dice: wordlist not found, installing…" >&2

        mkdir -p "$WORDLIST_DIR" || return 1
        curl -fsSL "$WORDLIST_URL" -o "$WORDLIST" || {
            echo "dice: failed to download wordlist" >&2
            return 1
        }
    fi

    # The EFF wordlist lines look like: 11111\tword
    # Remove the 5-digit code prefix, then randomly pick COUNT words,
    # and join them with spaces for a single passphrase line.
    # sed 's/^[0-9]\{5\}[[:space:]]\+//' "$WORDLIST" | shuf -n "$COUNT" | paste -sd ' ' -
    sed 's/^[0-9]\{5\}[[:space:]]\+//' "$WORDLIST" \
      | shuf --random-source=/dev/urandom -n "$COUNT" \
      | paste -sd ' ' -

}
