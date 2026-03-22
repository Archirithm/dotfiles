return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" }, 
  opts = {
    user_default_options = {
      mode = "background",
      names = false,
      -- 你甚至可以开启 CSS 变量的支持，比如 var(--bg-color)
      css_fn = true, 
    },
  },
}
