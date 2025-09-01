#!/bin/bash
set -e

echo "🔍 Checking Python package generation..."

# Check that expected files were generated
if [ ! -f "dist/python/cyberstorm/attestor/v1/services_pb2.py" ]; then
    echo "❌ services_pb2.py not generated"
    exit 1
fi

if [ ! -f "dist/python/cyberstorm/attestor/v1/messages_pb2.py" ]; then
    echo "❌ messages_pb2.py not generated"
    exit 1
fi

echo "✅ Generated Python files exist:"
ls -la dist/python/cyberstorm/attestor/v1/

# Test imports using the virtual environment
echo "📝 Testing Python imports..."
# Use cross-platform python detection
if [ -f "./venv/bin/python" ]; then
    PYTHON_CMD="./venv/bin/python"
elif [ -f "./venv/Scripts/python" ]; then
    PYTHON_CMD="./venv/Scripts/python"
else
    echo "Error: Could not find python in virtual environment"
    exit 1
fi

$PYTHON_CMD -c "
from cyberstorm.attestor.v1 import services_pb2, messages_pb2
print('✅ Python imports successful')
print(f'Services: {len(dir(services_pb2))} attributes')
print(f'Messages: {len(dir(messages_pb2))} attributes')
"

echo "✅ Python package validation complete"