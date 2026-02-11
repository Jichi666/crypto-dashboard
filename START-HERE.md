# 🚀 开始部署 - 最简单的方法

## 好消息：无需服务器授权，使用 GitHub 即可！

---

## 📋 你只需要做 3 件事

### 1️⃣ 生成 GitHub Token（1 分钟）

访问这个链接创建 Token：
https://github.com/settings/tokens

点击 "Generate new token (classic)"，勾选 `repo` 权限，生成后复制 Token。

---

### 2️⃣ 推送代码到 GitHub（1 分钟）

在服务器执行（替换 YOUR_USERNAME 和 YOUR_TOKEN）：

```bash
cd /root/.openclaw/workspace/crypto-dashboard

export GITHUB_TOKEN=your_token_here

git remote add origin https://$GITHUB_TOKEN@github.com/YOUR_USERNAME/crypto-dashboard.git
git branch -M main
git push -u origin main
```

---

### 3️⃣ 在浏览器连接 Cloudflare（2 分钟）

1. 打开：https://dash.cloudflare.com/
2. 登录 Cloudflare 账户
3. 点击：Workers & Pages → Create application
4. 选择：Pages → Connect to Git
5. 选择你的 `crypto-dashboard` 仓库
6. 输入：
   - Build command: `npm run build`
   - Output directory: `dist`
7. 点击：Save and Deploy

---

## ✅ 完成！

2-3 分钟后访问：
```
https://crypto-dashboard.pages.dev
```

**就这么简单！不需要在服务器上做任何授权！** 🎉

---

## 📚 详细文档

- **快速开始**: `cat DEPLOY-NOW.md`
- **详细指南**: `cat DEPLOY-GITHUB.md`
- **手动部署**: `cat MANUAL-DEPLOY.md`

## 🛠️ 可用脚本

```bash
./deploy.sh              # 一键部署助手
./deploy-status.sh       # 查看当前状态
./auth-helper.sh         # 授权助手（如果需要）
```

---

**开始吧！5 分钟内获得全球可访问的加密市场看板！** 🚀
