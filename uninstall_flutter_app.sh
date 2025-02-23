#!/bin/bash

if [ "$EUID" -ne 0 ]; then 
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

echo "卸载 Fig 应用..."

# 停止并禁用服务
systemctl stop fig-app
systemctl disable fig-app
rm -f /etc/systemd/system/fig-app.service
systemctl daemon-reload

# 删除应用文件
rm -rf /usr/local/fig-app
rm -f /usr/local/bin/start-fig-app

echo "卸载完成！" 