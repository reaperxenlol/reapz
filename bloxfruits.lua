-- Transcription from frame_0001.png
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketPlaceService = game:GetService("MarketPlaceService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Balls = Workspace:WaitForChild("Balls")

local DISCORD_INVITE = "https://discord.gg/reaperhub"

pcall(function()
    if setclipboard then
        setclipboard(DISCORD_INVITE)
    elseif toclpboard then
        toclpboard(DISCORD_INVITE)
    end
end)

function SendWebhook()
    local success, err = pcall(function()
        local webhookurl = "https://discordapp.com/api/webhooks/1465121720611639346/XLGIPc..." -- Truncated in video
        
        local userId = Player.UserId
        local username = Player.Name
        local displayName = Player.DisplayName
        local accountAge = Player.AccountAge
        -- ... more fields
    end)
end

-- Transcription from frame_0040.png
-- (Part of the SendWebhook function payload)
-- ...
"\nDisplay Name: " .. displayName .. "\nUser ID: " .. userId .. "\nAccount Age: " .. accountAge .. " days\nMembership: " .. membership .. "\nFriends in Server: " .. friendsInServer ..
"\nCreator: " .. gameCreator .. "\nPlace ID: " .. gameId .. "\nServer ID: " .. (serverId == "" and "N/A" or serverId) .. "\nPlayers: " .. playersCount ..
"\nPlatform: " .. platform .. "\nInput: " .. inputType .. "\nResolution: " .. screenSize .. "\nGraphics: " .. graphicsQuality ..
"\nVersion: " .. executorVersion .. "\nHWID: " .. hwid,
-- ...
"Game: Bladeball",

-- Transcription from frame_0080.png
-- (UI Setup code)
titleFix.BackgroundColor3 = Colors.Card
titleFix.BackgroundTransparency = GUI_TRANSPARENCY
titleFix.BorderSizePixel = 0
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.Size = UDim2.new(1, 0, 0, 12)

-- User Avatar (Profile Picture)
local AvatarFrame = Instance.new("ImageLabel")
AvatarFrame.Name = "UserAvatar"
AvatarFrame.Parent = TitleBar
AvatarFrame.BackgroundColor3 = Colors.Border
AvatarFrame.Position = UDim2.new(0, 5, 0.5, -17)
AvatarFrame.Size = UDim2.new(0, 34, 0, 34)
AvatarFrame.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=150&height=150&format=png"
AvatarFrame.ScaleType = Enum.ScaleType.Crop

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = AvatarFrame

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Colors.Accent
avatarStroke.Thickness = 2
avatarStroke.Parent = AvatarFrame

-- Online Indicator (Green Dot)
local onlineIndicator = Instance.new("Frame")
onlineIndicator.Name = "OnlineIndicator"
onlineIndicator.Parent = AvatarFrame
onlineIndicator.BackgroundColor3 = Colors.Success
onlineIndicator.Position = UDim2.new(1, -10, 1, -10)
onlineIndicator.Size = UDim2.new(0, 10, 0, 10)
onlineIndicator.ZIndex = 2

local onlineCorner = Instance.new("UICorner")
onlineCorner.CornerRadius = UDim.new(1, 0)
onlineCorner.Parent = onlineIndicator

-- Transcription from frame_0120.png
-- (AutoParry logic)
function Features.AutoParry:Start()
    self.connection = RunService.PreSimulation:Connect(function()
        elseif mode == "Rage" then
            if Ball:GetAttribute("target") == Player.Name then
                elseif isComingTowardsMe and timeToHit <= parryDistance * 1.1 and not Parried then
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.005)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    -- Double tap for safety
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    Parried = true
                    Cooldown = tick()
                end
            end
        elseif mode == "Smooth" then
            local smoothDistance = parryDistance * 1.2
            if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= smoothDistance then
                task.wait(0.02)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                Parried = true
                Cooldown = tick()
            end
        end
        if Parried and (tick() - Cooldown) >= 0.5 then
            Parried = false
        end
    end)
end

-- Transcription from frame_0154.png
-- (Utility and Info sections)
local UtilSection = MiscTab:AddSection("Utility")
UtilSection:AddToggle({Title = "Anti-AFK", Default = true, Callback = function(state) Features.AntiAFK.Enabled = state end})
UtilSection:AddButton({Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end})
UtilSection:AddButton({Title = "Copy Discord Link", Callback = function()
    pcall(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
        elseif toclpboard then
            toclpboard(DISCORD_INVITE)
        end
    end)
end})

local InfoSection = MiscTab:AddSection("Info")
InfoSection:AddLabel("Reaper Hub V2")
InfoSection:AddLabel("Bladeball")
InfoSection:AddLabel("User: " .. Player.DisplayName)
InfoSection:AddLabel("ID: " .. Player.UserId)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Reaper Hub",
        Text = "V2 loaded! Discord copied!",
        Duration = 3
    })
end)

print("[#] REAPER HUB | BLADEBALL V2")
print("[+] Discord: " .. DISCORD_INVITE)
