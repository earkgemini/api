--[[
    AnityX Hub Loader
    Secure Script Loading System
--]]

-- CONFIG --
-- [สำหรับลูกค้า] ใส่ Key ที่นี่ หรือใช้ _G.Key ก็ได้
local SCRIPT_KEY = _G.Key or "AnityX-KEY-HERE" 
local SCRIPT_ID = "default"
local API_DOMAIN = "http://localhost:3000" -- [สำคัญ] เปลี่ยนเป็นลิ้งค์เว็บจริง (Railway) ก่อนอัปโหลดลง GitHub

-- [[ วิธีใช้งานแบบ RAW ]] --
-- 1. แก้ API_DOMAIN ให้เป็นลิ้งค์เว็บจริง
-- 2. อัปโหลดไฟล์นี้ขึ้น GitHub
-- 3. ส่งลิ้งค์ RAW ให้ลูกค้าใช้แบบนี้:
--    _G.Key = "KEYลูกค้า"
--    loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/REPO/main/Loader.lua"))()

-- SERVICES --
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- MAIN --
local function LoadScript()
    local Player = Players.LocalPlayer
    local UserId = tostring(Player.UserId) -- Using UserId as HWID for simplicity/safety in Roblox
    
    -- Logging
    print("[AnityX] Connecting to server...")

    -- Construct URL
    -- We use UserId as 'hwid' to bind the key to this Roblox account
    local Url = string.format("%s/loader?key=%s&hwid=%s&id=%s", API_DOMAIN, SCRIPT_KEY, UserId, SCRIPT_ID)

    -- Safe Request
    local Success, Response = pcall(function()
        return game:HttpGet(Url)
    end)

    if not Success then
        warn("[AnityX] Failed to connect to server.")
        return
    end

    -- Check for API Errors (The API returns `print('Error...')` for simple errors)
    if string.find(Response, "Error:") then
        warn("[AnityX] Server Rejected Request:")
        -- Execute the error print from server for feedback
        loadstring(Response)()
        return
    end

    -- Execution
    print("[AnityX] Script authenticated. Loading...")
    
    local ExecErr, ExecResult = pcall(function()
        loadstring(Response)()
    end)

    if not ExecErr then
        warn("[AnityX] Error executing script: " .. tostring(ExecResult))
    else
        print("[AnityX] Running successfully.")
    end
end

-- Init
LoadScript()
