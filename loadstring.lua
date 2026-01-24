-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    Zyx MM2 SCRIPT - ULTIMATE EDITION                        ║
-- ║                     Enhanced by AI • Version 2.0                              ║
-- ║           Anti-Kick • Modern UI • Dynamic Shaders • 40+ Features              ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              SETTINGS                                         ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local Settings = {
    -- Main Features
    NoclipEnabled = false,
    FlyEnabled = false,
    SpeedEnabled = false,
    ESPEnabled = false,
    CoinESPEnabled = false,
    FlingEnabled = false,
    AutoFarmCoins = false,
    SilentAim = false,
    JumpBoost = false,
    KillAura = false,
    GunMods = false,
    InfiniteJump = false,
    NoFall = false,
    NoVoid = false,
    AutoGG = false,
    AntiAFK = false,
    Fullbright = false,
    GunESP = false,
    TrapESP = false,
    Spectating = false,
    
    -- Values
    WalkSpeed = 25,
    FlySpeed = 50,
    JumpPower = 50,
    KillAuraRange = 15,
    FOV = 70,
    
    -- Shader Settings
    WeatherEnabled = false,
    CurrentWeather = "Clear",
    AuroraEnabled = false,
    ThunderstormEnabled = false,
    RainEnabled = false,
    SnowEnabled = false,
    DynamicSkyEnabled = false,
    WeatherIntensity = 0.5,
    TimeOfDay = 14,
    CloudDensity = 0.3,
    FogEnabled = false,
    FogDensity = 0.1,
    BloomEnabled = false,
    BloomIntensity = 1,
    ColorCorrectionEnabled = false,
    SunRaysEnabled = false,
}

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              STATE MANAGEMENT                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local State = {
    -- Connections
    NoclipConnection = nil,
    FlyConnection = nil,
    SpeedConnection = nil,
    ESPConnections = {},
    CoinESPConnections = {},
    FlingConnection = nil,
    AutoFarmConnection = nil,
    SilentAimConnection = nil,
    JumpBoostConnection = nil,
    KillAuraConnection = nil,
    GunModsConnection = nil,
    InfiniteJumpConnection = nil,
    NoFallConnection = nil,
    NoVoidConnection = nil,
    AutoGGConnection = nil,
    AntiAFKConnection = nil,
    FullbrightConnection = nil,
    GunESPConnections = {},
    TrapESPConnections = {},
    SpectateConnection = nil,
    
    -- Shader Connections
    WeatherConnection = nil,
    AuroraConnection = nil,
    ThunderstormConnection = nil,
    RainConnection = nil,
    SnowConnection = nil,
    DynamicSkyConnection = nil,
    LightningConnection = nil,
    
    -- Shader Objects
    SkyboxObject = nil,
    AuroraParticles = {},
    RainParticles = {},
    SnowParticles = {},
    LightningFlash = nil,
    CloudParts = {},
    FogEffect = nil,
    BloomEffect = nil,
    ColorCorrection = nil,
    SunRays = nil,
    Atmosphere = nil,
    
    -- State Variables
    VoidPlatform = nil,
    OriginalWalkSpeed = 16,
    OriginalJumpPower = 50,
    Flying = false,
    FlyKeys = {},
    LastValidPosition = nil,
    FarmingCoins = false,
    NoclipParts = {},
    MobileFlyTouching = {Up = false, Down = false, Forward = false, Back = false, Left = false, Right = false},
    LastRoundState = nil,
    SpectatingPlayer = nil,
    OriginalLighting = {},
    WeatherTransitioning = false,
}

-- Cleanup old UI
pcall(function() CoreGui:FindFirstChild("ZyxMM2UI"):Destroy() end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              THEME CONFIGURATION                              ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local THEME = {
    FrameBg        = Color3.fromRGB(12, 12, 16),   
    FrameBg2       = Color3.fromRGB(18, 18, 24),   
    Accent         = Color3.fromRGB(255, 45, 85),  
    AccentHover    = Color3.fromRGB(255, 80, 110),
    AccentSecondary = Color3.fromRGB(138, 43, 226),
    TabIdle        = Color3.fromRGB(35, 35, 42),
    TabActive      = Color3.fromRGB(255, 45, 85),
    ToggleBg       = Color3.fromRGB(25, 25, 32),
    ToggleHover    = Color3.fromRGB(32, 32, 40),
    ToggleOffTrack = Color3.fromRGB(55, 55, 65),
    ToggleOnTrack  = Color3.fromRGB(255, 45, 85),
    SliderBg       = Color3.fromRGB(30, 30, 38),
    SliderFill     = Color3.fromRGB(255, 45, 85),
    ButtonBg       = Color3.fromRGB(35, 35, 45),
    ButtonHover    = Color3.fromRGB(45, 45, 58),
    TextLight      = Color3.fromRGB(245, 245, 250),
    TextDim        = Color3.fromRGB(150, 150, 165),
    TitleText      = Color3.fromRGB(255, 255, 255),
    Success        = Color3.fromRGB(50, 205, 50),
    Warning        = Color3.fromRGB(255, 165, 0),
    Error          = Color3.fromRGB(255, 60, 60),
    Info           = Color3.fromRGB(65, 165, 255),
    
    -- Shader Theme Colors
    ShaderAccent   = Color3.fromRGB(100, 200, 255),
    AuroraGreen    = Color3.fromRGB(0, 255, 127),
    AuroraPurple   = Color3.fromRGB(148, 0, 211),
    AuroraBlue     = Color3.fromRGB(0, 191, 255),
    StormGray      = Color3.fromRGB(70, 70, 80),
    SnowWhite      = Color3.fromRGB(240, 248, 255),
}

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              UTILITY FUNCTIONS                                ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Safe character access
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoidRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Safe CFrame setting with anti-kick protection
local function safeSetCFrame(part, newCFrame)
    if not newCFrame or not part then return false end
    
    local pos = newCFrame.Position
    if pos.Y < -500 or pos.Y > 10000 then return false end
    if pos.Magnitude > 100000 then return false end
    
    State.LastValidPosition = part.CFrame
    
    local success = pcall(function()
        part.CFrame = newCFrame
    end)
    
    return success
end

-- Get player role in MM2
local function getPlayerRole(player)
    local role = "Innocent"
    
    pcall(function()
        local char = player.Character
        if not char then return end
        
        -- Check for knife (Murderer)
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                if tool.Name == "Knife" or tool.Name:lower():find("knife") then
                    role = "Murderer"
                    return
                elseif tool.Name == "Gun" or tool.Name == "Revolver" then
                    role = "Sheriff"
                    return
                end
            end
        end
        
        -- Check backpack
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    if tool.Name == "Knife" or tool.Name:lower():find("knife") then
                        role = "Murderer"
                        return
                    elseif tool.Name == "Gun" or tool.Name == "Revolver" then
                        role = "Sheriff"
                        return
                    end
                end
            end
        end
    end)
    
    return role
end

-- Get role color
local function getRoleColor(role)
    if role == "Murderer" then
        return Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then
        return Color3.fromRGB(0, 100, 255)
    elseif role == "Hero" then
        return Color3.fromRGB(255, 215, 0)
    else
        return Color3.fromRGB(0, 255, 0)
    end
end

-- Lerp function for smooth transitions
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Color lerp
local function lerpColor(c1, c2, t)
    return Color3.new(
        lerp(c1.R, c2.R, t),
        lerp(c1.G, c2.G, t),
        lerp(c1.B, c2.B, t)
    )
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              SCREEN GUI SETUP                                 ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local gui = Instance.new("ScreenGui")
gui.Name = "ZyxMM2UI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 420)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
mainFrame.BackgroundColor3 = THEME.FrameBg
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = gui
mainFrame.ZIndex = 2
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- Main stroke with glow effect
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = THEME.Accent
mainStroke.Transparency = 0
mainStroke.Parent = mainFrame

-- Animated glow
local glowStroke = Instance.new("UIStroke")
glowStroke.Thickness = 4
glowStroke.Color = THEME.Accent
glowStroke.Transparency = 0.7
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glowStroke.Parent = mainFrame

-- Glow animation
spawn(function()
    while mainFrame.Parent do
        for i = 0, 1, 0.02 do
            glowStroke.Transparency = 0.5 + math.sin(i * math.pi * 2) * 0.3
            task.wait(0.03)
        end
    end
end)

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.ZIndex = 0
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.4
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)
shadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 3
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

-- Fix bottom corners of title
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 16)
titleFix.Position = UDim2.new(0, 0, 1, -16)
titleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 3
titleFix.Parent = titleBar

-- Title gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 10, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 20, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 20))
}
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ Zyx MM2 ULTIMATE"
titleText.Font = Enum.Font.GothamBlack
titleText.TextSize = 16
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextColor3 = THEME.TitleText
titleText.ZIndex = 4
titleText.Parent = titleBar

-- Version badge
local versionBadge = Instance.new("TextLabel")
versionBadge.Name = "Version"
versionBadge.Size = UDim2.new(0, 40, 0, 18)
versionBadge.Position = UDim2.new(0, 175, 0.5, -9)
versionBadge.BackgroundColor3 = THEME.Accent
versionBadge.Text = "v2.0"
versionBadge.Font = Enum.Font.GothamBold
versionBadge.TextSize = 10
versionBadge.TextColor3 = Color3.new(1, 1, 1)
versionBadge.ZIndex = 4
versionBadge.Parent = titleBar
Instance.new("UICorner", versionBadge).CornerRadius = UDim.new(0, 6)

-- Accent line under title
local accentLine = Instance.new("Frame")
accentLine.Name = "AccentLine"
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 1, 0)
accentLine.BackgroundColor3 = THEME.Accent
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 4
accentLine.Parent = titleBar

-- Animated accent line
spawn(function()
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, THEME.Accent),
        ColorSequenceKeypoint.new(0.5, THEME.AccentSecondary),
        ColorSequenceKeypoint.new(1, THEME.Accent)
    }
    gradient.Parent = accentLine
    
    while accentLine.Parent do
        for i = 0, 1, 0.01 do
            gradient.Offset = Vector2.new(math.sin(i * math.pi * 2) * 0.5, 0)
            task.wait(0.03)
        end
    end
end)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -37, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.ZIndex = 5
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.wait(0.2)
    mainFrame.Visible = false
    mainFrame.Size = UDim2.new(0, 380, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Error}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
minimizeBtn.Position = UDim2.new(1, -72, 0.5, -16)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minimizeBtn.Text = "─"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.ZIndex = 5
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 380, 0, 42)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 380, 0, 420)
        }):Play()
    end
end)

minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Warning}):Play()
end)
minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              TAB SYSTEM                                       ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 32)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 3
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.BackgroundColor3 = THEME.FrameBg2
contentFrame.ZIndex = 3
contentFrame.Parent = mainFrame
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 12)

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 5)
contentPadding.PaddingBottom = UDim.new(0, 5)
contentPadding.PaddingLeft = UDim.new(0, 5)
contentPadding.PaddingRight = UDim.new(0, 5)
contentPadding.Parent = contentFrame

-- Tab storage
local tabs = {}
local tabButtons = {}

-- Create tab function
local function createTab(name, icon)
    local tab = Instance.new("ScrollingFrame")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.BorderSizePixel = 0
    tab.ScrollBarThickness = 4
    tab.ScrollBarImageColor3 = THEME.Accent
    tab.ScrollBarImageTransparency = 0.3
    tab.Visible = false
    tab.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.ZIndex = 3
    tab.Parent = contentFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tab
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    tabs[name] = tab
    return tab
end

-- Set active tab
local function setActiveTab(name)
    for tabName, tab in pairs(tabs) do
        tab.Visible = (tabName == name)
    end
    for tabName, btn in pairs(tabButtons) do
        local isActive = (tabName == name)
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = isActive and THEME.TabActive or THEME.TabIdle
        }):Play()
        TweenService:Create(btn:FindFirstChild("TabStroke") or btn, TweenInfo.new(0.2), {
            Transparency = isActive and 0 or 0.7
        }):Play()
    end
end

-- Create tab button
local function createTabButton(text, tabName, icon)
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Btn"
    btn.Size = UDim2.new(0, 68, 0, 28)
    btn.Text = (icon or "") .. " " .. text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = THEME.TextLight
    btn.BackgroundColor3 = THEME.TabIdle
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    btn.Parent = tabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Name = "TabStroke"
    btnStroke.Thickness = 1.5
    btnStroke.Color = THEME.Accent
    btnStroke.Transparency = 0.7
    btnStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function() 
        setActiveTab(tabName) 
    end)
    
    btn.MouseEnter:Connect(function() 
        if not tabs[tabName].Visible then 
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.AccentHover}):Play() 
        end 
    end)
    
    btn.MouseLeave:Connect(function() 
        if not tabs[tabName].Visible then 
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.TabIdle}):Play() 
        end 
    end)
    
    tabButtons[tabName] = btn
end

-- Create all tabs
local mainTab = createTab("Main")
local visualTab = createTab("Visual")
local miscTab = createTab("Misc")
local teleportTab = createTab("Teleport")
local shadersTab = createTab("Shaders")

-- Create tab buttons
createTabButton("Main", "Main", "⚔")
createTabButton("Visual", "Visual", "👁")
createTabButton("Misc", "Misc", "⚙")
createTabButton("TP", "Teleport", "🎯")
createTabButton("Shaders", "Shaders", "✨")

setActiveTab("Main")

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              UI COMPONENTS                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Section Header
local function createSection(tabName, sectionName)
    local tab = tabs[tabName]
    if not tab then return end
    
    local section = Instance.new("Frame")
    section.Name = sectionName .. "_Section"
    section.Size = UDim2.new(1, -10, 0, 24)
    section.BackgroundTransparency = 1
    section.ZIndex = 3
    section.Parent = tab
    
    local sectionText = Instance.new("TextLabel")
    sectionText.Size = UDim2.new(1, 0, 1, 0)
    sectionText.BackgroundTransparency = 1
    sectionText.Text = "── " .. sectionName .. " ──"
    sectionText.Font = Enum.Font.GothamBold
    sectionText.TextSize = 11
    sectionText.TextColor3 = THEME.TextDim
    sectionText.ZIndex = 3
    sectionText.Parent = section
end

-- Toggle Creator
local function createToggle(tabName, data)
    local tab = tabs[tabName]
    if not tab then return warn("[ZyxUI] Tab not found: " .. tostring(tabName)) end

    local name = data.Name or "Toggle"
    local callback = data.Callback
    local default = data.Default or false
    local colorOn = data.ColorOn or THEME.ToggleOnTrack
    local description = data.Description

    local btn = Instance.new("TextButton")
    btn.Name = name .. "_Toggle"
    btn.Parent = tab
    btn.Size = UDim2.new(1, -10, 0, description and 50 or 38)
    btn.BackgroundColor3 = THEME.ToggleBg
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(50, 50, 60)
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 12, 0, description and 8 or 9)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextColor3 = THEME.TextLight
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = btn
    
    if description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -70, 0, 16)
        descLabel.Position = UDim2.new(0, 12, 0, 28)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 10
        descLabel.TextColor3 = THEME.TextDim
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 4
        descLabel.Parent = btn
    end

    -- Toggle track
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 44, 0, 22)
    track.Position = UDim2.new(1, -56, 0.5, -11)
    track.BackgroundColor3 = THEME.ToggleOffTrack
    track.ZIndex = 4
    track.Parent = btn
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    -- Toggle knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.ZIndex = 5
    knob.Parent = track
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    -- Knob shadow
    local knobShadow = Instance.new("ImageLabel")
    knobShadow.Size = UDim2.new(1, 6, 1, 6)
    knobShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    knobShadow.BackgroundTransparency = 1
    knobShadow.Image = "rbxassetid://5028857084"
    knobShadow.ImageColor3 = Color3.new(0, 0, 0)
    knobShadow.ImageTransparency = 0.7
    knobShadow.ZIndex = 4
    knobShadow.ScaleType = Enum.ScaleType.Slice
    knobShadow.SliceCenter = Rect.new(24, 24, 276, 276)
    knobShadow.Parent = knob

    local toggled = default

    local function updateVisual()
        TweenService:Create(track, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            BackgroundColor3 = toggled and colorOn or THEME.ToggleOffTrack
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
            Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        }):Play()
    end

    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateVisual()
        if callback then
            pcall(callback, toggled)
        end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ToggleHover}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = THEME.Accent, Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ToggleBg}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50, 50, 60), Transparency = 0.5}):Play()
    end)

    if default then
        updateVisual()
        if callback then pcall(callback, true) end
    end
    
    return {
        SetValue = function(val)
            toggled = val
            updateVisual()
        end,
        GetValue = function()
            return toggled
        end
    }
end

-- Slider Creator
local function createSlider(tabName, data)
    local tab = tabs[tabName]
    if not tab then return end

    local name = data.Name or "Slider"
    local min = data.Min or 0
    local max = data.Max or 100
    local default = data.Default or min
    local callback = data.Callback
    local suffix = data.Suffix or ""

    local container = Instance.new("Frame")
    container.Name = name .. "_Slider"
    container.Size = UDim2.new(1, -10, 0, 50)
    container.BackgroundColor3 = THEME.ToggleBg
    container.ZIndex = 3
    container.Parent = tab
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Thickness = 1
    containerStroke.Color = Color3.fromRGB(50, 50, 60)
    containerStroke.Transparency = 0.5
    containerStroke.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextColor3 = THEME.TextLight
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = container

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.35, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.65, -12, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default) .. suffix
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextColor3 = THEME.Accent
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.ZIndex = 4
    valueLabel.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 32)
    sliderBg.BackgroundColor3 = THEME.SliderBg
    sliderBg.ZIndex = 4
    sliderBg.Parent = container
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = THEME.SliderFill
    sliderFill.ZIndex = 5
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    -- Slider gradient
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, THEME.Accent),
        ColorSequenceKeypoint.new(1, THEME.AccentSecondary)
    }
    fillGradient.Parent = sliderFill

    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderKnob.ZIndex = 6
    sliderKnob.Parent = sliderBg
    Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local currentValue = default

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(min + (max - min) * pos)
        valueLabel.Text = tostring(currentValue) .. suffix
        
        TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
        TweenService:Create(sliderKnob, TweenInfo.new(0.1), {Position = UDim2.new(pos, -8, 0.5, -8)}):Play()
        
        if callback then pcall(callback, currentValue) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return {
        SetValue = function(val)
            currentValue = math.clamp(val, min, max)
            local pos = (currentValue - min) / (max - min)
            valueLabel.Text = tostring(currentValue) .. suffix
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderKnob.Position = UDim2.new(pos, -8, 0.5, -8)
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- Button Creator
local function createButton(tabName, data)
    local tab = tabs[tabName]
    if not tab then return end

    local name = data.Name or "Button"
    local callback = data.Callback
    local color = data.Color or THEME.ButtonBg

    local btn = Instance.new("TextButton")
    btn.Name = name .. "_Button"
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = THEME.TextLight
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = tab
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = THEME.Accent
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        -- Click animation
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -14, 0, 36)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 38)}):Play()
        
        if callback then pcall(callback) end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ButtonHover}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Transparency = 0.5}):Play()
    end)
end

-- Dropdown Creator
local function createDropdown(tabName, data)
    local tab = tabs[tabName]
    if not tab then return end

    local name = data.Name or "Dropdown"
    local options = data.Options or {}
    local default = data.Default or options[1]
    local callback = data.Callback

    local container = Instance.new("Frame")
    container.Name = name .. "_Dropdown"
    container.Size = UDim2.new(1, -10, 0, 38)
    container.BackgroundColor3 = THEME.ToggleBg
    container.ZIndex = 3
    container.ClipsDescendants = true
    container.Parent = tab
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 38)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextColor3 = THEME.TextLight
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = container

    local selectedBtn = Instance.new("TextButton")
    selectedBtn.Size = UDim2.new(0.45, -12, 0, 28)
    selectedBtn.Position = UDim2.new(0.55, 0, 0, 5)
    selectedBtn.BackgroundColor3 = THEME.SliderBg
    selectedBtn.Text = default or "Select"
    selectedBtn.Font = Enum.Font.GothamSemibold
    selectedBtn.TextSize = 11
    selectedBtn.TextColor3 = THEME.TextLight
    selectedBtn.ZIndex = 4
    selectedBtn.Parent = container
    Instance.new("UICorner", selectedBtn).CornerRadius = UDim.new(0, 6)

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 10
    arrow.TextColor3 = THEME.TextDim
    arrow.ZIndex = 5
    arrow.Parent = selectedBtn

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(0.45, -12, 0, #options * 28)
    optionsFrame.Position = UDim2.new(0.55, 0, 0, 38)
    optionsFrame.BackgroundColor3 = THEME.SliderBg
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 10
    optionsFrame.Parent = container
    Instance.new("UICorner", optionsFrame).CornerRadius = UDim.new(0, 6)

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Parent = optionsFrame

    local expanded = false
    local selectedValue = default

    for _, option in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = option
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 11
        optBtn.TextColor3 = THEME.TextLight
        optBtn.ZIndex = 11
        optBtn.Parent = optionsFrame

        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5, BackgroundColor3 = THEME.Accent}):Play()
        end)
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
        end)

        optBtn.MouseButton1Click:Connect(function()
            selectedValue = option
            selectedBtn.Text = option
            expanded = false
            optionsFrame.Visible = false
            TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 38)}):Play()
            arrow.Text = "▼"
            if callback then pcall(callback, option) end
        end)
    end

    selectedBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        optionsFrame.Visible = expanded
        arrow.Text = expanded and "▲" or "▼"
        TweenService:Create(container, TweenInfo.new(0.2), {
            Size = expanded and UDim2.new(1, -10, 0, 38 + #options * 28 + 5) or UDim2.new(1, -10, 0, 38)
        }):Play()
    end)
    
    return {
        SetValue = function(val)
            selectedValue = val
            selectedBtn.Text = val
        end,
        GetValue = function()
            return selectedValue
        end
    }
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              NOTIFICATION SYSTEM                              ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local notificationContainer = Instance.new("Frame")
notificationContainer.Name = "NotificationContainer"
notificationContainer.Size = UDim2.new(0, 300, 1, 0)
notificationContainer.Position = UDim2.new(1, -310, 0, 0)
notificationContainer.BackgroundTransparency = 1
notificationContainer.ZIndex = 100
notificationContainer.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Parent = notificationContainer

local notifPadding = Instance.new("UIPadding")
notifPadding.PaddingTop = UDim.new(0, 10)
notifPadding.PaddingRight = UDim.new(0, 10)
notifPadding.Parent = notificationContainer

local function createNotification(title, text, duration, notifType)
    notifType = notifType or "info"
    duration = duration or 5
    
    local colors = {
        info = THEME.Info,
        success = THEME.Success,
        warning = THEME.Warning,
        error = THEME.Error
    }
    
    local icons = {
        info = "ℹ",
        success = "✓",
        warning = "⚠",
        error = "✕"
    }
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 70)
    notif.Position = UDim2.new(1, 10, 0, 0)
    notif.BackgroundColor3 = THEME.FrameBg
    notif.ZIndex = 101
    notif.Parent = notificationContainer
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Thickness = 1.5
    notifStroke.Color = colors[notifType]
    notifStroke.Parent = notif
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 10, 0, 10)
    iconLabel.BackgroundColor3 = colors[notifType]
    iconLabel.Text = icons[notifType]
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 16
    iconLabel.TextColor3 = Color3.new(1, 1, 1)
    iconLabel.ZIndex = 102
    iconLabel.Parent = notif
    Instance.new("UICorner", iconLabel).CornerRadius = UDim.new(0, 6)
    
    -- Title
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -55, 0, 20)
    notifTitle.Position = UDim2.new(0, 48, 0, 8)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 13
    notifTitle.TextColor3 = colors[notifType]
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.ZIndex = 102
    notifTitle.Parent = notif
    
    -- Text
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -55, 0, 35)
    notifText.Position = UDim2.new(0, 48, 0, 28)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 11
    notifText.TextColor3 = THEME.TextLight
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextYAlignment = Enum.TextYAlignment.Top
    notifText.TextWrapped = true
    notifText.ZIndex = 102
    notifText.Parent = notif
    
    -- Progress bar
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -20, 0, 3)
    progressBg.Position = UDim2.new(0, 10, 1, -8)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressBg.ZIndex = 102
    progressBg.Parent = notif
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BackgroundColor3 = colors[notifType]
    progressFill.ZIndex = 103
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    
    -- Animate in
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    -- Progress animation
    TweenService:Create(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()
    
    -- Remove after duration
    task.delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 0, 0)
        }):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              OPEN/TOGGLE BUTTON                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 15, 0.2, 0)
toggleBtn.Text = "⚡"
toggleBtn.TextSize = 28
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
toggleBtn.BackgroundColor3 = THEME.Accent
toggleBtn.BackgroundTransparency = 0.1
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.ZIndex = 50
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 2
toggleStroke.Color = Color3.fromRGB(255, 215, 0)
toggleStroke.Transparency = 0.3
toggleStroke.Parent = toggleBtn

-- Pulse animation
spawn(function()
    while toggleBtn.Parent do
        TweenService:Create(toggleBtn, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.3
        }):Play()
        task.wait(1)
        TweenService:Create(toggleBtn, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.1
        }):Play()
        task.wait(1)
    end
end)

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

local isOpen = false
toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 380, 0, 420),
            Position = UDim2.new(0.5, -190, 0.5, -210)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.2)
        mainFrame.Visible = false
    end
end)

-- Hotkey toggle
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleBtn.MouseButton1Click:Fire()
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              MOBILE FLY CONTROLS                              ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝
local mobileFrame = Instance.new("Frame")
mobileFrame.Name = "MobileControls"
mobileFrame.Size = UDim2.new(0, 200, 0, 160)
mobileFrame.Position = UDim2.new(1, -210, 1, -170)
mobileFrame.BackgroundColor3 = THEME.FrameBg
mobileFrame.BackgroundTransparency = 0.3
mobileFrame.Visible = false
mobileFrame.ZIndex = 10
mobileFrame.Parent = gui
Instance.new("UICorner", mobileFrame).CornerRadius = UDim.new(0, 12)

local function createMobileBtn(text, pos, direction)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 45)
    btn.Position = pos
    btn.Text = text
    btn.TextSize = 22
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = THEME.ButtonBg
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.ZIndex = 11
    btn.Parent = mobileFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            State.MobileFlyTouching[direction] = true
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = THEME.Accent}):Play()
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            State.MobileFlyTouching[direction] = false
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = THEME.ButtonBg}):Play()
        end
    end)
    
    return btn
end

createMobileBtn("▲", UDim2.new(0.5, -22, 0, 10), "Up")
createMobileBtn("▼", UDim2.new(0.5, -22, 1, -55), "Down")
createMobileBtn("↑", UDim2.new(0.5, -22, 0.35, 0), "Forward")
createMobileBtn("↓", UDim2.new(0.5, -22, 0.55, 0), "Back")
createMobileBtn("←", UDim2.new(0.1, 0, 0.45, 0), "Left")
createMobileBtn("→", UDim2.new(0.9, -45, 0.45, 0), "Right")

-- Show mobile controls when flying on mobile
RunService.Heartbeat:Connect(function()
    mobileFrame.Visible = UIS.TouchEnabled and Settings.FlyEnabled
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              CORE FEATURES                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- NOCLIP
local function enableNoclip()
    if State.NoclipConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            State.NoclipParts[part] = part.CanCollide
        end
    end
    
    State.NoclipConnection = RunService.Stepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end)
    
    createNotification("Noclip", "Walk through walls enabled", 3, "success")
end

local function disableNoclip()
    if State.NoclipConnection then
        State.NoclipConnection:Disconnect()
        State.NoclipConnection = nil
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and State.NoclipParts[part] ~= nil then
                    part.CanCollide = State.NoclipParts[part]
                end
            end
        end
    end)
    
    State.NoclipParts = {}
    createNotification("Noclip", "Walk through walls disabled", 3, "info")
end

-- FLY
local flyBodyVelocity, flyBodyGyro

local function enableFly()
    if State.FlyConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    
    State.Flying = true
    State.FlyKeys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}
    State.LastValidPosition = hrp.CFrame
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Name = "FlyVelocity"
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Parent = hrp
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.Name = "FlyGyro"
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 1e6
    flyBodyGyro.Parent = hrp
    
    local keyDown = UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then State.FlyKeys.W = true end
        if input.KeyCode == Enum.KeyCode.A then State.FlyKeys.A = true end
        if input.KeyCode == Enum.KeyCode.S then State.FlyKeys.S = true end
        if input.KeyCode == Enum.KeyCode.D then State.FlyKeys.D = true end
        if input.KeyCode == Enum.KeyCode.Space then State.FlyKeys.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then State.FlyKeys.Shift = true end
    end)
    
    local keyUp = UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then State.FlyKeys.W = false end
        if input.KeyCode == Enum.KeyCode.A then State.FlyKeys.A = false end
        if input.KeyCode == Enum.KeyCode.S then State.FlyKeys.S = false end
        if input.KeyCode == Enum.KeyCode.D then State.FlyKeys.D = false end
        if input.KeyCode == Enum.KeyCode.Space then State.FlyKeys.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then State.FlyKeys.Shift = false end
    end)
    
    State.FlyConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not humanoid then return end
            
            local bv = hrp:FindFirstChild("FlyVelocity")
            local bg = hrp:FindFirstChild("FlyGyro")
            if not bv or not bg then return end
            
            local camera = workspace.CurrentCamera
            local direction = Vector3.new(0, 0, 0)
            local speed = Settings.FlySpeed
            
            -- Keyboard input
            if State.FlyKeys.W then direction = direction + camera.CFrame.LookVector end
            if State.FlyKeys.S then direction = direction - camera.CFrame.LookVector end
            if State.FlyKeys.A then direction = direction - camera.CFrame.RightVector end
            if State.FlyKeys.D then direction = direction + camera.CFrame.RightVector end
            if State.FlyKeys.Space then direction = direction + Vector3.new(0, 1, 0) end
            if State.FlyKeys.Shift then direction = direction - Vector3.new(0, 1, 0) end
            
            -- Mobile input
            if State.MobileFlyTouching.Forward then direction = direction + camera.CFrame.LookVector end
            if State.MobileFlyTouching.Back then direction = direction - camera.CFrame.LookVector end
            if State.MobileFlyTouching.Left then direction = direction - camera.CFrame.RightVector end
            if State.MobileFlyTouching.Right then direction = direction + camera.CFrame.RightVector end
            if State.MobileFlyTouching.Up then direction = direction + Vector3.new(0, 1, 0) end
            if State.MobileFlyTouching.Down then direction = direction - Vector3.new(0, 1, 0) end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit * speed
            end
            
            bv.Velocity = direction
            bg.CFrame = camera.CFrame
            
            humanoid.PlatformStand = true
        end)
    end)
    
    State.FlyKeyConnections = {keyDown, keyUp}
    createNotification("Fly", "Flying enabled - Use WASD + Space/Shift", 3, "success")
end

local function disableFly()
    State.Flying = false
    
    if State.FlyConnection then
        State.FlyConnection:Disconnect()
        State.FlyConnection = nil
    end
    
    if State.FlyKeyConnections then
        for _, conn in pairs(State.FlyKeyConnections) do
            if conn then conn:Disconnect() end
        end
        State.FlyKeyConnections = nil
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            
            if hrp then
                local bv = hrp:FindFirstChild("FlyVelocity")
                local bg = hrp:FindFirstChild("FlyGyro")
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
            
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end)
    
    createNotification("Fly", "Flying disabled", 3, "info")
end

-- SPEED
local function enableSpeed()
    if State.SpeedConnection then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                State.OriginalWalkSpeed = humanoid.WalkSpeed
            end
        end
    end)
    
    State.SpeedConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Settings.WalkSpeed
            end
        end)
    end)
    
    createNotification("Speed", "Speed boost enabled: " .. Settings.WalkSpeed, 3, "success")
end

local function disableSpeed()
    if State.SpeedConnection then
        State.SpeedConnection:Disconnect()
        State.SpeedConnection = nil
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = State.OriginalWalkSpeed
            end
        end
    end)
    
    createNotification("Speed", "Speed boost disabled", 3, "info")
end

-- INFINITE JUMP
local function enableInfiniteJump()
    if State.InfiniteJumpConnection then return end
    
    State.InfiniteJumpConnection = UIS.JumpRequest:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end)
    
    createNotification("Infinite Jump", "You can now jump infinitely!", 3, "success")
end

local function disableInfiniteJump()
    if State.InfiniteJumpConnection then
        State.InfiniteJumpConnection:Disconnect()
        State.InfiniteJumpConnection = nil
    end
    
    createNotification("Infinite Jump", "Infinite jump disabled", 3, "info")
end

-- JUMP BOOST
local function enableJumpBoost()
    if State.JumpBoostConnection then return end
    
    State.JumpBoostConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = Settings.JumpPower
                    humanoid.JumpHeight = Settings.JumpPower / 3
                end
            end
        end)
    end)
    
    createNotification("Jump Boost", "Jump power: " .. Settings.JumpPower, 3, "success")
end

local function disableJumpBoost()
    if State.JumpBoostConnection then
        State.JumpBoostConnection:Disconnect()
        State.JumpBoostConnection = nil
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = State.OriginalJumpPower
            end
        end
    end)
    
    createNotification("Jump Boost", "Jump boost disabled", 3, "info")
end

-- NO FALL DAMAGE
local function enableNoFall()
    if State.NoFallConnection then return end
    
    State.NoFallConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                end
            end
        end)
    end)
    
    createNotification("No Fall Damage", "Fall damage disabled", 3, "success")
end

local function disableNoFall()
    if State.NoFallConnection then
        State.NoFallConnection:Disconnect()
        State.NoFallConnection = nil
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end
    end)
    
    createNotification("No Fall Damage", "Fall damage enabled", 3, "info")
end

-- NO VOID
local function enableNoVoid()
    if State.VoidPlatform then return end
    
    State.VoidPlatform = Instance.new("Part")
    State.VoidPlatform.Name = "VoidPlatform"
    State.VoidPlatform.Size = Vector3.new(500, 5, 500)
    State.VoidPlatform.Position = Vector3.new(0, -200, 0)
    State.VoidPlatform.Anchored = true
    State.VoidPlatform.Transparency = 0.8
    State.VoidPlatform.BrickColor = BrickColor.new("Really red")
    State.VoidPlatform.Material = Enum.Material.Neon
    State.VoidPlatform.CanCollide = true
    State.VoidPlatform.Parent = workspace
    
    State.NoVoidConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < -180 then
                    hrp.CFrame = CFrame.new(hrp.Position.X, -195, hrp.Position.Z)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    end)
    
    createNotification("No Void", "Void protection enabled", 3, "success")
end

local function disableNoVoid()
    if State.VoidPlatform then
        State.VoidPlatform:Destroy()
        State.VoidPlatform = nil
    end
    
    if State.NoVoidConnection then
        State.NoVoidConnection:Disconnect()
        State.NoVoidConnection = nil
    end
    
    createNotification("No Void", "Void protection disabled", 3, "info")
end

-- ANTI-AFK
local function enableAntiAFK()
    if State.AntiAFKConnection then return end
    
    local VirtualUser = game:GetService("VirtualUser")
    
    State.AntiAFKConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    createNotification("Anti-AFK", "You won't be kicked for being idle", 3, "success")
end

local function disableAntiAFK()
    if State.AntiAFKConnection then
        State.AntiAFKConnection:Disconnect()
        State.AntiAFKConnection = nil
    end
    
    createNotification("Anti-AFK", "Anti-AFK disabled", 3, "info")
end

-- FULLBRIGHT
local function enableFullbright()
    -- Store original lighting
    State.OriginalLighting = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient
    }
    
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    
    createNotification("Fullbright", "Maximum brightness enabled", 3, "success")
end

local function disableFullbright()
    if State.OriginalLighting then
        Lighting.Ambient = State.OriginalLighting.Ambient
        Lighting.Brightness = State.OriginalLighting.Brightness
        Lighting.ClockTime = State.OriginalLighting.ClockTime
        Lighting.FogEnd = State.OriginalLighting.FogEnd
        Lighting.GlobalShadows = State.OriginalLighting.GlobalShadows
        Lighting.OutdoorAmbient = State.OriginalLighting.OutdoorAmbient
    end
    
    createNotification("Fullbright", "Original lighting restored", 3, "info")
end

-- AUTO GG
local function enableAutoGG()
    if State.AutoGGConnection then return end
    
    State.AutoGGConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local roundStatus = ReplicatedStorage:FindFirstChild("Status")
            if roundStatus then
                local status = roundStatus.Value
                if status:find("won") or status:find("Win") or status:find("escaped") then
                    if State.LastRoundState ~= status then
                        State.LastRoundState = status
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG!", "All")
                    end
                end
            end
        end)
    end)
    
    createNotification("Auto GG", "Will say GG when round ends", 3, "success")
end

local function disableAutoGG()
    if State.AutoGGConnection then
        State.AutoGGConnection:Disconnect()
        State.AutoGGConnection = nil
    end
    State.LastRoundState = nil
    
    createNotification("Auto GG", "Auto GG disabled", 3, "info")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              ESP SYSTEMS                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Player ESP with role detection
local function createPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function addHighlight()
        pcall(function()
            local char = player.Character
            if not char then return end
            
            -- Remove old highlight
            local oldHighlight = char:FindFirstChild("ESPHighlight")
            if oldHighlight then oldHighlight:Destroy() end
            
            local role = getPlayerRole(player)
            local color = getRoleColor(role)
            
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = color
            highlight.OutlineColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = char
            
            -- Billboard for name and role
            local head = char:FindFirstChild("Head")
            if head then
                local oldBillboard = head:FindFirstChild("ESPBillboard")
                if oldBillboard then oldBillboard:Destroy() end
                
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPBillboard"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = head
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
                nameLabel.TextScaled = true
                nameLabel.Parent = billboard
                
                local roleLabel = Instance.new("TextLabel")
                roleLabel.Size = UDim2.new(1, 0, 0.5, 0)
                roleLabel.Position = UDim2.new(0, 0, 0.5, 0)
                roleLabel.BackgroundTransparency = 1
                roleLabel.Text = "[" .. role .. "]"
                roleLabel.TextColor3 = color
                roleLabel.TextStrokeTransparency = 0
                roleLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                roleLabel.Font = Enum.Font.GothamBold
                roleLabel.TextSize = 12
                roleLabel.TextScaled = true
                roleLabel.Parent = billboard
            end
        end)
    end
    
    addHighlight()
    
    -- Update ESP when character changes
    State.ESPConnections[player] = player.CharacterAdded:Connect(addHighlight)
    
    -- Update role periodically
    spawn(function()
        while Settings.ESPEnabled and player and player.Parent do
            task.wait(1)
            if player.Character then
                addHighlight()
            end
        end
    end)
end

local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        createPlayerESP(player)
    end
    
    State.ESPConnections["PlayerAdded"] = Players.PlayerAdded:Connect(createPlayerESP)
    
    createNotification("Player ESP", "ESP enabled with role detection", 3, "success")
end

local function disableESP()
    for _, conn in pairs(State.ESPConnections) do
        if typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    State.ESPConnections = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then highlight:Destroy() end
            
            local head = player.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("ESPBillboard")
                if billboard then billboard:Destroy() end
            end
        end
    end
    
    createNotification("Player ESP", "ESP disabled", 3, "info")
end

-- Coin ESP
local function findAllCoins()
    local coins = {}
    
    local coinContainers = {
        workspace:FindFirstChild("Normal"),
        workspace:FindFirstChild("CoinContainer"),
        workspace:FindFirstChild("Coins"),
        workspace:FindFirstChild("Map")
    }
    
    for _, container in ipairs(coinContainers) do
        if container then
            for _, obj in pairs(container:GetDescendants()) do
                if (obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation")) then
                    if obj.Name == "Coin" or obj.Name:lower():find("coin") then
                        table.insert(coins, obj)
                    end
                end
            end
        end
    end
    
    if #coins == 0 then
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("Part") or obj:IsA("MeshPart")) and obj.Name == "Coin" then
                table.insert(coins, obj)
            end
        end
    end
    
    return coins
end

local function enableCoinESP()
    disableCoinESP()
    
    local coins = findAllCoins()
    
    for _, coin in ipairs(coins) do
        if coin and coin.Parent and not coin:FindFirstChild("CoinESP") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "CoinESP"
            highlight.FillColor = Color3.fromRGB(255, 215, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
            highlight.FillTransparency = 0.2
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = coin
        end
    end
    
    State.CoinESPConnections.Update = workspace.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        if Settings.CoinESPEnabled and (obj:IsA("Part") or obj:IsA("MeshPart")) then
            if obj.Name == "Coin" or obj.Name:lower():find("coin") then
                if not obj:FindFirstChild("CoinESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "CoinESP"
                    highlight.FillColor = Color3.fromRGB(255, 215, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
                    highlight.FillTransparency = 0.2
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = obj
                end
            end
        end
    end)
    
    createNotification("Coin ESP", "Found " .. #coins .. " coins", 3, "success")
end

local function disableCoinESP()
    if State.CoinESPConnections.Update then
        State.CoinESPConnections.Update:Disconnect()
        State.CoinESPConnections.Update = nil
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "CoinESP" and obj:IsA("Highlight") then
            obj:Destroy()
        end
    end
end

-- Gun/Trap ESP
local function enableGunESP()
    local function addGunHighlight(obj)
        if obj.Name == "GunDrop" or obj.Name == "Gun" then
            if not obj:FindFirstChild("GunESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "GunESP"
                highlight.FillColor = Color3.fromRGB(0, 150, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 200, 255)
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = obj
            end
        end
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        addGunHighlight(obj)
    end
    
    State.GunESPConnections.Update = workspace.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        if Settings.GunESP then
            addGunHighlight(obj)
        end
    end)
    
    createNotification("Gun ESP", "Gun locations highlighted", 3, "success")
end

local function disableGunESP()
    if State.GunESPConnections.Update then
        State.GunESPConnections.Update:Disconnect()
        State.GunESPConnections.Update = nil
    end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunESP" and obj:IsA("Highlight") then
            obj:Destroy()
        end
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              COMBAT FEATURES                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Silent Aim
local function enableSilentAim()
    if State.SilentAimConnection then return end
    
    State.SilentAimConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool or (tool.Name ~= "Gun" and tool.Name ~= "Revolver") then return end
            
            local nearestPlayer = nil
            local nearestDistance = math.huge
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetChar = player.Character
                    local targetHead = targetChar:FindFirstChild("Head")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    
                    if targetHead and hrp then
                        local distance = (hrp.Position - targetHead.Position).Magnitude
                        
                        if distance < nearestDistance and distance < 300 then
                            nearestDistance = distance
                            nearestPlayer = player
                        end
                    end
                end
            end
            
            if nearestPlayer and nearestPlayer.Character then
                local targetHead = nearestPlayer.Character:FindFirstChild("Head")
                if targetHead then
                    local camera = workspace.CurrentCamera
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)
                end
            end
        end)
    end)
    
    createNotification("Silent Aim", "Auto-aim enabled for Sheriff", 3, "success")
end

local function disableSilentAim()
    if State.SilentAimConnection then
        State.SilentAimConnection:Disconnect()
        State.SilentAimConnection = nil
    end
    
    createNotification("Silent Aim", "Auto-aim disabled", 3, "info")
end

-- Kill Aura
local function enableKillAura()
    if State.KillAuraConnection then return end
    
    State.KillAuraConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local knife = char:FindFirstChild("Knife") or char:FindFirstChildWhichIsA("Tool")
            if not knife or knife.Name ~= "Knife" then return end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        local distance = (hrp.Position - targetHrp.Position).Magnitude
                        if distance <= Settings.KillAuraRange then
                            -- Simulate knife attack
                            local remote = knife:FindFirstChild("Stab") or knife:FindFirstChildWhichIsA("RemoteEvent")
                            if remote then
                                remote:FireServer(player.Character:FindFirstChild("Humanoid"))
                            end
                        end
                    end
                end
            end
        end)
    end)
    
    createNotification("Kill Aura", "Auto-kill in range: " .. Settings.KillAuraRange, 3, "warning")
end

local function disableKillAura()
    if State.KillAuraConnection then
        State.KillAuraConnection:Disconnect()
        State.KillAuraConnection = nil
    end
    
    createNotification("Kill Aura", "Kill aura disabled", 3, "info")
end

-- Auto Farm Coins
local function enableAutoFarm()
    if State.AutoFarmConnection then return end
    
    State.FarmingCoins = true
    
    State.AutoFarmConnection = RunService.Heartbeat:Connect(function()
        if not State.FarmingCoins then return end
        
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local coins = findAllCoins()
            if #coins == 0 then return end
            
            local nearestCoin = nil
            local nearestDistance = math.huge
            
            for _, coin in pairs(coins) do
                if coin and coin.Parent then
                    local distance = (hrp.Position - coin.Position).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestCoin = coin
                    end
                end
            end
            
            if nearestCoin and nearestCoin.Parent then
                hrp.CFrame = CFrame.new(nearestCoin.Position + Vector3.new(0, 2, 0))
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end)
    
    createNotification("Auto Farm", "Farming coins automatically", 3, "success")
end

local function disableAutoFarm()
    State.FarmingCoins = false
    
    if State.AutoFarmConnection then
        State.AutoFarmConnection:Disconnect()
        State.AutoFarmConnection = nil
    end
    
    createNotification("Auto Farm", "Auto farm disabled", 3, "info")
end

-- Fling
local function enableFling()
    if State.FlingConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlingVelocity"
    bodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FlingGyro"
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.P = 1e6
    bodyGyro.Parent = hrp
    
    State.FlingConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local bv = hrp:FindFirstChild("FlingVelocity")
            local bg = hrp:FindFirstChild("FlingGyro")
            
            if bv and bg then
                bg.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(9999), 0)
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
            end
        end)
    end)
    
    createNotification("Fling", "Fling mode enabled - Touch players to fling", 3, "warning")
end

local function disableFling()
    if State.FlingConnection then
        State.FlingConnection:Disconnect()
        State.FlingConnection = nil
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("FlingVelocity")
                local bg = hrp:FindFirstChild("FlingGyro")
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    createNotification("Fling", "Fling mode disabled", 3, "info")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              TELEPORT FUNCTIONS                               ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function teleportToPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return end
    
    local char = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    
    if not char or not targetChar then
        createNotification("Teleport", "Character not found", 3, "error")
        return
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not targetHrp then
        createNotification("Teleport", "HumanoidRootPart not found", 3, "error")
        return
    end
    
    local newCFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
    
    if safeSetCFrame(hrp, newCFrame) then
        createNotification("Teleport", "Teleported to " .. targetPlayer.Name, 3, "success")
    else
        createNotification("Teleport", "Teleport failed", 3, "error")
    end
end

local function teleportToRandom()
    local playersList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            table.insert(playersList, player)
        end
    end
    
    if #playersList == 0 then
        createNotification("Teleport", "No other players found", 3, "error")
        return
    end
    
    local randomPlayer = playersList[math.random(1, #playersList)]
    teleportToPlayer(randomPlayer)
end

local function teleportToLobby()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Common lobby spawn positions in MM2
    local lobbyPositions = {
        Vector3.new(0, 10, 0),
        Vector3.new(-110, 140, 45),
        Vector3.new(0, 5, 0)
    }
    
    local spawn = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("SpawnLocation")
    if spawn then
        hrp.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
    else
        hrp.CFrame = CFrame.new(lobbyPositions[1])
    end
    
    createNotification("Teleport", "Teleported to lobby", 3, "success")
end

local function teleportToGun()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name == "Gun") then
            local targetPos = obj:IsA("BasePart") and obj.Position or (obj:FindFirstChild("Handle") and obj.Handle.Position)
            if targetPos then
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                createNotification("Teleport", "Teleported to gun", 3, "success")
                return
            end
        end
    end
    
    createNotification("Teleport", "No gun found", 3, "error")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              SHADER SYSTEM                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Store original lighting settings
local function storeOriginalLighting()
    State.OriginalLighting = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        ColorShift_Top = Lighting.ColorShift_Top,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        ExposureCompensation = Lighting.ExposureCompensation,
        FogColor = Lighting.FogColor,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        GeographicLatitude = Lighting.GeographicLatitude,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ShadowSoftness = Lighting.ShadowSoftness,
    }
end

local function restoreOriginalLighting()
    if State.OriginalLighting then
        for prop, value in pairs(State.OriginalLighting) do
            pcall(function()
                Lighting[prop] = value
            end)
        end
    end
end

-- Create/Get Atmosphere
local function getOrCreateAtmosphere()
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if not atmo then
        atmo = Instance.new("Atmosphere")
        atmo.Parent = Lighting
    end
    State.Atmosphere = atmo
    return atmo
end

-- Create/Get Sky
local function getOrCreateSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
    end
    State.SkyboxObject = sky
    return sky
end

-- Create/Get Bloom
local function getOrCreateBloom()
    local bloom = Lighting:FindFirstChild("ShaderBloom")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Name = "ShaderBloom"
        bloom.Enabled = false
        bloom.Parent = Lighting
    end
    State.BloomEffect = bloom
    return bloom
end

-- Create/Get ColorCorrection
local function getOrCreateColorCorrection()
    local cc = Lighting:FindFirstChild("ShaderColorCorrection")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "ShaderColorCorrection"
        cc.Enabled = false
        cc.Parent = Lighting
    end
    State.ColorCorrection = cc
    return cc
end

-- Create/Get SunRays
local function getOrCreateSunRays()
    local rays = Lighting:FindFirstChild("ShaderSunRays")
    if not rays then
        rays = Instance.new("SunRaysEffect")
        rays.Name = "ShaderSunRays"
        rays.Enabled = false
        rays.Parent = Lighting
    end
    State.SunRays = rays
    return rays
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              AURORA BOREALIS                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function createAuroraPart(index)
    local part = Instance.new("Part")
    part.Name = "AuroraPart_" .. index
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Transparency = 0.3
    part.Size = Vector3.new(math.random(50, 150), math.random(100, 300), 5)
    part.CFrame = CFrame.new(
        math.random(-500, 500),
        math.random(200, 400),
        math.random(-500, 500)
    ) * CFrame.Angles(0, math.rad(math.random(0, 360)), math.rad(math.random(-20, 20)))
    
    -- Aurora colors
    local colors = {
        Color3.fromRGB(0, 255, 127),   -- Green
        Color3.fromRGB(0, 191, 255),   -- Deep Sky Blue
        Color3.fromRGB(148, 0, 211),   -- Violet
        Color3.fromRGB(75, 0, 130),    -- Indigo
        Color3.fromRGB(0, 255, 255),   -- Cyan
    }
    part.Color = colors[math.random(1, #colors)]
    part.Parent = workspace
    
    return part
end

local function enableAurora()
    if State.AuroraConnection then return end
    
    storeOriginalLighting()
    
    -- Create aurora parts
    for i = 1, 15 do
        local part = createAuroraPart(i)
        table.insert(State.AuroraParticles, part)
    end
    
    -- Set night sky
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.5
    Lighting.Ambient = Color3.fromRGB(20, 30, 40)
    Lighting.OutdoorAmbient = Color3.fromRGB(30, 50, 70)
    
    local atmo = getOrCreateAtmosphere()
    atmo.Density = 0.3
    atmo.Color = Color3.fromRGB(20, 40, 60)
    atmo.Decay = Color3.fromRGB(30, 50, 80)
    atmo.Glare = 0
    atmo.Haze = 1
    
    -- Enable bloom for glow effect
    local bloom = getOrCreateBloom()
    bloom.Enabled = true
    bloom.Intensity = 1.5
    bloom.Size = 40
    bloom.Threshold = 0.8
    
    -- Animate aurora
    local time = 0
    State.AuroraConnection = RunService.Heartbeat:Connect(function(dt)
        time = time + dt
        
        for i, part in ipairs(State.AuroraParticles) do
            if part and part.Parent then
                -- Wave motion
                local waveOffset = math.sin(time * 0.5 + i * 0.5) * 20
                local verticalWave = math.cos(time * 0.3 + i * 0.3) * 10
                
                part.CFrame = part.CFrame * CFrame.new(0, verticalWave * dt, waveOffset * dt)
                
                -- Color shift
                local hue = (time * 0.1 + i * 0.1) % 1
                local color = Color3.fromHSV(hue * 0.3 + 0.3, 0.8, 1)
                part.Color = color
                
                -- Transparency pulse
                part.Transparency = 0.3 + math.sin(time * 2 + i) * 0.2
            end
        end
    end)
    
    createNotification("Aurora Borealis", "Northern lights enabled", 3, "success")
end

local function disableAurora()
    if State.AuroraConnection then
        State.AuroraConnection:Disconnect()
        State.AuroraConnection = nil
    end
    
    -- Remove aurora parts
    for _, part in ipairs(State.AuroraParticles) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    State.AuroraParticles = {}
    
    -- Disable bloom
    local bloom = Lighting:FindFirstChild("ShaderBloom")
    if bloom then bloom.Enabled = false end
    
    restoreOriginalLighting()
    
    createNotification("Aurora Borealis", "Northern lights disabled", 3, "info")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              THUNDERSTORM                                     ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function createLightningFlash()
    local flash = Instance.new("ColorCorrectionEffect")
    flash.Name = "LightningFlash"
    flash.Brightness = 0
    flash.Contrast = 0
    flash.Saturation = 0
    flash.TintColor = Color3.new(1, 1, 1)
    flash.Parent = Lighting
    return flash
end

local function enableThunderstorm()
    if State.ThunderstormConnection then return end
    
    storeOriginalLighting()
    
    -- Dark stormy atmosphere
    Lighting.ClockTime = 15
    Lighting.Brightness = 0.3
    Lighting.Ambient = Color3.fromRGB(30, 35, 45)
    Lighting.OutdoorAmbient = Color3.fromRGB(40, 45, 55)
    Lighting.FogColor = Color3.fromRGB(50, 55, 65)
    Lighting.FogEnd = 500
    Lighting.FogStart = 50
    
    local atmo = getOrCreateAtmosphere()
    atmo.Density = 0.5
    atmo.Color = Color3.fromRGB(60, 65, 75)
    atmo.Decay = Color3.fromRGB(50, 55, 65)
    atmo.Glare = 0
    atmo.Haze = 2
    
    -- Create lightning flash effect
    State.LightningFlash = createLightningFlash()
    
    -- Create rain particles
    local rainFolder = Instance.new("Folder")
    rainFolder.Name = "RainParticles"
    rainFolder.Parent = workspace
    
    for i = 1, 50 do
        local rain = Instance.new("Part")
        rain.Name = "RainDrop_" .. i
        rain.Size = Vector3.new(0.1, 3, 0.1)
        rain.Material = Enum.Material.Neon
        rain.Color = Color3.fromRGB(150, 170, 200)
        rain.Transparency = 0.5
        rain.Anchored = true
        rain.CanCollide = false
        rain.CFrame = CFrame.new(
            math.random(-200, 200),
            math.random(50, 150),
            math.random(-200, 200)
        )
        rain.Parent = rainFolder
        table.insert(State.RainParticles, rain)
    end
    
    -- Animate storm
    local time = 0
    local nextLightning = math.random(3, 8)
    
    State.ThunderstormConnection = RunService.Heartbeat:Connect(function(dt)
        time = time + dt
        
        -- Animate rain
        for _, rain in ipairs(State.RainParticles) do
            if rain and rain.Parent then
                local newY = rain.Position.Y - 100 * dt
                if newY < 0 then
                    newY = math.random(100, 200)
                    rain.CFrame = CFrame.new(
                        math.random(-200, 200),
                        newY,
                        math.random(-200, 200)
                    )
                else
                    rain.CFrame = CFrame.new(rain.Position.X, newY, rain.Position.Z)
                end
            end
        end
        
        -- Lightning flashes
        if time >= nextLightning then
            nextLightning = time + math.random(3, 10)
            
            -- Flash sequence
            spawn(function()
                if State.LightningFlash then
                    -- Bright flash
                    State.LightningFlash.Brightness = 2
                    Lighting.Brightness = 3
                    task.wait(0.05)
                    State.LightningFlash.Brightness = 0
                    Lighting.Brightness = 0.3
                    task.wait(0.1)
                    -- Second flash
                    State.LightningFlash.Brightness = 1.5
                    Lighting.Brightness = 2
                    task.wait(0.03)
                    State.LightningFlash.Brightness = 0
                    Lighting.Brightness = 0.3
                end
            end)
        end
        
        -- Ambient flicker
        local flicker = math.sin(time * 10) * 0.05
        Lighting.Brightness = 0.3 + flicker
    end)
    
    createNotification("Thunderstorm", "Storm effects enabled", 3, "success")
end

local function disableThunderstorm()
    if State.ThunderstormConnection then
        State.ThunderstormConnection:Disconnect()
        State.ThunderstormConnection = nil
    end
    
    -- Remove rain
    for _, rain in ipairs(State.RainParticles) do
        if rain and rain.Parent then
            rain:Destroy()
        end
    end
    State.RainParticles = {}
    
    local rainFolder = workspace:FindFirstChild("RainParticles")
    if rainFolder then rainFolder:Destroy() end
    
    -- Remove lightning flash
    if State.LightningFlash then
        State.LightningFlash:Destroy()
        State.LightningFlash = nil
    end
    
    restoreOriginalLighting()
    
    createNotification("Thunderstorm", "Storm effects disabled", 3, "info")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              SNOW EFFECTS                                     ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function enableSnow()
    if State.SnowConnection then return end
    
    storeOriginalLighting()
    
    -- Winter atmosphere
    Lighting.ClockTime = 10
    Lighting.Brightness = 1.5
    Lighting.Ambient = Color3.fromRGB(180, 190, 210)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 210, 230)
    Lighting.FogColor = Color3.fromRGB(220, 230, 245)
    Lighting.FogEnd = 800
    Lighting.FogStart = 100
    
    local atmo = getOrCreateAtmosphere()
    atmo.Density = 0.4
    atmo.Color = Color3.fromRGB(200, 210, 230)
    atmo.Decay = Color3.fromRGB(180, 190, 210)
    atmo.Glare = 0.2
    atmo.Haze = 1.5
    
    -- Color correction for cold feel
    local cc = getOrCreateColorCorrection()
    cc.Enabled = true
    cc.Brightness = 0.05
    cc.Contrast = 0.1
    cc.Saturation = -0.2
    cc.TintColor = Color3.fromRGB(220, 230, 255)
    
    -- Create snowflakes
    local snowFolder = Instance.new("Folder")
    snowFolder.Name = "SnowParticles"
    snowFolder.Parent = workspace
    
    for i = 1, 100 do
        local snow = Instance.new("Part")
        snow.Name = "Snowflake_" .. i
        snow.Shape = Enum.PartType.Ball
        snow.Size = Vector3.new(
            math.random(1, 3) / 10,
            math.random(1, 3) / 10,
            math.random(1, 3) / 10
        )
        snow.Material = Enum.Material.Neon
        snow.Color = Color3.fromRGB(255, 255, 255)
        snow.Transparency = 0.3
        snow.Anchored = true
        snow.CanCollide = false
        snow.CFrame = CFrame.new(
            math.random(-300, 300),
            math.random(50, 200),
            math.random(-300, 300)
        )
        snow.Parent = snowFolder
        table.insert(State.SnowParticles, {
            part = snow,
            speed = math.random(10, 30),
            drift = math.random(-5, 5) / 10,
            spin = math.random(-180, 180)
        })
    end
    
    -- Animate snow
    local time = 0
    State.SnowConnection = RunService.Heartbeat:Connect(function(dt)
        time = time + dt
        
        for _, snowData in ipairs(State.SnowParticles) do
            local snow = snowData.part
            if snow and snow.Parent then
                -- Fall with drift
                local newY = snow.Position.Y - snowData.speed * dt
                local driftX = math.sin(time * snowData.drift) * 0.5
                local driftZ = math.cos(time * snowData.drift * 0.7) * 0.5
                
                if newY < 0 then
                    newY = math.random(150, 250)
                    snow.CFrame = CFrame.new(
                        math.random(-300, 300),
                        newY,
                        math.random(-300, 300)
                    )
                else
                    snow.CFrame = CFrame.new(
                        snow.Position.X + driftX * dt,
                        newY,
                        snow.Position.Z + driftZ * dt
                    ) * CFrame.Angles(0, math.rad(snowData.spin * dt), 0)
                end
            end
        end
    end)
    
    createNotification("Snow", "Winter wonderland enabled", 3, "success")
end

local function disableSnow()
    if State.SnowConnection then
        State.SnowConnection:Disconnect()
        State.SnowConnection = nil
    end
    
    -- Remove snowflakes
    for _, snowData in ipairs(State.SnowParticles) do
        if snowData.part and snowData.part.Parent then
            snowData.part:Destroy()
        end
    end
    State.SnowParticles = {}
    
    local snowFolder = workspace:FindFirstChild("SnowParticles")
    if snowFolder then snowFolder:Destroy() end
    
    -- Disable color correction
    local cc = Lighting:FindFirstChild("ShaderColorCorrection")
    if cc then cc.Enabled = false end
    
    restoreOriginalLighting()
    
    createNotification("Snow", "Snow effects disabled", 3, "info")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              DYNAMIC SKY                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function enableDynamicSky()
    if State.DynamicSkyConnection then return end
    
    storeOriginalLighting()
    
    local atmo = getOrCreateAtmosphere()
    local bloom = getOrCreateBloom()
    local sunRays = getOrCreateSunRays()
    
    bloom.Enabled = true
    bloom.Intensity = 0.5
    bloom.Size = 24
    bloom.Threshold = 0.9
    
    sunRays.Enabled = true

    sunRays.Intensity = 0.1
    sunRays.Spread = 0.5
    
    local time = Settings.TimeOfDay
    
    State.DynamicSkyConnection = RunService.Heartbeat:Connect(function(dt)
        -- Slowly advance time
        time = time + dt * 0.01
        if time >= 24 then time = 0 end
        
        Lighting.ClockTime = time
        
        -- Adjust atmosphere based on time
        local isDaytime = time >= 6 and time <= 18
        local isSunrise = time >= 5 and time <= 7
        local isSunset = time >= 17 and time <= 19
        local isNight = time < 5 or time > 19
        
        if isSunrise then
            atmo.Color = lerpColor(
                Color3.fromRGB(255, 150, 100),
                Color3.fromRGB(200, 220, 255),
                (time - 5) / 2
            )
            atmo.Decay = Color3.fromRGB(255, 100, 50)
            Lighting.Brightness = lerp(0.5, 2, (time - 5) / 2)
            sunRays.Intensity = lerp(0.3, 0.1, (time - 5) / 2)
        elseif isSunset then
            atmo.Color = lerpColor(
                Color3.fromRGB(200, 220, 255),
                Color3.fromRGB(255, 100, 50),
                (time - 17) / 2
            )
            atmo.Decay = Color3.fromRGB(255, 80, 30)
            Lighting.Brightness = lerp(2, 0.5, (time - 17) / 2)
            sunRays.Intensity = lerp(0.1, 0.4, (time - 17) / 2)
        elseif isDaytime then
            atmo.Color = Color3.fromRGB(200, 220, 255)
            atmo.Decay = Color3.fromRGB(180, 200, 230)
            Lighting.Brightness = 2
            sunRays.Intensity = 0.1
        else
            atmo.Color = Color3.fromRGB(20, 30, 50)
            atmo.Decay = Color3.fromRGB(10, 15, 30)
            Lighting.Brightness = 0.3
            sunRays.Intensity = 0
        end
        
        atmo.Density = Settings.CloudDensity
        atmo.Haze = 1 + Settings.CloudDensity
    end)
    
    createNotification("Dynamic Sky", "Day/night cycle enabled", 3, "success")
end

local function disableDynamicSky()
    if State.DynamicSkyConnection then
        State.DynamicSkyConnection:Disconnect()
        State.DynamicSkyConnection = nil
    end
    
    local bloom = Lighting:FindFirstChild("ShaderBloom")
    if bloom then bloom.Enabled = false end
    
    local sunRays = Lighting:FindFirstChild("ShaderSunRays")
    if sunRays then sunRays.Enabled = false end
    
    restoreOriginalLighting()
    
    createNotification("Dynamic Sky", "Dynamic sky disabled", 3, "info")
end

-- Weather Presets
local function setWeatherPreset(preset)
    -- Disable all weather effects first
    disableAurora()
    disableThunderstorm()
    disableSnow()
    disableDynamicSky()
    
    task.wait(0.1)
    
    if preset == "Clear" then
        restoreOriginalLighting()
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        createNotification("Weather", "Clear skies", 3, "success")
        
    elseif preset == "Aurora" then
        enableAurora()
        
    elseif preset == "Thunderstorm" then
        enableThunderstorm()
        
    elseif preset == "Snow" then
        enableSnow()
        
    elseif preset == "Dynamic" then
        enableDynamicSky()
        
    elseif preset == "Night" then
        storeOriginalLighting()
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.fromRGB(30, 40, 60)
        Lighting.OutdoorAmbient = Color3.fromRGB(40, 50, 70)
        
        local atmo = getOrCreateAtmosphere()
        atmo.Density = 0.3
        atmo.Color = Color3.fromRGB(30, 40, 70)
        
        createNotification("Weather", "Night mode enabled", 3, "success")
        
    elseif preset == "Sunset" then
        storeOriginalLighting()
        Lighting.ClockTime = 18
        Lighting.Brightness = 1.5
        Lighting.Ambient = Color3.fromRGB(150, 100, 80)
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 150, 100)
        
        local atmo = getOrCreateAtmosphere()
        atmo.Color = Color3.fromRGB(255, 150, 100)
        atmo.Decay = Color3.fromRGB(255, 100, 50)
        atmo.Density = 0.35
        
        local sunRays = getOrCreateSunRays()
        sunRays.Enabled = true
        sunRays.Intensity = 0.3
        sunRays.Spread = 0.8
        
        createNotification("Weather", "Sunset mode enabled", 3, "success")
        
    elseif preset == "Foggy" then
        storeOriginalLighting()
        Lighting.ClockTime = 8
        Lighting.Brightness = 1
        Lighting.FogColor = Color3.fromRGB(180, 185, 195)
        Lighting.FogEnd = 200
        Lighting.FogStart = 10
        Lighting.Ambient = Color3.fromRGB(150, 155, 165)
        
        local atmo = getOrCreateAtmosphere()
        atmo.Density = 0.6
        atmo.Color = Color3.fromRGB(180, 185, 195)
        atmo.Haze = 3
        
        createNotification("Weather", "Foggy atmosphere enabled", 3, "success")
    end
    
    Settings.CurrentWeather = preset
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              POST-PROCESSING                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function enableBloom()
    local bloom = getOrCreateBloom()
    bloom.Enabled = true
    bloom.Intensity = Settings.BloomIntensity
    bloom.Size = 24
    bloom.Threshold = 0.8
    
    createNotification("Bloom", "Bloom effect enabled", 3, "success")
end

local function disableBloom()
    local bloom = Lighting:FindFirstChild("ShaderBloom")
    if bloom then bloom.Enabled = false end
    
    createNotification("Bloom", "Bloom effect disabled", 3, "info")
end

local function enableColorCorrection()
    local cc = getOrCreateColorCorrection()
    cc.Enabled = true
    cc.Brightness = 0.05
    cc.Contrast = 0.15
    cc.Saturation = 0.1
    
    createNotification("Color Correction", "Enhanced colors enabled", 3, "success")
end

local function disableColorCorrection()
    local cc = Lighting:FindFirstChild("ShaderColorCorrection")
    if cc then cc.Enabled = false end
    
    createNotification("Color Correction", "Color correction disabled", 3, "info")
end

local function enableSunRays()
    local rays = getOrCreateSunRays()
    rays.Enabled = true
    rays.Intensity = 0.15
    rays.Spread = 0.5
    
    createNotification("Sun Rays", "God rays enabled", 3, "success")
end

local function disableSunRays()
    local rays = Lighting:FindFirstChild("ShaderSunRays")
    if rays then rays.Enabled = false end
    
    createNotification("Sun Rays", "God rays disabled", 3, "info")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              UI ELEMENTS SETUP                                ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- MAIN TAB
createSection("Main", "Movement")

createToggle("Main", {
    Name = "Walk Through Walls",
    Description = "Phase through solid objects",
    Callback = function(enabled)
        Settings.NoclipEnabled = enabled
        if enabled then enableNoclip() else disableNoclip() end
    end
})

createToggle("Main", {
    Name = "Fly Mode",
    Description = "WASD + Space/Shift to fly",
    Callback = function(enabled)
        Settings.FlyEnabled = enabled
        if enabled then enableFly() else disableFly() end
    end
})

createSlider("Main", {
    Name = "Fly Speed",
    Min = 20,
    Max = 200,
    Default = 50,
    Callback = function(value)
        Settings.FlySpeed = value
    end
})

createToggle("Main", {
    Name = "Speed Boost",
    Description = "Increase walk speed",
    Callback = function(enabled)
        Settings.SpeedEnabled = enabled
        if enabled then enableSpeed() else disableSpeed() end
    end
})

createSlider("Main", {
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 25,
    Suffix = "",
    Callback = function(value)
        Settings.WalkSpeed = value
    end
})

createSection("Main", "Jumping")

createToggle("Main", {
    Name = "Infinite Jump",
    Description = "Jump unlimited times in air",
    Callback = function(enabled)
        Settings.InfiniteJump = enabled
        if enabled then enableInfiniteJump() else disableInfiniteJump() end
    end
})

createToggle("Main", {
    Name = "Jump Boost",
    Description = "Increase jump power",
    Callback = function(enabled)
        Settings.JumpBoost = enabled
        if enabled then enableJumpBoost() else disableJumpBoost() end
    end
})

createSlider("Main", {
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        Settings.JumpPower = value
    end
})

createSection("Main", "Combat")

createToggle("Main", {
    Name = "Kill Aura (Murderer)",
    Description = "Auto-kill players in range",
    Callback = function(enabled)
        Settings.KillAura = enabled
        if enabled then enableKillAura() else disableKillAura() end
    end
})

createSlider("Main", {
    Name = "Kill Aura Range",
    Min = 5,
    Max = 50,
    Default = 15,
    Callback = function(value)
        Settings.KillAuraRange = value
    end
})

createToggle("Main", {
    Name = "Auto Farm Coins",
    Description = "Teleport to coins automatically",
    Callback = function(enabled)
        Settings.AutoFarmCoins = enabled
        if enabled then enableAutoFarm() else disableAutoFarm() end
    end
})

-- VISUAL TAB
createSection("Visual", "ESP")

createToggle("Visual", {
    Name = "Player ESP",
    Description = "See players through walls with roles",
    Callback = function(enabled)
        Settings.ESPEnabled = enabled
        if enabled then enableESP() else disableESP() end
    end
})

createToggle("Visual", {
    Name = "Coin ESP",
    Description = "Highlight all coins",
    Callback = function(enabled)
        Settings.CoinESPEnabled = enabled
        if enabled then enableCoinESP() else disableCoinESP() end
    end
})

createToggle("Visual", {
    Name = "Gun ESP",
    Description = "Highlight dropped guns",
    Callback = function(enabled)
        Settings.GunESP = enabled
        if enabled then enableGunESP() else disableGunESP() end
    end
})

createSection("Visual", "Aim Assist")

createToggle("Visual", {
    Name = "Silent Aim (Sheriff)",
    Description = "Auto-aim at nearest player",
    Callback = function(enabled)
        Settings.SilentAim = enabled
        if enabled then enableSilentAim() else disableSilentAim() end
    end
})

createSection("Visual", "Lighting")

createToggle("Visual", {
    Name = "Fullbright",
    Description = "Maximum brightness everywhere",
    Callback = function(enabled)
        Settings.Fullbright = enabled
        if enabled then enableFullbright() else disableFullbright() end
    end
})

-- MISC TAB
createSection("Misc", "Protection")

createToggle("Misc", {
    Name = "No Fall Damage",
    Description = "Never take fall damage",
    Callback = function(enabled)
        Settings.NoFall = enabled
        if enabled then enableNoFall() else disableNoFall() end
    end
})

createToggle("Misc", {
    Name = "No Void Death",
    Description = "Platform prevents void death",
    Callback = function(enabled)
        Settings.NoVoid = enabled
        if enabled then enableNoVoid() else disableNoVoid() end
    end
})

createToggle("Misc", {
    Name = "Anti-AFK",
    Description = "Prevent idle kick",
    Callback = function(enabled)
        Settings.AntiAFK = enabled
        if enabled then enableAntiAFK() else disableAntiAFK() end
    end
})

createSection("Misc", "Fun")

createToggle("Misc", {
    Name = "Fling Players",
    Description = "Touch players to fling them",
    Callback = function(enabled)
        Settings.FlingEnabled = enabled
        if enabled then enableFling() else disableFling() end
    end
})

createToggle("Misc", {
    Name = "Auto GG",
    Description = "Say GG when round ends",
    Callback = function(enabled)
        Settings.AutoGG = enabled
        if enabled then enableAutoGG() else disableAutoGG() end
    end
})

createSection("Misc", "Utility")

createButton("Misc", {
    Name = "Reset Character",
    Callback = function()
        pcall(function()
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
        end)
        createNotification("Reset", "Character reset", 3, "info")
    end
})

createButton("Misc", {
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

-- TELEPORT TAB
createSection("Teleport", "Quick Teleport")

createButton("Teleport", {
    Name = "Teleport to Lobby",
    Color = THEME.Info,
    Callback = teleportToLobby
})

createButton("Teleport", {
    Name = "Teleport to Gun",
    Color = THEME.Success,
    Callback = teleportToGun
})

createButton("Teleport", {
    Name = "Teleport to Random Player",
    Color = THEME.Warning,
    Callback = teleportToRandom
})

createSection("Teleport", "Player Teleport")

-- Create player list dropdown
local playerNames = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerNames, player.Name)
    end
end

local selectedPlayer = nil
local playerDropdown = createDropdown("Teleport", {
    Name = "Select Player",
    Options = playerNames,
    Default = playerNames[1],
    Callback = function(name)
        selectedPlayer = Players:FindFirstChild(name)
    end
})

createButton("Teleport", {
    Name = "Teleport to Selected",
    Callback = function()
        if selectedPlayer then
            teleportToPlayer(selectedPlayer)
        else
            createNotification("Teleport", "No player selected", 3, "error")
        end
    end
})

-- Update player list when players join/leave
Players.PlayerAdded:Connect(function(player)
    table.insert(playerNames, player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(playerNames) do
        if name == player.Name then
            table.remove(playerNames, i)
            break
        end
    end
end)

-- SHADERS TAB
createSection("Shaders", "Weather Presets")

createDropdown("Shaders", {
    Name = "Weather",
    Options = {"Clear", "Aurora", "Thunderstorm", "Snow", "Dynamic", "Night", "Sunset", "Foggy"},
    Default = "Clear",
    Callback = function(preset)
        setWeatherPreset(preset)
    end
})

createSection("Shaders", "Individual Effects")

createToggle("Shaders", {
    Name = "Aurora Borealis",
    Description = "Northern lights in the sky",
    Callback = function(enabled)
        Settings.AuroraEnabled = enabled
        if enabled then
            disableThunderstorm()
            disableSnow()
            enableAurora()
        else
            disableAurora()
        end
    end
})

createToggle("Shaders", {
    Name = "Thunderstorm",
    Description = "Rain, lightning, and dark clouds",
    Callback = function(enabled)
        Settings.ThunderstormEnabled = enabled
        if enabled then
            disableAurora()
            disableSnow()
            enableThunderstorm()
        else
            disableThunderstorm()
        end
    end
})

createToggle("Shaders", {
    Name = "Snow",
    Description = "Winter snowfall effect",
    Callback = function(enabled)
        Settings.SnowEnabled = enabled
        if enabled then
            disableAurora()
            disableThunderstorm()
            enableSnow()
        else
            disableSnow()
        end
    end
})

createToggle("Shaders", {
    Name = "Dynamic Sky",
    Description = "Realistic day/night cycle",
    Callback = function(enabled)
        Settings.DynamicSkyEnabled = enabled
        if enabled then enableDynamicSky() else disableDynamicSky() end
    end
})

createSection("Shaders", "Post-Processing")

createToggle("Shaders", {
    Name = "Bloom Effect",
    Description = "Glowing light effect",
    Callback = function(enabled)
        Settings.BloomEnabled = enabled
        if enabled then enableBloom() else disableBloom() end
    end
})

createSlider("Shaders", {
    Name = "Bloom Intensity",
    Min = 0,
    Max = 3,
    Default = 1,
    Callback = function(value)
        Settings.BloomIntensity = value
        local bloom = Lighting:FindFirstChild("ShaderBloom")
        if bloom and bloom.Enabled then
            bloom.Intensity = value
        end
    end
})

createToggle("Shaders", {
    Name = "Color Enhancement",
    Description = "Vibrant color correction",
    Callback = function(enabled)
        Settings.ColorCorrectionEnabled = enabled
        if enabled then enableColorCorrection() else disableColorCorrection() end
    end
})

createToggle("Shaders", {
    Name = "Sun Rays",
    Description = "God rays from the sun",
    Callback = function(enabled)
        Settings.SunRaysEnabled = enabled
        if enabled then enableSunRays() else disableSunRays() end
    end
})

createSection("Shaders", "Time & Atmosphere")

createSlider("Shaders", {
    Name = "Time of Day",
    Min = 0,
    Max = 24,
    Default = 14,
    Suffix = "h",
    Callback = function(value)
        Settings.TimeOfDay = value
        if not Settings.DynamicSkyEnabled then
            Lighting.ClockTime = value
        end
    end
})

createSlider("Shaders", {
    Name = "Cloud Density",
    Min = 0,
    Max = 100,
    Default = 30,
    Suffix = "%",
    Callback = function(value)
        Settings.CloudDensity = value / 100
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmo then
            atmo.Density = Settings.CloudDensity
        end
    end
})

createSlider("Shaders", {
    Name = "Fog Amount",
    Min = 0,
    Max = 100,
    Default = 0,
    Suffix = "%",
    Callback = function(value)
        Settings.FogDensity = value / 100
        if value > 0 then
            Lighting.FogEnd = 1000 - (value * 8)
            Lighting.FogStart = 10
        else
            Lighting.FogEnd = 100000
        end
    end
})

createButton("Shaders", {
    Name = "Reset All Effects",
    Color = THEME.Error,
    Callback = function()
        disableAurora()
        disableThunderstorm()
        disableSnow()
        disableDynamicSky()
        disableBloom()
        disableColorCorrection()
        disableSunRays()
        restoreOriginalLighting()
        createNotification("Shaders", "All effects reset to default", 3, "success")
    end
})

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              ANTI-KICK MONITOR                                ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

spawn(function()
    while task.wait(1) do
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    if pos.Y < -500 or pos.Y > 10000 or pos.Magnitude > 100000 then
                        if State.LastValidPosition then
                            hrp.CFrame = State.LastValidPosition
                        end
                    else
                        State.LastValidPosition = hrp.CFrame
                    end
                end
            end
        end)
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              CHARACTER RESPAWN HANDLER                        ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    
    -- Re-enable features that need character
    if Settings.NoclipEnabled then
        disableNoclip()
        task.wait(0.1)
        enableNoclip()
    end
    
    if Settings.FlyEnabled then
        disableFly()
        task.wait(0.1)
        enableFly()
    end
    
    if Settings.SpeedEnabled then
        disableSpeed()
        task.wait(0.1)
        enableSpeed()
    end
    
    if Settings.JumpBoost then
        disableJumpBoost()
        task.wait(0.1)
        enableJumpBoost()
    end
    
    if Settings.NoFall then
        disableNoFall()
        task.wait(0.1)
        enableNoFall()
    end
    
    -- Update ESP
    if Settings.ESPEnabled then
        disableESP()
        task.wait(0.1)
        enableESP()
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              INITIALIZATION                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Store original lighting on load
storeOriginalLighting()

-- Welcome notification
task.wait(0.5)
createNotification("⚡ Zyx MM2 Ultimate", "Script loaded successfully!\nPress RightShift or tap ⚡ to toggle", 6, "success")

print("╔══════════════════════════════════════════════════════════════╗")
print("║          Zyx MM2 ULTIMATE v2.0 - LOADED SUCCESSFULLY        ║")
print("╠══════════════════════════════════════════════════════════════╣")
print("║  Press RightShift or click ⚡ button to toggle menu          ║")
print("║  Features: 40+ cheats, Dynamic Shaders, Weather Effects      ║")
print("║  Made with ❤ by 9ovp • Enhanced by ZYX            ║")
print("╚══════════════════════════════════════════════════════════════╝")
