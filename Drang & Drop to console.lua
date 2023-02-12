local os_name = string.lower(ffi.os)
local user_path
local move_command
local hostApp







function cret_dir(user, destiation)

    if package.config:sub(1, 1) == "\\" then
        -- Windows
        os.execute("mkdir " .. user .. destiation)
        print("creating folder")
    else
        -- Mac or Linux
        os.execute("mkdir -p " .. user .. destiation)
        print("creating folder")

    end

    print(user, destiation)
end

--for windows
function replaceBackslash(path)
    local new_path = string.gsub(path, "\\", "\\\\")
    new_path = string.gsub(new_path, "\\\\$", "")
    return new_path
end

function remove_last_backslash(path)
    local new_path = path:gsub("\\$", "")
    return new_path
end

function selected_dir(path)
    local value = remove_last_backslash(path)
    local end_value = value:gsub(".*\\", "")
    return end_value
end

function which_dir_to_move() 

    if selected_dir == "X-Session" then

        move_command = 'move "' ..dirName ..'\\Motion-Sweet" "%s\\AppData\\Roaming\\Blackmagic Design\\DaVinci Resolve\\Support\\Fusion\\Scripts\\Comp\\X-Session\\ "'
        print("X-Session selected")
    elseif selected_dir == "Motion-Sweet" then
        print("Motion-Sweet selected")
        move_command = 'move "' ..dirName ..'" "%s\\AppData\\Roaming\\Blackmagic Design\\DaVinci Resolve\\Support\\Fusion\\Scripts\\Comp\\X-Session\\ "'

    else
        print("please select the right folder!")

    end

end




dirName = tostring(fu:RequestDir(''));
selected_dir = selected_dir(dirName)
dirName = replaceBackslash(dirName)







if fu:GetVersion().App == "Resolve" then
    -- Resolve (Free) or Resolvd Studio is running
    hostApp = "Resolve"
    print(hostApp)






    if os_name:find("windows") then

        user_path = os.getenv("USERPROFILE")
        local is_xsession = "%s\\AppData\\Roaming\\Blackmagic Design\\DaVinci Resolve\\Fusion\\Scripts\\Comp\\X-Session"

        if bmd.direxists(string.format(is_xsession, user_path)) then
            which_dir_to_move() 

        else
        cret_dir(  user_path, "\\AppData\\Roaming\\Blackmagic Design\\DaVinci Resolve\\Support\\Fusion\\Scripts\\Comp\\X-Session ")
        
        which_dir_to_move() 

        end














    elseif os_name:find("mac") then

        user_path = os.getenv("HOME")
        local is_xsession = "%s/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp/X-Session"


        if bmd.direxists(string.format(is_xsession, user_path)) then
            move_command = 'mv "' ..
                dirName ..
                '" "%s/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/X-Session/ "'

        else
            cret_dir(string.format("%s\\AppData\\Roaming\\Blackmagic Design\\DaVinci Resolve\\Fusion\\Scripts\\Comp\\",
                user_path), "X-Session")
            move_command = 'move "' ..
                dirName ..
                '" "%s\\AppData\\Roaming\\Blackmagic Design\\DaVinci Resolve\\Fusion\\Scripts\\Comp\\X-Session\\ "'

        end




        -- elseif os_name:find("linux") then
        --     user_path = os.getenv("HOME")

        --     move_command = 'mv ' .. dirName .. ' "%s/path/to/new/location/folder"'


    else
        print("OS not supported")
        return
    end










elseif fu:GetVersion().App == "Fusion" then
    -- Fusion Studio is running
    hostApp = "Fusion"
    print(hostApp)


    if os_name:find("windows") then
        user_path = os.getenv("USERPROFILE")

        local path = "%s\\AppData\\Roaming\\Blackmagic Design\\Fusion\\Scripts\\Comp\\X-Session"

        if bmd.direxists(string.format(path, user_path)) then
            move_command = 'move "' ..
                dirName .. '" "%s\\AppData\\Roaming\\Blackmagic Design\\Fusion\\Scripts\\Comp\\X-Session\\ "'

        else
            move_command = 'move "' .. dirName ..
                '" "%s\\AppData\\Roaming\\Blackmagic Design\\Fusion\\Scripts\\Comp\\  "'


        end

    elseif os_name:find("mac") then
        user_path = os.getenv("HOME")
        path = "%s/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts/Comp/X-Session"


        if bmd.direxists(string.format(path, user_path)) then
            move_command = 'mv "' ..
                dirName .. '" "%s/Library/Application Support/Blackmagic Design/Fusion/Scripts/X-Session/ "'

        else
            move_command = 'mv  "' ..
                dirName .. '" "%s/Library/Application Support/Blackmagic Design/Fusion/Scripts/Comp/  "'

        end




    else
        print("OS not supported")
        return
    end


else
    print("somthing went wrong!")
end








local move_command = string.format(move_command, user_path)
os.execute(move_command)
