---
name: multi-agent-review
description: Use when a user asks for a multi-agent code review. 
---

# Multi-Agent Review

This skill covers how to dispatch multiple subagents with different instructions to conduct a code review.

## Workflow

Dispatch the following subagents in parallel to conduct a code review. If a model is not specified by the user, ask the user to specify one.

1. **Spec-aware reviewer**: This subagent should access and read any spec or plan documents for this change. If there are no documents, this subagent should be given a summary of any in-chat discussion context that functions like a spec.
2. **Adversarial reviewer**: This subagent is also spec-aware but explicitly instructed to be adversarial, i.e., willing to question key assumptions that may be off-base, design decisions that are ill-advised, incorrect framings of the problem. Sometimes the solution is bad because we're not solving the right problem, and this agent should be able to identify those cases. 
3. **Independent reviewer**: This subagent should be explicitly instructed _not_ to read any spec or plan documents for this change. This subagent should consider the current state of the code and review it based on its apparent merits. Minimize the extent of explanation of the changes when providing instructions.

All reviewers should be instructed with the following:

- The review target is the current working tree code state against the merge base. 
- Reviewers should ignore intermediate commit states and commit messages. The user generally squash-merges PRs so commits should not be interpreted as complete standalone changes.
- Reviewers should not run general checks like the test suite or code quality checks (e.g., linting, typechecking) unless investigating something specific. This was already done as part of implementation and running it again is redundant. 

After reviews are in, you (the dispatcher) should collate, verify, and triage the findings. Then present out for discussion. See section below for output format.

## Output format

- Report the findings as text.
- List the findings in order of severity.
- For each finding:
    - Give a clear and concise summary of the finding and which reviewers reported it.
    - Give a recommendation of "fix", "defer", or "dismiss".
    - For findings with a recommended fix, present the fix clearly. Show a diff of the proposed fix if appropriate and helpful for understanding.
