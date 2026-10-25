---
name: test-suite-review
description: Use when a user asks to review, clean up, or audit a test suite, or to find and remove low-quality or low-value tests.
---

# Test Suite Review

This skill covers how to review an existing test suite for quality and report recommended cleanups, primarily removing or consolidating tests that add little value. The review is read-only: don't modify any files.

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

This review is about cleanup. Missing coverage is out of scope; leave it to code review.

- **Speculative tests**: inputs the code never receives, hypothetical future edits, or exhaustive coverage of structurally symmetric cases.
- **Tautological tests**: asserting declared constants, fixture or template contents; re-implementing the code under test; asserting behavior the framework, a dependency, or the type checker already guarantees.
- **Tests of edit history**: asserting that removed or replaced behavior is gone, or tests that guard against changes that never shipped.
- **Redundant tests**: the same behavior covered in multiple modules or layers; near-duplicates that should be merged or parametrized; tests that only exercise dead code.
- **Wrong level**: unit tests of internals where a test through the public entry point would cover it; mocks or fake harnesses complex enough to need their own trust.
- **Tests that can't fail**: data or controls that don't distinguish the correct result from a plausible wrong one.
- **Tests that lock in questionable design**: report the design problem instead of encoding it.
- **Brittle assertions**: assertions that break on changes that don't affect behavior, like formatting, ordering, or incidental implementation details. Asserting exact output is fine when that output is the product.
- **Isolation**: dependence on real external resources; leaked global state patched test by test instead of fixed generally.
- **Organization**: tests in the wrong or a needlessly new module; tests grouped or named by why they were written (a regression, an issue number) instead of the behavior they cover; misleading names; explanations far from the test they explain.

## Output format

- Report the findings as text, most valuable cleanup first.
- For each finding:
    - Identify the tests involved and which item from "What to look for" applies.
    - Explain the problem clearly and concisely, so that the user can decide without reading the tests first.
    - Recommend an action: remove, merge, rewrite, or move/rename. Show the proposed change concretely, with a diff when helpful.
    - Say how you verified it. For a removal or merge, show that nothing worth keeping is lost: where else the behavior is covered, or why it isn't worth covering. For a test that can't fail, name a plausible wrong implementation that would pass it.
- List any out-of-focus findings at the end, as described under Focus.
- If nothing in focus needs cleanup, say so.
