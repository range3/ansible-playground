# CLAUDE.md

必ず日本語で回答せよ。
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Ansible playground repository for learning and testing Ansible configurations. It contains:

- **Ansible playbooks** in the root directory (site.yml)
- **Inventory management** in `inventory/` with hosts, groups, and variables
- **Custom collections** in `collections/` including ansible.posix and a custom range3.common collection
- **Python/Node.js tooling** for development dependencies

## Development Commands

### Ansible Operations
```bash
# Run the main playbook
ansible-playbook site.yml

# Run playbook with specific inventory
ansible-playbook -i inventory/hosts.yml site.yml

# Check inventory hosts
ansible-inventory --list

# Test connectivity to all hosts
ansible all -m ping

# Run against specific groups
ansible web_servers -m setup
ansible db_servers -m ping

# Dry run (check mode)
ansible-playbook site.yml --check
```

### Collection Management
```bash
# Install collection dependencies
ansible-galaxy collection install -r collections/requirements.yml

# Install collections to local collections path
ansible-galaxy collection install -p collections/
```

### Python Environment
```bash
# Install development dependencies (requires uv)
uv sync --group dev

# Using pip instead
pip install ansible-dev-tools
```

## Architecture

### Inventory Structure
- `inventory/hosts.yml`: Main inventory file defining hosts and groups
- `inventory/group_vars/`: Variables applied to specific groups (web_servers, db_servers, etc.)
- `inventory/host_vars/`: Variables specific to individual hosts

### Collections Layout
- `collections/ansible_collections/ansible/posix/`: Standard Ansible POSIX collection
- `collections/ansible_collections/range3/common/`: Custom collection with roles and plugins
- Collections are configured in `ansible.cfg` with `collections_path= collections`

### Configuration
- `ansible.cfg`: Main Ansible configuration with inventory paths, verbosity, and connection settings
- Default inventory points to `inventory/hosts.yml`
- Uses sudo as become method with 30-second timeouts

### Host Groups
- **web_servers**: server1, server2
- **db_servers**: server3  
- **switches**: switch1, switch2
- **production**: server1, server2
- **test**: server3

When modifying inventory or playbooks, ensure host group consistency and verify connectivity before running playbooks against production hosts.

## Git Commit Guidelines

### Commit Message Format
- Use simple, one-line commit messages in English
- Do not include Claude Code co-author attribution
- Example: `Add Claude Code installation to devcontainer`

### Commit Process
```bash
# Stage changes
git add <files>

# Create simple commit
git commit -m "Brief description of changes"
```
