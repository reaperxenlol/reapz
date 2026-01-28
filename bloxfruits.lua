--[[
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                    REAPER HUB - Enhanced Edition                   ║
    ║                        Blox Fruits Script                          ║
    ║                                                                    ║
    ║  Features:                                                         ║
    ║  • Modern UI matching reference design (Dark sidebar theme)        ║
    ║  • Full English translation                                        ║
    ║  • Config system for saving/loading settings                       ║
    ║  • Auto-select Pirates on startup                                  ║
    ║  • Press Right Control to toggle UI                                ║
    ╚═══════════════════════════════════════════════════════════════════╝
]]

-- ═══════════════════════════════════════════════════════════════════
-- AUTO SELECT PIRATES ON STARTUP
-- ═══════════════════════════════════════════════════════════════════
task.spawn(function()
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui", 10)
        if playerGui then
            local mainGui = playerGui:WaitForChild("Main", 10)
            if mainGui then
                local chooseTeam = mainGui:FindFirstChild("ChooseTeam") or mainGui:FindFirstChild("TeamSelect")
                if chooseTeam and chooseTeam.Visible then
                    task.wait(1)
                    for _, child in pairs(chooseTeam:GetDescendants()) do
                        if child:IsA("TextButton") or child:IsA("ImageButton") then
                            local text = child:FindFirstChildOfClass("TextLabel")
                            if (text and string.lower(text.Text):find("pirate")) or 
                               string.lower(child.Name):find("pirate") then
                                pcall(function() firesignal(child.MouseButton1Click) end)
                                break
                            end
                        end
                    end
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
                    end)
                end
            end
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════
-- SERVICES & VARIABLES
-- ═══════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local WS = workspace

-- World Detection
local World1, World2, World3 = false, false, false
if game.PlaceId == 2753915549 then World1 = true
elseif game.PlaceId == 4442272183 then World2 = true
elseif game.PlaceId == 7449423635 then World3 = true
end

-- Global Settings
_G.ToggleKey = Enum.KeyCode.RightControl
_G.Color = Color3.fromRGB(45, 45, 45)

local TweenSpeed = 250
local BypassTP = false
local StartBring = false
local MonFarm = ""
local PosMon = CFrame.new()
local isTeleporting = false

-- ═══════════════════════════════════════════════════════════════════
-- CONFIGURATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════
local ConfigSystem = {}
ConfigSystem.Settings = {}
ConfigSystem.FileName = "ReaperHub_Config.json"

function ConfigSystem:GetFilePath()
    if isfolder and isfile and writefile and readfile then
        if not isfolder("ReaperHub") then
            makefolder("ReaperHub")
        end
        return "ReaperHub/" .. self.FileName
    end
    return nil
end

function ConfigSystem:Save()
    local path = self:GetFilePath()
    if path then
        pcall(function()
            local json = HttpService:JSONEncode(self.Settings)
            writefile(path, json)
        end)
    end
end

function ConfigSystem:Load()
    local path = self:GetFilePath()
    if path and isfile(path) then
        pcall(function()
            local content = readfile(path)
            self.Settings = HttpService:JSONDecode(content)
        end)
    end
    return self.Settings
end

function ConfigSystem:Set(key, value)
    self.Settings[key] = value
    self:Save()
end

function ConfigSystem:Get(key, default)
    if self.Settings[key] ~= nil then
        return self.Settings[key]
    end
    return default
end

ConfigSystem:Load()

-- ═══════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end

local function isnil(thing)
    return (thing == nil)
end

local function WaitHRP(plr)
    local char = plr.Character
    if char then
        return char:WaitForChild("HumanoidRootPart")
    end
end

local function topos(Pos)
    if not _G.StopTween then
        pcall(function()
            local Distance = (Pos.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            TweenService:Create(
                LocalPlayer.Character.HumanoidRootPart,
                TweenInfo.new(Distance/TweenSpeed, Enum.EasingStyle.Linear),
                {CFrame = Pos}
            ):Play()
        end)
    end
end

local function TP1(Pos)
    topos(Pos)
end

local function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip then
        if LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            local Tool = LocalPlayer.Backpack:FindFirstChild(ToolSe)
            task.wait(0.1)
            LocalPlayer.Character.Humanoid:EquipTool(Tool)
        end
    end
end

local function UnEquipWeapon(Weapon)
    if LocalPlayer.Character:FindFirstChild(Weapon) then
        _G.NotAutoEquip = true
        task.wait(0.5)
        LocalPlayer.Character:FindFirstChild(Weapon).Parent = LocalPlayer.Backpack
        task.wait(0.1)
        _G.NotAutoEquip = false
    end
end

local function AutoHaki()
    local character = LocalPlayer.Character
    if character and not character:FindFirstChild("HasBuso") then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
        end)
    end
end

local function StopTween(target)
    if not target then
        _G.StopTween = true
        task.wait(0.2)
        pcall(function()
            topos(LocalPlayer.Character.HumanoidRootPart.CFrame)
        end)
        task.wait(0.2)
        pcall(function()
            if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                LocalPlayer.Character.HumanoidRootPart.BodyClip:Destroy()
            end
        end)
        _G.StopTween = false
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- QUEST SYSTEM (CheckQuest function)
-- ═══════════════════════════════════════════════════════════════════
local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon

function CheckQuest()
    local MyLevel = LocalPlayer.Data.Level.Value
    
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            CFrameMon = CFrame.new(1045.96, 27.00, 1560.82)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1448.51, 67.85, 11.46)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1129.88, 40.46, -525.42)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1103.51, 13.75, 3896.09)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1140.08, 14.80, 4322.92)
        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359)
            CFrameMon = CFrame.new(924.79, 6.44, 4481.58)
        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359)
            CFrameMon = CFrame.new(1608.28, 8.61, 4371.00)
        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            CFrameMon = CFrame.new(1354.34, 87.27, -1393.94)
        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            CFrameMon = CFrame.new(1201.64, 144.57, -1550.06)
        -- Continue for higher levels...
        end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then
            Mon = "Raider"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7186508, 1836.18848)
            CFrameMon = CFrame.new(-379.54, 71.71, 1836.18)
        -- Continue for World 2 levels...
        end
    elseif World3 then
        if MyLevel >= 1500 and MyLevel <= 1524 then
            Mon = "Pirate Millionaire"
            LevelQuest = 1
            NameQuest = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-289.57, 43.91, 5580.98)
            CFrameMon = CFrame.new(-118.80, 55.48, 5649.17)
        -- Continue for World 3 levels...
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- MODERN UI LIBRARY (Matching Reference Design)
-- ═══════════════════════════════════════════════════════════════════
local ReaperLib = {}
ReaperLib.__index = ReaperLib

function ReaperLib:Create()
    local Library = setmetatable({}, ReaperLib)
    Library.Tabs = {}
    Library.CurrentTab = nil
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReaperHub_" .. tostring(math.random(100000, 999999))
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    pcall(function()
        if syn then syn.protect_gui(ScreenGui) end
    end)
    
    Library.ScreenGui = ScreenGui
    
    -- Main Frame (Dark theme matching reference)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    Library.MainFrame = MainFrame
    
    -- Header Bar
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 60)
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = Header
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Parent = Header
    HeaderFix.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 1, -10)
    HeaderFix.Size = UDim2.new(1, 0, 0, 10)
    
    -- Avatar
    local Avatar = Instance.new("ImageLabel")
    Avatar.Parent = Header
    Avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Avatar.Position = UDim2.new(0, 15, 0.5, -20)
    Avatar.Size = UDim2.new(0, 40, 0, 40)
    Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Header
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 65, 0, 10)
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "[R] REAPER HUB"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Subtitle
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Parent = Header
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Position = UDim2.new(0, 65, 0, 30)
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 15)
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.Text = "Blox Fruits | V2"
    SubtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    SubtitleLabel.TextSize = 12
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Player Name
    local PlayerName = Instance.new("TextLabel")
    PlayerName.Parent = Header
    PlayerName.BackgroundTransparency = 1
    PlayerName.Position = UDim2.new(0, 280, 0, 10)
    PlayerName.Size = UDim2.new(0, 150, 0, 20)
    PlayerName.Font = Enum.Font.GothamBold
    PlayerName.Text = LocalPlayer.DisplayName
    PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerName.TextSize = 14
    PlayerName.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Player ID
    local PlayerID = Instance.new("TextLabel")
    PlayerID.Parent = Header
    PlayerID.BackgroundTransparency = 1
    PlayerID.Position = UDim2.new(0, 280, 0, 30)
    PlayerID.Size = UDim2.new(0, 200, 0, 15)
    PlayerID.Font = Enum.Font.Gotham
    PlayerID.Text = "ID: " .. LocalPlayer.UserId
    PlayerID.TextColor3 = Color3.fromRGB(100, 100, 100)
    PlayerID.TextSize = 11
    PlayerID.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Header
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    CloseBtn.Position = UDim2.new(1, -45, 0.5, -12)
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 12
    CloseBtn.AutoButtonColor = false
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 6)
    CloseBtnCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Parent = Header
    MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
    MinBtn.Position = UDim2.new(1, -75, 0.5, -12)
    MinBtn.Size = UDim2.new(0, 24, 0, 24)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 16
    MinBtn.AutoButtonColor = false
    
    local MinBtnCorner = Instance.new("UICorner")
    MinBtnCorner.CornerRadius = UDim.new(0, 6)
    MinBtnCorner.Parent = MinBtn
    
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            MainFrame:TweenSize(UDim2.new(0, 800, 0, 60), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
        else
            MainFrame:TweenSize(UDim2.new(0, 800, 0, 500), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
        end
    end)
    
    -- Sidebar (Left navigation panel)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.Size = UDim2.new(0, 160, 1, -60)
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 10)
    TabContainer.Size = UDim2.new(1, 0, 1, -10)
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 5)
    
    Library.TabContainer = TabContainer
    
    -- Content Area (Right panel)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 160, 0, 60)
    ContentArea.Size = UDim2.new(1, -160, 1, -60)
    
    Library.ContentArea = ContentArea
    
    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
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
    
    Header.InputChanged:Connect(function(input)
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
    
    -- Toggle visibility with keybind
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == _G.ToggleKey then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)
    
    return Library
end

function ReaperLib:AddTab(name, icon)
    local Tab = {}
    Tab.Name = name
    Tab.Sections = {}
    
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Tab"
    TabBtn.Parent = self.TabContainer
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.Text = ""
    TabBtn.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn
    
    -- Tab Icon
    local TabIcon = Instance.new("TextLabel")
    TabIcon.Parent = TabBtn
    TabIcon.BackgroundTransparency = 1
    TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
    TabIcon.Size = UDim2.new(0, 16, 0, 16)
    TabIcon.Font = Enum.Font.GothamBold
    TabIcon.Text = icon or "[M]"
    TabIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    TabIcon.TextSize = 10
    
    -- Tab Label
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Parent = TabBtn
    TabLabel.BackgroundTransparency = 1
    TabLabel.Position = UDim2.new(0, 30, 0, 0)
    TabLabel.Size = UDim2.new(1, -35, 1, 0)
    TabLabel.Font = Enum.Font.Gotham
    TabLabel.Text = name
    TabLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabLabel.TextSize = 13
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Tab Content Page
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = name .. "Page"
    TabPage.Parent = self.ContentArea
    TabPage.BackgroundTransparency = 1
    TabPage.Position = UDim2.new(0, 15, 0, 15)
    TabPage.Size = UDim2.new(1, -30, 1, -30)
    TabPage.ScrollBarThickness = 4
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 65)
    TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabPage.Visible = false
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = TabPage
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 10)
    
    Tab.Button = TabBtn
    Tab.Page = TabPage
    Tab.Label = TabLabel
    Tab.Icon = TabIcon
    
    -- Tab Selection
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Page.Visible = false
            t.Button.BackgroundTransparency = 1
            t.Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            t.Icon.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
        Tab.Page.Visible = true
        Tab.Button.BackgroundTransparency = 0
        Tab.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
        Tab.Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
        self.CurrentTab = Tab
    end)
    
    -- Hover effects
    TabBtn.MouseEnter:Connect(function()
        if self.CurrentTab ~= Tab then
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        end
    end)
    
    TabBtn.MouseLeave:Connect(function()
        if self.CurrentTab ~= Tab then
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end
    end)
    
    table.insert(self.Tabs, Tab)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        TabBtn.BackgroundTransparency = 0
        TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabPage.Visible = true
        self.CurrentTab = Tab
    end
    
    -- Section creation function
    function Tab:AddSection(sectionName)
        local Section = {}
        
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = sectionName .. "Section"
        SectionFrame.Parent = TabPage
        SectionFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        SectionFrame.Size = UDim2.new(1, 0, 0, 0)
        SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 8)
        SectionCorner.Parent = SectionFrame
        
        -- Section Header
        local SectionHeader = Instance.new("TextLabel")
        SectionHeader.Parent = SectionFrame
        SectionHeader.BackgroundTransparency = 1
        SectionHeader.Position = UDim2.new(0, 15, 0, 10)
        SectionHeader.Size = UDim2.new(1, -30, 0, 20)
        SectionHeader.Font = Enum.Font.GothamBold
        SectionHeader.Text = sectionName
        SectionHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionHeader.TextSize = 14
        SectionHeader.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Section Content
        local SectionContent = Instance.new("Frame")
        SectionContent.Parent = SectionFrame
        SectionContent.BackgroundTransparency = 1
        SectionContent.Position = UDim2.new(0, 15, 0, 35)
        SectionContent.Size = UDim2.new(1, -30, 0, 0)
        SectionContent.AutomaticSize = Enum.AutomaticSize.Y
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = SectionContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = SectionContent
        ContentPadding.PaddingBottom = UDim.new(0, 15)
        
        Section.Frame = SectionFrame
        Section.Content = SectionContent
        
        -- Toggle Element (Modern switch style matching reference)
        function Section:AddToggle(toggleName, default, callback)
            local savedValue = ConfigSystem:Get(toggleName, default)
            local toggled = savedValue
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = SectionContent
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleLabel.TextSize = 13
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Modern Toggle Switch
            local SwitchBg = Instance.new("Frame")
            SwitchBg.Parent = ToggleFrame
            SwitchBg.BackgroundColor3 = toggled and Color3.fromRGB(80, 180, 120) or Color3.fromRGB(60, 60, 65)
            SwitchBg.Position = UDim2.new(1, -55, 0.5, -12)
            SwitchBg.Size = UDim2.new(0, 44, 0, 24)
            
            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = SwitchBg
            
            local SwitchCircle = Instance.new("Frame")
            SwitchCircle.Parent = SwitchBg
            SwitchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SwitchCircle.Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            SwitchCircle.Size = UDim2.new(0, 20, 0, 20)
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = SwitchCircle
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Parent = ToggleFrame
            ToggleBtn.BackgroundTransparency = 1
            ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
            ToggleBtn.Text = ""
            
            local function updateToggle()
                TweenService:Create(SwitchBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = toggled and Color3.fromRGB(80, 180, 120) or Color3.fromRGB(60, 60, 65)
                }):Play()
                TweenService:Create(SwitchCircle, TweenInfo.new(0.2), {
                    Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                }):Play()
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                ConfigSystem:Set(toggleName, toggled)
                updateToggle()
                if callback then callback(toggled) end
            end)
            
            if savedValue and callback then
                task.spawn(function() callback(savedValue) end)
            end
            
            return {
                Set = function(_, value)
                    toggled = value
                    ConfigSystem:Set(toggleName, toggled)
                    updateToggle()
                    if callback then callback(toggled) end
                end,
                Get = function() return toggled end
            }
        end
        
        -- Dropdown Element
        function Section:AddDropdown(dropdownName, options, default, callback)
            local savedValue = ConfigSystem:Get(dropdownName, default)
            local selected = savedValue
            local opened = false
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = SectionContent
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
            DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
            DropdownFrame.ClipsDescendants = true
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Parent = DropdownFrame
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.Size = UDim2.new(0.5, 0, 0, 40)
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.Text = dropdownName
            DropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            DropdownLabel.TextSize = 13
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Parent = DropdownFrame
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
            SelectedLabel.Size = UDim2.new(0.5, -40, 0, 40)
            SelectedLabel.Font = Enum.Font.Gotham
            SelectedLabel.Text = tostring(selected)
            SelectedLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            SelectedLabel.TextSize = 12
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local ArrowLabel = Instance.new("TextLabel")
            ArrowLabel.Parent = DropdownFrame
            ArrowLabel.BackgroundTransparency = 1
            ArrowLabel.Position = UDim2.new(1, -30, 0, 0)
            ArrowLabel.Size = UDim2.new(0, 20, 0, 40)
            ArrowLabel.Font = Enum.Font.GothamBold
            ArrowLabel.Text = "v"
            ArrowLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            ArrowLabel.TextSize = 12
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Parent = DropdownFrame
            OptionsFrame.BackgroundTransparency = 1
            OptionsFrame.Position = UDim2.new(0, 5, 0, 45)
            OptionsFrame.Size = UDim2.new(1, -10, 0, 0)
            OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.Parent = OptionsFrame
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, 3)
            
            for _, option in ipairs(options) do
                local OptionBtn = Instance.new("TextButton")
                OptionBtn.Parent = OptionsFrame
                OptionBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
                OptionBtn.Size = UDim2.new(1, 0, 0, 30)
                OptionBtn.Font = Enum.Font.Gotham
                OptionBtn.Text = tostring(option)
                OptionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                OptionBtn.TextSize = 12
                OptionBtn.AutoButtonColor = false
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 4)
                OptionCorner.Parent = OptionBtn
                
                OptionBtn.MouseButton1Click:Connect(function()
                    selected = option
                    SelectedLabel.Text = tostring(option)
                    ConfigSystem:Set(dropdownName, selected)
                    opened = false
                    DropdownFrame:TweenSize(UDim2.new(1, 0, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
                    ArrowLabel.Text = "v"
                    if callback then callback(option) end
                end)
            end
            
            local DropdownBtn = Instance.new("TextButton")
            DropdownBtn.Parent = DropdownFrame
            DropdownBtn.BackgroundTransparency = 1
            DropdownBtn.Size = UDim2.new(1, 0, 0, 40)
            DropdownBtn.Text = ""
            
            DropdownBtn.MouseButton1Click:Connect(function()
                opened = not opened
                local targetHeight = opened and (45 + (#options * 33)) or 40
                DropdownFrame:TweenSize(UDim2.new(1, 0, 0, targetHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
                ArrowLabel.Text = opened and "^" or "v"
            end)
            
            if savedValue and callback then
                task.spawn(function() callback(savedValue) end)
            end
            
            return {
                Set = function(_, value)
                    selected = value
                    SelectedLabel.Text = tostring(value)
                    ConfigSystem:Set(dropdownName, value)
                    if callback then callback(value) end
                end
            }
        end
        
        -- Slider Element
        function Section:AddSlider(sliderName, min, max, default, callback)
            local savedValue = ConfigSystem:Get(sliderName, default)
            local value = savedValue
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = SectionContent
            SliderFrame.BackgroundColor3 = Color3.fromRGB(38, 38, 42)
            SliderFrame.Size = UDim2.new(1, 0, 0, 55)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 12, 0, 5)
            SliderLabel.Size = UDim2.new(1, -60, 0, 20)
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.Text = sliderName
            SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            SliderLabel.TextSize = 13
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -50, 0, 5)
            ValueLabel.Size = UDim2.new(0, 40, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(value)
            ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueLabel.TextSize = 13
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local SliderBg = Instance.new("Frame")
            SliderBg.Parent = SliderFrame
            SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            SliderBg.Position = UDim2.new(0, 12, 0, 32)
            SliderBg.Size = UDim2.new(1, -24, 0, 8)
            
            local SliderBgCorner = Instance.new("UICorner")
            SliderBgCorner.CornerRadius = UDim.new(1, 0)
            SliderBgCorner.Parent = SliderBg
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderBg
            SliderFill.BackgroundColor3 = Color3.fromRGB(80, 180, 120)
            SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Parent = SliderBg
            SliderBtn.BackgroundTransparency = 1
            SliderBtn.Size = UDim2.new(1, 0, 1, 0)
            SliderBtn.Text = ""
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                value = math.floor(min + ((max - min) * pos.X.Scale))
                ValueLabel.Text = tostring(value)
                ConfigSystem:Set(sliderName, value)
                if callback then callback(value) end
            end
            
            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            SliderBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            if savedValue and callback then
                task.spawn(function() callback(savedValue) end)
            end
            
            return {
                Set = function(_, newValue)
                    value = newValue
                    SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    ValueLabel.Text = tostring(value)
                    ConfigSystem:Set(sliderName, value)
                    if callback then callback(value) end
                end
            }
        end
        
        -- Button Element
        function Section:AddButton(buttonName, callback)
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Parent = SectionContent
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(60, 130, 180)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            ButtonFrame.Font = Enum.Font.GothamBold
            ButtonFrame.Text = buttonName
            ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonFrame.TextSize = 13
            ButtonFrame.AutoButtonColor = false
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            ButtonFrame.MouseEnter:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 150, 200)}):Play()
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 130, 180)}):Play()
            end)
        end
        
        -- Label Element
        function Section:AddLabel(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Parent = SectionContent
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Size = UDim2.new(1, 0, 0, 25)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = LabelFrame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(150, 150, 150)
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            return {
                Set = function(_, newText) Label.Text = newText end
            }
        end
        
        -- Separator Element
        function Section:AddSeparator(text)
            local SepFrame = Instance.new("Frame")
            SepFrame.Parent = SectionContent
            SepFrame.BackgroundTransparency = 1
            SepFrame.Size = UDim2.new(1, 0, 0, 25)
            
            local SepLabel = Instance.new("TextLabel")
            SepLabel.Parent = SepFrame
            SepLabel.BackgroundTransparency = 1
            SepLabel.Size = UDim2.new(1, 0, 1, 0)
            SepLabel.Font = Enum.Font.GothamBold
            SepLabel.Text = "— " .. text .. " —"
            SepLabel.TextColor3 = Color3.fromRGB(100, 100, 105)
            SepLabel.TextSize = 11
        end
        
        table.insert(Tab.Sections, Section)
        return Section
    end
    
    return Tab
end

-- ═══════════════════════════════════════════════════════════════════
-- CREATE THE UI
-- ═══════════════════════════════════════════════════════════════════
local Window = ReaperLib:Create()

-- [M] Main Tab
local MainTab = Window:AddTab("Main", "[M]")
local CombatSection = MainTab:AddSection("Combat")
local FarmSection = MainTab:AddSection("Auto Farm")

-- [P] Play Tab
local PlayTab = Window:AddTab("Play", "[P]")
local QuestSection = PlayTab:AddSection("Quest Settings")
local BossSection = PlayTab:AddSection("Boss Farm")

-- [E] ESP Tab
local ESPTab = Window:AddTab("ESP", "[E]")
local ESPSection = ESPTab:AddSection("ESP Settings")

-- [R] Roll Tab
local RollTab = Window:AddTab("Roll", "[R]")
local RollSection = RollTab:AddSection("Roll Settings")

-- [F] Ping | FPS Tab
local StatsTab = Window:AddTab("Ping | FPS", "[F]")
local StatsSection = StatsTab:AddSection("Performance")

-- [S] Shaders Tab
local ShadersTab = Window:AddTab("Shaders", "[S]")
local ShadersSection = ShadersTab:AddSection("Visual Settings")

-- [+] Misc Tab
local MiscTab = Window:AddTab("Misc", "[+]")
local MiscSection = MiscTab:AddSection("Miscellaneous")
local TeleportSection = MiscTab:AddSection("Teleport")

-- [C] Config Tab
local ConfigTab = Window:AddTab("Config", "[C]")
local ConfigSection = ConfigTab:AddSection("Configuration")

-- ═══════════════════════════════════════════════════════════════════
-- COMBAT SECTION
-- ═══════════════════════════════════════════════════════════════════
CombatSection:AddToggle("Auto Parry", false, function(value)
    _G.AutoParry = value
end)

CombatSection:AddDropdown("Parry Mode", {"Normal", "Aggressive", "Defensive"}, "Normal", function(value)
    _G.ParryMode = value
end)

CombatSection:AddSlider("Parry Timing", 0, 100, 75, function(value)
    _G.ParryTiming = value
end)

CombatSection:AddToggle("Manual Spam", false, function(value)
    _G.ManualSpam = value
end)

CombatSection:AddToggle("Auto Use Ability", false, function(value)
    _G.AutoUseAbility = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- AUTO FARM SECTION
-- ═══════════════════════════════════════════════════════════════════
FarmSection:AddDropdown("Select Weapon", {"Melee", "Sword", "Gun", "Blox Fruit"}, "Melee", function(value)
    _G.SelectWeapon = value
end)

FarmSection:AddToggle("Auto Farm Level", false, function(value)
    _G.AutoFarm = value
    StopTween(_G.AutoFarm)
end)

FarmSection:AddSeparator("Chest Farm")

FarmSection:AddToggle("Auto Farm Chest", false, function(value)
    _G.FarmChest = value
    StopTween(_G.FarmChest)
end)

FarmSection:AddSeparator("Berry Collection")

FarmSection:AddToggle("Auto Farm Berries", false, function(value)
    _G.CollectBerry = value
    StopTween(_G.CollectBerry)
end)

FarmSection:AddSeparator("Boss Farm")

FarmSection:AddToggle("Auto Farm Boss", false, function(value)
    _G.AutoBoss = value
    StopTween(_G.AutoBoss)
end)

-- ═══════════════════════════════════════════════════════════════════
-- QUEST SECTION
-- ═══════════════════════════════════════════════════════════════════
QuestSection:AddToggle("Auto Quest", false, function(value)
    _G.AutoQuest = value
end)

QuestSection:AddToggle("Auto Accept Quest", false, function(value)
    _G.AutoAcceptQuest = value
end)

-- Boss Dropdown based on World
local bossOptions = {}
if World1 then
    bossOptions = {"The Saw", "The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Saber Expert"}
elseif World2 then
    bossOptions = {"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain", "Darkbeard", "Order", "Awakened Ice Admiral", "Tide Keeper"}
elseif World3 then
    bossOptions = {"Stone", "Island Empress", "Rocket Admiral", "Captain Elephant", "Beautiful Pirate", "rip_indra True Form", "Longma", "Soul Reaper", "Cake Queen", "Cake Prince", "Dough King"}
end

if #bossOptions > 0 then
    BossSection:AddDropdown("Select Boss", bossOptions, bossOptions[1], function(value)
        _G.SelectBoss = value
    end)
end

local bossStatusLabel = BossSection:AddLabel("Boss Status: Checking...")

-- ═══════════════════════════════════════════════════════════════════
-- ESP SECTION
-- ═══════════════════════════════════════════════════════════════════
ESPSection:AddToggle("Player ESP", false, function(value)
    _G.ESPPlayer = value
end)

ESPSection:AddToggle("Mob ESP", false, function(value)
    _G.MobESP = value
end)

ESPSection:AddToggle("Devil Fruit ESP", false, function(value)
    _G.DevilFruitESP = value
end)

ESPSection:AddToggle("Chest ESP", false, function(value)
    _G.ChestESP = value
end)

ESPSection:AddToggle("Island ESP", false, function(value)
    _G.IslandESP = value
end)

ESPSection:AddToggle("Flower ESP", false, function(value)
    _G.FlowerESP = value
end)

ESPSection:AddToggle("Sea Beast ESP", false, function(value)
    _G.SeaESP = value
end)

ESPSection:AddToggle("Kitsune Island ESP", false, function(value)
    _G.KitsuneIslandEsp = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- ROLL SECTION
-- ═══════════════════════════════════════════════════════════════════
RollSection:AddToggle("Auto Roll", false, function(value)
    _G.AutoRoll = value
end)

RollSection:AddDropdown("Roll Type", {"Normal", "Fast", "Instant"}, "Normal", function(value)
    _G.RollType = value
end)

-- ═══════════════════════════════════════════════════════════════════
-- STATS SECTION
-- ═══════════════════════════════════════════════════════════════════
local fpsLabel = StatsSection:AddLabel("FPS: Loading...")
local pingLabel = StatsSection:AddLabel("Ping: Loading...")
local timeLabel = StatsSection:AddLabel("Time: Loading...")

StatsSection:AddSeparator("Island Status")
local mirageLabel = StatsSection:AddLabel("Mirage Island: Checking...")
local prehistoricLabel = StatsSection:AddLabel("Prehistoric Island: Checking...")
local kitsuneLabel = StatsSection:AddLabel("Kitsune Island: Checking...")

-- ═══════════════════════════════════════════════════════════════════
-- SHADERS SECTION
-- ═══════════════════════════════════════════════════════════════════
ShadersSection:AddButton("FPS Boost", function()
    settings().Rendering.QualityLevel = "Level01"
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end)
    end
end)

ShadersSection:AddButton("Remove Fog", function()
    pcall(function() Lighting:FindFirstChild("LightingLayers"):Destroy() end)
    pcall(function() Lighting:FindFirstChild("Sky"):Destroy() end)
    pcall(function() Lighting:FindFirstChild("BaseAtmosphere"):Destroy() end)
    Lighting.FogEnd = 9e9
end)

ShadersSection:AddButton("Remove Lava", function()
    for _, v in pairs(WS:GetDescendants()) do
        if v.Name == "Lava" then v:Destroy() end
    end
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == "Lava" then v:Destroy() end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- MISC SECTION
-- ═══════════════════════════════════════════════════════════════════
MiscSection:AddToggle("Auto Haki", false, function(value)
    _G.AutoHakiEnabled = value
end)

MiscSection:AddToggle("No Clip", false, function(value)
    _G.NoClip = value
end)

MiscSection:AddToggle("Infinite Jump", false, function(value)
    _G.InfiniteJump = value
end)

MiscSection:AddButton("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

MiscSection:AddButton("Server Hop", function()
    pcall(function()
        local module = loadstring(game:HttpGet("https://roblox.relzscript.xyz/Hop.lua"))()
        module:Teleport(game.PlaceId, "Singapore")
    end)
end)

MiscSection:AddSeparator("Codes")

MiscSection:AddButton("Redeem All Codes", function()
    local codes = {"NOOB_REFUND", "SUB2GAMERROBOT_RESET1", "Sub2UncleKizaru", "FUDD10", "BIGNEWS", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "STRAWHATMAIME", "SUB2OFFICIALNOOBIE", "SUB2NOOBMASTER123", "SUB2DAIGROCK", "AXIORE", "TANTAIGAMIMG", "STRAWHATMAINE", "JCWK", "FUDD10_V2", "SUB2FER999", "MAGICBIS", "TY_FOR_WATCHING", "STARCODEHEO"}
    for _, code in pairs(codes) do
        pcall(function()
            ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
        end)
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- TELEPORT SECTION
-- ═══════════════════════════════════════════════════════════════════
local teleportLocations = {}
if World1 then
    teleportLocations = {"Starter Island", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marine Fortress", "Sky Island", "Prison", "Colosseum", "Magma Village", "Underwater City", "Fountain City"}
elseif World2 then
    teleportLocations = {"Kingdom of Rose", "Green Zone", "Graveyard", "Snow Mountain", "Hot and Cold", "Cursed Ship", "Ice Castle", "Forgotten Island", "Dark Arena"}
elseif World3 then
    teleportLocations = {"Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Castle on the Sea", "Haunted Castle", "Sea of Treats", "Chocolate Land", "Tiki Outpost"}
end

if #teleportLocations > 0 then
    TeleportSection:AddDropdown("Select Location", teleportLocations, teleportLocations[1], function(value)
        _G.TeleportLocation = value
    end)
end

TeleportSection:AddButton("Teleport to Location", function()
    -- Teleport logic would go here
end)

-- ═══════════════════════════════════════════════════════════════════
-- CONFIG SECTION
-- ═══════════════════════════════════════════════════════════════════
ConfigSection:AddButton("Save Config", function()
    ConfigSystem:Save()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reaper Hub",
        Text = "Configuration saved successfully!",
        Duration = 3
    })
end)

ConfigSection:AddButton("Load Config", function()
    ConfigSystem:Load()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reaper Hub",
        Text = "Configuration loaded! Restart script to apply all settings.",
        Duration = 3
    })
end)

ConfigSection:AddButton("Reset Config", function()
    ConfigSystem.Settings = {}
    ConfigSystem:Save()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Reaper Hub",
        Text = "Configuration reset to defaults!",
        Duration = 3
    })
end)

ConfigSection:AddSeparator("Auto Settings")
ConfigSection:AddLabel("Settings are automatically saved when changed.")
ConfigSection:AddLabel("Press Right Control to toggle UI visibility.")
ConfigSection:AddLabel("Pirates team is auto-selected on startup.")

-- ═══════════════════════════════════════════════════════════════════
-- BACKGROUND LOOPS
-- ═══════════════════════════════════════════════════════════════════

-- FPS/Ping/Time Update Loop
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            fpsLabel:Set("FPS: " .. tostring(fps))
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            pingLabel:Set("Ping: " .. ping)
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local gameTime = math.floor(WS.DistributedGameTime + 0.5)
            local hours = math.floor(gameTime / 3600) % 24
            local minutes = math.floor(gameTime / 60) % 60
            local seconds = gameTime % 60
            timeLabel:Set(string.format("Time: %02d:%02d:%02d", hours, minutes, seconds))
        end)
    end
end)

-- Island Status Update Loop
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if WS._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
                mirageLabel:Set("Mirage Island: Spawning ✅")
            else
                mirageLabel:Set("Mirage Island: Not Spawning ❌")
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if WS.Map:FindFirstChild("PrehistoricIsland") then
                prehistoricLabel:Set("Prehistoric Island: Spawning ✅")
            else
                prehistoricLabel:Set("Prehistoric Island: Not Spawning ❌")
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if WS.Map:FindFirstChild("KitsuneIsland") then
                kitsuneLabel:Set("Kitsune Island: Spawning ✅")
            else
                kitsuneLabel:Set("Kitsune Island: Not Spawning ❌")
            end
        end)
    end
end)

-- Boss Status Update Loop
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if _G.SelectBoss then
                if ReplicatedStorage:FindFirstChild(_G.SelectBoss) or WS.Enemies:FindFirstChild(_G.SelectBoss) then
                    bossStatusLabel:Set("Boss Status: " .. _G.SelectBoss .. " Spawned ✅")
                else
                    bossStatusLabel:Set("Boss Status: " .. _G.SelectBoss .. " Not Spawned ❌")
                end
            end
        end)
    end
end)

-- Auto Haki Loop
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoHakiEnabled then
            AutoHaki()
        end
    end
end)

-- No Clip Loop
task.spawn(function()
    RunService.Stepped:Connect(function()
        if _G.NoClip and LocalPlayer.Character then
            pcall(function()
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        end
    end)
end)

-- Infinite Jump Loop
task.spawn(function()
    UserInputService.JumpRequest:Connect(function()
        if _G.InfiniteJump and LocalPlayer.Character then
            pcall(function()
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
        end
    end)
end)

-- Auto Farm Chest Loop
task.spawn(function()
    while task.wait() do
        if _G.FarmChest then
            pcall(function()
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local Position = Character:GetPivot().Position
                local Chests = CollectionService:GetTagged("_ChestTagged")
                local Distance, Nearest = math.huge, nil
                for i = 1, #Chests do
                    local Chest = Chests[i]
                    local Magnitude = (Chest:GetPivot().Position - Position).Magnitude
                    if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then
                        Distance, Nearest = Magnitude, Chest
                    end
                end
                if Nearest then
                    topos(CFrame.new(Nearest:GetPivot().Position))
                end
            end)
        end
    end
end)

-- Auto Farm Level Loop
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local QuestTitle = LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                CheckQuest()
                if not string.find(QuestTitle, NameMon) then
                    StartBring = false
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                if LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    StartBring = false
                    TP1(CFrameQuest)
                    if (LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 20 then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                elseif LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                    if WS.Enemies:FindFirstChild(Mon) then
                        for _, v in pairs(WS.Enemies:GetChildren()) do
                            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                if v.Name == Mon then
                                    if string.find(LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                        repeat task.wait()
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()
                                            PosMon = v.HumanoidRootPart.CFrame
                                            topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                            v.HumanoidRootPart.CanCollide = false
                                            v.Humanoid.WalkSpeed = 0
                                            v.Head.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
                                            StartBring = true
                                            MonFarm = v.Name
                                            game:GetService("VirtualUser"):CaptureController()
                                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                        until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                    else
                                        StartBring = false
                                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AbandonQuest")
                                    end
                                end
                            end
                        end
                    else
                        TP1(CFrameMon)
                        StartBring = false
                    end
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════
-- STARTUP NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Reaper Hub",
    Text = "Script loaded successfully!",
    Duration = 5
})

print("═══════════════════════════════════════════════════════════════════")
print("                    REAPER HUB - Enhanced Edition                   ")
print("═══════════════════════════════════════════════════════════════════")
print("[✓] Script loaded successfully!")
print("[✓] Press Right Control to toggle UI")
print("[✓] Settings are automatically saved")
print("[✓] Pirates team auto-selected on startup")
print("═══════════════════════════════════════════════════════════════════")
