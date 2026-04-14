# Terraform Authoring and Operations Professional - Exam Strategy

This exam is performance-based. You will not be answering multiple-choice questions. You will be executing real Terraform tasks in a live environment with a live CLI, a live HCP Terraform org, and in some cases a live cloud sandbox. Your strategy must be different from the Associate exam.

## The Week Before

- Confirm your testing environment: stable wired internet if possible, quiet room, webcam working.
- Run the PSI system compatibility check at least 48 hours before.
- Lock down your schedule: 4 hours plus 30 minutes buffer for check-in. Do not schedule anything within 5 hours.
- Sleep normally. Cramming HCL syntax the night before is less valuable than rest.

## The Day Of

- Eat a real meal 90 minutes before. No caffeine spike right before.
- Close everything except your browser. PSI will ask you to shut down non-essentials anyway.
- Have your ID ready and your room cleared of notes, second monitors, and phones.
- Take a bathroom break immediately before check-in. There are limited or no breaks during the exam.

## Time Management Within the Exam

You have approximately 4 hours for roughly 15 to 25 tasks. That is 10 to 15 minutes per task on average. Some tasks will be shorter (a state surgery fix), others longer (build a module from scratch). Budget accordingly.

**Rule of thumb:** If a task has consumed 20 minutes and you are not close, flag it, move on, and come back.

Break the exam into rough phases:

- Minutes 0 to 15: read every task, make a mental or scratch note of which are easy wins, which are medium, which are hard.
- Minutes 15 to 180: execute tasks in order of confidence (easy first, then medium).
- Minutes 180 to 210: tackle hard or flagged tasks.
- Minutes 210 to 240: verify end-state of completed tasks by re-running plan or inspecting state.

## Task Approach Playbook

For every task, in this order:

1. **Read twice.** Understand the exact end-state being asked. Scoring is based on end-state, not approach.
2. **Check the starting state.** Run `terraform state list`, inspect the workspace, review the module inputs. Do not assume.
3. **Plan your minimal change.** The fewer files you touch, the fewer ways to break it.
4. **Run plan before apply.** Always. The exam will not penalize you for running plan twice, but it will penalize a broken apply.
5. **Verify the end-state matches the prompt exactly.** If it says "the workspace must be named `prod-vpc`", do not name it `prod_vpc`.

## Common Task Types and Fast-Paths

### "Refactor module using for_each preserving state"
Fast-path: Use `moved` blocks. Do not `state mv` manually unless explicitly required. `moved` blocks are cleaner, reviewable, and survive in source control.

### "Import existing resource"
Fast-path: Prefer `import` blocks over `terraform import` CLI when possible. They are declarative, reviewable, and can generate configuration with `terraform plan -generate-config-out=generated.tf`.

### "Resolve state lock"
Fast-path: Check if the lock is genuinely stale (run ID, age, who holds it). Only then `terraform force-unlock LOCK_ID`. Never force-unlock a running operation.

### "Write Sentinel policy"
Fast-path: Start from `tfplan/v2`, filter `resource_changes`, check the `change.after` map. Use the `sentinel test` workflow with mock data. Keep policies small and testable.

### "Configure dynamic AWS credentials"
Fast-path: Set workspace variables `TFC_AWS_PROVIDER_AUTH=true` and `TFC_AWS_RUN_ROLE_ARN`. Do not also set `AWS_ACCESS_KEY_ID`. If both are set, the static key wins and you lose points.

### "Configure VCS-driven workspace"
Fast-path: Workspace > Settings > Version Control. Pick repo, set working directory if module lives in a subdir, enable speculative plans. Check connection status before saving.

### "Split monolithic state"
Fast-path: Create new workspace(s), pull current state, use `terraform state mv -state-out=new.tfstate ...` for each address, push to new workspace. Validate with `terraform plan` showing zero changes.

## Frequent Pitfalls to Avoid

1. **Forgetting to save a plan file.** If a task asks for `terraform apply tfplan`, you need the saved plan. `-out=tfplan` is not optional.
2. **Destroying resources during import.** If `import` block is missing, a plan will want to create the resource. Always verify with plan before apply.
3. **Wrong working directory.** VCS-driven workspaces have a working directory setting. Leaving it blank vs setting `modules/vpc` changes which files Terraform sees.
4. **Static credentials alongside dynamic.** Static wins. Unset them.
5. **Uppercase vs lowercase workspace names.** Case matters. Match the prompt exactly.
6. **Missing `required_providers` or `required_version`.** Professional-level modules must pin these. Lose points for omitting.
7. **Using `-target` as a crutch.** The graders notice. Use it only when explicitly asked.
8. **Ignoring `terraform fmt`.** Unformatted HCL is an easy deduction. Run fmt before finishing each task.

## Reading Error Messages

Terraform errors are verbose but informative. Train yourself to scan for:

- The resource address (which resource triggered it)
- The provider (AWS, Azure, etc.) vs core error
- Hints in the error body (e.g., "consider using `-refresh-only`")

Provider errors often include the underlying API response. If you see `AccessDenied`, it is not a Terraform bug. Check IAM.

## Keyboard and Tooling Efficiency

You will be switching between a CLI, the HCP Terraform UI, and an editor. Tips:

- Keep one terminal pinned at the module root. Use a second for `terraform console`.
- Use shell history (`Ctrl-R`) for repeated commands.
- Have `terraform -help plan` and `-help state` mentally indexed.
- If the lab provides a browser-based editor, resist using your local editor. Stay in-env.

## When to Give Up on a Task

If you have spent 20 minutes and are no closer, flag it and move on. A partially complete task is worth zero. Three fully complete tasks plus one abandoned is better than two half-done plus one stuck.

Come back only if time allows after the rest are done.

## Mental State

- This exam rewards calm, methodical work. Panicking speeds up typing but slows down thinking.
- If you hit a wall, take 30 seconds to look away from the screen, breathe, and come back.
- Trust your preparation. You have done these tasks before in labs. Treat the exam as another lab.

## After Submitting

- Results are typically emailed within 24 to 48 hours.
- If you pass, your certification is valid for 2 years. Add it to HashiCorp's Credly integration for shareable badges.
- If you do not pass, you get a domain-level breakdown. Use it to focus the retake.

## Post-Certification

- Recertification means taking the current version of the exam. HashiCorp updates the blueprint roughly annually.
- Stay current by reading the Terraform changelog and trying new language features as they ship.
- Contribute a public module or Sentinel policy to reinforce learning beyond the exam.
