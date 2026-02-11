#!/bin/bash

# 加密市场数字看板 - 快速部署脚本

set -e

PROJECT_DIR="/root/.openclaw/workspace/crypto-dashboard"
cd "$PROJECT_DIR"

echo "======================================"
echo "加密市场数字看板 - 部署状态"
echo "======================================"
echo ""

# 检查构建状态
echo "📦 构建状态:"
if [ -d "dist" ]; then
    echo "  ✅ dist/ 目录存在"
    echo "  📊 文件统计:"
    echo "     - index.html: $(du -h dist/index.html | cut -f1)"
    echo "     - assets/: $(du -h dist/assets/ | cut -f1)"
else
    echo "  ❌ dist/ 目录不存在"
    echo "     正在构建..."
    npm run build
fi

echo ""

# 检查服务器状态
echo "🌐 服务器状态:"
if pgrep -f "http.server 8080" > /dev/null; then
    echo "  ✅ Python 服务器运行中 (端口 8080)"
    # 获取进程 ID
    PID=$(pgrep -f "http.server 8080" | head -1)
    echo "  📌 进程 ID: $PID"
else
    echo "  ❌ Python 服务器未运行"
    echo "     启动服务器..."
    python3 -m http.server 8080 > /tmp/dashboard-server.log 2>&1 &
    sleep 2
    if pgrep -f "http.server 8080" > /dev/null; then
        echo "  ✅ 服务器已启动"
    else
        echo "  ❌ 服务器启动失败"
    fi
fi

echo ""

# 检查 Wrangler
echo "☁️  Cloudflare 部署:"
if command -v wrangler &> /dev/null; then
    echo "  ✅ Wrangler 已安装 (版本: $(wrangler --version | tail -1))"
    if wrangler whoami &> /dev/null; then
        echo "  ✅ 已登录 Cloudflare"
        echo "  🚀 可以部署: wrangler pages deploy dist --project-name crypto-dashboard"
    else
        echo "  ❌ 未登录 Cloudflare"
        echo "     需要运行: wrangler login"
    fi
else
    echo "  ❌ Wrangler 未安装"
    echo "     安装: npm install -g wrangler"
fi

echo ""
echo "======================================"
echo "访问方式:"
echo "======================================"
echo "  本地: http://127.0.0.1:8080/dist/"
echo "  外部: http://$(hostname -I | awk '{print $1}'):8080/dist/"
echo ""

# 显示选项
echo "======================================"
echo "操作选项:"
echo "======================================"
echo "1. 查看项目: cd $PROJECT_DIR && ls -la"
echo "2. 停止服务器: pkill -f 'http.server 8080'"
echo "3. 重新构建: npm run build"
echo "4. 部署到 Cloudflare: 查看 DEPLOY.md"
echo ""

# 日志位置
if [ -f "/tmp/dashboard-server.log" ]; then
    echo "服务器日志: /tmp/dashboard-server.log"
fi
