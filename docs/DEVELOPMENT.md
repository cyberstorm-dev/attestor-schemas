# Development Setup

This guide covers setting up your development environment for working with the Cyberstorm Attestor Schemas.

## Prerequisites

- [buf CLI](https://buf.build/docs/installation)
- [Task](https://taskfile.dev/#/installation)
- Go 1.20+
- Python 3.9+
- Node.js 16+

## Quick Start

1. Clone the repository
```bash
git clone https://github.com/cyberstorm-dev/attestor-schemas.git
cd attestor-schemas
```

2. Install dependencies and generate clients
```bash
task deps
task build
```

## Platform-Specific Setup

### macOS
```bash
# Install buf via Homebrew
brew install bufbuild/buf/buf

# Install Task via Homebrew
brew install go-task/tap/go-task

# For Python development (recommended to use virtual environment)
python3 -m venv venv
source venv/bin/activate
pip install -r requirements-dev.txt
```

### Linux (Ubuntu/Debian)
```bash
# Install buf
curl -sSL "https://github.com/bufbuild/buf/releases/latest/download/buf-$(uname -s)-$(uname -m)" -o "/usr/local/bin/buf"
chmod +x "/usr/local/bin/buf"

# Install Task
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

# For Python development
sudo apt update && sudo apt install python3-venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements-dev.txt
```

### Windows
```powershell
# Install buf via Scoop or download binary
scoop install buf

# Install Task via Scoop
scoop install task

# For Python development (use Command Prompt or PowerShell)
python -m venv venv
venv\Scripts\activate
pip install -r requirements-dev.txt
```

## IDE/Editor Integration

### VS Code (Recommended)
Install these extensions for the best development experience:
```json
{
  "recommendations": [
    "bufbuild.vscode-buf",
    "ms-vscode.vscode-proto3",
    "golang.go",
    "ms-python.python",
    "bradlc.vscode-tailwindcss"
  ]
}
```

Create `.vscode/settings.json`:
```json
{
  "protoc": {
    "compile_on_save": false,
    "options": [
      "--proto_path=${workspaceRoot}/schemas/proto"
    ]
  },
  "files.associations": {
    "*.proto": "proto3"
  }
}
```

### Other IDEs
- **IntelliJ/GoLand**: Install the Protocol Buffers plugin
- **Vim/Neovim**: Use `vim-protobuf` plugin
- **Emacs**: Use `protobuf-mode`

## Development Environment Recommendations

- **Protocol Buffer Linting**: Configure your editor to use `buf lint`
- **Auto-formatting**: Set up `buf format` on save
- **Git Integration**: Enable pre-commit hooks (see [Contributing](CONTRIBUTING.md))
- **Testing**: Run `task check:all` before committing

## Task Dependency Graph

The build system is organized around a dependency graph that ensures proper ordering of operations:

```mermaid
graph TD
    %% Core Infrastructure
    install[install - Install buf CLI]
    deps[deps - Update dependencies]
    clean[clean - Clean generated files]
    
    %% Development Tasks
    format[format - Format proto files]
    lint[lint - Lint proto files]
    breaking[breaking - Check for breaking changes]
    
    %% Language-specific Installation
    install_ts[install:typescript - Install JS deps]
    install_py[install:python - Install Python deps]
    
    %% Generation Tasks
    gen_ts[generate:typescript - Generate JS clients]
    gen_py[generate:python - Generate Python clients]
    gen_go[generate:go - Generate Go clients]
    gen_openapi[generate:openapi - Generate OpenAPI specs]
    gen_all[generate:all - Generate all clients]
    
    %% Packaging Tasks
    pkg_ts[package:typescript - Package for npm]
    pkg_py[package:python - Package for PyPI]
    pkg_go[package:go - Package Go module]
    pkg_all[package:all - Package all]
    
    %% Validation Tasks
    check_ts[check:typescript - Validate JS package]
    check_py[check:python - Validate Python package]
    check_go[check:go - Validate Go package]
    check_openapi[check:openapi - Validate OpenAPI specs]
    check_all[check:all - Run all checks]
    
    %% Publishing Tasks
    pub_ts[publish:typescript - Publish to npm]
    pub_py[publish:python - Publish to PyPI]
    pub_go[publish:go - Tag Go release]
    
    %% High-level Tasks
    build[build - Full build pipeline]
    validate[validate - Full validation pipeline]
    docs[docs - Serve API docs]
    
    %% Dependencies
    install --> deps
    install --> format
    install --> breaking
    install --> gen_py
    install --> gen_go
    install --> gen_openapi
    
    deps --> lint
    deps --> validate
    
    clean --> gen_ts
    clean --> gen_py
    clean --> gen_go
    clean --> gen_openapi
    
    install_ts --> gen_ts
    
    lint --> gen_all
    lint --> validate
    
    gen_ts --> pkg_ts
    gen_py --> pkg_py
    gen_go --> pkg_go
    gen_openapi --> check_openapi
    
    install_py --> pkg_py
    install_py --> check_py
    
    pkg_ts --> check_ts
    pkg_py --> check_py
    pkg_go --> check_go
    
    gen_ts --> gen_all
    gen_py --> gen_all
    gen_go --> gen_all
    gen_openapi --> gen_all
    
    pkg_ts --> pkg_all
    pkg_py --> pkg_all
    pkg_go --> pkg_all
    
    check_ts --> check_all
    check_py --> check_all
    check_go --> check_all
    check_openapi --> check_all
    
    pkg_ts --> pub_ts
    pkg_py --> pub_py
    pkg_go --> pub_go
    
    format --> build
    lint --> build
    gen_all --> build
    
    deps --> validate
    lint --> validate
    check_all --> validate
    
    gen_openapi --> docs
    
    %% Styling
    classDef coreTask fill:#e1f5fe
    classDef genTask fill:#f3e5f5
    classDef checkTask fill:#e8f5e8
    classDef pubTask fill:#fff3e0
    classDef highLevel fill:#ffebee
    
    class install,deps,clean,format,lint,breaking coreTask
    class gen_ts,gen_py,gen_go,gen_openapi,gen_all genTask
    class check_ts,check_py,check_go,check_openapi,check_all checkTask
    class pub_ts,pub_py,pub_go pubTask
    class build,validate,docs highLevel
```

## Available Tasks

### Core Development Tasks
- `task validate` - Run full validation pipeline (lint, generate, package, check)
- `task build` - Full build pipeline (format, lint, generate all)
- `task generate:all` - Generate client libraries for all languages
- `task lint` - Lint proto files with buf
- `task format` - Auto-format proto files
- `task clean` - Clean all generated files

### Language-Specific Tasks
- `task generate:typescript` - Generate TypeScript/JavaScript clients
- `task generate:python` - Generate Python clients  
- `task generate:go` - Generate Go clients
- `task generate:openapi` - Generate OpenAPI/Swagger specifications

### Packaging & Validation
- `task package:all` - Package all language targets for distribution
- `task check:all` - Run comprehensive validation checks for all generated libraries
- `task check:typescript` - Validate TypeScript package integrity
- `task check:python` - Validate Python package functionality
- `task check:go` - Validate Go module compilation

### Publishing
- `task publish:typescript` - Publish to npm registry
- `task publish:python` - Publish to PyPI
- `task publish:go` - Instructions for Git tag-based publishing

### Utilities
- `task docs` - Serve interactive API documentation with Swagger UI
- `task breaking` - Check for breaking changes against main branch

## Publishing

The repository supports publishing to multiple package registries:

- npm (TypeScript/JavaScript)
- PyPI (Python)
- Go modules (via Git tags)

### Publishing Commands

```bash
# Publish TypeScript package
task publish:typescript

# Publish Python package
task publish:python

# Publish Go module (requires version tag)
./scripts/publish-go.sh v1.0.0
```