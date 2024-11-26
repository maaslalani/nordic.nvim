-- 'sindrets/winshift.nvim'
return function(c, s, cs)
    return {
        { { 'WinShiftNormal', 'WinShiftEndOfBuffer' }, c.none, cs.bg_normal_alt },
        { 'WinShiftLineNr', c.yellow, cs.bg_normal_alt },
        { 'WinShiftCursorLineNr', c.yellow, cs.bg_normal_alt, s.bold },
        { 'WinShiftSignColumn', c.cyan, cs.bg_normal_alt },
        { 'WinShiftWindowPicker', c.purple, c.blue, s.bold },
        { 'WinShiftFoldColumn', c.cyan, cs.bg_normal_alt },
    }
end
