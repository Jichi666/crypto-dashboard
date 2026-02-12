#!/bin/bash

# GitHub + Cloudflare Pages 自动部署脚本

set -e

PROJECT_DIR="/root/.openclaw/workspace/crypto-dashboard"
cd "$PROJECT_DIR"

echo "======================================"
echo "🚀 Crypto Dashboard 自动部署"
echo "======================================"
echo ""

# 检查必要的工具
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "⚠️  $1 未安装"
    else
        echo "✅ $1 已安装"
    fi
}

echo "检查工具:"
check_tool "git"
check_tool "node"
check_tool "npm"
echo ""

# 检查项目构建
echo "检查构建状态:"
if [ -d "dist" ]; then
    echo "✅ dist/ 目录存在"
    echo "   - index.html: $(du -h dist/index.html | cut -f1)"
else
    echo "⚠️  dist/ 不存在，正在构建..."
    npm run build
fi
echo ""

# Git 检查
echo "Git 仓库状态:"
git_status=$(git status --porcelain 2>&1 || echo "not initialized")
if [ "$git_status" = "not initialized" ]; then
    echo "⚠️  Git 仓库未初始化"
    exit 1
else
    echo "✅ Git 仓库已初始化"
    echo "   最后提交: $(git log -1 --oneline)"
    echo "   分支: $(git rev-parse --abbrev-ref HEAD)"
fi
echo ""

# 创建部署清单
echo "======================================"
echo "📋 部署清单"
echo "======================================"
echo ""

cat << 'EOF'
步骤 1: 生成 GitHub Token
────────────────────────────────────
1. 访问: https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 勾选权限: repo (代码库完全访问)
4. 点击 "Generate token"
5. 复制生成的 Token（只显示一次）

步骤 2: 推送代码到 GitHub
────────────────────────────────────
创建仓库后，在下方推送代码。

步骤 3: 连接 Cloudflare Pages
────────────────────────────────────
1. 访问: https://dash.cloudflare.com/
2. Workers & Pages → Create → Pages
3. 选择 "Connect to Git"
4. 连接 GitHub（引导式）
5. 选择 crypto-dashboard 仓库
6. 配置:
   - Build command: npm run build
   - Output directory: dist
7. Save and Deploy

完成后访问: https://crypto-dashboard.pages.dev
EOF

echo ""
echo ""

# 尝试自动设置
echo "======================================"
echo "开始自动设置"
echo "======================================"
echo ""

read -p "请输入你的 GitHub 用户名: " github_user

if [ -z "$github_user" ]; then
    echo "❌ 必须提供 GitHub 用户名"
    exit 1
fi

repo_name="crypto-dashboard"
repo_url="https://github.com/$github_user/$repo_name.git"

echo ""
echo "目标仓库: $repo_url"
echo ""

# 询问 Token
read -p "是否已生成 GitHub Token? (y/n): " has_token

if [ "$has_token" = "y" ]; then
    read -p "请粘贴你的 GitHub Token: " token

    if [ -z "$token" ]; then
        echo "❌ Token 不能为空"
        exit 1
    fi

    # 使用 Token 配置远程仓库
    echo ""
    echo "配置远程仓库..."
    if git remote -v | grep -q "github"; then
        git remote set-url origin "https://$token@github.com/$github_user/$repo_name.git"
    else
        git remote add origin "https://$token@github.com/$github_user/$repo_name.git"
    fi

    echo "✅ 远程仓库已配置（使用 Token 认证）"
fi

# 确保在 main 分支
echo ""
echo "设置分支为 main..."
git branch -M main || git checkout -b main
echo "✅ 分支已设置"

# 推送代码
echo ""
echo "推送到 GitHub..."
if git push -u origin main 2>&1; then
    echo "✅ 推送成功！"
    echo ""
    echo "访问仓库: https://github.com/$github_user/$repo_name"
else
    echo "❌ 推送失败"
    echo ""
    echo "可能的原因:"
    echo "1. GitHub Token 无效或过期"
    echo "2. 仓库已存在但无权限"
    echo "3. 网络问题"
    echo ""
    echo "请检查并重试，或手动推送:"
    echo "  git push -u origin main"
    exit 1
fi

echo ""
echo "======================================"
echo "🎉 第一步完成！"
echo "======================================"
echo ""
echo "代码已成功推送到 GitHub"
echo ""
echo "现在进入 Cloudflare 完成部署:"
echo ""
echo "1. 打开浏览器访问:"
echo "   https://dash.cloudflare.com/"
echo ""
echo "2. 进入: Workers & Pages → Create → Pages"
echo ""
echo "3. 选择 'Connect to Git'"
echo ""
echo "4. 授权 GitHub 并选择 $repo_name 仓库"
echo ""
echo "5. 配置:"
echo "   - Build command: npm run build"
echo "   - Build output directory: dist"
echo ""
echo "6. Save and Deploy"
echo ""
echo "等待 1-2 分钟，然后访问:"
echo "   https://$repo_name.pages.dev"
echo ""
echo "======================================"
