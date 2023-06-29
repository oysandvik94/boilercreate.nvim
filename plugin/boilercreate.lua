if vim.g.boilercreate then
    return
end
vim.g.boilercreate = true

local boilercreate = require("boilercreate")


vim.api.nvim_create_user_command('BClass',
    function(opts)
        boilercreate.createClass(opts.args)
    end
    , { nargs = 1 }
)
