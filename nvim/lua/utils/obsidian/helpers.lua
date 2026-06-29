local M = {}

local daily_notes_dir = vim.fn.expand("~/Desktop/obsidian/works/daily")

local function get_section_content(filepath, section_pattern, empty_message)
    local file = io.open(filepath, "r")
    if not file then
        return "前日のノートが見つかりません。"
    end

    local content = {}
    local capture = false
    for line in file:lines() do
        if line:match(section_pattern) then
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
        return empty_message
    end

    return result
end

local function yesterday_filepath()
    local yesterday = os.time() - (24 * 60 * 60)
    local yesterday_str = os.date("%Y-%m-%d", yesterday)
    return daily_notes_dir .. "/" .. yesterday_str .. ".md"
end

function M.get_yesterday_todos()
    return get_section_content(yesterday_filepath(), "^##%s+今日のTODO", "前日のTODOはありませんでした。")
end

function M.get_yesterday_memos()
    return get_section_content(yesterday_filepath(), "^##%s+メモ", "前日のメモはありませんでした。")
end

return M
