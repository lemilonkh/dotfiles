return {
  "vuki656/package-info.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  init = function()
    require("package-info").setup()
  end,
}
