# GitHub CLI Issue State Management & Lifecycle Operations Test Report

**Repository**: https://github.com/terrylica/knowledgebase
**Test Date**: 2025-10-23
**GitHub CLI Version**: Tested with gh CLI
**Authentication**: terrylica account (active)

---

## Executive Summary

This report documents comprehensive testing of GitHub CLI issue lifecycle operations, including state transitions, close reasons, pin/unpin operations, lock/unlock with various reasons, and status commands. All operations were executed on real issues to document actual behaviors.

---

## 1. State Transitions

### 1.1 Create Issues (Default: OPEN)

Issues are created in `OPEN` state by default with no `stateReason`.

```bash
gh issue create --repo terrylica/knowledgebase \
  --title "Test Issue 1: State Management" \
  --body "This is test issue 1 for testing GitHub CLI state management and lifecycle operations."
```

**Result**: Creates issue in `OPEN` state with empty `stateReason` field.

**JSON Output**:
```json
{
  "number": 1,
  "state": "OPEN",
  "stateReason": "",
  "title": "Test Issue 1: State Management"
}
```

---

## 2. Close Operations

### 2.1 Close Reasons

GitHub supports two explicit close reasons:

| Reason | Flag Syntax | State Reason |
|--------|-------------|--------------|
| Completed | `--reason "completed"` | `COMPLETED` |
| Not Planned | `--reason "not planned"` | `NOT_PLANNED` |

### 2.2 Close as Completed

```bash
gh issue close 1 --repo terrylica/knowledgebase --reason "completed"
```

**Output**:
```
✓ Closed issue terrylica/knowledgebase#1 (Test Issue 1: State Management)
```

**Result State**:
```json
{
  "number": 1,
  "state": "CLOSED",
  "stateReason": "COMPLETED",
  "closedAt": "2025-10-23T18:12:09Z"
}
```

### 2.3 Close as Not Planned

```bash
gh issue close 2 --repo terrylica/knowledgebase --reason "not planned"
```

**Output**:
```
✓ Closed issue terrylica/knowledgebase#2 (Test Issue 2: State Management)
```

**Result State**:
```json
{
  "number": 2,
  "state": "CLOSED",
  "stateReason": "NOT_PLANNED",
  "closedAt": "2025-10-23T18:12:10Z"
}
```

### 2.4 Close with Comment (No Explicit Reason)

```bash
gh issue close 4 --repo terrylica/knowledgebase \
  --comment "Closing this issue with a comment to document the closure reason."
```

**Output**:
```
✓ Closed issue terrylica/knowledgebase#4 (Test Issue 3: State Management)
```

**Behavior**: When no `--reason` is specified, defaults to `COMPLETED`.

**Result State**:
```json
{
  "number": 4,
  "state": "CLOSED",
  "stateReason": "COMPLETED",
  "closedAt": "2025-10-23T18:12:12Z"
}
```

### 2.5 Close with Both Reason and Comment

```bash
gh issue close 5 --repo terrylica/knowledgebase \
  --reason "completed" \
  --comment "Task completed successfully. Closing as done."
```

**Output**:
```
✓ Closed issue terrylica/knowledgebase#5 (Test Issue 4: State Management)
```

**Result**: Issue closed with specified reason and comment added to conversation.

---

## 3. Reopen Operations

### 3.1 Basic Reopen

```bash
gh issue reopen 1 --repo terrylica/knowledgebase
```

**Output**:
```
✓ Reopened issue terrylica/knowledgebase#1 (Test Issue 1: State Management)
```

**Result State**:
```json
{
  "number": 1,
  "state": "OPEN",
  "stateReason": "REOPENED"
}
```

**Note**: The `stateReason` changes to `REOPENED` to indicate the issue was previously closed.

### 3.2 Reopen with Comment

```bash
gh issue reopen 2 --repo terrylica/knowledgebase \
  --comment "Reopening this issue as we need to reconsider the requirements."
```

**Output**:
```
✓ Reopened issue terrylica/knowledgebase#2 (Test Issue 2: State Management)
```

**Result**: Issue reopened with `REOPENED` state reason and comment added.

### 3.3 State Reason Persistence

**Important Discovery**: Once an issue is reopened, the `stateReason` remains `REOPENED` even after subsequent closes. The close reason takes precedence when the issue is closed again.

**Example Sequence**:
1. Issue created: `state=OPEN`, `stateReason=""`
2. Issue closed as completed: `state=CLOSED`, `stateReason="COMPLETED"`
3. Issue reopened: `state=OPEN`, `stateReason="REOPENED"`
4. Issue closed as not planned: `state=CLOSED`, `stateReason="NOT_PLANNED"`

---

## 4. Pin/Unpin Operations

### 4.1 Pin Limit Discovery

**Maximum Pinned Issues**: 3 per repository

```bash
gh issue pin 1 --repo terrylica/knowledgebase
gh issue pin 2 --repo terrylica/knowledgebase
gh issue pin 7 --repo terrylica/knowledgebase
# First 3 pins succeed

gh issue pin 10 --repo terrylica/knowledgebase
# Fourth pin fails
```

**Error Output**:
```
GraphQL: Maximum 3 pinned issues per repository (pinIssue)
```

### 4.2 Pin Operation

```bash
gh issue pin 1 --repo terrylica/knowledgebase
```

**Output**:
```
✓ Pinned issue terrylica/knowledgebase#1 (Test Issue 1: State Management)
```

**Verification**:
```bash
gh issue view 1 --repo terrylica/knowledgebase --json isPinned
```

**Result**:
```json
{
  "isPinned": true
}
```

### 4.3 Unpin Operation

```bash
gh issue unpin 1 --repo terrylica/knowledgebase
```

**Output**:
```
✓ Unpinned issue terrylica/knowledgebase#1 (Test Issue 1: State Management)
```

**Result**: `isPinned` field changes to `false`.

### 4.4 Pin Management Strategy

To pin a new issue when at limit:
1. Unpin an existing issue first
2. Then pin the new issue

```bash
gh issue unpin 1 --repo terrylica/knowledgebase
gh issue pin 10 --repo terrylica/knowledgebase
```

---

## 5. Lock/Unlock Operations

### 5.1 Lock Reasons

GitHub supports four lock reasons with **underscore** syntax:

| Reason | Flag Syntax | Description |
|--------|-------------|-------------|
| Off Topic | `--reason "off_topic"` | Discussion is off-topic |
| Too Heated | `--reason "too_heated"` | Discussion is too heated |
| Resolved | `--reason "resolved"` | Issue is resolved |
| Spam | `--reason "spam"` | Issue contains spam |

**Important**: Use underscores (`off_topic`, `too_heated`), NOT hyphens (`off-topic`, `too-heated`).

### 5.2 Lock with Reason: Off Topic

```bash
gh issue lock 12 --repo terrylica/knowledgebase --reason "off_topic"
```

**Output**: Silent success (no output on success)

### 5.3 Lock with Reason: Too Heated

```bash
gh issue lock 5 --repo terrylica/knowledgebase --reason "too_heated"
```

**Output**: Silent success

### 5.4 Lock with Reason: Resolved

```bash
gh issue lock 14 --repo terrylica/knowledgebase --reason "resolved"
```

**Output**: Silent success

### 5.5 Lock with Reason: Spam

```bash
gh issue lock 4 --repo terrylica/knowledgebase --reason "spam"
```

**Output**: Silent success

### 5.6 Lock without Reason

```bash
gh issue lock 7 --repo terrylica/knowledgebase
```

**Behavior**: Locks successfully without specifying a reason. Silent success.

### 5.7 Invalid Reason Errors

```bash
gh issue lock 12 --repo terrylica/knowledgebase --reason "off-topic"
# Error: invalid reason off-topic

gh issue lock 5 --repo terrylica/knowledgebase --reason "too heated"
# Error: invalid reason too heated
```

**Note**: Must use exact underscore syntax.

### 5.8 Unlock Operation

```bash
gh issue unlock 12 --repo terrylica/knowledgebase
```

**Output**: Silent success (no output on success)

### 5.9 Lock Status Visibility

**Important Discovery**: Lock status is NOT available in JSON output fields.

```bash
gh issue view 12 --repo terrylica/knowledgebase --json locked,activeLockReason
# Error: Unknown JSON field: "locked"
```

**Available JSON Fields**:
- assignees
- author
- body
- closed
- closedAt
- comments
- createdAt
- id
- isPinned
- labels
- milestone
- number
- state
- stateReason
- title
- updatedAt
- url

**Workaround**: Use `gh issue view <number> --web` to check lock status in browser.

---

## 6. Status Command Capabilities

### 6.1 Basic Status Command

```bash
gh issue status --repo terrylica/knowledgebase
```

**Output**:
```
Relevant issues in terrylica/knowledgebase

Issues assigned to you
  55	OPEN	Feature: Multi-factor authentication	enhancement, priority:high, security, api, backend	2025-10-23T18:13:36Z
  48	OPEN	Security: SQL injection vulnerability in search	bug, priority:critical, security, backend	2025-10-23T18:13:33Z
  ...

Issues mentioning you
  9	OPEN	Comment Test 3: Linking and Mentions		2025-10-23T18:13:01Z

Issues opened by you
  16	OPEN	Comment Test 5: Bulk Operations		2025-10-23T18:13:38Z
  55	OPEN	Feature: Multi-factor authentication	enhancement, priority:high, security, api, backend	2025-10-23T18:13:36Z
  ...
```

### 6.2 JSON Status Output

```bash
gh issue list --repo terrylica/knowledgebase \
  --state all \
  --limit 10 \
  --json number,title,state,stateReason,isPinned
```

**Output**:
```json
[
  {
    "isPinned": false,
    "number": 55,
    "state": "OPEN",
    "stateReason": "",
    "title": "Feature: Multi-factor authentication"
  },
  {
    "isPinned": false,
    "number": 52,
    "state": "CLOSED",
    "stateReason": "COMPLETED",
    "title": "Bug: Fix typo in error message"
  },
  {
    "isPinned": false,
    "number": 46,
    "state": "CLOSED",
    "stateReason": "NOT_PLANNED",
    "title": "Bug: Minor UI glitch in sidebar"
  }
]
```

### 6.3 Filter by State

```bash
# List only open issues
gh issue list --repo terrylica/knowledgebase --state open

# List only closed issues
gh issue list --repo terrylica/knowledgebase --state closed

# List all issues
gh issue list --repo terrylica/knowledgebase --state all
```

### 6.4 Analyze Close Reasons with jq

```bash
gh issue list --repo terrylica/knowledgebase \
  --state closed \
  --json number,title,stateReason,closedAt \
  --limit 100 | \
  jq 'group_by(.stateReason) | map({
    reason: .[0].stateReason,
    count: length,
    issues: map({number, title})
  })'
```

**Output**:
```json
[
  {
    "reason": "COMPLETED",
    "count": 4,
    "issues": [
      {"number": 52, "title": "Bug: Fix typo in error message"},
      {"number": 41, "title": "Bug: Authentication failure in login module"},
      {"number": 5, "title": "Test Issue 4: State Management"},
      {"number": 4, "title": "Test Issue 3: State Management"}
    ]
  },
  {
    "reason": "NOT_PLANNED",
    "count": 2,
    "issues": [
      {"number": 56, "title": "Lifecycle Example: Add user profile page"},
      {"number": 46, "title": "Bug: Minor UI glitch in sidebar"}
    ]
  }
]
```

---

## 7. Complete Lifecycle Example

### 7.1 Full Issue Lifecycle Commands

```bash
# Create issue
gh issue create --repo terrylica/knowledgebase \
  --title "Lifecycle Example: Add user profile page" \
  --body "Complete lifecycle demonstration issue"
# Result: Issue #56 created in OPEN state

# Pin issue
gh issue pin 56 --repo terrylica/knowledgebase
# Result: isPinned = true

# Close as completed with comment
gh issue close 56 --repo terrylica/knowledgebase \
  --reason "completed" \
  --comment "Work completed successfully"
# Result: state=CLOSED, stateReason=COMPLETED

# Reopen with comment
gh issue reopen 56 --repo terrylica/knowledgebase \
  --comment "Need to add more features"
# Result: state=OPEN, stateReason=REOPENED

# Lock conversation as resolved
gh issue lock 56 --repo terrylica/knowledgebase --reason "resolved"
# Result: Issue locked (silent success)

# Unlock conversation
gh issue unlock 56 --repo terrylica/knowledgebase
# Result: Issue unlocked (silent success)

# Close as not planned
gh issue close 56 --repo terrylica/knowledgebase --reason "not planned"
# Result: state=CLOSED, stateReason=NOT_PLANNED

# Unpin issue
gh issue unpin 56 --repo terrylica/knowledgebase
# Result: isPinned = false
```

### 7.2 State Progression

```
OPEN (stateReason: "")
  ↓ pin
OPEN (stateReason: "", isPinned: true)
  ↓ close --reason "completed"
CLOSED (stateReason: "COMPLETED", isPinned: true)
  ↓ reopen
OPEN (stateReason: "REOPENED", isPinned: true)
  ↓ lock --reason "resolved"
OPEN (stateReason: "REOPENED", isPinned: true, locked)
  ↓ unlock
OPEN (stateReason: "REOPENED", isPinned: true)
  ↓ close --reason "not planned"
CLOSED (stateReason: "NOT_PLANNED", isPinned: true)
  ↓ unpin
CLOSED (stateReason: "NOT_PLANNED", isPinned: false)
```

### 7.3 View Full Conversation History

```bash
gh issue view 56 --repo terrylica/knowledgebase \
  --json number,title,body,comments \
  --jq '{
    number,
    title,
    body,
    comments: .comments | map({
      author: .author.login,
      body: .body,
      createdAt: .createdAt
    })
  }'
```

**Output**:
```json
{
  "body": "Complete lifecycle demonstration issue",
  "comments": [
    {
      "author": "terrylica",
      "body": "Work completed successfully",
      "createdAt": "2025-10-23T18:14:22Z"
    },
    {
      "author": "terrylica",
      "body": "Need to add more features",
      "createdAt": "2025-10-23T18:14:24Z"
    }
  ],
  "number": 56,
  "title": "Lifecycle Example: Add user profile page"
}
```

---

## 8. Key Findings & Best Practices

### 8.1 State Transitions

| Operation | Command | State Change | State Reason |
|-----------|---------|--------------|--------------|
| Create | `gh issue create` | → OPEN | "" (empty) |
| Close (completed) | `gh issue close --reason "completed"` | OPEN → CLOSED | → COMPLETED |
| Close (not planned) | `gh issue close --reason "not planned"` | OPEN → CLOSED | → NOT_PLANNED |
| Close (default) | `gh issue close` | OPEN → CLOSED | → COMPLETED |
| Reopen | `gh issue reopen` | CLOSED → OPEN | → REOPENED |

### 8.2 Pin/Unpin

- **Maximum**: 3 pinned issues per repository
- **Pin Status**: Available via `isPinned` field in JSON output
- **Management**: Must unpin before pinning new issue when at limit
- **Visibility**: Pinned issues appear at top of issue list on GitHub web

### 8.3 Lock/Unlock

- **Valid Reasons**: `off_topic`, `too_heated`, `resolved`, `spam`
- **Syntax**: Use underscores, not hyphens
- **Optional Reason**: Can lock without specifying reason
- **Silent Operations**: Lock/unlock commands succeed silently (no output)
- **Status Visibility**: Lock status NOT available in JSON output (use web view)

### 8.4 Close Reasons

- **Two Options**: `completed` or `not planned`
- **Default Behavior**: Closing without `--reason` defaults to `completed`
- **With Comments**: Can combine `--reason` and `--comment` flags
- **Reason Persistence**: Close reason stored in `stateReason` field

### 8.5 State Reason Tracking

- **OPEN**: Empty string for new issues, `REOPENED` for reopened issues
- **CLOSED**: `COMPLETED` or `NOT_PLANNED`
- **Persistence**: State reason changes with each state transition
- **Visibility**: Fully accessible via JSON output

---

## 9. Command Reference

### 9.1 Essential Commands

```bash
# State transitions
gh issue close <number> [--reason "completed"|"not planned"] [--comment "text"]
gh issue reopen <number> [--comment "text"]

# Pin/Unpin
gh issue pin <number>
gh issue unpin <number>

# Lock/Unlock
gh issue lock <number> [--reason "off_topic"|"too_heated"|"resolved"|"spam"]
gh issue unlock <number>

# Status & Viewing
gh issue status
gh issue list [--state open|closed|all] [--limit N]
gh issue view <number> [--json fields] [--web]

# JSON Output
gh issue view <number> --json state,stateReason,isPinned,closed,closedAt
gh issue list --json number,title,state,stateReason,isPinned
```

### 9.2 Useful JSON Queries

```bash
# List all pinned issues
gh issue list --state all --json number,title,isPinned | \
  jq '.[] | select(.isPinned == true)'

# Group closed issues by reason
gh issue list --state closed --json number,title,stateReason | \
  jq 'group_by(.stateReason)'

# Find reopened issues
gh issue list --state open --json number,title,stateReason | \
  jq '.[] | select(.stateReason == "REOPENED")'
```

---

## 10. Limitations & Workarounds

### 10.1 Lock Status Visibility

**Limitation**: Lock status and lock reason not available in JSON output.

**Workaround**: Use web view for lock verification:
```bash
gh issue view <number> --web
```

### 10.2 Pin Limit

**Limitation**: Maximum 3 pinned issues per repository.

**Workaround**: Implement pin rotation strategy:
```bash
# Unpin old issue before pinning new one
gh issue unpin <old-number>
gh issue pin <new-number>
```

### 10.3 State Reason History

**Limitation**: No built-in command to view state reason history.

**Workaround**: Use GitHub Events API via GraphQL:
```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      issue(number: $number) {
        timelineItems(first: 100, itemTypes: [CLOSED_EVENT, REOPENED_EVENT]) {
          nodes {
            ... on ClosedEvent {
              createdAt
              stateReason
            }
            ... on ReopenedEvent {
              createdAt
            }
          }
        }
      }
    }
  }
' -f owner=terrylica -f repo=knowledgebase -F number=56
```

---

## 11. Testing Summary

### 11.1 Test Coverage

| Feature | Test Cases | Status |
|---------|-----------|--------|
| Issue Creation | 8 test issues | ✓ Passed |
| Close Operations | 4 variations (completed, not planned, with comment, both) | ✓ Passed |
| Reopen Operations | 2 variations (basic, with comment) | ✓ Passed |
| Pin/Unpin | 4 pins (limit discovery), 2 unpins | ✓ Passed |
| Lock/Unlock | 5 lock operations (4 reasons + no reason), 2 unlocks | ✓ Passed |
| Status Commands | 3 variations (basic, JSON, filtered) | ✓ Passed |
| Complete Lifecycle | 1 full lifecycle demonstration | ✓ Passed |

### 11.2 Issues Created

Test issues created and used:
- Issues #1, #2, #4, #5, #7, #10, #12, #14 (state management tests)
- Issue #56 (complete lifecycle example)

### 11.3 Discovery Highlights

1. **Pin Limit**: Discovered maximum 3 pinned issues per repository
2. **Lock Reason Syntax**: Confirmed underscore requirement (not hyphens)
3. **Lock Status**: Identified lack of JSON support for lock status
4. **Close Default**: Confirmed default close reason is "completed"
5. **State Reason**: Documented complete state reason progression

---

## 12. Conclusion

GitHub CLI provides comprehensive issue lifecycle management capabilities with well-defined state transitions, close reasons, and conversation controls. Key operational patterns:

1. **State Management**: Clear distinction between OPEN/CLOSED with semantic close reasons
2. **Pin Management**: Limited but functional pinning system (3 issue maximum)
3. **Lock Management**: Flexible locking with semantic reasons for conversation control
4. **JSON Integration**: Excellent JSON output support (except lock status)
5. **Comment Integration**: All state transitions support optional comments

The CLI provides production-ready issue management suitable for automation and scripting workflows.

---

**Report Generated**: 2025-10-23
**Test Repository**: https://github.com/terrylica/knowledgebase
**Report Location**: `/Users/terryli/eon/knowledgebase/github-cli-issue-lifecycle-test-report.md`
