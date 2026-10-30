#!/bin/bash
# Update packages.txt with all installed AUR packages, sorted alphabetically.
# Packages already in packages.txt are kept (deduplicated), ignore_packages.txt entries are removed.

PACKAGES_FILE="packages.txt"
IGNORE_FILE="ignore_packages.txt"

# Get all installed AUR packages (yay -Qm lists name and version; keep name only)
AUR_PACKAGES=$(yay -Qm 2>/dev/null | awk '{print $1}' || echo "ERROR: yay not found or failed.")

# Current packages (exclude header lines 1-2)
CURRENT_PACKAGES=$(awk 'NR > 2 {print}' "$PACKAGES_FILE" 2>/dev/null || true)

# Combine, deduplicate, and remove ignored packages
ALL_PACKAGES=$(printf "%s\n" "$CURRENT_PACKAGES" "$AUR_PACKAGES" | sort -u | grep -vxF -f "$IGNORE_FILE" || true)

# Write clean header + sorted list
NEW_CONTENT="# AUR packages\n#####\n$(echo -e "$ALL_PACKAGES")"
echo -e "$NEW_CONTENT" > "$PACKAGES_FILE"

echo "Done. $(echo -e "$ALL_PACKAGES" | wc -l) packages written to $PACKAGES_FILE."
