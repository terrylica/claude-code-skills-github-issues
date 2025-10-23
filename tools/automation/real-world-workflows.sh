#!/usr/bin/env bash
# Real-World GitHub Issue Workflow Examples
# Purpose: Complete automation patterns for common scenarios

set -euo pipefail

REPO="${GH_REPO:-terrylica/knowledgebase}"

# Workflow 1: Sprint Planning End-to-End
complete_sprint_planning() {
    local sprint_label="$1"
    local team_members=("${@:2}")

    echo "=== Complete Sprint Planning Workflow ==="
    echo "Sprint: $sprint_label"
    echo "Team: ${team_members[*]}"
    echo ""

    # Step 1: Create sprint label
    gh label create "$sprint_label" \
        --color "0e8a16" \
        --description "Sprint backlog" \
        --repo "$REPO" 2>/dev/null || echo "Label already exists"

    # Step 2: Get high-priority unplanned issues
    echo "Step 1: Selecting high-priority issues..."
    local issues=$(gh issue list --repo "$REPO" \
        --label "priority:high" \
        --state open \
        --limit 20 \
        --json number,title \
        --jq '.[].number')

    # Step 3: Add to sprint and create branches
    echo "Step 2: Adding issues to sprint and creating branches..."
    local index=0
    for issue_num in $issues; do
        # Add sprint label
        gh issue edit "$issue_num" --add-label "$sprint_label" --repo "$REPO"

        # Assign to team member (round-robin)
        local assignee="${team_members[$index]}"
        gh issue edit "$issue_num" --add-assignee "$assignee" --repo "$REPO"

        # Create development branch
        gh issue develop "$issue_num" --repo "$REPO" 2>/dev/null || echo "Branch exists"

        echo "  #$issue_num assigned to @$assignee"
        index=$(( (index + 1) % ${#team_members[@]} ))
    done

    # Step 4: Generate sprint report
    echo ""
    echo "=== Sprint Summary ==="
    gh issue list --repo "$REPO" \
        --label "$sprint_label" \
        --json number,title,assignees \
        --jq '.[] | "#\(.number): \(.title) (@\(.assignees[0].login // "unassigned"))"'
}

# Workflow 2: Daily Standup Report
generate_standup_report() {
    local team="${1:-all}"
    local output_file="${2:-standup-$(date +%Y-%m-%d).md}"

    echo "Generating standup report for team: $team"

    cat > "$output_file" <<EOF
# Daily Standup Report
Date: $(date +%Y-%m-%d)
Team: $team

## Issues Updated in Last 24 Hours

EOF

    # Get recently updated issues
    gh issue list --repo "$REPO" \
        --state all \
        --limit 100 \
        --json number,title,updatedAt,assignees,state \
    | jq -r '
        .[] |
        select((now - (.updatedAt | fromdateiso8601)) / 86400 < 1) |
        "- #\(.number): \(.title) - \(.state) (@\(.assignees[0].login // "unassigned"))"
    ' >> "$output_file"

    cat >> "$output_file" <<EOF

## Issues Created in Last 24 Hours

EOF

    gh issue list --repo "$REPO" \
        --limit 100 \
        --json number,title,createdAt,assignees \
    | jq -r '
        .[] |
        select((now - (.createdAt | fromdateiso8601)) / 86400 < 1) |
        "- #\(.number): \(.title) (@\(.assignees[0].login // "unassigned"))"
    ' >> "$output_file"

    cat >> "$output_file" <<EOF

## Issues Closed in Last 24 Hours

EOF

    gh issue list --repo "$REPO" \
        --state closed \
        --limit 100 \
        --json number,title,closedAt \
    | jq -r '
        .[] |
        select((now - (.closedAt | fromdateiso8601)) / 86400 < 1) |
        "- #\(.number): \(.title)"
    ' >> "$output_file"

    echo "Report generated: $output_file"
}

# Workflow 3: Bug Triage Automation
automated_bug_triage() {
    echo "=== Automated Bug Triage ==="

    # Step 1: Label new bugs
    echo "Step 1: Processing new bug reports..."
    gh issue list --repo "$REPO" \
        --label "bug" \
        --state open \
        --limit 50 \
        --json number,body,title \
    | jq -c '.[]' \
    | while read -r issue; do
        local number=$(echo "$issue" | jq -r '.number')
        local title=$(echo "$issue" | jq -r '.title')
        local body=$(echo "$issue" | jq -r '.body // ""')
        local text="$title $body"

        echo "Processing #$number: $title"

        # Auto-label by severity keywords
        if echo "$text" | grep -iE "crash|panic|fatal|data loss" > /dev/null; then
            gh issue edit "$number" --add-label "priority:critical" --repo "$REPO" 2>/dev/null || true
            echo "  Added: priority:critical"
        elif echo "$text" | grep -iE "urgent|blocker|broken" > /dev/null; then
            gh issue edit "$number" --add-label "priority:high" --repo "$REPO" 2>/dev/null || true
            echo "  Added: priority:high"
        else
            gh issue edit "$number" --add-label "priority:medium" --repo "$REPO" 2>/dev/null || true
            echo "  Added: priority:medium"
        fi

        # Auto-label by component
        if echo "$text" | grep -iE "api|endpoint|rest" > /dev/null; then
            gh issue edit "$number" --add-label "backend" --repo "$REPO" 2>/dev/null || true
            echo "  Added: backend"
        fi

        if echo "$text" | grep -iE "ui|frontend|css|button" > /dev/null; then
            gh issue edit "$number" --add-label "frontend" --repo "$REPO" 2>/dev/null || true
            echo "  Added: frontend"
        fi
    done

    # Step 2: Generate triage report
    echo ""
    echo "=== Bug Triage Summary ==="
    echo "Critical: $(gh issue list --repo "$REPO" --label "bug,priority:critical" --json number --jq 'length')"
    echo "High: $(gh issue list --repo "$REPO" --label "bug,priority:high" --json number --jq 'length')"
    echo "Medium: $(gh issue list --repo "$REPO" --label "bug,priority:medium" --json number --jq 'length')"
    echo "Low: $(gh issue list --repo "$REPO" --label "bug,priority:low" --json number --jq 'length')"
}

# Workflow 4: Release Checklist Automation
prepare_release_checklist() {
    local version="$1"
    local milestone="$2"

    echo "Preparing release checklist for $version (milestone: $milestone)"

    # Create release tracking issue
    local checklist=$(cat <<EOF
# Release Checklist: $version

## Pre-Release Tasks

- [ ] All milestone issues closed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Version bumped in all files
- [ ] Tests passing
- [ ] Security audit completed

## Release Tasks

- [ ] Create release branch
- [ ] Tag release
- [ ] Build artifacts
- [ ] Deploy to staging
- [ ] Smoke tests on staging
- [ ] Deploy to production

## Post-Release Tasks

- [ ] Monitor error rates
- [ ] Close milestone
- [ ] Announce release
- [ ] Update roadmap

## Issues in This Release

EOF
)

    # Add all milestone issues
    local issues=$(gh issue list --repo "$REPO" \
        --milestone "$milestone" \
        --state all \
        --limit 100 \
        --json number,title \
        --jq '.[] | "- #\(.number): \(.title)"')

    checklist="$checklist\n$issues"

    # Create tracking issue
    local tracking_issue=$(gh issue create \
        --repo "$REPO" \
        --title "Release $version Tracking" \
        --body "$checklist" \
        --label "release")

    echo "Created tracking issue: $tracking_issue"
}

# Workflow 5: Stale Issue Management
manage_stale_issues() {
    local stale_days="${1:-30}"
    local close_days="${2:-60}"

    echo "=== Stale Issue Management ==="
    echo "Stale threshold: $stale_days days"
    echo "Close threshold: $close_days days"

    # Create labels if needed
    gh label create "stale" \
        --color "ededed" \
        --description "No activity for extended period" \
        --repo "$REPO" 2>/dev/null || true

    # Step 1: Mark stale issues
    echo ""
    echo "Step 1: Marking stale issues..."
    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,title,updatedAt \
    | jq -r --arg days "$stale_days" '
        .[] |
        select((now - (.updatedAt | fromdateiso8601)) / 86400 > ($days | tonumber)) |
        .number
    ' \
    | while read -r issue_num; do
        # Check if already labeled
        local has_stale=$(gh issue view "$issue_num" --repo "$REPO" --json labels \
            | jq '.labels[] | select(.name == "stale") | .name')

        if [[ -z "$has_stale" ]]; then
            gh issue edit "$issue_num" --add-label "stale" --repo "$REPO"
            gh issue comment "$issue_num" \
                --body "This issue has been automatically marked as stale due to inactivity. It will be closed in ${close_days} days if no further activity occurs." \
                --repo "$REPO"
            echo "  Marked #$issue_num as stale"
        fi
    done

    # Step 2: Close very old stale issues
    echo ""
    echo "Step 2: Closing very old issues..."
    gh issue list --repo "$REPO" \
        --label "stale" \
        --state open \
        --limit 100 \
        --json number,updatedAt \
    | jq -r --arg days "$close_days" '
        .[] |
        select((now - (.updatedAt | fromdateiso8601)) / 86400 > ($days | tonumber)) |
        .number
    ' \
    | while read -r issue_num; do
        gh issue close "$issue_num" \
            --reason not_planned \
            --comment "Closing due to prolonged inactivity. Please reopen if this is still relevant." \
            --repo "$REPO"
        echo "  Closed #$issue_num"
    done
}

# Workflow 6: Team Workload Balancing
balance_team_workload() {
    shift
    local max_per_person="${1:-5}"
    shift
    local team=("$@")

    echo "=== Team Workload Balancing ==="
    echo "Max per person: $max_per_person"
    echo "Team: ${team[*]}"

    # Get current workload
    echo ""
    echo "Current Workload:"
    for member in "${team[@]}"; do
        local count=$(gh issue list --repo "$REPO" \
            --assignee "$member" \
            --state open \
            --json number \
            --jq 'length')
        echo "  @$member: $count issues"
    done

    # Assign unassigned issues
    echo ""
    echo "Assigning unassigned issues..."
    gh issue list --repo "$REPO" \
        --no-assignee \
        --state open \
        --limit 100 \
        --json number \
        --jq '.[].number' \
    | while read -r issue_num; do
        # Find team member with fewest issues
        local min_member=""
        local min_count=999999

        for member in "${team[@]}"; do
            local count=$(gh issue list --repo "$REPO" \
                --assignee "$member" \
                --state open \
                --json number \
                --jq 'length')

            if [[ $count -lt $min_count ]] && [[ $count -lt $max_per_person ]]; then
                min_count=$count
                min_member=$member
            fi
        done

        if [[ -n "$min_member" ]]; then
            gh issue edit "$issue_num" --add-assignee "$min_member" --repo "$REPO"
            echo "  Assigned #$issue_num to @$min_member"
        else
            echo "  All team members at capacity, skipping #$issue_num"
            break
        fi
    done
}

# Workflow 7: Documentation Issue Tracking
manage_documentation_issues() {
    echo "=== Documentation Issue Management ==="

    # Create documentation category labels
    local doc_labels=("docs:api" "docs:guide" "docs:tutorial" "docs:reference")
    for label in "${doc_labels[@]}"; do
        gh label create "$label" \
            --color "0075ca" \
            --description "Documentation category" \
            --repo "$REPO" 2>/dev/null || true
    done

    # Auto-categorize documentation issues
    gh issue list --repo "$REPO" \
        --label "documentation" \
        --state open \
        --limit 50 \
        --json number,title,body \
    | jq -c '.[]' \
    | while read -r issue; do
        local number=$(echo "$issue" | jq -r '.number')
        local title=$(echo "$issue" | jq -r '.title')
        local body=$(echo "$issue" | jq -r '.body // ""')
        local text="$title $body"

        if echo "$text" | grep -iE "api|endpoint" > /dev/null; then
            gh issue edit "$number" --add-label "docs:api" --repo "$REPO" 2>/dev/null || true
        fi

        if echo "$text" | grep -iE "tutorial|how-to|walkthrough" > /dev/null; then
            gh issue edit "$number" --add-label "docs:tutorial" --repo "$REPO" 2>/dev/null || true
        fi

        if echo "$text" | grep -iE "guide|getting started" > /dev/null; then
            gh issue edit "$number" --add-label "docs:guide" --repo "$REPO" 2>/dev/null || true
        fi
    done

    # Generate documentation backlog report
    echo ""
    echo "Documentation Backlog:"
    for label in "${doc_labels[@]}"; do
        local count=$(gh issue list --repo "$REPO" --label "$label" --json number --jq 'length')
        echo "  $label: $count issues"
    done
}

# Workflow 8: Weekly Team Report
generate_weekly_report() {
    local output_file="${1:-weekly-report-$(date +%Y-%m-%d).md}"

    echo "Generating weekly team report..."

    cat > "$output_file" <<EOF
# Weekly Team Report
Week Ending: $(date +%Y-%m-%d)

## Summary Statistics

- Issues Opened: $(gh issue list --repo "$REPO" --limit 100 --json createdAt | jq '[.[] | select((now - (.createdAt | fromdateiso8601)) / 86400 < 7)] | length')
- Issues Closed: $(gh issue list --repo "$REPO" --state closed --limit 100 --json closedAt | jq '[.[] | select((.closedAt != null) and ((now - (.closedAt | fromdateiso8601)) / 86400 < 7))] | length')
- Active Contributors: $(gh issue list --repo "$REPO" --limit 100 --json assignees | jq '[.[].assignees[]? | .login] | unique | length')

## Top Active Issues

EOF

    gh issue list --repo "$REPO" \
        --limit 10 \
        --json number,title,comments \
    | jq -r 'sort_by(.comments) | reverse | .[] | "- #\(.number): \(.title) (\(.comments) comments)"' \
        >> "$output_file"

    cat >> "$output_file" <<EOF

## Team Activity

EOF

    gh issue list --repo "$REPO" \
        --limit 100 \
        --json assignees \
    | jq -r '
        [.[].assignees[].login] |
        group_by(.) |
        map({user: .[0], count: length}) |
        sort_by(-.count)[] |
        "- @\(.user): \(.count) issues"
    ' >> "$output_file"

    echo "Report generated: $output_file"
}

# Example usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        sprint)
            shift
            sprint_label="$1"
            shift
            complete_sprint_planning "$sprint_label" "$@"
            ;;
        standup)
            generate_standup_report "${2:-all}" "${3}"
            ;;
        bug-triage)
            automated_bug_triage
            ;;
        release)
            prepare_release_checklist "${2}" "${3}"
            ;;
        stale)
            manage_stale_issues "${2:-30}" "${3:-60}"
            ;;
        balance)
            shift
            max="${1:-5}"
            shift
            balance_team_workload "$max" "$@"
            ;;
        docs)
            manage_documentation_issues
            ;;
        weekly)
            generate_weekly_report "${2}"
            ;;
        *)
            echo "Usage: $0 {command} [args...]"
            echo ""
            echo "Real-World Workflows:"
            echo "  sprint LABEL MEMBER1 MEMBER2 ...     - Complete sprint planning"
            echo "  standup [TEAM] [FILE]                - Daily standup report"
            echo "  bug-triage                           - Automated bug triage"
            echo "  release VERSION MILESTONE            - Release checklist"
            echo "  stale [STALE_DAYS] [CLOSE_DAYS]      - Manage stale issues"
            echo "  balance MAX USER1 USER2 ...          - Balance workload"
            echo "  docs                                 - Manage documentation"
            echo "  weekly [FILE]                        - Weekly report"
            exit 1
            ;;
    esac
fi
