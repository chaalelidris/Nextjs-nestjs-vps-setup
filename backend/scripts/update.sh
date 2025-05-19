#!/bin/bash
cd ~/apps/backend
git pull origin main
npm install
npm run build
pm2 start ecosystem.config.js --update-env