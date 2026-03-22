return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify", -- 引入极其优雅的右上角通知弹窗
  },
  opts = {
    lsp = {
      -- 覆盖底层 LSP 渲染，让文档悬浮窗变得极其美观
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = { enabled = true },
      signature = { enabled = true },
    },
    presets = {
      bottom_search = false,        -- 禁用底部经典搜索，改用居中悬浮窗
      command_palette = true,       -- 开启 VS Code 风格的中央命令面板
      long_message_to_split = true, -- 超长的报错信息自动放进分屏阅读
      lsp_doc_border = true,        -- 给 LSP 悬浮文档加上边框 (契合你的圆角风格)
    },
    -- 消息通知配置
    messages = {
      enabled = true,
      view = "notify",              -- 默认将消息路由到右上角通知弹窗
      view_warn = "notify",
      view_error = "notify",
    },
  },
  keys = {
    { "<leader>nh", "<cmd>Noice history<cr>", desc = "历史通知 (Noice)" },
    { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "关闭所有通知" },
  }
}
