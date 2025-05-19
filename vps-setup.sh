#!/bin/bash

set -e

echo "📁 Creating apps folders if not present..."
mkdir -p ~/apps

echo "📦 Installing PM2 globally..."
sudo npm install -g pm2

echo "🛠️ Installing Nginx if missing..."
if ! command -v nginx &> /dev/null; then
  sudo apt update
  sudo apt install -y nginx
fi

echo "🛠️ Setting up Nginx folders..."
sudo mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled

echo "📄 Writing Nginx config..."
sudo tee /etc/nginx/sites-available/web-app > /dev/null <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /api/ {
        proxy_pass http://localhost:5001/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

echo "🔗 Enabling Nginx site..."
sudo ln -sf /etc/nginx/sites-available/web-app /etc/nginx/sites-enabled/web-app

echo "🚦 Starting and enabling Nginx service..."
sudo systemctl start nginx
sudo systemctl enable nginx

echo "🔄 Testing and reloading Nginx..."
sudo nginx -t && sudo systemctl reload nginx

echo "✅ VPS setup complete!"
