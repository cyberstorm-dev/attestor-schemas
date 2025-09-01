#!/bin/bash
set -e

echo "🔍 Checking TypeScript generation..."

# Check that expected files were generated
if [ ! -f "dist/typescript/cyberstorm/attestor/v1/services_pb.js" ]; then
    echo "❌ services_pb.js not generated"
    exit 1
fi

if [ ! -f "dist/typescript/cyberstorm/attestor/v1/messages_pb.js" ]; then
    echo "❌ messages_pb.js not generated"  
    exit 1
fi

echo "✅ Generated files exist:"
ls -la dist/typescript/cyberstorm/attestor/v1/

# Check that files are valid JavaScript (syntax check)
echo "📝 Checking JavaScript syntax..."
node -c dist/typescript/cyberstorm/attestor/v1/messages_pb.js || exit 1
echo "✅ messages_pb.js has valid syntax"

node -c dist/typescript/cyberstorm/attestor/v1/services_pb.js || exit 1
echo "✅ services_pb.js has valid syntax"

# Check file sizes (should not be empty)
if [ ! -s "dist/typescript/cyberstorm/attestor/v1/services_pb.js" ]; then
    echo "❌ services_pb.js is empty"
    exit 1
fi

if [ ! -s "dist/typescript/cyberstorm/attestor/v1/messages_pb.js" ]; then
    echo "❌ messages_pb.js is empty"
    exit 1  
fi

echo "✅ TypeScript/JavaScript generation validation complete"