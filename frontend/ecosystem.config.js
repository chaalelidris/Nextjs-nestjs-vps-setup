module.exports = {
  apps: [
    {
      name: "nextjs-frontend",
      script: "node_modules/next/dist/bin/next",
      args: "start -p 3001",
      cwd: "/home/your-user/apps/frontend",
      env: {
        NODE_ENV: "production",
      },
    },
  ],
};
