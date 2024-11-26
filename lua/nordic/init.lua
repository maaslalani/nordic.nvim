local palette = require('nordic.palette')
local load_colors = require('nordic.colors')
local vim = vim
local M = {}

local default_opts = {
    underline_option = 'none',
    italic = true,
    italic_comments = false,
    minimal_mode = false,
    alternate_backgrounds = false,
    transparent_backgrounds = false,
    custom_colors = function()
        return {}
    end,
}

local style_names = {
    'bold',
    'underline',
    'italic',
    'undercurl',
    'strikethrough',
    'reverse',
    'inverse',
    'standout',
    'nocombine',
    'underdash',
    'underdot',
    'underlineline',
}

local alternate_buffers_supported = {
    'terminal',
    'qf',
    'vista_kind',
    'packer',
}

local alternate_highlights_supported = {
    'nvim-tree',
    'telescope',
    'whichkey',
}

local function create_options(config)
    local module_opts = {}
    local global_opts = {}

    for k in pairs(default_opts) do
        module_opts[k] = config[k]
        global_opts[k] = vim.g['nord_' .. k]
    end

    return vim.tbl_extend('force', default_opts, global_opts, module_opts)
end

local function create_alternatives(options)
    local buffers = {}
    local extensions = {}

    local function filter(check)
        return vim.tbl_filter(function(value)
            return vim.tbl_contains(check, value)
        end, options.alternate_backgrounds)
    end

    if options.alternate_backgrounds == true then
        buffers = alternate_buffers_supported
        extensions = alternate_highlights_supported
    elseif type(options.alternate_backgrounds) == 'table' then
        buffers = filter(alternate_buffers_supported)
        extensions = filter(alternate_highlights_supported)
    end

    return { buffers = buffers, extensions = extensions }
end

local function create_arguments(options, alternatives)
    local s = {}
    for _, v in pairs(style_names) do
        s[v] = v
    end

    local cs = {
        underline = options.underline_option and s[options.underline_option] or s.none,
        italic = (options.italic == true or options.italic == nil) and s.italic or s.none,
        comments = options.italic_comments and s.italic or s.none,
        bg_normal = options.transparent_backgrounds == false and palette.dark_black or s.none,
        bg_normal_alt = options.transparent_backgrounds == false and palette.dark_black_alt or s.none,
        bg = function(name)
            if options.transparent_backgrounds then
                return s.none
            end
            local found = vim.tbl_contains(alternatives.extensions, name)
            return found and palette.dark_black_alt or palette.dark_black
        end,
    }

    return { palette, s, cs, options }
end

local function initialize(config)
    local options = create_options(config)
    local alternatives = create_alternatives(options)
    local arguments = create_arguments(options, alternatives)
    local groups = load_colors()

    if type(options.custom_colors) == 'function' then
        table.insert(groups, options.custom_colors)
    end

    local function load_group(list)
        for _, group in ipairs(list) do
            if type(group) == 'function' then
                load_group(group(unpack(arguments)))
            elseif type(group[1]) == 'table' then
                load_group(vim.tbl_map(function(highlight)
                    return { highlight, group[2], group[3], group[4] }
                end, group[1]))
            else
                -- TODO: Support multiple options here.
                if type(vim.api.nvim_set_hl) == 'function' then
                    local def = {
                        fg = group[2] or 'NONE',
                        bg = group[3] or 'NONE',
                        sp = group[5] or 'NONE',
                    }

                    if group[4] then
                        def[group[4]] = true
                    end

                    vim.api.nvim_set_hl(0, group[1], def)
                else
                    vim.highlight.create(group[1], {
                        guifg = group[2] or 'NONE',
                        guibg = group[3] or 'NONE',
                        gui = group[4] or 'NONE',
                        guisp = group[5] or 'NONE',
                    })
                end
            end
        end
    end

    -- Thanks https://github.com/folke/tokyonight.nvim
    local function load_autocommands()
        local setlocal = 'setlocal winhighlight=Normal:NormalAlt,SignColumn:SignColumnAlt'

        vim.cmd('augroup nordic')
        vim.cmd('autocmd!')
        vim.cmd([[autocmd ColorScheme * lua require('nordic').destroy()]])

        for _, name in ipairs(alternatives.buffers) do
            if name == 'terminal' then
                vim.cmd('autocmd TermOpen * ' .. setlocal)
            else
                vim.cmd('autocmd FileType ' .. name .. ' ' .. setlocal)
            end
        end

        vim.cmd('augroup end')
    end

    load_group(groups)
    load_autocommands()
end

function M.destroy()
    if vim.g.colors_name ~= 'nordic' then
        vim.cmd('autocmd! nordic')
        vim.cmd('augroup! nordic')
    end
end

function M.colorscheme(config)
    vim.o.termguicolors = true
    vim.g.colors_name = 'nordic'
    vim.g.terminal_color_0 = palette.black
    vim.g.terminal_color_1 = palette.red
    vim.g.terminal_color_2 = palette.green
    vim.g.terminal_color_3 = palette.yellow
    vim.g.terminal_color_4 = palette.blue
    vim.g.terminal_color_5 = palette.purple
    vim.g.terminal_color_6 = palette.bright_cyan
    vim.g.terminal_color_7 = palette.white
    vim.g.terminal_color_8 = palette.gray
    vim.g.terminal_color_9 = palette.red
    vim.g.terminal_color_10 = palette.green
    vim.g.terminal_color_11 = palette.yellow
    vim.g.terminal_color_12 = palette.blue
    vim.g.terminal_color_13 = palette.purple
    vim.g.terminal_color_14 = palette.cyan
    vim.g.terminal_color_15 = palette.bright_white

    initialize(config or {})
end

return M
