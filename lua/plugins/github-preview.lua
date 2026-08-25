return {
  "wallpants/github-preview.nvim",
  cmd = { "GithubPreviewToggle" },
  keys = {
    {
      "<leader>mpt",
      function()
        require("github-preview").fns.toggle()
      end,
      desc = "Toggle GitHub preview",
    },
    {
      "<leader>mps",
      function()
        require("github-preview").fns.single_file_toggle()
      end,
      desc = "Toggle single-file preview",
    },
    {
      "<leader>mpd",
      function()
        require("github-preview").fns.details_tags_toggle()
      end,
      desc = "Toggle preview details",
    },
  },
  opts = {
    single_file = true,
  },
}
