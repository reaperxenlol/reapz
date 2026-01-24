-- Murder Mystery 2 Exploit Script (Enhanced)
-- Features: AutoFarm, ESP, Teleport, Shaders, Coin Farm, Shoot Murderer, Noclip, Fling & More

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

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
local GodModeEnabled = false
local ESPObjects = {}
local RainEnabled = false
local SnowEnabled = false

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2ExploitGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame (Better Design)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 380, 0, 420)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "Shadow"
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0, -15, 0, -15)
MainShadow.Size = UDim2.new(1, 30, 1, 30)
MainShadow.ZIndex = 0
MainShadow.Image = "rbxasset://textures/ui/Controls/shadow.png"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.5
MainShadow.ScaleType = Enum.ScaleType.Slice
MainShadow.SliceCenter = Rect.new(10, 10, 118, 118)
MainShadow.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- Title Bar (Better Design)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
}
TitleGradient.Rotation = 90
TitleGradient.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔪 MM2 EXPLOIT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
MinimizeButton.Position = UDim2.new(1, -63, 0, 3.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -32, 0, 3.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Minimized Button (Draggable)
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Size = UDim2.new(0, 50, 0, 50)
MinimizedButton.Position = UDim2.new(0, 10, 0, 10)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
MinimizedButton.Text = "🔪"
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.TextSize = 24
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Visible = false
MinimizedButton.Active = true
MinimizedButton.Draggable = true
MinimizedButton.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(1, 0)
MinimizedCorner.Parent = MinimizedButton

local MinimizedGradient = Instance.new("UIGradient")
MinimizedGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
}
MinimizedGradient.Rotation = 45
MinimizedGradient.Parent = MinimizedButton

-- Minimize/Maximize functionality
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedButton.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedButton.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -16, 0, 35)
TabContainer.Position = UDim2.new(0, 8, 0, 43)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabButtons = {}
local tabFrames = {}
local currentTab = nil

local function CreateTab(name, icon)
    local tabIndex = #tabButtons + 1
    
    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(0.25, -4, 1, 0)
    TabButton.Position = UDim2.new(0.25 * (tabIndex - 1), 2 * (tabIndex - 1), 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 12
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    -- Tab Content Frame
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = name .. "Frame"
    TabFrame.Size = UDim2.new(1, -16, 1, -90)
    TabFrame.Position = UDim2.new(0, 8, 0, 86)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 4
    TabFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    TabFrame.Visible = false
    TabFrame.Parent = MainFrame
    
    tabButtons[tabIndex] = TabButton
    tabFrames[tabIndex] = {frame = TabFrame, yOffset = 5}
    
    TabButton.MouseButton1Click:Connect(function()
        for i, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabFrames[i].frame.Visible = false
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabFrame.Visible = true
        currentTab = tabIndex
    end)
    
    return TabFrame, tabFrames[tabIndex]
end

-- Create Tabs
local MainTab, MainTabData = CreateTab("Main", "🏠")
local MoveTab, MoveTabData = CreateTab("Move", "⚡")
local ShaderTab, ShaderTabData = CreateTab("Shader", "🌈")
local MiscTab, MiscTabData = CreateTab("Misc", "⚙️")

-- Activate first tab
tabButtons[1]:Fire("MouseButton1Click")

-- Function to create buttons
local function CreateButton(text, callback, tabData)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -8, 0, 32)
    Button.Position = UDim2.new(0, 4, 0, tabData.yOffset)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = tabData.frame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 55))
    }
    ButtonGradient.Rotation = 90
    ButtonGradient.Parent = Button
    
    Button.MouseButton1Click:Connect(callback)
    
    tabData.yOffset = tabData.yOffset + 37
    return Button
end

local function CreateToggle(text, callback, tabData)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -8, 0, 32)
    ToggleFrame.Position = UDim2.new(0, 4, 0, tabData.yOffset)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    ToggleFrame.Parent = tabData.frame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleGradient = Instance.new("UIGradient")
    ToggleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 55))
    }
    ToggleGradient.Rotation = 90
    ToggleGradient.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.GothamSemibold
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 22)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 10
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(0, 11)
    ToggleButtonCorner.Parent = ToggleButton
    
    local toggled = false
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
            ToggleButton.Text = "ON"
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 80)
            ToggleButton.Text = "OFF"
        end
        callback(toggled)
    end)
    
    tabData.yOffset = tabData.yOffset + 37
    return ToggleButton
end

-- Notification System
local function Notify(title, text)
    spawn(function()
        local NotifFrame = Instance.new("Frame")
        NotifFrame.Size = UDim2.new(0, 280, 0, 70)
        NotifFrame.Position = UDim2.new(1, -290, 1, 0)
        NotifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = ScreenGui
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 8)
        NotifCorner.Parent = NotifFrame
        
        local NotifGradient = Instance.new("UIGradient")
        NotifGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255))
        }
        NotifGradient.Rotation = 45
        NotifGradient.Parent = NotifFrame
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -10, 0, 22)
        NotifTitle.Position = UDim2.new(0, 5, 0, 5)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifTitle.TextSize = 14
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = NotifFrame
        
        local NotifText = Instance.new("TextLabel")
        NotifText.Size = UDim2.new(1, -10, 0, 40)
        NotifText.Position = UDim2.new(0, 5, 0, 27)
        NotifText.BackgroundTransparency = 1
        NotifText.Text = text
        NotifText.TextColor3 = Color3.fromRGB(230, 230, 230)
        NotifText.TextSize = 12
        NotifText.Font = Enum.Font.Gotham
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.TextWrapped = true
        NotifText.Parent = NotifFrame
        
        NotifFrame:TweenPosition(UDim2.new(1, -290, 1, -80), "Out", "Quad", 0.4, true)
        wait(2.5)
        NotifFrame:TweenPosition(UDim2.new(1, -290, 1, 0), "In", "Quad", 0.4, true)
        wait(0.4)
        NotifFrame:Destroy()
    end)
end

-- FIXED ESP and Role Detection
local function GetPlayerRole(player)
    if not player.Character then return "Innocent" end
    
    -- Check for knife in character (Murderer)
    for _, item in pairs(player.Character:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Knife" then
            return "Murderer"
        end
    end
    
    -- Check for gun in character (Sheriff)
    for _, item in pairs(player.Character:GetChildren()) do
        if item:IsA("Tool") and (item.Name == "Gun" or item.Name == "Revolver") then
            return "Sheriff"
        end
    end
    
    -- Check backpack
    if player.Backpack then
        if player.Backpack:FindFirstChild("Knife") then
            return "Murderer"
        end
        if player.Backpack:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Revolver") then
            return "Sheriff"
        end
    end
    
    return "Innocent"
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.Adornee = player.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    local role = GetPlayerRole(player)
    
    if role == "Murderer" then
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    elseif role == "Sheriff" then
        highlight.FillColor = Color3.fromRGB(0, 100, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 100, 255)
    else
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
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
        RemoveESP(player)
        if player ~= LocalPlayer and player.Character and ESPEnabled then
            CreateESP(player)
        end
    end
end

-- Get Murderer
local function GetMurderer()
    for _, player in pairs(Players:GetPlayers()) do
        if GetPlayerRole(player) == "Murderer" then
            return player
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
        if tool and (tool.Name == "Gun" or tool.Name == "Revolver") then
            if tool:FindFirstChild("Shoot") then
                tool.Shoot:FireServer(1, murderer.Character.HumanoidRootPart.Position, "AH")
                Notify("🎯 Shot!", "Shot at " .. murderer.Name)
            end
        end
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

-- God Mode
local function EnableGodMode()
    if not GodModeEnabled then return end
    spawn(function()
        while GodModeEnabled and Humanoid do
            Humanoid.Health = Humanoid.MaxHealth
            wait(0.1)
        end
    end)
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

-- Weather Effects
local RainPart = nil
local SnowPart = nil

local function CreateRain()
    if RainPart then RainPart:Destroy() end
    RainPart = Instance.new("Part")
    RainPart.Size = Vector3.new(200, 1, 200)
    RainPart.Transparency = 1
    RainPart.Anchored = true
    RainPart.CanCollide = false
    RainPart.Parent = Workspace
    
    local ParticleEmitter = Instance.new("ParticleEmitter")
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
    ParticleEmitter.Size = NumberSequence.new(0.1, 0.1)
    ParticleEmitter.Transparency = NumberSequence.new(0.5, 0.8)
    ParticleEmitter.Lifetime = NumberRange.new(3, 5)
    ParticleEmitter.Rate = 100
    ParticleEmitter.Speed = NumberRange.new(50, 50)
    ParticleEmitter.SpreadAngle = Vector2.new(0, 0)
    ParticleEmitter.VelocityInheritance = 0
    ParticleEmitter.Parent = RainPart
    
    spawn(function()
        while RainEnabled and RainPart do
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                RainPart.Position = Character.HumanoidRootPart.Position + Vector3.new(0, 50, 0)
            end
            wait(0.5)
        end
    end)
end

local function CreateSnow()
    if SnowPart then SnowPart:Destroy() end
    SnowPart = Instance.new("Part")
    SnowPart.Size = Vector3.new(200, 1, 200)
    SnowPart.Transparency = 1
    SnowPart.Anchored = true
    SnowPart.CanCollide = false
    SnowPart.Parent = Workspace
    
    local ParticleEmitter = Instance.new("ParticleEmitter")
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    ParticleEmitter.Size = NumberSequence.new(0.3, 0.3)
    ParticleEmitter.Transparency = NumberSequence.new(0.3, 0.7)
    ParticleEmitter.Lifetime = NumberRange.new(5, 8)
    ParticleEmitter.Rate = 50
    ParticleEmitter.Speed = NumberRange.new(5, 10)
    ParticleEmitter.SpreadAngle = Vector2.new(10, 10)
    ParticleEmitter.VelocityInheritance = 0
    ParticleEmitter.Parent = SnowPart
    
    spawn(function()
        while SnowEnabled and SnowPart do
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                SnowPart.Position = Character.HumanoidRootPart.Position + Vector3.new(0, 50, 0)
            end
            wait(0.5)
        end
    end)
end

-- Realistic Sky Setup
local function SetupRealisticSky()
    Lighting.Ambient = Color3.fromRGB(150, 150, 150)
    Lighting.Brightness = 2
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    
    -- Create Sky
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxasset://sky/moon.jpg"
    sky.SkyboxDn = "rbxasset://sky/moon.jpg"
    sky.SkyboxFt = "rbxasset://sky/moon.jpg"
    sky.SkyboxLf = "rbxasset://sky/moon.jpg"
    sky.SkyboxRt = "rbxasset://sky/moon.jpg"
    sky.SkyboxUp = "rbxasset://sky/moon.jpg"
    sky.StarCount = 3000
    sky.SunAngularSize = 21
    sky.MoonAngularSize = 11
    sky.Parent = Lighting
    
    -- Create Atmosphere
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Density = 0.3
    atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 199)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0
    atmosphere.Haze = 0
    atmosphere.Parent = Lighting
    
    Notify("🌤️ Sky", "Realistic sky loaded!")
end

-- Create GUI Elements

-- MAIN TAB
CreateToggle("ESP (Red=Murd, Blue=Sheriff)", function(state)
    ESPEnabled = state
    if state then
        Notify("👁️ ESP", "ESP Enabled!")
        UpdateESP()
    else
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
        Notify("👁️ ESP", "ESP Disabled!")
    end
end, MainTabData)

CreateToggle("Coin Farm", function(state)
    CoinFarmEnabled = state
    if state then
        Notify("💰 Coins", "Coin Farm ON!")
        spawn(function()
            while CoinFarmEnabled do
                pcall(FarmCoins)
                wait(1)
            end
        end)
    else
        Notify("💰 Coins", "Coin Farm OFF!")
    end
end, MainTabData)

CreateButton("Collect All Coins", function()
    Notify("💰 Coins", "Collecting coins!")
    spawn(function() pcall(FarmCoins) end)
end, MainTabData)

CreateButton("Shoot Murderer", function()
    pcall(ShootMurderer)
end, MainTabData)

CreateToggle("Auto Shoot Murderer", function(state)
    ShootMurdererEnabled = state
    if state then
        Notify("🎯 Auto Shoot", "Auto Shoot ON!")
        spawn(function()
            while ShootMurdererEnabled do
                pcall(ShootMurderer)
                wait(0.5)
            end
        end)
    else
        Notify("🎯 Auto Shoot", "Auto Shoot OFF!")
    end
end, MainTabData)

CreateButton("TP to Murderer", function()
    local murderer = GetMurderer()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") and RootPart then
        RootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame
        Notify("📍 TP", "TPed to " .. murderer.Name)
    else
        Notify("❌ Error", "Murderer not found!")
    end
end, MainTabData)

-- MOVE TAB
CreateToggle("Noclip", function(state)
    NoclipEnabled = state
    Notify("👻 Noclip", state and "Noclip ON!" or "Noclip OFF!")
end, MoveTabData)

CreateButton("Speed 100", function()
    if Humanoid then
        Humanoid.WalkSpeed = 100
        Notify("⚡ Speed", "Speed set to 100!")
    end
end, MoveTabData)

CreateButton("Jump 150", function()
    if Humanoid then
        Humanoid.JumpPower = 150
        Notify("🦘 Jump", "Jump set to 150!")
    end
end, MoveTabData)

CreateToggle("Infinite Jump", function(state)
    InfiniteJumpEnabled = state
    Notify("🦘 Inf Jump", state and "Infinite Jump ON!" or "Infinite Jump OFF!")
end, MoveTabData)

CreateToggle("Fling Aura", function(state)
    FlingEnabled = state
    if state then
        Notify("💫 Fling", "Fling Aura ON!")
        spawn(function()
            while FlingEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and RootPart then
                        local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 20 then
                            pcall(function() FlingPlayer(player) end)
                        end
                    end
                end
                wait(1)
            end
        end)
    else
        Notify("💫 Fling", "Fling Aura OFF!")
    end
end, MoveTabData)

-- SHADER TAB
CreateButton("🌤️ Load Realistic Sky", function()
    SetupRealisticSky()
end, ShaderTabData)

CreateToggle("🌧️ Rain", function(state)
    RainEnabled = state
    if state then
        CreateRain()
        Notify("🌧️ Rain", "Rain Enabled!")
    else
        if RainPart then RainPart:Destroy() end
        Notify("🌧️ Rain", "Rain Disabled!")
    end
end, ShaderTabData)

CreateToggle("❄️ Snow", function(state)
    SnowEnabled = state
    if state then
        CreateSnow()
        Notify("❄️ Snow", "Snow Enabled!")
    else
        if SnowPart then SnowPart:Destroy() end
        Notify("❄️ Snow", "Snow Disabled!")
    end
end, ShaderTabData)

CreateButton("☀️ Full Bright", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Notify("☀️ Bright", "Full Bright ON!")
end, ShaderTabData)

CreateButton("🌫️ Remove Fog", function()
    Lighting.FogEnd = 100000
    Notify("🌫️ Fog", "Fog Removed!")
end, ShaderTabData)

-- MISC TAB
CreateToggle("God Mode", function(state)
    GodModeEnabled = state
    if state then
        EnableGodMode()
        Notify("🛡️ God Mode", "God Mode ON!")
    else
        Notify("🛡️ God Mode", "God Mode OFF!")
    end
end, MiscTabData)

CreateButton("TP to Lobby", function()
    if RootPart then
        RootPart.CFrame = CFrame.new(0, 100, 0)
        Notify("📍 TP", "TPed to Lobby!")
    end
end, MiscTabData)

-- RunService Loops
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        pcall(Noclip)
    end
end)

-- ESP Update Loop
spawn(function()
    while wait(2) do
        if ESPEnabled then
            pcall(UpdateESP)
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            wait(1)
            pcall(UpdateESP)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    if GodModeEnabled then
        wait(1)
        EnableGodMode()
    end
end)

-- Load realistic sky on start
SetupRealisticSky()

-- Initial Notification
Notify("🔪 MM2 Exploit", "Loaded Successfully!")
print("MM2 Exploit Script Loaded!")
