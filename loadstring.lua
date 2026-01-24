-- Murder Mystery 2 Exploit Script (Built-in GUI)
-- Features: AutoFarm, ESP, Teleport, Notifications, Coin Farm, Shoot Murderer, Noclip, Fling & More

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables
local AutoFarmEnabled = false
local ESPEnabled = false
local CoinFarmEnabled = false
local NoclipEnabled = false
local ShootMurdererEnabled = false
local FlingEnabled = false
local InfiniteJumpEnabled = false
local ESPObjects = {}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2ExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 Exploit Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 6
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
ContentFrame.Parent = MainFrame

-- Function to create buttons
local yOffset = 10

local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 35)
    Button.Position = UDim2.new(0, 5, 0, yOffset)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.Parent = ContentFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    
    yOffset = yOffset + 45
    return Button
end

local function CreateToggle(text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
    ToggleFrame.Position = UDim2.new(0, 5, 0, yOffset)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.Parent = ContentFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 5)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 16
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 25)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(0, 5)
    ToggleButtonCorner.Parent = ToggleButton
    
    local toggled = false
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            ToggleButton.Text = "ON"
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ToggleButton.Text = "OFF"
        end
        callback(toggled)
    end)
    
    yOffset = yOffset + 45
    return ToggleButton
end

local function CreateLabel(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 30)
    Label.Position = UDim2.new(0, 5, 0, yOffset)
    Label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 200, 50)
    Label.TextSize = 18
    Label.Font = Enum.Font.GothamBold
    Label.Parent = ContentFrame
    
    local LabelCorner = Instance.new("UICorner")
    LabelCorner.CornerRadius = UDim.new(0, 5)
    LabelCorner.Parent = Label
    
    yOffset = yOffset + 40
    return Label
end

-- Notification System
local function Notify(title, text)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    NotifFrame.Position = UDim2.new(1, -310, 1, 0)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotifFrame
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -10, 0, 25)
    NotifTitle.Position = UDim2.new(0, 5, 0, 5)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
    NotifTitle.TextSize = 16
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotifFrame
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -10, 0, 45)
    NotifText.Position = UDim2.new(0, 5, 0, 30)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextWrapped = true
    NotifText.Parent = NotifFrame
    
    NotifFrame:TweenPosition(UDim2.new(1, -310, 1, -90), "Out", "Quad", 0.5, true)
    
    wait(3)
    
    NotifFrame:TweenPosition(UDim2.new(1, -310, 1, 0), "In", "Quad", 0.5, true)
    wait(0.5)
    NotifFrame:Destroy()
end

-- ESP Functions
local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.Adornee = player.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    local role = player.Character:FindFirstChild("Role")
    if role then
        if role.Value == "Murderer" then
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        elseif role.Value == "Sheriff" then
            highlight.FillColor = Color3.fromRGB(0, 0, 255)
            highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
        else
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
        end
    else
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
    
    ESPObjects[player] = highlight
end

local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and ESPEnabled then
            if not ESPObjects[player] then
                CreateESP(player)
            end
        else
            RemoveESP(player)
        end
    end
end

-- Get Murderer
local function GetMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Role") then
            if player.Character.Role.Value == "Murderer" then
                return player
            end
        end
    end
    return nil
end

-- Coin Farm
local function FarmCoins()
    for _, coin in pairs(Workspace:GetDescendants()) do
        if coin.Name == "Coin" or coin.Name == "CoinContainer" then
            if coin:IsA("BasePart") or coin:FindFirstChild("Coin") then
                local coinPart = coin:IsA("BasePart") and coin or coin:FindFirstChild("Coin")
                if coinPart and RootPart then
                    RootPart.CFrame = coinPart.CFrame
                    wait(0.1)
                end
            end
        end
    end
end

-- Shoot Murderer
local function ShootMurderer()
    local murderer = GetMurderer()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Shoot") then
            local args = {
                [1] = 1,
                [2] = murderer.Character.HumanoidRootPart.Position,
                [3] = "AH"
            }
            tool.Shoot:FireServer(unpack(args))
            Notify("Shot Fired!", "Attempted to shoot " .. murderer.Name)
        else
            Notify("Error", "You need the gun!")
        end
    else
        Notify("Error", "Murderer not found!")
    end
end

-- Noclip
local function Noclip()
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end

-- Fling Player
local function FlingPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = targetPlayer.Character.HumanoidRootPart
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
        bodyVelocity.Velocity = Vector3.new(math.random(-100, 100), 100, math.random(-100, 100))
        bodyVelocity.Parent = targetRoot
        
        wait(0.5)
        bodyVelocity:Destroy()
    end
end

-- Create GUI Elements
CreateLabel("=== MAIN FEATURES ===")

CreateToggle("ESP (See Players)", function(state)
    ESPEnabled = state
    if state then
        Notify("ESP", "ESP Enabled!")
        UpdateESP()
    else
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
        Notify("ESP", "ESP Disabled!")
    end
end)

CreateToggle("Auto Farm Coins", function(state)
    CoinFarmEnabled = state
    if state then
        Notify("Coin Farm", "Coin Farm Enabled!")
        spawn(function()
            while CoinFarmEnabled do
                pcall(function()
                    FarmCoins()
                end)
                wait(1)
            end
        end)
    else
        Notify("Coin Farm", "Coin Farm Disabled!")
    end
end)

CreateButton("Collect All Coins", function()
    Notify("Coins", "Collecting all coins!")
    spawn(function()
        pcall(function()
            FarmCoins()
        end)
    end)
end)

CreateButton("Shoot Murderer", function()
    pcall(function()
        ShootMurderer()
    end)
end)

CreateToggle("Auto Shoot Murderer", function(state)
    ShootMurdererEnabled = state
    if state then
        Notify("Auto Shoot", "Auto Shoot Enabled!")
        spawn(function()
            while ShootMurdererEnabled do
                pcall(function()
                    ShootMurderer()
                end)
                wait(0.5)
            end
        end)
    else
        Notify("Auto Shoot", "Auto Shoot Disabled!")
    end
end)

CreateLabel("=== MOVEMENT ===")

CreateToggle("Noclip", function(state)
    NoclipEnabled = state
    if state then
        Notify("Noclip", "Noclip Enabled!")
    else
        Notify("Noclip", "Noclip Disabled!")
    end
end)

CreateButton("Speed: 100", function()
    if Humanoid then
        Humanoid.WalkSpeed = 100
        Notify("Speed", "Walk Speed set to 100!")
    end
end)

CreateButton("Jump: 150", function()
    if Humanoid then
        Humanoid.JumpPower = 150
        Notify("Jump", "Jump Power set to 150!")
    end
end)

CreateToggle("Infinite Jump", function(state)
    InfiniteJumpEnabled = state
    if state then
        Notify("Infinite Jump", "Infinite Jump Enabled!")
    else
        Notify("Infinite Jump", "Infinite Jump Disabled!")
    end
end)

CreateLabel("=== TELEPORT ===")

CreateButton("TP to Murderer", function()
    local murderer = GetMurderer()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") and RootPart then
        RootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame
        Notify("Teleported", "Teleported to " .. murderer.Name)
    else
        Notify("Error", "Murderer not found!")
    end
end)

CreateButton("TP to Lobby", function()
    if RootPart then
        RootPart.CFrame = CFrame.new(0, 100, 0)
        Notify("Teleported", "Teleported to Lobby!")
    end
end)

CreateLabel("=== FLING ===")

CreateToggle("Fling Aura", function(state)
    FlingEnabled = state
    if state then
        Notify("Fling", "Fling Aura Enabled!")
        spawn(function()
            while FlingEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and RootPart then
                        local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 20 then
                            pcall(function()
                                FlingPlayer(player)
                            end)
                        end
                    end
                end
                wait(1)
            end
        end)
    else
        Notify("Fling", "Fling Aura Disabled!")
    end
end)

CreateLabel("=== MISC ===")

CreateButton("God Mode", function()
    pcall(function()
        Humanoid.Name = "1"
        local newHumanoid = Humanoid:Clone()
        newHumanoid.Parent = Character
        newHumanoid.Name = "Humanoid"
        Workspace.CurrentCamera.CameraSubject = newHumanoid
        Humanoid:Destroy()
        Humanoid = newHumanoid
        Notify("God Mode", "God Mode Attempted!")
    end)
end)

CreateButton("Remove Fog", function()
    game:GetService("Lighting").FogEnd = 100000
    Notify("Fog", "Fog Removed!")
end)

CreateButton("Full Bright", function()
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Notify("Full Bright", "Full Bright Enabled!")
end)

-- RunService Loops
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        pcall(function()
            Noclip()
        end)
    end
    
    if ESPEnabled then
        pcall(function()
            UpdateESP()
        end)
    end
end)

-- Infinite Jump Handler
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if ESPEnabled then
            wait(1)
            pcall(function()
                CreateESP(player)
            end)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Initial Notification
Notify("MM2 Exploit Hub", "Script Loaded Successfully!")
print("MM2 Exploit Script Loaded!")
