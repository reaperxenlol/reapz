-- Teen Titans Battlegrounds: Advanced Suite

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
    ScreenGui.Name = "AdvancedSuiteGUI"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderColor3 = Color3.fromRGB(120, 50, 255)
    MainFrame.BorderSizePixel = 2
    MainFrame.Position = UDim2.new(-0.5, 0, 0.5, -150) -- Start off-screen
    MainFrame.Size = UDim2.new(0, 250, 0, 300)
    MainFrame.Draggable = true
    MainFrame.Active = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = MainFrame
    TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "TTB Advanced Suite"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18

    local UICornerTitle = UICorner:Clone()
    UICornerTitle.Parent = TitleLabel

    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabsFrame.Position = UDim2.new(0, 0, 0, 30)
    TabsFrame.Size = UDim2.new(1, 0, 1, -30)

    return ScreenGui, MainFrame
end

local function CreateButton(parent, text, position)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Button.BorderColor3 = Color3.fromRGB(120, 50, 255)
    Button.BorderSizePixel = 1
    Button.Position = position
    Button.Size = UDim2.new(0.8, 0, 0, 35)
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.TextSize = 16

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = Button

    return Button
end

-- Initialize GUI
local GUI, MainFrame = CreateGUI()
local TabsFrame = MainFrame.TabsFrame

-- Toggles
local Toggles = {
    AutoFarm = false,
    Aimbot = false,
    Speed = false,
    InfiniteJump = false,
    Reach = false,
    Shaders = false
}

-- Auto Farm Button
local AutoFarmButton = CreateButton(TabsFrame, "Auto Farm: OFF", UDim2.new(0.1, 0, 0.05, 0))
AutoFarmButton.MouseButton1Click:Connect(function()
    Toggles.AutoFarm = not Toggles.AutoFarm
    AutoFarmButton.Text = "Auto Farm: " .. (Toggles.AutoFarm and "ON" or "OFF")
    AutoFarmButton.TextColor3 = Toggles.AutoFarm and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(220, 220, 220)
end)

-- Aimbot Button
local AimbotButton = CreateButton(TabsFrame, "Aimbot: OFF", UDim2.new(0.1, 0, 0.20, 0))
AimbotButton.MouseButton1Click:Connect(function()
    Toggles.Aimbot = not Toggles.Aimbot
    AimbotButton.Text = "Aimbot: " .. (Toggles.Aimbot and "ON" or "OFF")
    AimbotButton.TextColor3 = Toggles.Aimbot and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(220, 220, 220)
end)

-- Other Buttons (Speed, Jump, Reach, Shaders, Tokens)
local SpeedButton = CreateButton(TabsFrame, "Speed: OFF", UDim2.new(0.1, 0, 0.35, 0))
local JumpButton = CreateButton(TabsFrame, "Infinite Jump: OFF", UDim2.new(0.1, 0, 0.50, 0))
local ReachButton = CreateButton(TabsFrame, "Reach: OFF", UDim2.new(0.1, 0, 0.65, 0))
local ShadersButton = CreateButton(TabsFrame, "Shaders: OFF", UDim2.new(0.1, 0, 0.80, 0))

-- GUI Toggle
local ToggleButton = CreateButton(GUI, "Show", UDim2.new(0.02, 0, 0.5, -15))
local guiVisible = false
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    local goal = guiVisible and UDim2.new(0.02, 0, 0.5, -150) or UDim2.new(-0.5, 0, 0.5, -150)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {Position = goal}):Play()
    ToggleButton.Text = guiVisible and "Hide" or "Show"
end)

-- Features Logic

-- Shaders
local bloom = Instance.new("BloomEffect")
bloom.Parent = Camera
bloom.Enabled = false
ShadersButton.MouseButton1Click:Connect(function()
    Toggles.Shaders = not Toggles.Shaders
    bloom.Enabled = Toggles.Shaders
    ShadersButton.Text = "Shaders: " .. (Toggles.Shaders and "ON" or "OFF")
end)

-- Speed & Jump
SpeedButton.MouseButton1Click:Connect(function() Toggles.Speed = not Toggles.Speed; SpeedButton.Text = "Speed: " .. (Toggles.Speed and "ON" or "OFF") end)
JumpButton.MouseButton1Click:Connect(function() Toggles.InfiniteJump = not Toggles.InfiniteJump; JumpButton.Text = "Infinite Jump: " .. (Toggles.InfiniteJump and "ON" or "OFF") end)

-- Reach
ReachButton.MouseButton1Click:Connect(function() Toggles.Reach = not Toggles.Reach; ReachButton.Text = "Reach: " .. (Toggles.Reach and "ON" or "OFF") end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = LocalPlayer.Character.HumanoidRootPart

    -- Speed
    LocalPlayer.Character.Humanoid.WalkSpeed = Toggles.Speed and 100 or 16

    -- Infinite Jump
    if Toggles.InfiniteJump then
        UserInputService.JumpRequest:Connect(function() if Toggles.InfiniteJump then LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    end

    -- Find nearest enemy
    local nearestEnemy, minDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health > 0 then
            local dist = (myRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearestEnemy = player
            end
        end
    end

    -- Aimbot
    if Toggles.Aimbot and nearestEnemy and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local enemyRoot = nearestEnemy.Character.HumanoidRootPart
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemyRoot.Position)
    end

    -- Auto Farm
    if Toggles.AutoFarm then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = player.Character.HumanoidRootPart
                enemyRoot.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
                player.Character.Humanoid.WalkSpeed = 0
                player.Character.Humanoid.JumpPower = 0
            end
        end

        if nearestEnemy then
            -- Equip weapon (assumes first tool is weapon)
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                -- Aim and attack
                local enemyRoot = nearestEnemy.Character.HumanoidRootPart
                myRoot.CFrame = CFrame.new(myRoot.Position, enemyRoot.Position)
                tool:Activate() -- Auto-click
            end
        end
    else
        -- Restore players when disabled
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
                player.Character.Humanoid.JumpPower = 50
            end
        end
    end

    -- Reach
    if Toggles.Reach and nearestEnemy and minDist < 50 then -- 50 stud reach
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            game.ReplicatedStorage.DefaultRemotes.Damage:FireServer(nearestEnemy.Character.Humanoid, 20)
        end
    end
end)

-- Initial GUI animation
wait(1)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.02, 0, 0.5, -150)}):Play()
guiVisible = true
ToggleButton.Text = "Hide"
