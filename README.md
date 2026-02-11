# 加密市场数字看板

一个基于 React + Vite + Recharts 的加密货币实时看板，部署在 Cloudflare Pages。

## 功能特性

### 📊 核心功能

1. **实时价格追踪**
   - 支持 5 大主流币种（BTC, ETH, SOL, ADA, AVAX）
   - 实时价格更新（30秒刷新间隔）
   - 涨跌指示和百分比变化
   - 24小时迷你走势图

2. **历史价格图表**
   - 24小时价格走势 Area 图
   - 多时间周期选择（1H, 1D, 1W）

3. **投资组合管理**
   - 资产列表展示
   - 本地化盈亏计算
   - 总价值汇总

4. **市场热力趋势**
   - 柱图展示各币种市场热度
   - 基于 24小时交易量热度评分

### 🎨 设计特点

- 暗色玻璃态设计
- 响应式布局（移动端适配）
- 流畅动画和过渡效果
- 专业金融软件风格

## 技术栈

### 前端
- React 18
- Vite 5
- TailwindCSS
- Recharts
- Zustand
- React Query

### 数据源
- [CoinGecko API](https://www.coingecko.com/api) - 主数据源
- [CoinMarketCap API](https://coinmarketcap.com/api) - 辅助数据源

### 部署
- Cloudflare Pages - 免费静态托管
- Cloudflare Workers - 边缘计算（API 代理）
- Cloudflare KV - 价格数据缓存
- Cloudflare D1 - 用户配置存储

## 安装和运行

### 开发环境

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build
```

### 环境变量

```bash
# 暂未使用环境变量，但可以配置：
# VITE_COINGECKO_API_KEY=xxx (如果需要更高调用频率)
```

## 文件结构

```
crypto-dashboard/
├── src/
│   ├── components/
│   │   ├── PriceCard.tsx
│   │   ├── Charts.tsx
│   │   └── Portfolio.tsx
│   ├── App.tsx
│   ├── main.tsx
│   ├── index.css
│   ├── types.ts
│   └── api.ts
├── public/
│   ├── prototype.html  (独立原型)
├── vite.config.js
├── package.json
└── README.md
```

## 开发说明

### API 集成

所有 API 调用都在 `src/api.ts` 中：

- `fetchCurrentPrices()` - 获取当前价格
- `fetchPriceHistory()` - 获取历史价格
- `fetchMarketCapRanking()` - 获取市场热度

### 实时更新机制

前端使用 `useEffect` 钩子每30秒轮询一次价格数据，并在获得响应时触发界面更新。

### 部署到 Cloudflare Pages

```bash
# 安装 Cloudflare Pages Wrangler
npm install -g wrangler

# 登录 Cloudflare
wrangler login

# 部署
npm run deploy
```

### 数据更新策略

- **免费额度安全：** CoinGecko API 免费层 50 calls/minute
- **刷新频率：** 30秒一次
- **缓存优化：** 使用 Cloudflare KV 缓存减少 API 调用
- **备用方案：** 使用本地模拟数据（当 API 失败时）

## 项目管理

本项目使用自定义的项目管理流程，里程碑和进度保存在 `projects/crypto-dashboard.json` 中。

**当前阶段：** 开发实施（进行中）

**里程碑：**
- ✅ 阶段1: 需求分析
- ✅ 阶段2: 技术选型
- ✅ 预段3: 原型设计
- ⏳ 阶段4: 开发实施
- ⏳ 阶段5: 部署上线

## License

MIT License
