#!/usr/bin/env bash
# Batch Label Operations Script
# Purpose: Perform bulk label operations on GitHub issues

set -euo pipefail

REPO="${GH_REPO:-terrylica/knowledgebase}"

# Function: Add label to all issues matching criteria
add_label_to_issues() {
    local filter_label="$1"
    local new_label="$2"
    local limit="${3:-10}"

    echo "Adding label '$new_label' to issues with label '$filter_label'..."
    gh issue list --repo "$REPO" \
        --label "$filter_label" \
        --limit "$limit" \
        --json number \
        --jq '.[].number' \
    | xargs -I {} gh issue edit {} --add-label "$new_label" --repo "$REPO"
}

# Function: Remove label from all issues
remove_label_from_issues() {
    local filter_label="$1"
    local remove_label="$2"
    local limit="${3:-10}"

    echo "Removing label '$remove_label' from issues with label '$filter_label'..."
    gh issue list --repo "$REPO" \
        --label "$filter_label" \
        --limit "$limit" \
        --json number \
        --jq '.[].number' \
    | xargs -I {} gh issue edit {} --remove-label "$remove_label" --repo "$REPO"
}

# Function: Replace label across all issues
replace_label() {
    local old_label="$1"
    local new_label="$2"
    local limit="${3:-50}"

    echo "Replacing label '$old_label' with '$new_label'..."
    gh issue list --repo "$REPO" \
        --label "$old_label" \
        --limit "$limit" \
        --json number \
        --jq '.[].number' \
    | xargs -I {} sh -c "gh issue edit {} --remove-label '$old_label' --add-label '$new_label' --repo '$REPO'"
}

# Function: Add multiple labels to issues
add_multiple_labels() {
    local filter_label="$1"
    shift
    local new_labels=("$@")

    echo "Adding labels '${new_labels[*]}' to issues with label '$filter_label'..."
    gh issue list --repo "$REPO" \
        --label "$filter_label" \
        --limit 50 \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        for label in "${new_labels[@]}"; do
            gh issue edit "$issue_num" --add-label "$label" --repo "$REPO" 2>/dev/null || true
        done
        echo "Updated issue #$issue_num"
    done
}

# Function: Label issues by age
label_by_age() {
    local days_old="$1"
    local label="$2"

    echo "Labeling issues older than $days_old days with '$label'..."
    gh issue list --repo "$REPO" \
        --limit 100 \
        --json number,createdAt \
        --jq --arg days "$days_old" \
            '.[] | select((now - (.createdAt | fromdateiso8601)) / 86400 > ($days | tonumber)) | .number' \
    | xargs -I {} gh issue edit {} --add-label "$label" --repo "$REPO"
}

# Example usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        add)
            add_label_to_issues "${2}" "${3}" "${4:-10}"
            ;;
        remove)
            remove_label_from_issues "${2}" "${3}" "${4:-10}"
            ;;
        replace)
            replace_label "${2}" "${3}" "${4:-50}"
            ;;
        multi)
            shift
            filter="$1"
            shift
            add_multiple_labels "$filter" "$@"
            ;;
        age)
            label_by_age "${2}" "${3}"
            ;;
        *)
            echo "Usage: $0 {add|remove|replace|multi|age} [args...]"
            echo ""
            echo "Commands:"
            echo "  add FILTER_LABEL NEW_LABEL [LIMIT]       - Add label to filtered issues"
            echo "  remove FILTER_LABEL LABEL [LIMIT]        - Remove label from filtered issues"
            echo "  replace OLD_LABEL NEW_LABEL [LIMIT]      - Replace label across issues"
            echo "  multi FILTER_LABEL LABEL1 LABEL2 ...     - Add multiple labels"
            echo "  age DAYS LABEL                            - Label old issues"
            exit 1
            ;;
    esac
fi
