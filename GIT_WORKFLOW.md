# Git Workflow Guide for Family Home iOS App

## 🚀 Getting Started

### Initial Setup (Already Done ✅)
- ✅ Git repository initialized
- ✅ .gitignore configured for iOS development
- ✅ Initial commit made
- ⏳ GitHub repository creation (manual step)

## 📝 Daily Development Workflow

### 1. Starting Your Day
```bash
# Pull latest changes from GitHub
git pull origin main

# Check current status
git status
```

### 2. Making Changes
```bash
# Create a new branch for your feature
git checkout -b feature/your-feature-name

# Make your changes in Xcode
# Test your changes

# Add your changes
git add .

# Commit with a descriptive message
git commit -m "Add beautiful gradient backgrounds to house view

- Implement warm color palette for living room
- Add smooth animations for furniture interactions
- Update avatar customization with new skin tones"
```

### 3. Pushing Changes
```bash
# Push your feature branch
git push origin feature/your-feature-name

# Go to GitHub and create a Pull Request
# Merge after review
```

### 4. Updating Main Branch
```bash
# Switch back to main
git checkout main

# Pull latest changes
git pull origin main

# Delete the feature branch (optional)
git branch -d feature/your-feature-name
```

## 🏷️ Branch Naming Conventions

- `feature/` - New features (e.g., `feature/avatar-customization`)
- `bugfix/` - Bug fixes (e.g., `bugfix/login-crash`)
- `hotfix/` - Urgent fixes (e.g., `hotfix/critical-crash`)
- `ui/` - UI improvements (e.g., `ui/button-styling`)
- `refactor/` - Code refactoring (e.g., `refactor/app-state-manager`)

## 📝 Commit Message Guidelines

### Format
```
Type: Brief description

- Detailed bullet point 1
- Detailed bullet point 2
- Detailed bullet point 3
```

### Types
- `Add:` - New features
- `Fix:` - Bug fixes
- `Update:` - Improvements to existing features
- `Refactor:` - Code restructuring
- `Style:` - UI/UX changes
- `Docs:` - Documentation updates
- `Test:` - Adding or updating tests

### Examples
```
Add: Beautiful gradient backgrounds to onboarding flow

- Implement soft blue to white gradient backgrounds
- Add smooth transitions between onboarding steps
- Update progress indicator with modern styling
- Enhance avatar preview with realistic skin tones

Fix: Crash when switching between family members

- Add null safety checks for family member data
- Handle edge case when family is empty
- Update error handling in AppStateManager

Style: Modernize house view with realistic furniture

- Replace basic rectangles with detailed furniture icons
- Add shadow effects for depth and realism
- Implement warm color palette for cozy feel
- Update room gradients with proper lighting
```

## 🔄 Common Git Commands

### Viewing History
```bash
# See commit history
git log --oneline

# See changes in last commit
git show

# See file changes
git diff
```

### Managing Branches
```bash
# List all branches
git branch -a

# Switch to a branch
git checkout branch-name

# Create and switch to new branch
git checkout -b new-branch-name

# Delete a branch
git branch -d branch-name
```

### Stashing Changes
```bash
# Save changes temporarily
git stash

# List stashes
git stash list

# Apply last stash
git stash pop

# Apply specific stash
git stash apply stash@{0}
```

### Undoing Changes
```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Undo changes in working directory
git checkout -- filename

# Revert a specific commit
git revert commit-hash
```

## 🚨 Important Notes

### Never Commit
- Build artifacts (`.build/`, `DerivedData/`)
- User-specific files (`xcuserdata/`)
- API keys or sensitive data
- Large binary files
- Temporary files

### Always Commit
- Source code changes
- UI improvements
- Bug fixes
- Documentation updates
- Configuration files (that don't contain secrets)

### Before Pushing
- ✅ Test your changes
- ✅ Write descriptive commit messages
- ✅ Make sure code compiles
- ✅ Check for any sensitive data

## 🎯 GitHub Integration Tips

### Pull Requests
- Write clear descriptions
- Include screenshots for UI changes
- Reference related issues
- Request reviews from team members

### Issues
- Use labels to categorize issues
- Assign issues to team members
- Use milestones for project planning
- Link issues to pull requests

### Releases
- Tag important versions
- Write release notes
- Include changelog
- Attach builds for testing

## 🔧 Troubleshooting

### Merge Conflicts
```bash
# See conflicted files
git status

# Resolve conflicts in Xcode
# Add resolved files
git add .

# Complete merge
git commit
```

### Lost Changes
```bash
# Find lost commits
git reflog

# Recover lost commit
git checkout -b recovery-branch commit-hash
```

### Large Files
```bash
# Remove large file from history
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch large-file.zip' \
  --prune-empty --tag-name-filter cat -- --all
```

## 📚 Additional Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Guides](https://guides.github.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) 