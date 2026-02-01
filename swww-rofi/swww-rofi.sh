#!/usr/bin/env bash

set -euo pipefail

# 配置
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/.config/wallpaper}"
ROFI_THEME="${ROFI_THEME:-$HOME/.config/swww-rofi/wallpaper_2_line.rasi}"

# 启动 swww 守护进程
if ! pgrep -x "swww-daemon" >/dev/null 2>&1; then
    swww-daemon >/dev/null 2>&1 &
    sleep 0.25
fi

# 收集壁纸
mapfile -t WALLS < <(find -L "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort)
[ ${#WALLS[@]} -eq 0 ] && { rofi -e "在 $WALLPAPER_DIR 中未找到壁纸"; exit 1; }

# 构建 rofi 菜单 - 直接使用原始图片作为图标
MENU_ITEMS=""
for wp in "${WALLS[@]}"; do
    name=$(basename "$wp")
    MENU_ITEMS+="$name\0icon\x1f$wp\n"
done

# 显示 rofi 菜单
ROFI_CMD=(rofi -dmenu -p "选择壁纸" -show-icons)

if [ -n "$ROFI_THEME" ]; then
    ROFI_CMD+=(-theme "$ROFI_THEME")
fi

CHOICE=$(printf '%b' "$MENU_ITEMS" | "${ROFI_CMD[@]}")

[ -z "$CHOICE" ] && exit 0

# 找到对应完整路径
SELECTED=""
for wp in "${WALLS[@]}"; do
    if [ "$(basename "$wp")" = "$CHOICE" ]; then
        SELECTED="$wp"
        break
    fi
done

if [ -z "$SELECTED" ]; then
    echo "错误: 未找到对应的壁纸文件" >&2
    exit 1
fi



# 切换壁纸
swww img "$SELECTED" \
    --transition-type "any" \
    --transition-duration 3 \
    --transition-fps 60 \
    --transition-bezier .43,1.19,1,.4

#提取颜色
matugen image "$SELECTED"
bash /home/archirithm/.config/swww-rofi/overview.sh
# 发送通知
if command -v notify-send >/dev/null 2>&1; then
    notify-send "壁纸已切换" "$(basename "$SELECTED")" -i "$SELECTED"
fi
