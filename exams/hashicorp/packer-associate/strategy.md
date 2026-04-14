# Packer Associate - Exam Strategy

This is a 60-minute multiple choice exam with 57 questions. That works out to just over a minute per question. The test rewards broad familiarity more than depth on any single feature. You cannot look things up. Speed and confidence matter.

## The Week Before

- Confirm the PSI system check passes on your machine at least 2 days before.
- Ensure the testing space is quiet, well-lit, and free of clutter (PSI will ask to see your workspace via webcam).
- Sleep normally. Cramming the night before is counterproductive.
- Do one full mock exam and review weak areas.

## The Day Of

- Eat a real meal 60 to 90 minutes before. Avoid heavy caffeine right before.
- Run through your notes files for a final skim of CLI commands and plugin names.
- Close all applications except the browser. Disable notifications.
- Take a bathroom break immediately before check-in. You cannot pause the exam.

## Time Budget

- 57 questions in 60 minutes = 63 seconds per question average.
- Budget: first pass 45 minutes at ~47 seconds per question; second pass 15 minutes for flagged items.
- If a question consumes 90 seconds and you are not close, flag and move on.

## Question-Taking Process

For every question, in order:

1. **Read the question twice** before looking at the answers.
2. **Identify the domain** (builder, provisioner, post-processor, HCL, HCP, CLI). This frames the answer space.
3. **Eliminate clearly wrong answers first.** Usually 1 or 2 distractors are obvious.
4. **Match the remaining answers against your memory.** Pick the most specific correct option.
5. **Flag if uncertain and move on.** Do not grind.

## Common Trap Patterns

### Wrong Block Names
HCL2 uses `source` and `build`. Legacy JSON uses `builders` and `provisioners`. If a question shows `"builders": [...]`, it is either a legacy template or a trap. Check for `.json` vs `.pkr.hcl`.

### Plugin Source Syntax
Modern plugin blocks use `source = "github.com/hashicorp/amazon"`. Legacy short names (`type = "amazon-ebs"`) still work inside `source` blocks but not in `required_plugins`. Watch for the context.

### Variable Precedence
From highest to lowest:
1. `-var 'foo=bar'` on CLI
2. `-var-file=X.pkrvars.hcl` on CLI
3. `*.auto.pkrvars.hcl` in working directory
4. `PKR_VAR_foo` env var
5. Default in variable block

If two sources set the same variable, the higher one wins.

### only vs except
- `-only=amazon-ebs.ubuntu` runs only that source
- `-except=amazon-ebs.dev` runs everything else
Both target the source address `builder-type.source-name`.

### Builder Selection
- `amazon-ebs`: most common, builds AMI from a running EC2 instance
- `amazon-chroot`: builds AMI in-place using an existing instance (faster, advanced)
- `amazon-ebssurrogate`: builds from a detached root volume
- `amazon-instance`: for instance-store AMIs (rare)

Questions asking "build an AMI without launching a new instance" point to `amazon-chroot`.

### shell vs shell-local
- `shell`: runs on the builder instance
- `shell-local`: runs on the machine running Packer itself

A question asking "download a file to the Packer host before uploading it" points to `shell-local` followed by `file`.

### file Provisioner Direction
By default `file` uploads from local to remote. Set `direction = "download"` to pull from remote. Easy to confuse under time pressure.

### null Builder
Produces no image. Used for provisioner-only flows (e.g., run Ansible against an existing host). If the question describes "run provisioners without producing an artifact", answer is `null`.

### breakpoint Provisioner
Pauses the build for SSH debugging. Only active when `PACKER_LOG` debugging is enabled. Remove before production pipelines.

### HCP Packer Channels
A channel is a named pointer to an iteration (like a git branch pointing to a commit). Promoting = reassigning the pointer. Consumers reference channels, not iteration IDs directly.

## Question Types to Expect

- **"What does command X do?"** Know each subcommand's effect.
- **"Which builder for scenario Y?"** Map scenarios to builders.
- **"Order these lifecycle steps."** Parse > validate > build > provision > post-process.
- **"Which post-processor produces Z?"** Map artifacts to post-processors.
- **"What HCL block fixes this error?"** Know `required_plugins`, `source`, `build`, `variable`, `locals`.
- **"Which environment variable authenticates HCP Packer?"** `HCP_CLIENT_ID`, `HCP_CLIENT_SECRET`.

## Syntax Traps

**required_plugins goes inside a packer block**
```hcl
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
  }
}
```

**sources are referenced by type.name in builds**
```hcl
build {
  sources = ["source.amazon-ebs.ubuntu"]
}
```

**Variables reference as var.X, locals as local.Y**
Don't confuse with Terraform conventions (same here actually, but watch for subtle differences).

**Functions that look similar**
- `timestamp()` returns RFC 3339
- `formatdate(format, timestamp)` formats it
- `file(path)` reads a file
- `fileset(path, pattern)` lists files matching glob

## Elimination Strategy

If you have no idea, eliminate:

- Options with syntax that is clearly Terraform-only (e.g., `resource "aws_..."` does not belong in Packer)
- Options that reference deprecated JSON syntax when the question uses HCL
- Options that name a builder for the wrong cloud
- Options with obvious typos (HashiCorp rarely puts typos in correct answers)

Then guess from the remaining 2. Never leave blank.

## Mental State

- This is an associate-level exam. Trust your preparation.
- If you hit a hard question, flag and move on. Don't let it eat your time.
- Come back at the end with fresh eyes.

## Tactical Tips

- **First pass fast:** answer every question you are confident on; flag uncertain ones.
- **Second pass:** revisit flagged questions. Often later questions give hints to earlier ones.
- **Third pass (if time):** re-read flagged questions once more.
- **Never change a confident answer based on second-guessing.** Change only if you see a specific error.

## After Submitting

- Results appear immediately or within minutes.
- If you pass, you receive a Credly badge email.
- If you do not pass, you get a domain breakdown showing your weakest area.

## Post-Certification

- Certification valid 2 years.
- Add to LinkedIn and your resume immediately.
- Consider pairing with Terraform Associate for the full IaC credential set.
