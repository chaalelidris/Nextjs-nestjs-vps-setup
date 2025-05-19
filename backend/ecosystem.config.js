module.exports = {
  apps: [
    {
      name: "nestjs-backend",
      script: "dist/main.js",
      cwd: "/home/your-user/apps/backend",
      env: {
        NODE_ENV: "production",
      },
    },
  ],
};
