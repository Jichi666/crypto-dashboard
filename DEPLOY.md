# 加密市场数字看板 - 部署指南

## 项目路径
`/root/.openclaw/workspace/crypto-dashboard/`

---

## 选项 1: 本地直接访问（已就绪）

### 当前状态
✅ 本地服务器已运行: 端口 8080  
✅ 构建文件位于: `dist/` 目录

### 访问方式
在服务器上打开浏览器访问：
```
http://127.0.0.1:8080/dist/
```

### 如果需要从外部访问
需要开放防火墙端口 8080：
```bash
# 开放 8080 端口（如果是 firewalld）
sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# 或者使用 iptables
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables-save
```

然后访问：
```
http://your-server-ip:8080/dist/
```

---

## 选项 2: Cloudflare Pages 部署（推荐）

### 方法 A: 使用 Wrangler（推荐）

#### 步骤 1: 登录 Cloudflare
在你的本地计算机（而不是服务器）上打开终端：
```bash
npm install -g wrangler
wrangler login
```
这会打开浏览器让你登录 Cloudflare 账户。

#### 步骤 2: 上传 dist 文件夹
方法 A1: 从本地先下载 dist
```bash
# 在服务器上打包
cd /root/.openclaw/workspace/crypto-dashboard/
tar -czf crypto-dashboard-dist.tar.gz dist/

# 下载到本地（在本地计算机执行）
scp root@your-server-ip:/root/.openclaw/workspace/crypto-dashboard/crypto-dashboard-dist.tar.gz ./

# 解压
tar -xzf crypto-dashboard-dist.tar.gz

# 部署（在本地计算机执行）
wrangler pages deploy dist --project-name crypto-dashboard
```

方法 A2: 直接从服务器部署（如果有 API Token）
```bash
# 获取 API Token，然后
wrangler login --api-token YOUR_API_TOKEN
wrangler pages deploy dist --project-name crypto-dashboard
```

#### 步骤 3: 查看访问链接
部署成功后会显示：
```
✨ Successfully deployed your Project to the following URL:
https://crypto-dashboard.pages.dev
```

---

### 方法 B: 使用 Cloudflare Pages 网站界面

1. 登录到 [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. 进入 **Workers & Pages** → **Create application** → **Pages**
3. 选择 **Upload assets**
4. 下载项目文件夹：
   ```bash
   # 在服务器上打包整个项目
   cd /root/.openclaw/
   tar -czf crypto-dashboard.tar.gz crypto-dashboard/
   
   # 下载到本地（在本地计算机执行）
   scp root@your-server-ip:/root/.openclaw/crypto-dashboard.tar.gz ./
   
   # 解压
   tar -xzf crypto-dashboard.tar.gz
   ```
5. 上传 `crypto-dashboard/dist/` 文件夹到 Cloudflare Pages
6. 项目名称设置为 `crypto-dashboard`
7. 点击 **Deploy** 等待部署完成（约 1-2 分钟）
8. 获得访问链接（如 `https://crypto-dashboard.pages.dev`）

---

## 选项 3: Netlify/Vercel/GitHub Pages

### Netlify Deploy
1. 下载 `dist` 文件夹
2. 访问 [app.netlify.com](https://app.netlify.com/)
3. 拖拽 `dist` 文件夹到网站
4. 等待部署完成

### Vercel Deploy
1. 将项目代码推送到 GitHub
2. 访问 [vercel.com](https://vercel.com/)
3. 导入 GitHub 仓库
4. 自动部署

### GitHub Pages
1. 创建 `gh-pages` 分支并推送 dist 内容
2. 在 GitHub 仓库设置中启用 GitHub Pages
3. 选择 `gh-pages` 分支作为发布源

---

## 快速命令参考

### 本地服务器管理
```bash
# 启动服务器
cd /root/.openclaw/workspace/crypto-dashboard
python3 -m http.server 8080

# 停止服务器
pkill -f "http.server 8080"

# 重新构建
npm run build
```

### 部署到 Cloudflare
```bash
# 获取 API Token
# 访问: https://dash.cloudflare.com/profile/api-tokens
# 创建 Token: Edit Cloudflare Workers

# 使用 Token 登录
wrangler login --api-token YOUR_API_TOKEN

# 部署
wrangler pages deploy dist --project-name crypto-dashboard
```

---

## 项目技术栈

- React 18 + Vite 6
- TailwindCSS 3.4
- Recharts 2.15
- CoinGecko API (50 calls/min)
- Cloudflare Pages (完全免费)

---

## 性能优化建议

1. **API 限制**: CoinGecko 免费 50 calls/min，已设置 30 秒刷新
2. **缓存优化**: 后续可添加 Cloudflare KV 缓存
3. **代码分割**: 当前打包 549KB，可按组件拆分优化
4. **CDN 加速**: Cloudflare Pages 提供全球 CDN

---

## 下一步功能扩展

待实现的功能：
- [ ] 价格预警通知
- [ ] 市场新闻聚合
- [ ] 更多币种支持
- [ ] 用户配置持久化
- [ ] 钱包连接功能

---

获取帮助：如有问题，请联系或查看 [Cloudflare Pages 文档](https://developers.cloudflare.com/pages/)
