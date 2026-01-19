return {
  -- 添加 catppuccin 插件
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha", -- 可选: latte, frappe, macchiato, mocha
      transparent_background = false, -- 如果想要透明背景改为 true
      integrations = {
        telescope = true,
        treesitter = true,
        notify = true,
        mini = true,
        -- 更多插件集成可参考官方文档
      },
    },
  },

  -- 告诉 LazyVim 使用这个主题
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

