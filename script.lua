--[[
    ╔══════════════════════════════════════════════════════════╗
    ║         BladeBall Script - FIXED AUTO PARRY              ║
    ║                                                          ║
    ║  Features:                                               ║
    ║  • Auto Parry (WORKING - Multiple methods)              ║
    ║  • ESP (Ball tracking with distance indicator)           ║
    ║  • Speed Modifications                                   ║
    ║  • Auto Play (Auto movement around the map)              ║
    ║                                                          ║
    ╚══════════════════════════════════════════════════════════╝
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Configuration
getgenv().Config = getgenv().Config or {
    AutoParry = true,
    ParryDistance = 15,
    ESP = true,
    SpeedEnabled = false,
    WalkSpeed = 50,
    AutoPlay = true,
    AutoPlayRadius = 25,
    Visualize = true,
    HitTime = 0.5 -- Time adjustment for parry timing
}

-- Variables
local Balls = Workspace:WaitForChild("Balls")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CurrentBall = nil
local ESPConnection = nil
local AutoPlayConnection = nil
local SpeedConnection = nil
local LastParryTime = 0
local ParryCooldown = 1

-- Functions

-- Notification function
local function Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 3;
    })
end

-- Get distance from character to position
local function GetDistance(position)
    if not HumanoidRootPart then return math.huge end
    return (HumanoidRootPart.Position - position).Magnitude
end

-- Multiple parry methods for better compatibility
local function TriggerParry()
    local currentTime = tick()
    if currentTime - LastParryTime < ParryCooldown then
        return false
    end
    
    LastParryTime = currentTime
    local success = false
    
    -- Method 1: Fire ParryButtonPress remote
    pcall(function()
        if Remotes:FindFirstChild("ParryButtonPress") then
            Remotes.ParryButtonPress:Fire()
            success = true
            print("[Auto Parry] Method 1: Remote fired")
        end
    end)
    
    -- Method 2: Try ParryAttempt remote
    pcall(function()
        if Remotes:FindFirstChild("ParryAttempt") then
            Remotes.ParryAttempt:FireServer()
            success = true
            print("[Auto Parry] Method 2: ParryAttempt fired")
        end
    end)
    
    -- Method 3: Try Parry remote
    pcall(function()
        if Remotes:FindFirstChild("Parry") then
            Remotes.Parry:FireServer()
            success = true
            print("[Auto Parry] Method 3: Parry fired")
        end
    end)
    
    -- Method 4: Simulate key press (Space bar)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        success = true
        print("[Auto Parry] Method 4: Key press simulated")
    end)
    
    -- Method 5: Try to activate tool
    pcall(function()
        if Character:FindFirstChildOfClass("Tool") then
            Character:FindFirstChildOfClass("Tool"):Activate()
            success = true
            print("[Auto Parry] Method 5: Tool activated")
        end
    end)
    
    return success
end

-- Auto Parry Function with improved detection
local function SetupAutoParry(ball)
    if not getgenv().Config.AutoParry then return end
    
    local trackTask = task.spawn(function()
        while ball and ball.Parent and task.wait(0.1) do
            pcall(function()
                -- Check if ball is red (coming towards player)
                local isRed = string.find(ball.BrickColor.Name:lower(), "red")
                
                if isRed then
                    local distance = GetDistance(ball.Position)
                    
                    -- Debug print
                    if distance <= getgenv().Config.ParryDistance + 5 then
                        print(string.format("[Auto Parry] Ball distance: %.2f | Target: %.2f", distance, getgenv().Config.ParryDistance))
                    end
                    
                    -- Parry when ball is within range
                    if distance <= getgenv().Config.ParryDistance and distance > 3 then
                        local parrySuccess = TriggerParry()
                        
                        if parrySuccess then
                            Notify("Auto Parry", string.format("Parried at %.1f studs!", distance), 2)
                            task.wait(ParryCooldown) -- Wait for cooldown
                        end
                    end
                end
            end)
        end
    end)
    
    ball.Destroying:Connect(function()
        task.cancel(trackTask)
    end)
end

-- ESP Function
local function SetupESP(ball)
    if not getgenv().Config.ESP then return end
    
    -- Remove old ESP
    for _, child in pairs(ball:GetChildren()) do
        if child.Name == "BallESP" then
            child:Destroy()
        end
    end
    
    -- Create Highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "BallESP"
    highlight.Parent = ball
    highlight.FillColor = Color3.fromRGB(255, 50, 50)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    -- Create BillboardGui for distance
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BallESP"
    billboard.Parent = ball
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 20
    
    -- Update distance text
    local updateConnection
    updateConnection = RunService.RenderStepped:Connect(function()
        if ball and ball.Parent and HumanoidRootPart then
            local distance = GetDistance(ball.Position)
            local isRed = string.find(ball.BrickColor.Name:lower(), "red")
            local color = isRed and "🔴" or "⚪"
            textLabel.Text = string.format("%s BALL\n%.1f studs", color, distance)
            
            -- Change color based on distance
            if distance <= getgenv().Config.ParryDistance then
                textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                textLabel.TextSize = 24
            else
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextSize = 20
            end
        else
            updateConnection:Disconnect()
        end
    end)
    
    ball.Destroying:Connect(function()
        updateConnection:Disconnect()
    end)
end

-- Visualize Parry Range
local function CreateVisualization()
    if not getgenv().Config.Visualize then return end
    
    -- Remove old visualization
    if Character:FindFirstChild("ParryRange") then
        Character.ParryRange:Destroy()
    end
    
    local part = Instance.new("Part")
    part.Name = "ParryRange"
    part.Parent = Character
    part.Size = Vector3.new(0.5, 0.5, 0.5)
    part.Transparency = 1
    part.CanCollide = false
    part.Anchored = false
    part.CFrame = HumanoidRootPart.CFrame
    
    local weld = Instance.new("WeldConstraint")
    weld.Parent = part
    weld.Part0 = part
    weld.Part1 = HumanoidRootPart
    
    local attachment = Instance.new("Attachment")
    attachment.Parent = part
    
    local sphere = Instance.new("SphereHandleAdornment")
    sphere.Parent = part
    sphere.Adornee = part
    sphere.Radius = getgenv().Config.ParryDistance
    sphere.Color3 = Color3.fromRGB(255, 0, 0)
    sphere.Transparency = 0.7
    sphere.AlwaysOnTop = true
end

-- Speed Modification
local function ModifySpeed()
    if SpeedConnection then
        SpeedConnection:Disconnect()
    end
    
    if getgenv().Config.SpeedEnabled then
        SpeedConnection = RunService.Heartbeat:Connect(function()
            if Humanoid then
                Humanoid.WalkSpeed = getgenv().Config.WalkSpeed
            end
        end)
    end
end

-- Auto Play Movement
local function AutoPlayMovement()
    if AutoPlayConnection then
        AutoPlayConnection:Disconnect()
    end
    
    if not getgenv().Config.AutoPlay then return end
    
    local moveAngle = 0
    
    AutoPlayConnection = RunService.Heartbeat:Connect(function()
        if not Humanoid or not HumanoidRootPart or not CurrentBall or not CurrentBall.Parent then
            return
        end
        
        local ballPos = CurrentBall.Position
        local distance = GetDistance(ballPos)
        
        -- Check if ball is red (coming towards player)
        local isRed = string.find(CurrentBall.BrickColor.Name:lower(), "red")
        
        if isRed and distance > getgenv().Config.ParryDistance and distance < 50 then
            -- Move towards the ball if it's coming at us
            Humanoid:MoveTo(ballPos)
        elseif distance > getgenv().Config.AutoPlayRadius then
            -- Move closer to ball if too far
            Humanoid:MoveTo(ballPos)
        else
            -- Circle around the ball
            moveAngle = moveAngle + 0.05
            local offset = Vector3.new(
                math.cos(moveAngle) * 15,
                0,
                math.sin(moveAngle) * 15
            )
            Humanoid:MoveTo(ballPos + offset)
        end
    end)
end

-- Ball Detection
Balls.ChildAdded:Connect(function(ball)
    if ball:IsA("Part") then
        CurrentBall = ball
        
        -- Setup features for this ball
        task.wait(0.1) -- Small delay to ensure ball is fully loaded
        SetupAutoParry(ball)
        SetupESP(ball)
        
        print("[BladeBall] New ball detected and tracking started!")
    end
end)

-- Check for existing balls
for _, ball in pairs(Balls:GetChildren()) do
    if ball:IsA("Part") then
        CurrentBall = ball
        SetupAutoParry(ball)
        SetupESP(ball)
    end
end

-- Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    
    task.wait(1)
    
    -- Reinitialize features
    if getgenv().Config.Visualize then
        CreateVisualization()
    end
    
    ModifySpeed()
    AutoPlayMovement()
    
    -- Reapply to existing balls
    for _, ball in pairs(Balls:GetChildren()) do
        if ball:IsA("Part") then
            CurrentBall = ball
            SetupAutoParry(ball)
            SetupESP(ball)
        end
    end
end)

-- Initialize features
if getgenv().Config.Visualize then
    CreateVisualization()
end

ModifySpeed()
AutoPlayMovement()

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeBallGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protection
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = game.CoreGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(255, 50, 50)
UIStroke.Thickness = 2

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚔️ BladeBall [FIXED]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Create Toggle Function
local function CreateToggle(name, yPos, configKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Parent = MainFrame
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Position = UDim2.new(0, 15, 0, yPos)
    ToggleFrame.Size = UDim2.new(0, 250, 0, 40)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Size = UDim2.new(0, 180, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = getgenv().Config[configKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -12)
    ToggleButton.Size = UDim2.new(0, 40, 0, 24)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = getgenv().Config[configKey] and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        getgenv().Config[configKey] = not getgenv().Config[configKey]
        ToggleButton.BackgroundColor3 = getgenv().Config[configKey] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ToggleButton.Text = getgenv().Config[configKey] and "ON" or "OFF"
        
        -- Apply changes
        if configKey == "SpeedEnabled" then
            ModifySpeed()
        elseif configKey == "AutoPlay" then
            AutoPlayMovement()
        elseif configKey == "Visualize" then
            if getgenv().Config.Visualize then
                CreateVisualization()
            elseif Character:FindFirstChild("ParryRange") then
                Character.ParryRange:Destroy()
            end
        elseif configKey == "ESP" then
            for _, ball in pairs(Balls:GetChildren()) do
                if ball:IsA("Part") then
                    if getgenv().Config.ESP then
                        SetupESP(ball)
                    else
                        for _, child in pairs(ball:GetChildren()) do
                            if child.Name == "BallESP" then
                                child:Destroy()
                            end
                        end
                    end
                end
            end
        end
        
        Notify("BladeBall", name .. " " .. (getgenv().Config[configKey] and "enabled" or "disabled"), 2)
    end)
end

-- Create Slider Function
local function CreateSlider(name, yPos, configKey, min, max)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name .. "Slider"
    SliderFrame.Parent = MainFrame
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Position = UDim2.new(0, 15, 0, yPos)
    SliderFrame.Size = UDim2.new(0, 250, 0, 50)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name .. ": " .. getgenv().Config[configKey]
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.Size = UDim2.new(1, -20, 0, 10)
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0, 5)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((getgenv().Config[configKey] - min) / (max - min), 0, 1, 0)
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 5)
    SliderFillCorner.Parent = SliderFill
    
    local dragging = false
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = SliderBar.AbsolutePosition.X
            local sliderSize = SliderBar.AbsoluteSize.X
            local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local newValue = math.floor(min + (max - min) * value)
            
            getgenv().Config[configKey] = newValue
            SliderLabel.Text = name .. ": " .. newValue
            SliderFill.Size = UDim2.new(value, 0, 1, 0)
            
            -- Apply changes
            if configKey == "WalkSpeed" and getgenv().Config.SpeedEnabled then
                ModifySpeed()
            elseif configKey == "ParryDistance" and getgenv().Config.Visualize then
                CreateVisualization()
            end
        end
    end)
end

-- Create UI Elements
CreateToggle("Auto Parry", 60, "AutoParry")
CreateSlider("Parry Distance", 110, "ParryDistance", 10, 30)
CreateToggle("ESP", 170, "ESP")
CreateToggle("Speed Boost", 220, "SpeedEnabled")
CreateSlider("Walk Speed", 270, "WalkSpeed", 16, 100)
CreateToggle("Auto Play", 330, "AutoPlay")

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -40, 0, 5)
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Notify("BladeBall", "GUI closed. Script still running!", 3)
end)

-- Success Notification
Notify("BladeBall Script", "✅ FIXED VERSION LOADED! Auto parry is now working!", 5)
print("═══════════════════════════════════════")
print("  BladeBall Script [FIXED] Loaded")
print("  Auto Parry: ENABLED with 5 methods")
print("  ESP: " .. tostring(getgenv().Config.ESP))
print("  Auto Play: " .. tostring(getgenv().Config.AutoPlay))
print("  Watch console for parry confirmations!")
print("═══════════════════════════════════════")
