#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status, on unset variables, or pipe failures
set -euo pipefail

# 0. Check if git is installed
if ! command -v git >/dev/null 2>&1; then
  echo "❌ Error: git is not installed. Please install git and try again." >&2
  exit 1
fi

# Path variables
REPO_URL="https://github.com/affaan-m/ECC.git"
TMP_DIR="/tmp/ECC"
PLUGIN_DIR="$HOME/.gemini/config/plugins/ecc"

echo "🚀 Starting ECC plugin installation..."

# 1. Clone the ECC repository into a temporary folder (cleaning it up first if it exists)
rm -rf "$TMP_DIR"
echo "📦 Cloning repository..."
git clone --depth 1 "$REPO_URL" "$TMP_DIR"

# 2. Create the global plugin directory
echo "📁 Creating directory structure in $PLUGIN_DIR..."
mkdir -p "$PLUGIN_DIR"

# 3. Copy skills and agents
echo "📋 Copying skills and agents..."
cp -R "$TMP_DIR/skills" "$PLUGIN_DIR/"
cp -R "$TMP_DIR/agents" "$PLUGIN_DIR/"

# 4. Copy common rules to rules/AGENTS.md
echo "📜 Compiling common rules into AGENTS.md..."
mkdir -p "$PLUGIN_DIR/rules"
cat "$TMP_DIR"/rules/common/*.md > "$PLUGIN_DIR/rules/AGENTS.md" 2>/dev/null || true

# 5. Create the plugin.json manifest
echo "⚙️ Creating plugin.json manifest..."
cat > "$PLUGIN_DIR/plugin.json" << 'EOF'
{
  "name": "ecc",
  "displayName": "Everything Claude Code (ECC)",
  "description": "ECC engineering system: skills, specialized agents, and workflows"
}
EOF

# 6. Remove temporary files
echo "🧹 Cleaning up temporary files..."
rm -rf "$TMP_DIR"

echo "✅ ECC plugin installation completed successfully!"
