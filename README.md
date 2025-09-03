# Cursor Rules for Multi-Project Workspace

This directory contains Cursor rules that provide coding standards and project-specific guidance across multiple projects.

## Rules Overview

- **project-structure.mdc** - Multi-project workspace navigation
- **general-coding-standards.mdc** - Universal coding best practices
- **charlotte-python-standards.mdc** - Python standards for CHARLOTTE security framework
- **rails-standards.mdc** - Ruby on Rails standards for Taco Price Index
- **scripts-automation.mdc** - Shell scripts and automation standards
- **charlotte-plugin-development.mdc** - Plugin development guidelines for CHARLOTTE

## Setup for New Workspaces

### Option 1: Clone Rules Repository
```bash
# In your new workspace root
git clone https://github.com/yourusername/cursor-rules.git .cursor/rules
```

### Option 2: Copy Rules Directory
```bash
# Copy from existing workspace
cp -r /path/to/existing/workspace/.cursor/rules .cursor/
```

### Option 3: Symlink (for local development)
```bash
# Create symlink to shared rules location
ln -s /path/to/shared/rules .cursor/rules
```

## Customization

- Modify `globs` patterns in rule files to match your project structure
- Update file path references in `mdc:` links to match your workspace
- Add new rules for additional projects or technologies

## Maintenance

- Keep rules updated as projects evolve
- Test rules in new workspaces before committing
- Document any workspace-specific customizations
