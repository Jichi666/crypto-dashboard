# 🚀 你来执行 - 完整部署指南

## 当前状态

✅ **已准备好的文件：**
- `crypto-dashboard.bundle` (115 KB) - 包含完整项目源码 + Git 历史

---

## 选择方案

### 方案 A: 使用 Git Bundle 包（推荐 - 最快）

**优点：**
- ✅ 单文件传输
- ✅ 包含完整历史
- ✅ 不需要 node_modules（本地会自动安装）

**步骤：**

1. **下载 bundle 文件到本地**
   ```bash
   # 在本地执行（替换 your-server-ip）
   scp root@your-server-ip:/root/.openclaw/workspace/crypto-dashboard/crypto-dashboard.bundle ./
   ```

2. **克隆并推送到 GitHub**
   ```bash
   # 在本地执行
   git clone crypto-dashboard.bundle crypto-dashboard
   cd crypto-dashboard

   # 生成 GitHub Token
   # 访问: https://github.com/settings/tokens
   # 创建 token (classic) 并勾选 repo 权限

   # 添加远程仓库（替换 YOUR_USERNAME）
   export GITHUB_TOKEN=your_token_here
   git remote add origin https://$GITHUB_TOKEN@github.com/YOUR_USERNAME/crypto-dashboard.git

   # 推送到 GitHub
   git push -u origin main
   ```

3. **连接 Cloudflare Pages**
   - 浏览器访问: https://dash.cloudflare.com/
   - Workers & Pages → Create → Pages
   - Connect to Git → 选择 crypto-dashboard 仓库
   - 配置：`npm run build`，output directory `dist`
   - Save and Deploy

---

### 方案 B: 使用自动部署脚本（在服务器执行）

**优点：**
- ✅ 交互式，引导完成
- ✅ 自动配置 Git 远程仓库
- ✅ 自动推送代码

**步骤：**

1. **生成 GitHub Token**
   - 访问: https://github.com/settings/tokens
   - 创建 token (classic)，勾选 `repo` 权限
   - 复制生成的 Token

2. **在服务器执行脚本**
   ```bash
   cd /root/.openclaw/workspace/crypto-dashboard
   ./auto-deploy.sh
   ```

3. **按提示操作**
   - 输入 GitHub 用户名
   - 粘贴 GitHub Token
   - 等待推送完成

4. **在浏览器连接 Cloudflare**（同方案 A 第 3 步）

---

### 方案 C: 手动执行（适合有经验的用户）

在服务器执行：
```bash
cd /root/.openclaw/workspace/crypto-dashboard

# 生成 GitHub Token 后
export GITHUB_TOKEN=your_token_here

# 添加远程仓库（替换用户名）
git remote add origin https://$GITHUB_TOKEN@github.com/YOUR_USERNAME/crypto-dashboard.git

# 推送
git branch -M main
git push -u origin main
```

然后在浏览器连接 Cloudflare Pages。

---

## Cloudflare Pages 连接（所有方案第 3 步相同）

1. **打开 Cloudflare:**
   https://dash.cloudflare.com/

2. **创建 Pages 项目:**
   - Workers & Pages → Create application
   - 选择 Pages
   - 选择 Connect to Git

3. **授权并选择仓库:**
   - Cloudflare 会引导你授权 GitHub
   - 选择 `crypto-dashboard` 仓库
   - 点击 Begin setup

4. **配置构建设置:**
   ```
   Framework: Vite
   Build command: npm run build
   Build output directory: dist
   ```

5. **启动部署:**
   - 点击 Save and Deploy
   - 等待 1-2 分钟
   - 部署成功后显示:
     ```
     ✨ Successfully deployed
     🌐 https://crypto-dashboard.pages.dev
     ```

---

## 验证部署

访问: https://crypto-dashboard.pages.dev

应该看到:
- ✅ 5 个币种价格卡片（BTC, ETH, SOL, ADA, AVAX）
- ✅ 24小时价格走势图
- ✅ 投资组合表格
- ✅ 市场热力趋势
- ✅ 实时更新（30秒）

---

## 更新部署

每次更新代码后:

```bash
cd /root/.openclaw/workspace/crypto-dashboard

# 本地构建测试
npm run build

# 提交并推送（自动触发部署）
git add .
git commit -m "Update feature"
git push origin main
```

Cloudflare 会自动重新部署！

---

## 快速命令参考

```bash
# 下载 bundle（本地）
scp root@server-ip:/root/.openclaw/workspace/crypto-dashboard/crypto-dashboard.bundle ./

# 克隆 bundle（本地）
git clone crypto-dashboard.bundle crypto-dashboard

# 运行自动部署脚本（服务器）
./auto-deploy.sh

# 检查状态
./deploy-status.sh
```

---

## 📊 项目统计

- Git bundle 大小: 115 KB
- 源代码文件: 24 个
- 构建输出: 549 KB (gzipped 159 KB)
- 部署脚本: 4 个（auto-deploy.sh, deploy.sh, auth-helper.sh, deploy-status.sh）

---

## 🎯 推荐

**最快方案：** 方案 A（Git Bundle）
- 单文件传输
- 本地操作更灵活
- 不需要在服务器上配置

**最简单：** 方案 B（自动部署脚本）
- 交互式引导
- 自动完成所有配置
- 一键推送

---

**选择适合你的方案，3-5 分钟完成部署！** 🚀
