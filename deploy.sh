#!/bin/bash

# Crypto Dashboard - 一键部署助手

set -e

REPO_NAME="crypto-dashboard"
GITHUB_USERNAME="$GITHUB_USERNAME"  # 设置此环境变量或手动输入

echo "======================================"
echo "🚀 Crypto Dashboard 一键部署"
echo "======================================"
echo ""

# 检查 Git 仓库
if [ ! -d "/root/.openclaw/workspace/crypto-dashboard/.git" ]; then
    echo "❌ Git 仓库未初始化"
    exit 1
fi

echo "✅ Git 仓库已就绪"
echo ""

# 检查远程仓库
echo "📂 Git 远程仓库状态:"
git remote -v 2>/dev/null || echo "  ⚠️  未配置远程仓库"
echo ""

if git remote -v 2>/dev/null | grep -q "github"; then
    echo "✅ 已连接到 GitHub 仓库"

    echo ""
    read -p "是否立即推送到 GitHub? (y/n): " push_now

    if [ "$push_now" = "y" ]; then
        echo ""
        echo "📦 推送代码到 GitHub..."
        git push origin main 2>/dev/null || {
            echo "❌ 推送失败，请检查 GitHub Token"
            exit 1
        }
        echo "✅ 代码已推送到 GitHub"
    fi
else
    echo ""
    echo "⚠️  需要先配置 GitHub 仓库"
    echo ""
    echo "步骤如下："
    echo ""
    echo "1. 创建 GitHub 仓库:"
    echo "   访问: https://github.com/new"
    echo "   仓库名: $REPO_NAME"
    echo "   不要勾选 'Initialize with README'"
    echo ""

    # 询问 GitHub 用户名
    if [ -z "$GITHUB_USERNAME" ]; then
        read -p "请输入你的 GitHub 用户名: " github_user
    else
        github_user="$GITHUB_USERNAME"
    fi

    # 添加远程仓库
    echo ""
    echo "连接到 GitHub..."
    git remote add origin "https://github.com/$github_user/$REPO_NAME.git"
    git branch -M main

    echo ""
    echo "✅ 远程仓库已配置"
    echo ""
    echo "2. 推送代码（需要 GitHub Token）:"
    echo ""
    echo "请先访问: https://github.com/settings/tokens"
    echo "生成访问 Token（Personal Access Token）"
    echo "勾选 'repo' 权限"
    echo "然后运行:"
    echo ""
    echo "  export GITHUB_TOKEN=your_token_here"
    echo '  git remote set-url origin https://$GITHUB_TOKEN@github.com/$github_user/crypto-dashboard.git'
    echo "  git push -u origin main"
    echo ""

    read -p "现在就推送吗? (y/n): " push_now

    if [ "$push_now" = "y" ]; then
        read -p "请输入你的 GitHub Token: " github_token

        # 设置远程使用 token
        git remote set-url origin "https://$github_token@github.com/$github_user/$REPO_NAME.git"

        # 推送
        echo ""
        echo "推送中..."
        if git push -u origin main 2>&1; then
            echo "✅ 推送成功！"
        else
            echo "❌ 推送失败，请检查 Token"
            read -p "重试推送吗? (y/n): " retry
            if [ "$retry" = "y" ]; then
                read -p "再次输入 GitHub Token: " github_token
                git remote set-url origin "https://$github_token@github.com/$github_user/$REPO_NAME.git"
                git push -u origin main || {
                    echo "❌ 仍然失败，请检查网络和 Token"
                }
            fi
        fi
    fi
fi

echo ""
echo "======================================"
echo "下一步：连接 Cloudflare Pages"
echo "======================================"
echo ""
echo "代码已推送到 GitHub，现在连接 Cloudflare："
echo ""
echo "1. 访问 Cloudflare: https://dash.cloudflare.com/"
echo ""
echo "2. 进入: Workers & Pages → Create application"
echo ""
echo "3. 选择 Pages → Connect to Git"
echo ""
echo "4. 选择 '$REPO_NAME' 仓库"
echo ""
echo "5. 配置构建设置:"
echo "   - Build command: npm run build"
echo "   - Build output directory: dist"
echo ""
echo "6. 点击 'Save and Deploy'"
echo ""
echo "等待 1-2 分钟，访问链接："
echo "  🌐 https://$REPO_NAME.pages.dev"
echo ""
echo "======================================"
echo "详细指南: cat DEPLOY-GITHUB.md"
echo "======================================"

# 显示项目信息
echo ""
echo "📊 项目信息:"
echo "  仓库: github.com/$github_user/$REPO_NAME"
echo "  最后提交: $(git log -1 --oneline)"
echo "  文件数: $(git ls-files | wc -l)"
echo ""
