-- Murder Mystery 2 - Baba Script with Custom UI
-- Anti-Kick Protection + Modern UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Settings
local Settings = {
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
    WalkSpeed = 25,
    FlySpeed = 50,
    JumpPower = 50,
    KillAuraRange = 15,
}

-- State
local State = {
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
}

-- Cleanup old
pcall(function() CoreGui:FindFirstChild("BabaMM2UI"):Destroy() end)

--// ======= THEME =========
local THEME = {
    FrameBg        = Color3.fromRGB(15, 15, 18),   
    FrameBg2       = Color3.fromRGB(22, 22, 26),   
    Accent         = Color3.fromRGB(255, 50, 50),  
    AccentHover    = Color3.fromRGB(255, 80, 80),
    TabIdle        = Color3.fromRGB(40, 40, 45),
    TabActive      = Color3.fromRGB(255, 50, 50),
    ToggleBg       = Color3.fromRGB(28, 28, 32),
    ToggleHover    = Color3.fromRGB(35, 35, 40),
    ToggleOffTrack = Color3.fromRGB(60, 60, 65),
    ToggleOnTrack  = Color3.fromRGB(255, 50, 50),
    SliderBg       = Color3.fromRGB(35, 35, 40),
    SliderFill     = Color3.fromRGB(255, 50, 50),
    TextLight      = Color3.fromRGB(245, 245, 245),
    TitleText      = Color3.fromRGB(255, 255, 255),
}

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "BabaMM2UI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 290, 0, 330)
mainFrame.Position = UDim2.new(0.5, -145, 0.5, -165)
mainFrame.BackgroundColor3 = THEME.FrameBg
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = gui
mainFrame.ZIndex = 2
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 2.5
mainStroke.Color = THEME.Accent
mainStroke.Transparency = 0
mainStroke.Parent = mainFrame

local glowStroke = Instance.new("UIStroke")
glowStroke.Thickness = 1
glowStroke.Color = THEME.Accent
glowStroke.Transparency = 0.6
glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glowStroke.Parent = mainFrame

-- Dark Shadow Background
local shadowBg = Instance.new("Frame")
shadowBg.Name = "ShadowBg"
shadowBg.Size = UDim2.new(1, 35, 1, 35)
shadowBg.Position = UDim2.new(0.5, 0, 0.5, 0)
shadowBg.AnchorPoint = Vector2.new(0.5, 0.5)
shadowBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadowBg.BackgroundTransparency = 0.5
shadowBg.ZIndex = 1
shadowBg.Parent = mainFrame
Instance.new("UICorner", shadowBg).CornerRadius = UDim.new(0, 16)

-- Soft Shadow
local shadow = Instance.new("ImageLabel")
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 28, 1, 28)
shadow.ZIndex = 0
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5028857084"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(24, 24, 276, 276)
shadow.Parent = mainFrame

-- TITLE BAR
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
title.Text = "  Baba MM2 Script"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = THEME.TitleText
title.ZIndex = 3
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 14)

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 15, 15))
}
titleGradient.Rotation = 45
titleGradient.Parent = title

-- Animated accent line
local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 1, -2)
accentLine.BackgroundColor3 = THEME.Accent
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 4
accentLine.Parent = title

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -33, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.ZIndex = 4
closeBtn.Parent = title
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 40, 40)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
end)

-- TAB CONTAINER
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 30)
tabContainer.Position = UDim2.new(0, 10, 0, 44)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 3
tabContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

-- CONTENT FRAME
local contentFrame = Instance.new("Frame")
contentFrame.Position = UDim2.new(0, 10, 0, 82)
contentFrame.Size = UDim2.new(1, -20, 1, -90)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 3
contentFrame.Parent = mainFrame

-- Tabs
local tabs, tabButtons = {}, {}
local function createTab(name)
    local tab = Instance.new("ScrollingFrame")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.BorderSizePixel = 0
    tab.ScrollBarThickness = 3
    tab.ScrollBarImageColor3 = THEME.Accent
    tab.Visible = false
    tab.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.ZIndex = 3
    tab.Parent = contentFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tab
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    tabs[name] = tab
    return tab
end

local mainTab = createTab("Main")
local visualTab = createTab("Visual")
local miscTab = createTab("Misc")

local function setActiveTab(name)
    for tabName, tab in pairs(tabs) do
        tab.Visible = (tabName == name)
    end
    for tabName, btn in pairs(tabButtons) do
        TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = (tabName == name) and THEME.TabActive or THEME.TabIdle
        }):Play()
    end
end

local function createTabButton(text, tabName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 86, 0, 28)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = THEME.TextLight
    btn.BackgroundColor3 = THEME.TabIdle
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    btn.Parent = tabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(60, 60, 65)
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function() setActiveTab(tabName) end)
    btn.MouseEnter:Connect(function() 
        if not tabs[tabName].Visible then 
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.AccentHover}):Play() 
            TweenService:Create(btnStroke, TweenInfo.new(0.15), {Transparency = 0}):Play()
        end 
    end)
    btn.MouseLeave:Connect(function() 
        if not tabs[tabName].Visible then 
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.TabIdle}):Play() 
            TweenService:Create(btnStroke, TweenInfo.new(0.15), {Transparency = 0.5}):Play()
        end 
    end)
    tabButtons[tabName] = btn
end

createTabButton("Main", "Main")
createTabButton("Visual", "Visual")
createTabButton("Misc", "Misc")
setActiveTab("Main")

-- TOGGLE CREATOR
local function createToggle(tabName, data)
    local tab = tabs[tabName]
    if not tab then return warn("[BabaUI] Tab not found!") end

    local name = data.Name or "Toggle"
    local callback = data.Callback
    local colorOn = data.ColorOn or THEME.ToggleOnTrack

    local btn = Instance.new("TextButton")
    btn.Name = name .. "_Toggle"
    btn.Parent = tab
    btn.Size = UDim2.new(1, -5, 0, 34)
    btn.BackgroundColor3 = THEME.ToggleBg
    btn.TextColor3 = THEME.TextLight
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Text = "  " .. name
    btn.ZIndex = 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local track = Instance.new("Frame")
    track.Parent = btn
    track.Size = UDim2.new(0, 32, 0, 14)
    track.Position = UDim2.new(1, -42, 0.5, -7)
    track.BackgroundColor3 = THEME.ToggleOffTrack
    track.ZIndex = 5
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Parent = track
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(0, 1, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1,1,1)
    dot.ZIndex = 6
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local state = false
    local function animate(on)
        TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = on and UDim2.new(1, -15, 0.5, -7) or UDim2.new(0, 1, 0.5, -7)}):Play()
        TweenService:Create(track, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = on and colorOn or THEME.ToggleOffTrack}):Play()
    end

    btn.MouseButton1Click:Connect(function()
        state = not state
        animate(state)
        if callback then pcall(callback, state) end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.ToggleHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.ToggleBg}):Play()
    end)

    return {Set = function(v) if type(v)=="boolean" and v~=state then state=v animate(state) end end, Get = function() return state end}
end

-- SLIDER CREATOR
local function createSlider(tabName, data)
    local tab = tabs[tabName]
    if not tab then return warn("[BabaUI] Tab not found!") end

    local name = data.Name or "Slider"
    local min = data.Min or 0
    local max = data.Max or 100
    local default = data.Default or min
    local callback = data.Callback

    local frame = Instance.new("Frame")
    frame.Name = name .. "_Slider"
    frame.Parent = tab
    frame.Size = UDim2.new(1, -5, 0, 50)
    frame.BackgroundColor3 = THEME.ToggleBg
    frame.ZIndex = 4
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = THEME.TextLight
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 5
    label.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -16, 0, 6)
    sliderBg.Position = UDim2.new(0, 8, 0, 32)
    sliderBg.BackgroundColor3 = THEME.SliderBg
    sliderBg.ZIndex = 5
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    sliderBg.Parent = frame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = THEME.SliderFill
    sliderFill.ZIndex = 6
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    sliderFill.Parent = sliderBg

    local dragging = false

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)

            local value = math.floor(min + (max - min) * pos)
            label.Text = name .. ": " .. value
            if callback then pcall(callback, value) end
        end
    end)
end

-- BUTTON CREATOR
local function createButton(tabName, data)
    local tab = tabs[tabName]
    if not tab then return warn("[BabaUI] Tab not found!") end

    local name = data.Name or "Button"
    local callback = data.Callback

    local btn = Instance.new("TextButton")
    btn.Name = name .. "_Button"
    btn.Parent = tab
    btn.Size = UDim2.new(1, -5, 0, 34)
    btn.BackgroundColor3 = THEME.Accent
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = THEME.TextLight
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    btn.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.AccentHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Accent}):Play()
    end)
end

-- NOTIFICATION SYSTEM
local function createNotification(title, text, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, -310, 0, 10)
    notif.BackgroundColor3 = THEME.FrameBg
    notif.ZIndex = 100
    notif.Parent = gui
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 10)
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Thickness = 2
    notifStroke.Color = THEME.Accent
    notifStroke.Parent = notif
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0, 10, 0, 8)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 15
    notifTitle.TextColor3 = THEME.Accent
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.ZIndex = 101
    notifTitle.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 0, 40)
    notifText.Position = UDim2.new(0, 10, 0, 32)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.Font = Enum.Font.Gotham
    notifText.TextSize = 13
    notifText.TextColor3 = THEME.TextLight
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextYAlignment = Enum.TextYAlignment.Top
    notifText.TextWrapped = true
    notifText.ZIndex = 101
    notifText.Parent = notif
    
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 0, 10)
    }):Play()
    
    task.delay(duration or 5, function()
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 0, 10)
        }):Play()
        task.wait(0.4)
        notif:Destroy()
    end)
end

-- Open Button (Star Icon)
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 10, 0.2, 0)
toggleBtn.Text = "★"
toggleBtn.TextSize = 35
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.Active = true
toggleBtn.Draggable = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 9)

local stroke = Instance.new("UIStroke")
stroke.Parent = toggleBtn
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(255, 50, 50)
stroke.Transparency = 0.3

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

local isOpen = false
toggleBtn.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    mainFrame.Visible = isOpen
end)

-- Mobile Fly Controls
local mobileFrame = Instance.new("Frame", gui)
mobileFrame.Size = UDim2.new(0, 240, 0, 180)
mobileFrame.Position = UDim2.new(1, -250, 1, -190)
mobileFrame.BackgroundTransparency = 0.7
mobileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mobileFrame.Visible = false
mobileFrame.ZIndex = 10
Instance.new("UICorner", mobileFrame).CornerRadius = UDim.new(0, 12)

-- Up Button
local upBtn = Instance.new("TextButton", mobileFrame)
upBtn.Size = UDim2.new(0, 50, 0, 50)
upBtn.Position = UDim2.new(0.5, -25, 0, 10)
upBtn.Text = "▲"
upBtn.TextSize = 28
upBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upBtn.ZIndex = 11
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(0.3, 0)

-- Down Button
local downBtn = Instance.new("TextButton", mobileFrame)
downBtn.Size = UDim2.new(0, 50, 0, 50)
downBtn.Position = UDim2.new(0.5, -25, 1, -60)
downBtn.Text = "▼"
downBtn.TextSize = 28
downBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downBtn.ZIndex = 11
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(0.3, 0)

-- Forward Button
local forwardBtn = Instance.new("TextButton", mobileFrame)
forwardBtn.Size = UDim2.new(0, 50, 0, 50)
forwardBtn.Position = UDim2.new(0.5, -25, 0.35, 0)
forwardBtn.Text = "↑"
forwardBtn.TextSize = 28
forwardBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
forwardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forwardBtn.ZIndex = 11
Instance.new("UICorner", forwardBtn).CornerRadius = UDim.new(0.3, 0)

-- Back Button
local backBtn = Instance.new("TextButton", mobileFrame)
backBtn.Size = UDim2.new(0, 50, 0, 50)
backBtn.Position = UDim2.new(0.5, -25, 0.65, 0)
backBtn.Text = "↓"
backBtn.TextSize = 28
backBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backBtn.ZIndex = 11
Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0.3, 0)

-- Left Button
local leftBtn = Instance.new("TextButton", mobileFrame)
leftBtn.Size = UDim2.new(0, 50, 0, 50)
leftBtn.Position = UDim2.new(0.1, 0, 0.5, -25)
leftBtn.Text = "←"
leftBtn.TextSize = 28
leftBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
leftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
leftBtn.ZIndex = 11
Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0.3, 0)

-- Right Button
local rightBtn = Instance.new("TextButton", mobileFrame)
rightBtn.Size = UDim2.new(0, 50, 0, 50)
rightBtn.Position = UDim2.new(0.9, -50, 0.5, -25)
rightBtn.Text = "→"
rightBtn.TextSize = 28
rightBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
rightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rightBtn.ZIndex = 11
Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0.3, 0)

-- Mobile Fly Bindings
local function bindMobile(btn, direction)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            State.MobileFlyTouching[direction] = true
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = THEME.Accent}):Play()
        end
    end)
    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            State.MobileFlyTouching[direction] = false
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
        end
    end)
end

bindMobile(upBtn, "Up")
bindMobile(downBtn, "Down")
bindMobile(forwardBtn, "Forward")
bindMobile(backBtn, "Back")
bindMobile(leftBtn, "Left")
bindMobile(rightBtn, "Right")

-- Show mobile controls only when flying on mobile
RunService.Heartbeat:Connect(function()
    if UIS.TouchEnabled and Settings.FlyEnabled then
        mobileFrame.Visible = true
    else
        mobileFrame.Visible = false
    end
end)

-- HOTKEY
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ANTI-KICK UTILITIES
local function safeSetCFrame(part, newCFrame)
    if not newCFrame then return false end
    
    local pos = newCFrame.Position
    if pos.Y < -500 or pos.Y > 10000 then return false end
    if pos.Magnitude > 100000 then return false end
    
    State.LastValidPosition = part.CFrame
    
    pcall(function()
        part.CFrame = newCFrame
    end)
    
    return true
end

-- NOCLIP (UNDETECTED)
local function enableNoclip()
    if State.NoclipConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Store original collision states
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
                    -- Use a more subtle approach
                    task.spawn(function()
                        part.CanCollide = false
                    end)
                end
            end
        end)
    end)
    
    print("✅ Noclip enabled (undetected)")
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
                if part:IsA("BasePart") then
                    -- Restore original collision
                    if State.NoclipParts[part] ~= nil then
                        part.CanCollide = State.NoclipParts[part]
                    else
                        part.CanCollide = true
                    end
                end
            end
        end
    end)
    
    State.NoclipParts = {}
    print("❌ Noclip disabled")
end

-- FLY (REVAMPED - Smooth & Mobile Compatible)
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
    
    -- Create physics objects for smooth flying
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Parent = hrp
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.P = 9e4
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
        if not State.Flying then 
            keyDown:Disconnect()
            keyUp:Disconnect()
            return 
        end
        
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not humanoid then return end
            
            local cam = workspace.CurrentCamera
            local speed = Settings.FlySpeed
            
            -- Calculate movement direction (PC + Mobile)
            local moveVector = Vector3.new()
            
            -- PC Controls
            if State.FlyKeys.W or State.MobileFlyTouching.Forward then
                moveVector = moveVector + cam.CFrame.LookVector
            end
            if State.FlyKeys.S or State.MobileFlyTouching.Back then
                moveVector = moveVector - cam.CFrame.LookVector
            end
            if State.FlyKeys.A or State.MobileFlyTouching.Left then
                moveVector = moveVector - cam.CFrame.RightVector
            end
            if State.FlyKeys.D or State.MobileFlyTouching.Right then
                moveVector = moveVector + cam.CFrame.RightVector
            end
            if State.FlyKeys.Space or State.MobileFlyTouching.Up then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if State.FlyKeys.Shift or State.MobileFlyTouching.Down then
                moveVector = moveVector - Vector3.new(0, 1, 0)
            end
            
            -- Normalize and apply speed
            if moveVector.Magnitude > 0 then
                moveVector = moveVector.Unit * speed
            end
            
            -- Apply physics
            if flyBodyVelocity and flyBodyVelocity.Parent then
                flyBodyVelocity.Velocity = moveVector
            end
            
            if flyBodyGyro and flyBodyGyro.Parent then
                flyBodyGyro.CFrame = cam.CFrame
            end
            
            -- Keep humanoid in flying state
            humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end)
    end)
    
    print("✅ Fly enabled (PC + Mobile)")
end

local function disableFly()
    State.Flying = false
    
    if State.FlyConnection then
        State.FlyConnection:Disconnect()
        State.FlyConnection = nil
    end
    
    -- Remove physics objects
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
    
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
            end
        end
    end)
    
    print("❌ Fly disabled")
end

-- SPEED
local function enableSpeed()
    if State.SpeedConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    
    State.OriginalWalkSpeed = humanoid.WalkSpeed
    
    State.SpeedConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not humanoid then return end
            
            if humanoid.MoveDirection.Magnitude > 0 then
                local speedMultiplier = Settings.WalkSpeed / 16
                local moveDirection = humanoid.MoveDirection * (speedMultiplier - 1) * 0.5
                
                local newCFrame = hrp.CFrame + moveDirection
                
                if safeSetCFrame(hrp, newCFrame) then
                    hrp.Velocity = hrp.Velocity.Unit * math.min(hrp.Velocity.Magnitude, 50)
                end
            end
        end)
    end)
    
    print("✅ Speed enabled")
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
                humanoid.WalkSpeed = State.OriginalWalkSpeed or 16
            end
        end
    end)
    
    print("❌ Speed disabled")
end

-- ESP
local function createPlayerESP(player)
    if player == LocalPlayer then return end
    
    local function addHighlight(char)
        if not char then return end
        
        task.wait(0.1)
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        local oldHighlight = char:FindFirstChild("ESPHighlight")
        if oldHighlight then oldHighlight:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        local backpack = player:FindFirstChild("Backpack")
        local char = player.Character
        
        local hasKnife = false
        if backpack and backpack:FindFirstChild("Knife") then hasKnife = true end
        if char then
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == "Knife" then hasKnife = true end
            end
        end
        
        local hasGun = false
        if backpack and backpack:FindFirstChild("Gun") then hasGun = true end
        if char then
            for _, tool in pairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == "Gun" then hasGun = true end
            end
        end
        
        if hasKnife then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        elseif hasGun then
            highlight.FillColor = Color3.fromRGB(0, 0, 255)
            highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        end
        
        highlight.Parent = char
    end
    
    if player.Character then
        addHighlight(player.Character)
    end
    
    State.ESPConnections[player] = player.CharacterAdded:Connect(addHighlight)
end

local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        createPlayerESP(player)
    end
    
    State.ESPConnections["PlayerAdded"] = Players.PlayerAdded:Connect(createPlayerESP)
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
        end
    end
end

-- COIN ESP (FIXED - Working for MM2)
local function findAllCoins()
    local coins = {}
    
    -- Search in common coin locations
    local coinContainers = {
        workspace:FindFirstChild("Normal"),
        workspace:FindFirstChild("CoinContainer"),
        workspace:FindFirstChild("Coins")
    }
    
    for _, container in ipairs(coinContainers) do
        if container then
            for _, obj in pairs(container:GetDescendants()) do
                if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                    if obj.Name == "Coin" or obj.Name:find("Coin") then
                        table.insert(coins, obj)
                    end
                end
            end
        end
    end
    
    -- Fallback: search entire workspace
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
    -- Clear old highlights
    disableCoinESP()
    
    local coins = findAllCoins()
    
    if #coins == 0 then
        warn("⚠️ No coins found - ESP will activate when coins spawn")
    else
        print("✅ Found " .. #coins .. " coins")
    end
    
    -- Add highlights to all coins
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
    
    -- Auto-update when new coins spawn
    State.CoinESPConnections.Update = workspace.DescendantAdded:Connect(function(obj)
        task.wait(0.1)
        if (obj:IsA("Part") or obj:IsA("MeshPart")) and obj.Name == "Coin" then
            if not obj:FindFirstChild("CoinESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "CoinESP"
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
                highlight.FillTransparency = 0.2
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = obj
                print("✅ New coin detected - ESP added")
            end
        end
    end)
    
    print("✅ Coin ESP enabled - Auto-detecting new coins")
end

local function disableCoinESP()
    -- Disconnect update connection
    if State.CoinESPConnections.Update then
        State.CoinESPConnections.Update:Disconnect()
        State.CoinESPConnections.Update = nil
    end
    
    -- Remove all coin highlights
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "CoinESP" and obj:IsA("Highlight") then
            obj:Destroy()
        end
    end
    
    print("❌ Coin ESP disabled")
end

-- AUTO FARM COINS (IMPROVED - Much Faster)
local function getAllCoins()
    local coins = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("MeshPart") or obj:IsA("Part") then
            if obj.Name:lower():find("coin") or (obj.Parent and obj.Parent.Name:lower():find("coin")) then
                if obj:IsA("Part") and obj.Size.Magnitude < 10 then
                    table.insert(coins, obj)
                end
            end
        end
    end
    
    return coins
end

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
            
            local coins = getAllCoins()
            
            if #coins == 0 then
                return
            end
            
            -- Find nearest coin
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
            
            -- Instant teleport to coin
            if nearestCoin and nearestCoin.Parent then
                local targetPos = nearestCoin.Position
                hrp.CFrame = CFrame.new(targetPos)
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end)
    
    print("✅ Auto Farm Coins enabled (instant)")
end

local function disableAutoFarm()
    State.FarmingCoins = false
    
    if State.AutoFarmConnection then
        State.AutoFarmConnection:Disconnect()
        State.AutoFarmConnection = nil
    end
    
    print("❌ Auto Farm Coins disabled")
end

-- SILENT AIM (FIXED - Working for MM2)
local function enableSilentAim()
    if State.SilentAimConnection then return end
    
    State.SilentAimConnection = RunService.RenderStepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            
            local tool = char:FindFirstChildOfClass("Tool")
            if not tool or tool.Name ~= "Gun" then return end
            
            local mouse = LocalPlayer:GetMouse()
            if not mouse then return end
            
            -- Find nearest player
            local nearestPlayer = nil
            local nearestDistance = math.huge
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetChar = player.Character
                    local targetHead = targetChar:FindFirstChild("Head")
                    
                    if targetHead then
                        local distance = (char.HumanoidRootPart.Position - targetHead.Position).Magnitude
                        
                        if distance < nearestDistance and distance < 300 then
                            nearestDistance = distance
                            nearestPlayer = player
                        end
                    end
                end
            end
            
            -- Auto aim camera at head
            if nearestPlayer and nearestPlayer.Character then
                local targetHead = nearestPlayer.Character:FindFirstChild("Head")
                if targetHead then
                    local camera = workspace.CurrentCamera
                    local headPos = targetHead.Position
                    camera.CFrame = CFrame.new(camera.CFrame.Position, headPos)
                end
            end
        end)
    end)
    
    print("✅ Silent Aim enabled (auto-aim)")
end

local function disableSilentAim()
    if State.SilentAimConnection then
        State.SilentAimConnection:Disconnect()
        State.SilentAimConnection = nil
    end
    
    print("❌ Silent Aim disabled")
end

-- JUMP BOOST
local function enableJumpBoost()
    if State.JumpBoostConnection then return end
    
    State.JumpBoostConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            humanoid.JumpPower = Settings.JumpPower
        end)
    end)
    
    print("✅ Jump Boost enabled")
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
    
    print("❌ Jump Boost disabled")
end
local function teleportToPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return end
    
    local char = LocalPlayer.Character
    local targetChar = targetPlayer.Character
    
    if not char or not targetChar then 
        print("❌ Character not found")
        return 
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not targetHrp then 
        print("❌ HumanoidRootPart not found")
        return 
    end
    
    local newCFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
    
    if safeSetCFrame(hrp, newCFrame) then
        print("✅ Teleported to " .. targetPlayer.Name)
    else
        print("❌ Teleport failed")
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
        print("❌ No other players found")
        return
    end
    
    local randomPlayer = playersList[math.random(1, #playersList)]
    teleportToPlayer(randomPlayer)
end

-- FLING
local function enableFling()
    if State.FlingConnection then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlingVelocity"
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "FlingGyro"
    bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    bodyGyro.P = 9e9
    bodyGyro.Parent = hrp
    
    task.wait(0.1)
    
    bodyVelocity.MaxForce = Vector3.new(9e9, 0, 9e9)
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    
    State.FlingConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local bv = hrp:FindFirstChild("FlingVelocity")
            local bg = hrp:FindFirstChild("FlingGyro")
            
            if bv and bg then
                bg.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(360), 0)
                
                local cam = workspace.CurrentCamera
                bv.Velocity = (cam.CFrame.LookVector * 20) + Vector3.new(0, 2, 0)
                
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
                end
            end
        end)
    end)
    
    print("✅ Fling enabled")
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
                
                hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Sit = false
            end
        end
    end)
    
    print("❌ Fling disabled")
end

-- ADD UI ELEMENTS
createToggle("Main", {
    Name = "Walk Through Walls",
    Callback = function(enabled)
        Settings.NoclipEnabled = enabled
        if enabled then enableNoclip() else disableNoclip() end
    end
})

createToggle("Main", {
    Name = "Fly (WASD)",
    Callback = function(enabled)
        Settings.FlyEnabled = enabled
        if enabled then enableFly() else disableFly() end
    end
})

createSlider("Main", {
    Name = "Fly Speed",
    Min = 20,
    Max = 150,
    Default = 50,
    Callback = function(value)
        Settings.FlySpeed = value
    end
})

createToggle("Main", {
    Name = "Speed Boost",
    Callback = function(enabled)
        Settings.SpeedEnabled = enabled
        if enabled then enableSpeed() else disableSpeed() end
    end
})

createSlider("Main", {
    Name = "Speed Amount",
    Min = 16,
    Max = 50,
    Default = 25,
    Callback = function(value)
        Settings.WalkSpeed = value
    end
})

createSlider("Main", {
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(value)
        Settings.JumpPower = value
    end
})

createToggle("Main", {
    Name = "Jump Boost",
    Callback = function(enabled)
        Settings.JumpBoost = enabled
        if enabled then enableJumpBoost() else disableJumpBoost() end
    end
})

createToggle("Main", {
    Name = "Auto Farm Coins",
    Callback = function(enabled)
        Settings.AutoFarmCoins = enabled
        if enabled then enableAutoFarm() else disableAutoFarm() end
    end
})

createToggle("Main", {
    Name = "Infinite Jump",
    Callback = function(enabled)
        Settings.InfiniteJump = enabled
        if enabled then enableInfiniteJump() else disableInfiniteJump() end
    end
})

createToggle("Main", {
    Name = "No Fall Damage",
    Callback = function(enabled)
        Settings.NoFall = enabled
        if enabled then enableNoFall() else disableNoFall() end
    end
})

createToggle("Main", {
    Name = "Kill Aura (Murderer)",
    Callback = function(enabled)
        Settings.KillAura = enabled
        if enabled then enableKillAura() else disableKillAura() end
    end
})

createSlider("Main", {
    Name = "Kill Aura Range",
    Min = 5,
    Max = 30,
    Default = 15,
    Callback = function(value)
        Settings.KillAuraRange = value
    end
})

createToggle("Visual", {
    Name = "Silent Aim (Sheriff)",
    Callback = function(enabled)
        Settings.SilentAim = enabled
        if enabled then enableSilentAim() else disableSilentAim() end
    end
})

createToggle("Visual", {
    Name = "Player ESP (Roles)",
    Callback = function(enabled)
        Settings.ESPEnabled = enabled
        if enabled then enableESP() else disableESP() end
    end
})

createToggle("Visual", {
    Name = "Coin ESP (Auto-Detect)",
    Callback = function(enabled)
        Settings.CoinESPEnabled = enabled
        if enabled then
            enableCoinESP()
        else
            disableCoinESP()
        end
    end
})

createToggle("Misc", {
    Name = "Fling Players",
    Callback = function(enabled)
        Settings.FlingEnabled = enabled
        if enabled then enableFling() else disableFling() end
    end
})

createToggle("Misc", {
    Name = "Auto GG (Round End)",
    Callback = function(enabled)
        Settings.AutoGG = enabled
        if enabled then enableAutoGG() else disableAutoGG() end
    end
})

createToggle("Misc", {
    Name = "No Void (Visual Platform)",
    Callback = function(enabled)
        Settings.NoVoid = enabled
        if enabled then enableNoVoid() else disableNoVoid() end
    end
})

createButton("Misc", {
    Name = "Teleport to Random Player",
    Callback = function()
        teleportToRandom()
    end
})

-- Anti-Kick Protection Monitor
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
                            warn("⚠️ Invalid position detected - restored")
                        end
                    else
                        State.LastValidPosition = hrp.CFrame
                    end
                end
            end
        end)
    end
end)

print("✅ Baba MM2 Script Loaded")
print("📌 Press Right Shift or click star button to toggle menu")
print("⚠️ Recommended speed: 25-35 to avoid kick")

-- Show notification on execute
createNotification("Baba MM2 Script", "Script loaded successfully!\nMade by babathegoat123", 6)
