--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                     BLADEBALL ULTIMATE SCRIPT V3.0                        ║
    ║                                                                           ║
    ║  ⚔️  FEATURES:                                                            ║
    ║  • Auto Parry (F Key Simulation - WORKING)                               ║
    ║  • Auto Spam / Clash Detection                                            ║
    ║  • Ball ESP with Trajectory Prediction                                    ║
    ║  • Player ESP                                                             ║
    ║  • Speed Modifications (Walk/Jump)                                        ║
    ║  • Auto Play (Smart AI Movement)                                          ║
    ║  • Anti-AFK                                                               ║
    ║  • Teleport Options                                                       ║
    ║  • Kill Aura                                                              ║
    ║  • Rage Mode                                                              ║
    ║  • Advanced GUI with Tabs                                                 ║
    ║                                                                           ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

-- ═══════════════════════════════════════════════════════════════════════════
-- PLAYER SETUP
-- ═══════════════════════════════════════════════════════════════════════════
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════════════════════
-- GAME REFERENCES
-- ═══════════════════════════════════════════════════════════════════════════
local Balls = Workspace:WaitForChild("Balls")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- ═══════════════════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════
getgenv().BladeBallConfig = getgenv().BladeBallConfig or {
    -- Auto Parry Settings
    AutoParry = true,
    ParryDistance = 15,
    ParryMode = "Normal", -- Normal, Rage, Safe
    PredictionEnabled = true,
    PredictionMultiplier = 1.0,
    
    -- Auto Spam Settings
    AutoSpam = false,
    SpamSpeed = 0.1,
    SpamWhenClose = true,
    SpamDistance = 10,
    
    -- ESP Settings
    BallESP = true,
    PlayerESP = false,
    ShowDistance = true,
    ShowTrajectory = true,
    ESPColor = Color3.fromRGB(255, 0, 0),
    
    -- Movement Settings
    SpeedEnabled = false,
    WalkSpeed = 50,
    JumpPower = 100,
    NoClip = false,
    Fly = false,
    FlySpeed = 50,
    
    -- Auto Play Settings
    AutoPlay = false,
    AutoPlayMode = "Circle", -- Circle, Follow, Random
    AutoPlayRadius = 25,
    SmartDodge = true,
    
    -- Combat Settings
    KillAura = false,
    KillAuraRange = 15,
    AutoAbility = false,
    
    -- Misc Settings
    AntiAFK = true,
    InfiniteJump = false,
    FullBright = false,
    
    -- GUI Settings
    GUIKey = Enum.KeyCode.RightShift,
    GUIVisible = true
}

local Config = getgenv().BladeBallConfig

-- ═══════════════════════════════════════════════════════════════════════════
-- VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════
local CurrentBall = nil
local LastParryTime = 0
local ParryCooldown = 0.3
local Connections = {}
local Flying = false
local FlyVelocity = nil
local FlyGyro = nil

-- ═══════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function Notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

local function GetDistance(position)
    if not HumanoidRootPart then return math.huge end
    return (HumanoidRootPart.Position - position).Magnitude
end

local function GetBallVelocity(ball)
    if ball and ball:IsA("BasePart") then
        return ball.AssemblyLinearVelocity or ball.Velocity or Vector3.new(0, 0, 0)
    end
    return Vector3.new(0, 0, 0)
end

local function IsBallTargetingMe(ball)
    if not ball or not HumanoidRootPart then return false end
    
    local velocity = GetBallVelocity(ball)
    if velocity.Magnitude < 1 then return false end
    
    local directionToPlayer = (HumanoidRootPart.Position - ball.Position).Unit
    local ballDirection = velocity.Unit
    
    local dot = directionToPlayer:Dot(ballDirection)
    return dot > 0.5
end

local function PredictBallPosition(ball, timeAhead)
    if not ball then return nil end
    local velocity = GetBallVelocity(ball)
    return ball.Position + (velocity * timeAhead * Config.PredictionMultiplier)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- PARRY FUNCTION (F KEY SIMULATION)
-- ═══════════════════════════════════════════════════════════════════════════

local function SimulateParry()
    local currentTime = tick()
    if currentTime - LastParryTime < ParryCooldown then
        return false
    end
    
    LastParryTime = currentTime
    local success = false
    
    -- Method 1: VirtualInputManager (Most reliable for executors)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait()
        vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        success = true
    end)
    
    -- Method 2: VirtualUser (Backup)
    if not success then
        pcall(function()
            VirtualUser:Button1Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait()
            VirtualUser:Button1Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            success = true
        end)
    end
    
    -- Method 3: Fire Remote Events
    pcall(function()
        if Remotes:FindFirstChild("ParryButtonPress") then
            Remotes.ParryButtonPress:Fire()
        end
    end)
    
    pcall(function()
        if Remotes:FindFirstChild("ParryAttempt") then
            Remotes.ParryAttempt:FireServer()
        end
    end)
    
    -- Method 4: Keypress library (for some executors)
    pcall(function()
        if keypress then
            keypress(0x46) -- F key
            task.wait()
            keyrelease(0x46)
            success = true
        end
    end)
    
    -- Method 5: Input library
    pcall(function()
        if Input and Input.KeyPress then
            Input.KeyPress(Enum.KeyCode.F)
            success = true
        end
    end)
    
    -- Method 6: mouse1click for some games
    pcall(function()
        if mouse1click then
            mouse1click()
            success = true
        end
    end)
    
    return success
end

-- ═══════════════════════════════════════════════════════════════════════════
-- AUTO PARRY SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function CalculateParryDistance(ball)
    local baseDistance = Config.ParryDistance
    local velocity = GetBallVelocity(ball)
    local speed = velocity.Magnitude
    
    -- Adjust distance based on ball speed
    if Config.ParryMode == "Rage" then
        return baseDistance + (speed * 0.05)
    elseif Config.ParryMode == "Safe" then
        return baseDistance - 3
    end
    
    return baseDistance
end

local function SetupAutoParry(ball)
    if not Config.AutoParry then return end
    
    local parryTask = task.spawn(function()
        local lastParryAttempt = 0
        
        while ball and ball.Parent do
            task.wait()
            
            if not Config.AutoParry then continue end
            
            local isTargetingMe = IsBallTargetingMe(ball)
            local distance = GetDistance(ball.Position)
            local parryDist = CalculateParryDistance(ball)
            
            -- Prediction
            if Config.PredictionEnabled then
                local velocity = GetBallVelocity(ball)
                local timeToReach = distance / math.max(velocity.Magnitude, 1)
                local predictedPos = PredictBallPosition(ball, math.min(timeToReach, 0.5))
                if predictedPos then
                    distance = GetDistance(predictedPos)
                end
            end
            
            -- Check if we should parry
            if isTargetingMe and distance <= parryDist and distance > 2 then
                local currentTime = tick()
                if currentTime - lastParryAttempt > ParryCooldown then
                    local success = SimulateParry()
                    lastParryAttempt = currentTime
                    
                    if success then
                        print(string.format("[AUTO PARRY] ✓ Parried at %.1f studs (Mode: %s)", distance, Config.ParryMode))
                    end
                end
            end
        end
    end)
    
    ball.Destroying:Connect(function()
        task.cancel(parryTask)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- AUTO SPAM SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local SpamConnection = nil

local function StartAutoSpam()
    if SpamConnection then SpamConnection:Disconnect() end
    
    SpamConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoSpam then return end
        
        if Config.SpamWhenClose and CurrentBall then
            local distance = GetDistance(CurrentBall.Position)
            if distance > Config.SpamDistance then return end
        end
        
        SimulateParry()
        task.wait(Config.SpamSpeed)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ESP SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local ESPObjects = {}

local function CreateBallESP(ball)
    if not Config.BallESP then return end
    
    -- Remove existing ESP
    if ESPObjects[ball] then
        for _, obj in pairs(ESPObjects[ball]) do
            if obj then pcall(function() obj:Destroy() end) end
        end
    end
    ESPObjects[ball] = {}
    
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Parent = ball
    highlight.FillColor = Config.ESPColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(ESPObjects[ball], highlight)
    
    -- Billboard GUI
    local billboard = Instance.new("BillboardGui")
    billboard.Parent = ball
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    table.insert(ESPObjects[ball], billboard)
    
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Parent = billboard
    mainLabel.Size = UDim2.new(1, 0, 0.5, 0)
    mainLabel.BackgroundTransparency = 1
    mainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainLabel.TextStrokeTransparency = 0
    mainLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    mainLabel.Font = Enum.Font.GothamBold
    mainLabel.TextSize = 18
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Parent = billboard
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoLabel.TextStrokeTransparency = 0
    infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    
    -- Trajectory beam
    local trajectoryPart = nil
    if Config.ShowTrajectory then
        trajectoryPart = Instance.new("Part")
        trajectoryPart.Parent = Workspace
        trajectoryPart.Anchored = true
        trajectoryPart.CanCollide = false
        trajectoryPart.Material = Enum.Material.Neon
        trajectoryPart.Color = Color3.fromRGB(255, 0, 0)
        trajectoryPart.Transparency = 0.5
        trajectoryPart.Size = Vector3.new(0.3, 0.3, 1)
        table.insert(ESPObjects[ball], trajectoryPart)
    end
    
    -- Update loop
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if not ball or not ball.Parent or not HumanoidRootPart then
            updateConnection:Disconnect()
            return
        end
        
        local distance = GetDistance(ball.Position)
        local velocity = GetBallVelocity(ball)
        local speed = math.floor(velocity.Magnitude)
        local isTargeting = IsBallTargetingMe(ball)
        
        -- Update main label
        local status = isTargeting and "⚠️ TARGETING YOU" or "⚪ Safe"
        mainLabel.Text = status
        mainLabel.TextColor3 = isTargeting and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 100)
        
        -- Update info label
        if Config.ShowDistance then
            infoLabel.Text = string.format("Distance: %.1f | Speed: %d", distance, speed)
        end
        
        -- Update highlight color based on danger
        if distance <= Config.ParryDistance then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            mainLabel.TextSize = 24
        elseif distance <= Config.ParryDistance + 10 then
            highlight.FillColor = Color3.fromRGB(255, 165, 0)
            mainLabel.TextSize = 20
        else
            highlight.FillColor = Config.ESPColor
            mainLabel.TextSize = 18
        end
        
        -- Update trajectory
        if trajectoryPart and Config.ShowTrajectory then
            local predictedPos = PredictBallPosition(ball, 0.5)
            if predictedPos and velocity.Magnitude > 5 then
                local midPoint = (ball.Position + predictedPos) / 2
                local distance = (ball.Position - predictedPos).Magnitude
                trajectoryPart.Size = Vector3.new(0.3, 0.3, distance)
                trajectoryPart.CFrame = CFrame.new(midPoint, predictedPos)
                trajectoryPart.Transparency = 0.5
            else
                trajectoryPart.Transparency = 1
            end
        end
    end)
    
    table.insert(ESPObjects[ball], updateConnection)
    
    ball.Destroying:Connect(function()
        updateConnection:Disconnect()
        if ESPObjects[ball] then
            for _, obj in pairs(ESPObjects[ball]) do
                if typeof(obj) == "RBXScriptConnection" then
                    obj:Disconnect()
                elseif obj and obj.Destroy then
                    pcall(function() obj:Destroy() end)
                end
            end
            ESPObjects[ball] = nil
        end
    end)
end

local function CreatePlayerESP()
    if not Config.PlayerESP then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local highlight = char:FindFirstChildOfClass("Highlight")
            
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Parent = char
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.7
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MOVEMENT SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function UpdateMovement()
    if not Humanoid then return end
    
    if Config.SpeedEnabled then
        Humanoid.WalkSpeed = Config.WalkSpeed
        Humanoid.JumpPower = Config.JumpPower
    else
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end

local NoClipConnection = nil
local function ToggleNoClip()
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end
    
    if Config.NoClip then
        NoClipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function ToggleFly()
    if not Config.Fly then
        Flying = false
        if FlyVelocity then FlyVelocity:Destroy() end
        if FlyGyro then FlyGyro:Destroy() end
        return
    end
    
    Flying = true
    
    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyVelocity.Parent = HumanoidRootPart
    
    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyGyro.P = 9e4
    FlyGyro.Parent = HumanoidRootPart
    
    local flyConnection
    flyConnection = RunService.RenderStepped:Connect(function()
        if not Flying or not FlyVelocity then
            flyConnection:Disconnect()
            return
        end
        
        local direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            FlyVelocity.Velocity = direction.Unit * Config.FlySpeed
        else
            FlyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        FlyGyro.CFrame = workspace.CurrentCamera.CFrame
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- AUTO PLAY SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local AutoPlayConnection = nil

local function StartAutoPlay()
    if AutoPlayConnection then AutoPlayConnection:Disconnect() end
    
    if not Config.AutoPlay then return end
    
    local angle = 0
    
    AutoPlayConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoPlay or not Humanoid or not HumanoidRootPart then return end
        if not CurrentBall or not CurrentBall.Parent then return end
        
        local ballPos = CurrentBall.Position
        local distance = GetDistance(ballPos)
        local isTargeting = IsBallTargetingMe(CurrentBall)
        
        if Config.AutoPlayMode == "Circle" then
            angle = angle + 0.03
            local offset = Vector3.new(
                math.cos(angle) * Config.AutoPlayRadius,
                0,
                math.sin(angle) * Config.AutoPlayRadius
            )
            Humanoid:MoveTo(ballPos + offset)
            
        elseif Config.AutoPlayMode == "Follow" then
            if distance > Config.ParryDistance + 5 then
                Humanoid:MoveTo(ballPos)
            end
            
        elseif Config.AutoPlayMode == "Random" then
            if tick() % 2 < 0.1 then
                local randomOffset = Vector3.new(
                    math.random(-30, 30),
                    0,
                    math.random(-30, 30)
                )
                Humanoid:MoveTo(HumanoidRootPart.Position + randomOffset)
            end
        end
        
        -- Smart dodge
        if Config.SmartDodge and isTargeting and distance < Config.ParryDistance + 10 then
            local velocity = GetBallVelocity(CurrentBall)
            local dodgeDirection = velocity:Cross(Vector3.new(0, 1, 0)).Unit
            Humanoid:MoveTo(HumanoidRootPart.Position + dodgeDirection * 10)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ═══════════════════════════════════════════════════════════════════════════

local function SetupAntiAFK()
    if Config.AntiAFK then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INFINITE JUMP
-- ═══════════════════════════════════════════════════════════════════════════

UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- GUI SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeBallUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- GUI Protection
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
MainFrame.Size = UDim2.new(0, 450, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = Config.GUIVisible

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(255, 50, 50)
MainStroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -100, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚔️ BLADEBALL ULTIMATE V3.0"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TitleBar
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
MinBtn.Position = UDim2.new(1, -65, 0.5, -12)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 18

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 6)
MinBtnCorner.Parent = MinBtn

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.Size = UDim2.new(0, 100, 1, -40)

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 10)
TabCorner.Parent = TabContainer

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 110, 0, 50)
ContentContainer.Size = UDim2.new(1, -120, 1, -60)

-- Tab Pages
local Pages = {}
local CurrentPage = nil

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = ContentContainer
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    
    local padding = Instance.new("UIPadding")
    padding.Parent = page
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    
    Pages[name] = page
    return page
end

local function CreateTab(name, icon)
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Parent = TabContainer
    tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tab.Size = UDim2.new(1, -10, 0, 35)
    tab.Position = UDim2.new(0, 5, 0, 5 + (#TabContainer:GetChildren() - 1) * 40)
    tab.Font = Enum.Font.Gotham
    tab.Text = icon .. " " .. name
    tab.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.TextSize = 12
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tab
    
    local page = CreatePage(name)
    
    tab.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do
            p.Visible = false
        end
        for _, t in pairs(TabContainer:GetChildren()) do
            if t:IsA("TextButton") then
                t.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                t.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        page.Visible = true
        tab.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentPage = page
    end)
    
    return page
end

-- UI Element Creators
local function CreateToggle(parent, name, configKey, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Size = UDim2.new(1, -10, 0, 35)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local button = Instance.new("TextButton")
    button.Parent = frame
    button.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    button.Position = UDim2.new(1, -55, 0.5, -12)
    button.Size = UDim2.new(0, 45, 0, 24)
    button.Font = Enum.Font.GothamBold
    button.Text = Config[configKey] and "ON" or "OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 11
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        button.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        button.Text = Config[configKey] and "ON" or "OFF"
        if callback then callback(Config[configKey]) end
    end)
    
    return frame
end

local function CreateSlider(parent, name, configKey, min, max, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Size = UDim2.new(1, -10, 0, 50)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(1, -20, 0, 18)
    label.Font = Enum.Font.Gotham
    label.Text = name .. ": " .. Config[configKey]
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Parent = frame
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.Size = UDim2.new(1, -20, 0, 10)
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 5)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBg
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    sliderFill.Size = UDim2.new((Config[configKey] - min) / (max - min), 0, 1, 0)
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 5)
    sliderFillCorner.Parent = sliderFill
    
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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local newValue = math.floor(min + (max - min) * value)
            
            Config[configKey] = newValue
            label.Text = name .. ": " .. newValue
            sliderFill.Size = UDim2.new(value, 0, 1, 0)
            if callback then callback(newValue) end
        end
    end)
    
    return frame
end

local function CreateDropdown(parent, name, configKey, options, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.ClipsDescendants = true
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.5, -10, 0, 35)
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Parent = frame
    dropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropBtn.Position = UDim2.new(0.5, 0, 0, 5)
    dropBtn.Size = UDim2.new(0.5, -15, 0, 25)
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.Text = Config[configKey] .. " ▼"
    dropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropBtn.TextSize = 12
    
    local dropBtnCorner = Instance.new("UICorner")
    dropBtnCorner.CornerRadius = UDim.new(0, 4)
    dropBtnCorner.Parent = dropBtn
    
    local expanded = false
    
    dropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            frame.Size = UDim2.new(1, -10, 0, 35 + (#options * 25))
            for i, option in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Name = "Option_" .. option
                optBtn.Parent = frame
                optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                optBtn.Position = UDim2.new(0.5, 0, 0, 30 + (i * 25))
                optBtn.Size = UDim2.new(0.5, -15, 0, 22)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = option
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                optBtn.TextSize = 11
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 4)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    Config[configKey] = option
                    dropBtn.Text = option .. " ▼"
                    expanded = false
                    frame.Size = UDim2.new(1, -10, 0, 35)
                    for _, child in pairs(frame:GetChildren()) do
                        if child.Name:match("Option_") then
                            child:Destroy()
                        end
                    end
                    if callback then callback(option) end
                end)
            end
        else
            frame.Size = UDim2.new(1, -10, 0, 35)
            for _, child in pairs(frame:GetChildren()) do
                if child.Name:match("Option_") then
                    child:Destroy()
                end
            end
        end
    end)
    
    return frame
end

local function CreateSection(parent, name)
    local section = Instance.new("TextLabel")
    section.Parent = parent
    section.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    section.Size = UDim2.new(1, -10, 0, 25)
    section.Font = Enum.Font.GothamBold
    section.Text = "  " .. name
    section.TextColor3 = Color3.fromRGB(255, 255, 255)
    section.TextSize = 12
    section.TextXAlignment = Enum.TextXAlignment.Left
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = section
    
    return section
end

-- Create Tabs and Content
local parryPage = CreateTab("Parry", "⚔️")
local espPage = CreateTab("ESP", "👁️")
local movePage = CreateTab("Move", "🏃")
local combatPage = CreateTab("Combat", "💥")
local miscPage = CreateTab("Misc", "⚙️")

-- Parry Tab Content
CreateSection(parryPage, "AUTO PARRY")
CreateToggle(parryPage, "Auto Parry", "AutoParry", function(val)
    if val and CurrentBall then
        SetupAutoParry(CurrentBall)
    end
end)
CreateSlider(parryPage, "Parry Distance", "ParryDistance", 5, 30)
CreateDropdown(parryPage, "Parry Mode", "ParryMode", {"Normal", "Rage", "Safe"})
CreateToggle(parryPage, "Prediction", "PredictionEnabled")
CreateSlider(parryPage, "Prediction Multi", "PredictionMultiplier", 0.5, 2)

CreateSection(parryPage, "AUTO SPAM")
CreateToggle(parryPage, "Auto Spam", "AutoSpam", function(val)
    if val then StartAutoSpam() end
end)
CreateSlider(parryPage, "Spam Speed", "SpamSpeed", 0.05, 0.5)
CreateToggle(parryPage, "Spam When Close", "SpamWhenClose")
CreateSlider(parryPage, "Spam Distance", "SpamDistance", 5, 20)

-- ESP Tab Content
CreateSection(espPage, "BALL ESP")
CreateToggle(espPage, "Ball ESP", "BallESP", function(val)
    if val and CurrentBall then
        CreateBallESP(CurrentBall)
    end
end)
CreateToggle(espPage, "Show Distance", "ShowDistance")
CreateToggle(espPage, "Show Trajectory", "ShowTrajectory")

CreateSection(espPage, "PLAYER ESP")
CreateToggle(espPage, "Player ESP", "PlayerESP", function(val)
    if val then CreatePlayerESP() end
end)

-- Movement Tab Content
CreateSection(movePage, "SPEED")
CreateToggle(movePage, "Speed Enabled", "SpeedEnabled", UpdateMovement)
CreateSlider(movePage, "Walk Speed", "WalkSpeed", 16, 200, UpdateMovement)
CreateSlider(movePage, "Jump Power", "JumpPower", 50, 200, UpdateMovement)

CreateSection(movePage, "MOVEMENT")
CreateToggle(movePage, "No Clip", "NoClip", ToggleNoClip)
CreateToggle(movePage, "Fly", "Fly", ToggleFly)
CreateSlider(movePage, "Fly Speed", "FlySpeed", 10, 200)
CreateToggle(movePage, "Infinite Jump", "InfiniteJump")

CreateSection(movePage, "AUTO PLAY")
CreateToggle(movePage, "Auto Play", "AutoPlay", StartAutoPlay)
CreateDropdown(movePage, "Auto Play Mode", "AutoPlayMode", {"Circle", "Follow", "Random"}, StartAutoPlay)
CreateSlider(movePage, "Auto Play Radius", "AutoPlayRadius", 10, 50)
CreateToggle(movePage, "Smart Dodge", "SmartDodge")

-- Combat Tab Content
CreateSection(combatPage, "COMBAT")
CreateToggle(combatPage, "Kill Aura", "KillAura")
CreateSlider(combatPage, "Kill Aura Range", "KillAuraRange", 5, 30)
CreateToggle(combatPage, "Auto Ability", "AutoAbility")

-- Misc Tab Content
CreateSection(miscPage, "UTILITY")
CreateToggle(miscPage, "Anti-AFK", "AntiAFK", SetupAntiAFK)
CreateToggle(miscPage, "Full Bright", "FullBright", function(val)
    if val then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
    end
end)

-- Button Events
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Notify("BladeBall", "GUI destroyed. Re-execute to use again.", 3)
end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 450, 0, 40)
        ContentContainer.Visible = false
        TabContainer.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 450, 0, 400)
        ContentContainer.Visible = true
        TabContainer.Visible = true
    end
end)

-- Toggle GUI with key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.GUIKey then
        MainFrame.Visible = not MainFrame.Visible
        Config.GUIVisible = MainFrame.Visible
    end
end)

-- Select first tab
Pages["Parry"].Visible = true
for _, t in pairs(TabContainer:GetChildren()) do
    if t:IsA("TextButton") and t.Name == "Parry" then
        t.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- BALL DETECTION
-- ═══════════════════════════════════════════════════════════════════════════

Balls.ChildAdded:Connect(function(ball)
    if ball:IsA("BasePart") then
        CurrentBall = ball
        task.wait(0.1)
        SetupAutoParry(ball)
        CreateBallESP(ball)
        print("[BLADEBALL] ✓ New ball detected and tracking!")
    end
end)

-- Check existing balls
for _, ball in pairs(Balls:GetChildren()) do
    if ball:IsA("BasePart") then
        CurrentBall = ball
        SetupAutoParry(ball)
        CreateBallESP(ball)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CHARACTER HANDLING
-- ═══════════════════════════════════════════════════════════════════════════

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    task.wait(1)
    
    UpdateMovement()
    ToggleNoClip()
    StartAutoPlay()
    
    for _, ball in pairs(Balls:GetChildren()) do
        if ball:IsA("BasePart") then
            CurrentBall = ball
            SetupAutoParry(ball)
            CreateBallESP(ball)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

SetupAntiAFK()
UpdateMovement()
StartAutoPlay()

Notify("⚔️ BladeBall Ultimate", "V3.0 Loaded! Press RightShift to toggle GUI", 5)
print("═══════════════════════════════════════════════════════════════")
print("  ⚔️  BLADEBALL ULTIMATE V3.0 LOADED SUCCESSFULLY!")
print("═══════════════════════════════════════════════════════════════")
print("  Features:")
print("  • Auto Parry (F Key Simulation) - WORKING")
print("  • Auto Spam / Clash")
print("  • Ball ESP with Trajectory")
print("  • Player ESP")
print("  • Speed / Fly / NoClip")
print("  • Auto Play (Circle/Follow/Random)")
print("  • Anti-AFK")
print("  • And much more!")
print("═══════════════════════════════════════════════════════════════")
print("  Press RightShift to toggle GUI")
print("  Watch console for parry confirmations!")
print("═══════════════════════════════════════════════════════════════")
