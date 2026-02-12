# 通过 GitHub Actions 自动部署指南

## 🚀 最简单的部署方式

**适合人群：** 不想在服务器上配置 API Token 的用户  
**部署流程：** 推代码到 GitHub → 自动触发部署 → 获得访问链接

---

## ✅ 已完成

项目已准备好 GitHub 自动部署：
- ✅ Git 仓库已初始化
- ✅ GitHub Actions Workflow 已配置
- ✅ 项目构建脚本已就绪
- ✅ .gitignore 已配置（排除 node_modules, dist, logs 等）

---

## 📋 部署步骤（3步完成）

### 步骤 1: 创建 GitHub 仓库

1. 访问 https://github.com/new
2. 仓库名称：`crypto-dashboard`
3. 设置为 Public 或 Private
4. **不要**勾选 "Initialize this repository with a README"
5. 点击 "Create repository"

### 步骤 2: 连接本地仓库并推送

在服务器上执行以下命令（**替换 YOUR_USERNAME**）：

```bash
cd /root/.openclaw/workspace/crypto-dashboard

# 添加所有文件
git add .
git add .github/

# 提交
git commit -m "Initial commit: Crypto Dashboard"

# 添加远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/crypto-dashboard.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

**注意：**
- 如果需要 GitHub Token 认证，使用：
  ```bash
  git remote set-url origin https://YOUR_TOKEN@github.com/YOUR_USERNAME/crypto-dashboard.git
  ```

### 步骤 3: 配置 Cloudflare Pages

1. 访问 https://dash.cloudflare.com/
2. 进入 **Workers & Pages** → **Create application** → **Pages**
3. 选择 **Connect to Git**
4. 选择刚刚创建的 `crypto-dashboard` 仓库
5. Cloudflare 会引导你授权 GitHub
6. 构建设置：
   - **Build command:** `npm run build`
   - **Build output directory:** `dist`
7. 点击 **Save and Deploy**

---

## 🔐 获取必要信息

### Cloudflare Account ID
1. https://dash.cloudflare.com/
2. 在 Workers & Pages 页面右侧，复制 "Account ID"

### Cloudflare API Token
1. https://dash.cloudflare.com/profile/api-tokens
2. 点击 "Create Token"
3. 使用 "Edit Cloudflare Workers" 模板
4. 设置权限：
   - Account → Cloudflare Pages → Edit
5. 保存 Token（会显示一次，请立即复制）

### GitHub Personal Access Token（可选）
如果使用 HTTPS 推送遇到认证问题：
1. https://github.com/settings/tokens
2. 生成新 Token (classic)
3. 勾选 `repo` 权限
4. 保存并复制

---

## 🎯 完整部署流程

### 方案 A: Cloudflare 直接连接（推荐）

```bash
# 1. 在服务器上准备代码
cd /root/.openclaw/workspace/crypto-dashboard
git add .
git commit -m "Ready for deployment"

# 2. 推送到 GitHub
git remote add origin https://github.com/YOUR_USERNAME/crypto-dashboard.git
git branch -M main
git push -u origin main

# 3. 在 Cloudflare Dashboard 连接 GitHub 仓库
# 访问 https://dash.cloudflare.com/ → Workers & Pages → Create → Connect to Git
```

### 方案 B: 使用 GitHub Actions（自动化）

1. **在仓库设置中添加 Secrets**
   - https://github.com/YOUR_USERNAME/crypto-dashboard/settings/secrets/actions
   - 添加以下 Secrets：
     - `CLOUDFLARE_API_TOKEN`: 你的 Cloudflare API Token
     - `CLOUDFLARE_ACCOUNT_ID`: 你的 Cloudflare Account ID

2. **推送代码到 main 分支**
   ```bash
   git push origin main
   ```

3. **自动部署**
   - GitHub Actions 会自动触发
   - 查看 Actions 标签页监控进度
   - 部署日志会显示成功或错误

---

## 📊 部署后获取访问链接

### Cloudflare Pages 访问地址

方式 1: Cloudflare Dashboard
- https://dash.cloudflare.com/ → Workers & Pages
- 查看 crypto-dashboard 项目
- 访问 URL 格式：`https://crypto-dashboard.pages.dev`

方式 2: 自定义域名（可选）
1. 在 Cloudflare Pages 项目设置中添加自定义域名
2. 免费自动配置 SSL 证书
3. 自动 DNS 配置（如果域名在 Cloudflare）

---

## 🔧 故障排除

### 问题 1: GitHub 推送时提示认证失败

**解决方案：**
```bash
# 方法 1: 使用 SSH
git remote set-url origin git@github.com:YOUR_USERNAME/crypto-dashboard.git

# 方法 2: 使用 Personal Access Token
git remote set-url origin https://YOUR_TOKEN@github.com/YOUR_USERNAME/crypto-dashboard.git

# 方法 3: 使用 GitHub CLI（需要安装）
gh auth login
git push
```

### 问题 2: GitHub Actions 构建失败

**检查：**
- Node.js 版本（workflow 设置为 22）
- npm install 是否成功
- 构建日志中的错误信息

**查看日志：**
1. GitHub 仓库 → Actions 标签
2. 点击失败的 workflow run
3. 查看具体错误

### 问题 3: Cloudflare Pages 部署失败

**检查：**
- API Token 权限是否正确
- Account ID 是否正确
- build command 是否正确（应该是 `npm run build`）
- build output directory 是否正确（应该是 `dist`）

---

## 📂 项目文件结构

```
crypto-dashboard/
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions 配置
├── src/                        # 源代码
├── dist/                       # 构建输出（会自动生成）
├── node_modules/               # 依赖包
├── package.json
├── vite.config.ts
├── tsconfig.json
├── tailwind.config.ts
├── .gitignore                  # Git 忽略文件
└── README.md                   # 项目说明
```

---

## 🔄 更新部署

每次更新代码后，只需推送即可：

```bash
# 1. 测试本地构建
npm run build

# 2. 如果成功，提交并推送
git add .
git commit -m "Update feature"
git push origin main

# 3. 自动触发部署（Cloudflare 或 GitHub Actions）
```

---

## 📈 监控部署

### Cloudflare Pages
- https://dash.cloudflare.com/ → Workers & Pages → crypto-dashboard
- 查看部署历史
- 实时流量统计
- 错误日志

### GitHub Actions
- GitHub 仓库 → Actions 标签
- 查看每次部署的工作流
- 构建时长和状态

---

## 🎁 额外功能

### 环境变量（可选）

如果你需要不同的环境（开发/生产）：

1. 在 Cloudflare Pages 项目设置中添加环境变量
2. 在代码中使用：
   ```typescript
   const apiKey = import.meta.env.VITE_API_KEY || 'default';
   ```

3. GitHub Actions 会自动传递环境变量到 Cloudflare

### 预览部署（Pull Requests）

每次创建 PR 时，Cloudflare 会自动：
- 创建预览环境（Preview Deployment）
- 获得临时的访问链接
- 方便测试和 review

---

## 📝 快速命令参考

```bash
# 初始化
cd /root/.openclaw/workspace/crypto-dashboard
git init
git config user.email "admin@openclaw.local"
git config user.name "OpenClaw AI"

# 提交和推送
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main

# 检查状态
git status
git log --oneline

# 撤销上次提交（如果需要）
git reset --soft HEAD~1
```

---

## 🌟 优势

相比服务器本地部署，GitHub + Cloudflare 方案的优势：

1. **自动化：** 推送代码自动部署，无需手动
2. **CDN：** Cloudflare 全球 CDN 加速
3. **SSL：** 自动配置 HTTPS 证书
4. **版本管理：** Git 版本控制 + 部署历史
5. **预览环境：** PR 自动创建预览部署
6. **免费：** 完全免费，无限制流量
7. **DDoS 保护：** Cloudflare 自动防护

---

## 🚀 开始部署

根据你的需求选择方案：

- **最简单：** 方案 A（Cloudflare 连接 GitHub）
- **最自动化：** 方案 B（GitHub Actions）
- **最灵活：** 使用 Vercel (但需要 API)

选择适合的方案，几分钟内就能获得全球可访问的看板！

---

**项目位置：** `/root/.openclaw/workspace/crypto-dashboard/`  
**GitHub 仓库：** https://github.com/YOUR_USERNAME/crypto-dashboard  
**Cloudflare Pages：** https://crypto-dashboard.pages.dev
