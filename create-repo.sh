#!/bin/bash

# 使用 GitHub API 创建仓库的脚本

set -e

# 从环境变量读取
TOKEN="${GITHUB_TOKEN:-}"
USERNAME="${GITHUB_USERNAME:-}"
REPO_NAME="crypto-dashboard"

if [ -z "$TOKEN" ] || [ -z "$USERNAME" ]; then
    echo "错误: 需要设置 GITHUB_TOKEN 和 GITHUB_USERNAME 环境变量"
    echo "示例: export GITHUB_TOKEN=your_token && export GITHUB_USERNAME=your_username && $0"
    exit 1
fi

echo "=========================================="
echo "📦 在 GitHub 上创建仓库"
echo "=========================================="
echo ""

echo "用户: $USERNAME"
echo "仓库名: $REPO_NAME"
echo ""

# 使用 API 创建仓库
echo "正在创建仓库..."

response=$(curl -s -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{
    \"name\": \"$REPO_NAME\",
    \"description\": \"加密市场数字看板 - React + Vite Cloudflare Pages\",
    \"private\": false,
    \"has_issues\": true,
    \"has_projects\": false,
    \"has_wiki\": false
  }")

echo "API 响应:"

if echo "$response" | grep -q '"html_url"'; then
    echo ""
    echo "✅ 仓库已存在或创建成功"

    # 获取仓库 URL
    REPO_URL="https://github.com/$USERNAME/$REPO_NAME"
    echo ""
    echo "仓库地址: $REPO_URL"
    echo ""

    # 配置 Git 远程仓库
    cd /root/.openclaw/workspace/crypto-dashboard

    if git remote -v | grep -q "github"; then
        git remote set-url origin "https://$TOKEN@github.com/$USERNAME/$REPO_NAME.git"
    else
        git remote add origin "https://$TOKEN@github.com/$USERNAME/$REPO_NAME.git"
    fi

    echo "✅ Git 远程仓库已配置"
    echo ""

    # 推送代码
    echo "=========================================="
    echo "📤 推送代码到 GitHub"
    echo "=========================================="
    echo ""

    if git push -u origin main 2>&1 | tee /tmp/git-push.log; then
        echo ""
        echo "✅ 推送成功！"

        echo ""
        echo "=========================================="
        echo "🎉 部署成功！"
        echo "=========================================="
        echo ""
        echo "查看仓库:"
        echo "  $REPO_URL"
        echo ""
        echo "现在进入 Cloudflare 完成部署："
        echo ""
        echo "1. 打开: https://dash.cloudflare.com/"
        echo "2. Workers & Pages → Create → Pages"
        echo "3. Connect to Git → 选择 crypto-dashboard"
        echo "4. 配置: Build command: npm run build"
        echo "5. 配置: Output directory: dist"
        echo "6. Save and Deploy"
        echo ""
        echo "等待 1-2 分钟，然后访问:"
        echo "  🌐 https://$REPO_NAME.pages.dev"
        echo ""
        echo "=========================================="
    else
        echo ""
        echo "❌ 推送失败"
        echo ""
        echo "查看日志: cat /tmp/git-push.log"
        exit 1
    fi

else
    echo "❌ API 请求失败"
    echo ""
    echo "$response" | python3 -m json.tool 2>/dev/null || echo "$response"
    exit 1
fi
