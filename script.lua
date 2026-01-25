--[[
    ██████╗ ███████╗ █████╗ ██████╗ ███████╗██████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗    ██║  ██║██║   ██║██╔══██╗
    ██████╔╝█████╗  ███████║██████╔╝█████╗  ██████╔╝    ███████║██║   ██║██████╔╝
    ██╔══██╗██╔══╝  ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗    ██╔══██║██║   ██║██╔══██╗
    ██║  ██║███████╗██║  ██║██║     ███████╗██║  ██║    ██║  ██║╚██████╔╝██████╔╝
    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                            BLADE BALL EDITION v1.0
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game
local Balls = Workspace:WaitForChild("Balls")

-- Settings
local Settings = {
    AutoParry = true,
    ParryDistance = 15,
    ParryMethod = "Velocity",
    VelocityMultiplier = 1.0,
    
    AntiClash = true,
    ClashSpam = true,
    ClashSpeed = 0.05,
    ClashRange = 8,
    
    AutoSpam = false,
    SpamCPS = 20,
    
    BallESP = true,
    ShowDistance = true,
    TrajectoryESP = true,
    
    SpeedEnabled = false,
    WalkSpeed = 50,
    
    AutoPlay = false,
    PlayStyle = "Balanced",
    
    AntiAFK = true,
    
    GUIKey = Enum.KeyCode.RightControl
}

-- Variables
local CurrentBall = nil
local IsClashing = false
local ParryCount = 0
local GUIVisible = true

-- ══════════════════════════════════════════════════════════════
-- PARRY FUNCTION - PRESS F
-- ══════════════════════════════════════════════════════════════

local function PressParry()
    -- Method 1: VirtualInputManager
    local success1 = pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.delay(0.05, function()
            VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end)
    end)
    
    -- Method 2: keypress (Synapse, KRNL, Fluxus)
    pcall(function()
        if keypress then
            keypress(0x46)
            task.delay(0.05, function()
                if keyrelease then keyrelease(0x46) end
            end)
        end
    end)
    
    -- Method 3: Remote
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local parryRemote = remotes:FindFirstChild("ParryButtonPress")
            if parryRemote then
                parryRemote:Fire()
            end
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- BALL FUNCTIONS
-- ══════════════════════════════════════════════════════════════

local function GetBallData(ball)
    if not ball or not ball.Parent then return nil end
    if not HumanoidRootPart then return nil end
    
    local pos = ball.Position
    local vel = ball.AssemblyLinearVelocity or Vector3.new()
    local speed = vel.Magnitude
    local dist = (HumanoidRootPart.Position - pos).Magnitude
    
    local dir = speed > 1 and vel.Unit or Vector3.new()
    local toPlayer = (HumanoidRootPart.Position - pos).Unit
    local dot = dir:Dot(toPlayer)
    local targeting = dot > 0.3
    
    return {
        Position = pos,
        Velocity = vel,
        Speed = speed,
        Distance = dist,
        Direction = dir,
        IsTargeting = targeting,
        Dot = dot
    }
end

local function ShouldParry(data)
    if not data or not data.IsTargeting then return false end
    
    local dist = data.Distance
    local speed = data.Speed
    
    if Settings.ParryMethod == "Velocity" then
        local dynamicDist = Settings.ParryDistance + (speed * Settings.VelocityMultiplier * 0.07)
        dynamicDist = math.clamp(dynamicDist, 5, 35)
        return dist <= dynamicDist and dist > 3
    else
        return dist <= Settings.ParryDistance and dist > 3
    end
end

local function IsClashSituation(data)
    if not Settings.AntiClash or not data then return false end
    return data.Distance <= Settings.ClashRange and data.Speed < 50 and data.Dot > 0.1
end

-- ══════════════════════════════════════════════════════════════
-- GUI CREATION
-- ══════════════════════════════════════════════════════════════

-- Destroy old GUI if exists
if game.CoreGui:FindFirstChild("ReaperHub") then
    game.CoreGui:FindFirstChild("ReaperHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try different parent methods
local guiParent = game.CoreGui
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
    end
end)
pcall(function()
    if gethui then
        guiParent = gethui()
    end
end)
ScreenGui.Parent = guiParent

-- Colors
local C = {
    Bg = Color3.fromRGB(15, 15, 20),
    Bg2 = Color3.fromRGB(25, 25, 32),
    Accent = Color3.fromRGB(180, 50, 50),
    Accent2 = Color3.fromRGB(220, 70, 70),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    Green = Color3.fromRGB(50, 200, 100),
    Border = Color3.fromRGB(60, 60, 70)
}

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = C.Bg
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.5, -220, 0.5, -180)
Main.Size = UDim2.new(0, 440, 0, 360)
Main.Active = true
Main.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainBorder = Instance.new("UIStroke")
MainBorder.Parent = Main
MainBorder.Color = C.Accent
MainBorder.Thickness = 2

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = Main
Header.BackgroundColor3 = C.Accent
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 45)

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Parent = Header
HeaderFix.BackgroundColor3 = C.Accent
HeaderFix.BorderSizePixel = 0
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "☠️ REAPER HUB"
Title.TextColor3 = C.Text
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = Header
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 140, 0, 0)
Subtitle.Size = UDim2.new(0, 100, 1, 0)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Blade Ball"
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Stats
local Stats = Instance.new("TextLabel")
Stats.Name = "Stats"
Stats.Parent = Header
Stats.BackgroundTransparency = 1
Stats.Position = UDim2.new(0.5, 0, 0, 0)
Stats.Size = UDim2.new(0.3, 0, 1, 0)
Stats.Font = Enum.Font.GothamBold
Stats.Text = "Parries: 0"
Stats.TextColor3 = C.Green
Stats.TextSize = 14

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = C.Text
CloseBtn.TextSize = 14

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Parent = Main
TabContainer.BackgroundColor3 = C.Bg2
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 10, 0, 55)
TabContainer.Size = UDim2.new(1, -20, 0, 35)

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabContainer

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabContainer
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.Padding = UDim.new(0, 5)
TabList.VerticalAlignment = Enum.VerticalAlignment.Center

-- Content Container
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = Main
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 10, 0, 100)
Content.Size = UDim2.new(1, -20, 1, -110)

-- Tab System
local Tabs = {}
local Pages = {}
local ActiveTab = nil

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = TabContainer
    btn.BackgroundColor3 = C.Bg
    btn.Size = UDim2.new(0, 80, 0, 28)
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.TextColor3 = C.TextDim
    btn.TextSize = 12
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = Content
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = C.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local pageList = Instance.new("UIListLayout")
    pageList.Parent = page
    pageList.Padding = UDim.new(0, 8)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pagePad = Instance.new("UIPadding")
    pagePad.Parent = page
    pagePad.PaddingRight = UDim.new(0, 5)
    
    Tabs[name] = btn
    Pages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        for n, t in pairs(Tabs) do
            t.BackgroundColor3 = C.Bg
            t.TextColor3 = C.TextDim
            Pages[n].Visible = false
        end
        btn.BackgroundColor3 = C.Accent
        btn.TextColor3 = C.Text
        page.Visible = true
        ActiveTab = name
    end)
    
    return page
end

-- UI Elements
local function CreateLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = parent
    lbl.BackgroundColor3 = C.Accent
    lbl.BackgroundTransparency = 0.8
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "  " .. text
    lbl.TextColor3 = C.Accent2
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local lblCorner = Instance.new("UICorner")
    lblCorner.CornerRadius = UDim.new(0, 6)
    lblCorner.Parent = lbl
end

local function CreateToggle(parent, text, setting, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = C.Bg2
    frame.Size = UDim2.new(1, 0, 0, 38)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = frame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = C.Text
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = frame
    toggleBg.BackgroundColor3 = Settings[setting] and C.Accent or C.Bg
    toggleBg.Position = UDim2.new(1, -55, 0.5, -11)
    toggleBg.Size = UDim2.new(0, 44, 0, 22)
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    local circle = Instance.new("Frame")
    circle.Parent = toggleBg
    circle.BackgroundColor3 = C.Text
    circle.Position = Settings[setting] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    circle.Size = UDim2.new(0, 18, 0, 18)
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    
    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        
        local pos = Settings[setting] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        local col = Settings[setting] and C.Accent or C.Bg
        
        TweenService:Create(circle, TweenInfo.new(0.15), {Position = pos}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.15), {BackgroundColor3 = col}):Play()
        
        if callback then callback(Settings[setting]) end
    end)
end

local function CreateSlider(parent, text, setting, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = C.Bg2
    frame.Size = UDim2.new(1, 0, 0, 50)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = frame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 12, 0, 5)
    lbl.Size = UDim2.new(1, -60, 0, 18)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = C.Text
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local val = Instance.new("TextLabel")
    val.Parent = frame
    val.BackgroundTransparency = 1
    val.Position = UDim2.new(1, -50, 0, 5)
    val.Size = UDim2.new(0, 40, 0, 18)
    val.Font = Enum.Font.GothamBold
    val.Text = tostring(Settings[setting])
    val.TextColor3 = C.Accent2
    val.TextSize = 13
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.BackgroundColor3 = C.Bg
    sliderBg.Position = UDim2.new(0, 12, 0, 32)
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Parent = sliderBg
    fill.BackgroundColor3 = C.Accent
    fill.Size = UDim2.new((Settings[setting] - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local dragging = false
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local rel = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local newVal = math.floor((min + (max - min) * rel) * 10) / 10
            
            Settings[setting] = newVal
            val.Text = tostring(newVal)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            
            if callback then callback(newVal) end
        end
    end)
end

local function CreateDropdown(parent, text, setting, options, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = C.Bg2
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.ClipsDescendants = true
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = frame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.Size = UDim2.new(0.5, -12, 0, 38)
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextColor3 = C.Text
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Parent = frame
    dropBtn.BackgroundColor3 = C.Bg
    dropBtn.Position = UDim2.new(0.5, 0, 0, 5)
    dropBtn.Size = UDim2.new(0.5, -12, 0, 28)
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.Text = Settings[setting] .. " ▼"
    dropBtn.TextColor3 = C.Text
    dropBtn.TextSize = 12
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 6)
    dropCorner.Parent = dropBtn
    
    local open = false
    
    dropBtn.MouseButton1Click:Connect(function()
        open = not open
        
        if open then
            frame.Size = UDim2.new(1, 0, 0, 38 + #options * 28)
            
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Name = "Opt" .. i
                optBtn.Parent = frame
                optBtn.BackgroundColor3 = C.Bg
                optBtn.Position = UDim2.new(0.5, 0, 0, 35 + i * 26)
                optBtn.Size = UDim2.new(0.5, -12, 0, 24)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = opt
                optBtn.TextColor3 = C.TextDim
                optBtn.TextSize = 11
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    Settings[setting] = opt
                    dropBtn.Text = opt .. " ▼"
                    open = false
                    frame.Size = UDim2.new(1, 0, 0, 38)
                    
                    for _, c in pairs(frame:GetChildren()) do
                        if c.Name:match("Opt") then c:Destroy() end
                    end
                    
                    if callback then callback(opt) end
                end)
            end
        else
            frame.Size = UDim2.new(1, 0, 0, 38)
            for _, c in pairs(frame:GetChildren()) do
                if c.Name:match("Opt") then c:Destroy() end
            end
        end
    end)
end

-- Create Tabs
local parryPage = CreateTab("Parry")
local clashPage = CreateTab("Clash")
local espPage = CreateTab("ESP")
local movePage = CreateTab("Move")
local miscPage = CreateTab("Misc")

-- PARRY PAGE
CreateLabel(parryPage, "AUTO PARRY")
CreateToggle(parryPage, "Enable Auto Parry", "AutoParry")
CreateDropdown(parryPage, "Parry Method", "ParryMethod", {"Velocity", "Distance"})
CreateSlider(parryPage, "Parry Distance", "ParryDistance", 5, 30)
CreateSlider(parryPage, "Velocity Multiplier", "VelocityMultiplier", 0.5, 2.0)

-- CLASH PAGE
CreateLabel(clashPage, "CLASH SYSTEM")
CreateToggle(clashPage, "Anti-Clash", "AntiClash")
CreateToggle(clashPage, "Clash Spam", "ClashSpam")
CreateSlider(clashPage, "Clash Range", "ClashRange", 3, 15)
CreateSlider(clashPage, "Clash Speed", "ClashSpeed", 0.01, 0.2)

CreateLabel(clashPage, "SPAM")
CreateToggle(clashPage, "Auto Spam", "AutoSpam")
CreateSlider(clashPage, "Spam CPS", "SpamCPS", 5, 50)

-- ESP PAGE
CreateLabel(espPage, "VISUALS")
CreateToggle(espPage, "Ball ESP", "BallESP")
CreateToggle(espPage, "Show Distance", "ShowDistance")
CreateToggle(espPage, "Trajectory Line", "TrajectoryESP")

-- MOVE PAGE
CreateLabel(movePage, "SPEED")
CreateToggle(movePage, "Speed Enabled", "SpeedEnabled", function(v)
    if Humanoid then
        Humanoid.WalkSpeed = v and Settings.WalkSpeed or 16
    end
end)
CreateSlider(movePage, "Walk Speed", "WalkSpeed", 16, 150, function(v)
    if Settings.SpeedEnabled and Humanoid then
        Humanoid.WalkSpeed = v
    end
end)

CreateLabel(movePage, "AUTO PLAY")
CreateToggle(movePage, "Auto Play", "AutoPlay")
CreateDropdown(movePage, "Play Style", "PlayStyle", {"Aggressive", "Defensive", "Balanced"})

-- MISC PAGE
CreateLabel(miscPage, "UTILITY")
CreateToggle(miscPage, "Anti-AFK", "AntiAFK")

local keyInfo = Instance.new("TextLabel")
keyInfo.Parent = miscPage
keyInfo.BackgroundColor3 = C.Bg2
keyInfo.Size = UDim2.new(1, 0, 0, 50)
keyInfo.Font = Enum.Font.Gotham
keyInfo.Text = "Press RIGHT CTRL to toggle GUI\nPress F to manually parry"
keyInfo.TextColor3 = C.TextDim
keyInfo.TextSize = 12

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyInfo

-- Select first tab
Tabs["Parry"].BackgroundColor3 = C.Accent
Tabs["Parry"].TextColor3 = C.Text
Pages["Parry"].Visible = true
ActiveTab = "Parry"

-- ══════════════════════════════════════════════════════════════
-- ESP SYSTEM
-- ══════════════════════════════════════════════════════════════

local ESPItems = {}

local function CreateESP(ball)
    if ESPItems[ball] then return end
    ESPItems[ball] = {}
    
    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Parent = ball
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(ESPItems[ball], hl)
    
    -- Billboard
    local bb = Instance.new("BillboardGui")
    bb.Parent = ball
    bb.Size = UDim2.new(0, 120, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    table.insert(ESPItems[ball], bb)
    
    local bg = Instance.new("Frame")
    bg.Parent = bb
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    bg.BackgroundTransparency = 0.3
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 6)
    bgCorner.Parent = bg
    
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = bg
    status.Size = UDim2.new(1, 0, 0.5, 0)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.GothamBold
    status.Text = "SAFE"
    status.TextColor3 = C.Green
    status.TextSize = 14
    
    local info = Instance.new("TextLabel")
    info.Name = "Info"
    info.Parent = bg
    info.Position = UDim2.new(0, 0, 0.5, 0)
    info.Size = UDim2.new(1, 0, 0.5, 0)
    info.BackgroundTransparency = 1
    info.Font = Enum.Font.Gotham
    info.Text = "0 studs"
    info.TextColor3 = C.TextDim
    info.TextSize = 11
    
    -- Update loop
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not ball or not ball.Parent then
            conn:Disconnect()
            return
        end
        
        if not Settings.BallESP then
            hl.Enabled = false
            bb.Enabled = false
            return
        end
        
        hl.Enabled = true
        bb.Enabled = true
        
        local data = GetBallData(ball)
        if not data then return end
        
        local dist = data.Distance
        local targeting = data.IsTargeting
        
        -- Colors based on danger
        if targeting then
            if dist <= 5 then
                hl.FillColor = Color3.fromRGB(255, 50, 50)
                hl.OutlineColor = Color3.fromRGB(255, 100, 100)
                status.Text = "PARRY!"
                status.TextColor3 = Color3.fromRGB(255, 50, 50)
            elseif dist <= Settings.ParryDistance then
                hl.FillColor = Color3.fromRGB(255, 150, 50)
                hl.OutlineColor = Color3.fromRGB(255, 200, 100)
                status.Text = "DANGER"
                status.TextColor3 = Color3.fromRGB(255, 150, 50)
            else
                hl.FillColor = Color3.fromRGB(255, 200, 50)
                hl.OutlineColor = Color3.fromRGB(255, 230, 100)
                status.Text = "WARNING"
                status.TextColor3 = Color3.fromRGB(255, 200, 50)
            end
        else
            hl.FillColor = Color3.fromRGB(50, 200, 100)
            hl.OutlineColor = Color3.fromRGB(100, 255, 150)
            status.Text = "SAFE"
            status.TextColor3 = C.Green
        end
        
        if Settings.ShowDistance then
            info.Text = string.format("%.1f studs | %.0f speed", dist, data.Speed)
        else
            info.Text = ""
        end
    end)
    
    table.insert(ESPItems[ball], conn)
    
    ball.Destroying:Connect(function()
        conn:Disconnect()
        for _, item in pairs(ESPItems[ball] or {}) do
            if typeof(item) == "RBXScriptConnection" then
                item:Disconnect()
            else
                pcall(function() item:Destroy() end)
            end
        end
        ESPItems[ball] = nil
    end)
end

-- ══════════════════════════════════════════════════════════════
-- MAIN PARRY LOOP
-- ══════════════════════════════════════════════════════════════

local lastParry = 0

local function StartParry(ball)
    CurrentBall = ball
    CreateESP(ball)
    
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not ball or not ball.Parent then
            conn:Disconnect()
            return
        end
        
        if not Settings.AutoParry then return end
        if not HumanoidRootPart then return end
        
        local data = GetBallData(ball)
        if not data then return end
        
        local now = tick()
        
        -- Clash handling
        if IsClashSituation(data) then
            IsClashing = true
            if Settings.ClashSpam then
                if now - lastParry >= Settings.ClashSpeed then
                    PressParry()
                    lastParry = now
                    ParryCount = ParryCount + 1
                end
            end
            return
        else
            IsClashing = false
        end
        
        -- Normal parry
        if ShouldParry(data) then
            if now - lastParry >= 0.1 then
                PressParry()
                lastParry = now
                ParryCount = ParryCount + 1
            end
        end
        
        -- Auto spam
        if Settings.AutoSpam then
            if data.IsTargeting and data.Distance <= Settings.ParryDistance + 10 then
                if now - lastParry >= (1 / Settings.SpamCPS) then
                    PressParry()
                    lastParry = now
                end
            end
        end
    end)
    
    ball.Destroying:Connect(function()
        conn:Disconnect()
    end)
end

-- ══════════════════════════════════════════════════════════════
-- AUTO PLAY
-- ══════════════════════════════════════════════════════════════

local angle = 0
RunService.Heartbeat:Connect(function()
    if not Settings.AutoPlay then return end
    if not CurrentBall or not CurrentBall.Parent then return end
    if not Humanoid or not HumanoidRootPart then return end
    
    local ballPos = CurrentBall.Position
    local dist = (HumanoidRootPart.Position - ballPos).Magnitude
    
    angle = angle + 0.03
    
    if Settings.PlayStyle == "Aggressive" then
        if dist > 15 then
            Humanoid:MoveTo(ballPos)
        else
            local offset = Vector3.new(math.cos(angle) * 10, 0, math.sin(angle) * 10)
            Humanoid:MoveTo(ballPos + offset)
        end
    elseif Settings.PlayStyle == "Defensive" then
        local offset = Vector3.new(math.cos(angle) * 25, 0, math.sin(angle) * 25)
        Humanoid:MoveTo(ballPos + offset)
    else
        local radius = 18
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        Humanoid:MoveTo(ballPos + offset)
    end
end)

-- ══════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ══════════════════════════════════════════════════════════════

-- Ball detection
Balls.ChildAdded:Connect(function(ball)
    if ball:IsA("BasePart") then
        task.wait(0.1)
        StartParry(ball)
    end
end)

for _, ball in pairs(Balls:GetChildren()) do
    if ball:IsA("BasePart") then
        StartParry(ball)
    end
end

-- Character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    task.wait(1)
    
    if Settings.SpeedEnabled then
        Humanoid.WalkSpeed = Settings.WalkSpeed
    end
    
    for _, ball in pairs(Balls:GetChildren()) do
        if ball:IsA("BasePart") then
            StartParry(ball)
        end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- GUI Toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Settings.GUIKey then
        Main.Visible = not Main.Visible
    end
end)

-- Stats update
task.spawn(function()
    while task.wait(0.5) do
        if Stats and Stats.Parent then
            Stats.Text = "Parries: " .. ParryCount
        end
    end
end)

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "☠️ Reaper Hub",
        Text = "Loaded! Press RIGHT CTRL to toggle",
        Duration = 5
    })
end)

print([[
╔═══════════════════════════════════════════════════════════════╗
║              ☠️ REAPER HUB - BLADE BALL v1.0                 ║
╠═══════════════════════════════════════════════════════════════╣
║  Auto Parry: ON          Anti-Clash: ON                      ║
║  Press RIGHT CTRL to toggle GUI                              ║
║  Press F to manually parry                                   ║
╚═══════════════════════════════════════════════════════════════╝
]])
