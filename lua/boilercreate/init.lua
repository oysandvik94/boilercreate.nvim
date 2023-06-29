local M = {}

function M.createClass(fileName)
    local workspacePath = vim.api.nvim_call_function("getcwd", {})
    local currentBufferPath = vim.api.nvim_call_function("expand", { "%:p:h" })

    -- oil.nvim changes the buffer path with a prefix, so remove
    -- this to allow creating files from oil
    currentBufferPath = currentBufferPath:gsub("oil://", "")


    local namespace = currentBufferPath:gsub(workspacePath, '')
    namespace = namespace:gsub("/", ".")
    namespace = namespace:gsub(fileName, "")
    namespace = namespace:gsub("^%.", "")

    local filePath = currentBufferPath .. "/" .. fileName
    local file, err = io.open(filePath, "w")

    if not file then
        print("Error opening file: " .. err)
        return
    end

    local className = fileName:gsub(".cs", "")
    file:write(string.format("namespace %s;\n\n", namespace))
    file:write(string.format("public class %s\n{\n\n}", className))
    file:close()

    vim.api.nvim_command("e " .. filePath)

    -- Find the opening curly brace using Vim commands
    vim.api.nvim_command("/\\v[{]")

    -- Adjust the cursor position to be between the braces
    local cursorLine, cursorCol = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_win_set_cursor(0, { cursorLine + 1, cursorCol + 1 })
end

return M
