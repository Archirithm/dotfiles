return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" }, -- 只有打开实际文件时才加载，提升启动速度
  config = function()
    -- 1. 定义你需要安装的语言列表 (加入 js 和 qmljs)
    local parsers = {
      "c", "cpp", "python", "lua", "bash", "markdown", 
      "javascript", "qmljs" 
    }

    -- 2. 异步安装缺失的解析器 (模拟旧版 ensure_installed 的效果)
    vim.defer_fn(function()
      require("nvim-treesitter").install(parsers)
    end, 0)

    -- 3. 核心机制：大文件保护 (借鉴自你找的开源代码，并做了现代化升级)
    local function is_large_file(buf)
      local max_filesize = 100 * 1024 -- 设定阈值为 100 KB
      -- 使用最新的 vim.uv 替代旧版的 vim.loop
      local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
      return ok and stats and stats.size > max_filesize
    end

    -- 4. 彻底拥抱 main 分支：使用 Neovim 原生 API 挂载高亮
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("my_native_treesitter", { clear = true }),
      callback = function(ev)
        -- 安全检查：如果是大文件，直接退出，保平安
        if is_large_file(ev.buf) then
          return
        end

        -- 尝试调用 Neovim 原生机制启动语法高亮
        pcall(vim.treesitter.start, ev.buf)

        -- 顺手开启基于语法树的高级代码折叠 (极其好用)
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
