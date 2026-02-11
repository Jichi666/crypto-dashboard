# 🚀 一键部署指南 - GitHub + Cloudflare Pages

## 为什么选择这个方案？

✅ **无需认证：** 不需要在服务器上配置 API Token
✅ **自动部署：** 推送代码后自动触发部署
✅ **完全免费：** GitHub 和 Cloudflare 都免费
✅ **全球访问：** Cloudflare CDN 全球加速
✅ **HTTPS：** 自动配置 SSL 证书

---

## 📋 部署前准备

### 选项 A: 生成 GitHub Token（推荐）

**1. 创建 Token**
- 访问: https://github.com/settings/tokens
- 点击 "Generate new token (classic)"
- 勾选权限：`repo`（完整代码库访问）
- 设置有效期（可选）
- 点击 "Generate token"
- **立即复制 Token**（只显示一次）

**2. 设置环境变量**
```bash
export GITHUB_TOKEN=your_token_here
```

### 选项 B: 使用 SSH 密钥（如果你已配置）

如果已在 GitHub 上配置 SSH 密钥，可以直接使用：
```bash
git@github.com:YOUR_USERNAME/crypto-dashboard.git
```

---

## 🚀 3 步完成部署

### 步骤 1: 创建 GitHub 仓库

1. 访问: https://github.com/new
2. 仓库名称: `crypto-dashboard`
3. 选择 Public 或 Private
4. **不要**勾选 "Initialize with README"
5. 点击 "Create repository"

---

### 步骤 2: 推送代码到 GitHub

**在服务器上执行：**

```bash
cd /root/.openclaw/workspace/crypto-dashboard

# 方式 1: 使用 GitHub Token（推荐）
export GITHUB_TOKEN=your_token_here

git remote add origin https://$GITHUB_TOKEN@github.com/YOUR_USERNAME/crypto-dashboard.git
git branch -M main
git push -u origin main

# 方式 2: 使用 SSH
git remote add origin git@github.com:YOUR_USERNAME/crypto-dashboard.git
git branch -M main
git push -u origin main
```

**如果使用部署脚本：**
```bash
chmod +x deploy.sh
./deploy.sh
```

脚本会引导你完成所有步骤。

---

### 步骤 3: 连接 Cloudflare Pages

**非交互式部署，无需账户授权：**

1. **打开 Cloudflare:**
   - https://dash.cloudflare.com/
   - 登录你的账户

2. **创建Pages项目:**
   - 进入 "Workers & Pages"
   - 点击 "Create application"
   - 选择 "Pages"

3. **连接 GitHub:**
   - 选择 "Connect to Git"
   - Cloudflare 会引导你授权 GitHub
   - 选择 `crypto-dashboard` 仓库
   - 点击 "Begin setup"

4. **配置构建:**
   ```
   Framework preset: Vite
   Build command: npm run build
   Build output directory: dist
   ```

5. **启动部署:**
   - 点击 "Save and Deploy"
   - 等待 1-2 分钟
   - 部署成功后显示：
     ```
     ✨ Successfully deployed
     🌐 https://crypto-dashboard.pages.dev
     ```

---

## 🎯 部署验证

**访问地址：**
```
https://crypto-dashboard.pages.dev
```

**检查功能：**
- ✅ 显示 5 个币种价格卡片（BTC, ETH, SOL, ADA, AVAX）
- ✅ 实时价格更新（30秒刷新）
- ✅ 24小时价格走势图
- ✅ 投资组合表格
- ✅ 市场热力趋势图
- ✅ 响应式布局（手机/平板/桌面）

---

## 🔄 更新部署

每次更新代码后：

```bash
cd /root/.openclaw/workspace/crypto-dashboard

# 1. 测试构建
npm run build

# 2. 提交代码
git add .
git commit -m "Update feature"

# 3. 推送（自动触发部署）
git push origin main
```

Cloudflare 会自动检测到 GitHub 的推送并重新部署

---

## 📊 快速命令

```bash
# 查看部署状态脚本
./deploy-status.sh

# 一键部署助手
./deploy.sh

# 显示完整部署指南
cat DEPLOY-GITHUB.md

# 显示快速开始指南
cat DEPLOY-NOW.md
```

---

## 🐛 常见问题

### Q: 推送代码时提示 "Authentication failed"
A: 检查 GitHub Token 是否正确，确认勾选了 `repo` 权限

### Q: Cloudflare 部署失败
A: 检查构建设置：
   - Build command: `npm run build`
   - Output directory: `dist`

### Q: 如何查看部署日志？
A: 在 Cloudflare Dashboard 进入 Workers & Pages → crypto-dashboard → Deployments

### Q: 如何自定义域名？
A: 在 Cloudflare Pages 项目设置中添加自定义域名，自动配置 SSL 和 DNS

---

## 📁 项目文件

```
/root/.openclaw/workspace/crypto-dashboard/
├── src/                        # 源代码
├── dist/                       # 构建输出
├── deploy.sh                   # 一键部署脚本 ⭐
├── auth-helper.sh              # 授权助手
├── deploy-status.sh            # 状态检查
├── DEPLOY-GITHUB.md            # 详细指南
├── DEPLOY-NOW.md               # 快速开始
└── README.md                   # 项目说明
```

---

## ⏱️ 预计时间

- 创建 GitHub 仓库: 1 分钟
- 推送代码: 1-2 分钟
- 连接 Cloudflare: 2-3 分钟
- 首次部署: 1-2 分钟

**总计：5-8 分钟**

---

## 🎉 完成后

你将拥有：

✅ 构建好的加密市场看板
✅ 全球 CDN 加速
✅ 自动 HTTPS
✅ 免费 SSL 证书
✅ 自动部署系统

**立即开始！**

```bash
# 生成 GitHub Token 后
cd /root/.openclaw/workspace/crypto-dashboard
export GITHUB_TOKEN=your_token_here
git remote add origin https://$GITHUB_TOKEN@github.com/YOUR_USERNAME/crypto-dashboard.git
git branch -M main
git push -u origin main
```

---

**下一步:** 在 Cloudflare Dashboard 连接 GitHub 仓库完成自动部署！🚀
