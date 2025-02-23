#!/bin/bash

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then 
  echo "请使用 sudo 运行此脚本"
  exit 1
fi

# 检查是否提供了应用包路径
if [ -z "$1" ]; then
  echo "请提供应用包路径"
  echo "使用方法: $0 <fig.tar.gz>"
  exit 1
fi

APP_PACKAGE="$1"

# 检查应用包是否存在
if [ ! -f "$APP_PACKAGE" ]; then
  echo "找不到应用包: $APP_PACKAGE"
  exit 1
fi

# 设置颜色输出
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}开始安装 Flutter 应用...${NC}"

# 更新系统包
echo -e "${GREEN}更新系统包...${NC}"
apt update

# 安装最小必要的依赖
echo -e "${GREEN}安装必要的依赖...${NC}"
apt install -y libgtk-3-0 libblkid1 liblzma5 xserver-xorg-core x11-xserver-utils

# 创建应用目录
APP_DIR="/usr/local/fig-app"
echo -e "${GREEN}创建应用目录 ${APP_DIR}...${NC}"
mkdir -p "$APP_DIR"

# 解压应用文件
echo -e "${GREEN}解压应用文件...${NC}"
tar xzf "$APP_PACKAGE" -C "$APP_DIR"

# 设置权限
echo -e "${GREEN}设置权限...${NC}"
chmod +x "$APP_DIR/fig"

# 创建启动脚本
echo -e "${GREEN}创建启动脚本...${NC}"
cat > /usr/local/bin/start-fig-app << EOL
#!/bin/bash
export DISPLAY=:0
/usr/lib/xorg/Xorg :0 -quiet &
sleep 2
$APP_DIR/fig
EOL

chmod +x /usr/local/bin/start-fig-app

# 创建服务文件
echo -e "${GREEN}创建系统服务...${NC}"
cat > /etc/systemd/system/fig-app.service << EOL
[Unit]
Description=Fig Application
After=network.target

[Service]
ExecStart=/usr/local/bin/start-fig-app
Restart=always
User=root
Environment=DISPLAY=:0

[Install]
WantedBy=multi-user.target
EOL

# 启用服务
systemctl daemon-reload
systemctl enable fig-app
systemctl start fig-app

echo -e "${GREEN}安装完成！${NC}"
echo -e "${GREEN}应用已设置为系统服务并自动启动${NC}"
echo -e "使用以下命令管理服务："
echo -e "  启动: ${GREEN}sudo systemctl start fig-app${NC}"
echo -e "  停止: ${GREEN}sudo systemctl stop fig-app${NC}"
echo -e "  重启: ${GREEN}sudo systemctl restart fig-app${NC}"
echo -e "  状态: ${GREEN}sudo systemctl status fig-app${NC}" 