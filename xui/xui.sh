#!/bin/bash

# Step 1: Prompt for Shadowsocks protocol link
read -p "请输入Shadowsocks协议链接： " ss_link

# Base64解析
decoded_link=$(echo "$ss_link" | sed 's/ss:\/\///' | base64 -d)

# 提取各项信息
method=$(echo "$decoded_link" | awk -F'[:@]' '{print $1}')
password=$(echo "$decoded_link" | awk -F'[:@]' '{print $2}')
address=$(echo "$decoded_link" | awk -F'[:@]' '{print $3}')
port=$(echo "$decoded_link" | awk -F'[:@]' '{print $4}')

# Step 2: 填写配置信息到v2ray.txt
cat > /root/xui/v2ray.txt << EOF
{
  "tag": "netflix_proxy",
  "protocol": "shadowsocks",
  "settings": {
    "servers": [
      {
        "address": "$address",
        "port": $port,
        "method": "$method",
        "password": "$password",
        "email": "",
        "ota": false
      }
    ]
  },
  "streamSettings": {
    "network": "tcp"
  },
  "mux": {
    "enabled": false,
    "concurrency": -1
  }
},
EOF

# Step 3: 清空旧的配置文件
> /root/xui/new_config.txt

# Step 4: 复制原始配置文件到新配置文件
cp /root/xui/original_config.txt /root/xui/new_config.txt

# Step 5: 将v2ray.txt的代码粘贴到新配置文件的第26行
sed -i '26r /root/xui/v2ray.txt' /root/xui/new_config.txt
