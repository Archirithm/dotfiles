return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = "*", 
  dependencies = {
    "nvim-lua/plenary.nvim", 
    { 
      "nvim-telescope/telescope-fzf-native.nvim", 
      build = "make" 
    },
  },
  -- 借鉴 LazyVim 的按需加载快捷键体系
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "搜索文件 (Find Files)" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "全局搜词 (Live Grep)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "切换已打开的文件 (Buffers)" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "最近打开的文件 (Recent)" },
  },
  config = function()
    local telescope = require("telescope")

    -- 核心设置与 UI 美化
    telescope.setup({
      defaults = {
        prompt_prefix = " ",   -- 借鉴 LazyVim 的现代图标
        selection_caret = " ",
      },
    })

    -- 极其重要：激活 C 语言底层的 fzf 加速引擎
    telescope.load_extension("fzf")
  end,
}
