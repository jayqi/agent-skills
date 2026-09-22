set shell := ["bash", "-euo", "pipefail", "-c"]

stow_dir := justfile_directory() / "skills"
target_dir := home_directory() / ".config/claude/skills"

# Show available recipes
help:
    @just --list

# Symlink skills into the Claude skills directory (default: all)
install *packages: (_stow "-v" packages)

# Preview an install without touching the filesystem
check *packages: (_stow "-n -v" packages)

# Remove skill symlinks
uninstall *packages: (_stow "-D -v" packages)

# Recreate skill symlinks, dropping stale ones
restow *packages: (_stow "-R -v" packages)

# Show each skill package and whether it is currently installed
list:
    #!/usr/bin/env bash
    set -euo pipefail
    for dir in "{{ stow_dir }}"/*/; do
        pkg="$(basename "$dir")"
        link="{{ target_dir }}/$pkg"
        if [[ -L "$link" ]]; then
            printf '%-32s installed -> %s\n' "$pkg" "$(readlink "$link")"
        elif [[ -e "$link" ]]; then
            printf '%-32s conflict (exists, not a symlink)\n' "$pkg"
        else
            printf '%-32s not installed\n' "$pkg"
        fi
    done

[private]
_stow flags *packages:
    #!/usr/bin/env bash
    set -euo pipefail
    pkgs="{{ packages }}"
    if [[ -z "$pkgs" ]]; then
        pkgs="$(find "{{ stow_dir }}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)"
    fi
    if [[ -z "$pkgs" ]]; then
        echo "No skill packages found in {{ stow_dir }}" >&2
        exit 1
    fi
    mkdir -p "{{ target_dir }}"
    # shellcheck disable=SC2086
    stow -d "{{ stow_dir }}" -t "{{ target_dir }}" {{ flags }} $pkgs
