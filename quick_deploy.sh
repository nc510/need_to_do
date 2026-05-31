#!/usr/bin/env bash

# ================================================================================
# 快速部署脚本 - 推送代码并触发 CI/CD
# ================================================================================

echo ""
echo "================================================"
echo "        在线考试系统 - CI/CD 部署"
echo "================================================"
echo ""

# 检查是否有未提交的更改
if [[ -n $(git status --porcelain) ]]; then
    echo "[INFO] 发现未提交的更改，正在提交..."
    git add .
    git commit -m "更新配置：$(date '+%Y-%m-%d %H:%M:%S')"
fi

# 推送到 GitHub
echo "[INFO] 推送代码到 GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "         ✅ 推送成功！"
    echo "================================================"
    echo ""
    echo "CI/CD 流程已触发，请查看："
    echo "  https://github.com/nc510/need_to_do/actions"
    echo ""
    echo "Railway 部署状态："
    echo "  https://railway.app"
    echo ""
else
    echo "[ERROR] 推送失败，请检查网络连接或权限"
    exit 1
fi