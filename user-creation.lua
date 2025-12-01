--[[

    Author: sinsly
    License: MIT
    Github: https://github.com/sinsly
       * How to get api_dev_key go to https://pastebin.com/doc_api

    Usage: 
    Creates a pastebin paste under a USER account
    Replace api_dev_key
    Replace pasteName
    Replace pasteCode 
    Set username
    Set password
       * Don't let your key or u/p be publicly visible.

--]]

local pasteName = "lua2paste.lua"
local pasteCode = [[ 
print('line 1') 
print('line 2'
]]

local http_request = http_request or request or http.request

local pasteData = {
    api_dev_key = "YOUR_DEV_KEY",
    api_user_key = "", -- Your Pastebin user key (authentication token)
    api_option = "paste",
    api_paste_private = "0",  -- 0: Public, 1: Unlisted, 2: Private
    api_paste_expire_date = "N",  -- N: Never, 10M: 10 Minutes, 1H: 1 Hour, 1D: 1 Day, 1W: 1 Week, 2W: 2 Weeks, 1M: 1 Month
}

pasteData.api_paste_name = pasteName
pasteData.api_paste_code = pasteCode

-- Set your Pastebin username and password here
local username = "YOUR_USERNAME"
local password = "YOUR_PASSWORD"

-- Step 1: Get user key (authentication token)
local getUserKey = http_request({
    Url = "https://pastebin.com/api/api_login.php",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
    },
    Body = "api_dev_key=" .. pasteData.api_dev_key .. "&api_user_name=" .. username .. "&api_user_password=" .. password
})

if getUserKey.Success then
    pasteData.api_user_key = getUserKey.Body
else
    warn("Failed to authenticate:", getUserKey.StatusCode, getUserKey.Body)
    return
end

-- Step 2: Create the paste
local postData = {}

for key, value in pairs(pasteData) do
    table.insert(postData, string.format("%s=%s", key, value))
end

postData = table.concat(postData, "&")

local createPaste = http_request({
    Url = "https://pastebin.com/api/api_post.php",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
    },
    Body = postData
})

if createPaste.Success then
    print(createPaste.Body)
else
    warn("Failed to create paste:", createPaste.StatusCode, createPaste.Body)
end
