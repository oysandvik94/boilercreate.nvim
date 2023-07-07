local M = {}

function M.createClass()
    local workspacePath = vim.api.nvim_call_function("getcwd", {})
    local currentBufferPath = vim.api.nvim_call_function("expand", { "%:p" })

    -- oil.nvim changes the buffer path with a prefix, so remove
    -- this to allow creating files from oil
    currentBufferPath = currentBufferPath:gsub("oil://", "")


    local namespace = currentBufferPath:gsub(workspacePath, '')
    namespace = namespace:gsub("/", ".")
    namespace = namespace:gsub(vim.api.nvim_buf_get_name(0), "")
    namespace = namespace:gsub("^%.", "")

    local className = vim.api.nvim_buf_get_name(0):gsub(".cs", "")
    vim.api.nvim_command(string.format("put ='namespace %s;\n\n'", namespace))
    vim.api.nvim_command(string.format("put ='public class %s\n{\n\n}'", className))

    -- Find the opening curly brace using Vim commands
    vim.api.nvim_command("/\\v[{]")

    -- Adjust the cursor position to be between the braces
    local cursorLine, cursorCol = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { cursorLine + 1, cursorCol + 1 })
end

return M


