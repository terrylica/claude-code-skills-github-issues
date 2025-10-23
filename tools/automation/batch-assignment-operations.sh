#!/usr/bin/env bash
# Batch Assignment Operations Script
# Purpose: Perform bulk assignment operations on GitHub issues

set -euo pipefail

REPO="${GH_REPO:-terrylica/knowledgebase}"

# Function: Assign all issues with label to user
assign_by_label() {
    local label="$1"
    local assignee="$2"
    local limit="${3:-50}"

    echo "Assigning issues with label '$label' to @$assignee..."
    gh issue list --repo "$REPO" \
        --label "$label" \
        --limit "$limit" \
        --json number \
        --jq '.[].number' \
    | xargs -I {} gh issue edit {} --add-assignee "$assignee" --repo "$REPO"
}

# Function: Unassign all issues from user
unassign_user() {
    local assignee="$1"
    local limit="${2:-100}"

    echo "Removing @$assignee from all assigned issues..."
    gh issue list --repo "$REPO" \
        --assignee "$assignee" \
        --limit "$limit" \
        --json number \
        --jq '.[].number' \
    | xargs -I {} gh issue edit {} --remove-assignee "$assignee" --repo "$REPO"
}

# Function: Reassign issues from one user to another
reassign_issues() {
    local from_user="$1"
    local to_user="$2"
    local limit="${3:-100}"

    echo "Reassigning issues from @$from_user to @$to_user..."
    gh issue list --repo "$REPO" \
        --assignee "$from_user" \
        --limit "$limit" \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        gh issue edit "$issue_num" \
            --remove-assignee "$from_user" \
            --add-assignee "$to_user" \
            --repo "$REPO"
        echo "Reassigned issue #$issue_num"
    done
}

# Function: Round-robin assignment
round_robin_assign() {
    local label="$1"
    shift
    local assignees=("$@")
    local index=0

    echo "Round-robin assigning issues with label '$label' to: ${assignees[*]}"
    gh issue list --repo "$REPO" \
        --label "$label" \
        --no-assignee \
        --limit 100 \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        local assignee="${assignees[$index]}"
        gh issue edit "$issue_num" --add-assignee "$assignee" --repo "$REPO"
        echo "Assigned issue #$issue_num to @$assignee"

        index=$(( (index + 1) % ${#assignees[@]} ))
    done
}

# Function: Auto-assign unassigned issues by label
auto_assign_by_label() {
    local config_file="$1"

    # Config file format (JSON):
    # {
    #   "bug": "user1",
    #   "documentation": "user2",
    #   "enhancement": "user3"
    # }

    echo "Auto-assigning based on configuration: $config_file"

    jq -r 'to_entries[] | "\(.key):\(.value)"' "$config_file" \
    | while IFS=: read -r label assignee; do
        echo "Processing label: $label -> @$assignee"
        gh issue list --repo "$REPO" \
            --label "$label" \
            --no-assignee \
            --limit 50 \
            --json number \
            --jq '.[].number' \
        | xargs -I {} gh issue edit {} --add-assignee "$assignee" --repo "$REPO" 2>/dev/null || true
    done
}

# Function: Balance assignments across team
balance_assignments() {
    shift
    local team=("$@")
    local max_per_user="${1:-10}"

    echo "Balancing assignments across team: ${team[*]}"

    # Get current assignment counts
    for user in "${team[@]}"; do
        local count=$(gh issue list --repo "$REPO" \
            --assignee "$user" \
            --state open \
            --json number \
            --jq 'length')
        echo "  @$user: $count issues"
    done

    # Assign unassigned issues to users with fewest issues
    gh issue list --repo "$REPO" \
        --no-assignee \
        --state open \
        --limit 100 \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        # Find user with fewest assignments
        local min_user=""
        local min_count=999999

        for user in "${team[@]}"; do
            local count=$(gh issue list --repo "$REPO" \
                --assignee "$user" \
                --state open \
                --json number \
                --jq 'length')

            if [[ $count -lt $min_count ]] && [[ $count -lt $max_per_user ]]; then
                min_count=$count
                min_user=$user
            fi
        done

        if [[ -n "$min_user" ]]; then
            gh issue edit "$issue_num" --add-assignee "$min_user" --repo "$REPO"
            echo "Assigned issue #$issue_num to @$min_user (now has $((min_count + 1)) issues)"
        else
            echo "All team members at capacity, skipping issue #$issue_num"
        fi
    done
}

# Example usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        assign)
            assign_by_label "${2}" "${3}" "${4:-50}"
            ;;
        unassign)
            unassign_user "${2}" "${3:-100}"
            ;;
        reassign)
            reassign_issues "${2}" "${3}" "${4:-100}"
            ;;
        round-robin)
            shift
            label="$1"
            shift
            round_robin_assign "$label" "$@"
            ;;
        auto-assign)
            auto_assign_by_label "${2}"
            ;;
        balance)
            max="${2:-10}"
            shift 2
            balance_assignments "$max" "$@"
            ;;
        *)
            echo "Usage: $0 {assign|unassign|reassign|round-robin|auto-assign|balance} [args...]"
            echo ""
            echo "Commands:"
            echo "  assign LABEL ASSIGNEE [LIMIT]              - Assign by label"
            echo "  unassign USER [LIMIT]                      - Remove user from all issues"
            echo "  reassign FROM_USER TO_USER [LIMIT]         - Reassign between users"
            echo "  round-robin LABEL USER1 USER2 ...          - Round-robin assignment"
            echo "  auto-assign CONFIG_FILE                    - Auto-assign by config"
            echo "  balance MAX_PER_USER USER1 USER2 ...       - Balance across team"
            exit 1
            ;;
    esac
fi
