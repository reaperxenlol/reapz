--[[
    ██████╗ ███████╗ █████╗ ██████╗ ███████╗██████╗     ██╗  ██╗██╗   ██╗██████╗ 
    ██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗    ██║  ██║██║   ██║██╔══██╗
    ██████╔╝█████╗  ███████║██████╔╝█████╗  ██████╔╝    ███████║██║   ██║██████╔╝
    ██╔══██╗██╔══╝  ██╔══██║██╔═══╝ ██╔══╝  ██╔══██╗    ██╔══██║██║   ██║██╔══██╗
    ██║  ██║███████╗██║  ██║██║     ███████╗██║  ██║    ██║  ██║╚██████╔╝██████╔╝
    ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                    BLADE BALL EDITION v2.0 - GLASSMORPHISM
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
local SuccessfulParries = 0
local GUIVisible = true

-- Ball tracking for prediction
local BallHistory = {}
local MaxHistorySize = 10

-- ══════════════════════════════════════════════════════════════
-- ENHANCED PARRY FUNCTION - USING CORRECT REMOTE
-- ══════════════════════════════════════════════════════════════

local function PressParry()
    local success = false
    
    -- Primary Method: Direct Remote Fire (MOST RELIABLE FOR BLADE BALL)
    pcall(function()
        ReplicatedStorage.Remotes.ParryButtonPress:Fire()
        success = true
    end)
    
    -- Fallback Method 1: VirtualInputManager
    if not success then
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.delay(0.03, function()
                VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end)
            success = true
        end)
    end
    
    -- Fallback Method 2: keypress (Synapse, KRNL, Fluxus)
    if not success then
        pcall(function()
            if keypress then
                keypress(0x46)
                task.delay(0.03, function()
                    if keyrelease then keyrelease(0x46) end
                end)
                success = true
            end
        end)
    end
    
    return success
end

-- ══════════════════════════════════════════════════════════════
-- BALL DETECTION SYSTEM - BRICKCOLOR METHOD (WORKING)
-- ══════════════════════════════════════════════════════════════

local function IsBallTargetingMe(ball)
    if not ball or not ball.Parent then return false end
    
    -- PRIMARY METHOD: Check if ball is RED (targeting current player)
    local colorName = ball.BrickColor.Name:lower()
    local isRed = string.find(colorName, "red") ~= nil
    
    -- Also check Color3 for more accuracy
    local color = ball.Color
    local isRedColor = color.R > 0.7 and color.G < 0.4 and color.B < 0.4
    
    return isRed or isRedColor
end

local function GetBallData(ball)
    if not ball or not ball.Parent then return nil end
    if not HumanoidRootPart then return nil end
    
    local pos = ball.Position
    local vel = ball.AssemblyLinearVelocity or Vector3.new()
    local speed = vel.Magnitude
    local dist = LocalPlayer:DistanceFromCharacter(ball.CFrame.Position)
    
    local dir = speed > 1 and vel.Unit or Vector3.new()
    local toPlayer = (HumanoidRootPart.Position - pos).Unit
    local dot = dir:Dot(toPlayer)
    
    -- Use BrickColor to determine if targeting
    local targeting = IsBallTargetingMe(ball)
    
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

-- ══════════════════════════════════════════════════════════════
-- SIMPLIFIED PARRY DECISION - DISTANCE BASED (RELIABLE)
-- ══════════════════════════════════════════════════════════════

local function ShouldParry(ball, data)
    if not data then return false end
    
    -- Ball must be RED (targeting us)
    if not data.IsTargeting then return false end
    
    -- Check distance threshold
    local dist = data.Distance
    return dist <= Settings.ParryDistance
end

local function IsClashSituation(data)
    if not Settings.AntiClash or not data then return false end
    if not data.IsTargeting then return false end
    
    -- Clash = ball is close and slow
    local isClose = data.Distance <= Settings.ClashRange
    local isSlowOrStopped = data.Speed < 40
    
    return isClose and isSlowOrStopped
end

-- ══════════════════════════════════════════════════════════════
-- GLASSMORPHISM GUI SYSTEM
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

-- Sleek Dark Modern Color Palette (Subtle Glassmorphism)
local Theme = {
    -- Dark solid backgrounds with slight transparency
    GlassPrimary = Color3.fromRGB(18, 18, 22),
    GlassSecondary = Color3.fromRGB(25, 25, 30),
    GlassTertiary = Color3.fromRGB(35, 35, 42),
    
    -- Accent colors (cyan/blue modern feel)
    AccentPrimary = Color3.fromRGB(0, 170, 255),
    AccentSecondary = Color3.fromRGB(120, 80, 255),
    AccentGlow = Color3.fromRGB(0, 200, 255),
    
    -- Status colors
    Success = Color3.fromRGB(45, 212, 120),
    Warning = Color3.fromRGB(255, 180, 50),
    Danger = Color3.fromRGB(255, 75, 75),
    
    -- Text
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(170, 175, 185),
    TextMuted = Color3.fromRGB(100, 105, 115),
    
    -- Transparency values - MORE SOLID
    GlassTransparency = 0.05,  -- Almost fully opaque
    GlassBlurTransparency = 0.1,
    BorderTransparency = 0.4
}

-- Animation presets
local Animations = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
}

-- Helper function to create sleek dark panel with subtle glass edge
local function CreateGlassPanel(parent, props)
    props = props or {}
    
    local container = Instance.new("Frame")
    container.Name = props.Name or "GlassPanel"
    container.Parent = parent
    container.BackgroundColor3 = props.Color or Theme.GlassPrimary
    container.BackgroundTransparency = props.Transparency or Theme.GlassTransparency
    container.BorderSizePixel = 0
    container.Position = props.Position or UDim2.new(0, 0, 0, 0)
    container.Size = props.Size or UDim2.new(1, 0, 1, 0)
    container.ClipsDescendants = props.ClipsDescendants or false
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = props.CornerRadius or UDim.new(0, 10)
    corner.Parent = container
    
    -- Subtle top highlight gradient (gives depth)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 70)),
        ColorSequenceKeypoint.new(0.03, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.03, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    gradient.Rotation = 90
    gradient.Parent = container
    
    -- Clean border with subtle glow
    if props.Border ~= false then
        local stroke = Instance.new("UIStroke")
        stroke.Parent = container
        stroke.Color = props.BorderColor or Color3.fromRGB(50, 50, 60)
        stroke.Thickness = props.BorderThickness or 1
        stroke.Transparency = props.BorderTransparency or 0.3
    end
    
    return container
end

-- Helper function for 3D hover effects
local function Add3DHoverEffect(element, options)
    options = options or {}
    local scale = options.Scale or 1.02
    local lift = options.Lift or UDim2.new(0, 0, 0, -2)
    local glowIncrease = options.GlowIncrease or 0.2
    
    local originalPos = element.Position
    local originalSize = element.Size
    
    local isHovering = false
    
    element.MouseEnter:Connect(function()
        isHovering = true
        
        -- Scale up and lift
        TweenService:Create(element, Animations.Fast, {
            Position = originalPos + lift,
            BackgroundTransparency = math.max(0, (element.BackgroundTransparency or 0) - 0.05)
        }):Play()
        
        -- Glow effect on stroke if exists
        local stroke = element:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, Animations.Fast, {
                Transparency = math.max(0, stroke.Transparency - glowIncrease)
            }):Play()
        end
    end)
    
    element.MouseLeave:Connect(function()
        isHovering = false
        
        TweenService:Create(element, Animations.Normal, {
            Position = originalPos,
            BackgroundTransparency = element.BackgroundTransparency + 0.05
        }):Play()
        
        local stroke = element:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, Animations.Normal, {
                Transparency = stroke.Transparency + glowIncrease
            }):Play()
        end
    end)
end

-- Helper function for ripple click effect
local function AddRippleEffect(button)
    button.ClipsDescendants = true
    
    button.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.Parent = button
        ripple.BackgroundColor3 = Theme.AccentPrimary
        ripple.BackgroundTransparency = 0.7
        ripple.BorderSizePixel = 0
        ripple.ZIndex = 10
        
        local mouse = UserInputService:GetMouseLocation()
        local relX = mouse.X - button.AbsolutePosition.X
        local relY = mouse.Y - button.AbsolutePosition.Y - 36 -- Account for topbar
        
        ripple.Position = UDim2.new(0, relX, 0, relY)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        
        local rippleCorner = Instance.new("UICorner")
        rippleCorner.CornerRadius = UDim.new(1, 0)
        rippleCorner.Parent = ripple
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
        
        TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }):Play()
        
        task.delay(0.5, function()
            ripple:Destroy()
        end)
    end)
end

-- ══════════════════════════════════════════════════════════════
-- MAIN GUI CONSTRUCTION
-- ══════════════════════════════════════════════════════════════

-- Main container with entrance animation
local Main = CreateGlassPanel(ScreenGui, {
    Name = "Main",
    Position = UDim2.new(0.5, -240, 0.5, -220),
    Size = UDim2.new(0, 480, 0, 440),
    Color = Theme.GlassPrimary,
    Transparency = 0,  -- Fully solid
    CornerRadius = UDim.new(0, 12),
    BorderColor = Color3.fromRGB(45, 45, 55),
    BorderThickness = 1,
    BorderTransparency = 0
})
Main.Active = true
Main.Draggable = true

-- Accent border on top
local accentLine = Instance.new("Frame")
accentLine.Parent = Main
accentLine.BackgroundColor3 = Theme.AccentPrimary
accentLine.BorderSizePixel = 0
accentLine.Position = UDim2.new(0, 0, 0, 0)
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.ZIndex = 5

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 12)
accentCorner.Parent = accentLine

-- Entrance animation
Main.Position = UDim2.new(0.5, -240, 0.5, -180)
Main.BackgroundTransparency = 1
Main.Size = UDim2.new(0, 480, 0, 400)

task.spawn(function()
    task.wait(0.1)
    TweenService:Create(Main, Animations.Bounce, {
        Position = UDim2.new(0.5, -240, 0.5, -220),
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 480, 0, 440)
    }):Play()
end)

-- Header
local Header = CreateGlassPanel(Main, {
    Name = "Header",
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 55),
    Color = Theme.GlassSecondary,
    Transparency = 0,
    CornerRadius = UDim.new(0, 12),
    Border = false
})

-- Fix header bottom corners
local headerFix = Instance.new("Frame")
headerFix.Parent = Header
headerFix.BackgroundColor3 = Theme.GlassSecondary
headerFix.BackgroundTransparency = 0
headerFix.BorderSizePixel = 0
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.ZIndex = 0

-- Separator line
local headerSep = Instance.new("Frame")
headerSep.Parent = Header
headerSep.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
headerSep.BorderSizePixel = 0
headerSep.Position = UDim2.new(0, 15, 1, -1)
headerSep.Size = UDim2.new(1, -30, 0, 1)

-- Logo/Title container
local TitleContainer = Instance.new("Frame")
TitleContainer.Parent = Header
TitleContainer.BackgroundTransparency = 1
TitleContainer.Position = UDim2.new(0, 20, 0, 0)
TitleContainer.Size = UDim2.new(0, 250, 1, 0)

-- Animated logo icon
local LogoIcon = Instance.new("TextLabel")
LogoIcon.Parent = TitleContainer
LogoIcon.BackgroundTransparency = 1
LogoIcon.Position = UDim2.new(0, 0, 0.5, -15)
LogoIcon.Size = UDim2.new(0, 30, 0, 30)
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.Text = "⚡"
LogoIcon.TextColor3 = Theme.AccentPrimary
LogoIcon.TextSize = 24

-- Pulsing animation for logo
task.spawn(function()
    while LogoIcon and LogoIcon.Parent do
        TweenService:Create(LogoIcon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0.3
        }):Play()
        task.wait(1)
        TweenService:Create(LogoIcon, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            TextTransparency = 0
        }):Play()
        task.wait(1)
    end
end)

local Title = Instance.new("TextLabel")
Title.Parent = TitleContainer
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 38, 0, 8)
Title.Size = UDim2.new(0, 180, 0, 24)
Title.Font = Enum.Font.GothamBold
Title.Text = "REAPER HUB"
Title.TextColor3 = Theme.TextPrimary
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = TitleContainer
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 38, 0, 32)
Subtitle.Size = UDim2.new(0, 180, 0, 16)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "Blade Ball • v2.0 Glassmorphism"
Subtitle.TextColor3 = Theme.TextMuted
Subtitle.TextSize = 11
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Stats display
local StatsContainer = CreateGlassPanel(Header, {
    Name = "Stats",
    Position = UDim2.new(0.5, -10, 0.5, -15),
    Size = UDim2.new(0, 130, 0, 30),
    Color = Theme.GlassTertiary,
    Transparency = 0,
    CornerRadius = UDim.new(0, 6),
    Border = false
})

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Name = "StatsLabel"
StatsLabel.Parent = StatsContainer
StatsLabel.BackgroundTransparency = 1
StatsLabel.Size = UDim2.new(1, 0, 0.5, 0)
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.Text = "PARRIES"
StatsLabel.TextColor3 = Theme.TextMuted
StatsLabel.TextSize = 9

local StatsValue = Instance.new("TextLabel")
StatsValue.Name = "StatsValue"
StatsValue.Parent = StatsContainer
StatsValue.BackgroundTransparency = 1
StatsValue.Position = UDim2.new(0, 0, 0.4, 0)
StatsValue.Size = UDim2.new(1, 0, 0.6, 0)
StatsValue.Font = Enum.Font.GothamBold
StatsValue.Text = "0"
StatsValue.TextColor3 = Theme.Success
StatsValue.TextSize = 18

-- Close button
local CloseBtn = CreateGlassPanel(Header, {
    Name = "CloseBtn",
    Position = UDim2.new(1, -50, 0.5, -15),
    Size = UDim2.new(0, 30, 0, 30),
    Color = Color3.fromRGB(60, 35, 35),
    Transparency = 0,
    CornerRadius = UDim.new(0, 6),
    Border = false
})

local CloseBtnText = Instance.new("TextLabel")
CloseBtnText.Parent = CloseBtn
CloseBtnText.BackgroundTransparency = 1
CloseBtnText.Size = UDim2.new(1, 0, 1, 0)
CloseBtnText.Font = Enum.Font.GothamBold
CloseBtnText.Text = "✕"
CloseBtnText.TextColor3 = Theme.TextPrimary
CloseBtnText.TextSize = 16

local CloseBtnClickArea = Instance.new("TextButton")
CloseBtnClickArea.Parent = CloseBtn
CloseBtnClickArea.BackgroundTransparency = 1
CloseBtnClickArea.Size = UDim2.new(1, 0, 1, 0)
CloseBtnClickArea.Text = ""

Add3DHoverEffect(CloseBtn, {Lift = UDim2.new(0, 0, 0, -3)})
AddRippleEffect(CloseBtnClickArea)

CloseBtnClickArea.MouseButton1Click:Connect(function()
    -- Exit animation
    TweenService:Create(Main, Animations.Normal, {
        BackgroundTransparency = 1,
        Position = Main.Position + UDim2.new(0, 0, 0, 50)
    }):Play()
    task.delay(0.3, function()
        ScreenGui:Destroy()
    end)
end)

-- ══════════════════════════════════════════════════════════════
-- TAB SYSTEM
-- ══════════════════════════════════════════════════════════════

local TabContainer = CreateGlassPanel(Main, {
    Name = "TabContainer",
    Position = UDim2.new(0, 15, 0, 65),
    Size = UDim2.new(1, -30, 0, 40),
    Color = Theme.GlassTertiary,
    Transparency = 0,
    CornerRadius = UDim.new(0, 8),
    Border = false
})

local TabList = Instance.new("UIListLayout")
TabList.Parent = TabContainer
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabList.VerticalAlignment = Enum.VerticalAlignment.Center
TabList.Padding = UDim.new(0, 8)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabContainer
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)

-- Content container
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = Main
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 15, 0, 115)
Content.Size = UDim2.new(1, -30, 1, -125)

-- Tab data
local Tabs = {}
local Pages = {}
local ActiveTab = nil

local TabIcons = {
    Parry = "⚔️",
    Clash = "💥",
    ESP = "👁️",
    Move = "🏃",
    Misc = "⚙️"
}

local function CreateTab(name)
    local btn = CreateGlassPanel(TabContainer, {
        Name = name,
        Size = UDim2.new(0, 75, 0, 30),
        Color = Theme.GlassSecondary,
        Transparency = 0,
        CornerRadius = UDim.new(0, 6),
        BorderThickness = 0,
        Border = false
    })
    
    local btnText = Instance.new("TextLabel")
    btnText.Parent = btn
    btnText.BackgroundTransparency = 1
    btnText.Size = UDim2.new(1, 0, 1, 0)
    btnText.Font = Enum.Font.GothamMedium
    btnText.Text = (TabIcons[name] or "") .. " " .. name
    btnText.TextColor3 = Theme.TextMuted
    btnText.TextSize = 11
    
    local btnClick = Instance.new("TextButton")
    btnClick.Parent = btn
    btnClick.BackgroundTransparency = 1
    btnClick.Size = UDim2.new(1, 0, 1, 0)
    btnClick.Text = ""
    
    -- Page
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = Content
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Theme.AccentPrimary
    page.ScrollBarImageTransparency = 0.5
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.BorderSizePixel = 0
    
    local pageList = Instance.new("UIListLayout")
    pageList.Parent = page
    pageList.Padding = UDim.new(0, 10)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pagePad = Instance.new("UIPadding")
    pagePad.Parent = page
    pagePad.PaddingRight = UDim.new(0, 8)
    
    Tabs[name] = {Button = btn, Text = btnText, Click = btnClick}
    Pages[name] = page
    
    Add3DHoverEffect(btn)
    AddRippleEffect(btnClick)
    
    btnClick.MouseButton1Click:Connect(function()
        if ActiveTab == name then return end
        
        -- Deactivate all tabs
        for n, t in pairs(Tabs) do
            TweenService:Create(t.Button, Animations.Fast, {
                BackgroundColor3 = Theme.GlassSecondary
            }):Play()
            TweenService:Create(t.Text, Animations.Fast, {
                TextColor3 = Theme.TextMuted
            }):Play()
            
            Pages[n].Visible = false
        end
        
        -- Activate selected tab
        TweenService:Create(btn, Animations.Fast, {
            BackgroundColor3 = Theme.AccentPrimary
        }):Play()
        TweenService:Create(btnText, Animations.Fast, {
            TextColor3 = Theme.TextPrimary
        }):Play()
        
        -- Fade in page
        page.Visible = true
        for _, child in pairs(page:GetChildren()) do
            if child:IsA("Frame") then
                child.BackgroundTransparency = 1
                TweenService:Create(child, Animations.Normal, {
                    BackgroundTransparency = 0
                }):Play()
            end
        end
        
        ActiveTab = name
    end)
    
    return page
end

-- ══════════════════════════════════════════════════════════════
-- UI ELEMENT CREATORS
-- ══════════════════════════════════════════════════════════════

local function CreateSectionLabel(parent, text)
    local container = Instance.new("Frame")
    container.Parent = parent
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, 0, 0, 30)
    
    local line1 = Instance.new("Frame")
    line1.Parent = container
    line1.BackgroundColor3 = Theme.AccentPrimary
    line1.BackgroundTransparency = 0.7
    line1.BorderSizePixel = 0
    line1.Position = UDim2.new(0, 0, 0.5, 0)
    line1.Size = UDim2.new(0.15, 0, 0, 1)
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = container
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0.15, 10, 0, 0)
    lbl.Size = UDim2.new(0.7, -20, 1, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = text
    lbl.TextColor3 = Theme.AccentPrimary
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local line2 = Instance.new("Frame")
    line2.Parent = container
    line2.BackgroundColor3 = Theme.AccentPrimary
    line2.BackgroundTransparency = 0.7
    line2.BorderSizePixel = 0
    line2.Position = UDim2.new(0.85, 0, 0.5, 0)
    line2.Size = UDim2.new(0.15, 0, 0, 1)
end

local function CreateToggle(parent, text, setting, callback)
    local frame = CreateGlassPanel(parent, {
        Size = UDim2.new(1, 0, 0, 46),
        Color = Theme.GlassSecondary,
        Transparency = 0,
        CornerRadius = UDim.new(0, 8),
        BorderThickness = 1,
        BorderColor = Color3.fromRGB(40, 40, 48),
        BorderTransparency = 0
    })
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = frame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.Size = UDim2.new(1, -90, 1, 0)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = Theme.TextPrimary
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Modern toggle switch
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = frame
    toggleBg.BackgroundColor3 = Settings[setting] and Theme.AccentPrimary or Color3.fromRGB(50, 50, 58)
    toggleBg.Position = UDim2.new(1, -65, 0.5, -12)
    toggleBg.Size = UDim2.new(0, 48, 0, 24)
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBg
    
    -- Toggle circle
    local circle = Instance.new("Frame")
    circle.Parent = toggleBg
    circle.BackgroundColor3 = Theme.TextPrimary
    circle.Position = Settings[setting] and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    circle.Size = UDim2.new(0, 18, 0, 18)
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circle
    
    -- Circle shadow/depth
    local circleGradient = Instance.new("UIGradient")
    circleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    })
    circleGradient.Rotation = 90
    circleGradient.Parent = circle
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = ""
    
    Add3DHoverEffect(frame)
    AddRippleEffect(btn)
    
    btn.MouseButton1Click:Connect(function()
        Settings[setting] = not Settings[setting]
        
        local targetPos = Settings[setting] and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetColor = Settings[setting] and Theme.AccentPrimary or Color3.fromRGB(50, 50, 58)
        
        TweenService:Create(circle, Animations.Bounce, {Position = targetPos}):Play()
        TweenService:Create(toggleBg, Animations.Normal, {BackgroundColor3 = targetColor}):Play()
        
        if callback then callback(Settings[setting]) end
    end)
end

local function CreateSlider(parent, text, setting, min, max, callback)
    local frame = CreateGlassPanel(parent, {
        Size = UDim2.new(1, 0, 0, 60),
        Color = Theme.GlassSecondary,
        Transparency = 0,
        CornerRadius = UDim.new(0, 8),
        BorderThickness = 1,
        BorderColor = Color3.fromRGB(40, 40, 48),
        BorderTransparency = 0
    })
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = frame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 16, 0, 8)
    lbl.Size = UDim2.new(1, -80, 0, 20)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = Theme.TextPrimary
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Value display
    local valBg = CreateGlassPanel(frame, {
        Position = UDim2.new(1, -65, 0, 6),
        Size = UDim2.new(0, 50, 0, 22),
        Color = Theme.GlassTertiary,
        Transparency = 0,
        CornerRadius = UDim.new(0, 4),
        Border = false
    })
    
    local val = Instance.new("TextLabel")
    val.Parent = valBg
    val.BackgroundTransparency = 1
    val.Size = UDim2.new(1, 0, 1, 0)
    val.Font = Enum.Font.GothamBold
    val.Text = tostring(Settings[setting])
    val.TextColor3 = Theme.AccentPrimary
    val.TextSize = 12
    
    -- Slider track
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    sliderBg.Position = UDim2.new(0, 16, 0, 40)
    sliderBg.Size = UDim2.new(1, -32, 0, 6)
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderBg
    
    -- Slider fill with gradient
    local fill = Instance.new("Frame")
    fill.Parent = sliderBg
    fill.BackgroundColor3 = Theme.AccentPrimary
    fill.Size = UDim2.new((Settings[setting] - min) / (max - min), 0, 1, 0)
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
        ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
    })
    fillGradient.Parent = fill
    
    -- Slider knob
    local knob = Instance.new("Frame")
    knob.Parent = sliderBg
    knob.BackgroundColor3 = Theme.AccentPrimary
    knob.Position = UDim2.new((Settings[setting] - min) / (max - min), -7, 0.5, -7)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.ZIndex = 2
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
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
            
            TweenService:Create(fill, Animations.Fast, {
                Size = UDim2.new(rel, 0, 1, 0)
            }):Play()
            
            TweenService:Create(knob, Animations.Fast, {
                Position = UDim2.new(rel, -7, 0.5, -7)
            }):Play()
            
            if callback then callback(newVal) end
        end
    end)
    
    Add3DHoverEffect(frame)
end

local function CreateDropdown(parent, text, setting, options, callback)
    local frame = CreateGlassPanel(parent, {
        Size = UDim2.new(1, 0, 0, 46),
        Color = Theme.GlassSecondary,
        Transparency = 0,
        CornerRadius = UDim.new(0, 8),
        BorderThickness = 1,
        BorderColor = Color3.fromRGB(40, 40, 48),
        BorderTransparency = 0,
        ClipsDescendants = true
    })
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = frame
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 16, 0, 0)
    lbl.Size = UDim2.new(0.5, -16, 0, 50)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = Theme.TextPrimary
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropBtn = CreateGlassPanel(frame, {
        Position = UDim2.new(0.5, 0, 0, 8),
        Size = UDim2.new(0.5, -16, 0, 30),
        Color = Theme.GlassTertiary,
        Transparency = 0,
        CornerRadius = UDim.new(0, 6),
        Border = false
    })
    
    local dropText = Instance.new("TextLabel")
    dropText.Parent = dropBtn
    dropText.BackgroundTransparency = 1
    dropText.Size = UDim2.new(1, -25, 1, 0)
    dropText.Position = UDim2.new(0, 10, 0, 0)
    dropText.Font = Enum.Font.GothamMedium
    dropText.Text = Settings[setting]
    dropText.TextColor3 = Theme.AccentPrimary
    dropText.TextSize = 12
    dropText.TextXAlignment = Enum.TextXAlignment.Left
    
    local arrow = Instance.new("TextLabel")
    arrow.Parent = dropBtn
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.TextMuted
    arrow.TextSize = 10
    
    local dropClick = Instance.new("TextButton")
    dropClick.Parent = dropBtn
    dropClick.BackgroundTransparency = 1
    dropClick.Size = UDim2.new(1, 0, 1, 0)
    dropClick.Text = ""
    
    local open = false
    local optionFrames = {}
    
    AddRippleEffect(dropClick)
    
    dropClick.MouseButton1Click:Connect(function()
        open = not open
        
        if open then
            -- Expand
        TweenService:Create(frame, Animations.Smooth, {
            Size = UDim2.new(1, 0, 0, 46 + #options * 30)
        }):Play()
            
            TweenService:Create(arrow, Animations.Normal, {
                Rotation = 180
            }):Play()
            
            for i, opt in ipairs(options) do
                local optFrame = CreateGlassPanel(frame, {
                    Position = UDim2.new(0.5, 0, 0, 42 + i * 30),
                    Size = UDim2.new(0.5, -16, 0, 26),
                    Color = Theme.GlassTertiary,
                    Transparency = 0,
                    CornerRadius = UDim.new(0, 4),
                    Border = false
                })
                optFrame.Name = "Opt" .. i
                
                -- Entrance animation
                optFrame.Position = UDim2.new(0.5, 0, 0, 38 + i * 30)
                optFrame.BackgroundTransparency = 1
                TweenService:Create(optFrame, TweenInfo.new(0.15 + i * 0.03, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0, 42 + i * 30),
                    BackgroundTransparency = 0
                }):Play()
                
                local optText = Instance.new("TextLabel")
                optText.Parent = optFrame
                optText.BackgroundTransparency = 1
                optText.Size = UDim2.new(1, 0, 1, 0)
                optText.Font = Enum.Font.Gotham
                optText.Text = opt
                optText.TextColor3 = opt == Settings[setting] and Theme.AccentPrimary or Theme.TextSecondary
                optText.TextSize = 11
                
                local optClick = Instance.new("TextButton")
                optClick.Parent = optFrame
                optClick.BackgroundTransparency = 1
                optClick.Size = UDim2.new(1, 0, 1, 0)
                optClick.Text = ""
                
                Add3DHoverEffect(optFrame)
                AddRippleEffect(optClick)
                
                optClick.MouseButton1Click:Connect(function()
                    Settings[setting] = opt
                    dropText.Text = opt
                    open = false
                    
        TweenService:Create(frame, Animations.Smooth, {
            Size = UDim2.new(1, 0, 0, 46)
        }):Play()
                    
                    TweenService:Create(arrow, Animations.Normal, {
                        Rotation = 0
                    }):Play()
                    
                    for _, f in pairs(optionFrames) do
                        f:Destroy()
                    end
                    optionFrames = {}
                    
                    if callback then callback(opt) end
                end)
                
                table.insert(optionFrames, optFrame)
            end
        else
            -- Collapse
            TweenService:Create(frame, Animations.Smooth, {
                Size = UDim2.new(1, 0, 0, 50)
            }):Play()
            
            TweenService:Create(arrow, Animations.Normal, {
                Rotation = 0
            }):Play()
            
            for _, f in pairs(optionFrames) do
                TweenService:Create(f, Animations.Fast, {
                    BackgroundTransparency = 1
                }):Play()
            end
            
            task.delay(0.15, function()
                for _, f in pairs(optionFrames) do
                    f:Destroy()
                end
                optionFrames = {}
            end)
        end
    end)
    
    Add3DHoverEffect(frame)
end

-- ══════════════════════════════════════════════════════════════
-- CREATE TABS AND CONTENT
-- ══════════════════════════════════════════════════════════════

local parryPage = CreateTab("Parry")
local clashPage = CreateTab("Clash")
local espPage = CreateTab("ESP")
local movePage = CreateTab("Move")
local miscPage = CreateTab("Misc")

-- PARRY PAGE
CreateSectionLabel(parryPage, "AUTO PARRY SYSTEM")
CreateToggle(parryPage, "Enable Auto Parry", "AutoParry")
-- Parry method removed - now using reliable BrickColor detection
CreateSlider(parryPage, "Base Parry Distance", "ParryDistance", 5, 35)
CreateSlider(parryPage, "Velocity Multiplier", "VelocityMultiplier", 0.5, 2.0)

-- CLASH PAGE
CreateSectionLabel(clashPage, "CLASH SYSTEM")
CreateToggle(clashPage, "Anti-Clash Detection", "AntiClash")
CreateToggle(clashPage, "Clash Spam Mode", "ClashSpam")
CreateSlider(clashPage, "Clash Detection Range", "ClashRange", 3, 15)
CreateSlider(clashPage, "Clash Spam Speed", "ClashSpeed", 0.01, 0.2)

CreateSectionLabel(clashPage, "SPAM SETTINGS")
CreateToggle(clashPage, "Auto Spam", "AutoSpam")
CreateSlider(clashPage, "Spam CPS", "SpamCPS", 5, 50)

-- ESP PAGE
CreateSectionLabel(espPage, "VISUAL SETTINGS")
CreateToggle(espPage, "Ball ESP Highlight", "BallESP")
CreateToggle(espPage, "Show Distance Info", "ShowDistance")
CreateToggle(espPage, "Trajectory Prediction", "TrajectoryESP")

-- MOVE PAGE
CreateSectionLabel(movePage, "SPEED SETTINGS")
CreateToggle(movePage, "Enable Speed Boost", "SpeedEnabled", function(v)
    if Humanoid then
        Humanoid.WalkSpeed = v and Settings.WalkSpeed or 16
    end
end)
CreateSlider(movePage, "Walk Speed", "WalkSpeed", 16, 150, function(v)
    if Settings.SpeedEnabled and Humanoid then
        Humanoid.WalkSpeed = v
    end
end)

CreateSectionLabel(movePage, "AUTO PLAY")
CreateToggle(movePage, "Enable Auto Play", "AutoPlay")
CreateDropdown(movePage, "Play Style", "PlayStyle", {"Aggressive", "Defensive", "Balanced"})

-- MISC PAGE
CreateSectionLabel(miscPage, "UTILITY")
CreateToggle(miscPage, "Anti-AFK System", "AntiAFK")

local keyInfoFrame = CreateGlassPanel(miscPage, {
    Size = UDim2.new(1, 0, 0, 75),
    Color = Theme.GlassSecondary,
    Transparency = 0,
    CornerRadius = UDim.new(0, 8),
    BorderThickness = 1,
    BorderColor = Color3.fromRGB(40, 40, 48),
    BorderTransparency = 0
})

local keyInfoText = Instance.new("TextLabel")
keyInfoText.Parent = keyInfoFrame
keyInfoText.BackgroundTransparency = 1
keyInfoText.Position = UDim2.new(0, 16, 0, 0)
keyInfoText.Size = UDim2.new(1, -32, 1, 0)
keyInfoText.Font = Enum.Font.Gotham
keyInfoText.Text = "RIGHT CTRL - Toggle GUI\nF - Manual Parry\n\nReaper Hub v2.0"
keyInfoText.TextColor3 = Theme.TextSecondary
keyInfoText.TextSize = 11
keyInfoText.TextXAlignment = Enum.TextXAlignment.Left

-- Select first tab
task.spawn(function()
    task.wait(0.2)
    Tabs["Parry"].Click:Emit("MouseButton1Click")
end)

-- ══════════════════════════════════════════════════════════════
-- ESP SYSTEM (ENHANCED)
-- ══════════════════════════════════════════════════════════════

local ESPItems = {}

local function CreateESP(ball)
    if ESPItems[ball] then return end
    ESPItems[ball] = {}
    
    -- Highlight with better colors
    local hl = Instance.new("Highlight")
    hl.Parent = ball
    hl.FillTransparency = 0.6
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(ESPItems[ball], hl)
    
    -- Modern Billboard
    local bb = Instance.new("BillboardGui")
    bb.Parent = ball
    bb.Size = UDim2.new(0, 140, 0, 60)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    table.insert(ESPItems[ball], bb)
    
    local bg = Instance.new("Frame")
    bg.Parent = bb
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.GlassPrimary
    bg.BackgroundTransparency = 0.2
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 10)
    bgCorner.Parent = bg
    
    local bgStroke = Instance.new("UIStroke")
    bgStroke.Parent = bg
    bgStroke.Color = Theme.AccentPrimary
    bgStroke.Thickness = 1.5
    bgStroke.Transparency = 0.5
    
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = bg
    status.Position = UDim2.new(0, 0, 0, 5)
    status.Size = UDim2.new(1, 0, 0, 25)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.GothamBold
    status.Text = "● SAFE"
    status.TextColor3 = Theme.Success
    status.TextSize = 14
    
    local info = Instance.new("TextLabel")
    info.Name = "Info"
    info.Parent = bg
    info.Position = UDim2.new(0, 0, 0, 30)
    info.Size = UDim2.new(1, 0, 0, 25)
    info.BackgroundTransparency = 1
    info.Font = Enum.Font.Gotham
    info.Text = "0 studs • 0 speed"
    info.TextColor3 = Theme.TextMuted
    info.TextSize = 10
    
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
        
        -- Colors based on danger level
        if targeting then
            if dist <= 6 then
                hl.FillColor = Theme.Danger
                hl.OutlineColor = Color3.fromRGB(255, 150, 150)
                bgStroke.Color = Theme.Danger
                status.Text = "⚠️ PARRY NOW!"
                status.TextColor3 = Theme.Danger
            elseif dist <= Settings.ParryDistance then
                hl.FillColor = Theme.Warning
                hl.OutlineColor = Color3.fromRGB(255, 230, 150)
                bgStroke.Color = Theme.Warning
                status.Text = "⚡ INCOMING"
                status.TextColor3 = Theme.Warning
            else
                hl.FillColor = Color3.fromRGB(255, 200, 100)
                hl.OutlineColor = Color3.fromRGB(255, 230, 180)
                bgStroke.Color = Color3.fromRGB(255, 200, 100)
                status.Text = "👁️ TRACKING"
                status.TextColor3 = Color3.fromRGB(255, 200, 100)
            end
        else
            hl.FillColor = Theme.Success
            hl.OutlineColor = Color3.fromRGB(150, 255, 180)
            bgStroke.Color = Theme.Success
            status.Text = "● SAFE"
            status.TextColor3 = Theme.Success
        end
        
        if Settings.ShowDistance then
            info.Text = string.format("%.1f studs • %.0f speed", dist, data.Speed)
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
        BallHistory[ball:GetFullName()] = nil
    end)
end

-- ══════════════════════════════════════════════════════════════
-- MAIN PARRY LOOP - BRICKCOLOR BASED (WORKING METHOD)
-- ══════════════════════════════════════════════════════════════

local lastParry = 0
local ActiveParryTasks = {}

local function StartParry(ball)
    CurrentBall = ball
    CreateESP(ball)
    
    -- Cancel any existing task for this ball
    if ActiveParryTasks[ball] then
        pcall(function() task.cancel(ActiveParryTasks[ball]) end)
    end
    
    -- Main parry tracking task (similar to working code)
    local trackTask = task.spawn(function()
        while task.wait() do
            if not ball or not ball.Parent then break end
            if not Settings.AutoParry then continue end
            
            -- Check if ball is RED (targeting us)
            if IsBallTargetingMe(ball) then
                local dist = LocalPlayer:DistanceFromCharacter(ball.CFrame.Position)
                
                -- Clash handling
                if dist <= Settings.ClashRange and Settings.AntiClash then
                    IsClashing = true
                    if Settings.ClashSpam then
                        local now = tick()
                        if now - lastParry >= Settings.ClashSpeed then
                            PressParry()
                            lastParry = now
                            ParryCount = ParryCount + 1
                        end
                    end
                else
                    IsClashing = false
                end
                
                -- Wait until ball is within parry distance
                while LocalPlayer:DistanceFromCharacter(ball.CFrame.Position) > Settings.ParryDistance do
                    if not ball or not ball.Parent then break end
                    if not IsBallTargetingMe(ball) then break end
                    task.wait()
                end
                
                -- Double check ball still exists and is targeting
                if ball and ball.Parent and IsBallTargetingMe(ball) then
                    local now = tick()
                    if now - lastParry >= 0.05 then -- Small cooldown to prevent spam
                        PressParry()
                        lastParry = now
                        ParryCount = ParryCount + 1
                    end
                end
            end
        end
    end)
    
    ActiveParryTasks[ball] = trackTask
    
    -- Cleanup on ball destroy
    ball.Destroying:Connect(function()
        if ActiveParryTasks[ball] then
            pcall(function() task.cancel(ActiveParryTasks[ball]) end)
            ActiveParryTasks[ball] = nil
        end
        CurrentBall = nil
    end)
end

-- ══════════════════════════════════════════════════════════════
-- AUTO PLAY (ENHANCED)
-- ══════════════════════════════════════════════════════════════

local angle = 0
local smoothAngle = 0

RunService.Heartbeat:Connect(function(dt)
    if not Settings.AutoPlay then return end
    if not CurrentBall or not CurrentBall.Parent then return end
    if not Humanoid or not HumanoidRootPart then return end
    
    local ballPos = CurrentBall.Position
    local dist = (HumanoidRootPart.Position - ballPos).Magnitude
    
    -- Smooth angle interpolation
    angle = angle + dt * 1.5
    smoothAngle = smoothAngle + (angle - smoothAngle) * 0.1
    
    local targetPos
    
    if Settings.PlayStyle == "Aggressive" then
        if dist > 12 then
            targetPos = ballPos
        else
            local offset = Vector3.new(math.cos(smoothAngle) * 8, 0, math.sin(smoothAngle) * 8)
            targetPos = ballPos + offset
        end
    elseif Settings.PlayStyle == "Defensive" then
        local offset = Vector3.new(math.cos(smoothAngle) * 28, 0, math.sin(smoothAngle) * 28)
        targetPos = ballPos + offset
    else -- Balanced
        local radius = 16
        local offset = Vector3.new(math.cos(smoothAngle) * radius, 0, math.sin(smoothAngle) * radius)
        targetPos = ballPos + offset
    end
    
    if targetPos then
        Humanoid:MoveTo(targetPos)
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

-- GUI Toggle with animation
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Settings.GUIKey then
        if Main.Visible then
            TweenService:Create(Main, Animations.Normal, {
                BackgroundTransparency = 1,
                Position = Main.Position + UDim2.new(0, 0, 0, 30)
            }):Play()
            task.delay(0.25, function()
                Main.Visible = false
            end)
        else
            Main.Visible = true
            Main.BackgroundTransparency = 1
            Main.Position = UDim2.new(0.5, -240, 0.5, -190)
            TweenService:Create(Main, Animations.Bounce, {
                BackgroundTransparency = 0.08,
                Position = UDim2.new(0.5, -240, 0.5, -220)
            }):Play()
        end
    end
end)

-- Stats update with animation
task.spawn(function()
    local lastCount = 0
    while task.wait(0.3) do
        if StatsValue and StatsValue.Parent then
            if ParryCount ~= lastCount then
                StatsValue.Text = tostring(ParryCount)
                
                -- Pop animation on update
                TweenService:Create(StatsValue, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    TextSize = 22
                }):Play()
                task.delay(0.1, function()
                    TweenService:Create(StatsValue, Animations.Normal, {
                        TextSize = 18
                    }):Play()
                end)
                
                lastCount = ParryCount
            end
        end
    end
end)

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "⚡ Reaper Hub v2.0",
        Text = "Glassmorphism UI Loaded!\nPress RIGHT CTRL to toggle",
        Duration = 5
    })
end)

print([[
╔═══════════════════════════════════════════════════════════════════════╗
║        ⚡ REAPER HUB v2.0 - GLASSMORPHISM EDITION                     ║
╠═══════════════════════════════════════════════════════════════════════╣
║  ✨ Modern Glassmorphism UI with 3D Animations                        ║
║  🎯 Enhanced Predictive Auto-Parry System                             ║
║  ⌨️  Press RIGHT CTRL to toggle GUI                                   ║
║  ⌨️  Press F to manually parry                                        ║
╚═══════════════════════════════════════════════════════════════════════╝
]])
