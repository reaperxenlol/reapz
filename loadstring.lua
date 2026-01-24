-- Teen Titans Battlegrounds Cheat Script (Enhanced)

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local TokenFarmButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")
local JumpButton = Instance.new("TextButton")
local UnlockButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")

-- Properties
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Draggable = true
MainFrame.Active = true

TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TitleLabel.BorderSizePixel = 2
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Teen Titans BG Cheats"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18

TokenFarmButton.Parent = MainFrame
TokenFarmButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TokenFarmButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TokenFarmButton.BorderSizePixel = 1
TokenFarmButton.Position = UDim2.new(0.1, 0, 0.15, 0)
TokenFarmButton.Size = UDim2.new(0.8, 0, 0, 30)
TokenFarmButton.Font = Enum.Font.SourceSans
TokenFarmButton.Text = "Token Farm: OFF"
TokenFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TokenFarmButton.TextSize = 16

SpeedButton.Parent = MainFrame
SpeedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SpeedButton.BorderSizePixel = 1
SpeedButton.Position = UDim2.new(0.1, 0, 0.3, 0)
SpeedButton.Size = UDim2.new(0.8, 0, 0, 30)
SpeedButton.Font = Enum.Font.SourceSans
SpeedButton.Text = "Speed: OFF"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 16

JumpButton.Parent = MainFrame
JumpButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
JumpButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
JumpButton.BorderSizePixel = 1
JumpButton.Position = UDim2.new(0.1, 0, 0.45, 0)
JumpButton.Size = UDim2.new(0.8, 0, 0, 30)
JumpButton.Font = Enum.Font.SourceSans
JumpButton.Text = "Infinite Jump: OFF"
JumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpButton.TextSize = 16

UnlockButton.Parent = MainFrame
UnlockButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
UnlockButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
UnlockButton.BorderSizePixel = 1
UnlockButton.Position = UDim2.new(0.1, 0, 0.6, 0)
UnlockButton.Size = UDim2.new(0.8, 0, 0, 30)
UnlockButton.Font = Enum.Font.SourceSans
UnlockButton.Text = "Add 1M Tokens"
UnlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockButton.TextSize = 16

ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BorderSizePixel = 2
ToggleButton.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleButton.Size = UDim2.new(0, 80, 0, 30)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Toggle GUI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

-- Script Logic
local tokenFarm = false
local speedEnabled = false
local infiniteJump = false
local originalSpeed = 16

local player = game.Players.LocalPlayer

-- Token Farm (Teleport, Freeze, Attack)
TokenFarmButton.MouseButton1Click:Connect(function()
    tokenFarm = not tokenFarm
    if tokenFarm then
        TokenFarmButton.Text = "Token Farm: ON"
        while tokenFarm do
            local playerPos = player.Character.HumanoidRootPart.Position
            for _, enemy in pairs(game.Players:GetPlayers()) do
                if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyRoot = enemy.Character.HumanoidRootPart
                    enemyRoot.CFrame = CFrame.new(playerPos)
                    enemy.Character.Humanoid.WalkSpeed = 0
                    enemy.Character.Humanoid.JumpPower = 0
                    game.ReplicatedStorage.DefaultRemotes.Damage:FireServer(enemy.Character.Humanoid, 25)
                end
            end
            wait(0.2)
        end
    else
        TokenFarmButton.Text = "Token Farm: OFF"
        -- Restore players
        for _, enemy in pairs(game.Players:GetPlayers()) do
            if enemy ~= player and enemy.Character and enemy.Character:FindFirstChild("Humanoid") then
                enemy.Character.Humanoid.WalkSpeed = 16
                enemy.Character.Humanoid.JumpPower = 50
            end
        end
    end
end)

-- Speed
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "Speed: ON"
        player.Character.Humanoid.WalkSpeed = 50
    else
        SpeedButton.Text = "Speed: OFF"
        player.Character.Humanoid.WalkSpeed = originalSpeed
    end
end)

-- Infinite Jump
JumpButton.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    if infiniteJump then
        JumpButton.Text = "Infinite Jump: ON"
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if infiniteJump then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        JumpButton.Text = "Infinite Jump: OFF"
    end
end)

-- Add Tokens (for unlocking characters)
UnlockButton.MouseButton1Click:Connect(function()
    local tokens = player:WaitForChild("leaderstats"):WaitForChild("Tokens")
    tokens.Value = tokens.Value + 1000000
end)

-- Toggle GUI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
