local M = {}

local daily_notes_dir = vim.fn.expand("~/Desktop/obsidian/works/daily")

function M.get_yesterday_todos()
    local yesterday = os.time() - (24 * 60 * 60)
    local yesterday_str = os.date("%Y-%m-%d", yesterday)
    local filepath = daily_notes_dir .. "/" .. yesterday_str .. ".md"

    local content = {}
    local file = io.open(filepath, "r")

    if not file then
        return "前日のノートが見つかりません。"
    end

    local capture = false
    for line in file:lines() do
        if line:match("^##%s+今日のTODO") then
            capture = true
        elseif capture and line:match("^##%s+") then
            break
        elseif capture then
            table.insert(content, line)
        end
    end

    file:close()

    local result = table.concat(content, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
    if result == "" then
        return "前日のTODOはありませんでした。"
    end

    return result
end

return M
