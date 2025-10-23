#!/usr/bin/env bash
# Batch State Operations Script
# Purpose: Perform bulk state changes on GitHub issues

set -euo pipefail

REPO="${GH_REPO:-terrylica/knowledgebase}"

# Function: Close all issues with specific label
close_by_label() {
    local label="$1"
    local reason="${2:-completed}"  # completed or not_planned
    local comment="${3:-Closing via automated script}"

    echo "Closing issues with label '$label' (reason: $reason)..."
    gh issue list --repo "$REPO" \
        --label "$label" \
        --state open \
        --limit 100 \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        gh issue close "$issue_num" \
            --reason "$reason" \
            --comment "$comment" \
            --repo "$REPO"
        echo "Closed issue #$issue_num"
    done
}

# Function: Close stale issues
close_stale_issues() {
    local days_inactive="$1"
    local label="${2:-stale}"
    local dry_run="${3:-false}"

    echo "Closing issues inactive for $days_inactive days..."
    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,updatedAt,title \
        --jq --arg days "$days_inactive" \
            '.[] | select((now - (.updatedAt | fromdateiso8601)) / 86400 > ($days | tonumber)) | {number, title}' \
    | jq -r '.number' \
    | while read -r issue_num; do
        if [[ "$dry_run" == "true" ]]; then
            echo "[DRY RUN] Would close issue #$issue_num"
        else
            gh issue edit "$issue_num" --add-label "$label" --repo "$REPO"
            gh issue close "$issue_num" \
                --reason not_planned \
                --comment "Closing due to inactivity (${days_inactive}+ days)" \
                --repo "$REPO"
            echo "Closed stale issue #$issue_num"
        fi
    done
}

# Function: Reopen issues with specific criteria
reopen_by_label() {
    local label="$1"
    local comment="${2:-Reopening via automated script}"

    echo "Reopening issues with label '$label'..."
    gh issue list --repo "$REPO" \
        --label "$label" \
        --state closed \
        --limit 50 \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        gh issue reopen "$issue_num" \
            --comment "$comment" \
            --repo "$REPO"
        echo "Reopened issue #$issue_num"
    done
}

# Function: Close issues matching title pattern
close_by_title_pattern() {
    local pattern="$1"
    local reason="${2:-not_planned}"

    echo "Closing issues matching pattern: $pattern"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,title \
        --jq --arg pattern "$pattern" \
            '.[] | select(.title | test($pattern)) | .number' \
    | while read -r issue_num; do
        gh issue close "$issue_num" \
            --reason "$reason" \
            --comment "Closing based on title match: $pattern" \
            --repo "$REPO"
        echo "Closed issue #$issue_num"
    done
}

# Function: Bulk state transition with label update
transition_state() {
    local from_label="$1"
    local to_label="$2"
    local action="$3"  # close or reopen

    echo "Transitioning issues from '$from_label' to '$to_label' ($action)..."
    gh issue list --repo "$REPO" \
        --label "$from_label" \
        --limit 100 \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        gh issue edit "$issue_num" \
            --remove-label "$from_label" \
            --add-label "$to_label" \
            --repo "$REPO"

        if [[ "$action" == "close" ]]; then
            gh issue close "$issue_num" --repo "$REPO"
        elif [[ "$action" == "reopen" ]]; then
            gh issue reopen "$issue_num" --repo "$REPO"
        fi

        echo "Transitioned issue #$issue_num"
    done
}

# Example usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        close-label)
            close_by_label "${2}" "${3:-completed}" "${4:-Automated closure}"
            ;;
        close-stale)
            close_stale_issues "${2}" "${3:-stale}" "${4:-false}"
            ;;
        reopen)
            reopen_by_label "${2}" "${3:-Automated reopen}"
            ;;
        close-pattern)
            close_by_title_pattern "${2}" "${3:-not_planned}"
            ;;
        transition)
            transition_state "${2}" "${3}" "${4}"
            ;;
        *)
            echo "Usage: $0 {close-label|close-stale|reopen|close-pattern|transition} [args...]"
            echo ""
            echo "Commands:"
            echo "  close-label LABEL [REASON] [COMMENT]           - Close issues by label"
            echo "  close-stale DAYS [LABEL] [DRY_RUN]            - Close stale issues"
            echo "  reopen LABEL [COMMENT]                         - Reopen issues by label"
            echo "  close-pattern PATTERN [REASON]                 - Close by title pattern"
            echo "  transition FROM_LABEL TO_LABEL ACTION          - Transition with state change"
            exit 1
            ;;
    esac
fi
