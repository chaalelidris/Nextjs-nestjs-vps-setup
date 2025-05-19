#!/bin/bash
cd ~/apps/frontend
git pull origin main
npm install
npm run build
pm2 start ecosystem.config.js --update-env