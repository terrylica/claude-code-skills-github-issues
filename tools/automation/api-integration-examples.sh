#!/usr/bin/env bash
# GitHub API Integration Examples
# Purpose: Access features not available in gh CLI using gh api

set -euo pipefail

REPO="${GH_REPO:-terrylica/knowledgebase}"
OWNER="${REPO%/*}"
REPO_NAME="${REPO#*/}"

# Example 1: Lock/Unlock issues (not available in gh CLI)
lock_issue() {
    local issue_num="$1"
    local lock_reason="${2:-resolved}"  # resolved, off-topic, too heated, spam

    echo "Locking issue #$issue_num with reason: $lock_reason"
    gh api \
        -X PUT \
        "/repos/$OWNER/$REPO_NAME/issues/$issue_num/lock" \
        -f lock_reason="$lock_reason"
}

unlock_issue() {
    local issue_num="$1"

    echo "Unlocking issue #$issue_num"
    gh api \
        -X DELETE \
        "/repos/$OWNER/$REPO_NAME/issues/$issue_num/lock"
}

# Example 2: Pin/Unpin issues (not available in gh CLI)
pin_issue() {
    local issue_num="$1"

    echo "Pinning issue #$issue_num"
    gh api graphql -f query='
        mutation($issueId: ID!) {
            pinIssue(input: {issueId: $issueId}) {
                issue {
                    number
                    title
                }
            }
        }
    ' -f issueId="$(get_issue_node_id "$issue_num")"
}

unpin_issue() {
    local issue_num="$1"

    echo "Unpinning issue #$issue_num"
    gh api graphql -f query='
        mutation($issueId: ID!) {
            unpinIssue(input: {issueId: $issueId}) {
                issue {
                    number
                    title
                }
            }
        }
    ' -f issueId="$(get_issue_node_id "$issue_num")"
}

# Helper: Get issue node ID for GraphQL
get_issue_node_id() {
    local issue_num="$1"

    gh api graphql -f query='
        query($owner: String!, $repo: String!, $number: Int!) {
            repository(owner: $owner, name: $repo) {
                issue(number: $number) {
                    id
                }
            }
        }
    ' -f owner="$OWNER" -f repo="$REPO_NAME" -F number="$issue_num" \
    | jq -r '.data.repository.issue.id'
}

# Example 3: Bulk update reactions (not available in gh CLI)
add_reaction_to_issue() {
    local issue_num="$1"
    local reaction="$2"  # +1, -1, laugh, confused, heart, hooray, rocket, eyes

    echo "Adding reaction '$reaction' to issue #$issue_num"
    gh api \
        -X POST \
        "/repos/$OWNER/$REPO_NAME/issues/$issue_num/reactions" \
        -f content="$reaction"
}

get_issue_reactions() {
    local issue_num="$1"

    echo "Reactions for issue #$issue_num:"
    gh api \
        "/repos/$OWNER/$REPO_NAME/issues/$issue_num/reactions" \
        --jq '.[] | "\(.user.login): \(.content)"'
}

# Example 4: Issue timeline events
get_issue_timeline() {
    local issue_num="$1"

    echo "Timeline for issue #$issue_num:"
    gh api \
        "/repos/$OWNER/$REPO_NAME/issues/$issue_num/timeline" \
        --paginate \
        --jq '.[] | "\(.created_at) [\(.event)] by \(.actor.login // "system")"'
}

# Example 5: Detailed issue metrics
get_issue_metrics() {
    local issue_num="$1"

    echo "Metrics for issue #$issue_num:"
    gh api \
        "/repos/$OWNER/$REPO_NAME/issues/$issue_num" \
    | jq '{
        number,
        title,
        state,
        comments: .comments,
        reactions: .reactions.total_count,
        created: .created_at,
        updated: .updated_at,
        closed: .closed_at,
        labels: [.labels[].name],
        assignees: [.assignees[].login]
    }'
}

# Example 6: Bulk create issues from file
bulk_create_from_csv() {
    local csv_file="$1"

    echo "Creating issues from CSV: $csv_file"

    # CSV format: title,body,labels,assignees
    tail -n +2 "$csv_file" | while IFS=, read -r title body labels assignees; do
        echo "Creating: $title"

        local label_args=""
        if [[ -n "$labels" ]]; then
            IFS=';' read -ra label_array <<< "$labels"
            for label in "${label_array[@]}"; do
                label_args="$label_args -f labels[]=$label"
            done
        fi

        local assignee_args=""
        if [[ -n "$assignees" ]]; then
            IFS=';' read -ra assignee_array <<< "$assignees"
            for assignee in "${assignee_array[@]}"; do
                assignee_args="$assignee_args -f assignees[]=$assignee"
            done
        fi

        gh api \
            -X POST \
            "/repos/$OWNER/$REPO_NAME/issues" \
            -f title="$title" \
            -f body="$body" \
            $label_args \
            $assignee_args
    done
}

# Example 7: Issue dependencies using task lists
parse_task_list_dependencies() {
    local issue_num="$1"

    echo "Task list dependencies for issue #$issue_num:"
    gh api "/repos/$OWNER/$REPO_NAME/issues/$issue_num" \
    | jq -r '.body // ""' \
    | grep -E '^\s*-\s*\[([ x])\]' \
    | while read -r line; do
        if echo "$line" | grep -q '\[x\]'; then
            status="DONE"
        else
            status="TODO"
        fi
        task=$(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*\[[[:space:]x]*\][[:space:]]*//')
        echo "  [$status] $task"
    done
}

# Example 8: Cross-repository issue search
search_issues_across_repos() {
    local query="$1"
    local org="$2"

    echo "Searching issues in $org for: $query"
    gh api \
        "/search/issues?q=$(printf %s "$query" | jq -sRr @uri)+org:$org+type:issue" \
        --paginate \
        --jq '.items[] | "#\(.number) [\(.repository_url | split("/")[-1])]: \(.title)"'
}

# Example 9: Issue statistics with GraphQL
get_advanced_stats() {
    echo "Advanced Repository Statistics:"

    gh api graphql -f query='
        query($owner: String!, $repo: String!) {
            repository(owner: $owner, name: $repo) {
                issues(first: 100, states: [OPEN]) {
                    totalCount
                    nodes {
                        createdAt
                        comments {
                            totalCount
                        }
                        reactions {
                            totalCount
                        }
                    }
                }
                closedIssues: issues(first: 100, states: [CLOSED]) {
                    totalCount
                }
            }
        }
    ' -f owner="$OWNER" -f repo="$REPO_NAME" \
    | jq '{
        total_open: .data.repository.issues.totalCount,
        total_closed: .data.repository.closedIssues.totalCount,
        avg_comments: (
            [.data.repository.issues.nodes[].comments.totalCount] |
            add / length
        ),
        avg_reactions: (
            [.data.repository.issues.nodes[].reactions.totalCount] |
            add / length
        )
    }'
}

# Example 10: Issue linking (mentions)
link_issues() {
    local source_issue="$1"
    local target_issue="$2"
    local link_type="${3:-relates to}"

    echo "Linking issue #$source_issue $link_type #$target_issue"
    gh issue comment "$source_issue" \
        --body "This issue $link_type #$target_issue" \
        --repo "$REPO"
}

# Example 11: Bulk update issue fields
bulk_update_issues() {
    local -a issue_numbers=("${@:1:$#-3}")
    local field="${@:$#-2:1}"
    local value="${@:$#-1:1}"

    echo "Bulk updating $field to '$value' for ${#issue_numbers[@]} issues"

    for issue_num in "${issue_numbers[@]}"; do
        case "$field" in
            milestone)
                gh api \
                    -X PATCH \
                    "/repos/$OWNER/$REPO_NAME/issues/$issue_num" \
                    -F milestone="$value"
                ;;
            state)
                gh api \
                    -X PATCH \
                    "/repos/$OWNER/$REPO_NAME/issues/$issue_num" \
                    -f state="$value"
                ;;
            *)
                echo "Unknown field: $field"
                return 1
                ;;
        esac
        echo "  Updated issue #$issue_num"
    done
}

# Example 12: Issue activity heatmap data
generate_activity_heatmap_data() {
    echo "Generating activity heatmap data..."

    gh api \
        "/repos/$OWNER/$REPO_NAME/issues?state=all&per_page=100" \
        --paginate \
    | jq -r '
        [.[] | .created_at[0:10]] |
        group_by(.) |
        map({date: .[0], count: length}) |
        .[] |
        "\(.date),\(.count)"
    ' | sort
}

# Example 13: Get issue participants
get_issue_participants() {
    local issue_num="$1"

    echo "Participants in issue #$issue_num:"

    # Get comments and extract users
    gh api \
        "/repos/$OWNER/$REPO_NAME/issues/$issue_num/comments" \
        --paginate \
    | jq -r '[.[].user.login] | unique | .[] | "  @\(.)"'
}

# Example 14: Clone issue to another repo
clone_issue() {
    local source_issue="$1"
    local target_repo="$2"

    echo "Cloning issue #$source_issue to $target_repo"

    # Get source issue
    local issue_data=$(gh api "/repos/$OWNER/$REPO_NAME/issues/$source_issue")

    local title=$(echo "$issue_data" | jq -r '.title')
    local body=$(echo "$issue_data" | jq -r '.body // ""')
    local labels=$(echo "$issue_data" | jq -r '[.labels[].name] | join(",")')

    # Create in target repo
    local new_issue=$(gh issue create \
        --repo "$target_repo" \
        --title "$title" \
        --body "Cloned from $REPO#$source_issue\n\n$body" \
        --label "$labels")

    echo "Created: $new_issue"
}

# Example 15: Export issue thread to JSON
export_issue_thread() {
    local issue_num="$1"
    local output_file="${2:-issue-${issue_num}.json}"

    echo "Exporting issue #$issue_num to $output_file"

    {
        echo "{"
        echo "  \"issue\": $(gh api "/repos/$OWNER/$REPO_NAME/issues/$issue_num"),"
        echo "  \"comments\": $(gh api "/repos/$OWNER/$REPO_NAME/issues/$issue_num/comments" --paginate),"
        echo "  \"events\": $(gh api "/repos/$OWNER/$REPO_NAME/issues/$issue_num/events" --paginate)"
        echo "}"
    } | jq '.' > "$output_file"

    echo "Exported to: $output_file"
}

# Example usage
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-help}" in
        lock)
            lock_issue "${2}" "${3:-resolved}"
            ;;
        unlock)
            unlock_issue "${2}"
            ;;
        pin)
            pin_issue "${2}"
            ;;
        unpin)
            unpin_issue "${2}"
            ;;
        react)
            add_reaction_to_issue "${2}" "${3}"
            ;;
        reactions)
            get_issue_reactions "${2}"
            ;;
        timeline)
            get_issue_timeline "${2}"
            ;;
        metrics)
            get_issue_metrics "${2}"
            ;;
        bulk-create)
            bulk_create_from_csv "${2}"
            ;;
        tasks)
            parse_task_list_dependencies "${2}"
            ;;
        search)
            search_issues_across_repos "${2}" "${3}"
            ;;
        stats)
            get_advanced_stats
            ;;
        link)
            link_issues "${2}" "${3}" "${4:-relates to}"
            ;;
        bulk-update)
            shift
            bulk_update_issues "$@"
            ;;
        heatmap)
            generate_activity_heatmap_data
            ;;
        participants)
            get_issue_participants "${2}"
            ;;
        clone)
            clone_issue "${2}" "${3}"
            ;;
        export)
            export_issue_thread "${2}" "${3}"
            ;;
        *)
            echo "Usage: $0 {command} [args...]"
            echo ""
            echo "Commands:"
            echo "  lock ISSUE [REASON]              - Lock issue"
            echo "  unlock ISSUE                     - Unlock issue"
            echo "  pin ISSUE                        - Pin issue"
            echo "  unpin ISSUE                      - Unpin issue"
            echo "  react ISSUE REACTION             - Add reaction"
            echo "  reactions ISSUE                  - Get reactions"
            echo "  timeline ISSUE                   - Get timeline"
            echo "  metrics ISSUE                    - Get metrics"
            echo "  bulk-create CSV_FILE             - Create from CSV"
            echo "  tasks ISSUE                      - Parse task list"
            echo "  search QUERY ORG                 - Search across repos"
            echo "  stats                            - Advanced statistics"
            echo "  link SOURCE TARGET [TYPE]        - Link issues"
            echo "  bulk-update ISSUES... FIELD VAL  - Bulk update"
            echo "  heatmap                          - Activity heatmap"
            echo "  participants ISSUE               - Get participants"
            echo "  clone ISSUE TARGET_REPO          - Clone issue"
            echo "  export ISSUE [FILE]              - Export thread"
            exit 1
            ;;
    esac
fi
