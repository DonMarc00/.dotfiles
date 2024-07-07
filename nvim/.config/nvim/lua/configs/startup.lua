
-- lua/configs/startup.lua
require("startup").setup({
  section_1 = {
    type = "text",
    content = {
      
"██████╗  ██████╗ ███╗   ██╗███╗   ███╗ █████╗ ██████╗  ██████╗ ██████╗ ",
"██╔══██╗██╔═══██╗████╗  ██║████╗ ████║██╔══██╗██╔══██╗██╔════╝██╔═████╗",
"██║  ██║██║   ██║██╔██╗ ██║██╔████╔██║███████║██████╔╝██║     ██║██╔██║",
"██║  ██║██║   ██║██║╚██╗██║██║╚██╔╝██║██╔══██║██╔══██╗██║     ████╔╝██║",
"██████╔╝╚██████╔╝██║ ╚████║██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╗╚██████╔╝",
"╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ",
    },
    align = "center", -- explicitly set alignment
    highlight = "Statement",
    default_color = "",
    oldfiles_amount = 0,
  },
  section_2 = {
    type = "mapping",
    content ={
            { " Find File", "Telescope find_files", "<leader>ff" },
            { "󰍉 Find Word", "Telescope live_grep", "<leader>lg" },
            { " Recent Files", "Telescope oldfiles", "<leader>of" },
            { " File Browser", "Telescope file_browser", "<leader>fb" },
            { " Colorschemes", "Telescope colorscheme", "<leader>cs" },
            { " New File", "lua require'startup'.new_file()", "<leader>nf" },
        },    align = "center", -- explicitly set alignment
    highlight = "String",
    default_color = "",
    oldfiles_amount = 0,
  },
  options = {
      mapping_keys = true, -- display mapping (e.g. <leader>ff)
      cursor_column = 0.5,
      after = function() -- function that gets executed at the end
        -- Add any additional setup or commands here
      end,
      empty_lines_between_mappings = true, -- add an empty line between mapping/commands
      disable_statuslines = true, -- disable status-, buffer- and tablines
      paddings = {1, 2}, -- amount of empty lines before each section (must be equal to amount of sections)
  },
  mappings = {
    execute_command = "<CR>",
    open_file = "o",
    open_file_split = "<c-o>",
    open_section = "<TAB>",
    open_help = "?",
  },
  colors = {
    background = "#1f2227",
    folded_section = "#56b6c2", -- the color of folded sections
  },
  parts = {"section_1", "section_2"} -- all sections in order
})

