-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    Zyx MM2 SCRIPT - ULTIMATE EDITION V3                      ║
-- ║                     Enhanced by AI • Version 3.0                              ║
-- ║           Anti-Kick • Modern UI • REAL Shader Effects • 40+ Features          ║
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
    
    -- Values
    WalkSpeed = 25,
    FlySpeed = 50,
    JumpPower = 50,
    KillAuraRange = 15,
    
    -- Shader Settings
    RainEnabled = false,
    SnowEnabled = false,
    ThunderstormEnabled = false,
    AuroraEnabled = false,
    MoonGlowEnabled = false,
    RainIntensity = 200,
    SnowIntensity = 150,
    TimeOfDay = 14,
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
    InfiniteJumpConnection = nil,
    NoFallConnection = nil,
    NoVoidConnection = nil,
    AutoGGConnection = nil,
    AntiAFKConnection = nil,
    FullbrightConnection = nil,
    GunESPConnections = {},
    
    -- Shader State
    RainConnection = nil,
    SnowConnection = nil,
    ThunderstormConnection = nil,
    AuroraConnection = nil,
    LightningConnection = nil,
    RainFolder = nil,
    SnowFolder = nil,
    OriginalLighting = {},
    
    -- Other State
    VoidPlatform = nil,
    OriginalWalkSpeed = 16,
    OriginalJumpPower = 50,
    Flying = false,
    FlyKeys = {},
    LastValidPosition = nil,
    FarmingCoins = false,
    NoclipParts = {},
    MobileFlyTouching = {},
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
    TabIdle        = Color3.fromRGB(35, 35, 42),
    TabActive      = Color3.fromRGB(255, 45, 85),
    ToggleBg       = Color3.fromRGB(25, 25, 32),
    ToggleOffTrack = Color3.fromRGB(55, 55, 65),
    ToggleOnTrack  = Color3.fromRGB(255, 45, 85),
    SliderBg       = Color3.fromRGB(30, 30, 38),
    SliderFill     = Color3.fromRGB(255, 45, 85),
    ButtonBg       = Color3.fromRGB(35, 35, 45),
    ButtonHover    = Color3.fromRGB(45, 45, 58),
    TextLight      = Color3.fromRGB(245, 245, 250),
    TextDim        = Color3.fromRGB(150, 150, 165),
    Success        = Color3.fromRGB(50, 205, 50),
    Warning        = Color3.fromRGB(255, 165, 0),
    Error          = Color3.fromRGB(255, 60, 60),
    Info           = Color3.fromRGB(65, 165, 255),
}

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              UTILITY FUNCTIONS                                ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

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

local function safeSetCFrame(part, newCFrame)
    if not newCFrame or not part then return false end
    local pos = newCFrame.Position
    if pos.Y < -500 or pos.Y > 10000 then return false end
    if pos.Magnitude > 100000 then return false end
    State.LastValidPosition = part.CFrame
    part.CFrame = newCFrame
    return true
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              UI SETUP                                         ║
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
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2
mainStroke.Color = THEME.Accent
mainStroke.Transparency = 0.5
mainStroke.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = THEME.FrameBg2
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ Zyx MM2 ULTIMATE V3"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "×"
closeBtn.TextSize = 24
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = THEME.Error
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

-- Tab Container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 35)
tabContainer.Position = UDim2.new(0, 10, 0, 45)
tabContainer.BackgroundColor3 = THEME.FrameBg2
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame
Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 8)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabContainer

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -95)
contentFrame.Position = UDim2.new(0, 10, 0, 85)
contentFrame.BackgroundColor3 = THEME.FrameBg2
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

-- Tab Pages
local tabPages = {}
local tabButtons = {}
local tabs = {"Main", "Visual", "Misc", "Teleport", "Shaders"}

for i, tabName in ipairs(tabs) do
    -- Tab Button
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(0, 65, 0, 28)
    tabBtn.Text = tabName
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.BackgroundColor3 = i == 1 and THEME.TabActive or THEME.TabIdle
    tabBtn.Parent = tabContainer
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    tabButtons[tabName] = tabBtn
    
    -- Tab Page
    local page = Instance.new("ScrollingFrame")
    page.Name = tabName .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = THEME.Accent
    page.Visible = i == 1
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Parent = contentFrame
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = page
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 8)
    pagePadding.PaddingLeft = UDim.new(0, 8)
    pagePadding.PaddingRight = UDim.new(0, 8)
    pagePadding.Parent = page
    
    tabPages[tabName] = page
    
    -- Auto-size canvas
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Tab click
    tabBtn.MouseButton1Click:Connect(function()
        for name, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = THEME.TabIdle
            tabPages[name].Visible = false
        end
        tabBtn.BackgroundColor3 = THEME.TabActive
        page.Visible = true
    end)
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              UI ELEMENT CREATORS                              ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function createSection(tabName, sectionName)
    local section = Instance.new("TextLabel")
    section.Name = sectionName .. "Section"
    section.Size = UDim2.new(1, -16, 0, 25)
    section.BackgroundTransparency = 1
    section.Text = "  " .. sectionName:upper()
    section.TextColor3 = THEME.Accent
    section.TextSize = 11
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = tabPages[tabName]
    return section
end

local function createToggle(tabName, options)
    local container = Instance.new("Frame")
    container.Name = options.Name .. "Toggle"
    container.Size = UDim2.new(1, -16, 0, 40)
    container.BackgroundColor3 = THEME.ToggleBg
    container.Parent = tabPages[tabName]
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = options.Name
    label.TextColor3 = THEME.TextLight
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    if options.Description then
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -70, 0, 14)
        desc.Position = UDim2.new(0, 12, 0, 22)
        desc.BackgroundTransparency = 1
        desc.Text = options.Description
        desc.TextColor3 = THEME.TextDim
        desc.TextSize = 10
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = container
    end
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 44, 0, 22)
    toggleBg.Position = UDim2.new(1, -56, 0.5, -11)
    toggleBg.BackgroundColor3 = THEME.ToggleOffTrack
    toggleBg.Parent = container
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 18, 0, 18)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
    toggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleCircle.Parent = toggleBg
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
    local enabled = false
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = container
    
    clickBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        if enabled then
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ToggleOnTrack}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -20, 0.5, -9)}):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ToggleOffTrack}):Play()
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
        
        if options.Callback then
            options.Callback(enabled)
        end
    end)
    
    return container
end

local function createSlider(tabName, options)
    local container = Instance.new("Frame")
    container.Name = options.Name .. "Slider"
    container.Size = UDim2.new(1, -16, 0, 50)
    container.BackgroundColor3 = THEME.ToggleBg
    container.Parent = tabPages[tabName]
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = options.Name
    label.TextColor3 = THEME.TextLight
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -12, 0, 20)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(options.Default or options.Min)
    valueLabel.TextColor3 = THEME.Accent
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 32)
    sliderBg.BackgroundColor3 = THEME.SliderBg
    sliderBg.Parent = container
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame")
    local defaultPercent = ((options.Default or options.Min) - options.Min) / (options.Max - options.Min)
    sliderFill.Size = UDim2.new(defaultPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = THEME.SliderFill
    sliderFill.Parent = sliderBg
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = math.floor(options.Min + (options.Max - options.Min) * pos)
        
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value) .. (options.Suffix or "")
        
        if options.Callback then
            options.Callback(value)
        end
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
    
    return container
end

local function createButton(tabName, options)
    local btn = Instance.new("TextButton")
    btn.Name = options.Name .. "Btn"
    btn.Size = UDim2.new(1, -16, 0, 35)
    btn.Text = options.Name
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = options.Color or THEME.ButtonBg
    btn.Parent = tabPages[tabName]
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.ButtonHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = options.Color or THEME.ButtonBg}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        if options.Callback then options.Callback() end
    end)
    
    return btn
end

local function createDropdown(tabName, options)
    local container = Instance.new("Frame")
    container.Name = options.Name .. "Dropdown"
    container.Size = UDim2.new(1, -16, 0, 40)
    container.BackgroundColor3 = THEME.ToggleBg
    container.ClipsDescendants = true
    container.Parent = tabPages[tabName]
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 40)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = options.Name
    label.TextColor3 = THEME.TextLight
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local selectedLabel = Instance.new("TextButton")
    selectedLabel.Size = UDim2.new(0.45, -12, 0, 28)
    selectedLabel.Position = UDim2.new(0.55, 0, 0, 6)
    selectedLabel.Text = options.Default or options.Options[1]
    selectedLabel.TextSize = 12
    selectedLabel.Font = Enum.Font.GothamSemibold
    selectedLabel.TextColor3 = Color3.new(1, 1, 1)
    selectedLabel.BackgroundColor3 = THEME.ButtonBg
    selectedLabel.Parent = container
    Instance.new("UICorner", selectedLabel).CornerRadius = UDim.new(0, 6)
    
    local expanded = false
    local optionFrames = {}
    
    for i, opt in ipairs(options.Options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -24, 0, 28)
        optBtn.Position = UDim2.new(0, 12, 0, 40 + (i-1) * 32)
        optBtn.Text = opt
        optBtn.TextSize = 12
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.BackgroundColor3 = THEME.ButtonBg
        optBtn.Visible = false
        optBtn.Parent = container
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 6)
        table.insert(optionFrames, optBtn)
        
        optBtn.MouseButton1Click:Connect(function()
            selectedLabel.Text = opt
            expanded = false
            container.Size = UDim2.new(1, -16, 0, 40)
            for _, f in pairs(optionFrames) do f.Visible = false end
            if options.Callback then options.Callback(opt) end
        end)
    end
    
    selectedLabel.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            container.Size = UDim2.new(1, -16, 0, 40 + #options.Options * 32 + 8)
            for _, f in pairs(optionFrames) do f.Visible = true end
        else
            container.Size = UDim2.new(1, -16, 0, 40)
            for _, f in pairs(optionFrames) do f.Visible = false end
        end
    end)
    
    return container
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              NOTIFICATION SYSTEM                              ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local notifContainer = Instance.new("Frame")
notifContainer.Name = "NotifContainer"
notifContainer.Size = UDim2.new(0, 280, 1, 0)
notifContainer.Position = UDim2.new(1, -290, 0, 10)
notifContainer.BackgroundTransparency = 1
notifContainer.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.Padding = UDim.new(0, 8)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.Parent = notifContainer

local function createNotification(title, message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"
    
    local colors = {
        success = THEME.Success,
        error = THEME.Error,
        warning = THEME.Warning,
        info = THEME.Info
    }
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 60)
    notif.BackgroundColor3 = THEME.FrameBg
    notif.Parent = notifContainer
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.BackgroundColor3 = colors[notifType]
    accent.BorderSizePixel = 0
    accent.Parent = notif
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 20)
    titleLbl.Position = UDim2.new(0, 15, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = colors[notifType]
    titleLbl.TextSize = 13
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = notif
    
    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1, -20, 0, 25)
    msgLbl.Position = UDim2.new(0, 15, 0, 28)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = message
    msgLbl.TextColor3 = THEME.TextDim
    msgLbl.TextSize = 11
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextWrapped = true
    msgLbl.Parent = notif
    
    -- Animate in
    notif.Position = UDim2.new(1, 10, 0, 0)
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    -- Remove after duration
    task.delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1, 10, 0, 0)}):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              TOGGLE BUTTON                                    ║
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
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.ZIndex = 50
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)

local isOpen = false
toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 380, 0, 420),
            Position = UDim2.new(0.5, -190, 0.5, -210)
        }):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        mainFrame.Visible = false
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    isOpen = false
    TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    mainFrame.Visible = false
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleBtn.MouseButton1Click:Fire()
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              CORE FEATURES                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- NOCLIP
local function enableNoclip()
    if State.NoclipConnection then return end
    State.NoclipConnection = RunService.Stepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
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
    createNotification("Noclip", "Noclip disabled", 3, "info")
end

-- FLY
local function enableFly()
    if State.FlyConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    
    State.Flying = true
    State.FlyKeys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}
    
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    
    local bg = Instance.new("BodyGyro")
    bg.Name = "FlyGyro"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 1e6
    bg.Parent = hrp
    
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
            
            local cam = workspace.CurrentCamera
            local dir = Vector3.zero
            local speed = Settings.FlySpeed
            
            if State.FlyKeys.W then dir = dir + cam.CFrame.LookVector end
            if State.FlyKeys.S then dir = dir - cam.CFrame.LookVector end
            if State.FlyKeys.A then dir = dir - cam.CFrame.RightVector end
            if State.FlyKeys.D then dir = dir + cam.CFrame.RightVector end
            if State.FlyKeys.Space then dir = dir + Vector3.new(0, 1, 0) end
            if State.FlyKeys.Shift then dir = dir - Vector3.new(0, 1, 0) end
            
            if dir.Magnitude > 0 then dir = dir.Unit * speed end
            
            bv.Velocity = dir
            bg.CFrame = cam.CFrame
            humanoid.PlatformStand = true
        end)
    end)
    
    State.FlyKeyConnections = {keyDown, keyUp}
    createNotification("Fly", "Flying enabled - WASD + Space/Shift", 3, "success")
end

local function disableFly()
    State.Flying = false
    
    if State.FlyConnection then
        State.FlyConnection:Disconnect()
        State.FlyConnection = nil
    end
    
    if State.FlyKeyConnections then
        for _, conn in pairs(State.FlyKeyConnections) do
            conn:Disconnect()
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
            if humanoid then humanoid.PlatformStand = false end
        end
    end)
    
    createNotification("Fly", "Flying disabled", 3, "info")
end

-- SPEED
local function enableSpeed()
    if State.SpeedConnection then return end
    State.SpeedConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local humanoid = getHumanoid()
            if humanoid then
                humanoid.WalkSpeed = Settings.WalkSpeed
            end
        end)
    end)
    createNotification("Speed", "Speed boost enabled", 3, "success")
end

local function disableSpeed()
    if State.SpeedConnection then
        State.SpeedConnection:Disconnect()
        State.SpeedConnection = nil
    end
    pcall(function()
        local humanoid = getHumanoid()
        if humanoid then humanoid.WalkSpeed = 16 end
    end)
    createNotification("Speed", "Speed disabled", 3, "info")
end

-- INFINITE JUMP
local function enableInfiniteJump()
    if State.InfiniteJumpConnection then return end
    State.InfiniteJumpConnection = UIS.JumpRequest:Connect(function()
        pcall(function()
            local humanoid = getHumanoid()
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end)
    createNotification("Infinite Jump", "Unlimited jumps enabled", 3, "success")
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
            local humanoid = getHumanoid()
            if humanoid then
                humanoid.JumpPower = Settings.JumpPower
            end
        end)
    end)
    createNotification("Jump Boost", "Jump power increased", 3, "success")
end

local function disableJumpBoost()
    if State.JumpBoostConnection then
        State.JumpBoostConnection:Disconnect()
        State.JumpBoostConnection = nil
    end
    pcall(function()
        local humanoid = getHumanoid()
        if humanoid then humanoid.JumpPower = 50 end
    end)
    createNotification("Jump Boost", "Jump boost disabled", 3, "info")
end

-- NO FALL
local function enableNoFall()
    if State.NoFallConnection then return end
    State.NoFallConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local humanoid = getHumanoid()
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end)
    end)
    createNotification("No Fall", "Fall damage disabled", 3, "success")
end

local function disableNoFall()
    if State.NoFallConnection then
        State.NoFallConnection:Disconnect()
        State.NoFallConnection = nil
    end
    createNotification("No Fall", "Fall protection disabled", 3, "info")
end

-- NO VOID
local function enableNoVoid()
    if State.VoidPlatform then return end
    
    State.VoidPlatform = Instance.new("Part")
    State.VoidPlatform.Name = "VoidPlatform"
    State.VoidPlatform.Size = Vector3.new(500, 1, 500)
    State.VoidPlatform.Position = Vector3.new(0, -200, 0)
    State.VoidPlatform.Anchored = true
    State.VoidPlatform.Transparency = 1
    State.VoidPlatform.CanCollide = true
    State.VoidPlatform.Parent = workspace
    
    createNotification("No Void", "Void protection enabled", 3, "success")
end

local function disableNoVoid()
    if State.VoidPlatform then
        State.VoidPlatform:Destroy()
        State.VoidPlatform = nil
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
    
    createNotification("Anti-AFK", "AFK prevention enabled", 3, "success")
end

local function disableAntiAFK()
    if State.AntiAFKConnection then
        State.AntiAFKConnection:Disconnect()
        State.AntiAFKConnection = nil
    end
    createNotification("Anti-AFK", "Anti-AFK disabled", 3, "info")
end

-- AUTO GG
local function enableAutoGG()
    if State.AutoGGConnection then return end
    
    State.AutoGGConnection = ReplicatedStorage.ChildAdded:Connect(function(child)
        if child.Name == "Remotes" or child:IsA("RemoteEvent") then
            task.wait(2)
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("GG!", "All")
            end)
        end
    end)
    
    createNotification("Auto GG", "Will say GG after rounds", 3, "success")
end

local function disableAutoGG()
    if State.AutoGGConnection then
        State.AutoGGConnection:Disconnect()
        State.AutoGGConnection = nil
    end
    createNotification("Auto GG", "Auto GG disabled", 3, "info")
end

-- FULLBRIGHT
local function enableFullbright()
    State.OriginalLighting.Ambient = Lighting.Ambient
    State.OriginalLighting.Brightness = Lighting.Brightness
    State.OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
    
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    
    createNotification("Fullbright", "Maximum brightness enabled", 3, "success")
end

local function disableFullbright()
    if State.OriginalLighting.Ambient then
        Lighting.Ambient = State.OriginalLighting.Ambient
        Lighting.Brightness = State.OriginalLighting.Brightness or 1
        Lighting.OutdoorAmbient = State.OriginalLighting.OutdoorAmbient
    end
    createNotification("Fullbright", "Fullbright disabled", 3, "info")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              ESP FUNCTIONS                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function getPlayerRole(player)
    -- MM2 Role Detection
    pcall(function()
        local backpack = player:FindFirstChild("Backpack")
        local char = player.Character
        
        -- Check for knife (Murderer)
        if backpack and backpack:FindFirstChild("Knife") then return "Murderer" end
        if char and char:FindFirstChild("Knife") then return "Murderer" end
        
        -- Check for gun (Sheriff)
        if backpack and (backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver")) then return "Sheriff" end
        if char and (char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")) then return "Sheriff" end
    end)
    
    return "Innocent"
end

local function createPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function updateESP()
        local char = player.Character
        if not char then return end
        
        -- Remove old ESP
        local oldHighlight = char:FindFirstChild("ESPHighlight")
        if oldHighlight then oldHighlight:Destroy() end
        
        local head = char:FindFirstChild("Head")
        if head then
            local oldBillboard = head:FindFirstChild("ESPBillboard")
            if oldBillboard then oldBillboard:Destroy() end
        end
        
        -- Create highlight
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        local role = getPlayerRole(player)
        if role == "Murderer" then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
        elseif role == "Sheriff" then
            highlight.FillColor = Color3.fromRGB(0, 100, 255)
            highlight.OutlineColor = Color3.fromRGB(50, 150, 255)
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(50, 255, 50)
        end
        
        highlight.Parent = char
        
        -- Create name billboard
        if head then
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
            nameLabel.TextColor3 = highlight.OutlineColor
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.Parent = billboard
            
            local roleLabel = Instance.new("TextLabel")
            roleLabel.Size = UDim2.new(1, 0, 0.5, 0)
            roleLabel.Position = UDim2.new(0, 0, 0.5, 0)
            roleLabel.BackgroundTransparency = 1
            roleLabel.Text = "[" .. role .. "]"
            roleLabel.TextColor3 = highlight.OutlineColor
            roleLabel.TextSize = 12
            roleLabel.Font = Enum.Font.GothamSemibold
            roleLabel.Parent = billboard
        end
    end
    
    updateESP()
    
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Settings.ESPEnabled then updateESP() end
    end)
    
    -- Update role periodically
    State.ESPConnections[player.Name] = RunService.Heartbeat:Connect(function()
        if not Settings.ESPEnabled then return end
        if tick() % 2 < 0.03 then -- Update every 2 seconds
            updateESP()
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
        if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    State.ESPConnections = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local hl = player.Character:FindFirstChild("ESPHighlight")
            if hl then hl:Destroy() end
            local head = player.Character:FindFirstChild("Head")
            if head then
                local bb = head:FindFirstChild("ESPBillboard")
                if bb then bb:Destroy() end
            end
        end
    end
    createNotification("Player ESP", "ESP disabled", 3, "info")
end

-- COIN ESP
local function findAllCoins()
    local coins = {}
    
    -- MM2 specific coin locations
    local containers = {
        workspace:FindFirstChild("Normal"),
        workspace:FindFirstChild("CoinContainer"),
        workspace:FindFirstChild("Coins"),
        workspace:FindFirstChild("Map"),
        workspace:FindFirstChild("Ignored"),
    }
    
    for _, container in pairs(containers) do
        if container then
            for _, obj in pairs(container:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if name:find("coin") or name == "coinvisual" or obj.Name == "Coin" then
                        table.insert(coins, obj)
                    end
                end
            end
        end
    end
    
    -- Fallback: search entire workspace
    if #coins == 0 then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local name = obj.Name:lower()
                if name:find("coin") and obj.Transparency < 1 then
                    table.insert(coins, obj)
                end
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
        if Settings.CoinESPEnabled and obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("coin") and not obj:FindFirstChild("CoinESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "CoinESP"
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
                highlight.FillTransparency = 0.2
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = obj
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

-- GUN ESP
local function enableGunESP()
    local function addGunHighlight(obj)
        if obj.Name == "GunDrop" or obj.Name == "Gun" or obj.Name == "Revolver" then
            if not obj:FindFirstChild("GunESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "GunESP"
                highlight.FillColor = Color3.fromRGB(0, 150, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 200, 255)
                highlight.FillTransparency = 0.3
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
        if Settings.GunESP then addGunHighlight(obj) end
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

-- SILENT AIM
local function enableSilentAim()
    if State.SilentAimConnection then return end
    
    State.SilentAimConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool or (tool.Name ~= "Gun" and tool.Name ~= "Revolver") then return end
            
            local nearest, nearestDist = nil, math.huge
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetHead = player.Character:FindFirstChild("Head")
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    
                    if targetHead and hrp then
                        local dist = (hrp.Position - targetHead.Position).Magnitude
                        if dist < nearestDist and dist < 300 then
                            nearestDist = dist
                            nearest = player
                        end
                    end
                end
            end
            
            if nearest and nearest.Character then
                local targetHead = nearest.Character:FindFirstChild("Head")
                if targetHead then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHead.Position)
                end
            end
        end)
    end)
    
    createNotification("Silent Aim", "Auto-aim enabled", 3, "success")
end

local function disableSilentAim()
    if State.SilentAimConnection then
        State.SilentAimConnection:Disconnect()
        State.SilentAimConnection = nil
    end
    createNotification("Silent Aim", "Silent aim disabled", 3, "info")
end

-- KILL AURA
local function enableKillAura()
    if State.KillAuraConnection then return end
    
    State.KillAuraConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local knife = char:FindFirstChild("Knife")
            if not knife then return end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetHrp then
                        local dist = (hrp.Position - targetHrp.Position).Magnitude
                        if dist <= Settings.KillAuraRange then
                            local remote = knife:FindFirstChildWhichIsA("RemoteEvent")
                            if remote then
                                remote:FireServer(player.Character:FindFirstChild("Humanoid"))
                            end
                        end
                    end
                end
            end
        end)
    end)
    
    createNotification("Kill Aura", "Auto-kill range: " .. Settings.KillAuraRange, 3, "warning")
end

local function disableKillAura()
    if State.KillAuraConnection then
        State.KillAuraConnection:Disconnect()
        State.KillAuraConnection = nil
    end
    createNotification("Kill Aura", "Kill aura disabled", 3, "info")
end

-- AUTO FARM
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
            
            local nearest, nearestDist = nil, math.huge
            for _, coin in pairs(coins) do
                if coin and coin.Parent then
                    local dist = (hrp.Position - coin.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = coin
                    end
                end
            end
            
            if nearest then
                hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 0))
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

-- FLING
local function enableFling()
    if State.FlingConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlingVelocity"
    bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    
    local bg = Instance.new("BodyGyro")
    bg.Name = "FlingGyro"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 1e6
    bg.Parent = hrp
    
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
    
    createNotification("Fling", "Touch players to fling them", 3, "warning")
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
            end
        end
    end)
    
    createNotification("Fling", "Fling disabled", 3, "info")
end

-- TELEPORT FUNCTIONS
local function teleportToPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return end
    
    local char = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    if not char or not targetChar then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp or not targetHrp then return end
    
    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
    createNotification("Teleport", "Teleported to " .. targetPlayer.Name, 3, "success")
end

local function teleportToLobby()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local spawn = workspace:FindFirstChild("Lobby") or workspace:FindFirstChild("SpawnLocation")
    if spawn then
        hrp.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
    else
        hrp.CFrame = CFrame.new(0, 10, 0)
    end
    createNotification("Teleport", "Teleported to lobby", 3, "success")
end

local function teleportToGun()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name == "Gun" then
            local pos = obj:IsA("BasePart") and obj.Position or (obj:FindFirstChild("Handle") and obj.Handle.Position)
            if pos then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                createNotification("Teleport", "Teleported to gun", 3, "success")
                return
            end
        end
    end
    createNotification("Teleport", "No gun found", 3, "error")
end

local function teleportToRandom()
    local playersList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            table.insert(playersList, player)
        end
    end
    
    if #playersList > 0 then
        teleportToPlayer(playersList[math.random(1, #playersList)])
    else
        createNotification("Teleport", "No players found", 3, "error")
    end
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    SHADER SYSTEM - REAL VISUAL EFFECTS                        ║
-- ║              Camera-following particles visible only to you                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local function storeOriginalLighting()
    State.OriginalLighting = {
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogColor = Lighting.FogColor,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        OutdoorAmbient = Lighting.OutdoorAmbient,
    }
end

local function restoreOriginalLighting()
    if State.OriginalLighting.Ambient then
        pcall(function()
            Lighting.Ambient = State.OriginalLighting.Ambient
            Lighting.Brightness = State.OriginalLighting.Brightness
            Lighting.ClockTime = State.OriginalLighting.ClockTime
            Lighting.FogColor = State.OriginalLighting.FogColor
            Lighting.FogEnd = State.OriginalLighting.FogEnd
            Lighting.FogStart = State.OriginalLighting.FogStart
            Lighting.OutdoorAmbient = State.OriginalLighting.OutdoorAmbient
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- RAIN EFFECT - Real falling rain particles that follow your camera
-- ═══════════════════════════════════════════════════════════════════════════════

local function enableRain()
    if State.RainConnection then return end
    
    storeOriginalLighting()
    
    -- Create rain container
    State.RainFolder = Instance.new("Folder")
    State.RainFolder.Name = "RainEffects_Local"
    State.RainFolder.Parent = workspace.CurrentCamera -- Parent to camera so only you see it
    
    local raindrops = {}
    local rainCount = Settings.RainIntensity or 200
    
    -- Create raindrops
    for i = 1, rainCount do
        local drop = Instance.new("Part")
        drop.Name = "Raindrop"
        drop.Size = Vector3.new(0.05, math.random(15, 25) / 10, 0.05) -- Thin long drops
        drop.Material = Enum.Material.Neon
        drop.Color = Color3.fromRGB(180, 200, 220)
        drop.Transparency = 0.4
        drop.Anchored = true
        drop.CanCollide = false
        drop.CastShadow = false
        drop.Parent = State.RainFolder
        
        table.insert(raindrops, {
            part = drop,
            speed = math.random(80, 120),
            offset = Vector3.new(math.random(-60, 60), math.random(20, 80), math.random(-60, 60))
        })
    end
    
    -- Dark stormy atmosphere
    Lighting.ClockTime = 16
    Lighting.Brightness = 0.8
    Lighting.Ambient = Color3.fromRGB(60, 65, 75)
    Lighting.OutdoorAmbient = Color3.fromRGB(70, 75, 85)
    Lighting.FogColor = Color3.fromRGB(100, 105, 115)
    Lighting.FogEnd = 600
    Lighting.FogStart = 20
    
    -- Add atmosphere
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
    atmo.Density = 0.4
    atmo.Color = Color3.fromRGB(120, 130, 145)
    atmo.Decay = Color3.fromRGB(100, 110, 125)
    atmo.Haze = 2
    
    -- Animate rain
    State.RainConnection = RunService.RenderStepped:Connect(function(dt)
        local camPos = workspace.CurrentCamera.CFrame.Position
        
        for _, data in ipairs(raindrops) do
            local drop = data.part
            if drop and drop.Parent then
                -- Move drop down
                local newY = drop.Position.Y - data.speed * dt
                
                -- Reset if below camera
                if newY < camPos.Y - 30 then
                    newY = camPos.Y + math.random(40, 80)
                    data.offset = Vector3.new(math.random(-60, 60), 0, math.random(-60, 60))
                end
                
                -- Position relative to camera
                drop.CFrame = CFrame.new(
                    camPos.X + data.offset.X,
                    newY,
                    camPos.Z + data.offset.Z
                ) * CFrame.Angles(0, 0, math.rad(math.random(-5, 5)))
            end
        end
    end)
    
    createNotification("Rain", "Rain effect enabled - visible only to you", 3, "success")
end

local function disableRain()
    if State.RainConnection then
        State.RainConnection:Disconnect()
        State.RainConnection = nil
    end
    
    if State.RainFolder then
        State.RainFolder:Destroy()
        State.RainFolder = nil
    end
    
    -- Remove atmosphere
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmo then atmo:Destroy() end
    
    restoreOriginalLighting()
    createNotification("Rain", "Rain effect disabled", 3, "info")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SNOW EFFECT - Realistic snowflakes falling around you
-- ═══════════════════════════════════════════════════════════════════════════════

local function enableSnow()
    if State.SnowConnection then return end
    
    storeOriginalLighting()
    
    -- Create snow container
    State.SnowFolder = Instance.new("Folder")
    State.SnowFolder.Name = "SnowEffects_Local"
    State.SnowFolder.Parent = workspace.CurrentCamera
    
    local snowflakes = {}
    local snowCount = Settings.SnowIntensity or 150
    
    -- Create snowflakes
    for i = 1, snowCount do
        local flake = Instance.new("Part")
        flake.Name = "Snowflake"
        flake.Shape = Enum.PartType.Ball
        local size = math.random(2, 6) / 10
        flake.Size = Vector3.new(size, size, size)
        flake.Material = Enum.Material.Neon
        flake.Color = Color3.fromRGB(255, 255, 255)
        flake.Transparency = 0.2
        flake.Anchored = true
        flake.CanCollide = false
        flake.CastShadow = false
        flake.Parent = State.SnowFolder
        
        table.insert(snowflakes, {
            part = flake,
            speed = math.random(8, 20),
            driftX = math.random(-20, 20) / 10,
            driftZ = math.random(-20, 20) / 10,
            phase = math.random() * math.pi * 2,
            offset = Vector3.new(math.random(-70, 70), math.random(20, 100), math.random(-70, 70))
        })
    end
    
    -- Winter atmosphere
    Lighting.ClockTime = 12
    Lighting.Brightness = 1.2
    Lighting.Ambient = Color3.fromRGB(180, 190, 210)
    Lighting.OutdoorAmbient = Color3.fromRGB(190, 200, 220)
    Lighting.FogColor = Color3.fromRGB(200, 210, 230)
    Lighting.FogEnd = 500
    Lighting.FogStart = 50
    
    -- Cold atmosphere
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
    atmo.Density = 0.35
    atmo.Color = Color3.fromRGB(200, 210, 235)
    atmo.Decay = Color3.fromRGB(180, 190, 210)
    atmo.Haze = 1.5
    
    -- Color correction for cold feel
    local cc = Lighting:FindFirstChild("SnowColorCorrection") or Instance.new("ColorCorrectionEffect", Lighting)
    cc.Name = "SnowColorCorrection"
    cc.Brightness = 0.05
    cc.Contrast = 0.1
    cc.Saturation = -0.15
    cc.TintColor = Color3.fromRGB(220, 230, 255)
    
    local time = 0
    
    -- Animate snow
    State.SnowConnection = RunService.RenderStepped:Connect(function(dt)
        time = time + dt
        local camPos = workspace.CurrentCamera.CFrame.Position
        
        for _, data in ipairs(snowflakes) do
            local flake = data.part
            if flake and flake.Parent then
                -- Gentle falling with drift
                local newY = flake.Position.Y - data.speed * dt
                local driftX = math.sin(time * data.driftX + data.phase) * 0.3
                local driftZ = math.cos(time * data.driftZ + data.phase) * 0.3
                
                -- Reset if below camera
                if newY < camPos.Y - 40 then
                    newY = camPos.Y + math.random(60, 100)
                    data.offset = Vector3.new(math.random(-70, 70), 0, math.random(-70, 70))
                end
                
                -- Position relative to camera with drift
                flake.CFrame = CFrame.new(
                    camPos.X + data.offset.X + driftX,
                    newY,
                    camPos.Z + data.offset.Z + driftZ
                )
            end
        end
    end)
    
    createNotification("Snow", "Snow effect enabled - visible only to you", 3, "success")
end

local function disableSnow()
    if State.SnowConnection then
        State.SnowConnection:Disconnect()
        State.SnowConnection = nil
    end
    
    if State.SnowFolder then
        State.SnowFolder:Destroy()
        State.SnowFolder = nil
    end
    
    -- Remove effects
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmo then atmo:Destroy() end
    
    local cc = Lighting:FindFirstChild("SnowColorCorrection")
    if cc then cc:Destroy() end
    
    restoreOriginalLighting()
    createNotification("Snow", "Snow effect disabled", 3, "info")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- THUNDERSTORM - Rain + Lightning flashes
-- ═══════════════════════════════════════════════════════════════════════════════

local function enableThunderstorm()
    if State.ThunderstormConnection then return end
    
    -- Enable rain first
    enableRain()
    
    -- Create lightning flash effect
    local flash = Instance.new("ColorCorrectionEffect")
    flash.Name = "LightningFlash"
    flash.Brightness = 0
    flash.Parent = Lighting
    
    local nextLightning = tick() + math.random(3, 8)
    
    -- Lightning loop
    State.LightningConnection = RunService.Heartbeat:Connect(function()
        if tick() >= nextLightning then
            nextLightning = tick() + math.random(4, 12)
            
            -- Flash sequence
            spawn(function()
                -- First flash
                flash.Brightness = 3
                Lighting.Brightness = 4
                task.wait(0.05)
                flash.Brightness = 0
                Lighting.Brightness = 0.8
                task.wait(0.1)
                -- Second flash
                flash.Brightness = 2
                Lighting.Brightness = 3
                task.wait(0.03)
                flash.Brightness = 0
                Lighting.Brightness = 0.8
            end)
        end
    end)
    
    State.ThunderstormConnection = true -- Flag
    createNotification("Thunderstorm", "Thunder & lightning enabled", 3, "success")
end

local function disableThunderstorm()
    -- Disable rain
    disableRain()
    
    if State.LightningConnection then
        State.LightningConnection:Disconnect()
        State.LightningConnection = nil
    end
    
    local flash = Lighting:FindFirstChild("LightningFlash")
    if flash then flash:Destroy() end
    
    State.ThunderstormConnection = nil
    createNotification("Thunderstorm", "Thunderstorm disabled", 3, "info")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- AURORA BOREALIS - Northern lights in the sky
-- ═══════════════════════════════════════════════════════════════════════════════

local function enableAurora()
    if State.AuroraConnection then return end
    
    storeOriginalLighting()
    
    -- Night sky
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.4
    Lighting.Ambient = Color3.fromRGB(20, 30, 50)
    Lighting.OutdoorAmbient = Color3.fromRGB(30, 45, 70)
    
    -- Create aurora parts
    local auroraFolder = Instance.new("Folder")
    auroraFolder.Name = "AuroraEffects"
    auroraFolder.Parent = workspace
    
    local auroraParts = {}
    
    for i = 1, 12 do
        local part = Instance.new("Part")
        part.Name = "Aurora_" .. i
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.Transparency = 0.4
        part.Size = Vector3.new(math.random(80, 200), math.random(150, 400), 8)
        part.CFrame = CFrame.new(
            math.random(-400, 400),
            math.random(250, 450),
            math.random(-400, 400)
        ) * CFrame.Angles(0, math.rad(math.random(0, 360)), math.rad(math.random(-15, 15)))
        part.Parent = auroraFolder
        
        table.insert(auroraParts, {
            part = part,
            phase = math.random() * math.pi * 2,
            colorPhase = math.random() * math.pi * 2
        })
    end
    
    -- Bloom for glow
    local bloom = Lighting:FindFirstChild("AuroraBloom") or Instance.new("BloomEffect", Lighting)
    bloom.Name = "AuroraBloom"
    bloom.Intensity = 1.5
    bloom.Size = 40
    bloom.Threshold = 0.7
    
    local time = 0
    
    State.AuroraConnection = RunService.Heartbeat:Connect(function(dt)
        time = time + dt
        
        for _, data in ipairs(auroraParts) do
            local part = data.part
            if part and part.Parent then
                -- Wave motion
                local wave = math.sin(time * 0.3 + data.phase) * 15
                part.CFrame = part.CFrame * CFrame.new(0, wave * dt, 0)
                
                -- Color shift between green, blue, purple
                local hue = (math.sin(time * 0.2 + data.colorPhase) + 1) / 2 * 0.4 + 0.4 -- 0.4 to 0.8 (green to purple)
                part.Color = Color3.fromHSV(hue, 0.8, 1)
                
                -- Transparency pulse
                part.Transparency = 0.35 + math.sin(time * 1.5 + data.phase) * 0.15
            end
        end
    end)
    
    State.AuroraFolder = auroraFolder
    createNotification("Aurora", "Northern lights enabled", 3, "success")
end

local function disableAurora()
    if State.AuroraConnection then
        State.AuroraConnection:Disconnect()
        State.AuroraConnection = nil
    end
    
    if State.AuroraFolder then
        State.AuroraFolder:Destroy()
        State.AuroraFolder = nil
    end
    
    local bloom = Lighting:FindFirstChild("AuroraBloom")
    if bloom then bloom:Destroy() end
    
    restoreOriginalLighting()
    createNotification("Aurora", "Aurora disabled", 3, "info")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- MOON GLOW - Bright moon with bloom effect
-- ═══════════════════════════════════════════════════════════════════════════════

local function enableMoonGlow()
    storeOriginalLighting()
    
    -- Night time
    Lighting.ClockTime = 0
    Lighting.Brightness = 0.6
    Lighting.Ambient = Color3.fromRGB(40, 50, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(50, 60, 80)
    
    -- Heavy bloom for moon glow
    local bloom = Lighting:FindFirstChild("MoonBloom") or Instance.new("BloomEffect", Lighting)
    bloom.Name = "MoonBloom"
    bloom.Intensity = 2
    bloom.Size = 56
    bloom.Threshold = 0.6
    
    -- Atmosphere
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
    atmo.Density = 0.25
    atmo.Color = Color3.fromRGB(50, 60, 90)
    atmo.Decay = Color3.fromRGB(40, 50, 80)
    atmo.Haze = 1
    
    createNotification("Moon Glow", "Bright moon with bloom enabled", 3, "success")
end

local function disableMoonGlow()
    local bloom = Lighting:FindFirstChild("MoonBloom")
    if bloom then bloom:Destroy() end
    
    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmo then atmo:Destroy() end
    
    restoreOriginalLighting()
    createNotification("Moon Glow", "Moon glow disabled", 3, "info")
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- WEATHER PRESETS
-- ═══════════════════════════════════════════════════════════════════════════════

local function setWeatherPreset(preset)
    -- Disable all effects first
    disableRain()
    disableSnow()
    disableThunderstorm()
    disableAurora()
    disableMoonGlow()
    
    task.wait(0.1)
    
    if preset == "Clear" then
        restoreOriginalLighting()
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        createNotification("Weather", "Clear skies", 3, "success")
        
    elseif preset == "Rain" then
        enableRain()
        
    elseif preset == "Snow" then
        enableSnow()
        
    elseif preset == "Thunderstorm" then
        enableThunderstorm()
        
    elseif preset == "Aurora" then
        enableAurora()
        
    elseif preset == "Night + Moon" then
        enableMoonGlow()
        
    elseif preset == "Foggy" then
        storeOriginalLighting()
        Lighting.ClockTime = 8
        Lighting.Brightness = 1
        Lighting.FogColor = Color3.fromRGB(180, 185, 195)
        Lighting.FogEnd = 150
        Lighting.FogStart = 10
        
        local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
        atmo.Density = 0.6
        atmo.Color = Color3.fromRGB(180, 185, 195)
        atmo.Haze = 3
        
        createNotification("Weather", "Foggy atmosphere", 3, "success")
    end
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
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
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

-- SHADERS TAB
createSection("Shaders", "Weather Presets")

createDropdown("Shaders", {
    Name = "Weather",
    Options = {"Clear", "Rain", "Snow", "Thunderstorm", "Aurora", "Night + Moon", "Foggy"},
    Default = "Clear",
    Callback = function(preset)
        setWeatherPreset(preset)
    end
})

createSection("Shaders", "Individual Effects")

createToggle("Shaders", {
    Name = "Rain",
    Description = "Falling rain particles (local only)",
    Callback = function(enabled)
        Settings.RainEnabled = enabled
        if enabled then
            disableSnow()
            disableThunderstorm()
            enableRain()
        else
            disableRain()
        end
    end
})

createToggle("Shaders", {
    Name = "Snow",
    Description = "Falling snowflakes (local only)",
    Callback = function(enabled)
        Settings.SnowEnabled = enabled
        if enabled then
            disableRain()
            disableThunderstorm()
            enableSnow()
        else
            disableSnow()
        end
    end
})

createToggle("Shaders", {
    Name = "Thunderstorm",
    Description = "Rain + Lightning flashes",
    Callback = function(enabled)
        Settings.ThunderstormEnabled = enabled
        if enabled then
            disableSnow()
            disableRain()
            enableThunderstorm()
        else
            disableThunderstorm()
        end
    end
})

createToggle("Shaders", {
    Name = "Aurora Borealis",
    Description = "Northern lights in the sky",
    Callback = function(enabled)
        Settings.AuroraEnabled = enabled
        if enabled then enableAurora() else disableAurora() end
    end
})

createToggle("Shaders", {
    Name = "Moon Glow",
    Description = "Bright moon with bloom effect",
    Callback = function(enabled)
        Settings.MoonGlowEnabled = enabled
        if enabled then enableMoonGlow() else disableMoonGlow() end
    end
})

createSection("Shaders", "Settings")

createSlider("Shaders", {
    Name = "Rain Intensity",
    Min = 50,
    Max = 400,
    Default = 200,
    Callback = function(value)
        Settings.RainIntensity = value
    end
})

createSlider("Shaders", {
    Name = "Snow Intensity",
    Min = 50,
    Max = 300,
    Default = 150,
    Callback = function(value)
        Settings.SnowIntensity = value
    end
})

createSlider("Shaders", {
    Name = "Time of Day",
    Min = 0,
    Max = 24,
    Default = 14,
    Suffix = "h",
    Callback = function(value)
        Settings.TimeOfDay = value
        Lighting.ClockTime = value
    end
})

createButton("Shaders", {
    Name = "Reset All Effects",
    Color = THEME.Error,
    Callback = function()
        disableRain()
        disableSnow()
        disableThunderstorm()
        disableAurora()
        disableMoonGlow()
        restoreOriginalLighting()
        createNotification("Shaders", "All effects reset", 3, "success")
    end
})

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              CHARACTER RESPAWN                                ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    
    if Settings.NoclipEnabled then disableNoclip() task.wait(0.1) enableNoclip() end
    if Settings.FlyEnabled then disableFly() task.wait(0.1) enableFly() end
    if Settings.SpeedEnabled then disableSpeed() task.wait(0.1) enableSpeed() end
    if Settings.JumpBoost then disableJumpBoost() task.wait(0.1) enableJumpBoost() end
    if Settings.NoFall then disableNoFall() task.wait(0.1) enableNoFall() end
    if Settings.ESPEnabled then disableESP() task.wait(0.1) enableESP() end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                              INITIALIZATION                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

storeOriginalLighting()

task.wait(0.5)
createNotification("⚡ Zyx MM2 Ultimate V3", "Script loaded! Press RightShift or tap ⚡", 5, "success")

print("╔══════════════════════════════════════════════════════════════╗")
print("║        Zyx MM2 ULTIMATE V3 - LOADED SUCCESSFULLY            ║")
print("╠══════════════════════════════════════════════════════════════╣")
print("║  Press RightShift or click ⚡ button to toggle menu          ║")
print("║  NEW: Real shader effects - Rain, Snow, Thunder, Aurora      ║")
print("║  All visual effects are LOCAL ONLY (only you see them)       ║")
print("╚══════════════════════════════════════════════════════════════╝")
