# Next.js + NestJS Production VPS Setup

# ==============================
# Folder Structure:
# ==============================
# - backend/                  # NestJS app
#   - ecosystem.config.js
#   - scripts/update.sh
# - frontend/                 # Next.js app
#   - ecosystem.config.js
#   - scripts/update.sh
# - .github/workflows/deploy.yml
# - .env.example (in both)

# ==============================
# 1. GitHub Actions: .github/workflows/deploy.yml
# ==============================

name: Deploy to VPS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup SSH
        uses: webfactory/ssh-agent@v0.7.0
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Deploy backend
        run: ssh -o StrictHostKeyChecking=no ${{ secrets.VPS_USER }}@${{ secrets.VPS_IP }} "bash ~/apps/backend/scripts/update.sh"

      - name: Deploy frontend
        run: ssh -o StrictHostKeyChecking=no ${{ secrets.VPS_USER }}@${{ secrets.VPS_IP }} "bash ~/apps/frontend/scripts/update.sh"

# ==============================
# 2. backend/ecosystem.config.js
# ==============================

module.exports = {
  apps: [
    {
      name: 'nestjs-backend',
      script: 'dist/main.js',
      cwd: '/home/your-user/apps/backend',
      env: {
        NODE_ENV: 'production',
      },
    },
  ],
};

# ==============================
# 3. backend/scripts/update.sh
# ==============================

#!/bin/bash
cd ~/apps/backend
git pull origin main
npm install
npm run build
pm2 start ecosystem.config.js --update-env

# ==============================
# 4. frontend/ecosystem.config.js
# ==============================

module.exports = {
  apps: [
    {
      name: 'nextjs-frontend',
      script: 'node_modules/next/dist/bin/next',
      args: 'start -p 3001',
      cwd: '/home/your-user/apps/frontend',
      env: {
        NODE_ENV: 'production',
      },
    },
  ],
};

# ==============================
# 5. frontend/scripts/update.sh
# ==============================

#!/bin/bash
cd ~/apps/frontend
git pull origin main
npm install
npm run build
pm2 start ecosystem.config.js --update-env

# ==============================
# 6. Nginx Config
# ==============================

# /etc/nginx/sites-available/web-app

server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api/ {
        proxy_pass http://localhost:3000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

# Enable the config
# sudo ln -s /etc/nginx/sites-available/web-app /etc/nginx/sites-enabled
# sudo nginx -t && sudo systemctl reload nginx

# ==============================
# 7. .env.example (Backend and Frontend)
# ==============================

# Backend .env.example
NODE_ENV=production
PORT=3000
DB_URL=postgres://user:pass@localhost:5432/db

# Frontend .env.example
NODE_ENV=production
NEXT_PUBLIC_API_URL=https://yourdomain.com/api
