#!/bin/bash

# Crypto Dashboard 自动部署执行脚本

set -e

PROJECT_DIR="/root/.openclaw/workspace/crypto-dashboard"
cd "$PROJECT_DIR"

echo "=========================================="
echo "🚀 Crypto Dashboard 自动部署执行"
echo "=========================================="
echo ""

# 第一步：检查项目状态
echo "📊 检查项目状态..."
if [ -d "dist" ]; then
    echo "✅ 构建文件存在"
else
    echo "⚠️  需要先构建"
    npm run build
fi

echo "✅ Git 仓库已准备"
echo "   当前版本: $(git log -1 --oneline)"
echo ""

# 第二步：检查是否已配置 GitHub Token
if [ -n "$GITHUB_TOKEN" ]; then
    echo "✅ 检测到 GITHUB_TOKEN 环境变量"
    USE_TOKEN=true
elif [ -n "$GH_TOKEN" ]; then
    echo "✅ 检测到 GH_TOKEN 环境变量"
    export GITHUB_TOKEN="$GH_TOKEN"
    USE_TOKEN=true
else
    echo "⚠️  未检测到 GitHub Token"
    echo ""
    echo "设置 GitHub Token（3种方式）："
    echo ""
    echo "方式 1: 环境变量"
    echo "  export GITHUB_TOKEN=your_token_here"
    echo ""
    echo "方式 2: .env 文件"
    echo "  echo GITHUB_TOKEN=your_token > .env"
    echo ""
    echo "方式 3: 输入 Token"
    export USE_TOKEN=false
fi
echo ""

# 第三步：获取 GitHub 信息
echo "📝 配置 GitHub 仓库..."

if [ -z "$GITHUB_USERNAME" ] && [ -z "$GH_USERNAME" ]; then
    read -p "请输入 GitHub 用户名: " github_user
else
    github_user="${GITHUB_USERNAME:-$GH_USERNAME}"
    echo "✅ 使用用户名: $github_user"
fi

REPO_NAME="crypto-dashboard"
REPO_URL="https://github.com/$github_user/$REPO_NAME.git"

echo "目标仓库: $REPO_URL"
echo ""

# 第四步：配置 Git 远程仓库
if git remote -v | grep -q "$REPO_URL"; then
    echo "✅ 远程仓库已配置"
elif [ "$USE_TOKEN" = true ]; then
    # 使用 Token
    TOKEN_URL="https://$GITHUB_TOKEN@github.com/$github_user/$REPO_NAME.git"
    if git remote -v | grep -q "github"; then
        git remote set-url origin "$TOKEN_URL"
    else
        git remote add origin "$TOKEN_URL"
    fi
    echo "✅ 已配置远程仓库（使用 Token）"
else
    # 不使用 Token，使用 HTTPS（稍后会提示认证）
    if git remote -v | grep -q "github"; then
        git remote set-url origin "$REPO_URL"
    else
        git remote add origin "$REPO_URL"
    fi
    echo "✅ 已配置远程仓库"
fi

# 第五步：确保在 main 分支
if [ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]; then
    echo "🔄 切换到 main 分支..."
    git checkout -b main 2>/dev/null || git checkout main
fi
echo "✅ 当前分支: main"
echo ""

# 第六步：尝试推送
echo "=========================================="
echo "📤 推送代码到 GitHub"
echo "=========================================="
echo ""

if [ "$USE_TOKEN" = true ]; then
    echo "使用 Token 推送..."
    if git push -u origin main 2>&1 | tee /tmp/git-push.log; then
        echo ""
        echo "✅ 推送成功！"
        PUSH_SUCCESS=true
    else
        echo ""
        echo "❌ 推送失败，请检查："
        echo "   - GitHub Token 是否有效"
        echo "   - Token 是否有 repo 权限"
        echo "   - 用户名是否正确"
        echo ""
        cat /tmp/git-push.log
        PUSH_SUCCESS=false
    fi
else
    echo "尝试推送（可能需要交互式认证）..."
    if git push -u origin main 2>&1 | tee /tmp/git-push.log; then
        echo ""
        echo "✅ 推送成功！"
        PUSH_SUCCESS=true
    else
        echo ""
        echo "⚠️  推送过程中可能需要认证"
        echo ""
        cat /tmp/git-push.log

        read -p "是否使用 Token 重试? (y/n): " retry_with_token
        if [ "$retry_with_token" = "y" ]; then
            read -p "请输入 GitHub Token: " token
            export GITHUB_TOKEN="$token"

            # 重新配置远程
            TOKEN_URL="https://$GITHUB_TOKEN@github.com/$github_user/$REPO_NAME.git"
            git remote set-url origin "$TOKEN_URL"

            echo ""
            echo "重试推送..."
            if git push -u origin main 2>&1; then
                echo "✅ 推送成功！"
                PUSH_SUCCESS=true
            else
                echo "❌ 推送仍然失败"
                PUSH_SUCCESS=false
            fi
        else
            PUSH_SUCCESS=false
        fi
    fi
fi

echo ""

# 第七步：后续步骤
if [ "$PUSH_SUCCESS" = true ]; then
    echo "=========================================="
    echo "🎉 第一步完成！"
    echo "=========================================="
    echo ""
    echo "代码已成功推送到 GitHub:"
    echo "  仓库: https://github.com/$github_user/$REPO_NAME"
    echo ""

    echo "现在进入 Cloudflare 完成部署："
    echo ""
    echo "1. 打开浏览器访问:"
    echo "   https://dash.cloudflare.com/"
    echo ""
    echo "2. 进入: Workers & Pages → Create application"
    echo ""
    echo "3. 选择: Pages"
    echo ""
    echo "4. 选择: Connect to Git"
    echo ""
    echo "5. 授权 GitHub 并选择 $REPO_NAME 仓库"
    echo ""
    echo "6. 配置构建设置:"
    echo "   - Framework: Vite"
    echo "   - Build command: npm run build"
    echo "   - Build output directory: dist"
    echo ""
    echo "7. 点击: Save and Deploy"
    echo ""
    echo "等待 1-2 分钟，然后访问:"
    echo "  🌐 https://$REPO_NAME.pages.dev"
    echo ""
    echo "=========================================="
else
    echo "=========================================="
    echo "⚠️  推送失败"
    echo "=========================================="
    echo ""
    echo "选项 1: 使用 GitHub Token 重试"
    echo "  export GITHUB_TOKEN=your_token"
    echo "  $0"
    echo ""
    echo "选项 2: 手动推送"
    echo "  cd $PROJECT_DIR"
    echo "  git push -u origin main"
    echo ""
    echo "选项 3: 使用 Git Bundle（本地操作）"
    echo "  scp crypto-dashboard.bundle localhost:/tmp/"
    echo "  git clone crypto-dashboard.bundle crypto-dashboard"
    echo "  cd crypto-dashboard && git push"
    echo ""
fi

echo ""
echo "项目日志: /tmp/git-push.log"
echo ""
