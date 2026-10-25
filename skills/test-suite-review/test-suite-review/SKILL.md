---
name: test-suite-review
description: Use when a user asks to review, clean up, or audit a test suite, or to find and remove low-quality or low-value tests.
---

# Test Suite Review

This skill covers how to review an existing test suite for quality and propose cleanups, primarily removing or consolidating tests that add little value.

## Focus

Determine the focus from the user's request:

- **Default: the current branch.** Start from the tests the branch adds or changes, compared against the merge base with the default branch. The goal is that the suite is in good shape for these changes, not just that the changed lines are clean.
- **A slice of the suite:** a path, module, or glob the user names.
- **Whole suite:** only when the user asks for it explicitly.

On a branch, follow relationships outward from the changes. Existing tests are in focus when they relate to the changes, for example:

- tests of the same code the branch changes
- tests that overlap with, duplicate, or could be merged with the new tests
- tests the branch makes redundant, outdated, or weaker than the new ones
- shared fixtures or helpers the new tests use or should use

Relatedness is a continuum, so use judgment. The further a test is from the branch's changes, the stronger the reason needed to include it. Leave out tests whose only connection is being in the same file or area.

Problems outside the focus are not part of the review. Don't go looking for them, and don't spend effort verifying ones you happen to notice. Mention one only if it looks high-value, such as a test that can't fail or one that asserts wrong behavior. In that case, list it briefly at the end, mark it as unverified, and don't propose a fix. Leave out everything else.

## What to look for

<!-- TODO: flesh out. Starting candidates: -->

- Tests that only assert the absence of old behavior rather than the presence of current behavior.
- Tests that exercise the mock or test setup instead of the code under test.
- Duplicate or near-duplicate tests that should be merged or parametrized.
- Tests that assert on implementation details likely to change without a behavior change.

## Workflow

<!-- TODO: steps, e.g., discover the project's test runner, survey the suite, classify findings, propose changes. -->

## Output format

<!-- TODO -->
