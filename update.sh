#!/bin/bash
set -e
echo "🔄 Mise à jour OpenClaw..."
cd /root/openclaw
docker pull ghcr.io/openclaw/openclaw:latest
docker tag ghcr.io/openclaw/openclaw:latest openclaw:local
docker build -f Dockerfile.chromium -t openclaw:chromium .
docker compose up -d --force-recreate openclaw-gateway
sleep 15
echo "✅ Version mise à jour :"
docker exec openclaw-openclaw-gateway-1 openclaw --version
