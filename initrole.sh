#!/usr/bin/env bash
#
# init role
# shellcheck disable=SC2001

NAME="$1"
TITLE=$(echo "$NAME" | sed -e 's/[a-z]*/\u&/')
BASE_DIR=$(dirname "$(readlink -f "$0")")
ROLE="$BASE_DIR/roles/${NAME}"
TASKS="$ROLE/tasks/main.yml"
DEFAULTS="$ROLE/defaults/main.yml"
PLAY="$BASE_DIR/plays/${NAME}.yml"

if [[ $# -ne 1 ]]; then
    echo "Usage: $(basename "$0") <role_name>"
    exit 1
fi

if [[ -d "$ROLE" ]]; then
    find "$ROLE" -type f
    echo "$PLAY"
else
    mkdir -p "$ROLE"/{defaults,files,bhandlers,tasks,templates}
    cat > "$TASKS" << EOF
---
EOF
    cat > "$DEFAULTS" << EOF
---
EOF
    cat > "$PLAY" << EOF
---
- name: $TITLE
  hosts: local
  gather_facts: true
  become: true

  roles:
    - role: $NAME
EOF
fi

exit 0
