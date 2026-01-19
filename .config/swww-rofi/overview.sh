#壁纸路径
WALLPAPER=$(swww query | head -n1 | grep -oP 'image: \K.*')

CACHE_DIR="$HOME/.cache/wallpaper_blur"
mkdir -p "$CACHE_DIR"

# 获取文件名并定义输出路径
FILENAME=$(basename "$WALLPAPER")
BLURRED_WALLPAPER="$CACHE_DIR/blurred_$FILENAME"

#如果没有模糊壁纸缓存则生成
if [[ ! -f "$BLURRED_WALLPAPER" ]]; then
  magick "$WALLPAPER" -blur 0x15 -fill black -colorize 40% "$BLURRED_WALLPAPER"
fi

swww img -n overview "$BLURRED_WALLPAPER" \
  --transition-type fade \
  --transition-duration 0.5

CACHE_ROFI="$HOME/.cache/wallpaper_rofi"
mkdir -p "$CACHE_ROFI"
cp -f "$WALLPAPER" "$CACHE_ROFI/current" || true
cp -f "$BLURRED_WALLPAPER" "$CACHE_ROFI/blurred" || true
