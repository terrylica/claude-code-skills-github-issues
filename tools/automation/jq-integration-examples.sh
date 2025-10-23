#!/usr/bin/env bash
# GitHub CLI + jq Integration Examples
# Purpose: Advanced data processing and filtering with jq

set -euo pipefail

REPO="${GH_REPO:-terrylica/knowledgebase}"

# Example 1: Complex filtering - Find issues with specific label combinations
find_multi_label_issues() {
    local label1="$1"
    local label2="$2"

    echo "Finding issues with both '$label1' AND '$label2' labels..."
    gh issue list --repo "$REPO" \
        --limit 100 \
        --json number,title,labels \
    | jq -r --arg l1 "$label1" --arg l2 "$label2" \
        '.[] | select(
            ([.labels[].name] | contains([$l1])) and
            ([.labels[].name] | contains([$l2]))
        ) | "#\(.number): \(.title)"'
}

# Example 2: Statistical analysis - Label usage statistics
analyze_label_stats() {
    echo "Label Usage Statistics:"
    echo "======================="

    gh issue list --repo "$REPO" \
        --state all \
        --limit 1000 \
        --json labels,state \
        --jq '
            [.[].labels[].name] |
            group_by(.) |
            map({
                label: .[0],
                count: length
            }) |
            sort_by(-.count) |
            .[] |
            "\(.label): \(.count) issues"
        '
}

# Example 3: Time-based analysis - Issues created per day/week
analyze_creation_trends() {
    echo "Issue Creation Trends (Last 30 days):"
    echo "======================================"

    gh issue list --repo "$REPO" \
        --limit 1000 \
        --json createdAt \
        --jq '
            [.[] |
                .createdAt |
                fromdateiso8601 |
                strftime("%Y-%m-%d")
            ] |
            group_by(.) |
            map({
                date: .[0],
                count: length
            }) |
            sort_by(.date) |
            .[-30:] |
            .[] |
            "\(.date): \(.count) issues"
        '
}

# Example 4: Cross-reference issues and PRs
cross_reference_issues_prs() {
    echo "Issues with Linked Pull Requests:"
    echo "=================================="

    # Get all issues
    local issues=$(gh issue list --repo "$REPO" \
        --limit 100 \
        --json number,title)

    # Get all PRs
    local prs=$(gh pr list --repo "$REPO" \
        --limit 100 \
        --json number,title,body)

    # Cross-reference
    echo "$prs" | jq -r --argjson issues "$issues" '
        .[] |
        .body // "" as $body |
        .number as $pr_num |
        .title as $pr_title |
        $issues[] |
        select($body | test("#\(.number)\\b")) |
        "Issue #\(.number) linked to PR #\($pr_num): \(.title)"
    '
}

# Example 5: Milestone progress tracking
track_milestone_progress() {
    local milestone="$1"

    echo "Milestone Progress: $milestone"
    echo "=============================="

    local data=$(gh issue list --repo "$REPO" \
        --milestone "$milestone" \
        --limit 1000 \
        --json number,state,labels)

    echo "$data" | jq -r '
        {
            total: length,
            open: [.[] | select(.state == "OPEN")] | length,
            closed: [.[] | select(.state == "CLOSED")] | length
        } |
        "Total: \(.total)",
        "Open: \(.open) (\((.open / .total * 100) | floor)%)",
        "Closed: \(.closed) (\((.closed / .total * 100) | floor)%)"
    '

    echo ""
    echo "Issues by Label:"
    echo "$data" | jq -r '
        [.[].labels[].name] |
        group_by(.) |
        map({label: .[0], count: length}) |
        sort_by(-.count)[] |
        "  \(.label): \(.count)"
    '
}

# Example 6: Find inactive issues
find_inactive_issues() {
    local days="${1:-30}"

    echo "Issues inactive for $days+ days:"
    echo "================================="

    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,title,updatedAt,comments \
    | jq -r --arg days "$days" '
        .[] |
        select((now - (.updatedAt | fromdateiso8601)) / 86400 > ($days | tonumber)) |
        {
            number,
            title,
            days_inactive: ((now - (.updatedAt | fromdateiso8601)) / 86400 | floor),
            comments: .comments | length
        } |
        "#\(.number): \(.title) (\(.days_inactive) days, \(.comments) comments)"
    '
}

# Example 7: Assignee workload distribution
analyze_workload() {
    echo "Assignee Workload Distribution:"
    echo "==============================="

    gh issue list --repo "$REPO" \
        --state open \
        --limit 1000 \
        --json assignees,labels \
        --jq '
            [.[].assignees[]] |
            group_by(.login) |
            map({
                user: .[0].login,
                count: length
            }) |
            sort_by(-.count)[] |
            "@\(.user): \(.count) issues"
        '

    echo ""
    echo "Unassigned Issues:"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 1000 \
        --json number,assignees \
        --jq '[.[] | select(.assignees | length == 0)] | length'
}

# Example 8: Label co-occurrence matrix
analyze_label_cooccurrence() {
    echo "Label Co-occurrence Analysis:"
    echo "============================="

    gh issue list --repo "$REPO" \
        --limit 1000 \
        --json labels \
        --jq '
            [
                .[] |
                .labels |
                map(.name) |
                sort |
                combinations(2) |
                join(" + ")
            ] |
            group_by(.) |
            map({
                pair: .[0],
                count: length
            }) |
            sort_by(-.count) |
            .[0:10] |
            .[] |
            "\(.pair): \(.count) issues"
        '
}

# Example 9: Issue velocity - Time to close
calculate_issue_velocity() {
    echo "Issue Velocity (Time to Close):"
    echo "================================"

    gh issue list --repo "$REPO" \
        --state closed \
        --limit 100 \
        --json number,createdAt,closedAt \
        --jq '
            [
                .[] |
                {
                    number,
                    days_to_close: (
                        (.closedAt | fromdateiso8601) -
                        (.createdAt | fromdateiso8601)
                    ) / 86400
                }
            ] |
            {
                avg: (map(.days_to_close) | add / length | floor),
                min: (map(.days_to_close) | min | floor),
                max: (map(.days_to_close) | max | floor),
                median: (
                    map(.days_to_close) |
                    sort |
                    .[length / 2 | floor] |
                    floor
                )
            } |
            "Average: \(.avg) days",
            "Median: \(.median) days",
            "Min: \(.min) days",
            "Max: \(.max) days"
        '
}

# Example 10: Export to CSV for external analysis
export_to_csv() {
    local output_file="${1:-issues.csv}"

    echo "Exporting issues to CSV: $output_file"

    gh issue list --repo "$REPO" \
        --limit 1000 \
        --json number,title,state,labels,assignees,createdAt,updatedAt,closedAt \
        --jq '
            ["Number", "Title", "State", "Labels", "Assignees", "Created", "Updated", "Closed"],
            (.[] | [
                .number,
                .title,
                .state,
                ([.labels[].name] | join(";")),
                ([.assignees[].login] | join(";")),
                .createdAt,
                .updatedAt,
                (.closedAt // "")
            ]) |
            @csv
        ' > "$output_file"

    echo "Export complete: $(wc -l < "$output_file") rows"
}

# Example 11: Generate markdown report
generate_markdown_report() {
    local output_file="${1:-report.md}"

    cat > "$output_file" <<EOF
# GitHub Issues Report
Generated: $(date)

## Summary Statistics

EOF

    # Total counts
    echo "### Total Issues" >> "$output_file"
    gh issue list --repo "$REPO" \
        --state all \
        --limit 1000 \
        --json state \
        --jq '
            group_by(.state) |
            map({state: .[0].state, count: length}) |
            .[] |
            "- \(.state): \(.count)"
        ' >> "$output_file"

    echo "" >> "$output_file"
    echo "### Top Labels" >> "$output_file"
    gh issue list --repo "$REPO" \
        --state open \
        --limit 1000 \
        --json labels \
        --jq '
            [.[].labels[].name] |
            group_by(.) |
            map({label: .[0], count: length}) |
            sort_by(-.count) |
            .[0:5] |
            .[] |
            "- \(.label): \(.count)"
        ' >> "$output_file"

    echo "" >> "$output_file"
    echo "### Recent Issues" >> "$output_file"
    gh issue list --repo "$REPO" \
        --limit 10 \
        --json number,title,createdAt \
        --jq '
            .[] |
            "- [#\(.number)](\(.number)): \(.title)"
        ' >> "$output_file"

    echo "Report generated: $output_file"
}

# Example 12: Complex filtering - Issues needing attention
find_issues_needing_attention() {
    echo "Issues Needing Attention:"
    echo "========================="

    gh issue list --repo "$REPO" \
        --state open \
        --limit 100 \
        --json number,title,labels,assignees,updatedAt,comments \
        --jq '
            .[] |
            select(
                (.assignees | length == 0) or
                (.labels | length == 0) or
                ((now - (.updatedAt | fromdateiso8601)) / 86400 > 14)
            ) |
            {
                number,
                title,
                issues: [
                    (if (.assignees | length == 0) then "no assignee" else empty end),
                    (if (.labels | length == 0) then "no labels" else empty end),
                    (if ((now - (.updatedAt | fromdateiso8601)) / 86400 > 14) then "stale" else empty end)
                ]
            } |
            "#\(.number): \(.title) - [\(.issues | join(", "))]"
        '
}

# Example usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        multi-label)
            find_multi_label_issues "${2}" "${3}"
            ;;
        label-stats)
            analyze_label_stats
            ;;
        trends)
            analyze_creation_trends
            ;;
        cross-ref)
            cross_reference_issues_prs
            ;;
        milestone)
            track_milestone_progress "${2}"
            ;;
        inactive)
            find_inactive_issues "${2:-30}"
            ;;
        workload)
            analyze_workload
            ;;
        cooccurrence)
            analyze_label_cooccurrence
            ;;
        velocity)
            calculate_issue_velocity
            ;;
        csv)
            export_to_csv "${2:-issues.csv}"
            ;;
        report)
            generate_markdown_report "${2:-report.md}"
            ;;
        attention)
            find_issues_needing_attention
            ;;
        *)
            echo "Usage: $0 {command} [args...]"
            echo ""
            echo "Commands:"
            echo "  multi-label LABEL1 LABEL2          - Find issues with multiple labels"
            echo "  label-stats                        - Label usage statistics"
            echo "  trends                             - Creation trends"
            echo "  cross-ref                          - Cross-reference issues and PRs"
            echo "  milestone NAME                     - Milestone progress"
            echo "  inactive [DAYS]                    - Find inactive issues"
            echo "  workload                           - Assignee workload"
            echo "  cooccurrence                       - Label co-occurrence"
            echo "  velocity                           - Time to close stats"
            echo "  csv [FILE]                         - Export to CSV"
            echo "  report [FILE]                      - Generate markdown report"
            echo "  attention                          - Issues needing attention"
            exit 1
            ;;
    esac
fi
