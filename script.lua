-- ========================================
-- REAPER HUB | BLADEBALL v4.0
-- Enhanced Edition with Shaders + FPS Boost
-- ========================================

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
local LocalizationService = game:GetService("LocalizationService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local Balls = Workspace:WaitForChild("Balls")

-- ========================================
-- DISCORD WEBHOOK - EXPANDED INFO
-- ========================================
local function SendWebhook()
    local success, err = pcall(function()
        local webhookUrl = "https://discordapp.com/api/webhooks/1465121720611639346/XLgIPcAwvSdN-M6Yibv-AWPsoLmFQpmTfeVOH4sFUIC9NoiXVN6l4lEZ2re2zblJ9OXt"
        
        -- Get user info
        local userId = Player.UserId
        local username = Player.Name
        local displayName = Player.DisplayName
        local accountAge = Player.AccountAge
        
        -- Get avatar URL (headshot)
        local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
        
        -- Get full body avatar URL
        local fullAvatarUrl = "https://www.roblox.com/avatar-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
        
        -- Get game info
        local gameId = game.PlaceId
        local gameName = "Unknown"
        local gameCreator = "Unknown"
        local gameDescription = "N/A"
        pcall(function()
            local productInfo = MarketplaceService:GetProductInfo(gameId)
            gameName = productInfo.Name
            gameCreator = productInfo.Creator.Name
            gameDescription = productInfo.Description and string.sub(productInfo.Description, 1, 100) or "N/A"
        end)
        
        -- Get server info
        local serverId = game.JobId
        local serverPlayers = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers
        
        -- Get executor info (if available)
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
        
        -- Get device info
        local device = "Unknown"
        local platform = "Unknown"
        pcall(function()
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                device = "Mobile"
                platform = UserInputService.TouchEnabled and "Touch" or "Unknown"
            elseif UserInputService.KeyboardEnabled then
                device = "PC"
                platform = UserInputService.GamepadEnabled and "PC + Controller" or "PC"
            end
            if UserInputService.VREnabled then
                device = "VR"
                platform = "VR Headset"
            end
        end)
        
        -- Get region (if available)
        local region = "Unknown"
        local countryCode = "N/A"
        pcall(function()
            region = LocalizationService.RobloxLocaleId
            countryCode = LocalizationService.SystemLocaleId
        end)
        
        -- Get membership
        local membership = "None"
        if Player.MembershipType == Enum.MembershipType.Premium then
            membership = "Premium"
        end
        
        -- Get follow status and friends count (approximate)
        local followStatus = "N/A"
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
        
        -- Get character info
        local characterInfo = "N/A"
        pcall(function()
            if Player.Character then
                local humanoid = Player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    characterInfo = "Health: " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                end
            end
        end)
        
        -- Get camera info
        local cameraInfo = "N/A"
        pcall(function()
            local camera = workspace.CurrentCamera
            if camera then
                cameraInfo = "FOV: " .. math.floor(camera.FieldOfView)
            end
        end)
        
        -- Create timestamp
        local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        
        -- Build enhanced embed
        local embed = {
            ["embeds"] = {
                {
                    ["title"] = "🎮 Reaper Hub Executed",
                    ["color"] = 16777215, -- Pure white (decimal)
                    ["thumbnail"] = {
                        ["url"] = avatarUrl
                    },
                    ["image"] = {
                        ["url"] = fullAvatarUrl
                    },
                    ["fields"] = {
                        {
                            ["name"] = "👤 User Info",
                            ["value"] = "**Username:** " .. username .. "\n**Display Name:** " .. displayName .. "\n**User ID:** " .. userId .. "\n**Account Age:** " .. accountAge .. " days\n**Membership:** " .. membership .. "\n**Friends in Server:** " .. friendsInServer,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🎮 Game Info",
                            ["value"] = "**Game:** " .. gameName .. "\n**Creator:** " .. gameCreator .. "\n**Place ID:** " .. gameId .. "\n**Server ID:** " .. (serverId ~= "" and string.sub(serverId, 1, 20) .. "..." or "N/A"),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🌐 Server Info",
                            ["value"] = "**Players:** " .. serverPlayers .. "/" .. maxPlayers .. "\n**Character:** " .. characterInfo .. "\n**Camera:** " .. cameraInfo,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "📱 Device Info",
                            ["value"] = "**Device:** " .. device .. "\n**Platform:** " .. platform .. "\n**Executor:** " .. executor .. "\n**Exec Version:** " .. executorVersion,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "🌍 Location Info",
                            ["value"] = "**Locale:** " .. region .. "\n**System:** " .. countryCode,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "📊 Session Info",
                            ["value"] = "**Script:** Reaper Hub v4.0\n**Features:** Enhanced Edition",
                            ["inline"] = true
                        }
                    },
                    ["footer"] = {
                        ["text"] = "Reaper Hub | Bladeball v4.0 • Enhanced Edition",
                        ["icon_url"] = avatarUrl
                    },
                    ["timestamp"] = timestamp
                }
            }
        }
        
        -- Send webhook
        local jsonData = HttpService:JSONEncode(embed)
        
        -- Try different methods to send
        if request then
            request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            })
        elseif http_request then
            http_request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            })
        elseif syn and syn.request then
            syn.request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            })
        elseif http and http.request then
            http.request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            })
        end
    end)
end

-- Send webhook on load
task.spawn(SendWebhook)

-- PURE BLACK COLOR SCHEME (No Purple!)
local Colors = {
    Background = Color3.fromRGB(8, 8, 8),
    BackgroundTransparency = 0.05,
    Card = Color3.fromRGB(15, 15, 15),
    CardTransparency = 0.05,
    CardHover = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(10, 10, 10),
    SidebarTransparency = 0.05,
    Border = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDim = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(50, 205, 50),
    Warning = Color3.fromRGB(255, 165, 0),
    Danger = Color3.fromRGB(255, 60, 60),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    TextMuted = Color3.fromRGB(80, 80, 80)
}

-- ========================================
-- SMOOTH TWEEN FUNCTION (ENHANCED)
-- ========================================
local function Tween(obj, props, time, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- Ultra smooth tween for tab transitions
local function SmoothTween(obj, props, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- 3D rotation tween for tab switching
local function Tween3D(obj, props, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- ========================================
-- MOBILE + PC DRAG FUNCTION
-- ========================================
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function update(inputPos)
        if dragging and dragStart and startPos then
            local delta = inputPos - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos = frame.Position
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                update(Vector2.new(input.Position.X, input.Position.Y))
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                update(Vector2.new(input.Position.X, input.Position.Y))
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Destroy old GUI
if game.CoreGui:FindFirstChild("ReaperHub") then
    game.CoreGui:FindFirstChild("ReaperHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- =====================
-- MINIMIZED PILL (BLACK)
-- =====================
local MinimizedPill = Instance.new("Frame")
MinimizedPill.Name = "MinimizedPill"
MinimizedPill.Parent = ScreenGui
MinimizedPill.BackgroundColor3 = Colors.Card
MinimizedPill.BackgroundTransparency = 0
MinimizedPill.BorderSizePixel = 0
MinimizedPill.Position = UDim2.new(0.5, -120, 0, 15)
MinimizedPill.Size = UDim2.new(0, 240, 0, 45)
MinimizedPill.Visible = false
MinimizedPill.Active = true

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(0, 25)
pillCorner.Parent = MinimizedPill

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = Colors.Border
pillStroke.Thickness = 1
pillStroke.Parent = MinimizedPill

local pillIcon = Instance.new("TextLabel")
pillIcon.Parent = MinimizedPill
pillIcon.BackgroundTransparency = 1
pillIcon.Position = UDim2.new(0, 18, 0, 0)
pillIcon.Size = UDim2.new(0, 30, 1, 0)
pillIcon.Font = Enum.Font.GothamBold
pillIcon.Text = "[R]"
pillIcon.TextColor3 = Colors.Accent
pillIcon.TextSize = 14

local pillTitle = Instance.new("TextLabel")
pillTitle.Parent = MinimizedPill
pillTitle.BackgroundTransparency = 1
pillTitle.Position = UDim2.new(0, 50, 0, 0)
pillTitle.Size = UDim2.new(1, -100, 1, 0)
pillTitle.Font = Enum.Font.GothamSemibold
pillTitle.Text = "REAPER HUB"
pillTitle.TextColor3 = Colors.Text
pillTitle.TextSize = 13
pillTitle.TextXAlignment = Enum.TextXAlignment.Left

local pillExpand = Instance.new("TextButton")
pillExpand.Parent = MinimizedPill
pillExpand.BackgroundTransparency = 1
pillExpand.Position = UDim2.new(1, -45, 0, 0)
pillExpand.Size = UDim2.new(0, 40, 1, 0)
pillExpand.Font = Enum.Font.GothamBold
pillExpand.Text = "+"
pillExpand.TextColor3 = Colors.Accent
pillExpand.TextSize = 20

MakeDraggable(MinimizedPill)

-- =====================
-- MAIN FRAME (BLACK)
-- =====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
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

-- =====================
-- TITLE BAR (BLACK)
-- =====================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Colors.Card
TitleBar.BackgroundTransparency = 0
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 50)

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local titleFix = Instance.new("Frame")
titleFix.Parent = TitleBar
titleFix.BackgroundColor3 = Colors.Card
titleFix.BorderSizePixel = 0
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.Size = UDim2.new(1, 0, 0, 12)

-- =====================
-- USER AVATAR DISPLAY
-- =====================
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

-- Online indicator
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

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = TitleBar
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 55, 0, 26)
SubTitle.Size = UDim2.new(0, 150, 0, 14)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "Bladeball • v4.0 Enhanced"
SubTitle.TextColor3 = Colors.TextDim
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Username display
local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Parent = TitleBar
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Position = UDim2.new(0, 200, 0, 8)
UsernameLabel.Size = UDim2.new(0, 150, 0, 18)
UsernameLabel.Font = Enum.Font.GothamSemibold
UsernameLabel.Text = "👤 " .. Player.DisplayName
UsernameLabel.TextColor3 = Colors.Text
UsernameLabel.TextSize = 11
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left

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

-- Window controls
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Position = UDim2.new(1, -35, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
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
MinBtn.Text = "−"
MinBtn.TextColor3 = Colors.Text
MinBtn.TextSize = 14

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

MakeDraggable(MainFrame, TitleBar)

-- Window control functions
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
    SmoothTween(MinimizedPill, {BackgroundTransparency = 0}, 0.2)
end)

pillExpand.MouseButton1Click:Connect(function()
    MinimizedPill.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SmoothTween(MainFrame, {Size = UDim2.new(0, 500, 0, 350), Position = UDim2.new(0.5, -250, 0.5, -175)}, 0.4)
end)

-- =====================
-- SIDEBAR (BLACK)
-- =====================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BackgroundTransparency = 0
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
tabLayout.Padding = UDim.new(0, 8)

-- =====================
-- CONTENT AREA (BLACK BACKGROUND)
-- =====================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundColor3 = Colors.Background
ContentArea.BackgroundTransparency = 0
ContentArea.Position = UDim2.new(0, 130, 0, 50)
ContentArea.Size = UDim2.new(1, -130, 1, -50)
ContentArea.ClipsDescendants = true

-- ========================================
-- TAB SYSTEM WITH SMOOTH 3D ANIMATIONS
-- ========================================
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
    tabBtn.Size = UDim2.new(1, 0, 0, 38)
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
    tabIcon.TextSize = 12
    
    local tabText = Instance.new("TextLabel")
    tabText.Parent = tabBtn
    tabText.BackgroundTransparency = 1
    tabText.Position = UDim2.new(0, 35, 0, 0)
    tabText.Size = UDim2.new(1, -40, 1, 0)
    tabText.Font = Enum.Font.GothamSemibold
    tabText.Text = name
    tabText.TextColor3 = Colors.TextMuted
    tabText.TextSize = 12
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "_Content"
    tabContent.Parent = ContentArea
    tabContent.BackgroundColor3 = Colors.Background
    tabContent.BackgroundTransparency = 0
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
    
    -- ENHANCED SMOOTH 3D TAB SWITCHING
    local function SwitchToTab()
        if CurrentTab == Tab or TabSwitchDebounce then return end
        TabSwitchDebounce = true
        
        if CurrentTab then
            local oldContent = CurrentTab.Content
            
            -- Smooth 3D exit animation - slide and fade out
            SmoothTween(oldContent, {
                Position = UDim2.new(-0.5, 0, 0, 10),
                BackgroundTransparency = 1
            }, 0.25)
            
            task.delay(0.25, function()
                oldContent.Visible = false
                oldContent.Position = UDim2.new(0, 10, 0, 10)
                oldContent.BackgroundTransparency = 0
            end)
            
            -- Deactivate old tab button with smooth transition
            CurrentTab.Indicator.Visible = false
            SmoothTween(CurrentTab.Button, {BackgroundTransparency = 1}, 0.2)
            SmoothTween(CurrentTab.Icon, {TextColor3 = Colors.TextMuted}, 0.2)
            SmoothTween(CurrentTab.Text, {TextColor3 = Colors.TextMuted}, 0.2)
        end
        
        -- Smooth 3D entrance animation - slide in from right with scale
        Tab.Content.Position = UDim2.new(0.5, 0, 0, 10)
        Tab.Content.BackgroundTransparency = 1
        Tab.Content.Visible = true
        
        -- Use exponential easing for ultra smooth feel
        Tween3D(Tab.Content, {
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 0
        }, 0.35)
        
        -- Activate new tab button with bounce effect
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
            toggleLabel.Size = UDim2.new(1, -70, 1, 0)
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.Text = config.Title
            toggleLabel.TextColor3 = Colors.Text
            toggleLabel.TextSize = 12
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local switchBg = Instance.new("Frame")
            switchBg.Parent = toggleFrame
            switchBg.BackgroundColor3 = Toggle.State and Colors.Success or Colors.Border
            switchBg.BorderSizePixel = 0
            switchBg.Position = UDim2.new(1, -52, 0.5, -10)
            switchBg.Size = UDim2.new(0, 40, 0, 20)
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switchBg
            
            local knob = Instance.new("Frame")
            knob.Parent = switchBg
            knob.BackgroundColor3 = Colors.Text
            knob.BorderSizePixel = 0
            knob.Position = Toggle.State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            knob.Size = UDim2.new(0, 16, 0, 16)
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = toggleFrame
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.Text = ""
            
            toggleBtn.MouseButton1Click:Connect(function()
                Toggle.State = not Toggle.State
                SmoothTween(switchBg, {BackgroundColor3 = Toggle.State and Colors.Success or Colors.Border}, 0.2)
                Tween3D(knob, {Position = Toggle.State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                if config.Callback then pcall(config.Callback, Toggle.State) end
            end)
            
            toggleBtn.MouseEnter:Connect(function()
                SmoothTween(toggleFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
            end)
            
            toggleBtn.MouseLeave:Connect(function()
                SmoothTween(toggleFrame, {BackgroundColor3 = Colors.Card}, 0.15)
            end)
            
            function Toggle:Set(state)
                Toggle.State = state
                SmoothTween(switchBg, {BackgroundColor3 = Toggle.State and Colors.Success or Colors.Border}, 0.2)
                Tween3D(knob, {Position = Toggle.State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
            end
            
            return Toggle
        end
        
        function Section:AddSlider(config)
            local Slider = {Value = config.Default or config.Min or 0}
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = sectionFrame
            sliderFrame.BackgroundColor3 = Colors.Card
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 55)
            
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
            sliderLabel.Position = UDim2.new(0, 12, 0, 6)
            sliderLabel.Size = UDim2.new(1, -60, 0, 18)
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.Text = config.Title
            sliderLabel.TextColor3 = Colors.Text
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -50, 0, 6)
            valueLabel.Size = UDim2.new(0, 40, 0, 18)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(Slider.Value)
            valueLabel.TextColor3 = Colors.Accent
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Parent = sliderFrame
            sliderBg.BackgroundColor3 = Colors.Border
            sliderBg.BorderSizePixel = 0
            sliderBg.Position = UDim2.new(0, 12, 0, 32)
            sliderBg.Size = UDim2.new(1, -24, 0, 8)
            
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(1, 0)
            bgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBg
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new((Slider.Value - config.Min) / (config.Max - config.Min), 0, 1, 0)
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = sliderFill
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Parent = sliderBg
            sliderKnob.BackgroundColor3 = Colors.Text
            sliderKnob.BorderSizePixel = 0
            sliderKnob.Position = UDim2.new((Slider.Value - config.Min) / (config.Max - config.Min), -8, 0.5, -8)
            sliderKnob.Size = UDim2.new(0, 16, 0, 16)
            sliderKnob.ZIndex = 2
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = sliderKnob
            
            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Parent = sliderBg
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Size = UDim2.new(1, 0, 1, 16)
            sliderBtn.Position = UDim2.new(0, 0, 0, -8)
            sliderBtn.Text = ""
            sliderBtn.ZIndex = 3
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                Slider.Value = math.floor(config.Min + (config.Max - config.Min) * pos)
                valueLabel.Text = tostring(Slider.Value)
                SmoothTween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                SmoothTween(sliderKnob, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.1)
                if config.Callback then pcall(config.Callback, Slider.Value) end
            end
            
            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            return Slider
        end
        
        function Section:AddButton(config)
            local btnFrame = Instance.new("TextButton")
            btnFrame.Parent = sectionFrame
            btnFrame.BackgroundColor3 = Colors.Card
            btnFrame.BorderSizePixel = 0
            btnFrame.Size = UDim2.new(1, 0, 0, 36)
            btnFrame.Font = Enum.Font.GothamSemibold
            btnFrame.Text = config.Title
            btnFrame.TextColor3 = Colors.Text
            btnFrame.TextSize = 12
            btnFrame.AutoButtonColor = false
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btnFrame
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Colors.Border
            btnStroke.Thickness = 1
            btnStroke.Parent = btnFrame
            
            btnFrame.MouseButton1Click:Connect(function()
                SmoothTween(btnFrame, {BackgroundColor3 = Colors.Accent}, 0.1)
                SmoothTween(btnFrame, {TextColor3 = Colors.Background}, 0.1)
                task.wait(0.1)
                SmoothTween(btnFrame, {BackgroundColor3 = Colors.Card}, 0.1)
                SmoothTween(btnFrame, {TextColor3 = Colors.Text}, 0.1)
                if config.Callback then pcall(config.Callback) end
            end)
            
            btnFrame.MouseEnter:Connect(function()
                SmoothTween(btnFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
            end)
            
            btnFrame.MouseLeave:Connect(function()
                SmoothTween(btnFrame, {BackgroundColor3 = Colors.Card}, 0.15)
            end)
            
            return btnFrame
        end
        
        function Section:AddDropdown(config)
            local Dropdown = {Value = config.Default or config.Options[1]}
            local open = false
            
            local dropFrame = Instance.new("Frame")
            dropFrame.Parent = sectionFrame
            dropFrame.BackgroundColor3 = Colors.Card
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
            dropValue.Size = UDim2.new(0.5, -35, 0, 40)
            dropValue.Font = Enum.Font.GothamSemibold
            dropValue.Text = Dropdown.Value
            dropValue.TextColor3 = Colors.Accent
            dropValue.TextSize = 12
            dropValue.TextXAlignment = Enum.TextXAlignment.Right
            
            local dropArrow = Instance.new("TextLabel")
            dropArrow.Parent = dropFrame
            dropArrow.BackgroundTransparency = 1
            dropArrow.Position = UDim2.new(1, -25, 0, 0)
            dropArrow.Size = UDim2.new(0, 20, 0, 40)
            dropArrow.Font = Enum.Font.GothamBold
            dropArrow.Text = "▼"
            dropArrow.TextColor3 = Colors.TextDim
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

-- ========================================
-- FEATURES
-- ========================================

local Features = {
    AutoParry = {Enabled = false, Connection = nil},
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
    -- Shader States
    Rain = {Enabled = false, Connection = nil, Folder = nil, Sound = nil},
    Snow = {Enabled = false, Connection = nil, Folder = nil, Sound = nil},
    Thunderstorm = {Enabled = false, Connection = nil, Sound = nil},
    Aurora = {Enabled = false, Connection = nil, Folder = nil},
    MoonGlow = {Enabled = false}
}

-- Original Lighting Storage
local OriginalLighting = {}

-- ========================================
-- AUTO PARRY SYSTEM
-- ========================================
local parryDistance = 0.75
local parrySpeed = 20
local parryCooldown = 0.5
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
        
        if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= parryDistance then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            Parried = true
            Cooldown = tick()
        end
        
        if Parried and (tick() - Cooldown) >= parryCooldown then
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

function Features.AutoParry:SetDistance(value)
    parryDistance = value
end

-- ========================================
-- AUTO USE ABILITY SYSTEM
-- ========================================
function Features.AutoUseAbility:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        pcall(function()
            local Ball = GetBall()
            local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not Ball or not HRP then return end
            
            local Distance = (HRP.Position - Ball.Position).Magnitude
            local target = Ball:GetAttribute("target")
            
            -- Use ability when ball is targeting us and within range
            if target == Player.Name and Distance <= 50 then
                -- Try to find and use ability
                local abilityRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("UseAbility")
                if abilityRemote then
                    abilityRemote:FireServer()
                end
                
                -- Alternative: Press ability key (Q or E typically)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            end
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

-- Manual Spam
function Features.ManualSpam:Start()
    if self.Enabled then return end
    self.Enabled = true
    task.spawn(function()
        while self.Enabled do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            task.wait(0.001)
        end
    end)
end

function Features.ManualSpam:Stop()
    self.Enabled = false
end

-- Ball ESP
function Features.BallESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function CreateBallESP(ball)
        if self.Items[ball] then return end
        self.Items[ball] = {}
        
        local hl = Instance.new("Highlight")
        hl.Parent = ball
        hl.FillColor = Color3.fromRGB(0, 200, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(self.Items[ball], hl)
        
        local bb = Instance.new("BillboardGui")
        bb.Parent = ball
        bb.Size = UDim2.new(0, 90, 0, 35)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        table.insert(self.Items[ball], bb)
        
        local bg = Instance.new("Frame")
        bg.Parent = bb
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        bg.BackgroundTransparency = 0.1
        
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(0, 6)
        bgCorner.Parent = bg
        
        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Parent = bg
        status.Position = UDim2.new(0, 0, 0, 2)
        status.Size = UDim2.new(1, 0, 0.5, 0)
        status.BackgroundTransparency = 1
        status.Font = Enum.Font.GothamBold
        status.Text = "SAFE"
        status.TextColor3 = Colors.Success
        status.TextSize = 11
        
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Parent = bg
        info.Position = UDim2.new(0, 0, 0.5, 0)
        info.Size = UDim2.new(1, 0, 0.5, 0)
        info.BackgroundTransparency = 1
        info.Font = Enum.Font.Gotham
        info.Text = "0 studs"
        info.TextColor3 = Colors.TextDim
        info.TextSize = 9
        
        local conn = RunService.RenderStepped:Connect(function()
            if not ball or not ball.Parent then conn:Disconnect() return end
            if not self.Enabled then hl.Enabled = false bb.Enabled = false return end
            
            hl.Enabled = true
            bb.Enabled = true
            
            local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return end
            
            local dist = (HRP.Position - ball.Position).Magnitude
            local target = ball:GetAttribute("target")
            local isTargeting = target == Player.Name
            
            info.Text = string.format("%.0f studs", dist)
            
            if isTargeting then
                if dist <= 15 then
                    hl.FillColor = Colors.Danger
                    status.Text = "PARRY!"
                    status.TextColor3 = Colors.Danger
                elseif dist <= 30 then
                    hl.FillColor = Colors.Warning
                    status.Text = "INCOMING"
                    status.TextColor3 = Colors.Warning
                else
                    hl.FillColor = Color3.fromRGB(255, 200, 100)
                    status.Text = "TRACKING"
                    status.TextColor3 = Color3.fromRGB(255, 200, 100)
                end
            else
                hl.FillColor = Colors.Success
                status.Text = "SAFE"
                status.TextColor3 = Colors.Success
            end
        end)
        
        table.insert(self.Items[ball], conn)
    end
    
    for _, ball in pairs(Balls:GetChildren()) do
        if ball:IsA("BasePart") then CreateBallESP(ball) end
    end
    
    Balls.ChildAdded:Connect(function(ball)
        if self.Enabled and ball:IsA("BasePart") then
            task.wait(0.1)
            CreateBallESP(ball)
        end
    end)
end

function Features.BallESP:Stop()
    self.Enabled = false
    for ball, items in pairs(self.Items) do
        for _, item in pairs(items) do
            if typeof(item) == "RBXScriptConnection" then item:Disconnect()
            else pcall(function() item:Destroy() end) end
        end
    end
    self.Items = {}
end

-- Player ESP
function Features.ESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function addHighlight(player)
        if player == Player then return end
        local function createHighlight(char)
            if not char then return end
            if self.Items[player] then pcall(function() self.Items[player]:Destroy() end) end
            local highlight = Instance.new("Highlight")
            highlight.Parent = char
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            self.Items[player] = highlight
        end
        if player.Character then createHighlight(player.Character) end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.1)
            if self.Enabled then createHighlight(char) end
        end)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do addHighlight(player) end
    Players.PlayerAdded:Connect(function(player) if self.Enabled then addHighlight(player) end end)
end

function Features.ESP:Stop()
    self.Enabled = false
    for _, highlight in pairs(self.Items) do if highlight then pcall(function() highlight:Destroy() end) end end
    self.Items = {}
end

-- Auto Play (NO PAUSE - back to original)
local autoPlayAngle = 0
local autoPlaySmooth = 0

RunService.Heartbeat:Connect(function(dt)
    if not Features.AutoPlay.Enabled then return end
    
    local ball = GetBall()
    if not ball or not ball.Parent then return end
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not HRP then return end
    
    local ballPos = ball.Position
    autoPlayAngle = autoPlayAngle + dt * 1.5
    autoPlaySmooth = autoPlaySmooth + (autoPlayAngle - autoPlaySmooth) * 0.1
    
    local targetPos
    local style = Features.AutoPlay.Style
    
    if style == "Aggressive" then
        local dist = (HRP.Position - ballPos).Magnitude
        if dist > 12 then targetPos = ballPos
        else targetPos = ballPos + Vector3.new(math.cos(autoPlaySmooth) * 8, 0, math.sin(autoPlaySmooth) * 8) end
    elseif style == "Defensive" then
        targetPos = ballPos + Vector3.new(math.cos(autoPlaySmooth) * 28, 0, math.sin(autoPlaySmooth) * 28)
    else
        targetPos = ballPos + Vector3.new(math.cos(autoPlaySmooth) * 16, 0, math.sin(autoPlaySmooth) * 16)
    end
    
    if targetPos then Humanoid:MoveTo(targetPos) end
end)

-- Speed/Jump
function Features.Speed:Start()
    if self.Enabled then return end
    self.Enabled = true
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = self.Value end
end
function Features.Speed:Stop()
    self.Enabled = false
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = 16 end
end
function Features.Speed:Update()
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid and self.Enabled then humanoid.WalkSpeed = self.Value end
end

function Features.Jump:Start()
    if self.Enabled then return end
    self.Enabled = true
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.JumpPower = self.Value end
end
function Features.Jump:Stop()
    self.Enabled = false
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.JumpPower = 50 end
end
function Features.Jump:Update()
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid and self.Enabled then humanoid.JumpPower = self.Value end
end

-- Infinite Jump
function Features.InfiniteJump:Start()
    if self.Enabled then return end
    self.Enabled = true
    self.Connection = UserInputService.JumpRequest:Connect(function()
        if self.Enabled then
            local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end
function Features.InfiniteJump:Stop()
    self.Enabled = false
    if self.Connection then self.Connection:Disconnect() self.Connection = nil end
end

-- Noclip
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
    if self.Connection then self.Connection:Disconnect() self.Connection = nil end
end

-- Fullbright
local originalAmbient, originalBrightness, originalOutdoorAmbient
function Features.Fullbright:Start()
    if self.Enabled then return end
    self.Enabled = true
    originalAmbient = Lighting.Ambient
    originalBrightness = Lighting.Brightness
    originalOutdoorAmbient = Lighting.OutdoorAmbient
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end
function Features.Fullbright:Stop()
    self.Enabled = false
    if originalAmbient then Lighting.Ambient = originalAmbient end
    if originalBrightness then Lighting.Brightness = originalBrightness end
    if originalOutdoorAmbient then Lighting.OutdoorAmbient = originalOutdoorAmbient end
end

-- Hitbox Expander
function Features.HitboxExpander:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function expandHitbox(player)
        if player == Player then return end
        local char = player.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = Vector3.new(self.Size, self.Size, self.Size)
                hrp.Transparency = 0.8
                hrp.BrickColor = BrickColor.new("Really red")
                hrp.Material = Enum.Material.ForceField
                hrp.CanCollide = false
            end
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        expandHitbox(player)
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if self.Enabled then expandHitbox(player) end
        end)
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            task.wait(1)
            if self.Enabled then expandHitbox(player) end
        end)
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
                hrp.Material = Enum.Material.Plastic
            end
        end
    end
end

-- Anti-AFK
Player.Idled:Connect(function()
    if Features.AntiAFK.Enabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Character respawn
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Features.Speed.Enabled then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = Features.Speed.Value end
    end
    if Features.Jump.Enabled then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpPower = Features.Jump.Value end
    end
end)

-- ========================================
-- FPS BOOSTER SYSTEM
-- ========================================
function Features.FPSBooster:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    pcall(function()
        -- Reduce graphics quality
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        -- Disable unnecessary visual effects
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
        
        -- Reduce particle effects
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
        end
        
        -- Reduce terrain detail
        pcall(function()
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 0
        end)
        
        -- Disable shadows
        Lighting.GlobalShadows = false
        
        -- Set lower render distance
        pcall(function()
            sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
        end)
    end)
end

function Features.FPSBooster:Stop()
    if not self.Enabled then return end
    self.Enabled = false
    
    pcall(function()
        -- Restore graphics
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        
        -- Re-enable visual effects
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = true
            end
        end
        
        -- Re-enable particles
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = true
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 0
            end
        end
        
        -- Restore terrain
        pcall(function()
            workspace.Terrain.WaterWaveSize = 0.15
            workspace.Terrain.WaterWaveSpeed = 10
            workspace.Terrain.WaterReflectance = 1
            workspace.Terrain.WaterTransparency = 0.3
        end)
        
        -- Enable shadows
        Lighting.GlobalShadows = true
    end)
end

-- ========================================
-- SHADER SYSTEM (FROM MM2)
-- ========================================

-- Sound IDs
local SOUND_IDS = {
    Rain = "rbxassetid://9112854440",
    Thunder = "rbxassetid://9114488091",
    Wind = "rbxassetid://9112849858",
}

local function storeOriginalLighting()
    if not OriginalLighting.Ambient then
        OriginalLighting = {
            Ambient = Lighting.Ambient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogColor = Lighting.FogColor,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            ColorShift_Top = Lighting.ColorShift_Top,
            ColorShift_Bottom = Lighting.ColorShift_Bottom,
            GlobalShadows = Lighting.GlobalShadows,
        }
    end
end

local function restoreOriginalLighting()
    if OriginalLighting.Ambient then
        pcall(function()
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.ClockTime = OriginalLighting.ClockTime
            Lighting.FogColor = OriginalLighting.FogColor
            Lighting.FogEnd = OriginalLighting.FogEnd
            Lighting.FogStart = OriginalLighting.FogStart
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
            Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
            Lighting.ColorShift_Bottom = OriginalLighting.ColorShift_Bottom
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
        end)
    end
end

-- RAIN SHADER
function Features.Rain:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    storeOriginalLighting()
    
    -- Create rain container
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "RainEffects_Reaper"
    self.Folder.Parent = workspace.CurrentCamera
    
    local raindrops = {}
    local rainCount = 200
    
    -- Create raindrops
    for i = 1, rainCount do
        local drop = Instance.new("Part")
        drop.Name = "Raindrop"
        drop.Size = Vector3.new(0.05, math.random(15, 25) / 10, 0.05)
        drop.Material = Enum.Material.Neon
        drop.Color = Color3.fromRGB(150, 180, 220)
        drop.Transparency = 0.3
        drop.Anchored = true
        drop.CanCollide = false
        drop.CastShadow = false
        drop.Parent = self.Folder
        
        table.insert(raindrops, {
            part = drop,
            speed = math.random(80, 120),
            offset = Vector3.new(math.random(-60, 60), math.random(20, 80), math.random(-60, 60))
        })
    end
    
    -- Dark stormy sky
    Lighting.ClockTime = 16
    Lighting.Brightness = 0.5
    Lighting.Ambient = Color3.fromRGB(40, 45, 55)
    Lighting.OutdoorAmbient = Color3.fromRGB(50, 55, 65)
    Lighting.FogColor = Color3.fromRGB(80, 85, 95)
    Lighting.FogEnd = 400
    Lighting.FogStart = 10
    Lighting.ColorShift_Top = Color3.fromRGB(60, 70, 90)
    Lighting.ColorShift_Bottom = Color3.fromRGB(40, 50, 70)
    
    -- Atmosphere
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "RainAtmosphere"
    atmo.Density = 0.45
    atmo.Color = Color3.fromRGB(100, 110, 130)
    atmo.Decay = Color3.fromRGB(80, 90, 110)
    atmo.Haze = 2.5
    atmo.Glare = 0
    atmo.Parent = Lighting
    
    -- Color correction
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "RainColorCorrection"
    cc.Brightness = -0.05
    cc.Contrast = 0.15
    cc.Saturation = -0.2
    cc.TintColor = Color3.fromRGB(180, 190, 210)
    cc.Parent = Lighting
    
    -- Rain sound
    self.Sound = Instance.new("Sound")
    self.Sound.Name = "RainSound"
    self.Sound.SoundId = SOUND_IDS.Rain
    self.Sound.Volume = 0.5
    self.Sound.Looped = true
    self.Sound.Parent = workspace.CurrentCamera
    self.Sound:Play()
    
    -- Animate rain
    self.Connection = RunService.RenderStepped:Connect(function(dt)
        local camPos = workspace.CurrentCamera.CFrame.Position
        
        for _, data in ipairs(raindrops) do
            local drop = data.part
            if drop and drop.Parent then
                local newY = drop.Position.Y - data.speed * dt
                
                if newY < camPos.Y - 30 then
                    newY = camPos.Y + math.random(40, 80)
                    data.offset = Vector3.new(math.random(-60, 60), 0, math.random(-60, 60))
                end
                
                drop.CFrame = CFrame.new(
                    camPos.X + data.offset.X,
                    newY,
                    camPos.Z + data.offset.Z
                ) * CFrame.Angles(0, 0, math.rad(math.random(-5, 5)))
            end
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
    
    local atmo = Lighting:FindFirstChild("RainAtmosphere")
    if atmo then atmo:Destroy() end
    
    local cc = Lighting:FindFirstChild("RainColorCorrection")
    if cc then cc:Destroy() end
    
    if not Features.Snow.Enabled and not Features.Thunderstorm.Enabled and not Features.Aurora.Enabled and not Features.MoonGlow.Enabled then
        restoreOriginalLighting()
    end
end

-- SNOW SHADER
function Features.Snow:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    storeOriginalLighting()
    
    -- Create snow container
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "SnowEffects_Reaper"
    self.Folder.Parent = workspace.CurrentCamera
    
    local snowflakes = {}
    local snowCount = 150
    
    -- Create snowflakes
    for i = 1, snowCount do
        local flake = Instance.new("Part")
        flake.Name = "Snowflake"
        flake.Size = Vector3.new(0.2, 0.2, 0.2)
        flake.Shape = Enum.PartType.Ball
        flake.Material = Enum.Material.Neon
        flake.Color = Color3.fromRGB(255, 255, 255)
        flake.Transparency = 0.2
        flake.Anchored = true
        flake.CanCollide = false
        flake.CastShadow = false
        flake.Parent = self.Folder
        
        table.insert(snowflakes, {
            part = flake,
            speed = math.random(8, 15),
            drift = math.random(-2, 2),
            phase = math.random() * math.pi * 2,
            offset = Vector3.new(math.random(-50, 50), math.random(20, 60), math.random(-50, 50))
        })
    end
    
    -- Winter lighting
    Lighting.ClockTime = 12
    Lighting.Brightness = 1.2
    Lighting.Ambient = Color3.fromRGB(180, 190, 210)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 210, 230)
    Lighting.FogColor = Color3.fromRGB(220, 225, 235)
    Lighting.FogEnd = 500
    Lighting.FogStart = 50
    Lighting.ColorShift_Top = Color3.fromRGB(200, 210, 230)
    Lighting.ColorShift_Bottom = Color3.fromRGB(180, 190, 210)
    
    -- Snow atmosphere
    local atmo = Instance.new("Atmosphere")
    atmo.Name = "SnowAtmosphere"
    atmo.Density = 0.35
    atmo.Color = Color3.fromRGB(220, 225, 240)
    atmo.Decay = Color3.fromRGB(200, 210, 230)
    atmo.Haze = 2
    atmo.Glare = 0.1
    atmo.Parent = Lighting
    
    -- Color correction for winter
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "SnowColorCorrection"
    cc.Brightness = 0.05
    cc.Contrast = 0.1
    cc.Saturation = -0.3
    cc.TintColor = Color3.fromRGB(220, 230, 255)
    cc.Parent = Lighting
    
    -- Wind sound
    self.Sound = Instance.new("Sound")
    self.Sound.Name = "SnowSound"
    self.Sound.SoundId = SOUND_IDS.Wind
    self.Sound.Volume = 0.3
    self.Sound.Looped = true
    self.Sound.Parent = workspace.CurrentCamera
    self.Sound:Play()
    
    local time = 0
    
    -- Animate snow
    self.Connection = RunService.RenderStepped:Connect(function(dt)
        time = time + dt
        local camPos = workspace.CurrentCamera.CFrame.Position
        
        for _, data in ipairs(snowflakes) do
            local flake = data.part
            if flake and flake.Parent then
                local newY = flake.Position.Y - data.speed * dt
                local sway = math.sin(time * 2 + data.phase) * data.drift
                
                if newY < camPos.Y - 20 then
                    newY = camPos.Y + math.random(30, 60)
                    data.offset = Vector3.new(math.random(-50, 50), 0, math.random(-50, 50))
                end
                
                flake.CFrame = CFrame.new(
                    camPos.X + data.offset.X + sway,
                    newY,
                    camPos.Z + data.offset.Z
                )
            end
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
    
    local atmo = Lighting:FindFirstChild("SnowAtmosphere")
    if atmo then atmo:Destroy() end
    
    local cc = Lighting:FindFirstChild("SnowColorCorrection")
    if cc then cc:Destroy() end
    
    if not Features.Rain.Enabled and not Features.Thunderstorm.Enabled and not Features.Aurora.Enabled and not Features.MoonGlow.Enabled then
        restoreOriginalLighting()
    end
end

-- THUNDERSTORM SHADER
function Features.Thunderstorm:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    -- Enable rain first
    if not Features.Rain.Enabled then
        Features.Rain:Start()
    end
    
    -- Make it darker
    Lighting.Brightness = 0.3
    Lighting.Ambient = Color3.fromRGB(25, 30, 40)
    
    -- Lightning flash effect
    local flash = Instance.new("ColorCorrectionEffect")
    flash.Name = "LightningFlash"
    flash.Brightness = 0
    flash.Parent = Lighting
    
    -- Thunder sound
    self.Sound = Instance.new("Sound")
    self.Sound.Name = "ThunderSound"
    self.Sound.SoundId = SOUND_IDS.Thunder
    self.Sound.Volume = 0.8
    self.Sound.Looped = false
    self.Sound.Parent = workspace.CurrentCamera
    
    local nextLightning = tick() + math.random(3, 8)
    
    -- Lightning loop
    self.Connection = RunService.Heartbeat:Connect(function()
        if tick() >= nextLightning then
            nextLightning = tick() + math.random(5, 15)
            
            -- Play thunder
            if self.Sound then
                self.Sound:Play()
            end
            
            -- Flash sequence
            task.spawn(function()
                flash.Brightness = 4
                Lighting.Brightness = 5
                task.wait(0.05)
                flash.Brightness = 0
                Lighting.Brightness = 0.3
                task.wait(0.1)
                flash.Brightness = 2.5
                Lighting.Brightness = 3
                task.wait(0.04)
                flash.Brightness = 0
                Lighting.Brightness = 0.3
            end)
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
    
    -- Disable rain if it was enabled by thunderstorm
    if Features.Rain.Enabled then
        Features.Rain:Stop()
    end
end

-- AURORA SHADER
function Features.Aurora:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    storeOriginalLighting()
    
    -- Night sky for aurora
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.4
    Lighting.Ambient = Color3.fromRGB(15, 25, 45)
    Lighting.OutdoorAmbient = Color3.fromRGB(25, 40, 65)
    Lighting.ColorShift_Top = Color3.fromRGB(30, 60, 100)
    Lighting.ColorShift_Bottom = Color3.fromRGB(20, 40, 70)
    
    -- Create aurora parts
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
        part.CFrame = CFrame.new(
            math.random(-500, 500),
            math.random(300, 550),
            math.random(-500, 500)
        ) * CFrame.Angles(0, math.rad(math.random(0, 360)), math.rad(math.random(-20, 20)))
        part.Parent = self.Folder
        
        table.insert(auroraParts, {
            part = part,
            phase = math.random() * math.pi * 2,
            colorPhase = math.random() * math.pi * 2
        })
    end
    
    -- Bloom for glow
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

-- MOON GLOW SHADER
function Features.MoonGlow:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    storeOriginalLighting()
    
    -- Night time
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.6
    Lighting.Ambient = Color3.fromRGB(35, 45, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(45, 55, 85)
    Lighting.ColorShift_Top = Color3.fromRGB(50, 70, 110)
    Lighting.ColorShift_Bottom = Color3.fromRGB(40, 55, 90)
    
    -- Heavy bloom for moon glow
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "MoonBloom"
    bloom.Intensity = 2.5
    bloom.Size = 60
    bloom.Threshold = 0.5
    bloom.Parent = Lighting
    
    -- Night atmosphere
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

-- ========================================
-- CREATE TABS
-- ========================================

local MainTab = CreateTab("Main", "[M]")
local PlayTab = CreateTab("Play", "[P]")
local ESPTab = CreateTab("ESP", "[E]")
local PingFPSTab = CreateTab("Ping | FPS", "[F]")
local ShadersTab = CreateTab("Shaders", "[S]")
local MiscTab = CreateTab("Misc", "[+]")

-- MAIN TAB
local CombatSection = MainTab:AddSection("Combat")
CombatSection:AddToggle({Title = "Auto Parry", Default = false, Callback = function(state) if state then Features.AutoParry:Start() else Features.AutoParry:Stop() end end})
CombatSection:AddSlider({Title = "Parry Timing", Min = 25, Max = 150, Default = 75, Callback = function(value) Features.AutoParry:SetDistance(value / 100) end})
CombatSection:AddToggle({Title = "Manual Spam", Default = false, Callback = function(state) if state then Features.ManualSpam:Start() else Features.ManualSpam:Stop() end end})
CombatSection:AddToggle({Title = "Auto Use Ability", Default = false, Callback = function(state) if state then Features.AutoUseAbility:Start() else Features.AutoUseAbility:Stop() end end})

local HitboxSection = MainTab:AddSection("Hitbox")
HitboxSection:AddToggle({Title = "Hitbox Expander", Default = false, Callback = function(state) if state then Features.HitboxExpander:Start() else Features.HitboxExpander:Stop() end end})
HitboxSection:AddSlider({Title = "Hitbox Size", Min = 5, Max = 20, Default = 10, Callback = function(value) Features.HitboxExpander.Size = value end})

-- PLAY TAB
local MovementSection = PlayTab:AddSection("Movement")
MovementSection:AddToggle({Title = "Speed Boost", Default = false, Callback = function(state) if state then Features.Speed:Start() else Features.Speed:Stop() end end})
MovementSection:AddSlider({Title = "Speed Value", Min = 16, Max = 100, Default = 50, Callback = function(value) Features.Speed.Value = value Features.Speed:Update() end})
MovementSection:AddToggle({Title = "Jump Boost", Default = false, Callback = function(state) if state then Features.Jump:Start() else Features.Jump:Stop() end end})
MovementSection:AddSlider({Title = "Jump Power", Min = 50, Max = 200, Default = 100, Callback = function(value) Features.Jump.Value = value Features.Jump:Update() end})
MovementSection:AddToggle({Title = "Infinite Jump", Default = false, Callback = function(state) if state then Features.InfiniteJump:Start() else Features.InfiniteJump:Stop() end end})
MovementSection:AddToggle({Title = "Noclip", Default = false, Callback = function(state) if state then Features.Noclip:Start() else Features.Noclip:Stop() end end})

local AutoSection = PlayTab:AddSection("Auto Play")
AutoSection:AddToggle({Title = "Auto Play", Default = false, Callback = function(state) Features.AutoPlay.Enabled = state end})
AutoSection:AddDropdown({Title = "Play Style", Options = {"Aggressive", "Balanced", "Defensive"}, Default = "Balanced", Callback = function(value) Features.AutoPlay.Style = value end})

-- ESP TAB
local ESPSection = ESPTab:AddSection("ESP Options")
ESPSection:AddToggle({Title = "Ball ESP", Default = false, Callback = function(state) if state then Features.BallESP:Start() else Features.BallESP:Stop() end end})
ESPSection:AddToggle({Title = "Player ESP", Default = false, Callback = function(state) if state then Features.ESP:Start() else Features.ESP:Stop() end end})
ESPSection:AddButton({Title = "Refresh All ESP", Callback = function()
    if Features.ESP.Enabled then Features.ESP:Stop() task.wait(0.1) Features.ESP:Start() end
    if Features.BallESP.Enabled then Features.BallESP:Stop() task.wait(0.1) Features.BallESP:Start() end
end})

local VisualsSection = ESPTab:AddSection("Visuals")
VisualsSection:AddToggle({Title = "Fullbright", Default = false, Callback = function(state) if state then Features.Fullbright:Start() else Features.Fullbright:Stop() end end})

-- PING | FPS TAB
local PerformanceSection = PingFPSTab:AddSection("Performance")

-- FPS Display Label
local fpsLabel = PerformanceSection:AddLabel("FPS: Calculating...")
local pingLabel = PerformanceSection:AddLabel("Ping: Calculating...")

-- FPS/Ping Update Loop
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

-- SHADERS TAB
local WeatherSection = ShadersTab:AddSection("Weather Effects")
WeatherSection:AddToggle({Title = "Rain", Default = false, Callback = function(state) if state then Features.Rain:Start() else Features.Rain:Stop() end end})
WeatherSection:AddToggle({Title = "Snow", Default = false, Callback = function(state) if state then Features.Snow:Start() else Features.Snow:Stop() end end})
WeatherSection:AddToggle({Title = "Thunderstorm", Default = false, Callback = function(state) if state then Features.Thunderstorm:Start() else Features.Thunderstorm:Stop() end end})

local SkySection = ShadersTab:AddSection("Sky Effects")
SkySection:AddToggle({Title = "Aurora Borealis", Default = false, Callback = function(state) if state then Features.Aurora:Start() else Features.Aurora:Stop() end end})
SkySection:AddToggle({Title = "Moon Glow", Default = false, Callback = function(state) if state then Features.MoonGlow:Start() else Features.MoonGlow:Stop() end end})

local ShaderInfoSection = ShadersTab:AddSection("Info")
ShaderInfoSection:AddLabel("Shaders include sounds & effects")
ShaderInfoSection:AddLabel("Multiple shaders can be combined")
ShaderInfoSection:AddButton({Title = "Reset All Shaders", Callback = function()
    Features.Rain:Stop()
    Features.Snow:Stop()
    Features.Thunderstorm:Stop()
    Features.Aurora:Stop()
    Features.MoonGlow:Stop()
    restoreOriginalLighting()
end})

-- MISC TAB
local UtilSection = MiscTab:AddSection("Utility")
UtilSection:AddToggle({Title = "Anti-AFK", Default = true, Callback = function(state) Features.AntiAFK.Enabled = state end})
UtilSection:AddButton({Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end})
UtilSection:AddButton({Title = "Copy Server Link", Callback = function()
    local jobId = game.JobId
    if jobId ~= "" then
        if setclipboard then
            setclipboard("roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. jobId)
        end
    end
end})

local InfoSection = MiscTab:AddSection("Info")
InfoSection:AddLabel("Reaper Hub v4.0")
InfoSection:AddLabel("Enhanced Edition")
InfoSection:AddLabel("User: " .. Player.DisplayName)
InfoSection:AddLabel("ID: " .. Player.UserId)

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Reaper Hub",
        Text = "v4.0 Enhanced loaded!",
        Duration = 3
    })
end)

print("========================================")
print("[R] REAPER HUB | BLADEBALL v4.0")
print("[+] Enhanced Edition")
print("[+] User Avatar Display")
print("[+] Auto Use Ability")
print("[+] Smooth 3D Animations")
print("[+] Ping | FPS Tab with Booster")
print("[+] Shaders Tab (Rain, Snow, etc.)")
print("[+] Expanded Discord Embed")
print("========================================")
