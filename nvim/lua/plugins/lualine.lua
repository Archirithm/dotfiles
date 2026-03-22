return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy", -- 懒加载，不拖慢启动页速度
  init = function()
    -- 在 lualine 加载前防止状态栏闪烁
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- 恢复之前的全局状态栏设置 (我们在 options.lua 里设置的 3)
    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        theme = "auto", -- 直接使用你安装的主题
        globalstatus = true,  -- 开启全局唯一状态栏
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" }, -- 使用圆润的边缘过渡 (Kitty 完美支持)
        disabled_filetypes = { 
          statusline = { "dashboard", "lazy" } -- 在启动页和包管理器界面隐藏状态栏
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diagnostics", -- 原生错误诊断提示
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { 
            "filename", 
            path = 1, -- 0: 仅文件名, 1: 相对路径, 2: 绝对路径
            symbols = { modified = "  ", readonly = "  ", unnamed = "[No Name]" }
          },
        },
        lualine_x = {
          -- 简单的 Git 差异显示
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy" },
    }
  end,
}
