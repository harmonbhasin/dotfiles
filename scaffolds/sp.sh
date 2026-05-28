# Shared project scaffold command for bash and zsh.

_sp_usage() {
  cat <<'EOF'
Usage:
  sp [--force] [profile ...]
  sp --list
  sp --help

Examples:
  sp
  sp base
  sp typescript
  sp python
  sp --force typescript

Profiles are copied into the current directory. Non-base profiles copy base first.
EOF
}

_sp_scaffold_root() {
  printf '%s\n' "${SP_SCAFFOLDS_DIR:-${DOTFILES_DIR:-$HOME/dotfiles}/scaffolds}"
}

_sp_has_profile() {
  local needle="$1"
  shift

  local profile
  for profile in "$@"; do
    if [ "$profile" = "$needle" ]; then
      return 0
    fi
  done

  return 1
}

sp() {
  local force=0
  local root
  local profile
  local item
  local rel
  local src
  local dest
  local conflict
  local -a requested_profiles
  local -a profiles

  requested_profiles=()

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -f|--force)
        force=1
        ;;
      -h|--help)
        _sp_usage
        return 0
        ;;
      --list)
        root="$(_sp_scaffold_root)"
        if [ ! -d "$root" ]; then
          printf 'sp: scaffold root not found: %s\n' "$root" >&2
          return 1
        fi
        find "$root" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
        return 0
        ;;
      --)
        shift
        break
        ;;
      -*)
        printf 'sp: unknown option: %s\n' "$1" >&2
        return 2
        ;;
      *)
        requested_profiles+=("$1")
        ;;
    esac
    shift
  done

  while [ "$#" -gt 0 ]; do
    requested_profiles+=("$1")
    shift
  done

  if [ "${#requested_profiles[@]}" -eq 0 ]; then
    requested_profiles=(base)
  fi

  root="$(_sp_scaffold_root)"
  if [ ! -d "$root" ]; then
    printf 'sp: scaffold root not found: %s\n' "$root" >&2
    return 1
  fi

  profiles=(base)
  for profile in "${requested_profiles[@]}"; do
    case "$profile" in
      base)
        ;;
      *)
        if ! _sp_has_profile "$profile" "${profiles[@]}"; then
          profiles+=("$profile")
        fi
        ;;
    esac
  done

  for profile in "${profiles[@]}"; do
    if [ ! -d "$root/$profile" ]; then
      printf 'sp: scaffold profile not found: %s\n' "$profile" >&2
      printf 'sp: available profiles:\n' >&2
      find "$root" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort >&2
      return 1
    fi
  done

  if [ "$force" -ne 1 ]; then
    conflict=0
    for profile in "${profiles[@]}"; do
      while IFS= read -r rel; do
        [ -n "$rel" ] || continue

        src="$root/$profile/$rel"
        dest="$PWD/$rel"

        if [ -d "$src" ] && [ ! -L "$src" ]; then
          if [ -e "$dest" ] && [ ! -d "$dest" ]; then
            printf 'sp: target exists and is not a directory: %s\n' "$rel" >&2
            conflict=1
          fi
        elif [ "$rel" = ".gitignore" ]; then
          : # appended, not overwritten — handled in the copy loop
        elif [ -e "$dest" ] || [ -L "$dest" ]; then
          printf 'sp: target file exists: %s\n' "$rel" >&2
          conflict=1
        fi
      done < <(cd "$root/$profile" && find . ! -name . -print | sed 's#^\./##')
    done

    if [ "$conflict" -ne 0 ]; then
      printf 'sp: refusing to overwrite. Re-run with --force to replace existing files.\n' >&2
      return 1
    fi
  fi

  for profile in "${profiles[@]}"; do
    local src_gitignore="$root/$profile/.gitignore"
    local dest_gitignore="$PWD/.gitignore"
    local stash=""

    if [ -f "$src_gitignore" ] && [ -f "$dest_gitignore" ]; then
      stash="$(cat "$dest_gitignore")"
    fi

    command cp -R "$root/$profile"/. "$PWD"/ || return 1

    if [ -n "$stash" ]; then
      {
        printf '%s\n\n# --- %s ---\n' "$stash" "$profile"
        cat "$src_gitignore"
      } > "$dest_gitignore"
    fi
  done

  printf 'sp: copied %s into %s\n' "${profiles[*]}" "$PWD"

  if [ -f "$PWD/AGENTS.override.md" ] && [ ! -e "$PWD/CLAUDE.local.md" ] && [ ! -L "$PWD/CLAUDE.local.md" ]; then
    ln -s AGENTS.override.md "$PWD/CLAUDE.local.md"
    printf 'sp: linked CLAUDE.local.md -> AGENTS.override.md\n'
  fi
}
