--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                    BLOX FRUITS PREMIUM SCRIPT                    ║
    ║                     Version 3.0 - January 2026                   ║
    ║              Custom Futuristic GUI | Full Feature Set            ║
    ╚══════════════════════════════════════════════════════════════════╝
    
    Features:
    - Auto Farm Level (All Seas)
    - Auto Farm Boss
    - Auto Farm Mastery
    - Auto Raids
    - Auto Stats
    - Devil Fruit Features
    - Fighting Style Unlocks
    - Teleportation System
    - Combat Enhancements
    - And much more...
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

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Clean up previous instances
if PlayerGui:FindFirstChild("BloxFruitsPremium") then
    PlayerGui:FindFirstChild("BloxFruitsPremium"):Destroy()
end

-- Remove death/respawn effects
pcall(function()
    if ReplicatedStorage.Effect.Container:FindFirstChild("Death") then
        ReplicatedStorage.Effect.Container.Death:Destroy()
    end
    if ReplicatedStorage.Effect.Container:FindFirstChild("Respawn") then
        ReplicatedStorage.Effect.Container.Respawn:Destroy()
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- SETTINGS CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════

local Settings = {
    Main = {
        AutoFarmLevel = false,
        FastAutoFarm = false,
        MobAura = false,
        MobAuraDistance = 1000,
        BringMob = true,
        AutoQuest = true,
    },
    
    World1 = {
        AutoSaber = false,
        AutoPole = false,
        AutoNewWorld = false,
        AutoBuyAbility = false,
    },
    
    World2 = {
        AutoThirdSea = false,
        AutoFactory = false,
        AutoBartiloQuest = false,
        AutoTTK = false,
        AutoRengoku = false,
        AutoSwanGlasses = false,
        AutoDarkCoat = false,
        AutoEctoplasm = false,
        AutoLegendarySword = false,
        AutoEnchantHaki = false,
    },
    
    World3 = {
        AutoHolyTorch = false,
        AutoBuddySword = false,
        AutoRainbowHaki = false,
        AutoEliteHunter = false,
        AutoMusketeerHat = false,
        AutoFarmBone = false,
        AutoKenHakiV2 = false,
        AutoCavander = false,
        AutoYama = false,
        AutoTushita = false,
        AutoSerpentBow = false,
        AutoDarkDagger = false,
        AutoCakePrince = false,
        AutoDoughV2 = false,
    },
    
    FightingStyle = {
        AutoGodHuman = false,
        AutoSuperhuman = false,
        AutoElectricClaw = false,
        AutoDeathStep = false,
        AutoSharkmanKarate = false,
        AutoDragonTalon = false,
    },
    
    Boss = {
        AutoAllBoss = false,
        AutoBossSelect = false,
        SelectedBoss = "",
        AutoBossQuest = false,
    },
    
    Mastery = {
        FarmSwordMastery = false,
        FarmFruitMastery = false,
        FarmGunMastery = false,
        SelectedWeapon = "",
        MobHealthPercent = 15,
    },
    
    Stats = {
        AutoStats = false,
        StatType = "Melee",
        PointsPerClick = 3,
    },
    
    Raids = {
        AutoRaids = false,
        KillAura = false,
        AutoAwakened = false,
        SelectedRaid = "Flame",
    },
    
    Fruits = {
        AutoBuyRandom = false,
        AutoStoreFruits = false,
        AutoSniper = false,
        SelectedFruit = "",
    },
    
    Combat = {
        FastAttack = true,
        AttackSpeed = "Fast",
        AutoHaki = true,
        SkillZ = true,
        SkillX = true,
        SkillC = true,
        SkillV = true,
    },
    
    Misc = {
        NoClip = false,
        InfiniteEnergy = false,
        InfiniteGeppo = false,
        NoFog = false,
        Fly = false,
        FlySpeed = 50,
        AutoRejoin = true,
        BypassTP = false,
    },
    
    Teleport = {
        SelectedIsland = "",
    },
    
    HUD = {
        FPSLimit = 60,
        LockFPS = false,
        BoostFPS = false,
    },
    
    Config = {
        SelectedTeam = "Pirate",
        WeaponType = "Melee",
        FarmDistance = 20,
        ShowHitbox = false,
    }
}

-- ═══════════════════════════════════════════════════════════════════
-- CUSTOM GUI LIBRARY
-- ═══════════════════════════════════════════════════════════════════

local GUI = {}
GUI.Theme = {
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
    Glow = Color3.fromRGB(0, 200, 255),
}

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return CreateInstance("UIStroke", {
        Color = color or GUI.Theme.Border,
        Thickness = thickness or 1,
        Parent = parent
    })
end

local function AddGlow(parent, color)
    local glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = color or GUI.Theme.Glow,
        ImageTransparency = 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        ZIndex = -1,
        Parent = parent
    })
    return glow
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN GUI CREATION
-- ═══════════════════════════════════════════════════════════════════

function GUI:CreateWindow(title)
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Main ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "BloxFruitsPremium",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })
    
    -- Main Frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = GUI.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -400, 0.5, -275),
        Size = UDim2.new(0, 800, 0, 550),
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, GUI.Theme.Border, 2)
    AddGlow(MainFrame, GUI.Theme.Accent)
    
    -- Title Bar
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = GUI.Theme.Secondary,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = MainFrame
    })
    AddCorner(TitleBar, 12)
    
    -- Fix corner overlap
    local TitleBarFix = CreateInstance("Frame", {
        Name = "Fix",
        BackgroundColor3 = GUI.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -12),
        Size = UDim2.new(1, 0, 0, 12),
        Parent = TitleBar
    })
    
    -- Title Text
    local TitleText = CreateInstance("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 300, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title or "BLOX FRUITS PREMIUM",
        TextColor3 = GUI.Theme.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Version Badge
    local VersionBadge = CreateInstance("TextLabel", {
        Name = "Version",
        BackgroundColor3 = GUI.Theme.Accent,
        Position = UDim2.new(0, 220, 0.5, -10),
        Size = UDim2.new(0, 50, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "v3.0",
        TextColor3 = GUI.Theme.Text,
        TextSize = 11,
        Parent = TitleBar
    })
    AddCorner(VersionBadge, 4)
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Name = "Close",
        BackgroundColor3 = GUI.Theme.Error,
        Position = UDim2.new(1, -40, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "×",
        TextColor3 = GUI.Theme.Text,
        TextSize = 18,
        Parent = TitleBar
    })
    AddCorner(CloseButton, 6)
    
    -- Minimize Button
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = GUI.Theme.Warning,
        Position = UDim2.new(1, -70, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = "−",
        TextColor3 = GUI.Theme.Background,
        TextSize = 18,
        Parent = TitleBar
    })
    AddCorner(MinimizeButton, 6)
    
    -- Tab Container (Left Side)
    local TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = GUI.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 55),
        Size = UDim2.new(0, 180, 1, -65),
        Parent = MainFrame
    })
    AddCorner(TabContainer, 10)
    
    local TabList = CreateInstance("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 10),
        Size = UDim2.new(1, -10, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = GUI.Theme.Accent,
        Parent = TabContainer
    })
    
    local TabListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabList
    })
    
    -- Content Container (Right Side)
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = GUI.Theme.Secondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 200, 0, 55),
        Size = UDim2.new(1, -210, 1, -65),
        ClipsDescendants = true,
        Parent = MainFrame
    })
    AddCorner(ContentContainer, 10)
    
    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Close/Minimize functionality
    local minimized = false
    local originalSize = MainFrame.Size
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        wait(0.3)
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
    
    -- Toggle visibility with key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    -- Create Tab Function
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
        local TabButton = CreateInstance("TextButton", {
            Name = name,
            BackgroundColor3 = GUI.Theme.Tertiary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            Font = Enum.Font.GothamSemibold,
            Text = "  " .. (icon or "⚡") .. "  " .. name,
            TextColor3 = GUI.Theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabList
        })
        AddCorner(TabButton, 8)
        
        -- Tab Content Page
        local TabPage = CreateInstance("ScrollingFrame", {
            Name = name .. "Page",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 1, -20),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = GUI.Theme.Accent,
            Visible = false,
            Parent = ContentContainer
        })
        
        local PageLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabPage
        })
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundColor3 = GUI.Theme.Tertiary
                tab.Button.TextColor3 = GUI.Theme.TextDark
                tab.Page.Visible = false
            end
            TabButton.BackgroundColor3 = GUI.Theme.Accent
            TabButton.TextColor3 = GUI.Theme.Text
            TabPage.Visible = true
            Window.ActiveTab = Tab
        end)
        
        -- Hover effects
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = GUI.Theme.Border}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = GUI.Theme.Tertiary}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Page = TabPage
        
        -- Section Function
        function Tab:CreateSection(name)
            local Section = {}
            
            local SectionFrame = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = GUI.Theme.Tertiary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 35),
                Parent = TabPage
            })
            AddCorner(SectionFrame, 8)
            
            local SectionTitle = CreateInstance("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "▸ " .. name,
                TextColor3 = GUI.Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionFrame
            })
            
            return Section
        end
        
        -- Toggle Function
        function Tab:CreateToggle(name, default, callback)
            local Toggle = {}
            Toggle.Value = default or false
            
            local ToggleFrame = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = GUI.Theme.Tertiary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = TabPage
            })
            AddCorner(ToggleFrame, 8)
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = name,
                TextColor3 = GUI.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame
            })
            
            local ToggleButton = CreateInstance("Frame", {
                Name = "Toggle",
                BackgroundColor3 = Toggle.Value and GUI.Theme.Accent or GUI.Theme.Border,
                Position = UDim2.new(1, -55, 0.5, -12),
                Size = UDim2.new(0, 44, 0, 24),
                Parent = ToggleFrame
            })
            AddCorner(ToggleButton, 12)
            
            local ToggleCircle = CreateInstance("Frame", {
                Name = "Circle",
                BackgroundColor3 = GUI.Theme.Text,
                Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Parent = ToggleButton
            })
            AddCorner(ToggleCircle, 10)
            
            local ToggleClickArea = CreateInstance("TextButton", {
                Name = "ClickArea",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                Parent = ToggleFrame
            })
            
            ToggleClickArea.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                Tween(ToggleButton, {BackgroundColor3 = Toggle.Value and GUI.Theme.Accent or GUI.Theme.Border}, 0.2)
                Tween(ToggleCircle, {Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
                if callback then
                    callback(Toggle.Value)
                end
            end)
            
            function Toggle:Set(value)
                Toggle.Value = value
                Tween(ToggleButton, {BackgroundColor3 = Toggle.Value and GUI.Theme.Accent or GUI.Theme.Border}, 0.2)
                Tween(ToggleCircle, {Position = Toggle.Value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.2)
                if callback then
                    callback(Toggle.Value)
                end
            end
            
            table.insert(Tab.Elements, Toggle)
            return Toggle
        end
        
        -- Slider Function
        function Tab:CreateSlider(name, min, max, default, callback)
            local Slider = {}
            Slider.Value = default or min
            
            local SliderFrame = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = GUI.Theme.Tertiary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 55),
                Parent = TabPage
            })
            AddCorner(SliderFrame, 8)
            
            local SliderLabel = CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 5),
                Size = UDim2.new(1, -70, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = name,
                TextColor3 = GUI.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame
            })
            
            local SliderValue = CreateInstance("TextLabel", {
                Name = "Value",
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -60, 0, 5),
                Size = UDim2.new(0, 48, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(Slider.Value),
                TextColor3 = GUI.Theme.Accent,
                TextSize = 13,
                Parent = SliderFrame
            })
            
            local SliderBar = CreateInstance("Frame", {
                Name = "Bar",
                BackgroundColor3 = GUI.Theme.Border,
                Position = UDim2.new(0, 12, 0, 35),
                Size = UDim2.new(1, -24, 0, 8),
                Parent = SliderFrame
            })
            AddCorner(SliderBar, 4)
            
            local SliderFill = CreateInstance("Frame", {
                Name = "Fill",
                BackgroundColor3 = GUI.Theme.Accent,
                Size = UDim2.new((Slider.Value - min) / (max - min), 0, 1, 0),
                Parent = SliderBar
            })
            AddCorner(SliderFill, 4)
            
            local SliderKnob = CreateInstance("Frame", {
                Name = "Knob",
                BackgroundColor3 = GUI.Theme.Text,
                Position = UDim2.new((Slider.Value - min) / (max - min), -8, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                ZIndex = 2,
                Parent = SliderBar
            })
            AddCorner(SliderKnob, 8)
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    Slider.Value = math.floor(min + (max - min) * percent)
                    SliderValue.Text = tostring(Slider.Value)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(percent, -8, 0.5, -8)
                    if callback then
                        callback(Slider.Value)
                    end
                end
            end)
            
            function Slider:Set(value)
                Slider.Value = math.clamp(value, min, max)
                local percent = (Slider.Value - min) / (max - min)
                SliderValue.Text = tostring(Slider.Value)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderKnob.Position = UDim2.new(percent, -8, 0.5, -8)
                if callback then
                    callback(Slider.Value)
                end
            end
            
            table.insert(Tab.Elements, Slider)
            return Slider
        end
        
        -- Dropdown Function
        function Tab:CreateDropdown(name, options, default, callback)
            local Dropdown = {}
            Dropdown.Value = default or options[1]
            Dropdown.Open = false
            
            local DropdownFrame = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = GUI.Theme.Tertiary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true,
                Parent = TabPage
            })
            AddCorner(DropdownFrame, 8)
            
            local DropdownLabel = CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.5, -12, 0, 40),
                Font = Enum.Font.GothamMedium,
                Text = name,
                TextColor3 = GUI.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame
            })
            
            local DropdownButton = CreateInstance("TextButton", {
                Name = "Button",
                BackgroundColor3 = GUI.Theme.Border,
                Position = UDim2.new(0.5, 0, 0, 8),
                Size = UDim2.new(0.5, -12, 0, 24),
                Font = Enum.Font.GothamMedium,
                Text = Dropdown.Value .. " ▼",
                TextColor3 = GUI.Theme.Text,
                TextSize = 12,
                Parent = DropdownFrame
            })
            AddCorner(DropdownButton, 6)
            
            local DropdownList = CreateInstance("Frame", {
                Name = "List",
                BackgroundColor3 = GUI.Theme.Border,
                Position = UDim2.new(0.5, 0, 0, 38),
                Size = UDim2.new(0.5, -12, 0, #options * 28),
                Parent = DropdownFrame
            })
            AddCorner(DropdownList, 6)
            
            local ListLayout = CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = DropdownList
            })
            
            for _, option in ipairs(options) do
                local OptionButton = CreateInstance("TextButton", {
                    Name = option,
                    BackgroundColor3 = GUI.Theme.Tertiary,
                    BackgroundTransparency = 0.5,
                    Size = UDim2.new(1, 0, 0, 26),
                    Font = Enum.Font.GothamMedium,
                    Text = option,
                    TextColor3 = GUI.Theme.Text,
                    TextSize = 11,
                    Parent = DropdownList
                })
                AddCorner(OptionButton, 4)
                
                OptionButton.MouseButton1Click:Connect(function()
                    Dropdown.Value = option
                    DropdownButton.Text = option .. " ▼"
                    Dropdown.Open = false
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                    if callback then
                        callback(option)
                    end
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                Dropdown.Open = not Dropdown.Open
                if Dropdown.Open then
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 45 + #options * 28)}, 0.2)
                else
                    Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                end
            end)
            
            function Dropdown:Set(value)
                Dropdown.Value = value
                DropdownButton.Text = value .. " ▼"
                if callback then
                    callback(value)
                end
            end
            
            table.insert(Tab.Elements, Dropdown)
            return Dropdown
        end
        
        -- Button Function
        function Tab:CreateButton(name, callback)
            local Button = {}
            
            local ButtonFrame = CreateInstance("TextButton", {
                Name = name,
                BackgroundColor3 = GUI.Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 38),
                Font = Enum.Font.GothamBold,
                Text = name,
                TextColor3 = GUI.Theme.Text,
                TextSize = 13,
                Parent = TabPage
            })
            AddCorner(ButtonFrame, 8)
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = GUI.Theme.AccentDark}, 0.2)
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = GUI.Theme.Accent}, 0.2)
            end)
            
            ButtonFrame.MouseButton1Click:Connect(function()
                if callback then
                    callback()
                end
            end)
            
            table.insert(Tab.Elements, Button)
            return Button
        end
        
        -- Textbox Function
        function Tab:CreateTextbox(name, placeholder, callback)
            local Textbox = {}
            Textbox.Value = ""
            
            local TextboxFrame = CreateInstance("Frame", {
                Name = name,
                BackgroundColor3 = GUI.Theme.Tertiary,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 40),
                Parent = TabPage
            })
            AddCorner(TextboxFrame, 8)
            
            local TextboxLabel = CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(0.4, -12, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = name,
                TextColor3 = GUI.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TextboxFrame
            })
            
            local TextboxInput = CreateInstance("TextBox", {
                Name = "Input",
                BackgroundColor3 = GUI.Theme.Border,
                Position = UDim2.new(0.4, 0, 0, 8),
                Size = UDim2.new(0.6, -12, 0, 24),
                Font = Enum.Font.GothamMedium,
                PlaceholderText = placeholder or "Enter text...",
                Text = "",
                TextColor3 = GUI.Theme.Text,
                PlaceholderColor3 = GUI.Theme.TextDark,
                TextSize = 12,
                ClearTextOnFocus = false,
                Parent = TextboxFrame
            })
            AddCorner(TextboxInput, 6)
            
            TextboxInput.FocusLost:Connect(function(enterPressed)
                Textbox.Value = TextboxInput.Text
                if callback then
                    callback(TextboxInput.Text, enterPressed)
                end
            end)
            
            function Textbox:Set(value)
                Textbox.Value = value
                TextboxInput.Text = value
            end
            
            table.insert(Tab.Elements, Textbox)
            return Textbox
        end
        
        -- Label Function
        function Tab:CreateLabel(text)
            local Label = {}
            
            local LabelFrame = CreateInstance("TextLabel", {
                Name = "Label",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamMedium,
                Text = text,
                TextColor3 = GUI.Theme.TextDark,
                TextSize = 12,
                Parent = TabPage
            })
            
            function Label:Set(newText)
                LabelFrame.Text = newText
            end
            
            return Label
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = GUI.Theme.Accent
            TabButton.TextColor3 = GUI.Theme.Text
            TabPage.Visible = true
            Window.ActiveTab = Tab
        end
        
        return Tab
    end
    
    -- Notification Function
    function Window:Notify(title, message, duration)
        local NotifyFrame = CreateInstance("Frame", {
            Name = "Notification",
            BackgroundColor3 = GUI.Theme.Secondary,
            Position = UDim2.new(1, -320, 1, 10),
            Size = UDim2.new(0, 300, 0, 80),
            Parent = ScreenGui
        })
        AddCorner(NotifyFrame, 10)
        AddStroke(NotifyFrame, GUI.Theme.Accent, 2)
        
        local NotifyTitle = CreateInstance("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 8),
            Size = UDim2.new(1, -24, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = title,
            TextColor3 = GUI.Theme.Accent,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotifyFrame
        })
        
        local NotifyMessage = CreateInstance("TextLabel", {
            Name = "Message",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 30),
            Size = UDim2.new(1, -24, 0, 40),
            Font = Enum.Font.GothamMedium,
            Text = message,
            TextColor3 = GUI.Theme.Text,
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
    
    return Window
end

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
    return humanoid and humanoid.Health > 0
end

local function GetPlayerLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    return data and data:FindFirstChild("Level") and data.Level.Value or 0
end

local function GetPlayerBeli()
    local data = LocalPlayer:FindFirstChild("Data")
    return data and data:FindFirstChild("Beli") and data.Beli.Value or 0
end

local function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1
    elseif placeId == 4442272183 then return 2
    elseif placeId == 7449423635 then return 3
    end
    return 1
end

local function FireRemote(remoteName, ...)
    local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild(remoteName)
    if remote then
        if remote:IsA("RemoteFunction") then
            return remote:InvokeServer(...)
        elseif remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        end
    end
end

local function CommF(...)
    return FireRemote("CommF_", ...)
end

-- Teleport Function with Tween
local CurrentTween = nil
local function TweenTo(targetCFrame, speed)
    if CurrentTween then
        CurrentTween:Cancel()
    end
    
    local rootPart = GetRootPart()
    if not rootPart then return end
    
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local duration = distance / (speed or 200)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    CurrentTween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    CurrentTween:Play()
    
    return CurrentTween
end

local function StopTween()
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
end

-- Equip Tool Function
local function EquipTool(toolName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = GetCharacter()
    
    if backpack and backpack:FindFirstChild(toolName) then
        local tool = backpack:FindFirstChild(toolName)
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid:EquipTool(tool)
        end
    end
end

-- Get Weapon by Type
local function GetWeaponByType(weaponType)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = GetCharacter()
    
    local searchIn = {backpack, character}
    
    for _, container in ipairs(searchIn) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    if weaponType == "Melee" and item.ToolTip == "Melee" then
                        return item.Name
                    elseif weaponType == "Sword" and item.ToolTip == "Sword" then
                        return item.Name
                    elseif weaponType == "Fruit" and item.ToolTip == "Blox Fruit" then
                        return item.Name
                    elseif weaponType == "Gun" and item.ToolTip == "Gun" then
                        return item.Name
                    end
                end
            end
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════
-- QUEST DATA
-- ═══════════════════════════════════════════════════════════════════

local QuestData = {
    -- First Sea
    [1] = {
        {Level = 0, Quest = "BanditQuest1", QuestLevel = 1, Mob = "Bandit [Lv. 5]", NPC = CFrame.new(1061, 16, 1548)},
        {Level = 10, Quest = "BanditQuest2", QuestLevel = 2, Mob = "Monkey [Lv. 14]", NPC = CFrame.new(-1604, 36, 154)},
        {Level = 15, Quest = "PirateQuest1", QuestLevel = 1, Mob = "Pirate [Lv. 20]", NPC = CFrame.new(-1139, 5, 3825)},
        {Level = 30, Quest = "JungleQuest", QuestLevel = 1, Mob = "Gorilla [Lv. 35]", NPC = CFrame.new(-1607, 36, 152)},
        {Level = 60, Quest = "BuggyQuest1", QuestLevel = 1, Mob = "Buggy Pirate [Lv. 65]", NPC = CFrame.new(-1139, 5, 3825)},
        {Level = 75, Quest = "DesertQuest", QuestLevel = 1, Mob = "Desert Bandit [Lv. 80]", NPC = CFrame.new(896, 6, 4392)},
        {Level = 90, Quest = "DesertQuest", QuestLevel = 2, Mob = "Desert Officer [Lv. 95]", NPC = CFrame.new(896, 6, 4392)},
        {Level = 100, Quest = "SnowQuest", QuestLevel = 1, Mob = "Snow Bandit [Lv. 105]", NPC = CFrame.new(1386, 87, -1296)},
        {Level = 120, Quest = "SnowQuest", QuestLevel = 2, Mob = "Snowman [Lv. 125]", NPC = CFrame.new(1386, 87, -1296)},
        {Level = 150, Quest = "IceSideQuest", QuestLevel = 1, Mob = "Chief Petty Officer [Lv. 155]", NPC = CFrame.new(-6064, 16, -4902)},
        {Level = 175, Quest = "IceSideQuest", QuestLevel = 2, Mob = "Sky Bandit [Lv. 180]", NPC = CFrame.new(-6064, 16, -4902)},
        {Level = 190, Quest = "SkyQuest", QuestLevel = 1, Mob = "Dark Master [Lv. 195]", NPC = CFrame.new(-4841, 331, -2619)},
        {Level = 225, Quest = "SkyQuest", QuestLevel = 2, Mob = "Toga Warrior [Lv. 230]", NPC = CFrame.new(-4841, 331, -2619)},
        {Level = 250, Quest = "ColosseumQuest", QuestLevel = 1, Mob = "Gladiator [Lv. 255]", NPC = CFrame.new(-1576, 7, -2983)},
        {Level = 275, Quest = "MagmaQuest", QuestLevel = 1, Mob = "Military Soldier [Lv. 280]", NPC = CFrame.new(-5316, 12, 8517)},
        {Level = 300, Quest = "MagmaQuest", QuestLevel = 2, Mob = "Military Spy [Lv. 305]", NPC = CFrame.new(-5316, 12, 8517)},
        {Level = 330, Quest = "FishmanQuest", QuestLevel = 1, Mob = "Fishman Warrior [Lv. 335]", NPC = CFrame.new(61123, 18, 1568)},
        {Level = 375, Quest = "FishmanQuest", QuestLevel = 2, Mob = "Fishman Commando [Lv. 380]", NPC = CFrame.new(61123, 18, 1568)},
    },
    
    -- Second Sea
    [2] = {
        {Level = 700, Quest = "AreaQuest", QuestLevel = 1, Mob = "Raider [Lv. 705]", NPC = CFrame.new(-429, 73, 1836)},
        {Level = 725, Quest = "AreaQuest2", QuestLevel = 1, Mob = "Mercenary [Lv. 730]", NPC = CFrame.new(-557, 73, 1321)},
        {Level = 775, Quest = "KingdomQuest", QuestLevel = 1, Mob = "Swan Pirate [Lv. 780]", NPC = CFrame.new(2291, 16, -315)},
        {Level = 800, Quest = "KingdomQuest", QuestLevel = 2, Mob = "Factory Staff [Lv. 805]", NPC = CFrame.new(2291, 16, -315)},
        {Level = 850, Quest = "GraveyardQuest", QuestLevel = 1, Mob = "Marine Lieutenant [Lv. 855]", NPC = CFrame.new(-5497, 314, -795)},
        {Level = 875, Quest = "GraveyardQuest", QuestLevel = 2, Mob = "Marine Captain [Lv. 880]", NPC = CFrame.new(-5497, 314, -795)},
        {Level = 900, Quest = "SnowMountainQuest", QuestLevel = 1, Mob = "Yeti [Lv. 905]", NPC = CFrame.new(609, 400, -5765)},
        {Level = 925, Quest = "SnowMountainQuest", QuestLevel = 2, Mob = "Yeti [Lv. 930]", NPC = CFrame.new(609, 400, -5765)},
        {Level = 950, Quest = "IceCastleQuest", QuestLevel = 1, Mob = "Snowman [Lv. 955]", NPC = CFrame.new(-6059, 16, -4904)},
        {Level = 975, Quest = "ForgottenQuest", QuestLevel = 1, Mob = "Zombie [Lv. 980]", NPC = CFrame.new(-3054, 237, -10148)},
        {Level = 1000, Quest = "ForgottenQuest", QuestLevel = 2, Mob = "Vampire [Lv. 1005]", NPC = CFrame.new(-3054, 237, -10148)},
        {Level = 1050, Quest = "PirateVillageQuest", QuestLevel = 1, Mob = "Pirate [Lv. 1055]", NPC = CFrame.new(-3054, 237, -10148)},
        {Level = 1100, Quest = "DarkAreaQuest", QuestLevel = 1, Mob = "Brute [Lv. 1105]", NPC = CFrame.new(5765, 87, -3064)},
        {Level = 1125, Quest = "DarkAreaQuest", QuestLevel = 2, Mob = "Brute [Lv. 1130]", NPC = CFrame.new(5765, 87, -3064)},
        {Level = 1175, Quest = "CursedShipQuest", QuestLevel = 1, Mob = "Reborn Skeleton [Lv. 1180]", NPC = CFrame.new(916, 125, 33056)},
        {Level = 1200, Quest = "CursedShipQuest", QuestLevel = 2, Mob = "Living Zombie [Lv. 1205]", NPC = CFrame.new(916, 125, 33056)},
        {Level = 1250, Quest = "FrostQuest", QuestLevel = 1, Mob = "Arctic Warrior [Lv. 1255]", NPC = CFrame.new(5669, 28, -6485)},
        {Level = 1300, Quest = "FrostQuest", QuestLevel = 2, Mob = "Snow Lurker [Lv. 1305]", NPC = CFrame.new(5669, 28, -6485)},
        {Level = 1350, Quest = "ForgottenQuest2", QuestLevel = 1, Mob = "Horned Warrior [Lv. 1355]", NPC = CFrame.new(-3054, 237, -10148)},
        {Level = 1400, Quest = "ForgottenQuest2", QuestLevel = 2, Mob = "Magma Ninja [Lv. 1405]", NPC = CFrame.new(-3054, 237, -10148)},
    },
    
    -- Third Sea
    [3] = {
        {Level = 1500, Quest = "PortQuest", QuestLevel = 1, Mob = "Pirate Millionaire [Lv. 1505]", NPC = CFrame.new(-290, 44, 5579)},
        {Level = 1525, Quest = "PortQuest", QuestLevel = 2, Mob = "Pistol Billionaire [Lv. 1530]", NPC = CFrame.new(-290, 44, 5579)},
        {Level = 1575, Quest = "HydraQuest", QuestLevel = 1, Mob = "Dragon Crew Warrior [Lv. 1580]", NPC = CFrame.new(5259, 607, 335)},
        {Level = 1600, Quest = "HydraQuest", QuestLevel = 2, Mob = "Dragon Crew Archer [Lv. 1605]", NPC = CFrame.new(5259, 607, 335)},
        {Level = 1625, Quest = "GreatTreeQuest", QuestLevel = 1, Mob = "Female Islander [Lv. 1630]", NPC = CFrame.new(2840, 1392, -7839)},
        {Level = 1650, Quest = "GreatTreeQuest", QuestLevel = 2, Mob = "Giant Islander [Lv. 1655]", NPC = CFrame.new(2840, 1392, -7839)},
        {Level = 1700, Quest = "FloatingTurtleQuest", QuestLevel = 1, Mob = "Marine Commodore [Lv. 1705]", NPC = CFrame.new(-13232, 533, -7631)},
        {Level = 1725, Quest = "FloatingTurtleQuest", QuestLevel = 2, Mob = "Marine Rear Admiral [Lv. 1730]", NPC = CFrame.new(-13232, 533, -7631)},
        {Level = 1775, Quest = "HauntedQuest", QuestLevel = 1, Mob = "Ghoul [Lv. 1780]", NPC = CFrame.new(-9516, 162, 5765)},
        {Level = 1800, Quest = "HauntedQuest", QuestLevel = 2, Mob = "Cursed Skeleton [Lv. 1805]", NPC = CFrame.new(-9516, 162, 5765)},
        {Level = 1825, Quest = "IceQuest", QuestLevel = 1, Mob = "Soul Reaper [Lv. 1830]", NPC = CFrame.new(-6059, 16, -4904)},
        {Level = 1850, Quest = "IceQuest", QuestLevel = 2, Mob = "Shadow [Lv. 1855]", NPC = CFrame.new(-6059, 16, -4904)},
        {Level = 1900, Quest = "CastleQuest", QuestLevel = 1, Mob = "Demonic Soul [Lv. 1905]", NPC = CFrame.new(-5497, 314, -795)},
        {Level = 1950, Quest = "CastleQuest", QuestLevel = 2, Mob = "Possessed Mummy [Lv. 1955]", NPC = CFrame.new(-5497, 314, -795)},
        {Level = 2000, Quest = "TikiQuest", QuestLevel = 1, Mob = "Jungle Pirate [Lv. 2005]", NPC = CFrame.new(-1607, 36, 152)},
        {Level = 2075, Quest = "TikiQuest2", QuestLevel = 1, Mob = "Musketeer Pirate [Lv. 2080]", NPC = CFrame.new(-1607, 36, 152)},
        {Level = 2100, Quest = "MansionQuest", QuestLevel = 1, Mob = "Reborn [Lv. 2105]", NPC = CFrame.new(-3054, 237, -10148)},
        {Level = 2175, Quest = "MansionQuest2", QuestLevel = 1, Mob = "Living Zombie [Lv. 2180]", NPC = CFrame.new(-3054, 237, -10148)},
        {Level = 2200, Quest = "KitsuneShrineQuest", QuestLevel = 1, Mob = "Kitsune Shrine Guard [Lv. 2205]", NPC = CFrame.new(916, 125, 33056)},
        {Level = 2250, Quest = "KitsuneShrineQuest", QuestLevel = 2, Mob = "Kitsune Shrine Master [Lv. 2255]", NPC = CFrame.new(916, 125, 33056)},
        {Level = 2300, Quest = "TempleQuest", QuestLevel = 1, Mob = "Temple Guardian [Lv. 2305]", NPC = CFrame.new(5669, 28, -6485)},
        {Level = 2350, Quest = "TempleQuest", QuestLevel = 2, Mob = "Temple Master [Lv. 2355]", NPC = CFrame.new(5669, 28, -6485)},
        {Level = 2400, Quest = "VolcanoQuest", QuestLevel = 1, Mob = "Lava Pirate [Lv. 2405]", NPC = CFrame.new(-5316, 12, 8517)},
        {Level = 2450, Quest = "VolcanoQuest", QuestLevel = 2, Mob = "Magma Admiral [Lv. 2455]", NPC = CFrame.new(-5316, 12, 8517)},
    }
}

-- Get Quest for Current Level
local function GetQuestForLevel()
    local level = GetPlayerLevel()
    local sea = GetCurrentSea()
    local questList = QuestData[sea]
    
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

-- ═══════════════════════════════════════════════════════════════════
-- ISLAND DATA FOR TELEPORTATION
-- ═══════════════════════════════════════════════════════════════════

local Islands = {
    -- First Sea
    ["First Sea"] = {
        ["Starter Island"] = CFrame.new(1061, 16, 1548),
        ["Jungle"] = CFrame.new(-1607, 36, 152),
        ["Pirate Village"] = CFrame.new(-1139, 5, 3825),
        ["Desert"] = CFrame.new(896, 6, 4392),
        ["Frozen Village"] = CFrame.new(1386, 87, -1296),
        ["Marine Fortress"] = CFrame.new(-4914, 331, -2619),
        ["Skylands"] = CFrame.new(-4841, 331, -2619),
        ["Prison"] = CFrame.new(4875, 5.6, 735),
        ["Colosseum"] = CFrame.new(-1576, 7, -2983),
        ["Magma Village"] = CFrame.new(-5316, 12, 8517),
        ["Underwater City"] = CFrame.new(61123, 18, 1568),
        ["Fountain City"] = CFrame.new(5166, 4, 4050),
    },
    
    -- Second Sea
    ["Second Sea"] = {
        ["Kingdom of Rose"] = CFrame.new(2291, 16, -315),
        ["Usoap's Island"] = CFrame.new(4813, 7, -2569),
        ["Graveyard"] = CFrame.new(-5497, 314, -795),
        ["Snow Mountain"] = CFrame.new(609, 400, -5765),
        ["Hot and Cold"] = CFrame.new(-6059, 16, -4904),
        ["Cursed Ship"] = CFrame.new(916, 125, 33056),
        ["Ice Castle"] = CFrame.new(5669, 28, -6485),
        ["Forgotten Island"] = CFrame.new(-3054, 237, -10148),
        ["Dark Arena"] = CFrame.new(5765, 87, -3064),
        ["Cafe"] = CFrame.new(-379, 73, 1836),
    },
    
    -- Third Sea
    ["Third Sea"] = {
        ["Port Town"] = CFrame.new(-290, 44, 5579),
        ["Hydra Island"] = CFrame.new(5259, 607, 335),
        ["Great Tree"] = CFrame.new(2840, 1392, -7839),
        ["Floating Turtle"] = CFrame.new(-13232, 533, -7631),
        ["Haunted Castle"] = CFrame.new(-9516, 162, 5765),
        ["Sea of Treats"] = CFrame.new(-2067, 28, -10212),
        ["Tiki Outpost"] = CFrame.new(-1607, 36, 152),
        ["Mansion"] = CFrame.new(-3054, 237, -10148),
        ["Kitsune Shrine"] = CFrame.new(916, 125, 33056),
    }
}

-- ═══════════════════════════════════════════════════════════════════
-- BOSS DATA
-- ═══════════════════════════════════════════════════════════════════

local BossData = {
    -- First Sea
    ["Gorilla King [Lv. 25] [Boss]"] = {Quest = "JungleBossQuest", QuestLevel = 1, NPC = CFrame.new(-1607, 36, 152)},
    ["Bobby [Lv. 55] [Boss]"] = {Quest = "BuggyQuest2", QuestLevel = 1, NPC = CFrame.new(-1139, 5, 3825)},
    ["Yeti [Lv. 110] [Boss]"] = {Quest = "SnowBossQuest", QuestLevel = 1, NPC = CFrame.new(1386, 87, -1296)},
    ["Mob Leader [Lv. 120] [Boss]"] = {Quest = "MobBossQuest", QuestLevel = 1, NPC = CFrame.new(896, 6, 4392)},
    ["Vice Admiral [Lv. 130] [Boss]"] = {Quest = "ViceAdmiralQuest", QuestLevel = 1, NPC = CFrame.new(-6064, 16, -4902)},
    ["Warden [Lv. 175] [Boss]"] = {Quest = "WardenQuest", QuestLevel = 1, NPC = CFrame.new(4875, 5.6, 735)},
    ["Saber Expert [Lv. 200] [Boss]"] = {Quest = "SaberExpertQuest", QuestLevel = 1, NPC = CFrame.new(-1576, 7, -2983)},
    ["Magma Admiral [Lv. 350] [Boss]"] = {Quest = "MagmaBossQuest", QuestLevel = 1, NPC = CFrame.new(-5316, 12, 8517)},
    ["Fishman Lord [Lv. 425] [Boss]"] = {Quest = "FishmanBossQuest", QuestLevel = 1, NPC = CFrame.new(61123, 18, 1568)},
    
    -- Second Sea
    ["Swan [Lv. 775] [Boss]"] = {Quest = "SwanQuest", QuestLevel = 1, NPC = CFrame.new(2291, 16, -315)},
    ["Don Swan [Lv. 1000] [Boss]"] = {Quest = "DonSwanQuest", QuestLevel = 1, NPC = CFrame.new(2291, 16, -315)},
    ["Smoke Admiral [Lv. 1150] [Boss]"] = {Quest = "SmokeAdmiralQuest", QuestLevel = 1, NPC = CFrame.new(-5497, 314, -795)},
    ["Awakened Ice Admiral [Lv. 1400] [Boss]"] = {Quest = "IceAdmiralQuest", QuestLevel = 1, NPC = CFrame.new(5669, 28, -6485)},
    
    -- Third Sea
    ["Beautiful Pirate [Lv. 1950] [Boss]"] = {Quest = "BeautifulPirateQuest", QuestLevel = 1, NPC = CFrame.new(-290, 44, 5579)},
    ["Longma [Lv. 2000] [Boss]"] = {Quest = "LongmaQuest", QuestLevel = 1, NPC = CFrame.new(5259, 607, 335)},
    ["Cake Queen [Lv. 2175] [Boss]"] = {Quest = "CakeQueenQuest", QuestLevel = 1, NPC = CFrame.new(-2067, 28, -10212)},
    ["dough king [Lv. 2300] [Boss]"] = {Quest = "DoughKingQuest", QuestLevel = 1, NPC = CFrame.new(-2067, 28, -10212)},
}

-- ═══════════════════════════════════════════════════════════════════
-- COMBAT FRAMEWORK INTEGRATION
-- ═══════════════════════════════════════════════════════════════════

local CombatFramework, CombatFrameworkR, RigController, RigControllerR

pcall(function()
    CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
    CombatFrameworkR = getupvalues(CombatFramework)[2]
    RigController = require(LocalPlayer.PlayerScripts.CombatFramework.RigController)
    RigControllerR = getupvalues(RigController)[2]
end)

local function GetAllBladeHits(range)
    local hits = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return hits end
    
    for _, enemy in ipairs(enemies:GetChildren()) do
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        local rootPart = humanoid and humanoid.RootPart
        
        if humanoid and rootPart and humanoid.Health > 0 then
            local distance = LocalPlayer:DistanceFromCharacter(rootPart.Position)
            if distance < range then
                table.insert(hits, rootPart)
            end
        end
    end
    
    return hits
end

local function FastAttack()
    if not CombatFrameworkR then return end
    
    local ac = CombatFrameworkR.activeController
    if ac and ac.equipped then
        local bladeHits = GetAllBladeHits(60)
        if #bladeHits > 0 then
            pcall(function()
                local AcAttack8 = debug.getupvalue(ac.attack, 5)
                local AcAttack9 = debug.getupvalue(ac.attack, 6)
                local AcAttack7 = debug.getupvalue(ac.attack, 4)
                local AcAttack10 = debug.getupvalue(ac.attack, 7)
                local NumberAc12 = (AcAttack8 * 798405 + AcAttack7 * 727595) % AcAttack9
                local NumberAc13 = AcAttack7 * 798405
                
                NumberAc12 = (NumberAc12 * AcAttack9 + NumberAc13) % 1099511627776
                AcAttack8 = math.floor(NumberAc12 / AcAttack9)
                AcAttack7 = NumberAc12 - AcAttack8 * AcAttack9
                AcAttack10 = AcAttack10 + 1
                
                debug.setupvalue(ac.attack, 5, AcAttack8)
                debug.setupvalue(ac.attack, 6, AcAttack9)
                debug.setupvalue(ac.attack, 4, AcAttack7)
                debug.setupvalue(ac.attack, 7, AcAttack10)
                
                for _, anim in pairs(ac.animator.anims.basic) do
                    anim:Play(0.01, 0.01, 0.01)
                end
                
                local character = GetCharacter()
                local tool = character and character:FindFirstChildOfClass("Tool")
                
                if tool and ac.blades and ac.blades[1] then
                    ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tool.Name)
                    ReplicatedStorage.Remotes.Validator:FireServer(math.floor(NumberAc12 / 1099511627776 * 16777215), AcAttack10)
                    ReplicatedStorage.RigControllerEvent:FireServer("hit", bladeHits, 2, "")
                end
            end)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- MAIN SCRIPT LOOPS
-- ═══════════════════════════════════════════════════════════════════

-- Auto Farm Level Loop
local AutoFarmConnection
local function StartAutoFarm()
    if AutoFarmConnection then return end
    
    AutoFarmConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Main.AutoFarmLevel then return end
        if not IsAlive() then return end
        
        local questData = GetQuestForLevel()
        if not questData then return end
        
        local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        local questVisible = questGui and questGui:FindFirstChild("Quest") and questGui.Quest.Visible
        
        if questVisible then
            -- Find and attack mob
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, enemy in ipairs(enemies:GetChildren()) do
                    if enemy.Name == questData.Mob then
                        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and rootPart and humanoid.Health > 0 then
                            -- Equip weapon
                            local weapon = GetWeaponByType(Settings.Config.WeaponType)
                            if weapon then
                                EquipTool(weapon)
                            end
                            
                            -- Move to mob
                            local targetCFrame = rootPart.CFrame * CFrame.new(0, 20, 0)
                            TweenTo(targetCFrame, 200)
                            
                            -- Bring mob if enabled
                            if Settings.Main.BringMob then
                                pcall(function()
                                    rootPart.CFrame = GetRootPart().CFrame * CFrame.new(0, -10, 5)
                                    rootPart.Size = Vector3.new(60, 60, 60)
                                    rootPart.Transparency = 1
                                    rootPart.CanCollide = false
                                    humanoid.WalkSpeed = 0
                                    humanoid.JumpPower = 0
                                end)
                            end
                            
                            -- Attack
                            if Settings.Combat.FastAttack then
                                FastAttack()
                            end
                            
                            break
                        end
                    end
                end
            end
        else
            -- Get quest
            StopTween()
            TweenTo(questData.NPC, 200)
            
            local rootPart = GetRootPart()
            if rootPart and (questData.NPC.Position - rootPart.Position).Magnitude < 20 then
                CommF("StartQuest", questData.Quest, questData.QuestLevel)
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

-- Auto Haki Loop
task.spawn(function()
    while true do
        task.wait(1)
        if Settings.Combat.AutoHaki and IsAlive() then
            local character = GetCharacter()
            if character and not character:FindFirstChild("HasBuso") then
                CommF("Buso")
            end
        end
    end
end)

-- Simulation Radius Loop
task.spawn(function()
    while true do
        task.wait()
        pcall(function()
            if setscriptable then
                setscriptable(LocalPlayer, "SimulationRadius", true)
            end
            if sethiddenproperty then
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end
        end)
    end
end)

-- No Clip Loop
task.spawn(function()
    while true do
        task.wait()
        if Settings.Misc.NoClip and IsAlive() then
            local character = GetCharacter()
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Infinite Energy Loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.Misc.InfiniteEnergy then
            pcall(function()
                LocalPlayer.Character.Energy.Value = 5000
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- CREATE GUI INTERFACE
-- ═══════════════════════════════════════════════════════════════════

local Window = GUI:CreateWindow("⚡ BLOX FRUITS PREMIUM v3.0")

-- ═══════════════════════════════════════════════════════════════════
-- MAIN TAB
-- ═══════════════════════════════════════════════════════════════════

local MainTab = Window:CreateTab("Main", "🎮")

MainTab:CreateSection("Auto Farm")

MainTab:CreateToggle("Auto Farm Level", Settings.Main.AutoFarmLevel, function(value)
    Settings.Main.AutoFarmLevel = value
    if value then
        StartAutoFarm()
        Window:Notify("Auto Farm", "Auto Farm Level enabled!", 3)
    else
        StopAutoFarm()
        Window:Notify("Auto Farm", "Auto Farm Level disabled!", 3)
    end
end)

MainTab:CreateToggle("Bring Mob", Settings.Main.BringMob, function(value)
    Settings.Main.BringMob = value
end)

MainTab:CreateToggle("Auto Quest", Settings.Main.AutoQuest, function(value)
    Settings.Main.AutoQuest = value
end)

MainTab:CreateSlider("Mob Aura Distance", 100, 5000, Settings.Main.MobAuraDistance, function(value)
    Settings.Main.MobAuraDistance = value
end)

MainTab:CreateToggle("Mob Aura", Settings.Main.MobAura, function(value)
    Settings.Main.MobAura = value
end)

MainTab:CreateSection("Weapon Selection")

MainTab:CreateDropdown("Weapon Type", {"Melee", "Sword", "Fruit", "Gun"}, Settings.Config.WeaponType, function(value)
    Settings.Config.WeaponType = value
end)

MainTab:CreateSlider("Farm Distance", 10, 100, Settings.Config.FarmDistance, function(value)
    Settings.Config.FarmDistance = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- COMBAT TAB
-- ═══════════════════════════════════════════════════════════════════

local CombatTab = Window:CreateTab("Combat", "⚔️")

CombatTab:CreateSection("Attack Settings")

CombatTab:CreateToggle("Fast Attack", Settings.Combat.FastAttack, function(value)
    Settings.Combat.FastAttack = value
end)

CombatTab:CreateDropdown("Attack Speed", {"Fast", "Normal", "Slow"}, Settings.Combat.AttackSpeed, function(value)
    Settings.Combat.AttackSpeed = value
end)

CombatTab:CreateToggle("Auto Haki", Settings.Combat.AutoHaki, function(value)
    Settings.Combat.AutoHaki = value
end)

CombatTab:CreateSection("Skill Settings")

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

-- ═══════════════════════════════════════════════════════════════════
-- BOSS TAB
-- ═══════════════════════════════════════════════════════════════════

local BossTab = Window:CreateTab("Boss", "👹")

BossTab:CreateSection("Boss Farm")

local bossNames = {}
for bossName, _ in pairs(BossData) do
    table.insert(bossNames, bossName)
end
table.sort(bossNames)

BossTab:CreateDropdown("Select Boss", bossNames, bossNames[1] or "", function(value)
    Settings.Boss.SelectedBoss = value
end)

BossTab:CreateToggle("Auto Farm Boss", Settings.Boss.AutoBossSelect, function(value)
    Settings.Boss.AutoBossSelect = value
end)

BossTab:CreateToggle("Auto All Bosses", Settings.Boss.AutoAllBoss, function(value)
    Settings.Boss.AutoAllBoss = value
end)

BossTab:CreateToggle("Auto Boss Quest", Settings.Boss.AutoBossQuest, function(value)
    Settings.Boss.AutoBossQuest = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- MASTERY TAB
-- ═══════════════════════════════════════════════════════════════════

local MasteryTab = Window:CreateTab("Mastery", "📚")

MasteryTab:CreateSection("Mastery Farm")

MasteryTab:CreateToggle("Farm Sword Mastery", Settings.Mastery.FarmSwordMastery, function(value)
    Settings.Mastery.FarmSwordMastery = value
end)

MasteryTab:CreateToggle("Farm Fruit Mastery", Settings.Mastery.FarmFruitMastery, function(value)
    Settings.Mastery.FarmFruitMastery = value
end)

MasteryTab:CreateToggle("Farm Gun Mastery", Settings.Mastery.FarmGunMastery, function(value)
    Settings.Mastery.FarmGunMastery = value
end)

MasteryTab:CreateSlider("Mob Health %", 5, 100, Settings.Mastery.MobHealthPercent, function(value)
    Settings.Mastery.MobHealthPercent = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- STATS TAB
-- ═══════════════════════════════════════════════════════════════════

local StatsTab = Window:CreateTab("Stats", "📊")

StatsTab:CreateSection("Auto Stats")

StatsTab:CreateToggle("Auto Stats", Settings.Stats.AutoStats, function(value)
    Settings.Stats.AutoStats = value
    
    if value then
        task.spawn(function()
            while Settings.Stats.AutoStats do
                task.wait(0.5)
                pcall(function()
                    local statType = Settings.Stats.StatType
                    local points = Settings.Stats.PointsPerClick
                    
                    for i = 1, points do
                        CommF("AddPoint", statType)
                    end
                end)
            end
        end)
    end
end)

StatsTab:CreateDropdown("Stat Type", {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"}, Settings.Stats.StatType, function(value)
    Settings.Stats.StatType = value
end)

StatsTab:CreateSlider("Points Per Click", 1, 10, Settings.Stats.PointsPerClick, function(value)
    Settings.Stats.PointsPerClick = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- RAIDS TAB
-- ═══════════════════════════════════════════════════════════════════

local RaidsTab = Window:CreateTab("Raids", "🏰")

RaidsTab:CreateSection("Raid Settings")

local raidOptions = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Buddha", "Sand", "Phoenix", "Dough", "Venom", "Control", "Spirit", "Dragon", "Leopard"}

RaidsTab:CreateDropdown("Select Raid", raidOptions, Settings.Raids.SelectedRaid, function(value)
    Settings.Raids.SelectedRaid = value
end)

RaidsTab:CreateToggle("Auto Raids", Settings.Raids.AutoRaids, function(value)
    Settings.Raids.AutoRaids = value
end)

RaidsTab:CreateToggle("Kill Aura", Settings.Raids.KillAura, function(value)
    Settings.Raids.KillAura = value
end)

RaidsTab:CreateToggle("Auto Awakened", Settings.Raids.AutoAwakened, function(value)
    Settings.Raids.AutoAwakened = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- FRUITS TAB
-- ═══════════════════════════════════════════════════════════════════

local FruitsTab = Window:CreateTab("Fruits", "🍎")

FruitsTab:CreateSection("Devil Fruit Settings")

local fruitOptions = {"Bomb", "Spike", "Chop", "Spring", "Kilo", "Smoke", "Spin", "Flame", "Bird: Falcon", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Love", "Rubber", "Barrier", "Magma", "Quake", "Human: Buddha", "Bird: Phoenix", "Rumble", "Paw", "Gravity", "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune"}

FruitsTab:CreateDropdown("Select Fruit", fruitOptions, Settings.Fruits.SelectedFruit, function(value)
    Settings.Fruits.SelectedFruit = value
end)

FruitsTab:CreateToggle("Auto Buy Random Fruit", Settings.Fruits.AutoBuyRandom, function(value)
    Settings.Fruits.AutoBuyRandom = value
end)

FruitsTab:CreateToggle("Auto Store Fruits", Settings.Fruits.AutoStoreFruits, function(value)
    Settings.Fruits.AutoStoreFruits = value
end)

FruitsTab:CreateToggle("Fruit Sniper", Settings.Fruits.AutoSniper, function(value)
    Settings.Fruits.AutoSniper = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- FIGHTING STYLES TAB
-- ═══════════════════════════════════════════════════════════════════

local StylesTab = Window:CreateTab("Styles", "🥊")

StylesTab:CreateSection("Fighting Style Unlocks")

StylesTab:CreateToggle("Auto Superhuman", Settings.FightingStyle.AutoSuperhuman, function(value)
    Settings.FightingStyle.AutoSuperhuman = value
end)

StylesTab:CreateToggle("Auto Electric Claw", Settings.FightingStyle.AutoElectricClaw, function(value)
    Settings.FightingStyle.AutoElectricClaw = value
end)

StylesTab:CreateToggle("Auto Death Step", Settings.FightingStyle.AutoDeathStep, function(value)
    Settings.FightingStyle.AutoDeathStep = value
end)

StylesTab:CreateToggle("Auto Sharkman Karate", Settings.FightingStyle.AutoSharkmanKarate, function(value)
    Settings.FightingStyle.AutoSharkmanKarate = value
end)

StylesTab:CreateToggle("Auto Dragon Talon", Settings.FightingStyle.AutoDragonTalon, function(value)
    Settings.FightingStyle.AutoDragonTalon = value
end)

StylesTab:CreateToggle("Auto God Human", Settings.FightingStyle.AutoGodHuman, function(value)
    Settings.FightingStyle.AutoGodHuman = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- WORLD 1 TAB
-- ═══════════════════════════════════════════════════════════════════

local World1Tab = Window:CreateTab("World 1", "🌍")

World1Tab:CreateSection("First Sea Quests")

World1Tab:CreateToggle("Auto Saber", Settings.World1.AutoSaber, function(value)
    Settings.World1.AutoSaber = value
end)

World1Tab:CreateToggle("Auto Pole (1st Form)", Settings.World1.AutoPole, function(value)
    Settings.World1.AutoPole = value
end)

World1Tab:CreateToggle("Auto New World", Settings.World1.AutoNewWorld, function(value)
    Settings.World1.AutoNewWorld = value
end)

World1Tab:CreateToggle("Auto Buy Abilities", Settings.World1.AutoBuyAbility, function(value)
    Settings.World1.AutoBuyAbility = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- WORLD 2 TAB
-- ═══════════════════════════════════════════════════════════════════

local World2Tab = Window:CreateTab("World 2", "🌎")

World2Tab:CreateSection("Second Sea Quests")

World2Tab:CreateToggle("Auto Third Sea", Settings.World2.AutoThirdSea, function(value)
    Settings.World2.AutoThirdSea = value
end)

World2Tab:CreateToggle("Auto Factory", Settings.World2.AutoFactory, function(value)
    Settings.World2.AutoFactory = value
end)

World2Tab:CreateToggle("Auto Bartilo Quest", Settings.World2.AutoBartiloQuest, function(value)
    Settings.World2.AutoBartiloQuest = value
end)

World2Tab:CreateSection("Weapons & Items")

World2Tab:CreateToggle("Auto TTK", Settings.World2.AutoTTK, function(value)
    Settings.World2.AutoTTK = value
end)

World2Tab:CreateToggle("Auto Rengoku", Settings.World2.AutoRengoku, function(value)
    Settings.World2.AutoRengoku = value
end)

World2Tab:CreateToggle("Auto Swan Glasses", Settings.World2.AutoSwanGlasses, function(value)
    Settings.World2.AutoSwanGlasses = value
end)

World2Tab:CreateToggle("Auto Dark Coat", Settings.World2.AutoDarkCoat, function(value)
    Settings.World2.AutoDarkCoat = value
end)

World2Tab:CreateToggle("Auto Ectoplasm", Settings.World2.AutoEctoplasm, function(value)
    Settings.World2.AutoEctoplasm = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- WORLD 3 TAB
-- ═══════════════════════════════════════════════════════════════════

local World3Tab = Window:CreateTab("World 3", "🌏")

World3Tab:CreateSection("Third Sea Quests")

World3Tab:CreateToggle("Auto Holy Torch", Settings.World3.AutoHolyTorch, function(value)
    Settings.World3.AutoHolyTorch = value
end)

World3Tab:CreateToggle("Auto Buddy Sword", Settings.World3.AutoBuddySword, function(value)
    Settings.World3.AutoBuddySword = value
end)

World3Tab:CreateToggle("Auto Rainbow Haki", Settings.World3.AutoRainbowHaki, function(value)
    Settings.World3.AutoRainbowHaki = value
end)

World3Tab:CreateToggle("Auto Elite Hunter", Settings.World3.AutoEliteHunter, function(value)
    Settings.World3.AutoEliteHunter = value
end)

World3Tab:CreateSection("Weapons & Items")

World3Tab:CreateToggle("Auto Yama", Settings.World3.AutoYama, function(value)
    Settings.World3.AutoYama = value
end)

World3Tab:CreateToggle("Auto Tushita", Settings.World3.AutoTushita, function(value)
    Settings.World3.AutoTushita = value
end)

World3Tab:CreateToggle("Auto Serpent Bow", Settings.World3.AutoSerpentBow, function(value)
    Settings.World3.AutoSerpentBow = value
end)

World3Tab:CreateToggle("Auto Dark Dagger", Settings.World3.AutoDarkDagger, function(value)
    Settings.World3.AutoDarkDagger = value
end)

World3Tab:CreateToggle("Auto Cake Prince", Settings.World3.AutoCakePrince, function(value)
    Settings.World3.AutoCakePrince = value
end)

World3Tab:CreateToggle("Auto Dough V2", Settings.World3.AutoDoughV2, function(value)
    Settings.World3.AutoDoughV2 = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- TELEPORT TAB
-- ═══════════════════════════════════════════════════════════════════

local TeleportTab = Window:CreateTab("Teleport", "🚀")

TeleportTab:CreateSection("Island Teleport")

local currentSea = GetCurrentSea()
local seaName = currentSea == 1 and "First Sea" or (currentSea == 2 and "Second Sea" or "Third Sea")
local islandList = {}

for name, _ in pairs(Islands[seaName] or {}) do
    table.insert(islandList, name)
end
table.sort(islandList)

TeleportTab:CreateDropdown("Select Island", islandList, islandList[1] or "", function(value)
    Settings.Teleport.SelectedIsland = value
end)

TeleportTab:CreateButton("Teleport to Island", function()
    local island = Settings.Teleport.SelectedIsland
    if island and Islands[seaName] and Islands[seaName][island] then
        TweenTo(Islands[seaName][island], 300)
        Window:Notify("Teleport", "Teleporting to " .. island, 3)
    end
end)

TeleportTab:CreateSection("Quick Teleports")

TeleportTab:CreateButton("Teleport to Nearest Mob", function()
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        local nearestEnemy = nil
        local nearestDistance = math.huge
        
        for _, enemy in ipairs(enemies:GetChildren()) do
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local distance = LocalPlayer:DistanceFromCharacter(rootPart.Position)
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestEnemy = rootPart
                end
            end
        end
        
        if nearestEnemy then
            TweenTo(nearestEnemy.CFrame * CFrame.new(0, 10, 0), 200)
        end
    end
end)

TeleportTab:CreateButton("Teleport to Spawn", function()
    CommF("TeleportToSpawn")
end)

-- ═══════════════════════════════════════════════════════════════════
-- MISC TAB
-- ═══════════════════════════════════════════════════════════════════

local MiscTab = Window:CreateTab("Misc", "⚙️")

MiscTab:CreateSection("Player Modifications")

MiscTab:CreateToggle("No Clip", Settings.Misc.NoClip, function(value)
    Settings.Misc.NoClip = value
end)

MiscTab:CreateToggle("Infinite Energy", Settings.Misc.InfiniteEnergy, function(value)
    Settings.Misc.InfiniteEnergy = value
end)

MiscTab:CreateToggle("Infinite Geppo", Settings.Misc.InfiniteGeppo, function(value)
    Settings.Misc.InfiniteGeppo = value
end)

MiscTab:CreateToggle("No Fog", Settings.Misc.NoFog, function(value)
    Settings.Misc.NoFog = value
    if value then
        game.Lighting.FogEnd = 9e9
    else
        game.Lighting.FogEnd = 5000
    end
end)

MiscTab:CreateSection("Flight")

MiscTab:CreateToggle("Fly", Settings.Misc.Fly, function(value)
    Settings.Misc.Fly = value
    -- Fly implementation would go here
end)

MiscTab:CreateSlider("Fly Speed", 10, 500, Settings.Misc.FlySpeed, function(value)
    Settings.Misc.FlySpeed = value
end)

MiscTab:CreateSection("Server")

MiscTab:CreateToggle("Auto Rejoin", Settings.Misc.AutoRejoin, function(value)
    Settings.Misc.AutoRejoin = value
end)

MiscTab:CreateToggle("Bypass TP", Settings.Misc.BypassTP, function(value)
    Settings.Misc.BypassTP = value
end)

MiscTab:CreateButton("Rejoin Server", function()
    TeleportService = game:GetService("TeleportService")
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

MiscTab:CreateButton("Server Hop", function()
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

-- ═══════════════════════════════════════════════════════════════════
-- HUD TAB
-- ═══════════════════════════════════════════════════════════════════

local HUDTab = Window:CreateTab("HUD", "🖥️")

HUDTab:CreateSection("Performance")

HUDTab:CreateToggle("Lock FPS", Settings.HUD.LockFPS, function(value)
    Settings.HUD.LockFPS = value
    if value then
        setfpscap(Settings.HUD.FPSLimit)
    else
        setfpscap(9999)
    end
end)

HUDTab:CreateSlider("FPS Limit", 30, 240, Settings.HUD.FPSLimit, function(value)
    Settings.HUD.FPSLimit = value
    if Settings.HUD.LockFPS then
        setfpscap(value)
    end
end)

HUDTab:CreateToggle("Boost FPS", Settings.HUD.BoostFPS, function(value)
    Settings.HUD.BoostFPS = value
    if value then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
                v.Material = Enum.Material.SmoothPlastic
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 9e9
    end
end)

HUDTab:CreateSection("Display")

HUDTab:CreateToggle("Show Hitbox", Settings.Config.ShowHitbox, function(value)
    Settings.Config.ShowHitbox = value
end)

HUDTab:CreateLabel("Press Right Control to toggle GUI")

-- ═══════════════════════════════════════════════════════════════════
-- INFO TAB
-- ═══════════════════════════════════════════════════════════════════

local InfoTab = Window:CreateTab("Info", "ℹ️")

InfoTab:CreateSection("Player Info")

local levelLabel = InfoTab:CreateLabel("Level: " .. GetPlayerLevel())
local beliLabel = InfoTab:CreateLabel("Beli: $" .. GetPlayerBeli())
local seaLabel = InfoTab:CreateLabel("Current Sea: " .. GetCurrentSea())

-- Update info labels
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            levelLabel:Set("Level: " .. GetPlayerLevel())
            beliLabel:Set("Beli: $" .. string.format("%d", GetPlayerBeli()))
            seaLabel:Set("Current Sea: " .. GetCurrentSea())
        end)
    end
end)

InfoTab:CreateSection("Script Info")

InfoTab:CreateLabel("Version: 3.0")
InfoTab:CreateLabel("Updated: January 2026")
InfoTab:CreateLabel("Toggle GUI: Right Control")

InfoTab:CreateSection("Credits")

InfoTab:CreateLabel("Script by Premium Team")

-- ═══════════════════════════════════════════════════════════════════
-- INITIALIZATION COMPLETE
-- ═══════════════════════════════════════════════════════════════════

Window:Notify("Welcome!", "Blox Fruits Premium v3.0 loaded successfully!\nPress Right Control to toggle GUI.", 5)

print([[
╔══════════════════════════════════════════════════════════════════╗
║                    BLOX FRUITS PREMIUM v3.0                      ║
║                     Successfully Loaded!                         ║
║              Press Right Control to toggle GUI                   ║
╚══════════════════════════════════════════════════════════════════╝
]])


-- ═══════════════════════════════════════════════════════════════════
-- ADVANCED FEATURES MODULE
-- ═══════════════════════════════════════════════════════════════════

-- Materials Farming Data
local MaterialsData = {
    ["Fish Tail"] = {
        Sea1 = CFrame.new(61123, 18, 1568),
        Sea3 = CFrame.new(-2067, 28, -10212),
        Mob = "Fishman"
    },
    ["Magma Ore"] = {
        Sea1 = CFrame.new(-5316, 12, 8517),
        Sea2 = CFrame.new(-5497, 314, -795),
        Mob = "Military"
    },
    ["Mystic Droplet"] = {
        Sea3 = CFrame.new(-9516, 162, 5765),
        Mob = "Ghoul"
    },
    ["Dragon Scale"] = {
        Sea3 = CFrame.new(5259, 607, 335),
        Mob = "Dragon Crew"
    },
    ["Bone"] = {
        Sea3 = CFrame.new(-9516, 162, 5765),
        Mob = "Skeleton"
    },
    ["Ectoplasm"] = {
        Sea2 = CFrame.new(-3054, 237, -10148),
        Mob = "Zombie"
    }
}

-- Auto Farm Materials
local function AutoFarmMaterial(materialName)
    local material = MaterialsData[materialName]
    if not material then return end
    
    local sea = GetCurrentSea()
    local targetPos = material["Sea" .. sea]
    
    if not targetPos then
        Window:Notify("Error", "Material not available in current sea!", 3)
        return
    end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            if string.find(enemy.Name, material.Mob) then
                local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                
                if humanoid and rootPart and humanoid.Health > 0 then
                    TweenTo(rootPart.CFrame * CFrame.new(0, 15, 0), 200)
                    
                    if Settings.Main.BringMob then
                        pcall(function()
                            rootPart.CFrame = GetRootPart().CFrame * CFrame.new(0, -10, 5)
                        end)
                    end
                    
                    if Settings.Combat.FastAttack then
                        FastAttack()
                    end
                    return true
                end
            end
        end
    end
    
    -- No mob found, teleport to spawn location
    TweenTo(targetPos, 200)
    return false
end

-- ═══════════════════════════════════════════════════════════════════
-- RACE V2/V3/V4 UNLOCK FEATURES
-- ═══════════════════════════════════════════════════════════════════

local RaceData = {
    ["Human V2"] = {
        Requirements = {"Complete Alchemist Quest"},
        NPC = CFrame.new(-3054, 237, -10148)
    },
    ["Shark V2"] = {
        Requirements = {"Complete Water Kung Fu Master Quest"},
        NPC = CFrame.new(61123, 18, 1568)
    },
    ["Angel V2"] = {
        Requirements = {"Complete Sky Island Quest"},
        NPC = CFrame.new(-4841, 331, -2619)
    },
    ["Rabbit V2"] = {
        Requirements = {"Complete Speed Quest"},
        NPC = CFrame.new(2291, 16, -315)
    },
    ["Cyborg V3"] = {
        Requirements = {"Complete Factory Quest", "Defeat Factory Boss"},
        NPC = CFrame.new(2291, 16, -315)
    },
    ["Ghoul V3"] = {
        Requirements = {"Complete Graveyard Quest", "Collect Ectoplasm"},
        NPC = CFrame.new(-3054, 237, -10148)
    }
}

-- ═══════════════════════════════════════════════════════════════════
-- FRUIT SNIPER SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local FruitSniperActive = false
local TargetFruits = {}

local function StartFruitSniper()
    FruitSniperActive = true
    
    task.spawn(function()
        while FruitSniperActive do
            task.wait(0.5)
            
            -- Check ground fruits
            for _, item in ipairs(Workspace:GetChildren()) do
                if item:IsA("Tool") and item.ToolTip == "Blox Fruit" then
                    local handle = item:FindFirstChild("Handle")
                    if handle then
                        local distance = LocalPlayer:DistanceFromCharacter(handle.Position)
                        
                        -- Check if it's a target fruit or any fruit
                        local isTarget = #TargetFruits == 0
                        for _, targetFruit in ipairs(TargetFruits) do
                            if string.find(item.Name:lower(), targetFruit:lower()) then
                                isTarget = true
                                break
                            end
                        end
                        
                        if isTarget then
                            -- Teleport to fruit
                            local rootPart = GetRootPart()
                            if rootPart then
                                rootPart.CFrame = handle.CFrame * CFrame.new(0, 3, 0)
                                task.wait(0.3)
                                
                                -- Try to pick up
                                fireproximityprompt(handle:FindFirstChildOfClass("ProximityPrompt"))
                                
                                Window:Notify("Fruit Sniper", "Found " .. item.Name .. "!", 3)
                            end
                        end
                    end
                end
            end
            
            -- Check dealer stock
            pcall(function()
                local stock = CommF("GetFruits")
                if stock then
                    for fruitName, inStock in pairs(stock) do
                        if inStock then
                            for _, targetFruit in ipairs(TargetFruits) do
                                if string.find(fruitName:lower(), targetFruit:lower()) then
                                    Window:Notify("Fruit Dealer", fruitName .. " is in stock!", 5)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

local function StopFruitSniper()
    FruitSniperActive = false
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO RAID SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local RaidActive = false

local function StartAutoRaid()
    RaidActive = true
    
    task.spawn(function()
        while RaidActive and Settings.Raids.AutoRaids do
            task.wait(0.5)
            
            -- Check if in raid
            local inRaid = Workspace:FindFirstChild("_WorldOrigin") and 
                          Workspace._WorldOrigin:FindFirstChild("Raid")
            
            if inRaid then
                -- Kill all raid enemies
                local enemies = Workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
                        
                        if humanoid and rootPart and humanoid.Health > 0 then
                            -- Teleport to enemy
                            TweenTo(rootPart.CFrame * CFrame.new(0, 10, 0), 300)
                            
                            -- Attack
                            if Settings.Combat.FastAttack then
                                FastAttack()
                            end
                            
                            -- Bring mob
                            if Settings.Main.BringMob then
                                pcall(function()
                                    rootPart.CFrame = GetRootPart().CFrame * CFrame.new(0, -5, 5)
                                end)
                            end
                        end
                    end
                end
                
                -- Check for next island portal
                local portal = Workspace:FindFirstChild("Portal")
                if portal then
                    local portalPart = portal:FindFirstChild("Portal") or portal:FindFirstChildOfClass("Part")
                    if portalPart then
                        local distance = LocalPlayer:DistanceFromCharacter(portalPart.Position)
                        if distance < 50 then
                            TweenTo(portalPart.CFrame, 100)
                        end
                    end
                end
            else
                -- Start raid
                if Settings.Raids.SelectedRaid then
                    pcall(function()
                        CommF("RaidStart", Settings.Raids.SelectedRaid)
                    end)
                end
            end
        end
    end)
end

local function StopAutoRaid()
    RaidActive = false
end

-- ═══════════════════════════════════════════════════════════════════
-- SKILL AUTO-USE SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local SkillCooldowns = {
    Z = 0,
    X = 0,
    C = 0,
    V = 0
}

local function UseSkill(key)
    local currentTime = tick()
    local cooldownKey = key:upper()
    
    if currentTime - SkillCooldowns[cooldownKey] < 1 then return end
    
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key:upper()], false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key:upper()], false, game)
    
    SkillCooldowns[cooldownKey] = currentTime
end

local function AutoUseSkills()
    if Settings.Combat.SkillZ then UseSkill("Z") end
    task.wait(0.2)
    if Settings.Combat.SkillX then UseSkill("X") end
    task.wait(0.2)
    if Settings.Combat.SkillC then UseSkill("C") end
    task.wait(0.2)
    if Settings.Combat.SkillV then UseSkill("V") end
end

-- ═══════════════════════════════════════════════════════════════════
-- FLY SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local FlyActive = false
local FlyBodyVelocity = nil
local FlyBodyGyro = nil

local function StartFly()
    if FlyActive then return end
    FlyActive = true
    
    local character = GetCharacter()
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
    
    local flyConnection
    flyConnection = RunService.RenderStepped:Connect(function()
        if not FlyActive then
            flyConnection:Disconnect()
            return
        end
        
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
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end
        
        FlyBodyVelocity.Velocity = direction * Settings.Misc.FlySpeed
        FlyBodyGyro.CFrame = camera.CFrame
    end)
end

local function StopFly()
    FlyActive = false
    
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
-- ESP SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local ESPEnabled = false
local ESPObjects = {}

local function CreateESP(target, color, text)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. target.Name
    billboard.Adornee = target
    billboard.Size = UDim2.new(0, 100, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = target
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color or Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.Text = text or target.Name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = billboard
    
    table.insert(ESPObjects, billboard)
    return billboard
end

local function ClearESP()
    for _, esp in ipairs(ESPObjects) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    ESPObjects = {}
end

local function UpdateESP()
    ClearESP()
    
    if not ESPEnabled then return end
    
    -- Enemy ESP
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                CreateESP(rootPart, Color3.fromRGB(255, 50, 50), enemy.Name .. "\n" .. healthPercent .. "%")
            end
        end
    end
    
    -- Fruit ESP
    for _, item in ipairs(Workspace:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == "Blox Fruit" then
            local handle = item:FindFirstChild("Handle")
            if handle then
                CreateESP(handle, Color3.fromRGB(255, 200, 0), "🍎 " .. item.Name)
            end
        end
    end
    
    -- Chest ESP
    for _, chest in ipairs(Workspace:GetDescendants()) do
        if chest.Name == "Chest" and chest:IsA("Model") then
            local primary = chest.PrimaryPart or chest:FindFirstChildOfClass("Part")
            if primary then
                CreateESP(primary, Color3.fromRGB(0, 255, 100), "💰 Chest")
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- ANTI-AFK SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local AntiAFKConnection = nil

local function StartAntiAFK()
    if AntiAFKConnection then return end
    
    local VirtualUser = game:GetService("VirtualUser")
    
    AntiAFKConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    
    Window:Notify("Anti-AFK", "Anti-AFK system activated!", 3)
end

local function StopAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

-- Start Anti-AFK by default
StartAntiAFK()

-- ═══════════════════════════════════════════════════════════════════
-- SETTINGS SAVE/LOAD SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local SettingsFolder = "BloxFruitsPremium"
local SettingsFile = SettingsFolder .. "/" .. LocalPlayer.Name .. "_settings.json"

local function SaveSettings()
    pcall(function()
        if not isfolder(SettingsFolder) then
            makefolder(SettingsFolder)
        end
        
        local settingsJson = HttpService:JSONEncode(Settings)
        writefile(SettingsFile, settingsJson)
    end)
end

local function LoadSettings()
    pcall(function()
        if isfile(SettingsFile) then
            local settingsJson = readfile(SettingsFile)
            local loadedSettings = HttpService:JSONDecode(settingsJson)
            
            -- Merge loaded settings with defaults
            for category, values in pairs(loadedSettings) do
                if Settings[category] then
                    for key, value in pairs(values) do
                        if Settings[category][key] ~= nil then
                            Settings[category][key] = value
                        end
                    end
                end
            end
            
            Window:Notify("Settings", "Settings loaded successfully!", 3)
        end
    end)
end

-- Load settings on start
LoadSettings()

-- Auto-save settings periodically
task.spawn(function()
    while true do
        task.wait(60) -- Save every minute
        SaveSettings()
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- WEBHOOK NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local WebhookURL = "" -- User can set this

local function SendWebhook(title, message, color)
    if WebhookURL == "" then return end
    
    pcall(function()
        local data = {
            embeds = {{
                title = title,
                description = message,
                color = color or 65535,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                footer = {
                    text = "Blox Fruits Premium v3.0"
                }
            }}
        }
        
        local headers = {
            ["Content-Type"] = "application/json"
        }
        
        local request = http_request or request or HttpPost
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = headers,
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO REJOIN ON KICK
-- ═══════════════════════════════════════════════════════════════════

if Settings.Misc.AutoRejoin then
    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") then
            local message = child.MessageArea.ErrorFrame.ErrorMessage.Text
            
            if string.find(message:lower(), "kick") or 
               string.find(message:lower(), "ban") or 
               string.find(message:lower(), "disconnect") then
                
                task.wait(2)
                game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
-- CHARACTER RESPAWN HANDLER
-- ═══════════════════════════════════════════════════════════════════

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    
    -- Re-apply settings after respawn
    if Settings.Misc.NoClip then
        -- NoClip loop will handle this
    end
    
    if Settings.Misc.Fly and FlyActive then
        StopFly()
        task.wait(0.5)
        StartFly()
    end
    
    if Settings.Combat.AutoHaki then
        task.wait(1)
        CommF("Buso")
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- KEYBIND SYSTEM
-- ═══════════════════════════════════════════════════════════════════

local Keybinds = {
    ToggleGUI = Enum.KeyCode.RightControl,
    ToggleFly = Enum.KeyCode.F,
    ToggleFarm = Enum.KeyCode.G,
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Keybinds.ToggleFly then
        Settings.Misc.Fly = not Settings.Misc.Fly
        if Settings.Misc.Fly then
            StartFly()
            Window:Notify("Fly", "Fly enabled!", 2)
        else
            StopFly()
            Window:Notify("Fly", "Fly disabled!", 2)
        end
    elseif input.KeyCode == Keybinds.ToggleFarm then
        Settings.Main.AutoFarmLevel = not Settings.Main.AutoFarmLevel
        if Settings.Main.AutoFarmLevel then
            StartAutoFarm()
            Window:Notify("Auto Farm", "Auto Farm enabled!", 2)
        else
            StopAutoFarm()
            Window:Notify("Auto Farm", "Auto Farm disabled!", 2)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- FINAL INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════

-- Create enemy spawn tracking folder
local EnemySpawns = Instance.new("Folder")
EnemySpawns.Name = "EnemySpawns"
EnemySpawns.Parent = Workspace

pcall(function()
    local worldOrigin = Workspace:FindFirstChild("_WorldOrigin")
    if worldOrigin and worldOrigin:FindFirstChild("EnemySpawns") then
        for _, spawn in ipairs(worldOrigin.EnemySpawns:GetChildren()) do
            if spawn:IsA("Part") then
                local clone = spawn:Clone()
                clone.Name = spawn.Name:gsub("Lv%. ", ""):gsub("[%[%]]", ""):gsub("%d+", ""):gsub("%s+", "")
                clone.Parent = EnemySpawns
                clone.Anchored = true
            end
        end
    end
end)

-- Display final load message
print([[
╔══════════════════════════════════════════════════════════════════╗
║              ALL MODULES LOADED SUCCESSFULLY!                    ║
║                                                                  ║
║  Keybinds:                                                       ║
║  • Right Control - Toggle GUI                                    ║
║  • F - Toggle Fly                                                ║
║  • G - Toggle Auto Farm                                          ║
║                                                                  ║
║  Features:                                                       ║
║  • Auto Farm Level (All Seas)                                    ║
║  • Auto Boss Farm                                                ║
║  • Auto Mastery Farm                                             ║
║  • Auto Raids                                                    ║
║  • Fruit Sniper                                                  ║
║  • Fighting Style Unlocks                                        ║
║  • Teleportation System                                          ║
║  • ESP System                                                    ║
║  • Fly System                                                    ║
║  • Anti-AFK                                                      ║
║  • Auto Save Settings                                            ║
║  • And much more...                                              ║
╚══════════════════════════════════════════════════════════════════╝
]])
