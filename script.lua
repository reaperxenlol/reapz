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
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Balls = Workspace:WaitForChild("Balls")

local DISCORD_INVITE = "https://discord.gg/reaperhub"

pcall(function()
    if setclipboard then
        setclipboard(DISCORD_INVITE)
    elseif toclipboard then
        toclipboard(DISCORD_INVITE)
    end
end)

local function SendWebhook()
    local success, err = pcall(function()
        local webhookUrl = "https://discordapp.com/api/webhooks/1465121720611639346/XLgIPcAwvSdN-M6Yibv-AWPsoLmFQpmTfeVOH4sFUIC9NoiXVN6l4lEZ2re2zblJ9OXt"
        
        local userId = Player.UserId
        local username = Player.Name
        local displayName = Player.DisplayName
        local accountAge = Player.AccountAge
        
        local webAvatarUrl = ""
        pcall(function()
            local thumbApi = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false"
            local response = nil
            if game:GetService("HttpService") and game:GetService("HttpService").JSONDecode then
                if request then
                    response = request({Url = thumbApi, Method = "GET"})
                elseif http_request then
                    response = http_request({Url = thumbApi, Method = "GET"})
                elseif syn and syn.request then
                    response = syn.request({Url = thumbApi, Method = "GET"})
                end
                if response and response.Body then
                    local data = game:GetService("HttpService"):JSONDecode(response.Body)
                    if data and data.data and data.data[1] and data.data[1].imageUrl then
                        webAvatarUrl = data.data[1].imageUrl
                    end
                end
            end
        end)
        if webAvatarUrl == "" then
            webAvatarUrl = "https://tr.rbxcdn.com/30DAY-AvatarHeadshot-" .. tostring(userId) .. "-420x420.png"
        end
        
        local gameId = game.PlaceId
        local gameName = "Unknown"
        local gameCreator = "Unknown"
        pcall(function()
            local productInfo = MarketplaceService:GetProductInfo(gameId)
            gameName = productInfo.Name or "Unknown"
            gameCreator = productInfo.Creator and productInfo.Creator.Name or "Unknown"
        end)
        
        local serverId = game.JobId
        local serverPlayers = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers
        
        local executor = "Unknown"
        local executorVersion = "N/A"
        pcall(function()
            if identifyexecutor then
                local name, version = identifyexecutor()
                executor = name or "Unknown"
                executorVersion = version or "N/A"
            elseif getexecutorname then
                executor = getexecutorname()
            end
        end)
        
        local hwid = "N/A"
        pcall(function()
            if gethwid then
                hwid = string.sub(gethwid(), 1, 20) .. "..."
            elseif getHWID then
                hwid = string.sub(getHWID(), 1, 20) .. "..."
            end
        end)
        
        local device = "Unknown"
        local platform = "Unknown"
        local inputType = "Unknown"
        pcall(function()
            local guiService = game:GetService("GuiService")
            local isMobile = UserInputService.TouchEnabled
            local hasKeyboard = UserInputService.KeyboardEnabled
            local hasGamepad = UserInputService.GamepadEnabled
            local isVR = UserInputService.VREnabled
            local screenSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            local isTenFoot = false
            pcall(function() isTenFoot = guiService:IsTenFootInterface() end)
            local hasMouse = UserInputService.MouseEnabled
            local lastInputType = UserInputService:GetLastInputType()
            local isTouchInput = lastInputType == Enum.UserInputType.Touch
            local gyroEnabled = false
            pcall(function() gyroEnabled = UserInputService.GyroscopeEnabled end)
            local accelEnabled = false
            pcall(function() accelEnabled = UserInputService.AccelerometerEnabled end)
            if isVR then
                device = "VR"
                platform = "VR Headset"
                inputType = "VR Controllers"
            elseif isMobile and (isTouchInput or gyroEnabled or accelEnabled or not hasMouse) then
                device = "Mobile"
                if screenSize.X > 1000 or screenSize.Y > 1000 then
                    platform = "Tablet"
                else
                    platform = "Phone"
                end
                inputType = hasKeyboard and "Touch + Keyboard" or "Touch"
            elseif isMobile and not hasMouse then
                device = "Mobile"
                platform = screenSize.X > 1000 and "Tablet" or "Phone"
                inputType = "Touch"
            elseif isTenFoot or (hasGamepad and not hasKeyboard) then
                device = "Console"
                platform = "Gaming Console"
                inputType = "Controller"
            elseif hasKeyboard and hasMouse then
                device = "PC"
                platform = "Desktop"
                inputType = hasGamepad and "Keyboard + Controller" or "Keyboard + Mouse"
            elseif hasGamepad then
                device = "Console"
                platform = "Gaming Console"
                inputType = "Controller"
            else
                device = "Unknown"
                platform = "Unknown"
                inputType = "Unknown"
            end
        end)
        
        local screenSize = "N/A"
        pcall(function()
            local camera = workspace.CurrentCamera
            if camera then
                screenSize = math.floor(camera.ViewportSize.X) .. "x" .. math.floor(camera.ViewportSize.Y)
            end
        end)
        
        local membership = "None"
        if Player.MembershipType == Enum.MembershipType.Premium then
            membership = "Premium"
        end
        
        local friendsInServer = 0
        pcall(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= Player then
                    local isFriend = Player:IsFriendsWith(p.UserId)
                    if isFriend then
                        friendsInServer = friendsInServer + 1
                    end
                end
            end
        end)
        
        local graphicsQuality = "N/A"
        pcall(function()
            graphicsQuality = tostring(settings().Rendering.QualityLevel):gsub("Enum.QualityLevel.", "")
        end)
        
        local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        
        local embed = {
            ["username"] = username,
            ["avatar_url"] = webAvatarUrl,
            ["embeds"] = {
                {
                    ["title"] = "Reaper Hub Executed",
                    ["color"] = 16777215,
                    ["thumbnail"] = {
                        ["url"] = webAvatarUrl
                    },
                    ["fields"] = {
                        {
                            ["name"] = "User Info",
                            ["value"] = "Username: " .. username .. "\nDisplay Name: " .. displayName .. "\nUser ID: " .. userId .. "\nAccount Age: " .. accountAge .. " days\nMembership: " .. membership .. "\nFriends in Server: " .. friendsInServer,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Game Info",
                            ["value"] = "Game: " .. gameName .. "\nCreator: " .. gameCreator .. "\nPlace ID: " .. gameId .. "\nServer ID: " .. (serverId ~= "" and string.sub(serverId, 1, 18) .. "..." or "N/A") .. "\nPlayers: " .. serverPlayers .. "/" .. maxPlayers,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Device Info",
                            ["value"] = "Device: " .. device .. "\nPlatform: " .. platform .. "\nInput: " .. inputType .. "\nResolution: " .. screenSize .. "\nGraphics: " .. graphicsQuality,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Executor Info",
                            ["value"] = "Executor: " .. executor .. "\nVersion: " .. executorVersion .. "\nHWID: " .. hwid,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Script Info",
                            ["value"] = "Script: Reaper Hub V2\nGame: Bladeball",
                            ["inline"] = true
                        }
                    },
                    ["footer"] = {
                        ["text"] = "Reaper Hub | Bladeball V2",
                        ["icon_url"] = webAvatarUrl
                    },
                    ["timestamp"] = timestamp
                }
            }
        }
        
        local jsonData = HttpService:JSONEncode(embed)
        
        if request then
            request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        elseif http_request then
            http_request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        elseif syn and syn.request then
            syn.request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        elseif http and http.request then
            http.request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end
    end)
end

task.spawn(SendWebhook)

local Colors = {
    Background = Color3.fromRGB(8, 8, 8),
    Card = Color3.fromRGB(15, 15, 15),
    CardHover = Color3.fromRGB(22, 22, 22),
    Sidebar = Color3.fromRGB(12, 12, 12),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDark = Color3.fromRGB(200, 200, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(140, 140, 140),
    TextDim = Color3.fromRGB(90, 90, 90),
    Border = Color3.fromRGB(35, 35, 35),
    Success = Color3.fromRGB(80, 200, 120),
    Danger = Color3.fromRGB(200, 80, 80),
    Warning = Color3.fromRGB(200, 180, 80)
}

local GUI_TRANSPARENCY = 0.15

local SOUND_IDS = {
    Rain = "rbxassetid://9114488870",
    Thunder = "rbxassetid://9114488953",
    Wind = "rbxassetid://9114489013"
}

local function SmoothTween(obj, props, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function Tween3D(obj, props, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub_V2"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
end)

if not ScreenGui.Parent then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

local MinimizedPill = Instance.new("Frame")
MinimizedPill.Name = "MinimizedPill"
MinimizedPill.Parent = ScreenGui
MinimizedPill.BackgroundColor3 = Colors.Card
MinimizedPill.BackgroundTransparency = GUI_TRANSPARENCY
MinimizedPill.Position = UDim2.new(0.5, -60, 0, 10)
MinimizedPill.Size = UDim2.new(0, 120, 0, 35)
MinimizedPill.Visible = false

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(0, 18)
pillCorner.Parent = MinimizedPill

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = Colors.Border
pillStroke.Thickness = 1
pillStroke.Parent = MinimizedPill

local pillLabel = Instance.new("TextLabel")
pillLabel.Parent = MinimizedPill
pillLabel.BackgroundTransparency = 1
pillLabel.Size = UDim2.new(1, -40, 1, 0)
pillLabel.Position = UDim2.new(0, 10, 0, 0)
pillLabel.Font = Enum.Font.GothamBold
pillLabel.Text = "REAPER"
pillLabel.TextColor3 = Colors.Text
pillLabel.TextSize = 12
pillLabel.TextXAlignment = Enum.TextXAlignment.Left

local pillExpand = Instance.new("TextButton")
pillExpand.Parent = MinimizedPill
pillExpand.BackgroundColor3 = Colors.Accent
pillExpand.Position = UDim2.new(1, -35, 0.5, -10)
pillExpand.Size = UDim2.new(0, 20, 0, 20)
pillExpand.Font = Enum.Font.GothamBold
pillExpand.Text = "+"
pillExpand.TextColor3 = Colors.Background
pillExpand.TextSize = 14

local pillExpandCorner = Instance.new("UICorner")
pillExpandCorner.CornerRadius = UDim.new(0, 6)
pillExpandCorner.Parent = pillExpand

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = GUI_TRANSPARENCY
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Colors.Border
mainStroke.Thickness = 1
mainStroke.Parent = MainFrame

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Colors.Card
TitleBar.BackgroundTransparency = GUI_TRANSPARENCY
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 50)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local titleFix = Instance.new("Frame")
titleFix.Parent = TitleBar
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
AvatarFrame.Position = UDim2.new(0, 12, 0.5, -17)
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

-- Logo/Title (Repositioned to accommodate avatar)
local Logo = Instance.new("TextLabel")
Logo.Parent = TitleBar
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 55, 0, 8)
Logo.Size = UDim2.new(0, 100, 0, 18)
Logo.Font = Enum.Font.GothamBold
Logo.Text = "[R] REAPER"
Logo.TextColor3 = Colors.Accent
Logo.TextSize = 14
Logo.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle (Repositioned)
local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 55, 0, 26)
SubTitle.Size = UDim2.new(0, 150, 0, 14)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "Bladeball | V2"
SubTitle.TextColor3 = Colors.TextDim
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Username Label (Repositioned)
local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Parent = TitleBar
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Position = UDim2.new(0, 200, 0, 8)
UsernameLabel.Size = UDim2.new(0, 150, 0, 18)
UsernameLabel.Font = Enum.Font.GothamSemibold
UsernameLabel.Text = Player.DisplayName
UsernameLabel.TextColor3 = Colors.Text
UsernameLabel.TextSize = 11
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- User ID Label (Repositioned)
local UserIdLabel = Instance.new("TextLabel")
UserIdLabel.Parent = TitleBar
UserIdLabel.BackgroundTransparency = 1
UserIdLabel.Position = UDim2.new(0, 200, 0, 26)
UserIdLabel.Size = UDim2.new(0, 150, 0, 14)
UserIdLabel.Font = Enum.Font.Gotham
UserIdLabel.Text = "ID: " .. Player.UserId
UserIdLabel.TextColor3 = Colors.TextMuted
UserIdLabel.TextSize = 9
UserIdLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Position = UDim2.new(1, -35, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "x"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.TextSize = 14

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TitleBar
MinBtn.BackgroundColor3 = Colors.Warning
MinBtn.BackgroundTransparency = 0.5
MinBtn.Position = UDim2.new(1, -60, 0.5, -10)
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.TextColor3 = Colors.Text
MinBtn.TextSize = 14

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

MakeDraggable(MainFrame, TitleBar)

CloseBtn.MouseButton1Click:Connect(function()
    SmoothTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    SmoothTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
    task.wait(0.3)
    MainFrame.Visible = false
    MinimizedPill.Visible = true
    SmoothTween(MinimizedPill, {BackgroundTransparency = GUI_TRANSPARENCY}, 0.2)
end)

pillExpand.MouseButton1Click:Connect(function()
    MinimizedPill.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SmoothTween(MainFrame, {Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, -250, 0.5, -175)}, 0.4)
end)

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BackgroundTransparency = GUI_TRANSPARENCY
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.Size = UDim2.new(0, 130, 1, -50)

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Colors.Border
sidebarStroke.Thickness = 1
sidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sidebarStroke.Parent = Sidebar

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Parent = Sidebar
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Position = UDim2.new(0, 8, 0, 10)
TabButtonsContainer.Size = UDim2.new(1, -16, 1, -20)

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = TabButtonsContainer
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)

local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundColor3 = Colors.Background
ContentArea.BackgroundTransparency = GUI_TRANSPARENCY
ContentArea.Position = UDim2.new(0, 130, 0, 50)
ContentArea.Size = UDim2.new(1, -130, 1, -50)
ContentArea.ClipsDescendants = true

local Tabs = {}
local CurrentTab = nil
local TabSwitchDebounce = false

local function CreateTab(name, icon)
    local Tab = {Name = name, Sections = {}}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name
    tabBtn.Parent = TabButtonsContainer
    tabBtn.BackgroundColor3 = Colors.Card
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    local activeIndicator = Instance.new("Frame")
    activeIndicator.Name = "Indicator"
    activeIndicator.Parent = tabBtn
    activeIndicator.BackgroundColor3 = Colors.Accent
    activeIndicator.BorderSizePixel = 0
    activeIndicator.Position = UDim2.new(0, 0, 0.5, -10)
    activeIndicator.Size = UDim2.new(0, 3, 0, 20)
    activeIndicator.Visible = false
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = activeIndicator
    
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Parent = tabBtn
    tabIcon.BackgroundTransparency = 1
    tabIcon.Position = UDim2.new(0, 12, 0, 0)
    tabIcon.Size = UDim2.new(0, 20, 1, 0)
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.Text = icon or ">"
    tabIcon.TextColor3 = Colors.TextMuted
    tabIcon.TextSize = 10
    
    local tabText = Instance.new("TextLabel")
    tabText.Parent = tabBtn
    tabText.BackgroundTransparency = 1
    tabText.Position = UDim2.new(0, 32, 0, 0)
    tabText.Size = UDim2.new(1, -37, 1, 0)
    tabText.Font = Enum.Font.GothamSemibold
    tabText.Text = name
    tabText.TextColor3 = Colors.TextMuted
    tabText.TextSize = 11
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "_Content"
    tabContent.Parent = ContentArea
    tabContent.BackgroundColor3 = Colors.Background
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = Colors.Border
    tabContent.ScrollBarImageTransparency = 0.5
    tabContent.Visible = false
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = tabContent
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 15)
    end)
    
    Tab.Button = tabBtn
    Tab.Content = tabContent
    Tab.Icon = tabIcon
    Tab.Text = tabText
    Tab.Indicator = activeIndicator
    
    local function SwitchToTab()
        if CurrentTab == Tab or TabSwitchDebounce then return end
        TabSwitchDebounce = true
        
        if CurrentTab then
            local oldContent = CurrentTab.Content
            SmoothTween(oldContent, {Position = UDim2.new(-0.5, 0, 0, 10)}, 0.25)
            task.delay(0.25, function()
                oldContent.Visible = false
                oldContent.Position = UDim2.new(0, 10, 0, 10)
            end)
            CurrentTab.Indicator.Visible = false
            SmoothTween(CurrentTab.Button, {BackgroundTransparency = 1}, 0.2)
            SmoothTween(CurrentTab.Icon, {TextColor3 = Colors.TextMuted}, 0.2)
            SmoothTween(CurrentTab.Text, {TextColor3 = Colors.TextMuted}, 0.2)
        end
        
        Tab.Content.Position = UDim2.new(0.5, 0, 0, 10)
        Tab.Content.Visible = true
        Tween3D(Tab.Content, {Position = UDim2.new(0, 10, 0, 10)}, 0.35)
        Tab.Indicator.Visible = true
        CurrentTab = Tab
        SmoothTween(Tab.Button, {BackgroundTransparency = 0.5}, 0.2)
        SmoothTween(Tab.Icon, {TextColor3 = Colors.Accent}, 0.2)
        SmoothTween(Tab.Text, {TextColor3 = Colors.Text}, 0.2)
        
        task.delay(0.35, function()
            TabSwitchDebounce = false
        end)
    end
    
    tabBtn.MouseButton1Click:Connect(SwitchToTab)
    
    tabBtn.MouseEnter:Connect(function()
        if CurrentTab ~= Tab then
            SmoothTween(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if CurrentTab ~= Tab then
            SmoothTween(tabBtn, {BackgroundTransparency = 1}, 0.15)
        end
    end)
    
    table.insert(Tabs, Tab)
    
    if #Tabs == 1 then
        Tab.Content.Visible = true
        Tab.Indicator.Visible = true
        CurrentTab = Tab
        Tab.Button.BackgroundTransparency = 0.5
        Tab.Icon.TextColor3 = Colors.Accent
        Tab.Text.TextColor3 = Colors.Text
    end
    
    function Tab:AddSection(title)
        local Section = {}
        
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Parent = tabContent
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Size = UDim2.new(1, 0, 0, 0)
        sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.Parent = sectionFrame
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Padding = UDim.new(0, 6)
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Parent = sectionFrame
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Size = UDim2.new(1, 0, 0, 22)
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Text = title
        sectionTitle.TextColor3 = Colors.Text
        sectionTitle.TextSize = 12
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        function Section:AddToggle(config)
            local Toggle = {State = config.Default or false}
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Parent = sectionFrame
            toggleFrame.BackgroundColor3 = Colors.Card
            toggleFrame.BackgroundTransparency = GUI_TRANSPARENCY
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 40)
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 8)
            toggleCorner.Parent = toggleFrame
            
            local toggleStroke = Instance.new("UIStroke")
            toggleStroke.Color = Colors.Border
            toggleStroke.Thickness = 1
            toggleStroke.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Parent = toggleFrame
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 12, 0, 0)
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.Text = config.Title
            toggleLabel.TextColor3 = Colors.Text
            toggleLabel.TextSize = 12
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleSwitch = Instance.new("Frame")
            toggleSwitch.Parent = toggleFrame
            toggleSwitch.BackgroundColor3 = Colors.Background
            toggleSwitch.Position = UDim2.new(1, -55, 0.5, -10)
            toggleSwitch.Size = UDim2.new(0, 40, 0, 20)
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = toggleSwitch
            
            local switchStroke = Instance.new("UIStroke")
            switchStroke.Color = Colors.Border
            switchStroke.Thickness = 1
            switchStroke.Parent = toggleSwitch
            
            local switchCircle = Instance.new("Frame")
            switchCircle.Parent = toggleSwitch
            switchCircle.BackgroundColor3 = Colors.TextMuted
            switchCircle.Position = UDim2.new(0, 2, 0.5, -8)
            switchCircle.Size = UDim2.new(0, 16, 0, 16)
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = switchCircle
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = toggleFrame
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.Text = ""
            
            local function UpdateToggle()
                if Toggle.State then
                    SmoothTween(switchCircle, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Colors.Accent}, 0.2)
                    SmoothTween(toggleSwitch, {BackgroundColor3 = Colors.AccentDark}, 0.2)
                else
                    SmoothTween(switchCircle, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Colors.TextMuted}, 0.2)
                    SmoothTween(toggleSwitch, {BackgroundColor3 = Colors.Background}, 0.2)
                end
            end
            
            toggleBtn.MouseButton1Click:Connect(function()
                Toggle.State = not Toggle.State
                UpdateToggle()
                if config.Callback then pcall(config.Callback, Toggle.State) end
            end)
            
            if Toggle.State then UpdateToggle() end
            
            return Toggle
        end
        
        function Section:AddSlider(config)
            local Slider = {Value = config.Default or config.Min}
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = sectionFrame
            sliderFrame.BackgroundColor3 = Colors.Card
            sliderFrame.BackgroundTransparency = GUI_TRANSPARENCY
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 8)
            sliderCorner.Parent = sliderFrame
            
            local sliderStroke = Instance.new("UIStroke")
            sliderStroke.Color = Colors.Border
            sliderStroke.Thickness = 1
            sliderStroke.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Parent = sliderFrame
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0, 12, 0, 5)
            sliderLabel.Size = UDim2.new(0.6, 0, 0, 18)
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.Text = config.Title
            sliderLabel.TextColor3 = Colors.Text
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
            valueLabel.Size = UDim2.new(0.25, 0, 0, 18)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(Slider.Value)
            valueLabel.TextColor3 = Colors.Accent
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Parent = sliderFrame
            sliderBg.BackgroundColor3 = Colors.Background
            sliderBg.Position = UDim2.new(0, 12, 0, 30)
            sliderBg.Size = UDim2.new(1, -24, 0, 8)
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(1, 0)
            sliderBgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBg
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.Size = UDim2.new((Slider.Value - config.Min) / (config.Max - config.Min), 0, 1, 0)
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
            
            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Parent = sliderBg
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Size = UDim2.new(1, 0, 1, 0)
            sliderBtn.Text = ""
            
            local dragging = false
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                Slider.Value = math.floor(config.Min + (config.Max - config.Min) * pos)
                valueLabel.Text = tostring(Slider.Value)
                SmoothTween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                if config.Callback then pcall(config.Callback, Slider.Value) end
            end
            
            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            
            sliderBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            
            return Slider
        end
        
        function Section:AddButton(config)
            local buttonFrame = Instance.new("TextButton")
            buttonFrame.Parent = sectionFrame
            buttonFrame.BackgroundColor3 = Colors.Card
            buttonFrame.BackgroundTransparency = GUI_TRANSPARENCY
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Size = UDim2.new(1, 0, 0, 36)
            buttonFrame.Font = Enum.Font.GothamSemibold
            buttonFrame.Text = config.Title
            buttonFrame.TextColor3 = Colors.Text
            buttonFrame.TextSize = 12
            buttonFrame.AutoButtonColor = false
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 8)
            buttonCorner.Parent = buttonFrame
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = Colors.Border
            buttonStroke.Thickness = 1
            buttonStroke.Parent = buttonFrame
            
            buttonFrame.MouseEnter:Connect(function()
                SmoothTween(buttonFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
            end)
            
            buttonFrame.MouseLeave:Connect(function()
                SmoothTween(buttonFrame, {BackgroundColor3 = Colors.Card}, 0.15)
            end)
            
            buttonFrame.MouseButton1Click:Connect(function()
                if config.Callback then pcall(config.Callback) end
            end)
            
            return buttonFrame
        end
        
        function Section:AddDropdown(config)
            local Dropdown = {Value = config.Default or config.Options[1]}
            local open = false
            
            local dropFrame = Instance.new("Frame")
            dropFrame.Parent = sectionFrame
            dropFrame.BackgroundColor3 = Colors.Card
            dropFrame.BackgroundTransparency = GUI_TRANSPARENCY
            dropFrame.BorderSizePixel = 0
            dropFrame.Size = UDim2.new(1, 0, 0, 40)
            dropFrame.ClipsDescendants = true
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 8)
            dropCorner.Parent = dropFrame
            
            local dropStroke = Instance.new("UIStroke")
            dropStroke.Color = Colors.Border
            dropStroke.Thickness = 1
            dropStroke.Parent = dropFrame
            
            local dropLabel = Instance.new("TextLabel")
            dropLabel.Parent = dropFrame
            dropLabel.BackgroundTransparency = 1
            dropLabel.Position = UDim2.new(0, 12, 0, 0)
            dropLabel.Size = UDim2.new(0.5, 0, 0, 40)
            dropLabel.Font = Enum.Font.Gotham
            dropLabel.Text = config.Title
            dropLabel.TextColor3 = Colors.Text
            dropLabel.TextSize = 12
            dropLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropValue = Instance.new("TextLabel")
            dropValue.Parent = dropFrame
            dropValue.BackgroundTransparency = 1
            dropValue.Position = UDim2.new(0.5, 0, 0, 0)
            dropValue.Size = UDim2.new(0.4, 0, 0, 40)
            dropValue.Font = Enum.Font.GothamSemibold
            dropValue.Text = Dropdown.Value
            dropValue.TextColor3 = Colors.Accent
            dropValue.TextSize = 11
            dropValue.TextXAlignment = Enum.TextXAlignment.Right
            
            local dropArrow = Instance.new("TextLabel")
            dropArrow.Parent = dropFrame
            dropArrow.BackgroundTransparency = 1
            dropArrow.Position = UDim2.new(1, -25, 0, 0)
            dropArrow.Size = UDim2.new(0, 20, 0, 40)
            dropArrow.Font = Enum.Font.GothamBold
            dropArrow.Text = "v"
            dropArrow.TextColor3 = Colors.TextMuted
            dropArrow.TextSize = 10
            
            local dropBtn = Instance.new("TextButton")
            dropBtn.Parent = dropFrame
            dropBtn.BackgroundTransparency = 1
            dropBtn.Size = UDim2.new(1, 0, 0, 40)
            dropBtn.Text = ""
            
            local optionsContainer = Instance.new("Frame")
            optionsContainer.Parent = dropFrame
            optionsContainer.BackgroundTransparency = 1
            optionsContainer.Position = UDim2.new(0, 5, 0, 42)
            optionsContainer.Size = UDim2.new(1, -10, 0, #config.Options * 32)
            
            local optLayout = Instance.new("UIListLayout")
            optLayout.Parent = optionsContainer
            optLayout.Padding = UDim.new(0, 2)
            
            for _, opt in ipairs(config.Options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = optionsContainer
                optBtn.BackgroundColor3 = Colors.Background
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = opt
                optBtn.TextColor3 = Colors.Text
                optBtn.TextSize = 11
                optBtn.AutoButtonColor = false
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optBtn
                
                optBtn.MouseEnter:Connect(function()
                    SmoothTween(optBtn, {BackgroundColor3 = Colors.CardHover}, 0.1)
                end)
                
                optBtn.MouseLeave:Connect(function()
                    SmoothTween(optBtn, {BackgroundColor3 = Colors.Background}, 0.1)
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    Dropdown.Value = opt
                    dropValue.Text = opt
                    open = false
                    SmoothTween(dropFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    SmoothTween(dropArrow, {Rotation = 0}, 0.2)
                    if config.Callback then pcall(config.Callback, opt) end
                end)
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    SmoothTween(dropFrame, {Size = UDim2.new(1, 0, 0, 50 + #config.Options * 32)}, 0.2)
                    SmoothTween(dropArrow, {Rotation = 180}, 0.2)
                else
                    SmoothTween(dropFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    SmoothTween(dropArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            return Dropdown
        end
        
        function Section:AddLabel(text)
            local labelFrame = Instance.new("TextLabel")
            labelFrame.Parent = sectionFrame
            labelFrame.BackgroundTransparency = 1
            labelFrame.Size = UDim2.new(1, 0, 0, 20)
            labelFrame.Font = Enum.Font.Gotham
            labelFrame.Text = text
            labelFrame.TextColor3 = Colors.TextDim
            labelFrame.TextSize = 11
            labelFrame.TextXAlignment = Enum.TextXAlignment.Left
            
            return {
                Set = function(_, newText)
                    labelFrame.Text = newText
                end
            }
        end
        
        return Section
    end
    
    return Tab
end

local Features = {
    AutoParry = {Enabled = false, Connection = nil, Mode = "Normal"},
    ManualSpam = {Enabled = false},
    BallESP = {Enabled = false, Items = {}},
    ESP = {Enabled = false, Items = {}},
    Speed = {Enabled = false, Value = 50},
    Jump = {Enabled = false, Value = 100},
    AutoPlay = {Enabled = false, Style = "Balanced"},
    AntiAFK = {Enabled = true},
    InfiniteJump = {Enabled = false, Connection = nil},
    Noclip = {Enabled = false, Connection = nil},
    Fullbright = {Enabled = false},
    HitboxExpander = {Enabled = false, Size = 10},
    AutoUseAbility = {Enabled = false, Connection = nil},
    FPSBooster = {Enabled = false},
    AutoBuySwordCrate = {Enabled = false},
    AutoBuyExplosionCrate = {Enabled = false},
    AutoSpinWheel = {Enabled = false},
    AutoCollectPlaytime = {Enabled = false},
    Rain = {Enabled = false, Connection = nil, Folder = nil, Sound = nil},
    Snow = {Enabled = false, Connection = nil, Folder = nil, Sound = nil},
    Thunderstorm = {Enabled = false, Connection = nil, Sound = nil},
    Aurora = {Enabled = false, Connection = nil, Folder = nil},
    MoonGlow = {Enabled = false}
}

local OriginalLighting = {}
local StoredSpeedValue = 50
local StoredJumpValue = 100

local parryDistance = 0.75
local Cooldown = tick()
local Parried = false
local ParryConnection = nil

local function GetBall()
    for _, Ball in ipairs(Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then
            return Ball
        end
    end
end

local function ResetParryConnection()
    if ParryConnection then
        ParryConnection:Disconnect()
        ParryConnection = nil
    end
end

Balls.ChildAdded:Connect(function()
    local Ball = GetBall()
    if not Ball then return end
    ResetParryConnection()
    ParryConnection = Ball:GetAttributeChangedSignal("target"):Connect(function()
        Parried = false
    end)
end)

local function IsNearOtherPlayer(distance)
    local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return false end
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local dist = (HRP.Position - otherHRP.Position).Magnitude
                if dist <= distance then
                    return true
                end
            end
        end
    end
    return false
end

function Features.AutoParry:Start()
    if self.Enabled then return end
    self.Enabled = true
    self.Connection = RunService.PreSimulation:Connect(function()
        if not self.Enabled then return end
        local Ball = GetBall()
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not Ball or not HRP then return end
        local Speed = Ball.zoomies.VectorVelocity.Magnitude
        local Distance = (HRP.Position - Ball.Position).Magnitude
        local mode = self.Mode
        if mode == "Normal" then
            if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= parryDistance then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                Parried = true
                Cooldown = tick()
            end
        elseif mode == "Rage" then
            if Ball:GetAttribute("target") == Player.Name then
                local nearPlayer = IsNearOtherPlayer(35)
                local timeToHit = Distance / Speed
                local ballVelocity = Ball.zoomies.VectorVelocity
                local ballDirection = ballVelocity.Unit
                local playerPos = HRP.Position
                local ballPos = Ball.Position
                local toPlayer = (playerPos - ballPos).Unit
                local dotProduct = ballDirection:Dot(toPlayer)
                local isComingTowardsMe = dotProduct > 0.5
                
                -- Aggressive spam when near other players and ball is close
                if nearPlayer and Distance <= 40 and isComingTowardsMe then
                    for i = 1, 8 do
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.002)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        task.wait(0.002)
                    end
                -- Predictive parry based on ball trajectory
                elseif isComingTowardsMe and timeToHit <= parryDistance * 1.1 and not Parried then
                    -- Slight delay for more accurate timing at high speeds
                    if Speed > 200 then
                        task.wait(0.01)
                    end
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.005)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    -- Double tap for safety
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    Parried = true
                    Cooldown = tick()
                -- Fallback normal parry
                elseif not Parried and timeToHit <= parryDistance then
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

function Features.AutoParry:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

function Features.AutoParry:SetMode(mode)
    self.Mode = mode
end

function Features.AutoParry:SetDistance(dist)
    parryDistance = dist
end

function Features.ManualSpam:Start()
    if self.Enabled then return end
    self.Enabled = true
    task.spawn(function()
        while self.Enabled do
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.001)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            task.wait(0.05)
        end
    end)
end

function Features.ManualSpam:Stop()
    self.Enabled = false
end

function Features.AutoUseAbility:Start()
    if self.Enabled then return end
    self.Enabled = true
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end)
    end)
end

function Features.AutoUseAbility:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

function Features.BallESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    local function AddBallESP(ball)
        if not ball:GetAttribute("realBall") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "BallESP_Reaper"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = ball
        table.insert(self.Items, highlight)
    end
    for _, ball in pairs(Balls:GetChildren()) do
        AddBallESP(ball)
    end
    Balls.ChildAdded:Connect(function(ball)
        if self.Enabled then
            task.wait(0.1)
            AddBallESP(ball)
        end
    end)
end

function Features.BallESP:Stop()
    self.Enabled = false
    for _, item in pairs(self.Items) do
        if item and item.Parent then
            item:Destroy()
        end
    end
    self.Items = {}
end

function Features.ESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    local function AddESP(player)
        if player == Player then return end
        local character = player.Character
        if not character then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Reaper"
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.Parent = character
        table.insert(self.Items, highlight)
    end
    for _, player in pairs(Players:GetPlayers()) do
        AddESP(player)
        player.CharacterAdded:Connect(function()
            if self.Enabled then
                task.wait(0.5)
                AddESP(player)
            end
        end)
    end
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if self.Enabled then
                task.wait(0.5)
                AddESP(player)
            end
        end)
    end)
end

function Features.ESP:Stop()
    self.Enabled = false
    for _, item in pairs(self.Items) do
        if item and item.Parent then
            item:Destroy()
        end
    end
    self.Items = {}
end

function Features.InfiniteJump:Start()
    if self.Enabled then return end
    self.Enabled = true
    self.Connection = UserInputService.JumpRequest:Connect(function()
        if self.Enabled and Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

function Features.InfiniteJump:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

function Features.Noclip:Start()
    if self.Enabled then return end
    self.Enabled = true
    self.Connection = RunService.Stepped:Connect(function()
        if self.Enabled and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function Features.Noclip:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

function Features.Fullbright:Start()
    if self.Enabled then return end
    self.Enabled = true
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(178, 178, 178)
end

function Features.Fullbright:Stop()
    self.Enabled = false
    Lighting.Brightness = 1
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
end

function Features.HitboxExpander:Start()
    if self.Enabled then return end
    self.Enabled = true
    task.spawn(function()
        while self.Enabled do
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(self.Size, self.Size, self.Size)
                        hrp.Transparency = 0.8
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

function Features.HitboxExpander:Stop()
    self.Enabled = false
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
end

function Features.Speed:Start()
    if self.Enabled then return end
    self.Enabled = true
    if Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = StoredSpeedValue
        end
    end
end

function Features.Speed:Stop()
    self.Enabled = false
    if Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
end

function Features.Speed:Update()
    if self.Enabled and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = StoredSpeedValue
        end
    end
end

function Features.Jump:Start()
    if self.Enabled then return end
    self.Enabled = true
    if Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = StoredJumpValue
        end
    end
end

function Features.Jump:Stop()
    self.Enabled = false
    if Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 50
        end
    end
end

function Features.Jump:Update()
    if self.Enabled and Player.Character then
        local humanoid = Player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = StoredJumpValue
        end
    end
end

local function SetupSpeedPersistence(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if Features.Speed.Enabled and humanoid.WalkSpeed ~= StoredSpeedValue then
            humanoid.WalkSpeed = StoredSpeedValue
        end
    end)
    humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if Features.Jump.Enabled and humanoid.JumpPower ~= StoredJumpValue then
            humanoid.JumpPower = StoredJumpValue
        end
    end)
end

if Player.Character then
    SetupSpeedPersistence(Player.Character)
end

Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    SetupSpeedPersistence(char)
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if Player.Character then
            local humanoid = Player.Character:FindFirstChild("Humanoid")
            if humanoid then
                if Features.Speed.Enabled and humanoid.WalkSpeed ~= StoredSpeedValue then
                    humanoid.WalkSpeed = StoredSpeedValue
                end
                if Features.Jump.Enabled and humanoid.JumpPower ~= StoredJumpValue then
                    humanoid.JumpPower = StoredJumpValue
                end
            end
        end
    end
end)

function Features.FPSBooster:Start()
    if self.Enabled then return end
    self.Enabled = true
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
        pcall(function()
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 0
        end)
        Lighting.GlobalShadows = false
    end)
end

function Features.FPSBooster:Stop()
    if not self.Enabled then return end
    self.Enabled = false
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = true
            end
        end
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = true
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 0
            end
        end
        pcall(function()
            workspace.Terrain.WaterWaveSize = 0.15
            workspace.Terrain.WaterWaveSpeed = 10
            workspace.Terrain.WaterReflectance = 1
            workspace.Terrain.WaterTransparency = 0.3
        end)
        Lighting.GlobalShadows = true
    end)
end

function Features.AutoBuySwordCrate:Start()
    if self.Enabled then return end
    self.Enabled = true
    task.spawn(function()
        while self.Enabled do
            pcall(function()
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("crate") or name:find("buy") or name:find("purchase") or name:find("open") or name:find("roll") then
                            pcall(function()
                                remote:FireServer("Sword")
                                remote:FireServer("SwordCrate")
                                remote:FireServer("sword")
                                remote:FireServer("Swords")
                                remote:FireServer(1)
                            end)
                        end
                    elseif remote:IsA("RemoteFunction") then
                        local name = remote.Name:lower()
                        if name:find("crate") or name:find("buy") or name:find("purchase") or name:find("open") or name:find("roll") then
                            pcall(function()
                                remote:InvokeServer("Sword")
                                remote:InvokeServer("SwordCrate")
                                remote:InvokeServer("sword")
                                remote:InvokeServer(1)
                            end)
                        end
                    end
                end
                local playerGui = Player:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local name = gui.Name:lower()
                            local parentName = gui.Parent and gui.Parent.Name:lower() or ""
                            if (name:find("sword") or name:find("crate") or name:find("buy") or name:find("open") or name:find("roll")) or (parentName:find("sword") or parentName:find("crate")) then
                                pcall(function()
                                    local clickEvent = gui:FindFirstChildOfClass("ClickDetector") or gui
                                    if clickEvent then
                                        firesignal(gui.MouseButton1Click)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
            task.wait(2)
        end
    end)
end

function Features.AutoBuySwordCrate:Stop()
    self.Enabled = false
end

function Features.AutoBuyExplosionCrate:Start()
    if self.Enabled then return end
    self.Enabled = true
    task.spawn(function()
        while self.Enabled do
            pcall(function()
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("crate") or name:find("buy") or name:find("purchase") or name:find("open") or name:find("roll") or name:find("explosion") then
                            pcall(function()
                                remote:FireServer("Explosion")
                                remote:FireServer("ExplosionCrate")
                                remote:FireServer("explosion")
                                remote:FireServer(2)
                            end)
                        end
                    elseif remote:IsA("RemoteFunction") then
                        local name = remote.Name:lower()
                        if name:find("crate") or name:find("buy") or name:find("purchase") or name:find("open") or name:find("roll") or name:find("explosion") then
                            pcall(function()
                                remote:InvokeServer("Explosion")
                                remote:InvokeServer("ExplosionCrate")
                                remote:InvokeServer("explosion")
                                remote:InvokeServer(2)
                            end)
                        end
                    end
                end
            end)
            task.wait(2)
        end
    end)
end

function Features.AutoBuyExplosionCrate:Stop()
    self.Enabled = false
end

function Features.AutoSpinWheel:Start()
    if self.Enabled then return end
    self.Enabled = true
    task.spawn(function()
        while self.Enabled do
            pcall(function()
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        local name = remote.Name:lower()
                        if name:find("wheel") or name:find("spin") or name:find("lucky") or name:find("daily") then
                            pcall(function()
                                if remote:IsA("RemoteEvent") then
                                    remote:FireServer()
                                    remote:FireServer("Spin")
                                    remote:FireServer("spin")
                                else
                                    remote:InvokeServer()
                                    remote:InvokeServer("Spin")
                                end
                            end)
                        end
                    end
                end
                local playerGui = Player:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local name = gui.Name:lower()
                            if name:find("spin") or name:find("wheel") or name:find("lucky") then
                                pcall(function()
                                    firesignal(gui.MouseButton1Click)
                                end)
                            end
                        end
                    end
                end
            end)
            task.wait(3)
        end
    end)
end

function Features.AutoSpinWheel:Stop()
    self.Enabled = false
end

function Features.AutoCollectPlaytime:Start()
    if self.Enabled then return end
    self.Enabled = true
    task.spawn(function()
        while self.Enabled do
            pcall(function()
                -- Try to find and click playtime reward buttons
                local playerGui = Player:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local name = gui.Name:lower()
                            local parentName = gui.Parent and gui.Parent.Name:lower() or ""
                            local grandParentName = gui.Parent and gui.Parent.Parent and gui.Parent.Parent.Name:lower() or ""
                            if name:find("playtime") or name:find("reward") or name:find("claim") or name:find("collect") or
                               parentName:find("playtime") or parentName:find("reward") or
                               grandParentName:find("playtime") or grandParentName:find("reward") then
                                pcall(function()
                                    firesignal(gui.MouseButton1Click)
                                end)
                            end
                        end
                    end
                end
                -- Try remote events for playtime rewards
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                        local name = remote.Name:lower()
                        if name:find("playtime") or name:find("reward") or name:find("claim") or name:find("collect") then
                            pcall(function()
                                if remote:IsA("RemoteEvent") then
                                    remote:FireServer()
                                    remote:FireServer("Claim")
                                    remote:FireServer("claim")
                                    remote:FireServer("Collect")
                                else
                                    remote:InvokeServer()
                                    remote:InvokeServer("Claim")
                                    remote:InvokeServer("Collect")
                                end
                            end)
                        end
                    end
                end
            end)
            task.wait(5)
        end
    end)
end

function Features.AutoCollectPlaytime:Stop()
    self.Enabled = false
end

local function storeOriginalLighting()
    if next(OriginalLighting) == nil then
        OriginalLighting.ClockTime = Lighting.ClockTime
        OriginalLighting.Brightness = Lighting.Brightness
        OriginalLighting.Ambient = Lighting.Ambient
        OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        OriginalLighting.FogColor = Lighting.FogColor
        OriginalLighting.FogEnd = Lighting.FogEnd
        OriginalLighting.FogStart = Lighting.FogStart
        OriginalLighting.ColorShift_Top = Lighting.ColorShift_Top
        OriginalLighting.ColorShift_Bottom = Lighting.ColorShift_Bottom
    end
end

local function restoreOriginalLighting()
    if next(OriginalLighting) ~= nil then
        Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.FogColor = OriginalLighting.FogColor
        Lighting.FogEnd = OriginalLighting.FogEnd
        Lighting.FogStart = OriginalLighting.FogStart
        Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
        Lighting.ColorShift_Bottom = OriginalLighting.ColorShift_Bottom
    end
end

function Features.Rain:Start()
    if self.Enabled then return end
    self.Enabled = true
    storeOriginalLighting()
    Lighting.ClockTime = 18
    Lighting.Brightness = 0.5
    Lighting.Ambient = Color3.fromRGB(50, 50, 60)
    Lighting.OutdoorAmbient = Color3.fromRGB(60, 60, 70)
    Lighting.FogColor = Color3.fromRGB(80, 85, 95)
    Lighting.FogEnd = 500
    Lighting.FogStart = 50
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "RainEffects_Reaper"
    self.Folder.Parent = workspace
    local rainPart = Instance.new("Part")
    rainPart.Name = "RainEmitter"
    rainPart.Anchored = true
    rainPart.CanCollide = false
    rainPart.Transparency = 1
    rainPart.Size = Vector3.new(200, 1, 200)
    rainPart.Parent = self.Folder
    local rainEmitter = Instance.new("ParticleEmitter")
    rainEmitter.Name = "Rain"
    rainEmitter.Texture = "rbxassetid://3419930363"
    rainEmitter.Rate = 500
    rainEmitter.Lifetime = NumberRange.new(1, 2)
    rainEmitter.Speed = NumberRange.new(80, 100)
    rainEmitter.SpreadAngle = Vector2.new(5, 5)
    rainEmitter.Rotation = NumberRange.new(0, 0)
    rainEmitter.RotSpeed = NumberRange.new(0, 0)
    rainEmitter.Size = NumberSequence.new(0.1, 0.1)
    rainEmitter.Transparency = NumberSequence.new(0.3, 0.7)
    rainEmitter.Color = ColorSequence.new(Color3.fromRGB(180, 190, 210))
    rainEmitter.EmissionDirection = Enum.NormalId.Bottom
    rainEmitter.Parent = rainPart
    self.Sound = Instance.new("Sound")
    self.Sound.SoundId = SOUND_IDS.Rain
    self.Sound.Volume = 0.5
    self.Sound.Looped = true
    self.Sound.Parent = workspace
    self.Sound:Play()
    self.Connection = RunService.Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            rainPart.CFrame = CFrame.new(Player.Character.HumanoidRootPart.Position + Vector3.new(0, 100, 0))
        end
    end)
end

function Features.Rain:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if self.Folder then
        self.Folder:Destroy()
        self.Folder = nil
    end
    if self.Sound then
        self.Sound:Stop()
        self.Sound:Destroy()
        self.Sound = nil
    end
    if not Features.Snow.Enabled and not Features.Thunderstorm.Enabled and not Features.Aurora.Enabled and not Features.MoonGlow.Enabled then
        restoreOriginalLighting()
    end
end

function Features.Snow:Start()
    if self.Enabled then return end
    self.Enabled = true
    storeOriginalLighting()
    Lighting.ClockTime = 12
    Lighting.Brightness = 1.5
    Lighting.Ambient = Color3.fromRGB(200, 210, 230)
    Lighting.OutdoorAmbient = Color3.fromRGB(220, 230, 250)
    Lighting.FogColor = Color3.fromRGB(240, 245, 255)
    Lighting.FogEnd = 800
    Lighting.FogStart = 100
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "SnowEffects_Reaper"
    self.Folder.Parent = workspace
    local snowPart = Instance.new("Part")
    snowPart.Name = "SnowEmitter"
    snowPart.Anchored = true
    snowPart.CanCollide = false
    snowPart.Transparency = 1
    snowPart.Size = Vector3.new(200, 1, 200)
    snowPart.Parent = self.Folder
    local snowEmitter = Instance.new("ParticleEmitter")
    snowEmitter.Name = "Snow"
    snowEmitter.Texture = "rbxassetid://243660364"
    snowEmitter.Rate = 200
    snowEmitter.Lifetime = NumberRange.new(5, 8)
    snowEmitter.Speed = NumberRange.new(10, 20)
    snowEmitter.SpreadAngle = Vector2.new(30, 30)
    snowEmitter.Rotation = NumberRange.new(0, 360)
    snowEmitter.RotSpeed = NumberRange.new(-50, 50)
    snowEmitter.Size = NumberSequence.new(0.2, 0.4)
    snowEmitter.Transparency = NumberSequence.new(0, 0.5)
    snowEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    snowEmitter.EmissionDirection = Enum.NormalId.Bottom
    snowEmitter.Parent = snowPart
    self.Sound = Instance.new("Sound")
    self.Sound.SoundId = SOUND_IDS.Wind
    self.Sound.Volume = 0.3
    self.Sound.Looped = true
    self.Sound.Parent = workspace
    self.Sound:Play()
    self.Connection = RunService.Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            snowPart.CFrame = CFrame.new(Player.Character.HumanoidRootPart.Position + Vector3.new(0, 80, 0))
        end
    end)
end

function Features.Snow:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if self.Folder then
        self.Folder:Destroy()
        self.Folder = nil
    end
    if self.Sound then
        self.Sound:Stop()
        self.Sound:Destroy()
        self.Sound = nil
    end
    if not Features.Rain.Enabled and not Features.Thunderstorm.Enabled and not Features.Aurora.Enabled and not Features.MoonGlow.Enabled then
        restoreOriginalLighting()
    end
end

function Features.Thunderstorm:Start()
    if self.Enabled then return end
    self.Enabled = true
    if not Features.Rain.Enabled then
        Features.Rain:Start()
    end
    self.Sound = Instance.new("Sound")
    self.Sound.SoundId = SOUND_IDS.Thunder
    self.Sound.Volume = 0.8
    self.Sound.Looped = false
    self.Sound.Parent = workspace
    local flash = Instance.new("ColorCorrectionEffect")
    flash.Name = "LightningFlash"
    flash.Brightness = 0
    flash.Parent = Lighting
    self.Connection = task.spawn(function()
        while self.Enabled do
            task.wait(math.random(5, 15))
            if self.Enabled then
                flash.Brightness = 2
                self.Sound:Play()
                task.wait(0.1)
                flash.Brightness = 0
                task.wait(0.05)
                flash.Brightness = 1.5
                task.wait(0.1)
                flash.Brightness = 0
            end
        end
    end)
end

function Features.Thunderstorm:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if self.Sound then
        self.Sound:Stop()
        self.Sound:Destroy()
        self.Sound = nil
    end
    local flash = Lighting:FindFirstChild("LightningFlash")
    if flash then flash:Destroy() end
    if Features.Rain.Enabled then
        Features.Rain:Stop()
    end
end

function Features.Aurora:Start()
    if self.Enabled then return end
    self.Enabled = true
    storeOriginalLighting()
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.4
    Lighting.Ambient = Color3.fromRGB(15, 25, 45)
    Lighting.OutdoorAmbient = Color3.fromRGB(25, 40, 65)
    Lighting.ColorShift_Top = Color3.fromRGB(30, 60, 100)
    Lighting.ColorShift_Bottom = Color3.fromRGB(20, 40, 70)
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "AuroraEffects_Reaper"
    self.Folder.Parent = workspace
    local auroraParts = {}
    for i = 1, 15 do
        local part = Instance.new("Part")
        part.Name = "Aurora_" .. i
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Transparency = 0.4
        part.Size = Vector3.new(math.random(100, 250), math.random(200, 500), 10)
        part.CFrame = CFrame.new(math.random(-500, 500), math.random(300, 550), math.random(-500, 500)) * CFrame.Angles(0, math.rad(math.random(0, 360)), math.rad(math.random(-20, 20)))
        part.Parent = self.Folder
        table.insert(auroraParts, {
            part = part,
            phase = math.random() * math.pi * 2,
            colorPhase = math.random() * math.pi * 2
        })
    end
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "AuroraBloom"
    bloom.Intensity = 2
    bloom.Size = 50
    bloom.Threshold = 0.6
    bloom.Parent = Lighting
    local time = 0
    self.Connection = RunService.Heartbeat:Connect(function(dt)
        time = time + dt
        for _, data in ipairs(auroraParts) do
            local part = data.part
            if part and part.Parent then
                local wave = math.sin(time * 0.3 + data.phase) * 20
                part.CFrame = part.CFrame * CFrame.new(0, wave * dt, 0)
                local hue = (math.sin(time * 0.15 + data.colorPhase) + 1) / 2 * 0.4 + 0.35
                part.Color = Color3.fromHSV(hue, 0.85, 1)
                part.Transparency = 0.3 + math.sin(time * 1.5 + data.phase) * 0.2
            end
        end
    end)
end

function Features.Aurora:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    if self.Folder then
        self.Folder:Destroy()
        self.Folder = nil
    end
    local bloom = Lighting:FindFirstChild("AuroraBloom")
    if bloom then bloom:Destroy() end
    if not Features.Rain.Enabled and not Features.Snow.Enabled and not Features.Thunderstorm.Enabled and not Features.MoonGlow.Enabled then
        restoreOriginalLighting()
    end
end

function Features.MoonGlow:Start()
    if self.Enabled then return end
    self.Enabled = true
    storeOriginalLighting()
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.6
    Lighting.Ambient = Color3.fromRGB(35, 45, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(45, 55, 85)
    Lighting.ColorShift_Top = Color3.fromRGB(50, 70, 110)
    Lighting.ColorShift_Bottom = Color3.fromRGB(40, 55, 90)
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "MoonBloom"
    bloom.Intensity = 2.5
    bloom.Size = 60
    bloom.Threshold = 0.5
    bloom.Parent = Lighting
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "MoonAtmosphere"
    atmo.Density = 0.25
    atmo.Color = Color3.fromRGB(45, 55, 90)
    atmo.Decay = Color3.fromRGB(35, 45, 80)
    atmo.Haze = 1.2
    atmo.Parent = Lighting
end

function Features.MoonGlow:Stop()
    self.Enabled = false
    local bloom = Lighting:FindFirstChild("MoonBloom")
    if bloom then bloom:Destroy() end
    local atmo = Lighting:FindFirstChild("MoonAtmosphere")
    if atmo then atmo:Destroy() end
    if not Features.Rain.Enabled and not Features.Snow.Enabled and not Features.Thunderstorm.Enabled and not Features.Aurora.Enabled then
        restoreOriginalLighting()
    end
end

local MainTab = CreateTab("Main", "[M]")
local PlayTab = CreateTab("Play", "[P]")
local ESPTab = CreateTab("ESP", "[E]")
local RollTab = CreateTab("Roll", "[R]")
local PingFPSTab = CreateTab("Ping | FPS", "[F]")
local ShadersTab = CreateTab("Shaders", "[S]")
local MiscTab = CreateTab("Misc", "[+]")

local CombatSection = MainTab:AddSection("Combat")
CombatSection:AddToggle({Title = "Auto Parry", Default = false, Callback = function(state) if state then Features.AutoParry:Start() else Features.AutoParry:Stop() end end})
CombatSection:AddDropdown({Title = "Parry Mode", Options = {"Normal", "Rage", "Smooth"}, Default = "Normal", Callback = function(value) Features.AutoParry:SetMode(value) end})
CombatSection:AddSlider({Title = "Parry Timing", Min = 25, Max = 150, Default = 75, Callback = function(value) Features.AutoParry:SetDistance(value / 100) end})
CombatSection:AddToggle({Title = "Manual Spam", Default = false, Callback = function(state) if state then Features.ManualSpam:Start() else Features.ManualSpam:Stop() end end})
CombatSection:AddToggle({Title = "Auto Use Ability", Default = false, Callback = function(state) if state then Features.AutoUseAbility:Start() else Features.AutoUseAbility:Stop() end end})

local HitboxSection = MainTab:AddSection("Hitbox")
HitboxSection:AddToggle({Title = "Hitbox Expander", Default = false, Callback = function(state) if state then Features.HitboxExpander:Start() else Features.HitboxExpander:Stop() end end})
HitboxSection:AddSlider({Title = "Hitbox Size", Min = 5, Max = 20, Default = 10, Callback = function(value) Features.HitboxExpander.Size = value end})

local MovementSection = PlayTab:AddSection("Movement")
MovementSection:AddToggle({Title = "Speed Boost", Default = false, Callback = function(state) if state then Features.Speed:Start() else Features.Speed:Stop() end end})
MovementSection:AddSlider({Title = "Speed Value", Min = 16, Max = 100, Default = 50, Callback = function(value) StoredSpeedValue = value Features.Speed:Update() end})
MovementSection:AddToggle({Title = "Jump Boost", Default = false, Callback = function(state) if state then Features.Jump:Start() else Features.Jump:Stop() end end})
MovementSection:AddSlider({Title = "Jump Power", Min = 50, Max = 200, Default = 100, Callback = function(value) StoredJumpValue = value Features.Jump:Update() end})
MovementSection:AddToggle({Title = "Infinite Jump", Default = false, Callback = function(state) if state then Features.InfiniteJump:Start() else Features.InfiniteJump:Stop() end end})
MovementSection:AddToggle({Title = "Noclip", Default = false, Callback = function(state) if state then Features.Noclip:Start() else Features.Noclip:Stop() end end})

local AutoSection = PlayTab:AddSection("Auto Play")
AutoSection:AddToggle({Title = "Auto Play", Default = false, Callback = function(state) Features.AutoPlay.Enabled = state end})
AutoSection:AddDropdown({Title = "Play Style", Options = {"Aggressive", "Balanced", "Defensive"}, Default = "Balanced", Callback = function(value) Features.AutoPlay.Style = value end})

local ESPSection = ESPTab:AddSection("ESP Options")
ESPSection:AddToggle({Title = "Ball ESP", Default = false, Callback = function(state) if state then Features.BallESP:Start() else Features.BallESP:Stop() end end})
ESPSection:AddToggle({Title = "Player ESP", Default = false, Callback = function(state) if state then Features.ESP:Start() else Features.ESP:Stop() end end})
ESPSection:AddButton({Title = "Refresh All ESP", Callback = function()
    if Features.ESP.Enabled then Features.ESP:Stop() task.wait(0.1) Features.ESP:Start() end
    if Features.BallESP.Enabled then Features.BallESP:Stop() task.wait(0.1) Features.BallESP:Start() end
end})

local VisualsSection = ESPTab:AddSection("Visuals")
VisualsSection:AddToggle({Title = "Fullbright", Default = false, Callback = function(state) if state then Features.Fullbright:Start() else Features.Fullbright:Stop() end end})

local SwordCrateSection = RollTab:AddSection("SWORD CRATES")
SwordCrateSection:AddToggle({Title = "Auto Buy Sword Crate", Default = false, Callback = function(state) if state then Features.AutoBuySwordCrate:Start() else Features.AutoBuySwordCrate:Stop() end end})
SwordCrateSection:AddLabel("Automatically purchases sword crates")

local ExplosionCrateSection = RollTab:AddSection("EXPLOSION CRATES")
ExplosionCrateSection:AddToggle({Title = "Auto Buy Explosion Crate", Default = false, Callback = function(state) if state then Features.AutoBuyExplosionCrate:Start() else Features.AutoBuyExplosionCrate:Stop() end end})
ExplosionCrateSection:AddLabel("Automatically purchases explosion crates")

local WheelSection = RollTab:AddSection("Wheel")
WheelSection:AddToggle({Title = "Auto Spin Wheel", Default = false, Callback = function(state) if state then Features.AutoSpinWheel:Start() else Features.AutoSpinWheel:Stop() end end})
WheelSection:AddLabel("Automatically spins the lucky wheel")

local PlaytimeSection = RollTab:AddSection("PLAYTIME REWARDS")
PlaytimeSection:AddToggle({Title = "Auto Collect Playtime", Default = false, Callback = function(state) if state then Features.AutoCollectPlaytime:Start() else Features.AutoCollectPlaytime:Stop() end end})
PlaytimeSection:AddLabel("Automatically collects playtime rewards")

local PerformanceSection = PingFPSTab:AddSection("Performance")
local fpsLabel = PerformanceSection:AddLabel("FPS: Calculating...")
local pingLabel = PerformanceSection:AddLabel("Ping: Calculating...")

task.spawn(function()
    while true do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            fpsLabel:Set("FPS: " .. fps)
            local ping = math.floor(Player:GetNetworkPing() * 1000)
            pingLabel:Set("Ping: " .. ping .. " ms")
        end)
        task.wait(0.5)
    end
end)

local BoosterSection = PingFPSTab:AddSection("FPS Booster")
BoosterSection:AddToggle({Title = "FPS Booster", Default = false, Callback = function(state) 
    if state then 
        Features.FPSBooster:Start() 
    else 
        Features.FPSBooster:Stop() 
    end 
end})
BoosterSection:AddLabel("Reduces graphics quality for better FPS")
BoosterSection:AddLabel("Disables particles, shadows, effects")

local NetworkSection = PingFPSTab:AddSection("Network Info")
NetworkSection:AddLabel("Server: " .. (game.JobId ~= "" and string.sub(game.JobId, 1, 15) .. "..." or "N/A"))
NetworkSection:AddLabel("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)

local WeatherSection = ShadersTab:AddSection("Weather Effects")
WeatherSection:AddToggle({Title = "Rain", Default = false, Callback = function(state) if state then Features.Rain:Start() else Features.Rain:Stop() end end})
WeatherSection:AddToggle({Title = "Snow", Default = false, Callback = function(state) if state then Features.Snow:Start() else Features.Snow:Stop() end end})
WeatherSection:AddToggle({Title = "Thunderstorm", Default = false, Callback = function(state) if state then Features.Thunderstorm:Start() else Features.Thunderstorm:Stop() end end})

local SkySection = ShadersTab:AddSection("Sky Effects")
SkySection:AddToggle({Title = "Aurora Borealis", Default = false, Callback = function(state) if state then Features.Aurora:Start() else Features.Aurora:Stop() end end})
SkySection:AddToggle({Title = "Moon Glow", Default = false, Callback = function(state) if state then Features.MoonGlow:Start() else Features.MoonGlow:Stop() end end})

local ShaderInfoSection = ShadersTab:AddSection("Info")
ShaderInfoSection:AddLabel("Shaders include sounds and effects")
ShaderInfoSection:AddLabel("Multiple shaders can be combined")
ShaderInfoSection:AddButton({Title = "Reset All Shaders", Callback = function()
    Features.Rain:Stop()
    Features.Snow:Stop()
    Features.Thunderstorm:Stop()
    Features.Aurora:Stop()
    Features.MoonGlow:Stop()
    restoreOriginalLighting()
end})

local UtilSection = MiscTab:AddSection("Utility")
UtilSection:AddToggle({Title = "Anti-AFK", Default = true, Callback = function(state) Features.AntiAFK.Enabled = state end})
UtilSection:AddButton({Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end})
UtilSection:AddButton({Title = "Copy Discord Link", Callback = function()
    pcall(function()
        if setclipboard then
            setclipboard(DISCORD_INVITE)
        elseif toclipboard then
            toclipboard(DISCORD_INVITE)
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

print("[R] REAPER HUB | BLADEBALL V2")
print("[+] Discord: " .. DISCORD_INVITE)
