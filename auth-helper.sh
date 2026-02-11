#!/bin/bash

# Cloudflare Auth Helper Script

echo "======================================"
echo "Cloudflare 授权指南"
echo "======================================"
echo ""

# 检查当前状态
echo "当前授权状态:"
if [ -f ~/.config/.wrangler/credentials.json ]; then
    echo "✅ 已找到 Wrangler 凭证"
    cat ~/.config/.wrangler/credentials.json | grep -o '"api_token":"[^"]*"' | cut -d'"' -f4 | head -c 15 | sed 's/$/.../'
else
    echo "⚠️  未找到 Wrangler 凭证"
fi
echo ""

# 展示选项
echo "请选择授权方式:"
echo ""
echo "选项 1: 使用浏览器授权（推荐）"
echo "  - 在本地计算机上打开终端"
echo "  - 执行: npx wrangler login"
echo "  - 会自动打开浏览器让你登录"
echo "  - 登录成功后复制生成的凭证"
echo ""
echo "选项 2: 使用 API Token（推荐服务器环境）"
echo "  1. 访问 https://dash.cloudflare.com/profile/api-tokens"
echo "  2. 创建 Token（Edit Cloudflare Workers 模板）"
echo "  3. 复制 Token 并粘贴到下面的环境中"
echo ""
echo "选项 3: 使用 GitHub + Cloudflare Pages（最简单）"
echo "  1. 创建 GitHub 仓库"
echo "  2. 推送代码"
echo "  3. 在 Cloudflare Dashboard 连接 GitHub"
echo "  4. 自动部署"
echo ""

# 询问用户
read -p "请选择选项 (1/2/3): " choice

case $choice in
    1)
        echo ""
        echo "请在本地计算机上执行:"
        echo "  npx wrangler login"
        echo ""
        echo "完成后，将生成的 ~/Library/Application\ Support/wrangler/config.json"
        echo "中的 api_token 复制到服务器"
        echo ""
        read -p "粘贴你的 API Token: " token
        mkdir -p ~/.config/.wrangler/
        cat > ~/.config/.wrangler/credentials.json << EOF
{
  "credentials": [
    {
      "api_token": "$token",
      "name": "wrangler"
    }
  ]
}
EOF
        echo "✅ 凭证已保存"
        ;;

    2)
        echo ""
        read -p "请粘贴你的 Cloudflare API Token: " token
        mkdir -p ~/.config/.wrangler/
        cat > ~/.config/.wrangler/credentials.json << EOF
{
  "credentials": [
    {
      "api_token": "$token",
      "name": "wrangler"
    }
  ]
}
EOF
        echo "✅ 凭证已保存"
        # 同时设置环境变量
        export CLOUDFLARE_API_TOKEN="$token"
        echo "🌍 环境变量已设置"

        # 尝试部署
        echo ""
        echo "尝试部署..."
        cd /root/.openclaw/workspace/crypto-dashboard
        wrangler pages deploy dist --project-name crypto-dashboard
        ;;

    3)
        echo ""
        echo "请查看 DEPLOY-GITHUB.md 开始部署"
        echo "或者执行: cat DEPLOY-GITHUB.md"
        ;;

    *)
        echo "无效选项"
        ;;
esac

echo ""
echo "======================================"
