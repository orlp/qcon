function prompt()
    -- ▄
    local pwd = string.sub(clink.prompt.value, 1, -2)

    -- network location?
    if string.sub(pwd, 1, 3) == "\\\\" then
        pwd = string.sub(pwd, 3, -1)
    end

    -- drive letter?
    if string.sub(pwd, 2, 2) == ":" then
        pwd = string.lower(string.sub(pwd, 1, 1)) .. string.sub(pwd, 3, -1)
    end

    -- strip trailing slash
    if string.sub(pwd, -1, -1) == "\\" then
        pwd = string.sub(pwd, 1, -2)
    end

    local path = string.gsub(pwd, "\\", "\27[1;34m >\27[0;37m ")

    local dirs = false
    local files = false

    for i, dir in ipairs(clink.find_dirs("*")) do
        if dir ~= "." and dir ~= ".." then
            dirs = true
            break
        end
    end

    for i, file in ipairs(clink.find_files("*")) do
        if file ~= "." and file ~= ".." and not clink.is_dir(file) then
            files = true
            break
        end
    end

    local file_dir_color = "31"
    if dirs and files then
        file_dir_color = "32"
    elseif files then
        file_dir_color = "33"
    elseif dirs then
        file_dir_color = "35"
    end

    clink.prompt.value = "\27[0;".. file_dir_color .. "m" .. os.getenv("CONSOLE_NR") .. "\27[0;1;37m " .. path .. " \27[1;34m| \27[1;37m"
    
    return false
end

clink.prompt.register_filter(prompt, 50)