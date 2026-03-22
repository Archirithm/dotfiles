return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- 保持最高优先级
    opts = {
      -- 保留 LSP 诊断的漂亮波浪线
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      -- 开启你目前/未来会用到的插件 UI 整合
      integrations = {
        cmp = true,             -- 代码补全
        blink_cmp = true,
        dashboard = true,       -- 启动页
        gitsigns = true,        -- Git 提示
        illuminate = true,      -- 相同单词高亮
        indent_blankline = { enabled = true }, -- 缩进线
        mason = true,           -- LSP 包管理器
        native_lsp = { enabled = true },       -- 原生 LSP
        noice = true,           -- 消息弹窗
        telescope = true,       -- 搜索器
        treesitter = true,      -- 语法高亮
        which_key = true,       -- 快捷键提示
      },
    },
    config = function(_, opts)
      -- 先把上面的 opts 配置喂给 catppuccin
      require("catppuccin").setup(opts)
      -- 然后启动主题
      vim.cmd.colorscheme("catppuccin")
    end,
  }
}
