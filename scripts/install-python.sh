#!/bin/bash
set -e

mkdir -p logs

# Use a lock file to serialize venv creation
VENV_LOCK_FILE="/tmp/python-venv-install.lock"
exec 201>"$VENV_LOCK_FILE"

if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    
    # Get exclusive lock for venv creation
    if flock -n 201 2>/dev/null; then
        # Check again if venv was created by another process
        if [ ! -d "venv" ]; then
            python3 -m venv venv >logs/python-venv.log 2>&1
            # Upgrade pip immediately after venv creation
            if [ -f "./venv/bin/python" ]; then
                ./venv/bin/python -m pip install --upgrade pip --quiet >>logs/python-venv.log 2>&1
            elif [ -f "./venv/Scripts/python" ]; then
                ./venv/Scripts/python -m pip install --upgrade pip --quiet >>logs/python-venv.log 2>&1
            fi
        fi
        flock -u 201
    else
        # Another process is creating venv, wait for it
        echo "Another venv creation in progress, waiting..."
        flock 201
        flock -u 201
    fi
fi

exec 201>&-  # Close the file descriptor

# Only install package if Python source files exist
if [ -d "dist/python/cyberstorm" ]; then
    echo "Installing Python package dependencies..."
    # Use cross-platform pip detection
    if [ -f "./venv/bin/pip" ]; then
        ./venv/bin/pip install -e ".[dev]" --quiet >logs/python-install.log 2>&1
    elif [ -f "./venv/Scripts/pip" ]; then
        ./venv/Scripts/pip install -e ".[dev]" --quiet >logs/python-install.log 2>&1
    else
        echo "Error: Could not find pip in virtual environment"
        ls -la ./venv/ >>logs/python-install.log 2>&1
        exit 1
    fi
    echo "Python package installed in development mode"
else
    echo "Python source files not generated yet - skipping package installation"
    echo "Virtual environment created and ready for package generation"
fi