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

## 🚀 Deployment Workflow

- Push to `main` branch
- GitHub Actions connects via SSH
- Runs update scripts on the VPS
- PM2 restarts apps
- Nginx proxies public traffic

## 📄 License

[MIT](LICENSE)
