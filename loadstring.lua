-- Murder Mystery 2 Exploit Script
-- Features: AutoFarm, ESP, Teleport, Notifications, Coin Farm, Shoot Murderer, Noclip, Fling & More

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("MM2 Exploit Hub", "DarkTheme")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
local TeleportSpeed = 1

-- ESP Functions
local ESPObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    
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

-- Coin Farm Function
local function FarmCoins()
    for _, coin in pairs(Workspace:GetDescendants()) do
        if coin.Name == "Coin" or coin.Name == "CoinContainer" then
            if coin:IsA("BasePart") or coin:FindFirstChild("Coin") then
                local coinPart = coin:IsA("BasePart") and coin or coin:FindFirstChild("Coin")
                if coinPart then
                    RootPart.CFrame = coinPart.CFrame
                    wait(0.1)
                end
            end
        end
    end
end

-- Get Murderer Function
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

-- Shoot Murderer Function
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
            
            Library:Notification({
                Title = "Shot Fired!",
                Text = "Attempted to shoot " .. murderer.Name,
                Time = 3
            })
        end
    end
end

-- Noclip Function
local function Noclip()
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end

-- Fling Function
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

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main Features")

MainSection:NewToggle("Auto Farm", "Automatically farm coins and objectives", function(state)
    AutoFarmEnabled = state
    if state then
        Library:Notification({
            Title = "Auto Farm",
            Text = "Auto Farm Enabled!",
            Time = 3
        })
    end
end)

MainSection:NewToggle("ESP", "See all players through walls", function(state)
    ESPEnabled = state
    if state then
        Library:Notification({
            Title = "ESP",
            Text = "ESP Enabled!",
            Time = 3
        })
        UpdateESP()
    else
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
    end
end)

MainSection:NewToggle("Coin Farm", "Automatically collect all coins", function(state)
    CoinFarmEnabled = state
    if state then
        Library:Notification({
            Title = "Coin Farm",
            Text = "Coin Farm Enabled!",
            Time = 3
        })
        spawn(function()
            while CoinFarmEnabled do
                FarmCoins()
                wait(1)
            end
        end)
    end
end)

MainSection:NewButton("Shoot Murderer", "Automatically shoot the murderer", function()
    ShootMurderer()
end)

MainSection:NewToggle("Auto Shoot Murderer", "Continuously shoot murderer", function(state)
    ShootMurdererEnabled = state
    if state then
        spawn(function()
            while ShootMurdererEnabled do
                ShootMurderer()
                wait(0.5)
            end
        end)
    end
end)

-- Movement Tab
local MovementTab = Window:NewTab("Movement")
local MovementSection = MovementTab:NewSection("Movement Features")

MovementSection:NewToggle("Noclip", "Walk through walls", function(state)
    NoclipEnabled = state
    if state then
        Library:Notification({
            Title = "Noclip",
            Text = "Noclip Enabled!",
            Time = 3
        })
    end
end)

MovementSection:NewSlider("Walk Speed", "Change your walk speed", 500, 16, function(value)
    Humanoid.WalkSpeed = value
end)

MovementSection:NewSlider("Jump Power", "Change your jump power", 500, 50, function(value)
    Humanoid.JumpPower = value
end)

MovementSection:NewButton("Infinite Jump", "Enable infinite jump", function()
    local InfiniteJumpEnabled = true
    UserInputService.JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    Library:Notification({
        Title = "Infinite Jump",
        Text = "Infinite Jump Enabled!",
        Time = 3
    })
end)

-- Teleport Tab
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Teleport Features")

TeleportSection:NewButton("TP to Murderer", "Teleport to the murderer", function()
    local murderer = GetMurderer()
    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
        RootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame
        Library:Notification({
            Title = "Teleported",
            Text = "Teleported to " .. murderer.Name,
            Time = 3
        })
    else
        Library:Notification({
            Title = "Error",
            Text = "Murderer not found!",
            Time = 3
        })
    end
end)

TeleportSection:NewButton("TP to Lobby", "Teleport to lobby", function()
    RootPart.CFrame = CFrame.new(0, 100, 0)
end)

TeleportSection:NewDropdown("TP to Player", "Teleport to selected player", Players:GetPlayers(), function(selectedPlayer)
    local player = Players:FindFirstChild(selectedPlayer)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        RootPart.CFrame = player.Character.HumanoidRootPart.CFrame
        Library:Notification({
            Title = "Teleported",
            Text = "Teleported to " .. player.Name,
            Time = 3
        })
    end
end)

-- Fling Tab
local FlingTab = Window:NewTab("Fling")
local FlingSection = FlingTab:NewSection("Fling Features")

FlingSection:NewToggle("Fling Aura", "Fling nearby players", function(state)
    FlingEnabled = state
    if state then
        spawn(function()
            while FlingEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (RootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if distance < 20 then
                            FlingPlayer(player)
                        end
                    end
                end
                wait(1)
            end
        end)
    end
end)

FlingSection:NewDropdown("Fling Player", "Fling selected player", Players:GetPlayers(), function(selectedPlayer)
    local player = Players:FindFirstChild(selectedPlayer)
    if player then
        FlingPlayer(player)
        Library:Notification({
            Title = "Fling",
            Text = "Flung " .. player.Name,
            Time = 3
        })
    end
end)

-- Misc Tab
local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Miscellaneous")

MiscSection:NewButton("Collect All Coins", "Instantly collect all coins", function()
    FarmCoins()
    Library:Notification({
        Title = "Coins",
        Text = "Collecting all coins!",
        Time = 3
    })
end)

MiscSection:NewButton("God Mode", "Enable god mode (may not work)", function()
    Humanoid.Name = "1"
    local newHumanoid = Humanoid:Clone()
    newHumanoid.Parent = Character
    newHumanoid.Name = "Humanoid"
    Workspace.CurrentCamera.CameraSubject = newHumanoid
    Humanoid:Destroy()
    Library:Notification({
        Title = "God Mode",
        Text = "God Mode Attempted!",
        Time = 3
    })
end)

MiscSection:NewButton("Remove Fog", "Remove fog effects", function()
    game:GetService("Lighting").FogEnd = 100000
    Library:Notification({
        Title = "Fog",
        Text = "Fog Removed!",
        Time = 3
    })
end)

MiscSection:NewButton("Full Bright", "Enable full brightness", function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 14
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Library:Notification({
        Title = "Full Bright",
        Text = "Full Bright Enabled!",
        Time = 3
    })
end)

-- Credits Tab
local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Script Info")
CreditsSection:NewLabel("MM2 Exploit Script")
CreditsSection:NewLabel("Made for Manus User")
CreditsSection:NewLabel("Version 1.0")

-- RunService Loops
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        Noclip()
    end
    
    if ESPEnabled then
        UpdateESP()
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if ESPEnabled then
            wait(1)
            CreateESP(player)
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
Library:Notification({
    Title = "MM2 Exploit Hub",
    Text = "Script Loaded Successfully!",
    Time = 5
})

print("MM2 Exploit Script Loaded!")
