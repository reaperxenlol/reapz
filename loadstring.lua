-- Teen Titans Battlegrounds: Glassmorphic Suite

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player & Camera
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera

-- GUI Creation
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GlassmorphicSuiteGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false -- Make GUI persistent on death

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BackgroundTransparency = 0.4 -- Glassmorphic transparency
    MainFrame.BorderColor3 = Color3.fromRGB(150, 80, 255)
    MainFrame.BorderSizePixel = 1
    MainFrame.Position = UDim2.new(-0.5, 0, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 280, 0, 320)
    MainFrame.Draggable = true
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIBlur = Instance.new("UIBlur") -- Frosted glass effect
    UIBlur.Parent = MainFrame
    UIBlur.Size = 24

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = MainFrame
    TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.BackgroundTransparency = 0.9
    TitleLabel.Size = UDim2.new(1, 0, 0, 35)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "TTB Glass Suite"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 20

    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundTransparency = 1
    TabsFrame.Position = UDim2.new(0, 0, 0, 35)
    TabsFrame.Size = UDim2.new(1, 0, 1, -35)

    return ScreenGui, MainFrame
end

local function CreateButton(parent, text, position)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundTransparency = 0.85
    Button.Position = position
    Button.Size = UDim2.new(0.8, 0, 0, 35)
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(230, 230, 230)
    Button.TextSize = 16
    Button.AnchorPoint = Vector2.new(0.5, 0)
    Button.Position = UDim2.new(0.5, 0, position.Y.Scale, position.Y.Offset)

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Button

    -- 3D Animation on Hover
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, tweenInfo, {BackgroundTransparency = 0.7, Size = UDim2.new(0.85, 0, 0, 40)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, tweenInfo, {BackgroundTransparency = 0.85, Size = UDim2.new(0.8, 0, 0, 35)}):Play()
    end)

    return Button
end

-- Initialize GUI
local GUI, MainFrame = CreateGUI()
local TabsFrame = MainFrame.TabsFrame

-- Toggles
local Toggles = { AutoFarm = false, Aimbot = false, Speed = false, InfiniteJump = false, Reach = false, Shaders = false }

-- Create Buttons
local AutoFarmButton = CreateButton(TabsFrame, "Auto Farm: OFF", UDim2.new(0.5, 0, 0.05, 0))
local AimbotButton = CreateButton(TabsFrame, "Aimbot: OFF", UDim2.new(0.5, 0, 0.20, 0))
local SpeedButton = CreateButton(TabsFrame, "Speed: OFF", UDim2.new(0.5, 0, 0.35, 0))
local JumpButton = CreateButton(TabsFrame, "Infinite Jump: OFF", UDim2.new(0.5, 0, 0.50, 0))
local ReachButton = CreateButton(TabsFrame, "Reach: OFF", UDim2.new(0.5, 0, 0.65, 0))
local ShadersButton = CreateButton(TabsFrame, "Shaders: OFF", UDim2.new(0.5, 0, 0.80, 0))

-- Button Click Logic
local function ToggleFeature(button, featureName)
    Toggles[featureName] = not Toggles[featureName]
    button.Text = featureName .. ": " .. (Toggles[featureName] and "ON" or "OFF")
    local color = Toggles[featureName] and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(230, 230, 230)
    TweenService:Create(button, TweenInfo.new(0.2), {TextColor3 = color}):Play()
end

AutoFarmButton.MouseButton1Click:Connect(function() ToggleFeature(AutoFarmButton, "AutoFarm") end)
AimbotButton.MouseButton1Click:Connect(function() ToggleFeature(AimbotButton, "Aimbot") end)
SpeedButton.MouseButton1Click:Connect(function() ToggleFeature(SpeedButton, "Speed") end)
JumpButton.MouseButton1Click:Connect(function() ToggleFeature(JumpButton, "InfiniteJump") end)
ReachButton.MouseButton1Click:Connect(function() ToggleFeature(ReachButton, "Reach") end)

-- GUI Toggle Button
local ToggleButton = CreateButton(GUI, "Show", UDim2.new(0.02, 0, 0.5, -15))
local guiVisible = false
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
ToggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    local goal = guiVisible and UDim2.new(0.02, 0, 0.5, 0) or UDim2.new(-0.5, 0, 0.5, 0)
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {Position = goal}):Play()
    ToggleButton.Text = guiVisible and "Hide" or "Show"
end)

-- Shaders
local bloom = Instance.new("BloomEffect")
bloom.Parent = Camera
bloom.Enabled = false
ShadersButton.MouseButton1Click:Connect(function()
    Toggles.Shaders = not Toggles.Shaders
    bloom.Enabled = Toggles.Shaders
    ShadersButton.Text = "Shaders: " .. (Toggles.Shaders and "ON" or "OFF")
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = LocalPlayer.Character.HumanoidRootPart

    LocalPlayer.Character.Humanoid.WalkSpeed = Toggles.Speed and 100 or 16
    if Toggles.InfiniteJump then UserInputService.JumpRequest:Connect(function() if Toggles.InfiniteJump then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end

    local nearestEnemy, minDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local dist = (myRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then minDist = dist; nearestEnemy = player end
        end
    end

    if Toggles.Aimbot and nearestEnemy and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, nearestEnemy.Character.HumanoidRootPart.Position)
    end

    if Toggles.AutoFarm then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = player.Character.HumanoidRootPart
                enemyRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
                player.Character.Humanoid.WalkSpeed = 0; player.Character.Humanoid.JumpPower = 0
            end
        end
        if nearestEnemy then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                myRoot.CFrame = CFrame.new(myRoot.Position, nearestEnemy.Character.HumanoidRootPart.Position)
                tool:Activate()
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16; player.Character.Humanoid.JumpPower = 50
            end
        end
    end

    if Toggles.Reach and nearestEnemy and minDist < 50 then
        if LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            game.ReplicatedStorage.DefaultRemotes.Damage:FireServer(nearestEnemy.Character.Humanoid, 20)
        end
    end
end)

-- Initial GUI animation
wait(1)
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.02, 0, 0.5, 0)}):Play()
guiVisible = true
ToggleButton.Text = "Hide"
