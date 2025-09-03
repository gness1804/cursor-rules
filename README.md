# Cursor Rules for Multi-Project Workspace

This directory contains Cursor rules that provide coding standards and project-specific guidance across multiple projects.

## Rules Overview

- **project-structure.mdc** - Multi-project workspace navigation
- **general-coding-standards.mdc** - Universal coding best practices
- **charlotte-python-standards.mdc** - Python standards for CHARLOTTE security framework
- **rails-standards.mdc** - Ruby on Rails standards for Taco Price Index
- **scripts-automation.mdc** - Shell scripts and automation standards
- **charlotte-plugin-development.mdc** - Plugin development guidelines for CHARLOTTE

## Quick Setup for New Workspaces

**Important**: "Workspace root" refers to the top-level directory that VS Code opens as your workspace. This is typically the parent directory containing all your projects.

### 🚀 Easy Installation (Recommended)
```bash
# Clone the rules repository
git clone https://github.com/gness1804/cursor-rules.git cursor-rules

# Install the rules in your workspace
cd cursor-rules
./install-rules.sh
```

The installation script will:
- ✅ Automatically detect your workspace root
- ✅ Create the `.cursor/rules/` directory
- ✅ Copy all rule files
- ✅ Handle existing rules (with confirmation)

### Alternative Setup Methods

#### Option 1: Manual Clone
```bash
# Navigate to your VS Code workspace root (e.g., /Users/username/)
cd /path/to/your/workspace/root
git clone https://github.com/gness1804/cursor-rules.git .cursor/rules
```

#### Option 2: Copy Rules Directory
```bash
# Navigate to your VS Code workspace root
cd /path/to/your/workspace/root
# Copy from existing workspace
cp -r /path/to/existing/workspace/.cursor/rules .cursor/
```

#### Option 3: Symlink (for local development)
```bash
# Navigate to your VS Code workspace root
cd /path/to/your/workspace/root
# Create symlink to shared rules location
ln -s /path/to/shared/rules .cursor/rules
```

## Customization

- Modify `globs` patterns in rule files to match your project structure
- Update file path references in `mdc:` links to match your workspace
- Add new rules for additional projects or technologies

## Updating Rules

When you make changes to the rules:

```bash
# In the cursor-rules repository
git add .
git commit -m "Update Cursor rules"
git push

# In any workspace using these rules
cd cursor-rules
git pull
./install-rules.sh
```

## Maintenance

- Keep rules updated as projects evolve
- Test rules in new workspaces before committing
- Document any workspace-specific customizations
- Use semantic versioning for major rule changes
