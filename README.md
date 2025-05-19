# Next.js + NestJS VPS Deployment Template

Production-ready template to deploy a Next.js frontend and NestJS backend on a VPS using:

- 🧑‍💻 PM2 for process management
- 🔁 GitHub Actions for CI/CD (SSH based)
- 🌐 Nginx reverse proxy
- 🌍 Environment template files

## 🔧 Folder Structure

```text
apps/
├── frontend/     # Next.js
└── backend/      # NestJS
```

Here’s a concise README section to add to your repo on how to run the VPS setup script:

---

## 🛠️ VPS Setup Script

This script automates initial VPS configuration for your Next.js + NestJS app deployment:

```bash
# Upload the script to your VPS (if not already there)
scp vps-setup.sh user@your-vps-ip:~

# SSH into your VPS
ssh user@your-vps-ip

# Make the script executable
chmod +x ~/vps-setup.sh

# Run the script (will install pm2, create folders, setup nginx config, reload nginx)
./vps-setup.sh
```

> **Note:**
> The script assumes:
>
> - NestJS backend runs on port `5001`
> - Next.js frontend runs on port `3001`
> - You access your server by IP (no domain configured yet)
> - You have Node.js and npm installed on your VPS

---

Want me to commit this update in the README for you?

## 🚀 Deployment Workflow

- Push to `main` branch
- GitHub Actions connects via SSH
- Runs update scripts on the VPS
- PM2 restarts apps
- Nginx proxies public traffic

📄 [Multi-GitHub SSH Key Setup Guide](./docs/multi-ssh-setup.md)

## 📄 License

[MIT](LICENSE)
