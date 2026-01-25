--[[
╔══════════════════════════════════════════════════════════════════════════════════╗
║                                                                                  ║
║   ██████╗ ██╗      █████╗ ██████╗ ███████╗    ██████╗  █████╗ ██╗     ██╗        ║
║   ██╔══██╗██║     ██╔══██╗██╔══██╗██╔════╝    ██╔══██╗██╔══██╗██║     ██║        ║
║   ██████╔╝██║     ███████║██║  ██║█████╗      ██████╔╝███████║██║     ██║        ║
║   ██╔══██╗██║     ██╔══██║██║  ██║██╔══╝      ██╔══██╗██╔══██║██║     ██║        ║
║   ██████╔╝███████╗██║  ██║██████╔╝███████╗    ██████╔╝██║  ██║███████╗███████╗   ║
║   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ║
║                                                                                  ║
║                         NEXUS PRO v4.0 - COMPETITIVE EDITION                     ║
║                                                                                  ║
╚══════════════════════════════════════════════════════════════════════════════════╝
]]

-- ════════════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ════════════════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

-- ════════════════════════════════════════════════════════════════════════════════
-- PLAYER
-- ════════════════════════════════════════════════════════════════════════════════
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ════════════════════════════════════════════════════════════════════════════════
-- GAME REFERENCES
-- ════════════════════════════════════════════════════════════════════════════════
local Balls = Workspace:WaitForChild("Balls")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- ════════════════════════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ════════════════════════════════════════════════════════════════════════════════
getgenv().NexusConfig = getgenv().NexusConfig or {
    -- PARRY SYSTEM
    AutoParry = true,
    ParryMethod = "Velocity", -- Velocity, Distance, Hybrid
    BaseDistance = 15,
    MinDistance = 3,
    
    -- ADVANCED PARRY
    VelocityMultiplier = 1.0,
    ReactionTime = 0.0, -- Add delay to seem human (0 = instant)
    PredictionFrames = 3,
    
    -- CLASH HANDLING
    AntiClash = true,
    ClashSpamSpeed = 0.05,
    ClashDetectionRange = 8,
    AutoSpamOnClash = true,
    
    -- SPAM SYSTEM
    AutoSpam = false,
    SpamCPS = 20, -- Clicks per second
    SmartSpam = true, -- Only spam when needed
    
    -- ESP
    BallESP = true,
    PlayerESP = false,
    TrajectoryLine = true,
    DangerIndicator = true,
    
    -- MOVEMENT
    SpeedHack = false,
    WalkSpeed = 16,
    JumpPower = 50,
    
    -- AUTO PLAY
    AutoPlay = false,
    PlayStyle = "Aggressive", -- Aggressive, Defensive, Balanced
    
    -- MISC
    AntiAFK = true,
    Notifications = true,
    DebugMode = false,
    
    -- GUI
    ToggleKey = Enum.KeyCode.RightShift
}

local Config = getgenv().NexusConfig

-- ════════════════════════════════════════════════════════════════════════════════
-- VARIABLES
-- ════════════════════════════════════════════════════════════════════════════════
local CurrentBall = nil
local BallVelocity = Vector3.new()
local BallSpeed = 0
local LastBallPos = Vector3.new()
local IsClashing = false
local ClashStartTime = 0
local ParryCount = 0
local LastParryTime = 0

-- ════════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ════════════════════════════════════════════════════════════════════════════════

local function Notify(title, text, duration)
    if not Config.Notifications then return end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

local function DebugPrint(...)
    if Config.DebugMode then
        print("[NEXUS DEBUG]", ...)
    end
end

local function GetDistance(pos)
    if not HumanoidRootPart then return math.huge end
    return (HumanoidRootPart.Position - pos).Magnitude
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

-- ════════════════════════════════════════════════════════════════════════════════
-- ADVANCED PARRY SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

local function PressF()
    -- Method 1: VirtualInputManager (Best for most executors)
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.spawn(function()
            task.wait()
            VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end)
    end)
    
    -- Method 2: keypress (Synapse, KRNL, etc.)
    pcall(function()
        if keypress then
            keypress(0x46)
            task.spawn(function()
                task.wait()
                keyrelease(0x46)
            end)
        end
    end)
    
    -- Method 3: Input library
    pcall(function()
        if Input then
            Input.KeyPress(Enum.KeyCode.F)
        end
    end)
    
    -- Method 4: Remote fallback
    pcall(function()
        if Remotes:FindFirstChild("ParryButtonPress") then
            Remotes.ParryButtonPress:Fire()
        end
    end)
end

local function CalculateBallData(ball)
    if not ball or not ball.Parent then return nil end
    
    local currentPos = ball.Position
    local velocity = ball.AssemblyLinearVelocity or ball.Velocity or Vector3.new()
    local speed = velocity.Magnitude
    
    -- Calculate direction
    local direction = speed > 1 and velocity.Unit or Vector3.new()
    
    -- Check if targeting player
    local toPlayer = HumanoidRootPart and (HumanoidRootPart.Position - currentPos).Unit or Vector3.new()
    local dotProduct = direction:Dot(toPlayer)
    local isTargeting = dotProduct > 0.3
    
    -- Predict future position
    local timeToReach = GetDistance(currentPos) / math.max(speed, 1)
    local predictedPos = currentPos + velocity * math.min(timeToReach, 1)
    local predictedDistance = GetDistance(predictedPos)
    
    return {
        Position = currentPos,
        Velocity = velocity,
        Speed = speed,
        Direction = direction,
        IsTargeting = isTargeting,
        Distance = GetDistance(currentPos),
        PredictedDistance = predictedDistance,
        TimeToReach = timeToReach,
        DotProduct = dotProduct
    }
end

local function ShouldParry(ballData)
    if not ballData or not ballData.IsTargeting then return false end
    
    local distance = ballData.Distance
    local speed = ballData.Speed
    local predictedDist = ballData.PredictedDistance
    
    -- Calculate dynamic parry distance based on ball speed
    local dynamicDistance = Config.BaseDistance
    
    if Config.ParryMethod == "Velocity" then
        -- Faster ball = parry earlier
        dynamicDistance = Config.BaseDistance + (speed * Config.VelocityMultiplier * 0.08)
        dynamicDistance = math.clamp(dynamicDistance, Config.MinDistance, 35)
        
        return distance <= dynamicDistance and distance > Config.MinDistance
        
    elseif Config.ParryMethod == "Distance" then
        return distance <= Config.BaseDistance and distance > Config.MinDistance
        
    elseif Config.ParryMethod == "Hybrid" then
        -- Use both velocity and prediction
        local velocityDist = Config.BaseDistance + (speed * Config.VelocityMultiplier * 0.06)
        local shouldParryVelocity = distance <= velocityDist
        local shouldParryPrediction = predictedDist <= Config.BaseDistance * 0.8
        
        return (shouldParryVelocity or shouldParryPrediction) and distance > Config.MinDistance
    end
    
    return false
end

local function DetectClash(ballData)
    if not Config.AntiClash or not ballData then return false end
    
    -- Clash detection: ball is very close and moving slowly or stopped
    local isClose = ballData.Distance <= Config.ClashDetectionRange
    local isSlowOrStopped = ballData.Speed < 50
    local wasTargeting = ballData.DotProduct > 0.1
    
    -- Check if ball has been close for a while (clash situation)
    if isClose and isSlowOrStopped and wasTargeting then
        if not IsClashing then
            IsClashing = true
            ClashStartTime = tick()
            DebugPrint("CLASH DETECTED!")
        end
        return true
    else
        IsClashing = false
    end
    
    return false
end

-- ════════════════════════════════════════════════════════════════════════════════
-- MAIN PARRY LOOP
-- ════════════════════════════════════════════════════════════════════════════════

local ParryConnection = nil

local function StartParrySystem(ball)
    if ParryConnection then ParryConnection:Disconnect() end
    
    local lastParry = 0
    local clashSpamActive = false
    
    ParryConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoParry then return end
        if not ball or not ball.Parent then return end
        if not HumanoidRootPart then return end
        
        local ballData = CalculateBallData(ball)
        if not ballData then return end
        
        -- Store for ESP
        BallVelocity = ballData.Velocity
        BallSpeed = ballData.Speed
        
        local currentTime = tick()
        
        -- CLASH HANDLING (Priority)
        if DetectClash(ballData) then
            if Config.AutoSpamOnClash then
                -- Spam parry during clash
                if currentTime - lastParry >= Config.ClashSpamSpeed then
                    PressF()
                    lastParry = currentTime
                    ParryCount = ParryCount + 1
                    DebugPrint("CLASH SPAM - Distance:", math.floor(ballData.Distance))
                end
            end
            return
        end
        
        -- NORMAL PARRY
        if ShouldParry(ballData) then
            -- Add reaction time delay if configured
            if Config.ReactionTime > 0 then
                task.wait(Config.ReactionTime)
            end
            
            -- Cooldown check
            if currentTime - lastParry >= 0.15 then
                PressF()
                lastParry = currentTime
                ParryCount = ParryCount + 1
                
                DebugPrint(string.format("PARRY #%d | Dist: %.1f | Speed: %.0f | Method: %s", 
                    ParryCount, ballData.Distance, ballData.Speed, Config.ParryMethod))
            end
        end
        
        -- AUTO SPAM (if enabled separately)
        if Config.AutoSpam and not IsClashing then
            if Config.SmartSpam then
                -- Only spam when ball is close
                if ballData.Distance <= Config.BaseDistance + 5 and ballData.IsTargeting then
                    if currentTime - lastParry >= (1 / Config.SpamCPS) then
                        PressF()
                        lastParry = currentTime
                    end
                end
            else
                -- Always spam
                if currentTime - lastParry >= (1 / Config.SpamCPS) then
                    PressF()
                    lastParry = currentTime
                end
            end
        end
    end)
    
    ball.Destroying:Connect(function()
        if ParryConnection then ParryConnection:Disconnect() end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- ESP SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

local ESPObjects = {}

local function CreateModernESP(ball)
    if not Config.BallESP then return end
    
    -- Cleanup old ESP
    if ESPObjects[ball] then
        for _, obj in pairs(ESPObjects[ball]) do
            pcall(function() obj:Destroy() end)
        end
    end
    ESPObjects[ball] = {}
    
    -- Main Highlight
    local highlight = Instance.new("Highlight")
    highlight.Parent = ball
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(ESPObjects[ball], highlight)
    
    -- Info Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = ball
    billboard.Size = UDim2.new(0, 180, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    table.insert(ESPObjects[ball], billboard)
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = billboard
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BackgroundTransparency = 0.2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = mainFrame
    stroke.Thickness = 2
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = mainFrame
    statusLabel.Size = UDim2.new(1, 0, 0.4, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 16
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Parent = mainFrame
    infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
    infoLabel.Size = UDim2.new(1, 0, 0.6, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 12
    infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    
    -- Trajectory Line
    local trajectoryPart = nil
    if Config.TrajectoryLine then
        trajectoryPart = Instance.new("Part")
        trajectoryPart.Parent = Workspace
        trajectoryPart.Anchored = true
        trajectoryPart.CanCollide = false
        trajectoryPart.Material = Enum.Material.Neon
        trajectoryPart.Transparency = 0.3
        table.insert(ESPObjects[ball], trajectoryPart)
    end
    
    -- Update Loop
    local updateConn
    updateConn = RunService.RenderStepped:Connect(function()
        if not ball or not ball.Parent then
            updateConn:Disconnect()
            return
        end
        
        local ballData = CalculateBallData(ball)
        if not ballData then return end
        
        local distance = ballData.Distance
        local speed = ballData.Speed
        local isTargeting = ballData.IsTargeting
        
        -- Dynamic colors based on danger level
        local dangerLevel = 0
        if isTargeting then
            if distance <= Config.MinDistance then
                dangerLevel = 3 -- CRITICAL
            elseif distance <= Config.BaseDistance then
                dangerLevel = 2 -- DANGER
            elseif distance <= Config.BaseDistance + 15 then
                dangerLevel = 1 -- WARNING
            end
        end
        
        local colors = {
            [0] = {fill = Color3.fromRGB(100, 200, 100), stroke = Color3.fromRGB(150, 255, 150), status = "SAFE"},
            [1] = {fill = Color3.fromRGB(255, 200, 50), stroke = Color3.fromRGB(255, 220, 100), status = "WARNING"},
            [2] = {fill = Color3.fromRGB(255, 100, 50), stroke = Color3.fromRGB(255, 150, 100), status = "DANGER"},
            [3] = {fill = Color3.fromRGB(255, 50, 50), stroke = Color3.fromRGB(255, 100, 100), status = "PARRY NOW"}
        }
        
        local colorData = colors[dangerLevel]
        
        highlight.FillColor = colorData.fill
        highlight.OutlineColor = colorData.stroke
        stroke.Color = colorData.stroke
        
        statusLabel.Text = colorData.status
        statusLabel.TextColor3 = colorData.stroke
        
        infoLabel.Text = string.format("Distance: %.1f\nSpeed: %.0f\n%s", 
            distance, speed, IsClashing and "⚔️ CLASHING" or (isTargeting and "🎯 Targeting" or ""))
        
        -- Update trajectory
        if trajectoryPart and Config.TrajectoryLine and speed > 10 then
            local futurePos = ball.Position + ballData.Velocity * 0.3
            local midPoint = (ball.Position + futurePos) / 2
            local length = (ball.Position - futurePos).Magnitude
            
            trajectoryPart.Size = Vector3.new(0.2, 0.2, length)
            trajectoryPart.CFrame = CFrame.new(midPoint, futurePos)
            trajectoryPart.Color = colorData.fill
            trajectoryPart.Transparency = 0.4
        elseif trajectoryPart then
            trajectoryPart.Transparency = 1
        end
    end)
    
    table.insert(ESPObjects[ball], updateConn)
    
    ball.Destroying:Connect(function()
        updateConn:Disconnect()
        if ESPObjects[ball] then
            for _, obj in pairs(ESPObjects[ball]) do
                if typeof(obj) == "RBXScriptConnection" then
                    obj:Disconnect()
                else
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- AUTO PLAY SYSTEM
-- ════════════════════════════════════════════════════════════════════════════════

local AutoPlayConn = nil

local function StartAutoPlay()
    if AutoPlayConn then AutoPlayConn:Disconnect() end
    if not Config.AutoPlay then return end
    
    local angle = 0
    
    AutoPlayConn = RunService.Heartbeat:Connect(function()
        if not Config.AutoPlay or not Humanoid or not CurrentBall then return end
        
        local ballData = CalculateBallData(CurrentBall)
        if not ballData then return end
        
        local ballPos = CurrentBall.Position
        local distance = ballData.Distance
        
        if Config.PlayStyle == "Aggressive" then
            -- Stay close to ball, ready to parry
            if distance > Config.BaseDistance + 5 then
                Humanoid:MoveTo(ballPos)
            else
                angle = angle + 0.04
                local offset = Vector3.new(math.cos(angle) * 12, 0, math.sin(angle) * 12)
                Humanoid:MoveTo(ballPos + offset)
            end
            
        elseif Config.PlayStyle == "Defensive" then
            -- Keep distance, only approach when needed
            if ballData.IsTargeting and distance > Config.BaseDistance + 10 then
                Humanoid:MoveTo(ballPos)
            elseif not ballData.IsTargeting then
                angle = angle + 0.02
                local offset = Vector3.new(math.cos(angle) * 25, 0, math.sin(angle) * 25)
                Humanoid:MoveTo(ballPos + offset)
            end
            
        elseif Config.PlayStyle == "Balanced" then
            angle = angle + 0.03
            local radius = ballData.IsTargeting and 15 or 20
            local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            Humanoid:MoveTo(ballPos + offset)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- BEAUTIFUL GUI
-- ════════════════════════════════════════════════════════════════════════════════

-- Color Palette
local Colors = {
    Background = Color3.fromRGB(12, 12, 18),
    Surface = Color3.fromRGB(22, 22, 30),
    SurfaceLight = Color3.fromRGB(32, 32, 42),
    Primary = Color3.fromRGB(139, 92, 246), -- Purple
    PrimaryDark = Color3.fromRGB(109, 62, 216),
    Accent = Color3.fromRGB(236, 72, 153), -- Pink
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(250, 204, 21),
    Danger = Color3.fromRGB(239, 68, 68),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(156, 163, 175),
    Border = Color3.fromRGB(55, 55, 70)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusProGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end
end)

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -220)
MainFrame.Size = UDim2.new(0, 480, 0, 440)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Colors.Border
MainStroke.Thickness = 1

-- Gradient Background Effect
local GradientFrame = Instance.new("Frame")
GradientFrame.Parent = MainFrame
GradientFrame.Size = UDim2.new(1, 0, 0, 100)
GradientFrame.BackgroundColor3 = Colors.Primary
GradientFrame.BackgroundTransparency = 0.85
GradientFrame.BorderSizePixel = 0

local GradientCorner = Instance.new("UICorner")
GradientCorner.CornerRadius = UDim.new(0, 16)
GradientCorner.Parent = GradientFrame

local Gradient = Instance.new("UIGradient")
Gradient.Parent = GradientFrame
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.Primary),
    ColorSequenceKeypoint.new(1, Colors.Accent)
})
Gradient.Rotation = 45
Gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 1)
})

-- Header
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.BackgroundTransparency = 1
Header.Size = UDim2.new(1, 0, 0, 60)

local Logo = Instance.new("TextLabel")
Logo.Parent = Header
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 20, 0, 10)
Logo.Size = UDim2.new(0, 200, 0, 25)
Logo.Font = Enum.Font.GothamBold
Logo.Text = "⚔️ NEXUS PRO"
Logo.TextColor3 = Colors.Text
Logo.TextSize = 20
Logo.TextXAlignment = Enum.TextXAlignment.Left

local Version = Instance.new("TextLabel")
Version.Parent = Header
Version.BackgroundTransparency = 1
Version.Position = UDim2.new(0, 20, 0, 35)
Version.Size = UDim2.new(0, 200, 0, 15)
Logo.Font = Enum.Font.Gotham
Version.Text = "v4.0 Competitive Edition"
Version.TextColor3 = Colors.TextDim
Version.TextSize = 11
Version.TextXAlignment = Enum.TextXAlignment.Left

-- Stats Display
local StatsFrame = Instance.new("Frame")
StatsFrame.Parent = Header
StatsFrame.BackgroundColor3 = Colors.Surface
StatsFrame.Position = UDim2.new(1, -160, 0, 15)
StatsFrame.Size = UDim2.new(0, 140, 0, 35)

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

local ParryCountLabel = Instance.new("TextLabel")
ParryCountLabel.Parent = StatsFrame
ParryCountLabel.BackgroundTransparency = 1
ParryCountLabel.Size = UDim2.new(1, 0, 1, 0)
ParryCountLabel.Font = Enum.Font.GothamBold
ParryCountLabel.Text = "Parries: 0"
ParryCountLabel.TextColor3 = Colors.Success
ParryCountLabel.TextSize = 14

-- Update parry count
task.spawn(function()
    while wait(0.5) do
        if ParryCountLabel and ParryCountLabel.Parent then
            ParryCountLabel.Text = "Parries: " .. ParryCount
        end
    end
end)

-- Close & Minimize Buttons
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Colors.Danger
CloseBtn.Position = UDim2.new(1, -45, 0, 15)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Colors.Text
CloseBtn.TextSize = 20

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = Header
MinBtn.BackgroundColor3 = Colors.Warning
MinBtn.Position = UDim2.new(1, -80, 0, 15)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "−"
MinBtn.TextColor3 = Colors.Background
MinBtn.TextSize = 20

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 8)
MinBtnCorner.Parent = MinBtn

-- Tab System
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Colors.Surface
TabBar.Position = UDim2.new(0, 15, 0, 65)
TabBar.Size = UDim2.new(1, -30, 0, 40)

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 10)
TabBarCorner.Parent = TabBar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabBar
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0, 5)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabBar
TabPadding.PaddingLeft = UDim.new(0, 5)
TabPadding.PaddingTop = UDim.new(0, 5)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 15, 0, 115)
ContentArea.Size = UDim2.new(1, -30, 1, -125)

local Pages = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    local tab = Instance.new("TextButton")
    tab.Parent = TabBar
    tab.BackgroundColor3 = Colors.SurfaceLight
    tab.Size = UDim2.new(0, 85, 0, 30)
    tab.Font = Enum.Font.Gotham
    tab.Text = icon .. " " .. name
    tab.TextColor3 = Colors.TextDim
    tab.TextSize = 12
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tab
    
    local page = Instance.new("ScrollingFrame")
    page.Parent = ContentArea
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Colors.Primary
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.Padding = UDim.new(0, 10)
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.Parent = page
    pagePadding.PaddingTop = UDim.new(0, 5)
    pagePadding.PaddingRight = UDim.new(0, 10)
    
    Pages[name] = {Tab = tab, Page = page}
    
    tab.MouseButton1Click:Connect(function()
        for _, data in pairs(Pages) do
            data.Page.Visible = false
            data.Tab.BackgroundColor3 = Colors.SurfaceLight
            data.Tab.TextColor3 = Colors.TextDim
        end
        page.Visible = true
        tab.BackgroundColor3 = Colors.Primary
        tab.TextColor3 = Colors.Text
        CurrentTab = name
    end)
    
    return page
end

-- UI Element Creators
local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Parent = parent
    section.BackgroundColor3 = Colors.Surface
    section.Size = UDim2.new(1, 0, 0, 30)
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionGradient = Instance.new("UIGradient")
    sectionGradient.Parent = section
    sectionGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.Primary),
        ColorSequenceKeypoint.new(1, Colors.Accent)
    })
    sectionGradient.Transparency = NumberSequence.new(0.85)
    
    local label = Instance.new("TextLabel")
    label.Parent = section
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -12, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = title
    label.TextColor3 = Colors.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(parent, name, configKey, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Colors.Surface
    frame.Size = UDim2.new(1, 0, 0, 45)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Parent = frame
    toggleBg.BackgroundColor3 = Config[configKey] and Colors.Primary or Colors.SurfaceLight
    toggleBg.Position = UDim2.new(1, -60, 0.5, -12)
    toggleBg.Size = UDim2.new(0, 48, 0, 24)
    
    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(1, 0)
    toggleBgCorner.Parent = toggleBg
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Parent = toggleBg
    toggleCircle.BackgroundColor3 = Colors.Text
    toggleCircle.Position = Config[configKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    
    local toggleCircleCorner = Instance.new("UICorner")
    toggleCircleCorner.CornerRadius = UDim.new(1, 0)
    toggleCircleCorner.Parent = toggleCircle
    
    local button = Instance.new("TextButton")
    button.Parent = frame
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    
    button.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        
        local targetPos = Config[configKey] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        local targetColor = Config[configKey] and Colors.Primary or Colors.SurfaceLight
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        
        if callback then callback(Config[configKey]) end
    end)
end

local function CreateSlider(parent, name, configKey, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Colors.Surface
    frame.Size = UDim2.new(1, 0, 0, 55)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 15, 0, 8)
    label.Size = UDim2.new(1, -80, 0, 18)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(1, -65, 0, 8)
    valueLabel.Size = UDim2.new(0, 50, 0, 18)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(Config[configKey])
    valueLabel.TextColor3 = Colors.Primary
    valueLabel.TextSize = 14
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.BackgroundColor3 = Colors.SurfaceLight
    sliderBg.Position = UDim2.new(0, 15, 0, 35)
    sliderBg.Size = UDim2.new(1, -30, 0, 8)
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    sliderFillCorner.Parent = sliderFill
    
    local sliderGradient = Instance.new("UIGradient")
    sliderGradient.Parent = sliderFill
    sliderGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.Primary),
        ColorSequenceKeypoint.new(1, Colors.Accent)
    })
    
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local newValue = math.floor(min + (max - min) * value * 10) / 10
            
            Config[configKey] = newValue
            valueLabel.Text = tostring(newValue)
            sliderFill.Size = UDim2.new(value, 0, 1, 0)
            if callback then callback(newValue) end
        end
    end)
end

local function CreateDropdown(parent, name, configKey, options, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Colors.Surface
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.ClipsDescendants = true
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 15, 0, 0)
    label.Size = UDim2.new(0.5, -15, 0, 45)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Colors.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Parent = frame
    dropBtn.BackgroundColor3 = Colors.SurfaceLight
    dropBtn.Position = UDim2.new(0.5, 0, 0, 8)
    dropBtn.Size = UDim2.new(0.5, -15, 0, 30)
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.Text = Config[configKey] .. " ▼"
    dropBtn.TextColor3 = Colors.Text
    dropBtn.TextSize = 12
    
    local dropBtnCorner = Instance.new("UICorner")
    dropBtnCorner.CornerRadius = UDim.new(0, 6)
    dropBtnCorner.Parent = dropBtn
    
    local expanded = false
    
    dropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        
        if expanded then
            frame.Size = UDim2.new(1, 0, 0, 45 + (#options * 30))
            
            for i, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Name = "Opt_" .. option
                optBtn.Parent = frame
                optBtn.BackgroundColor3 = Colors.SurfaceLight
                optBtn.Position = UDim2.new(0.5, 0, 0, 40 + (i * 28))
                optBtn.Size = UDim2.new(0.5, -15, 0, 26)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = option
                optBtn.TextColor3 = Colors.TextDim
                optBtn.TextSize = 11
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    Config[configKey] = option
                    dropBtn.Text = option .. " ▼"
                    expanded = false
                    frame.Size = UDim2.new(1, 0, 0, 45)
                    
                    for _, child in pairs(frame:GetChildren()) do
                        if child.Name:match("Opt_") then child:Destroy() end
                    end
                    
                    if callback then callback(option) end
                end)
            end
        else
            frame.Size = UDim2.new(1, 0, 0, 45)
            for _, child in pairs(frame:GetChildren()) do
                if child.Name:match("Opt_") then child:Destroy() end
            end
        end
    end)
end

-- Create Tabs
local parryPage = CreateTab("Parry", "⚔️")
local clashPage = CreateTab("Clash", "💥")
local espPage = CreateTab("ESP", "👁️")
local movePage = CreateTab("Move", "🏃")
local miscPage = CreateTab("Misc", "⚙️")

-- PARRY TAB
CreateSection(parryPage, "AUTO PARRY")
CreateToggle(parryPage, "Enable Auto Parry", "AutoParry")
CreateDropdown(parryPage, "Parry Method", "ParryMethod", {"Velocity", "Distance", "Hybrid"})
CreateSlider(parryPage, "Base Distance", "BaseDistance", 5, 30)
CreateSlider(parryPage, "Min Distance", "MinDistance", 1, 10)
CreateSlider(parryPage, "Velocity Multiplier", "VelocityMultiplier", 0.5, 2.0)
CreateSlider(parryPage, "Reaction Delay (ms)", "ReactionTime", 0, 0.2)

-- CLASH TAB
CreateSection(clashPage, "CLASH HANDLING")
CreateToggle(clashPage, "Anti-Clash System", "AntiClash")
CreateToggle(clashPage, "Auto Spam on Clash", "AutoSpamOnClash")
CreateSlider(clashPage, "Clash Detection Range", "ClashDetectionRange", 3, 15)
CreateSlider(clashPage, "Clash Spam Speed", "ClashSpamSpeed", 0.01, 0.2)

CreateSection(clashPage, "MANUAL SPAM")
CreateToggle(clashPage, "Auto Spam", "AutoSpam")
CreateToggle(clashPage, "Smart Spam", "SmartSpam")
CreateSlider(clashPage, "Spam CPS", "SpamCPS", 5, 50)

-- ESP TAB
CreateSection(espPage, "VISUALS")
CreateToggle(espPage, "Ball ESP", "BallESP", function(val)
    if val and CurrentBall then CreateModernESP(CurrentBall) end
end)
CreateToggle(espPage, "Trajectory Line", "TrajectoryLine")
CreateToggle(espPage, "Player ESP", "PlayerESP")
CreateToggle(espPage, "Danger Indicator", "DangerIndicator")

-- MOVEMENT TAB
CreateSection(movePage, "SPEED")
CreateToggle(movePage, "Speed Hack", "SpeedHack", function(val)
    if Humanoid then
        Humanoid.WalkSpeed = val and Config.WalkSpeed or 16
    end
end)
CreateSlider(movePage, "Walk Speed", "WalkSpeed", 16, 150, function(val)
    if Config.SpeedHack and Humanoid then
        Humanoid.WalkSpeed = val
    end
end)

CreateSection(movePage, "AUTO PLAY")
CreateToggle(movePage, "Auto Play", "AutoPlay", StartAutoPlay)
CreateDropdown(movePage, "Play Style", "PlayStyle", {"Aggressive", "Defensive", "Balanced"}, StartAutoPlay)

-- MISC TAB
CreateSection(miscPage, "UTILITY")
CreateToggle(miscPage, "Anti-AFK", "AntiAFK")
CreateToggle(miscPage, "Notifications", "Notifications")
CreateToggle(miscPage, "Debug Mode", "DebugMode")

-- Select first tab
Pages["Parry"].Page.Visible = true
Pages["Parry"].Tab.BackgroundColor3 = Colors.Primary
Pages["Parry"].Tab.TextColor3 = Colors.Text

-- Button Events
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    ContentArea.Visible = not minimized
    TabBar.Visible = not minimized
    MainFrame.Size = minimized and UDim2.new(0, 480, 0, 65) or UDim2.new(0, 480, 0, 440)
end)

-- Toggle GUI
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Config.ToggleKey then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ════════════════════════════════════════════════════════════════════════════════
-- BALL DETECTION & INITIALIZATION
-- ════════════════════════════════════════════════════════════════════════════════

Balls.ChildAdded:Connect(function(ball)
    if ball:IsA("BasePart") then
        CurrentBall = ball
        task.wait(0.1)
        StartParrySystem(ball)
        CreateModernESP(ball)
        DebugPrint("New ball detected!")
    end
end)

for _, ball in pairs(Balls:GetChildren()) do
    if ball:IsA("BasePart") then
        CurrentBall = ball
        StartParrySystem(ball)
        CreateModernESP(ball)
    end
end

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    task.wait(1)
    
    if Config.SpeedHack then
        Humanoid.WalkSpeed = Config.WalkSpeed
    end
    
    StartAutoPlay()
    
    for _, ball in pairs(Balls:GetChildren()) do
        if ball:IsA("BasePart") then
            CurrentBall = ball
            StartParrySystem(ball)
            CreateModernESP(ball)
        end
    end
end)

-- Anti-AFK
if Config.AntiAFK then
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ════════════════════════════════════════════════════════════════════════════════
-- STARTUP
-- ════════════════════════════════════════════════════════════════════════════════

StartAutoPlay()

Notify("⚔️ NEXUS PRO", "v4.0 Loaded! Press RightShift to toggle", 5)

print([[
╔══════════════════════════════════════════════════════════════════════════════════╗
║                         NEXUS PRO v4.0 - LOADED                                  ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║  ⚔️  Auto Parry: Velocity-based prediction system                               ║
║  💥  Anti-Clash: Automatic spam when clashing detected                          ║
║  👁️  ESP: Modern visuals with trajectory prediction                             ║
║  🏃  Movement: Speed hack & auto play                                           ║
╠══════════════════════════════════════════════════════════════════════════════════╣
║  Press RightShift to toggle GUI                                                  ║
║  Enable Debug Mode to see parry logs                                             ║
╚══════════════════════════════════════════════════════════════════════════════════╝
]])
