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

## Available Tasks

- `task validate`: Run full validation pipeline (lint, generate, package)
- `task generate:all`: Generate client libraries for all languages
- `task lint`: Lint proto files
- `task format`: Format proto files
- `task check:all`: Run comprehensive checks for all generated libraries

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