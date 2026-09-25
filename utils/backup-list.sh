#!/usr/bin/env bash
#
# velero-volume-backups.sh
#
# Prints a summary table of all PodVolumeBackup objects:
# backup name, namespace, pod, volume, volume-backup phase,
# parent backup phase, size, created time, expiration time.
#
# Requires: kubectl, jq, numfmt (usually part of coreutils)

set -euo pipefail

VELERO_NAMESPACE="velero"

# ---------- check dependencies ----------
for cmd in kubectl jq numfmt; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command '$cmd' not found." >&2
    exit 1
  fi
done

# ---------- fetch data ----------
backups_json=$(kubectl get backups -n "$VELERO_NAMESPACE" -o json)
pvbs_json=$(kubectl get podvolumebackups -n "$VELERO_NAMESPACE" -o json)

# ---------- build table rows (TSV) ----------
rows=$(jq -r --argjson backups "$backups_json" '
  ($backups.items | map({(.metadata.name): .status}) | add) as $bmap |
  .items
  | sort_by(.metadata.labels["velero.io/backup-name"])
  | .[]
  | .metadata.labels["velero.io/backup-name"] as $b
  | [
      $b,
      .spec.pod.namespace,
      .spec.pod.name,
      .spec.volume,
      .status.phase,
      ($bmap[$b].phase // "N/A"),
      (.status.progress.bytesDone // 0),
      ($bmap[$b].startTimestamp // "N/A"),
      ($bmap[$b].expiration // "N/A")
    ] | @tsv
' <<< "$pvbs_json")

if [[ -z "$rows" ]]; then
  echo "No PodVolumeBackup objects found in namespace: $VELERO_NAMESPACE"
  exit 0
fi

# ---------- convert bytes to human-readable size and print ----------
{
  echo -e "BACKUP\tNAMESPACE\tPOD\tVOLUME\tPVB_PHASE\tBACKUP_PHASE\tSIZE\tCREATED\tEXPIRES"
  while IFS=$'\t' read -r backup ns pod vol pvb_phase b_phase bytes created expires; do
    size_human=$(numfmt --to=iec-i --suffix=B "$bytes" 2>/dev/null || echo "$bytes")
    echo -e "${backup}\t${ns}\t${pod}\t${vol}\t${pvb_phase}\t${b_phase}\t${size_human}\t${created}\t${expires}"
  done <<< "$rows"
} | column -t -s $'\t'