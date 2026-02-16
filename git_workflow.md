# Git Workflow — Hybrid Nights

## Checkpoint Steps

When you say **"Please commit everything"**, the following happens:

### 1. Status Check
```bash
git status
```
Review untracked files, staged changes, and modified files.

### 2. Secret Scan (CRITICAL — runs before every commit)
Automatic scan of the workspace for:
- `.env` files
- Private key files (`*.key`, `*.pem`, `*.p12`, `*.pfx`)
- Private key blocks (`BEGIN RSA PRIVATE KEY`, etc.)
- API keys / tokens (OpenAI, GitHub, AWS, etc.)
- OAuth secrets
- Database passwords
- Hardcoded credentials in source files

**If anything suspicious is found:**
- Commit is **STOPPED**
- Files are listed with warnings
- `.gitignore` updates are recommended
- User must explicitly confirm before proceeding

### 3. Stage Files
Only intended project files are staged. Never stage:
- `.env` or credential files
- Generated caches (`.godot/`, `.import/`)
- OS junk (`Thumbs.db`, `.DS_Store`)
- Build artifacts

### 4. Commit
```bash
git commit -m "chore(checkpoint): update progress + dashboards"
```

### 5. Push (conditional)
Push only happens if:
- Remote `origin` exists
- Authentication succeeds
- The push completes without error

If push fails, exact next steps are printed. Success is never assumed.

## Commit Message Format

```
<type>(<scope>): <short description>

[optional body]

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
```

### Types
| Type | Use |
|------|-----|
| `feat` | New gameplay feature or system |
| `fix` | Bug fix |
| `refactor` | Code restructuring, no behavior change |
| `chore` | Maintenance, checkpoints, dashboards, docs |
| `test` | Adding or updating tests |
| `style` | Formatting, naming conventions |

### Scopes (optional)
`combat`, `characters`, `enemies`, `ui`, `camera`, `save`, `companions`, `input`, `tests`, `docs`

## Safety Warnings

- **Never force-push** (`git push --force`) without explicit user request
- **Never rewrite history** on shared branches
- **Never commit secrets** — the secret scan catches most patterns, but always review `git diff --staged`
- **Never use `git reset --hard`** without user confirmation
- **Always create new commits** rather than amending (unless explicitly asked)
- **Review `.gitignore`** if adding new file types to the project

## .gitignore Coverage

The `.gitignore` file protects against committing:
- Godot caches: `.godot/`, `.import/`
- Secrets: `.env*`, `*.key`, `*.pem`, `*.p12`, `*.pfx`
- Build output: `build/`, `dist/`, `export/`
- Dependencies: `node_modules/`, `addons/*/bin/`
- OS files: `.DS_Store`, `Thumbs.db`, `*.swp`
- Large binaries: `*.blend1` (Blender backups)

## Quick Reference

| Action | Command |
|--------|---------|
| Check status | `git status` |
| See changes | `git diff` |
| See staged | `git diff --staged` |
| Commit checkpoint | `git commit -m "chore(checkpoint): <msg>"` |
| Push | `git push origin main` |
| View log | `git log --oneline -10` |
