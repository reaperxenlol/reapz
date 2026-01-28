--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                    BLOX FRUITS PREMIUM SCRIPT                    ║
    ║                     Version 3.0 - January 2026                   ║
    ║                      Using Fluent UI Library                     ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════
-- LOAD FLUENT UI LIBRARY
-- ═══════════════════════════════════════════════════════════════════

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ═══════════════════════════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════
-- GLOBAL VARIABLES
-- ═══════════════════════════════════════════════════════════════════

_G.StopTween = false
local CurrentTween = nil
local AutoFarmConnection = nil
local BossFarmConnection = nil

-- ═══════════════════════════════════════════════════════════════════
-- SETTINGS
-- ═══════════════════════════════════════════════════════════════════

local Settings = {
    AutoFarm = false,
    BringMob = true,
    WeaponType = "Melee",
    AutoBoss = false,
    SelectedBoss = "",
    AutoStats = false,
    StatType = "Melee",
    NoClip = false,
    InfiniteEnergy = false,
    Fly = false,
    FlySpeed = 50,
    AutoHaki = true,
}

-- ═══════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function IsAlive()
    local humanoid = GetHumanoid()
    local rootPart = GetRootPart()
    return humanoid and rootPart and humanoid.Health > 0
end

local function GetPlayerLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    return data and data:FindFirstChild("Level") and data.Level.Value or 0
end

local function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1
    elseif placeId == 4442272183 then return 2
    elseif placeId == 7449423635 then return 3
    end
    return 1
end

local function GetDistance(position)
    local rootPart = GetRootPart()
    if rootPart and position then
        return (rootPart.Position - position).Magnitude
    end
    return math.huge
end

local function FireRemote(...)
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer(...)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- TWEEN SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local function StopTween()
    _G.StopTween = true
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    task.wait(0.1)
    _G.StopTween = false
end

local function TweenTo(targetCFrame, speed)
    if _G.StopTween then return end
    if not IsAlive() then return end
    
    local rootPart = GetRootPart()
    if not rootPart then return end
    
    if typeof(targetCFrame) == "Vector3" then
        targetCFrame = CFrame.new(targetCFrame)
    end
    
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local duration = distance / (speed or 200)
    
    if duration < 0.1 then duration = 0.1 end
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    if CurrentTween then
        CurrentTween:Cancel()
    end
    
    CurrentTween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    CurrentTween:Play()
    
    return CurrentTween
end

-- ═══════════════════════════════════════════════════════════════════
-- WEAPON FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

local function EquipTool(toolName)
    pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack and backpack:FindFirstChild(toolName) then
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid:EquipTool(backpack:FindFirstChild(toolName))
            end
        end
    end)
end

local function GetWeaponByType(weaponType)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = GetCharacter()
    
    local searchIn = {}
    if backpack then table.insert(searchIn, backpack) end
    if character then table.insert(searchIn, character) end
    
    for _, container in ipairs(searchIn) do
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local tooltip = item.ToolTip:lower()
                if weaponType == "Melee" and (tooltip == "melee" or tooltip == "fighting style") then
                    return item.Name
                elseif weaponType == "Sword" and tooltip == "sword" then
                    return item.Name
                elseif weaponType == "Fruit" and (tooltip == "blox fruit" or tooltip == "devil fruit") then
                    return item.Name
                elseif weaponType == "Gun" and tooltip == "gun" then
                    return item.Name
                end
            end
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════
-- QUEST DATA
-- ═══════════════════════════════════════════════════════════════════

local QuestTable = {
    [1] = {
        {Level = 0, QuestName = "BanditQuest1", QuestLevel = 1, MobName = "Bandit [Lv. 5]", NPCPosition = CFrame.new(1061, 16, 1548), MobPosition = CFrame.new(1061, 16, 1548)},
        {Level = 10, QuestName = "MonkeyQuest1", QuestLevel = 1, MobName = "Monkey [Lv. 14]", NPCPosition = CFrame.new(-1604, 37, 154), MobPosition = CFrame.new(-1500, 50, 100)},
        {Level = 15, QuestName = "MonkeyQuest2", QuestLevel = 2, MobName = "Gorilla [Lv. 20]", NPCPosition = CFrame.new(-1604, 37, 154), MobPosition = CFrame.new(-1350, 37, 250)},
        {Level = 30, QuestName = "PirateQuest1", QuestLevel = 1, MobName = "Pirate [Lv. 35]", NPCPosition = CFrame.new(-1139, 5, 3825), MobPosition = CFrame.new(-1200, 5, 3850)},
        {Level = 60, QuestName = "DesertQuest1", QuestLevel = 1, MobName = "Desert Bandit [Lv. 60]", NPCPosition = CFrame.new(896, 6, 4392), MobPosition = CFrame.new(900, 7, 4500)},
        {Level = 90, QuestName = "SnowQuest1", QuestLevel = 1, MobName = "Snow Bandit [Lv. 90]", NPCPosition = CFrame.new(1386, 87, -1296), MobPosition = CFrame.new(1400, 87, -1200)},
        {Level = 120, QuestName = "IceSideQuest1", QuestLevel = 1, MobName = "Chief Petty Officer [Lv. 120]", NPCPosition = CFrame.new(-6064, 16, -4902), MobPosition = CFrame.new(-6000, 16, -4850)},
        {Level = 150, QuestName = "SkyQuest1", QuestLevel = 1, MobName = "Sky Bandit [Lv. 150]", NPCPosition = CFrame.new(-4841, 717, -2619), MobPosition = CFrame.new(-4900, 720, -2600)},
        {Level = 200, QuestName = "ColosseumQuest", QuestLevel = 1, MobName = "Gladiator [Lv. 225]", NPCPosition = CFrame.new(-1576, 7, -2983), MobPosition = CFrame.new(-1450, 7, -2900)},
        {Level = 250, QuestName = "MagmaQuest1", QuestLevel = 1, MobName = "Military Soldier [Lv. 250]", NPCPosition = CFrame.new(-5316, 12, 8517), MobPosition = CFrame.new(-5400, 12, 8600)},
        {Level = 300, QuestName = "FishmanQuest1", QuestLevel = 1, MobName = "Fishman Warrior [Lv. 300]", NPCPosition = CFrame.new(61123, 18, 1568), MobPosition = CFrame.new(61200, 18, 1500)},
    },
    [2] = {
        {Level = 700, QuestName = "AreaQuest1", QuestLevel = 1, MobName = "Raider [Lv. 700]", NPCPosition = CFrame.new(-429, 73, 1836), MobPosition = CFrame.new(-350, 73, 1900)},
        {Level = 750, QuestName = "KingdomQuest1", QuestLevel = 1, MobName = "Swan Pirate [Lv. 750]", NPCPosition = CFrame.new(2291, 15, -315), MobPosition = CFrame.new(2200, 15, -250)},
        {Level = 850, QuestName = "SnowMountainQuest1", QuestLevel = 1, MobName = "Yeti [Lv. 850]", NPCPosition = CFrame.new(609, 400, -5765), MobPosition = CFrame.new(700, 400, -5700)},
        {Level = 950, QuestName = "ForgottenQuest1", QuestLevel = 1, MobName = "Zombie [Lv. 950]", NPCPosition = CFrame.new(-3054, 237, -10148), MobPosition = CFrame.new(-3000, 237, -10050)},
        {Level = 1100, QuestName = "DarkAreaQuest1", QuestLevel = 1, MobName = "Brute [Lv. 1100]", NPCPosition = CFrame.new(5765, 87, -3064), MobPosition = CFrame.new(5850, 87, -3000)},
        {Level = 1125, QuestName = "CursedShipQuest1", QuestLevel = 1, MobName = "Reborn Skeleton [Lv. 1125]", NPCPosition = CFrame.new(916, 125, 33056), MobPosition = CFrame.new(1000, 125, 33100)},
    },
    [3] = {
        {Level = 1500, QuestName = "PortQuest1", QuestLevel = 1, MobName = "Pirate Millionaire [Lv. 1500]", NPCPosition = CFrame.new(-290, 44, 5579), MobPosition = CFrame.new(-200, 44, 5650)},
        {Level = 1550, QuestName = "HydraQuest1", QuestLevel = 1, MobName = "Dragon Crew Warrior [Lv. 1550]", NPCPosition = CFrame.new(5259, 607, 335), MobPosition = CFrame.new(5350, 607, 400)},
        {Level = 1600, QuestName = "GreatTreeQuest1", QuestLevel = 1, MobName = "Female Islander [Lv. 1600]", NPCPosition = CFrame.new(2840, 1392, -7839), MobPosition = CFrame.new(2900, 1392, -7750)},
        {Level = 1700, QuestName = "FloatingTurtleQuest1", QuestLevel = 1, MobName = "Marine Commodore [Lv. 1650]", NPCPosition = CFrame.new(-13232, 533, -7631), MobPosition = CFrame.new(-13150, 533, -7550)},
        {Level = 1800, QuestName = "HauntedQuest1", QuestLevel = 1, MobName = "Ghoul [Lv. 1750]", NPCPosition = CFrame.new(-9516, 162, 5765), MobPosition = CFrame.new(-9450, 162, 5850)},
        {Level = 2000, QuestName = "SeaQuest1", QuestLevel = 1, MobName = "Cake Guard [Lv. 2000]", NPCPosition = CFrame.new(-2067, 28, -10212), MobPosition = CFrame.new(-2000, 28, -10150)},
    }
}

local function GetQuestForLevel()
    local level = GetPlayerLevel()
    local sea = GetCurrentSea()
    local questList = QuestTable[sea]
    
    if not questList then return nil end
    
    local selectedQuest = nil
    for _, quest in ipairs(questList) do
        if level >= quest.Level then
            selectedQuest = quest
        else
            break
        end
    end
    
    return selectedQuest
end

local function HasQuest()
    local success, result = pcall(function()
        return LocalPlayer.PlayerGui.Main.Quest.Visible
    end)
    return success and result
end

-- ═══════════════════════════════════════════════════════════════════
-- ISLAND DATA
-- ═══════════════════════════════════════════════════════════════════

local IslandTable = {
    ["First Sea"] = {
        ["Starter Island"] = CFrame.new(1061, 16, 1548),
        ["Jungle"] = CFrame.new(-1607, 36, 152),
        ["Pirate Village"] = CFrame.new(-1139, 5, 3825),
        ["Desert"] = CFrame.new(896, 6, 4392),
        ["Frozen Village"] = CFrame.new(1386, 87, -1296),
        ["Marine Fortress"] = CFrame.new(-6064, 16, -4902),
        ["Skylands"] = CFrame.new(-4841, 717, -2619),
        ["Colosseum"] = CFrame.new(-1576, 7, -2983),
        ["Magma Village"] = CFrame.new(-5316, 12, 8517),
        ["Underwater City"] = CFrame.new(61123, 18, 1568),
    },
    ["Second Sea"] = {
        ["Kingdom of Rose"] = CFrame.new(2291, 16, -315),
        ["Graveyard"] = CFrame.new(-5497, 314, -795),
        ["Snow Mountain"] = CFrame.new(609, 400, -5765),
        ["Cursed Ship"] = CFrame.new(916, 125, 33056),
        ["Ice Castle"] = CFrame.new(5669, 28, -6485),
        ["Forgotten Island"] = CFrame.new(-3054, 237, -10148),
        ["Dark Arena"] = CFrame.new(5765, 87, -3064),
    },
    ["Third Sea"] = {
        ["Port Town"] = CFrame.new(-290, 44, 5579),
        ["Hydra Island"] = CFrame.new(5259, 607, 335),
        ["Great Tree"] = CFrame.new(2840, 1392, -7839),
        ["Floating Turtle"] = CFrame.new(-13232, 533, -7631),
        ["Haunted Castle"] = CFrame.new(-9516, 162, 5765),
        ["Sea of Treats"] = CFrame.new(-2067, 28, -10212),
    }
}

-- ═══════════════════════════════════════════════════════════════════
-- MOB FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

local function FindMob(mobName)
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, enemy in ipairs(enemies:GetChildren()) do
        if enemy.Name == mobName then
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                return {
                    Model = enemy,
                    Humanoid = humanoid,
                    RootPart = rootPart,
                    Name = enemy.Name
                }
            end
        end
    end
    return nil
end

local function BringMob(enemy)
    if not enemy or not enemy.RootPart or not enemy.Humanoid then return end
    if enemy.Humanoid.Health <= 0 then return end
    
    local rootPart = GetRootPart()
    if not rootPart then return end
    
    pcall(function()
        enemy.RootPart.CFrame = rootPart.CFrame * CFrame.new(0, -10, 5)
        enemy.RootPart.Size = Vector3.new(60, 60, 60)
        enemy.RootPart.Transparency = 1
        enemy.RootPart.CanCollide = false
        enemy.Humanoid.WalkSpeed = 0
        enemy.Humanoid.JumpPower = 0
        enemy.Humanoid:ChangeState(11)
        enemy.Humanoid:ChangeState(14)
    end)
end

local function Attack()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO FARM SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local function StartAutoFarm()
    if AutoFarmConnection then return end
    
    AutoFarmConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoFarm then return end
        if not IsAlive() then return end
        
        local questData = GetQuestForLevel()
        if not questData then return end
        
        if HasQuest() then
            local mob = FindMob(questData.MobName)
            
            if mob then
                local weapon = GetWeaponByType(Settings.WeaponType)
                if weapon then EquipTool(weapon) end
                
                TweenTo(mob.RootPart.CFrame * CFrame.new(0, 15, 0), 250)
                
                if Settings.BringMob then
                    BringMob(mob)
                end
                
                Attack()
            else
                TweenTo(questData.MobPosition, 250)
            end
        else
            local npcPos = questData.NPCPosition
            local distance = GetDistance(npcPos.Position)
            
            if distance > 15 then
                TweenTo(npcPos, 250)
            else
                FireRemote("StartQuest", questData.QuestName, questData.QuestLevel)
                task.wait(0.5)
            end
        end
    end)
end

local function StopAutoFarm()
    if AutoFarmConnection then
        AutoFarmConnection:Disconnect()
        AutoFarmConnection = nil
    end
    StopTween()
end

-- ═══════════════════════════════════════════════════════════════════
-- FLY SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local FlyActive = false
local FlyBodyVelocity = nil
local FlyBodyGyro = nil
local FlyConnection = nil

local function StartFly()
    if FlyActive then return end
    FlyActive = true
    
    local rootPart = GetRootPart()
    local humanoid = GetHumanoid()
    
    if not rootPart or not humanoid then return end
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.Parent = rootPart
    
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyBodyGyro.P = 9e4
    FlyBodyGyro.CFrame = rootPart.CFrame
    FlyBodyGyro.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    local camera = Workspace.CurrentCamera
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not FlyActive then return end
        
        local direction = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end
        
        if FlyBodyVelocity then
            FlyBodyVelocity.Velocity = direction * Settings.FlySpeed
        end
        if FlyBodyGyro then
            FlyBodyGyro.CFrame = camera.CFrame
        end
    end)
end

local function StopFly()
    FlyActive = false
    
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if FlyBodyVelocity then
        FlyBodyVelocity:Destroy()
        FlyBodyVelocity = nil
    end
    
    if FlyBodyGyro then
        FlyBodyGyro:Destroy()
        FlyBodyGyro = nil
    end
    
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- BACKGROUND LOOPS
-- ═══════════════════════════════════════════════════════════════════

-- No Clip
task.spawn(function()
    while true do
        task.wait()
        if Settings.NoClip and IsAlive() then
            pcall(function()
                local character = GetCharacter()
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- Infinite Energy
task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.InfiniteEnergy then
            pcall(function()
                local character = GetCharacter()
                if character and character:FindFirstChild("Energy") then
                    character.Energy.Value = 5000
                end
            end)
        end
    end
end)

-- Auto Haki
task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoHaki and IsAlive() then
            pcall(function()
                local character = GetCharacter()
                if character and not character:FindFirstChild("HasBuso") then
                    FireRemote("Buso")
                end
            end)
        end
    end
end)

-- Anti-AFK
pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ═══════════════════════════════════════════════════════════════════
-- CREATE FLUENT WINDOW
-- ═══════════════════════════════════════════════════════════════════

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits Premium",
    SubTitle = "v3.0 | January 2026",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- ═══════════════════════════════════════════════════════════════════
-- MAIN TAB
-- ═══════════════════════════════════════════════════════════════════

local MainTab = Window:AddTab({Title = "Main", Icon = "swords"})

MainTab:AddParagraph({
    Title = "Auto Farm",
    Content = "Automatically farms mobs based on your level"
})

MainTab:AddToggle("AutoFarm", {
    Title = "Auto Farm Level",
    Default = false,
    Callback = function(value)
        Settings.AutoFarm = value
        if value then
            StartAutoFarm()
            Fluent:Notify({Title = "Auto Farm", Content = "Auto Farm enabled!", Duration = 3})
        else
            StopAutoFarm()
            Fluent:Notify({Title = "Auto Farm", Content = "Auto Farm disabled!", Duration = 3})
        end
    end
})

MainTab:AddToggle("BringMob", {
    Title = "Bring Mob",
    Default = true,
    Callback = function(value)
        Settings.BringMob = value
    end
})

MainTab:AddDropdown("WeaponType", {
    Title = "Weapon Type",
    Values = {"Melee", "Sword", "Fruit", "Gun"},
    Default = "Melee",
    Callback = function(value)
        Settings.WeaponType = value
    end
})

-- ═══════════════════════════════════════════════════════════════════
-- COMBAT TAB
-- ═══════════════════════════════════════════════════════════════════

local CombatTab = Window:AddTab({Title = "Combat", Icon = "sword"})

CombatTab:AddParagraph({
    Title = "Combat Settings",
    Content = "Configure your combat options"
})

CombatTab:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Default = true,
    Callback = function(value)
        Settings.AutoHaki = value
    end
})

-- ═══════════════════════════════════════════════════════════════════
-- STATS TAB
-- ═══════════════════════════════════════════════════════════════════

local StatsTab = Window:AddTab({Title = "Stats", Icon = "bar-chart"})

StatsTab:AddParagraph({
    Title = "Auto Stats",
    Content = "Automatically distribute stat points"
})

StatsTab:AddToggle("AutoStats", {
    Title = "Auto Stats",
    Default = false,
    Callback = function(value)
        Settings.AutoStats = value
        if value then
            task.spawn(function()
                while Settings.AutoStats do
                    task.wait(0.5)
                    pcall(function()
                        FireRemote("AddPoint", Settings.StatType)
                    end)
                end
            end)
            Fluent:Notify({Title = "Stats", Content = "Auto Stats enabled!", Duration = 3})
        end
    end
})

StatsTab:AddDropdown("StatType", {
    Title = "Stat Type",
    Values = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"},
    Default = "Melee",
    Callback = function(value)
        Settings.StatType = value
    end
})

-- ═══════════════════════════════════════════════════════════════════
-- TELEPORT TAB
-- ═══════════════════════════════════════════════════════════════════

local TeleportTab = Window:AddTab({Title = "Teleport", Icon = "map-pin"})

TeleportTab:AddParagraph({
    Title = "Island Teleport",
    Content = "Teleport to any island in your current sea"
})

local currentSea = GetCurrentSea()
local seaName = currentSea == 1 and "First Sea" or (currentSea == 2 and "Second Sea" or "Third Sea")
local islandList = {}

for name, _ in pairs(IslandTable[seaName] or {}) do
    table.insert(islandList, name)
end
table.sort(islandList)

local SelectedIsland = islandList[1] or ""

TeleportTab:AddDropdown("Island", {
    Title = "Select Island",
    Values = islandList,
    Default = islandList[1],
    Callback = function(value)
        SelectedIsland = value
    end
})

TeleportTab:AddButton({
    Title = "Teleport",
    Description = "Teleport to selected island",
    Callback = function()
        if SelectedIsland and IslandTable[seaName] and IslandTable[seaName][SelectedIsland] then
            TweenTo(IslandTable[seaName][SelectedIsland], 300)
            Fluent:Notify({Title = "Teleport", Content = "Teleporting to " .. SelectedIsland, Duration = 3})
        end
    end
})

-- ═══════════════════════════════════════════════════════════════════
-- MISC TAB
-- ═══════════════════════════════════════════════════════════════════

local MiscTab = Window:AddTab({Title = "Misc", Icon = "settings"})

MiscTab:AddParagraph({
    Title = "Player Mods",
    Content = "Various player modifications"
})

MiscTab:AddToggle("NoClip", {
    Title = "No Clip",
    Default = false,
    Callback = function(value)
        Settings.NoClip = value
    end
})

MiscTab:AddToggle("InfiniteEnergy", {
    Title = "Infinite Energy",
    Default = false,
    Callback = function(value)
        Settings.InfiniteEnergy = value
    end
})

MiscTab:AddToggle("Fly", {
    Title = "Fly",
    Default = false,
    Callback = function(value)
        Settings.Fly = value
        if value then
            StartFly()
            Fluent:Notify({Title = "Fly", Content = "Fly enabled! Use WASD + Space/Shift", Duration = 3})
        else
            StopFly()
        end
    end
})

MiscTab:AddSlider("FlySpeed", {
    Title = "Fly Speed",
    Min = 10,
    Max = 500,
    Default = 50,
    Rounding = 0,
    Callback = function(value)
        Settings.FlySpeed = value
    end
})

MiscTab:AddButton({
    Title = "Rejoin Server",
    Description = "Rejoin the current server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

MiscTab:AddButton({
    Title = "Server Hop",
    Description = "Join a different server",
    Callback = function()
        pcall(function()
            local servers = {}
            local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            
            for _, server in ipairs(req.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], LocalPlayer)
            end
        end)
    end
})

-- ═══════════════════════════════════════════════════════════════════
-- INFO TAB
-- ═══════════════════════════════════════════════════════════════════

local InfoTab = Window:AddTab({Title = "Info", Icon = "info"})

InfoTab:AddParagraph({
    Title = "Player Info",
    Content = "Level: " .. GetPlayerLevel() .. "\nSea: " .. GetCurrentSea()
})

InfoTab:AddParagraph({
    Title = "Script Info",
    Content = "Version: 3.0\nUpdated: January 2026\nUI: Fluent"
})

InfoTab:AddParagraph({
    Title = "Controls",
    Content = "PC: Right Control to toggle GUI\nMobile: Use the toggle button"
})

-- ═══════════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════

local SettingsTab = Window:AddTab({Title = "Settings", Icon = "cog"})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("BloxFruitsPremium")
SaveManager:SetFolder("BloxFruitsPremium/configs")

InterfaceManager:BuildInterfaceSection(SettingsTab)
SaveManager:BuildConfigSection(SettingsTab)

-- ═══════════════════════════════════════════════════════════════════
-- SELECT DEFAULT TAB
-- ═══════════════════════════════════════════════════════════════════

Window:SelectTab(1)

-- ═══════════════════════════════════════════════════════════════════
-- INITIALIZATION COMPLETE
-- ═══════════════════════════════════════════════════════════════════

Fluent:Notify({
    Title = "Blox Fruits Premium",
    Content = "Script loaded successfully!\nPC: Right Control to toggle\nMobile: Use toggle button",
    Duration = 5
})

print([[
╔══════════════════════════════════════════════════════════════════╗
║                    BLOX FRUITS PREMIUM v3.0                      ║
║                       SCRIPT LOADED!                             ║
║                                                                  ║
║  PC: Right Control to toggle GUI                                 ║
║  Mobile: Use the toggle button on screen                         ║
╚══════════════════════════════════════════════════════════════════╝
]])
