#!/usr/bin/env bash
# Ensure we fail fast if there is a problem.
set -eo pipefail

npm -v
npm install @angular/service-worker --save-dev
ng set apps.0.serviceWorker=true

assets_array=$(node<<EOF
const cliOutput = $(ng get apps.0.assets);
const newAssets = JSON.stringify(cliOutput.concat("manifest.json", "favicon.ico"));
console.log(newAssets);
EOF
)
ng set apps.0.assets="$assets_array"

manifest_link="<link rel=\"manifest\" href=\"manifest.json\">"
sed -i "s#</head>#$manifest_link\n</head>#" src/index.html