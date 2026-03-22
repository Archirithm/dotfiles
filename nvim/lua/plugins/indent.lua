return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "VeryLazy", 
  opts = {
    indent = {
      char = "│", 
      tab_char = "│", 
    },
    scope = {
      enabled = true,
      show_start = false, 
      show_end = false,   
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
      },
    },
  },
}
