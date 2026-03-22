return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  -- 全局快捷键：按 空格+e 呼出或隐藏文件树
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
  },
  opts = {
    -- 默认显示哪些数据源
    sources = { "filesystem", "buffers", "git_status" },
    -- 文件系统配置
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { 
        enabled = true,         -- 自动定位到当前打开的文件
        leave_dirs_open = false -- 展开到目标文件后，保持其他无关目录关闭，维持整洁
      }, 
      use_libuv_file_watcher = true, -- 监听文件系统变化，自动刷新
      hijack_netrw_behavior = "open_default", -- ✨ 彻底接管 Neovim 默认的目录浏览器，防止终端打开时出现原生丑陋界面
      
      -- ✨ 核心修改区：解除所有隐藏封印
      filtered_items = {
        visible = false,         -- 保持 false，让底下的细分规则生效
        hide_dotfiles = false,   -- 永久显示以 . 开头的文件 (如 .config, .gitignore)
        hide_gitignored = false, -- 永久显示被 git 忽略的编译产物或缓存文件
        hide_hidden = false,     -- 显示系统级别的隐藏文件
      },
    },
    -- 窗口内快捷键映射 (享受 Vim 的 h/l 丝滑导航)
    window = {
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
            print("Copied: " .. path)
          end,
          desc = "Copy Path to Clipboard",
        },
      },
    },
    -- UI 图标美化
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      git_status = {
        symbols = {
          unstaged = "󰄱",
          staged = "󰱒",
        },
      },
    },
  },
}
