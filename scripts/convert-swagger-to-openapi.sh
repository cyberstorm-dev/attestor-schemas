#!/bin/bash
set -e

# Convert Swagger 2.0 to OpenAPI 3.0 using npx swagger2openapi
echo "Converting Swagger 2.0 to OpenAPI 3.0..."

# Convert all swagger files using npx (uses locally installed version)
for swagger_file in dist/openapi/cyberstorm/attestor/v1/*.swagger.json; do
    if [ -f "$swagger_file" ]; then
        openapi_file="${swagger_file%.swagger.json}.openapi.json"
        echo "Converting $(basename "$swagger_file") -> $(basename "$openapi_file")..."
        npx swagger2openapi "$swagger_file" --outfile "$openapi_file" >logs/swagger-convert.log 2>&1 || {
            echo "⚠️  Conversion failed, check logs/swagger-convert.log"
            exit 1
        }
    fi
done

echo "✅ Swagger 2.0 to OpenAPI 3.0 conversion complete"