#!/bin/bash
# VPS Update Script - SECURE VERSION
# Generated 2026-03-17 after security cleanup
# Uses SSH key authentication (no passphrases in scripts)

set -euo pipefail

VPS_HOST="vps-main"  # Using ~/.ssh/config
SSH_KEY="/root/.ssh/id_ed25519_openclaw"
REBOOT="${1:-}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔄 VPS Update Script${NC}"
echo "================================"
echo ""

# Verify SSH key exists
if [ ! -f "$SSH_KEY" ]; then
    echo -e "${RED}❌ SSH key not found: $SSH_KEY${NC}"
    exit 1
fi

# Test connection
echo -e "${YELLOW}🔌 Testing SSH connection...${NC}"
if ! ssh -i "$SSH_KEY" "$VPS_HOST" 'uptime' > /dev/null 2>&1; then
    echo -e "${RED}❌ SSH connection failed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ SSH connection OK${NC}"
echo ""

# Run updates
echo -e "${YELLOW}📦 Running system updates...${NC}"
ssh -i "$SSH_KEY" "$VPS_HOST" << 'EOF'
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Updates completed successfully${NC}"
    echo ""

    # Reboot if requested
    if [ "$REBOOT" = "--reboot" ]; then
        echo -e "${YELLOW}🔄 Initiating reboot...${NC}"
        ssh -i "$SSH_KEY" "$VPS_HOST" 'reboot'
        echo -e "${GREEN}✅ Reboot command sent${NC}"
        echo "⏳ VPS will be back online in ~1 minute"
    else
        echo -e "${YELLOW}💡 To reboot: $0 --reboot${NC}"
    fi
else
    echo -e "${RED}❌ Update failed${NC}"
    exit 1
fi
