local M = {}

local daily_notes_dir = vim.fn.expand("~/Desktop/obsidian/works/daily")

local function get_section_content(filepath, section_pattern, empty_message)
    if not filepath then
        return "前日のノートが見つかりません。"
    end
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

-- テンプレート適用時点では新ノートが既に作成済みのため、
-- ファイル名降順で2番目（＝直前のノート）を返す
local function recent_daily_filepath()
    local files = vim.fn.glob(daily_notes_dir .. "/*.md", false, true)
    if not files or #files < 2 then
        return nil
    end
    table.sort(files, function(a, b) return a > b end)
    return files[2]
end

function M.get_yesterday_todos()
    return get_section_content(recent_daily_filepath(), "^##%s+今日のTODO", "前日のTODOはありませんでした。")
end

function M.get_yesterday_memos()
    return get_section_content(recent_daily_filepath(), "^##%s+メモ", "前日のメモはありませんでした。")
end

return M
