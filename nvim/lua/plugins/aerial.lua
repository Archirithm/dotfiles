return {
  "stevearc/aerial.nvim",
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
  -- 绑定极其顺手的全局快捷键
  keys = {
    { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "大纲视图 (Aerial)" },
    -- 联动 Telescope：在当前文件的所有函数/变量中进行模糊搜索
    { "<leader>fs", "<cmd>Telescope aerial<CR>", desc = "搜索当前文件符号 (Symbols)" },
  },
  opts = {
    -- 引擎优先级：优先使用最精准的 LSP，其次是你的 Treesitter
    backends = { "lsp", "treesitter", "markdown" },
    
    layout = {
      -- 核心设定：永远优先在屏幕右侧打开，还原 VS Code 体验
      default_direction = "prefer_right", 
      max_width = { 40, 0.2 },
      width = nil,
      min_width = 15,
    },
    
    -- 视觉反馈：在右侧大纲中，高亮指示你当前所在的函数位置
    highlight_mode = "split_width",
    
    -- 极致联动：当你在右侧大纲里上下移动光标时，左侧代码会自动实时滚动
    autojump = true,
    
    -- 当你按回车选中某个函数并跳转后，大纲面板依然保持打开状态
    close_on_select = false,
    
    -- 开启树状图的连接参考线，UI 更具层次感
    show_guides = true,
    guides = {
      mid_item = "├─",
      last_item = "└─",
      nested_top = "│ ",
      whitespace = "  ",
    },
  },
  -- 挂载 Telescope 扩展引擎的底层逻辑
  config = function(_, opts)
    require("aerial").setup(opts)
    require("telescope").load_extension("aerial")
  end,
}
