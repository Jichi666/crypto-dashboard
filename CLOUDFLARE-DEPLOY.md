# 🚀 Cloudflare Pages 部署操作指南

## 当前状态

✅ **已完成:**
- 项目构建成功
- 本地服务器运行中 (http://10.3.0.10:8080/dist/)
- Wrangler 已安装 (v4.64.0)
- Wrangler 已首次登录 Cloudflare

⚠️ **需要完成:**
- 设置 Cloudflare API Token
- 完成部署到 Cloudflare Pages

---

## 方案 A: 完全自动部署（推荐）

### 步骤 1: 获取 Cloudflare API Token

1. 访问 Cloudflare: https://dash.cloudflare.com/profile/api-tokens
2. 点击 **Create Token**
3. 选择 **Edit Cloudflare Workers** 模板
4. 点击 **Continue to summary**
5. 设置 Token 权限：
   - Account → Cloudflare Pages → Edit
   - Account → Workers Scripts (Optional)
   - Account → Account Settings → Read
6. 设置账户资源为你的 Cloudflare 账户
7. 继续创建并保存 Token（会显示一次，请立即复制）

### 步骤 2: 设置环境变量并部署

在服务器上执行：

```bash
# 设置 API Token（替换 YOUR_API_TOKEN）
export CLOUDFLARE_API_TOKEN=your_api_token_here

# 部署
cd /root/.openclaw/workspace/crypto-dashboard
wrangler pages deploy dist --project-name crypto-dashboard
```

部署成功后会显示：
```
✨ Successfully deployed your Project to the following URL:
https://crypto-dashboard.pages.dev
```

### 步骤 3: 永久保存 Token（可选）

编辑 `~/.bashrc` 或 `~/.zshrc` 添加：
```bash
export CLOUDFLARE_API_TOKEN=your_api_token_here
```

---

## 方案 B: 交互式登录（本地部署）

如果你不方便在服务器上设置 API Token，可以在你的本地计算机上完成部署：

### 步骤 1: 在服务器上打包项目

```bash
cd /root/.openclaw/workspace/crypto-dashboard
tar -czf crypto-dashboard-dist.tar.gz dist/
```

### 步骤 2: 下载到本地计算机

在你的本地 macOS/Linux/Windows 终端执行：
```bash
scp root@your-server-ip:/root/.openclaw/workspace/crypto-dashboard/crypto-dashboard-dist.tar.gz ./
```

### 步骤 3: 在本地部署到 Cloudflare

```bash
# 解压
tar -xzf crypto-dashboard-dist.tar.gz

# 安装 wrangler（如果还没有）
npm install -g wrangler

# 登录（会打开浏览器）
wrangler login

# 部署
wrangler pages deploy dist --project-name crypto-dashboard
```

---

## 方案 C: 网站界面部署（最简单）

1. 在服务器上打包 dist 文件夹
2. 通过 SCP/SFTP 下载到本地
3. 访问 Cloudflare Dashboard
4. 进入 Workers & Pages → Create application → Pages
5. 选择 "Upload assets"
6. 上传 dist 文件夹（解压后的）
7. 点击 Deploy

---

## 常见问题

### Q: 部署后如何自定义域名？
A: 在 Cloudflare Pages 项目设置中添加自定义域名，免费 SSL 自动配置。

### Q: 如何查看部署日志？
A:
```bash
# 查看部署列表
wrangler pages deployment list --project-name crypto-dashboard

# 查看特定部署日志
wrangler pages deployment tail --project-name crypto-dashboard
```

### Q: 如何删除项目？
A:
```bash
wrangler pages project delete crypto-dashboard
```

### Q: 如何更新部署？
A: 重新构建并部署：
```bash
npm run build
wrangler pages deploy dist --project-name crypto-dashboard
```

---

## 项目访问

### 本地访问（当前可用）
```
http://10.3.0.10:8080/dist/
```

### Cloudflare Pages（部署后可用）
```
https://crypto-dashboard.pages.dev
```

或自定义域名

---

## 快速命令

| 操作 | 命令 |
|------|------|
| 查看部署状态 | `./deploy-status.sh` |
| 重新构建 | `npm run build` |
| 停止本地服务器 | `pkill -f 'http.server 8080'` |
| 启动本地服务器 | `python3 -m http.server 8080` |
| 部署到 Cloudflare | `wrangler pages deploy dist --project-name crypto-dashboard` |

---

## 技术支持

- Cloudflare Pages 文档: https://developers.cloudflare.com/pages/
- Wrangler 文档: https://developers.cloudflare.com/workers/wrangler/
- 项目位置: `/root/.openclaw/workspace/crypto-dashboard/`

---

选择适合你的方案，完成部署后就能通过 Cloudflare CDN 全球访问看板了！🌍
