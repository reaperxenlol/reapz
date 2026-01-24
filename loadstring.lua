--[[
    MM2 EXPLOIT SCRIPT
    100% WORKING GUI
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

-- Variables
local ESPEnabled = false
local NoclipEnabled = false
local CoinFarmEnabled = false
local InfJumpEnabled = false
local GodModeEnabled = false
local FlingEnabled = false
local RainEnabled = false
local SnowEnabled = false
local ESPFolder = nil
local RainPart = nil
local SnowPart = nil

-- Destroy old GUI if exists
if game.CoreGui:FindFirstChild("MM2GUI") then
    game.CoreGui:FindFirstChild("MM2GUI"):Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2GUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 400, 0, 500)
Main.Position = UDim2.new(0.5, -200, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "MM2 EXPLOIT HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "Minimize"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = Main

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 6)
MinBtnCorner.Parent = MinBtn

-- Open Button (when minimized)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -30)
OpenBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
OpenBtn.Text = "MM2"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 16
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(1, 0)
OpenBtnCorner.Parent = OpenBtn

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- Tab Buttons Container
local TabBtns = Instance.new("Frame")
TabBtns.Name = "TabBtns"
TabBtns.Size = UDim2.new(1, -20, 0, 35)
TabBtns.Position = UDim2.new(0, 10, 0, 50)
TabBtns.BackgroundTransparency = 1
TabBtns.Parent = Main

-- Tab Content Container
local TabContent = Instance.new("Frame")
TabContent.Name = "TabContent"
TabContent.Size = UDim2.new(1, -20, 1, -100)
TabContent.Position = UDim2.new(0, 10, 0, 95)
TabContent.BackgroundTransparency = 1
TabContent.Parent = Main

-- Create Tab Pages
local Pages = {}

local function CreatePage(name)
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Name = name
    Scroll.Size = UDim2.new(1, 0, 1, 0)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 5
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.Visible = false
    Scroll.Parent = TabContent
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = Scroll
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 5)
    Padding.PaddingBottom = UDim.new(0, 5)
    Padding.Parent = Scroll
    
    Pages[name] = Scroll
    return Scroll
end

-- Create Pages
local MainPage = CreatePage("Main")
local MovePage = CreatePage("Move")
local ShaderPage = CreatePage("Shader")
local MiscPage = CreatePage("Misc")

-- Tab Button Creation
local TabList = {"Main", "Move", "Shader", "Misc"}
local CurrentTab = nil

for i, tabName in ipairs(TabList) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = tabName
    TabBtn.Size = UDim2.new(0.25, -5, 1, 0)
    TabBtn.Position = UDim2.new((i-1) * 0.25, 0, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 14
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Parent = TabBtns
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 6)
    TabBtnCorner.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, page in pairs(Pages) do
            page.Visible = false
        end
        for _, btn in pairs(TabBtns:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        Pages[tabName].Visible = true
        TabBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CurrentTab = tabName
    end)
end

-- Show Main tab by default
Pages["Main"].Visible = true
TabBtns:FindFirstChild("Main").BackgroundColor3 = Color3.fromRGB(80, 40, 180)
TabBtns:FindFirstChild("Main").TextColor3 = Color3.fromRGB(255, 255, 255)

-- Button Creator Function
local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Parent = parent
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- Toggle Creator Function
local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    Frame.Parent = parent
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 45, 0, 25)
    Toggle.Position = UDim2.new(1, -50, 0.5, -12.5)
    Toggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Toggle.Text = "OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextSize = 11
    Toggle.Font = Enum.Font.GothamBold
    Toggle.Parent = Frame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = Toggle
    
    local enabled = false
    Toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Toggle.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
            Toggle.Text = "ON"
        else
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            Toggle.Text = "OFF"
        end
        callback(enabled)
    end)
    
    return Frame
end

-- Notification Function
local function Notify(text)
    local Notif = Instance.new("TextLabel")
    Notif.Size = UDim2.new(0, 250, 0, 50)
    Notif.Position = UDim2.new(1, 0, 1, -60)
    Notif.BackgroundColor3 = Color3.fromRGB(80, 40, 180)
    Notif.Text = text
    Notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    Notif.TextSize = 14
    Notif.Font = Enum.Font.GothamBold
    Notif.Parent = ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = Notif
    
    Notif:TweenPosition(UDim2.new(1, -260, 1, -60), "Out", "Quad", 0.3, true)
    wait(2)
    Notif:TweenPosition(UDim2.new(1, 0, 1, -60), "In", "Quad", 0.3, true)
    wait(0.3)
    Notif:Destroy()
end

-- ============ FUNCTIONS ============

-- Get Character
local function GetCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Role Detection (FIXED)
local function GetRole(plr)
    if not plr.Character then return "Innocent" end
    
    -- Check character for tools
    for _, v in pairs(plr.Character:GetChildren()) do
        if v:IsA("Tool") then
            if v.Name == "Knife" then return "Murderer" end
            if v.Name == "Gun" or v.Name == "Revolver" then return "Sheriff" end
        end
    end
    
    -- Check backpack
    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") then
                if v.Name == "Knife" then return "Murderer" end
                if v.Name == "Gun" or v.Name == "Revolver" then return "Sheriff" end
            end
        end
    end
    
    return "Innocent"
end

-- Get Murderer
local function GetMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if GetRole(plr) == "Murderer" then
            return plr
        end
    end
    return nil
end

-- Get Sheriff
local function GetSheriff()
    for _, plr in pairs(Players:GetPlayers()) do
        if GetRole(plr) == "Sheriff" then
            return plr
        end
    end
    return nil
end

-- ESP
local function UpdateESP()
    if ESPFolder then ESPFolder:Destroy() end
    if not ESPEnabled then return end
    
    ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "ESP"
    ESPFolder.Parent = game.CoreGui
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(plr)
            local color
            
            if role == "Murderer" then
                color = Color3.fromRGB(255, 0, 0)
            elseif role == "Sheriff" then
                color = Color3.fromRGB(0, 100, 255)
            else
                color = Color3.fromRGB(0, 255, 0)
            end
            
            local highlight = Instance.new("Highlight")
            highlight.Adornee = plr.Character
            highlight.FillColor = color
            highlight.OutlineColor = color
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = ESPFolder
        end
    end
end

-- Coin Farm
local function CollectCoins()
    local root = GetRootPart()
    if not root then return end
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Coin" and v:IsA("BasePart") then
            root.CFrame = v.CFrame
            wait(0.1)
        end
    end
end

-- Noclip
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local hum = GetHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- God Mode
spawn(function()
    while wait(0.1) do
        if GodModeEnabled then
            local hum = GetHumanoid()
            if hum then
                hum.Health = hum.MaxHealth
            end
        end
    end
end)

-- ESP Loop
spawn(function()
    while wait(1) do
        if ESPEnabled then
            pcall(UpdateESP)
        end
    end
end)

-- Fling
local function FlingNearby()
    local root = GetRootPart()
    if not root then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 15 then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Velocity = Vector3.new(math.random(-100,100), 80, math.random(-100,100))
                bv.Parent = plr.Character.HumanoidRootPart
                game:GetService("Debris"):AddItem(bv, 0.5)
            end
        end
    end
end

-- Rain
local function ToggleRain(state)
    if state then
        RainPart = Instance.new("Part")
        RainPart.Size = Vector3.new(150, 1, 150)
        RainPart.Transparency = 1
        RainPart.Anchored = true
        RainPart.CanCollide = false
        RainPart.Parent = workspace
        
        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
        emitter.Color = ColorSequence.new(Color3.fromRGB(180, 180, 220))
        emitter.Size = NumberSequence.new(0.1)
        emitter.Transparency = NumberSequence.new(0.5, 0.9)
        emitter.Lifetime = NumberRange.new(2, 4)
        emitter.Rate = 150
        emitter.Speed = NumberRange.new(60)
        emitter.Parent = RainPart
        
        spawn(function()
            while RainEnabled and RainPart do
                local root = GetRootPart()
                if root then
                    RainPart.Position = root.Position + Vector3.new(0, 40, 0)
                end
                wait(0.3)
            end
        end)
    else
        if RainPart then RainPart:Destroy() RainPart = nil end
    end
end

-- Snow
local function ToggleSnow(state)
    if state then
        SnowPart = Instance.new("Part")
        SnowPart.Size = Vector3.new(150, 1, 150)
        SnowPart.Transparency = 1
        SnowPart.Anchored = true
        SnowPart.CanCollide = false
        SnowPart.Parent = workspace
        
        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
        emitter.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        emitter.Size = NumberSequence.new(0.2)
        emitter.Transparency = NumberSequence.new(0.3, 0.8)
        emitter.Lifetime = NumberRange.new(4, 7)
        emitter.Rate = 80
        emitter.Speed = NumberRange.new(8)
        emitter.SpreadAngle = Vector2.new(15, 15)
        emitter.Parent = SnowPart
        
        spawn(function()
            while SnowEnabled and SnowPart do
                local root = GetRootPart()
                if root then
                    SnowPart.Position = root.Position + Vector3.new(0, 40, 0)
                end
                wait(0.3)
            end
        end)
    else
        if SnowPart then SnowPart:Destroy() SnowPart = nil end
    end
end

-- Realistic Sky
local function LoadRealisticSky()
    -- Remove old sky/atmosphere
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
    
    Lighting.Ambient = Color3.fromRGB(140, 140, 140)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = true
    Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 130)
    
    local sky = Instance.new("Sky")
    sky.StarCount = 3000
    sky.SunAngularSize = 20
    sky.MoonAngularSize = 10
    sky.Parent = Lighting
    
    local atmo = Instance.new("Atmosphere")
    atmo.Density = 0.35
    atmo.Offset = 0.2
    atmo.Color = Color3.fromRGB(200, 200, 200)
    atmo.Decay = Color3.fromRGB(100, 110, 120)
    atmo.Parent = Lighting
    
    Notify("Realistic sky loaded!")
end

-- ============ MAIN TAB ============

CreateToggle(MainPage, "ESP (Red=Murd Blue=Sheriff Green=Inno)", function(state)
    ESPEnabled = state
    if state then
        UpdateESP()
        Notify("ESP ON")
    else
        if ESPFolder then ESPFolder:Destroy() end
        Notify("ESP OFF")
    end
end)

CreateToggle(MainPage, "Coin Farm", function(state)
    CoinFarmEnabled = state
    if state then
        Notify("Coin Farm ON")
        spawn(function()
            while CoinFarmEnabled do
                pcall(CollectCoins)
                wait(0.5)
            end
        end)
    else
        Notify("Coin Farm OFF")
    end
end)

CreateButton(MainPage, "Collect All Coins", function()
    Notify("Collecting coins...")
    spawn(function() pcall(CollectCoins) end)
end)

CreateButton(MainPage, "TP to Murderer", function()
    local murd = GetMurderer()
    if murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") then
        local root = GetRootPart()
        if root then
            root.CFrame = murd.Character.HumanoidRootPart.CFrame
            Notify("TPed to " .. murd.Name)
        end
    else
        Notify("Murderer not found!")
    end
end)

CreateButton(MainPage, "TP to Sheriff", function()
    local sher = GetSheriff()
    if sher and sher.Character and sher.Character:FindFirstChild("HumanoidRootPart") then
        local root = GetRootPart()
        if root then
            root.CFrame = sher.Character.HumanoidRootPart.CFrame
            Notify("TPed to " .. sher.Name)
        end
    else
        Notify("Sheriff not found!")
    end
end)

-- ============ MOVE TAB ============

CreateToggle(MovePage, "Noclip", function(state)
    NoclipEnabled = state
    Notify(state and "Noclip ON" or "Noclip OFF")
end)

CreateToggle(MovePage, "Infinite Jump", function(state)
    InfJumpEnabled = state
    Notify(state and "Infinite Jump ON" or "Infinite Jump OFF")
end)

CreateButton(MovePage, "Speed 100", function()
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = 100
        Notify("Speed set to 100")
    end
end)

CreateButton(MovePage, "Speed 200", function()
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = 200
        Notify("Speed set to 200")
    end
end)

CreateButton(MovePage, "Jump 150", function()
    local hum = GetHumanoid()
    if hum then
        hum.JumpPower = 150
        Notify("Jump set to 150")
    end
end)

CreateToggle(MovePage, "Fling Aura", function(state)
    FlingEnabled = state
    if state then
        Notify("Fling Aura ON")
        spawn(function()
            while FlingEnabled do
                pcall(FlingNearby)
                wait(0.5)
            end
        end)
    else
        Notify("Fling Aura OFF")
    end
end)

-- ============ SHADER TAB ============

CreateButton(ShaderPage, "Load Realistic Sky", function()
    LoadRealisticSky()
end)

CreateToggle(ShaderPage, "Rain", function(state)
    RainEnabled = state
    ToggleRain(state)
    Notify(state and "Rain ON" or "Rain OFF")
end)

CreateToggle(ShaderPage, "Snow", function(state)
    SnowEnabled = state
    ToggleSnow(state)
    Notify(state and "Snow ON" or "Snow OFF")
end)

CreateButton(ShaderPage, "Full Bright", function()
    Lighting.Brightness = 3
    Lighting.ClockTime = 12
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    Notify("Full Bright ON")
end)

CreateButton(ShaderPage, "Remove Fog", function()
    Lighting.FogEnd = 100000
    Notify("Fog Removed")
end)

-- ============ MISC TAB ============

CreateToggle(MiscPage, "God Mode", function(state)
    GodModeEnabled = state
    Notify(state and "God Mode ON" or "God Mode OFF")
end)

CreateButton(MiscPage, "TP to Lobby", function()
    local root = GetRootPart()
    if root then
        root.CFrame = CFrame.new(0, 100, 0)
        Notify("TPed to Lobby")
    end
end)

CreateButton(MiscPage, "Reset Character", function()
    local hum = GetHumanoid()
    if hum then
        hum.Health = 0
        Notify("Character Reset")
    end
end)

-- Character respawn handler
Player.CharacterAdded:Connect(function()
    wait(1)
    if ESPEnabled then UpdateESP() end
end)

-- Load sky on start
LoadRealisticSky()

-- Done
Notify("MM2 Exploit Loaded!")
print("MM2 Exploit Script Loaded Successfully!")
