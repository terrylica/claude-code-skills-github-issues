#!/usr/bin/env bash
# Advanced GitHub CLI Workflow Scripts
# Purpose: Complex automation patterns combining multiple operations

set -euo pipefail

REPO="${GH_REPO:-terrylica/knowledgebase}"

# Workflow: Triage new issues
triage_new_issues() {
    local days="${1:-7}"

    echo "Triaging issues created in last $days days..."

    # Get recent issues
    gh issue list --repo "$REPO" \
        --limit 100 \
        --json number,title,body,labels,createdAt \
    | jq -c --arg days "$days" \
        '.[] | select((now - (.createdAt | fromdateiso8601)) / 86400 <= ($days | tonumber))' \
    | while read -r issue_json; do
        local number=$(echo "$issue_json" | jq -r '.number')
        local title=$(echo "$issue_json" | jq -r '.title')
        local body=$(echo "$issue_json" | jq -r '.body // ""')
        local labels=$(echo "$issue_json" | jq -r '.labels | length')

        echo "Processing issue #$number: $title"

        # Auto-label based on keywords
        if echo "$title $body" | grep -iq "bug\|error\|fail"; then
            gh issue edit "$number" --add-label "bug" --repo "$REPO" 2>/dev/null || true
            echo "  Added 'bug' label"
        fi

        if echo "$title $body" | grep -iq "feature\|enhancement\|improve"; then
            gh issue edit "$number" --add-label "enhancement" --repo "$REPO" 2>/dev/null || true
            echo "  Added 'enhancement' label"
        fi

        if echo "$title $body" | grep -iq "doc\|documentation\|readme"; then
            gh issue edit "$number" --add-label "documentation" --repo "$REPO" 2>/dev/null || true
            echo "  Added 'documentation' label"
        fi

        # Add needs-triage if no labels
        if [[ $labels -eq 0 ]]; then
            gh label create "needs-triage" --color "ffffff" --description "Needs initial triage" --repo "$REPO" 2>/dev/null || true
            gh issue edit "$number" --add-label "needs-triage" --repo "$REPO"
            echo "  Added 'needs-triage' label"
        fi
    done
}

# Workflow: Sprint planning automation
sprint_planning() {
    local sprint_label="$1"
    local max_issues="${2:-20}"

    echo "Planning sprint: $sprint_label (max $max_issues issues)"

    # Create sprint label if it doesn't exist
    gh label create "$sprint_label" \
        --color "0e8a16" \
        --description "Sprint backlog" \
        --repo "$REPO" 2>/dev/null || true

    # Select high-priority issues
    gh issue list --repo "$REPO" \
        --label "priority:high" \
        --state open \
        --limit "$max_issues" \
        --json number,title,labels \
        --jq '.[] | {number, title, labels: [.labels[].name]}' \
    | jq -c '.' \
    | while read -r issue_json; do
        local number=$(echo "$issue_json" | jq -r '.number')
        local title=$(echo "$issue_json" | jq -r '.title')

        echo "Adding issue #$number to sprint: $title"
        gh issue edit "$number" --add-label "$sprint_label" --repo "$REPO"

        # Create development branch
        gh issue develop "$number" --repo "$REPO" 2>/dev/null || echo "  Branch already exists"
    done
}

# Workflow: Release preparation
prepare_release() {
    local milestone="$1"
    local release_label="release-ready"

    echo "Preparing release for milestone: $milestone"

    # Create release-ready label
    gh label create "$release_label" \
        --color "0e8a16" \
        --description "Ready for release" \
        --repo "$REPO" 2>/dev/null || true

    # Get all closed issues in milestone
    gh issue list --repo "$REPO" \
        --milestone "$milestone" \
        --state closed \
        --limit 100 \
        --json number,title,labels \
    | jq -r '.[].number' \
    | while read -r issue_num; do
        echo "Marking issue #$issue_num as release-ready"
        gh issue edit "$issue_num" --add-label "$release_label" --repo "$REPO"
    done

    # Generate release notes
    echo ""
    echo "Release Notes for $milestone:"
    echo "================================"
    gh issue list --repo "$REPO" \
        --milestone "$milestone" \
        --state closed \
        --limit 100 \
        --json number,title,labels \
        --jq '.[] | "- \(.title) (#\(.number))"'
}

# Workflow: Dependency tracking
track_dependencies() {
    local blocked_label="blocked"

    echo "Tracking issue dependencies..."

    # Find issues mentioning blocking relationships
    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,body \
    | jq -r '.[] | select(.body // "" | test("blocks?|blocked by|depends on")) | .number' \
    | while read -r issue_num; do
        echo "Issue #$issue_num has dependencies"
        gh issue edit "$issue_num" --add-label "$blocked_label" --repo "$REPO" 2>/dev/null || true
    done
}

# Workflow: Quality gates
enforce_quality_gates() {
    echo "Enforcing quality gates on open issues..."

    # Check for issues without labels
    echo "Issues without labels:"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,title,labels \
        --jq '.[] | select(.labels | length == 0) | "  #\(.number): \(.title)"'

    # Check for issues without assignees
    echo ""
    echo "Issues without assignees:"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,title,assignees \
        --jq '.[] | select(.assignees | length == 0) | "  #\(.number): \(.title)"'

    # Check for stale issues
    echo ""
    echo "Stale issues (30+ days without update):"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,title,updatedAt \
        --jq '.[] | select((now - (.updatedAt | fromdateiso8601)) / 86400 > 30) | "  #\(.number): \(.title)"'
}

# Workflow: Automated code review assignment
auto_assign_reviews() {
    local label="${1:-needs-review}"
    shift
    local reviewers=("$@")

    echo "Auto-assigning reviews for label: $label"
    echo "Reviewers: ${reviewers[*]}"

    local index=0

    gh issue list --repo "$REPO" \
        --label "$label" \
        --state open \
        --limit 50 \
        --json number,assignees \
        --jq '.[] | select(.assignees | length == 0) | .number' \
    | while read -r issue_num; do
        local reviewer="${reviewers[$index]}"
        gh issue edit "$issue_num" --add-assignee "$reviewer" --repo "$REPO"
        gh issue comment "$issue_num" \
            --body "@$reviewer Please review this issue when you have a chance." \
            --repo "$REPO"

        echo "Assigned issue #$issue_num to @$reviewer for review"
        index=$(( (index + 1) % ${#reviewers[@]} ))
    done
}

# Workflow: Create development branches for sprint
bulk_create_branches() {
    local label="$1"
    local base_branch="${2:-main}"

    echo "Creating development branches for all issues with label: $label"

    gh issue list --repo "$REPO" \
        --label "$label" \
        --state open \
        --limit 50 \
        --json number,title \
    | jq -r '.[].number' \
    | while read -r issue_num; do
        echo "Creating branch for issue #$issue_num..."
        gh issue develop "$issue_num" --base "$base_branch" --repo "$REPO" 2>&1 \
            | grep -v "already exists" || echo "  Branch created or already exists"
    done
}

# Workflow: Issue health report
generate_health_report() {
    echo "GitHub Issue Health Report"
    echo "=========================="
    echo ""

    echo "Total Issues:"
    echo "  Open: $(gh issue list --repo "$REPO" --state open --limit 1000 --json number --jq 'length')"
    echo "  Closed: $(gh issue list --repo "$REPO" --state closed --limit 1000 --json number --jq 'length')"
    echo ""

    echo "Label Distribution:"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 1000 \
        --json labels \
        --jq '[.[].labels[].name] | group_by(.) | map({label: .[0], count: length}) | sort_by(-.count)[] | "  \(.label): \(.count)"'
    echo ""

    echo "Assignment Distribution:"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 1000 \
        --json assignees \
        --jq '[.[].assignees[].login] | group_by(.) | map({user: .[0], count: length}) | sort_by(-.count)[] | "  @\(.user): \(.count)"'
    echo ""

    echo "Issues by Age:"
    echo "  < 7 days: $(gh issue list --repo "$REPO" --state open --limit 1000 --json createdAt --jq '[.[] | select((now - (.createdAt | fromdateiso8601)) / 86400 < 7)] | length')"
    echo "  7-30 days: $(gh issue list --repo "$REPO" --state open --limit 1000 --json createdAt --jq '[.[] | select((now - (.createdAt | fromdateiso8601)) / 86400 >= 7 and (now - (.createdAt | fromdateiso8601)) / 86400 < 30)] | length')"
    echo "  > 30 days: $(gh issue list --repo "$REPO" --state open --limit 1000 --json createdAt --jq '[.[] | select((now - (.createdAt | fromdateiso8601)) / 86400 >= 30)] | length')"
}

# Example usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        triage)
            triage_new_issues "${2:-7}"
            ;;
        sprint)
            sprint_planning "${2}" "${3:-20}"
            ;;
        release)
            prepare_release "${2}"
            ;;
        dependencies)
            track_dependencies
            ;;
        quality)
            enforce_quality_gates
            ;;
        reviews)
            shift
            label="$1"
            shift
            auto_assign_reviews "$label" "$@"
            ;;
        branches)
            bulk_create_branches "${2}" "${3:-main}"
            ;;
        health)
            generate_health_report
            ;;
        *)
            echo "Usage: $0 {triage|sprint|release|dependencies|quality|reviews|branches|health} [args...]"
            echo ""
            echo "Workflows:"
            echo "  triage [DAYS]                              - Triage recent issues"
            echo "  sprint LABEL [MAX_ISSUES]                  - Plan sprint backlog"
            echo "  release MILESTONE                          - Prepare release"
            echo "  dependencies                               - Track blocking issues"
            echo "  quality                                    - Quality gate report"
            echo "  reviews LABEL REVIEWER1 REVIEWER2 ...      - Auto-assign reviews"
            echo "  branches LABEL [BASE_BRANCH]               - Bulk create branches"
            echo "  health                                     - Generate health report"
            exit 1
            ;;
    esac
fi
