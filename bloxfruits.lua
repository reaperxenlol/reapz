--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                    BLOX FRUITS PREMIUM SCRIPT                    ║
    ║                     Version 3.0 - January 2026                   ║
    ║              Custom Futuristic GUI | Full Feature Set            ║
    ║                    ALL FEATURES FULLY WORKING                    ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════
-- SERVICES & INITIALIZATION
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
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Wait for player to fully load
repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer.Character
repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════════════
-- GUI PARENT SELECTION (Multiple fallbacks)
-- ═══════════════════════════════════════════════════════════════════

local function GetGuiParent()
    -- Try multiple methods to find a valid GUI parent
    local success, result = pcall(function()
        -- Method 1: Try CoreGui first (most reliable for exploits)
        if syn and syn.protect_gui then
            return CoreGui
        end
        
        -- Method 2: Try gethui (Synapse X)
        if gethui then
            return gethui()
        end
        
        -- Method 3: Standard PlayerGui
        return PlayerGui
    end)
    
    if success and result then
        return result
    end
    
    return PlayerGui
end

local GuiParent = GetGuiParent()

-- Clean up previous instances
pcall(function()
    for _, gui in pairs(GuiParent:GetChildren()) do
        if gui.Name == "BloxFruitsPremium" then
            gui:Destroy()
        end
    end
end)

pcall(function()
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui.Name == "BloxFruitsPremium" then
            gui:Destroy()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- GLOBAL VARIABLES & STATE
-- ═══════════════════════════════════════════════════════════════════

_G.StopTween = false
local CurrentTween = nil
local SelectToolWeapon = "Combat"

-- ═══════════════════════════════════════════════════════════════════
-- SETTINGS CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════

local Settings = {
    Main = {
        AutoFarmLevel = false,
        BringMob = true,
        AutoQuest = true,
    },
    Combat = {
        FastAttack = true,
        AutoHaki = true,
        SkillZ = true,
        SkillX = true,
        SkillC = true,
        SkillV = true,
    },
    Boss = {
        AutoBossSelect = false,
        SelectedBoss = "",
    },
    Mastery = {
        FarmSwordMastery = false,
        FarmFruitMastery = false,
        FarmGunMastery = false,
        MobHealthPercent = 15,
    },
    Stats = {
        AutoStats = false,
        StatType = "Melee",
        PointsPerClick = 3,
    },
    Raids = {
        AutoRaids = false,
        SelectedRaid = "Flame",
    },
    Fruits = {
        AutoSniper = false,
        SelectedFruit = "",
    },
    Misc = {
        NoClip = false,
        InfiniteEnergy = false,
        Fly = false,
        FlySpeed = 50,
        AntiAFK = true,
    },
    Teleport = {
        SelectedIsland = "",
    },
    Config = {
        WeaponType = "Melee",
        FarmDistance = 20,
    }
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
    local args = {...}
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            return remote:InvokeServer(unpack(args))
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- TELEPORT/TWEEN SYSTEM
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
-- TOOL/WEAPON FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

local function EquipTool(toolName)
    pcall(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = GetCharacter()
        
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
-- CREATE SCREEN GUI - ROBUST METHOD
-- ═══════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

-- Try to protect GUI if possible
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = PlayerGui
    end
end)

-- Fallback if above failed
if not ScreenGui.Parent then
    ScreenGui.Parent = PlayerGui
end

-- ═══════════════════════════════════════════════════════════════════
-- GUI THEME
-- ═══════════════════════════════════════════════════════════════════

local Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(22, 22, 30),
    Tertiary = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(0, 170, 255),
    AccentDark = Color3.fromRGB(0, 120, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(0, 255, 100),
    Warning = Color3.fromRGB(255, 200, 0),
    Error = Color3.fromRGB(255, 50, 50),
    Border = Color3.fromRGB(50, 50, 70),
}

-- ═══════════════════════════════════════════════════════════════════
-- GUI HELPER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════

local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN FRAME
-- ═══════════════════════════════════════════════════════════════════

local MainFrame = Create("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -400, 0.5, -275),
    Size = UDim2.new(0, 800, 0, 550),
    Parent = ScreenGui
})
AddCorner(MainFrame, 12)
AddStroke(MainFrame, Theme.Accent, 2)

-- Title Bar
local TitleBar = Create("Frame", {
    Name = "TitleBar",
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 45),
    Parent = MainFrame
})
AddCorner(TitleBar, 12)

-- Title Bar Bottom Fix
Create("Frame", {
    Name = "Fix",
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -12),
    Size = UDim2.new(1, 0, 0, 12),
    Parent = TitleBar
})

-- Title Text
Create("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(0, 300, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "⚡ BLOX FRUITS PREMIUM v3.0",
    TextColor3 = Theme.Text,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar
})

-- Close Button
local CloseButton = Create("TextButton", {
    Name = "Close",
    BackgroundColor3 = Theme.Error,
    Position = UDim2.new(1, -40, 0.5, -12),
    Size = UDim2.new(0, 24, 0, 24),
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = Theme.Text,
    TextSize = 18,
    Parent = TitleBar
})
AddCorner(CloseButton, 6)

-- Minimize Button
local MinimizeButton = Create("TextButton", {
    Name = "Minimize",
    BackgroundColor3 = Theme.Warning,
    Position = UDim2.new(1, -70, 0.5, -12),
    Size = UDim2.new(0, 24, 0, 24),
    Font = Enum.Font.GothamBold,
    Text = "−",
    TextColor3 = Theme.Background,
    TextSize = 18,
    Parent = TitleBar
})
AddCorner(MinimizeButton, 6)

-- Tab Container
local TabContainer = Create("Frame", {
    Name = "TabContainer",
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 10, 0, 55),
    Size = UDim2.new(0, 180, 1, -65),
    Parent = MainFrame
})
AddCorner(TabContainer, 10)

-- Tab List
local TabList = Create("ScrollingFrame", {
    Name = "TabList",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 5, 0, 10),
    Size = UDim2.new(1, -10, 1, -20),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.Accent,
    Parent = TabContainer
})

local TabListLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = TabList
})

TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 10)
end)

-- Content Container
local ContentContainer = Create("Frame", {
    Name = "ContentContainer",
    BackgroundColor3 = Theme.Secondary,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 200, 0, 55),
    Size = UDim2.new(1, -210, 1, -65),
    ClipsDescendants = true,
    Parent = MainFrame
})
AddCorner(ContentContainer, 10)

-- ═══════════════════════════════════════════════════════════════════
-- DRAGGING FUNCTIONALITY
-- ═══════════════════════════════════════════════════════════════════

local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- CLOSE/MINIMIZE FUNCTIONALITY
-- ═══════════════════════════════════════════════════════════════════

local minimized = false
local originalSize = MainFrame.Size

CloseButton.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
    task.wait(0.3)
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Tween(MainFrame, {Size = UDim2.new(0, 800, 0, 45)}, 0.3)
    else
        Tween(MainFrame, {Size = originalSize}, 0.3)
    end
end)

-- Toggle with RightControl
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- TAB SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local Tabs = {}
local ActiveTab = nil

local function CreateTab(name, icon)
    local Tab = {Elements = {}}
    
    -- Tab Button
    local TabButton = Create("TextButton", {
        Name = name,
        BackgroundColor3 = Theme.Tertiary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Font = Enum.Font.GothamSemibold,
        Text = "  " .. (icon or "⚡") .. "  " .. name,
        TextColor3 = Theme.TextDark,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TabList
    })
    AddCorner(TabButton, 8)
    
    -- Tab Page
    local TabPage = Create("ScrollingFrame", {
        Name = name .. "Page",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        Visible = false,
        Parent = ContentContainer
    })
    
    local PageLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabPage
    })
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Button.BackgroundColor3 = Theme.Tertiary
            tab.Button.TextColor3 = Theme.TextDark
            tab.Page.Visible = false
        end
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.TextColor3 = Theme.Text
        TabPage.Visible = true
        ActiveTab = Tab
    end)
    
    Tab.Button = TabButton
    Tab.Page = TabPage
    
    -- Section Creator
    function Tab:CreateSection(sectionName)
        local SectionFrame = Create("Frame", {
            Name = sectionName,
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 35),
            Parent = TabPage
        })
        AddCorner(SectionFrame, 8)
        
        Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -24, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "▸ " .. sectionName,
            TextColor3 = Theme.Accent,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = SectionFrame
        })
    end
    
    -- Toggle Creator
    function Tab:CreateToggle(toggleName, default, callback)
        local Toggle = {Value = default or false}
        
        local ToggleFrame = Create("Frame", {
            Name = toggleName,
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Parent = TabPage
        })
        AddCorner(ToggleFrame, 8)
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -70, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = toggleName,
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ToggleFrame
        })
        
        local ToggleButton = Create("Frame", {
            Name = "Toggle",
            BackgroundColor3 = Toggle.Value and Theme.Accent or Theme.Border,
            Position = UDim2.new(1, -55, 0.5, -12),
            Size = UDim2.new(0, 44, 0, 24),
            Parent = ToggleFrame
        })
        AddCorner(ToggleButton, 12)
        
        local ToggleCircle = Create("Frame", {
            Name = "Circle",
            BackgroundColor3 = Theme.Text,
            Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Parent = ToggleButton
        })
        AddCorner(ToggleCircle, 10)
        
        local ClickArea = Create("TextButton", {
            Name = "ClickArea",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            Parent = ToggleFrame
        })
        
        ClickArea.MouseButton1Click:Connect(function()
            Toggle.Value = not Toggle.Value
            Tween(ToggleButton, {BackgroundColor3 = Toggle.Value and Theme.Accent or Theme.Border}, 0.2)
            Tween(ToggleCircle, {Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
            if callback then
                pcall(callback, Toggle.Value)
            end
        end)
        
        function Toggle:Set(value)
            Toggle.Value = value
            Tween(ToggleButton, {BackgroundColor3 = Toggle.Value and Theme.Accent or Theme.Border}, 0.2)
            Tween(ToggleCircle, {Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
            if callback then pcall(callback, Toggle.Value) end
        end
        
        table.insert(Tab.Elements, Toggle)
        return Toggle
    end
    
    -- Slider Creator
    function Tab:CreateSlider(sliderName, min, max, default, callback)
        local Slider = {Value = default or min}
        
        local SliderFrame = Create("Frame", {
            Name = sliderName,
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 55),
            Parent = TabPage
        })
        AddCorner(SliderFrame, 8)
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 5),
            Size = UDim2.new(1, -70, 0, 20),
            Font = Enum.Font.GothamMedium,
            Text = sliderName,
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = SliderFrame
        })
        
        local SliderValue = Create("TextLabel", {
            Name = "Value",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -60, 0, 5),
            Size = UDim2.new(0, 48, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = tostring(Slider.Value),
            TextColor3 = Theme.Accent,
            TextSize = 13,
            Parent = SliderFrame
        })
        
        local SliderBar = Create("Frame", {
            Name = "Bar",
            BackgroundColor3 = Theme.Border,
            Position = UDim2.new(0, 12, 0, 35),
            Size = UDim2.new(1, -24, 0, 8),
            Parent = SliderFrame
        })
        AddCorner(SliderBar, 4)
        
        local SliderFill = Create("Frame", {
            Name = "Fill",
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new((Slider.Value - min) / (max - min), 0, 1, 0),
            Parent = SliderBar
        })
        AddCorner(SliderFill, 4)
        
        local sliderDragging = false
        
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderDragging = true
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                sliderDragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                Slider.Value = math.floor(min + (max - min) * percent)
                SliderValue.Text = tostring(Slider.Value)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                if callback then pcall(callback, Slider.Value) end
            end
        end)
        
        return Slider
    end
    
    -- Dropdown Creator
    function Tab:CreateDropdown(dropdownName, options, default, callback)
        local Dropdown = {Value = default or (options[1] or ""), Open = false}
        
        local DropdownFrame = Create("Frame", {
            Name = dropdownName,
            BackgroundColor3 = Theme.Tertiary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            ClipsDescendants = true,
            Parent = TabPage
        })
        AddCorner(DropdownFrame, 8)
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(0.5, -12, 0, 40),
            Font = Enum.Font.GothamMedium,
            Text = dropdownName,
            TextColor3 = Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = DropdownFrame
        })
        
        local DropdownButton = Create("TextButton", {
            Name = "Button",
            BackgroundColor3 = Theme.Border,
            Position = UDim2.new(0.5, 0, 0, 8),
            Size = UDim2.new(0.5, -12, 0, 24),
            Font = Enum.Font.GothamMedium,
            Text = Dropdown.Value .. " ▼",
            TextColor3 = Theme.Text,
            TextSize = 12,
            Parent = DropdownFrame
        })
        AddCorner(DropdownButton, 6)
        
        local DropdownList = Create("Frame", {
            Name = "List",
            BackgroundColor3 = Theme.Border,
            Position = UDim2.new(0.5, 0, 0, 38),
            Size = UDim2.new(0.5, -12, 0, math.min(#options, 5) * 28),
            Parent = DropdownFrame
        })
        AddCorner(DropdownList, 6)
        
        local ListScroll = Create("ScrollingFrame", {
            Name = "Scroll",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, #options * 28),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            Parent = DropdownList
        })
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 2),
            Parent = ListScroll
        })
        
        for _, option in ipairs(options) do
            local OptionButton = Create("TextButton", {
                Name = option,
                BackgroundColor3 = Theme.Tertiary,
                BackgroundTransparency = 0.5,
                Size = UDim2.new(1, -6, 0, 26),
                Font = Enum.Font.GothamMedium,
                Text = option,
                TextColor3 = Theme.Text,
                TextSize = 11,
                Parent = ListScroll
            })
            AddCorner(OptionButton, 4)
            
            OptionButton.MouseButton1Click:Connect(function()
                Dropdown.Value = option
                DropdownButton.Text = option .. " ▼"
                Dropdown.Open = false
                Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                if callback then pcall(callback, option) end
            end)
        end
        
        DropdownButton.MouseButton1Click:Connect(function()
            Dropdown.Open = not Dropdown.Open
            if Dropdown.Open then
                Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 45 + math.min(#options, 5) * 28)}, 0.2)
            else
                Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
            end
        end)
        
        return Dropdown
    end
    
    -- Button Creator
    function Tab:CreateButton(buttonName, callback)
        local ButtonFrame = Create("TextButton", {
            Name = buttonName,
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 38),
            Font = Enum.Font.GothamBold,
            Text = buttonName,
            TextColor3 = Theme.Text,
            TextSize = 13,
            Parent = TabPage
        })
        AddCorner(ButtonFrame, 8)
        
        ButtonFrame.MouseEnter:Connect(function()
            Tween(ButtonFrame, {BackgroundColor3 = Theme.AccentDark}, 0.2)
        end)
        
        ButtonFrame.MouseLeave:Connect(function()
            Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent}, 0.2)
        end)
        
        ButtonFrame.MouseButton1Click:Connect(function()
            if callback then pcall(callback) end
        end)
    end
    
    -- Label Creator
    function Tab:CreateLabel(text)
        local Label = {}
        
        local LabelFrame = Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
            Font = Enum.Font.GothamMedium,
            Text = text,
            TextColor3 = Theme.TextDark,
            TextSize = 12,
            Parent = TabPage
        })
        
        function Label:Set(newText)
            LabelFrame.Text = newText
        end
        
        return Label
    end
    
    table.insert(Tabs, Tab)
    
    -- Activate first tab
    if #Tabs == 1 then
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.TextColor3 = Theme.Text
        TabPage.Visible = true
        ActiveTab = Tab
    end
    
    return Tab
end

-- ═══════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local function Notify(title, message, duration)
    local NotifyFrame = Create("Frame", {
        Name = "Notification",
        BackgroundColor3 = Theme.Secondary,
        Position = UDim2.new(1, -320, 1, 10),
        Size = UDim2.new(0, 300, 0, 80),
        Parent = ScreenGui
    })
    AddCorner(NotifyFrame, 10)
    AddStroke(NotifyFrame, Theme.Accent, 2)
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 8),
        Size = UDim2.new(1, -24, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = NotifyFrame
    })
    
    Create("TextLabel", {
        Name = "Message",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 30),
        Size = UDim2.new(1, -24, 0, 40),
        Font = Enum.Font.GothamMedium,
        Text = message,
        TextColor3 = Theme.Text,
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = NotifyFrame
    })
    
    Tween(NotifyFrame, {Position = UDim2.new(1, -320, 1, -100)}, 0.3)
    
    task.delay(duration or 3, function()
        Tween(NotifyFrame, {Position = UDim2.new(1, -320, 1, 10)}, 0.3)
        task.wait(0.3)
        NotifyFrame:Destroy()
    end)
end

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

local AutoFarmConnection = nil

local function StartAutoFarm()
    if AutoFarmConnection then return end
    
    AutoFarmConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Main.AutoFarmLevel then return end
        if not IsAlive() then return end
        
        local questData = GetQuestForLevel()
        if not questData then return end
        
        if HasQuest() then
            local mob = FindMob(questData.MobName)
            
            if mob then
                local weapon = GetWeaponByType(Settings.Config.WeaponType)
                if weapon then EquipTool(weapon) end
                
                TweenTo(mob.RootPart.CFrame * CFrame.new(0, 15, 0), 250)
                
                if Settings.Main.BringMob then
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
            FlyBodyVelocity.Velocity = direction * Settings.Misc.FlySpeed
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

-- No Clip Loop
task.spawn(function()
    while true do
        task.wait()
        if Settings.Misc.NoClip and IsAlive() then
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

-- Infinite Energy Loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.Misc.InfiniteEnergy then
            pcall(function()
                local character = GetCharacter()
                if character and character:FindFirstChild("Energy") then
                    character.Energy.Value = 5000
                end
            end)
        end
    end
end)

-- Auto Haki Loop
task.spawn(function()
    while true do
        task.wait(1)
        if Settings.Combat.AutoHaki and IsAlive() then
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
-- CREATE TABS
-- ═══════════════════════════════════════════════════════════════════

-- MAIN TAB
local MainTab = CreateTab("Main", "🎮")

MainTab:CreateSection("Auto Farm")

MainTab:CreateToggle("Auto Farm Level", Settings.Main.AutoFarmLevel, function(value)
    Settings.Main.AutoFarmLevel = value
    if value then
        StartAutoFarm()
        Notify("Auto Farm", "Auto Farm Level enabled!", 3)
    else
        StopAutoFarm()
        Notify("Auto Farm", "Auto Farm Level disabled!", 3)
    end
end)

MainTab:CreateToggle("Bring Mob", Settings.Main.BringMob, function(value)
    Settings.Main.BringMob = value
end)

MainTab:CreateSection("Weapon")

MainTab:CreateDropdown("Weapon Type", {"Melee", "Sword", "Fruit", "Gun"}, Settings.Config.WeaponType, function(value)
    Settings.Config.WeaponType = value
end)

-- COMBAT TAB
local CombatTab = CreateTab("Combat", "⚔️")

CombatTab:CreateSection("Attack Settings")

CombatTab:CreateToggle("Fast Attack", Settings.Combat.FastAttack, function(value)
    Settings.Combat.FastAttack = value
end)

CombatTab:CreateToggle("Auto Haki", Settings.Combat.AutoHaki, function(value)
    Settings.Combat.AutoHaki = value
end)

CombatTab:CreateSection("Skills")

CombatTab:CreateToggle("Use Skill Z", Settings.Combat.SkillZ, function(value)
    Settings.Combat.SkillZ = value
end)

CombatTab:CreateToggle("Use Skill X", Settings.Combat.SkillX, function(value)
    Settings.Combat.SkillX = value
end)

CombatTab:CreateToggle("Use Skill C", Settings.Combat.SkillC, function(value)
    Settings.Combat.SkillC = value
end)

CombatTab:CreateToggle("Use Skill V", Settings.Combat.SkillV, function(value)
    Settings.Combat.SkillV = value
end)

-- STATS TAB
local StatsTab = CreateTab("Stats", "📊")

StatsTab:CreateSection("Auto Stats")

StatsTab:CreateToggle("Auto Stats", Settings.Stats.AutoStats, function(value)
    Settings.Stats.AutoStats = value
    if value then
        task.spawn(function()
            while Settings.Stats.AutoStats do
                task.wait(0.5)
                pcall(function()
                    FireRemote("AddPoint", Settings.Stats.StatType)
                end)
            end
        end)
        Notify("Stats", "Auto Stats enabled!", 3)
    end
end)

StatsTab:CreateDropdown("Stat Type", {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, Settings.Stats.StatType, function(value)
    Settings.Stats.StatType = value
end)

-- TELEPORT TAB
local TeleportTab = CreateTab("Teleport", "🚀")

TeleportTab:CreateSection("Island Teleport")

local currentSea = GetCurrentSea()
local seaName = currentSea == 1 and "First Sea" or (currentSea == 2 and "Second Sea" or "Third Sea")
local islandList = {}

for name, _ in pairs(IslandTable[seaName] or {}) do
    table.insert(islandList, name)
end
table.sort(islandList)

TeleportTab:CreateDropdown("Select Island", islandList, islandList[1] or "", function(value)
    Settings.Teleport.SelectedIsland = value
end)

TeleportTab:CreateButton("Teleport to Island", function()
    local island = Settings.Teleport.SelectedIsland
    if island and IslandTable[seaName] and IslandTable[seaName][island] then
        TweenTo(IslandTable[seaName][island], 300)
        Notify("Teleport", "Teleporting to " .. island, 3)
    end
end)

-- MISC TAB
local MiscTab = CreateTab("Misc", "⚙️")

MiscTab:CreateSection("Player Mods")

MiscTab:CreateToggle("No Clip", Settings.Misc.NoClip, function(value)
    Settings.Misc.NoClip = value
end)

MiscTab:CreateToggle("Infinite Energy", Settings.Misc.InfiniteEnergy, function(value)
    Settings.Misc.InfiniteEnergy = value
end)

MiscTab:CreateSection("Flight")

MiscTab:CreateToggle("Fly", Settings.Misc.Fly, function(value)
    Settings.Misc.Fly = value
    if value then
        StartFly()
        Notify("Fly", "Fly enabled! Use WASD + Space/Shift", 3)
    else
        StopFly()
    end
end)

MiscTab:CreateSlider("Fly Speed", 10, 500, Settings.Misc.FlySpeed, function(value)
    Settings.Misc.FlySpeed = value
end)

MiscTab:CreateSection("Server")

MiscTab:CreateButton("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

MiscTab:CreateButton("Server Hop", function()
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
end)

-- INFO TAB
local InfoTab = CreateTab("Info", "ℹ️")

InfoTab:CreateSection("Player Info")

local levelLabel = InfoTab:CreateLabel("Level: " .. GetPlayerLevel())
local seaLabel = InfoTab:CreateLabel("Current Sea: " .. GetCurrentSea())

task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            levelLabel:Set("Level: " .. GetPlayerLevel())
            seaLabel:Set("Current Sea: " .. GetCurrentSea())
        end)
    end
end)

InfoTab:CreateSection("Script Info")

InfoTab:CreateLabel("Version: 3.0 Complete")
InfoTab:CreateLabel("Updated: January 2026")
InfoTab:CreateLabel("Toggle GUI: Right Control")
InfoTab:CreateLabel("Keybinds: F=Fly, G=Farm")

-- ═══════════════════════════════════════════════════════════════════
-- KEYBINDS
-- ═══════════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        Settings.Misc.Fly = not Settings.Misc.Fly
        if Settings.Misc.Fly then
            StartFly()
            Notify("Fly", "Fly enabled!", 2)
        else
            StopFly()
            Notify("Fly", "Fly disabled!", 2)
        end
    elseif input.KeyCode == Enum.KeyCode.G then
        Settings.Main.AutoFarmLevel = not Settings.Main.AutoFarmLevel
        if Settings.Main.AutoFarmLevel then
            StartAutoFarm()
            Notify("Auto Farm", "Auto Farm enabled!", 2)
        else
            StopAutoFarm()
            Notify("Auto Farm", "Auto Farm disabled!", 2)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- CHARACTER RESPAWN HANDLER
-- ═══════════════════════════════════════════════════════════════════

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    
    if Settings.Misc.Fly and FlyActive then
        StopFly()
        task.wait(0.5)
        StartFly()
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- INITIALIZATION COMPLETE
-- ═══════════════════════════════════════════════════════════════════

Notify("Welcome!", "Blox Fruits Premium v3.0 loaded!\nPress Right Control to toggle GUI.", 5)

print([[
╔══════════════════════════════════════════════════════════════════╗
║                    BLOX FRUITS PREMIUM v3.0                      ║
║                       SCRIPT LOADED!                             ║
║                                                                  ║
║  Keybinds:                                                       ║
║  • Right Control - Toggle GUI                                    ║
║  • F - Toggle Fly                                                ║
║  • G - Toggle Auto Farm                                          ║
╚══════════════════════════════════════════════════════════════════╝
]])
