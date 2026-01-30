-- ========== REAPERHUB WEBHOOK SYSTEM ==========
_G.OwnerWebhookURL = "https://discordapp.com/api/webhooks/1466254440339210250/4So_juFufF4aEvBQc1zmaPGY1PdonPX3hV_py1doHl51Lu4FLUVQXCI1ycaKYpgFyZc-"
_G.UserWebhookURL = ""

function SendOwnerWebhook()
    spawn(function()
        wait(10)
        pcall(function()
            local player = game:GetService("Players").LocalPlayer
            local data = player:WaitForChild("Data")
            
            local level = data:FindFirstChild("Level") and data.Level.Value or 0
            local beli = data:FindFirstChild("Beli") and data.Beli.Value or 0
            local fragments = data:FindFirstChild("Fragments") and data.Fragments.Value or 0
            local bounty = data:FindFirstChild("Bounty") and data.Bounty.Value or 0
            local race = data:FindFirstChild("Race") and data.Race.Value or "Unknown"
            
            local payload = {
                embeds = {{
                    title = "ReaperHub Executed",
                    color = 16777215,
                    thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"},
                    fields = {
                        {name = "Player", value = player.Name, inline = true},
                        {name = "User ID", value = tostring(player.UserId), inline = true},
                        {name = "Level", value = tostring(level), inline = true},
                        {name = "Beli", value = tostring(beli), inline = true},
                        {name = "Fragments", value = tostring(fragments), inline = true},
                        {name = "Bounty", value = tostring(bounty), inline = true},
                        {name = "Race", value = race, inline = true},
                    },
                    footer = {text = "ReaperHub Execution Logger"}
                }}
            }
            
            local HttpService = game:GetService("HttpService")
            local req = request or http_request or syn.request
            if req then
                req({
                    Url = _G.OwnerWebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(payload)
                })
            end
        end)
    end)
end

function SendUserWebhook()
    if _G.UserWebhookURL == "" then return end
    spawn(function()
        pcall(function()
            local player = game:GetService("Players").LocalPlayer
            local data = player:WaitForChild("Data")
            
            local level = data:FindFirstChild("Level") and data.Level.Value or 0
            local beli = data:FindFirstChild("Beli") and data.Beli.Value or 0
            local fragments = data:FindFirstChild("Fragments") and data.Fragments.Value or 0
            local bounty = data:FindFirstChild("Bounty") and data.Bounty.Value or 0
            local honor = data:FindFirstChild("Honor") and data.Honor.Value or 0
            local race = data:FindFirstChild("Race") and data.Race.Value or "Unknown"
            
            local melee = 0
            local defense = 0
            local sword = 0
            local gun = 0
            local df = 0
            
            pcall(function()
                melee = data.Stats.Melee.Level.Value
                defense = data.Stats.Defense.Level.Value
                sword = data.Stats.Sword.Level.Value
                gun = data.Stats.Gun.Level.Value
                df = data.Stats["Demon Fruit"].Level.Value
            end)
            
            local payload = {
                embeds = {{
                    author = {name = player.Name, icon_url = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"},
                    title = "=====CURRENCY=====",
                    color = 16777215,
                    fields = {
                        {name = "Level", value = tostring(level), inline = true},
                        {name = "Beli", value = "$ "..tostring(beli), inline = true},
                        {name = "Fragment", value = tostring(fragments), inline = true},
                        {name = "Bounty", value = tostring(bounty), inline = true},
                        {name = "Honor", value = tostring(honor), inline = true},
                        {name = "Race", value = race, inline = true},
                        {name = "=====STATS=====", value = "Melee: "..melee.." | Defense: "..defense.." | Sword: "..sword.." | Gun: "..gun.." | Blox Fruit: "..df, inline = false},
                    },
                    footer = {text = "ReaperHub Progress Tracker"}
                }}
            }
            
            local HttpService = game:GetService("HttpService")
            local req = request or http_request or syn.request
            if req then
                req({
                    Url = _G.UserWebhookURL,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(payload)
                })
            end
        end)
    end)
end

-- Send owner webhook on load
SendOwnerWebhook()

-- Auto send user webhook every 5 minutes
spawn(function()
    while wait(300) do
        SendUserWebhook()
    end
end)
-- ========== END WEBHOOK SYSTEM ==========

-- ========== REAPERHUB CONFIG SYSTEM ==========
_G.ReaperHubConfig = {}

function SaveConfig()
    pcall(function()
        local config = {
            AutoFarm = _G.AutoFarm or false,
            AutoBoss = _G.AutoBoss or false,
            AutoFarmMaterial = _G.AutoFarmMaterial or false,
            AutoElitehunter = _G.AutoElitehunter or false,
            FastAttack = _G.FastAttack or false,
            AutoHaki = _G.AutoHaki or false,
            Grabfruit = _G.Grabfruit or false,
            UserWebhookURL = _G.UserWebhookURL or "",
            SelectWeapon = _G.SelectWeapon or "",
        }
        local HttpService = game:GetService("HttpService")
        local encoded = HttpService:JSONEncode(config)
        writefile("ReaperHub_Config.json", encoded)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ReaperHub",
            Text = "Config saved!",
            Duration = 3
        })
    end)
end

function LoadConfig()
    pcall(function()
        if isfile and isfile("ReaperHub_Config.json") then
            local HttpService = game:GetService("HttpService")
            local content = readfile("ReaperHub_Config.json")
            local config = HttpService:JSONDecode(content)
            
            _G.AutoFarm = config.AutoFarm or false
            _G.AutoBoss = config.AutoBoss or false
            _G.AutoFarmMaterial = config.AutoFarmMaterial or false
            _G.AutoElitehunter = config.AutoElitehunter or false
            _G.FastAttack = config.FastAttack or false
            _G.AutoHaki = config.AutoHaki or false
            _G.Grabfruit = config.Grabfruit or false
            _G.UserWebhookURL = config.UserWebhookURL or ""
            _G.SelectWeapon = config.SelectWeapon or ""
            
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ReaperHub",
                Text = "Config loaded!",
                Duration = 3
            })
        end
    end)
end

function DeleteConfig()
    pcall(function()
        if isfile and isfile("ReaperHub_Config.json") then
            delfile("ReaperHub_Config.json")
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ReaperHub",
                Text = "Config deleted!",
                Duration = 3
            })
        end
    end)
end

-- Auto load config after 5 seconds
spawn(function()
    wait(5)
    LoadConfig()
end)
-- ========== END CONFIG SYSTEM ==========

-- ========== AUTO-SELECT TEAM (INTEGRATED) ==========
spawn(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Wait for game to load
    repeat wait() until game:IsLoaded()
    wait(1)
    
    -- Check if player hasn't chosen a team yet
    local function selectPirateTeam()
        -- Try multiple times in case of delays
        for i = 1, 10 do
            pcall(function()
                -- Check if team selection is needed
                if not LocalPlayer.Team or LocalPlayer.Team.Name == "Neutral" then
                    -- Method 1: Try RemoteEvent
                    if ReplicatedStorage:FindFirstChild("Remotes") then
                        local remotes = ReplicatedStorage.Remotes
                        if remotes:FindFirstChild("CommF_") then
                            remotes.CommF_:InvokeServer("SetTeam", "Pirates")
                        end
                    end
                    
                    -- Method 2: Try direct team assignment
                    local teams = game:GetService("Teams")
                    if teams:FindFirstChild("Pirates") then
                        LocalPlayer.Team = teams.Pirates
                    end
                    
                    -- Method 3: Click the pirate button if GUI exists
                    if LocalPlayer.PlayerGui:FindFirstChild("Main") then
                        local main = LocalPlayer.PlayerGui.Main
                        if main:FindFirstChild("ChooseTeam") then
                            local chooseTeam = main.ChooseTeam
                            if chooseTeam:FindFirstChild("Container") then
                                local container = chooseTeam.Container
                                if container:FindFirstChild("Pirates") then
                                    local piratesButton = container.Pirates
                                    if piratesButton:FindFirstChild("ViewportFrame") then
                                        -- Simulate button click
                                        for _, v in pairs(getconnections(piratesButton.MouseButton1Click)) do
                                            v:Fire()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            
            -- Check if successful
            if LocalPlayer.Team and LocalPlayer.Team.Name == "Pirates" then
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "ReaperHub",
                    Text = "Auto-selected Pirate team!",
                    Duration = 3
                })
                break
            end
            
            wait(0.5)
        end
    end
    
    -- Try to select team
    selectPirateTeam()
    
    -- Also watch for respawns/resets
    LocalPlayer.CharacterAdded:Connect(function()
        wait(1)
        selectPirateTeam()
    end)
end)
-- ========== END AUTO-SELECT TEAM ==========

-- ESP Mobs - Green Circle (5000 studs, small circle)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- lưu ESP
local mobESP = {}
local MAX_DISTANCE = 5000 -- 👈 chỉ quét quái trong phạm vi 5000 stud

-- tạo circle
local function createCircle()
    local circle = Drawing.new("Circle")
    circle.Color = Color3.fromRGB(0, 0, 0)
    circle.Thickness = 2
    circle.NumSides = 50
    circle.Filled = false
    circle.Radius = 1.2 -- 👈 nhỏ gấp 10 lần (so với 12)
    circle.Visible = true
    return circle
end

-- tạo esp cho mob
local function addESP(mob)
    if mobESP[mob] then return end
    local circle = createCircle()
    mobESP[mob] = circle

    mob.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if mobESP[mob] then
                mobESP[mob]:Remove()
                mobESP[mob] = nil
            end
        end
    end)
end

-- update vòng tròn theo vị trí
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for mob, circle in pairs(mobESP) do
        if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChildOfClass("Humanoid") and mob.Humanoid.Health > 0 then
            local distance = (mob.HumanoidRootPart.Position - hrp.Position).Magnitude
            if distance <= MAX_DISTANCE then
                local pos, onScreen = Camera:WorldToViewportPoint(mob.HumanoidRootPart.Position)
                if onScreen then
                    circle.Position = Vector2.new(pos.X, pos.Y)
                    circle.Visible = true
                else
                    circle.Visible = false
                end
            else
                circle.Visible = false
            end
        else
            circle.Visible = false
        end
    end
end)

-- theo dõi workspace.Enemies
for _, mob in ipairs(workspace.Enemies:GetChildren()) do
    addESP(mob)
end
workspace.Enemies.ChildAdded:Connect(function(mob)
    task.wait(0.2)
    addESP(mob)
end)

-- Skibidi
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

task.delay(25, function() -- ⏳ Chờ 10 giây mới bật script này

    -- Hàm tạo aura xanh ngọc
    local function createAquaAura(char)
        if not char then return end
        if char:FindFirstChild("AquaAura") then
            char.AquaAura:Destroy()
        end

        local aura = Instance.new("Highlight")
        aura.Name = "AquaAura"
        aura.FillColor = Color3.fromRGB(0, 0, 0)
        aura.OutlineColor = Color3.fromRGB(0, 0, 0)
        aura.FillTransparency = 1 -- mặc định ẩn
        aura.OutlineTransparency = 1
        aura.Parent = char
    end

    -- Respawn thì tạo aura
    local function onCharacterAdded(char)
        char:WaitForChild("HumanoidRootPart")
        task.wait(1)
        createAquaAura(char)

        local humanoid = char:WaitForChild("Humanoid")
        local aura = char:FindFirstChild("AquaAura")

        local floatTime = 0
        RunService.RenderStepped:Connect(function(dt)
            if not humanoid or not aura then return end

            if humanoid.FloorMaterial == Enum.Material.Air then
                floatTime += dt
                if floatTime >= 3 then
                    aura.FillTransparency = 0.3
                    aura.OutlineTransparency = 0
                end
            else
                floatTime = 0
                aura.FillTransparency = 1
                aura.OutlineTransparency = 1
            end
        end)
    end

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

end)
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDzaiScript/Setting/refs/heads/main/FastMax.lua"))()
end)
local plr = game:GetService("Players").LocalPlayer
local Notification = require(game:GetService("ReplicatedStorage").Notification)

-- Thông báo chào mừng
Notification.new("<Color=Yellow>ReaperHub <Color=/>"):Display()
task.wait(1)

-- LocalScript (đặt trong StarterPlayerScripts)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Tùy chỉnh
local TEXT = "ReaperHub"
local TEXT_SIZE = 14                 -- kích thước chữ (không quá to)
local GUI_OFFSET = Vector3.new(0, 1.8, 0) -- khoảng cách so với đầu
local RAINBOW_SPEED = 1.0           -- tốc độ đổi màu (1 = bình thường, tăng để nhanh hơn)

local function createBillboardFor(character)
    if not character then return end
    local head = character:FindFirstChild("Head") or character:FindFirstChildWhichIsA("BasePart")
    if not head then return end

    -- Nếu đã có Billboard do script tạo thì hủy trước
    local existing = head:FindFirstChild("HNC_FastAttack_Label")
    if existing then existing:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HNC_FastAttack_Label"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 40) -- kích thước GUI
    billboard.StudsOffset = GUI_OFFSET
    billboard.Parent = head

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Label"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = TEXT
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = TEXT_SIZE
    textLabel.TextStrokeTransparency = 0.6
    textLabel.TextTransparency = 0
    textLabel.TextScaled = false
    textLabel.Parent = billboard

    -- rainbow loop
    local hue = 0
    local con
    con = RunService.RenderStepped:Connect(function(dt)
        hue = (hue + dt * RAINBOW_SPEED) % 1
        local rgb = Color3.fromHSV(hue, 0.9, 1)
        if textLabel and textLabel.Parent then
            textLabel.TextColor3 = rgb
        else
            if con then con:Disconnect() end
        end
    end)
end

-- khi spawn/respawn character
local function onCharacterAdded(character)
    -- đợi head xuất hiện
    if not character.Parent then
        character.AncestryChanged:Wait()
    end
    -- tạo sau 0.1s để head chắc chắn có
    wait(0.1)
    createBillboardFor(character)
end

-- kết nối
if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

-- optional: nếu muốn tắt khi rời game (cleanup)
player.AncestryChanged:Connect(function(_, parent)
    if not parent then
        -- client đang bị remove, nothing to do
    end
end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local screenGui = Instance.new("ScreenGui")
local textLabel = Instance.new("TextLabel")

screenGui.Parent = game.CoreGui
screenGui.DisplayOrder = 100

textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 200, 0, 40) -- Nhỏ lại kích thước hộp
textLabel.Position = UDim2.new(0, 10, 0, 10)
textLabel.Font = Enum.Font.FredokaOne
textLabel.TextScaled = false
textLabel.TextSize = 20 -- Kích thước chữ nhỏ
textLabel.BackgroundTransparency = 1
textLabel.TextStrokeTransparency = 0

local function rainbowColor()
    local Dreamon = 0
    while true do
        Dreamon = Dreamon + 0.01
        if Dreamon > 1 then Dreamon = 0 end
        textLabel.TextColor3 = Color3.fromHSV(Dreamon, 1, 1)
        RunService.RenderStepped:Wait()
    end
end

local frameCount = 0
local lastUpdate = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        textLabel.Text = "ReaperHub | FPS: " .. frameCount
        frameCount = 0
        lastUpdate = now
    end
end)

spawn(rainbowColor)

function CheckItemBPCRBPCR(name)
    chbp = {game.Players.LocalPlayer.Character,game.Players.LocalPlayer.Backpack}
    for i, v in pairs(chbp) do
        if v:FindFirstChild(name) then
            return v:FindFirstChild(name)
        end
    end
end

local library = {}

_G.Color = Color3.fromRGB(0, 255, 255) -- CHANGED FROM WHITE TO CYAN FOR VISIBILITY
_G.imageLogo = "rbxassetid://129771247821193"
_G.Logo = "rbxassetid://129771247821193"
_G.NameHub = "BloxFruit" -- ชื่อ Hub
_G.Title = "ReaperHub" -- คำอธิบาย
-----------------------------------------------------------------

local isUIEnabled = true 

local function toggleUI()
    -- Loop through the children of "Modules" to find any ScreenGui
    for i, v in pairs(game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):GetChildren()) do
        if v.ClassName == "ScreenGui" then
            v.Enabled = isUIEnabled  -- Update the UI's Enabled property
        end
    end

    -- Check if ScreenGui exists in CoreGui and update its state
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("ScreenGui") then
        coreGui.ScreenGui.Enabled = isUIEnabled
    end
end

-- Creating the ScreenGui and ImageButton
local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- DARK BACKGROUND FOR BUTTON
ImageButton.BackgroundTransparency = 0.5 -- SEMI-TRANSPARENT
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.120833337 - 0.10, 0, 0.0952890813 + 0.01, 0)
ImageButton.Size = UDim2.new(0, 50, 0, 50)
ImageButton.Draggable = true
ImageButton.Image = "rbxassetid://129771247821193"

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ImageButton

-- Handle the event when the ImageButton is clicked
ImageButton.MouseButton1Click:Connect(function()
    isUIEnabled = not isUIEnabled  -- Toggle the UI state
    toggleUI()
end)


--local library = {}

local UIConfig = {Bind = Enum.KeyCode.RightControl}
local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local length = 20
local randomString = ""

math.randomseed(os.time())

charTable = {}
for c in chars:gmatch "." do
    table.insert(charTable, c)
end

for i = 1, length do
    randomString = randomString .. charTable[math.random(1, #charTable)]
end

for i, v in pairs(game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):GetChildren()) do
    if v.ClassName == "ScreenGui" then
        local MrMaxNaJa = Instance.new("ScreenGui")
        for i1, v1 in pairs(v:GetChildren()) do
            if v1.Name == "Main" then
                do
                    local ui = v
                    if ui then
                        ui:Destroy()
                        game:GetService("CoreGui").ScreenGui:Destroy()
                    end
                end
            end
        end
    end
end
function CircleClick(Button, X, Y)
    coroutine.resume(
        coroutine.create(
            function()
                local Circle = Instance.new("ImageLabel")
                Circle.Parent = Button
                Circle.Name = "Circle"
                Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Circle.BackgroundTransparency = 1.000
                Circle.ZIndex = 10
                Circle.Image = "rbxassetid://129771247821193"
                Circle.ImageColor3 = Color3.fromRGB(255, 255, 255)
                Circle.ImageTransparency = 0.7
                local NewX = X - Circle.AbsolutePosition.X
                local NewY = Y - Circle.AbsolutePosition.Y
                Circle.Position = UDim2.new(0, NewX, 0, NewY)

                local Time = 0.2
                Circle:TweenSizeAndPosition(
                    UDim2.new(0, 30.25, 0, 30.25),
                    UDim2.new(0, NewX - 15, 0, NewY - 10),
                    "Out",
                    "Quad",
                    Time,
                    false,
                    nil
                )
                for i = 1, 10 do
                    Circle.ImageTransparency = Circle.ImageTransparency + 0.01
                    wait(Time / 10)
                end
                Circle:Destroy()
            end
        )
    )
end
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
function dragify(Frame, object)
    DragToggle = nil
    Dragging = nil
    DragSpeed = .25
    DragInputl = nil
    DragStart = nil
    DragPos = nil

    function updateInput(input)
        Delta = input.Position - DragStart
        Position =
            UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        game:GetService("TweenService"):Create(object, TweenInfo.new(DragSpeed), {Position = Position}):Play()
    end

    Frame.InputBegan:Connect(
        function(input)
            if
                (input.UserInputType == Enum.UserInputType.MouseButton1 or
                    input.UserInputType == Enum.UserInputType.Touch)
            then
                DragToggle = true
                DragStart = input.Position
                startPos = object.Position
                input.Changed:Connect(
                    function()
                        if (input.UserInputState == Enum.UserInputState.End) then
                            DragToggle = false
                        end
                    end
                )
            end
        end
    )

    Frame.InputChanged:Connect(
        function(input)
            if
                (input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch)
            then
                DragInputl = input
            end
        end
    )

    game:GetService("UserInputService").InputChanged:Connect(
    function(input)
        if (input == DragInputl and DragToggle) then
            updateInput(input)
        end
    end
    )
end

local UI = Instance.new("ScreenGui")
UI.Name = randomString
UI.Parent = game.CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn then
    syn.protect_gui(UI)
end

function library:Destroy()
    library:Destroy()
    game:GetService("CoreGui").ScreenGui:Destroy()
end

function library:NaJa()
    local Main = Instance.new("Frame")
    local Logo = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    local Top = Instance.new("Frame")
    local TabHolder = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local TabContainer = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local Title = Instance.new("TextLabel")
    local Desc = Instance.new("TextLabel")

    Main.Name = "Main"
    Main.Parent = UI
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- DARK BACKGROUND
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.BackgroundTransparency = 0.1 -- REDUCED TRANSPARENCY FOR BETTER VISIBILITY
    Main.Size = UDim2.new(0, 520, 0, 380)
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)

    local ClickFrame = Instance.new("Frame")
    ClickFrame.Name = "Top"
    ClickFrame.Parent = Main
    ClickFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClickFrame.BackgroundTransparency = 1
    ClickFrame.Position = UDim2.new(0, 0, 0, 50)
    ClickFrame.Size = UDim2.new(0, 520, 0, 360)

    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- DARK TOP BAR
    Top.BackgroundTransparency = 0.5
    Top.Position = UDim2.new(0.021956088, 0, 0.01, 5)
    Top.Size = UDim2.new(0, 414, 0, 43)

local TweenService = game:GetService("TweenService")

-- Tween helper function
local function TweenObject(obj, props, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3), props)
    tween:Play()
end

local Discord = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local Disc_Logo = Instance.new("ImageLabel")
local Disc_Title = Instance.new("TextLabel")

Discord.Name = "Tik Tok"
Discord.Parent = Main
Discord.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Discord.BackgroundTransparency = 0.5 -- SEMI-TRANSPARENT FOR VISIBILITY
Discord.BorderColor3 = Color3.fromRGB(0, 0, 0)
Discord.BorderSizePixel = 0
Discord.Position = UDim2.new(0, 430, 0, 16)
Discord.Size = UDim2.new(0, 85, 0, 25)
Discord.AutoButtonColor = false
Discord.Font = Enum.Font.SourceSans
Discord.Text = ""
Discord.TextColor3 = Color3.fromRGB(255, 255, 255)
Discord.TextSize = 14.000

UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = Discord

Disc_Logo.Name = "Disc_Logo"
Disc_Logo.Parent = Discord
Disc_Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Disc_Logo.BackgroundTransparency = 1.000
Disc_Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
Disc_Logo.BorderSizePixel = 0
Disc_Logo.Position = UDim2.new(0, 5, 0, 1)
Disc_Logo.Size = UDim2.new(0, 23, 0, 23)
Disc_Logo.Image = "http://www.roblox.com/asset/?id=129771247821193"

Disc_Title.Name = "Disc_Title"
Disc_Title.Parent = Discord
Disc_Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Disc_Title.BackgroundTransparency = 1.000
Disc_Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Disc_Title.BorderSizePixel = 0
Disc_Title.Position = UDim2.new(0, 35, 0, 0)
Disc_Title.Size = UDim2.new(0, 40, 0, 25)
Disc_Title.Font = Enum.Font.SourceSansSemibold
Disc_Title.Text = "Discord"
Disc_Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Disc_Title.TextSize = 14.000
Disc_Title.TextXAlignment = Enum.TextXAlignment.Left

-- Hover Effects
Discord.MouseEnter:Connect(function()
    TweenObject(Discord, {BackgroundTransparency = 0.3}, .15)
    TweenObject(Disc_Logo, {ImageTransparency = 0.7}, .15)
    TweenObject(Disc_Title, {TextTransparency = 0.7}, .15)
end)

Discord.MouseLeave:Connect(function()
    TweenObject(Discord, {BackgroundTransparency = 1}, .15)
    TweenObject(Disc_Logo, {ImageTransparency = 0}, .15)
    TweenObject(Disc_Title, {TextTransparency = 0}, .15)
end)

-- Click event: copy Discord link
Discord.MouseButton1Click:Connect(function()
    (setclipboard or toclipboard)("https://discord.gg/reaperhub")
    wait(.1)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ReaperHub",
        Text = "Discord",
        Button1 = "🌹",
        Duration = 20
    })
end)


UICorner.Parent = ImageButton
	local Cornerx = Instance.new("UICorner")
	local Cornerxx = Instance.new("UICorner")
	local Cornerxxx = Instance.new("UICorner")
	local Cornerxxxxx = Instance.new("UICorner")
	local Cornerxxxxxx = Instance.new("UICorner")
	local o = Instance.new("UICorner")
	local r = Instance.new("UICorner")
    Cornerx.CornerRadius = UDim.new(0, 5)
    Cornerxx.CornerRadius = UDim.new(0, 5)
    Cornerxxx.CornerRadius = UDim.new(0, 5)
    Cornerxxxxx.CornerRadius = UDim.new(1, 0)
    Cornerxxxxxx.CornerRadius = UDim.new(1, 0)
    o.CornerRadius = UDim.new(1, 0)
    r.CornerRadius = UDim.new(1, 0)
    Cornerx.Name = "ServerCorner"
    Cornerx.Parent = Topdiscor
    Cornerxx.Name = "ServerCorner"
    Cornerxx.Parent = Topdiscord
    Cornerxxx.Name = "ServerCorner"
    Cornerxxx.Parent = TopdiscordI
    Cornerxxxxx.Name = "ServerCorner"
    Cornerxxxxx.Parent = Topdiscor11
    Cornerxxxxxx.Name = "ServerCorner"
    Cornerxxxxxx.Parent = atopdiscor11
    o.Name = "ServerCorner"
    o.Parent = Topdiscor1
    r.Name = "ServerCorner"
    r.Parent = atopdiscor111
    
	TabHolder.Name = "TabHolder"
	TabHolder.Parent = Top
	TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20) --25
	TabHolder.BackgroundTransparency = 0.7
	TabHolder.Position = UDim2.new(-0.010309278, 6, 0.023051, 0.2)
	TabHolder.Size = UDim2.new(0, 410, 0, 40)

	UICorner_2.Parent = TabHolder

	TabContainer.Name = "TabContainer"
	TabContainer.Parent = TabHolder
	TabContainer.Active = true
	TabContainer.BackgroundColor3 = Color3.fromRGB(16, 42, 220)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.Size = UDim2.new(0, 405, 0, 45)
	TabContainer.CanvasSize = UDim2.new(2, 0, 0, 0)
	TabContainer.ScrollBarThickness = 6
	TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always

	UIListLayout.Parent = TabContainer
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
	function()
		TabContainer.CanvasSize = UDim2.new(.0, UIListLayout.AbsoluteContentSize.X, 0, 0)
	end
	)
	UIPadding.Parent = TabContainer
	UIPadding.PaddingLeft = UDim.new(0, 5)
	UIPadding.PaddingTop = UDim.new(0, 5) --3

	local Bottom = Instance.new("Frame")
	Bottom.Name = "Bottom"
	Bottom.Parent = Main
	Bottom.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
	Bottom.BackgroundTransparency = 0.5
	Bottom.Position = UDim2.new(0.0119760484, 2, 0.0916666687, 25)
	Bottom.Size = UDim2.new(0, 505, 0, 300)
    
	local uitoggled = false
	UserInputService.InputBegan:Connect(
		function(io, p)
			if io.KeyCode == UIConfig.Bind then
				if uitoggled == false then
					Main:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 1, true)
					uitoggled = true
					wait(.5)
					UI.Enabled = false
				else
					Main:TweenSize(
						UDim2.new(0, 520, 0, 380),
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quart,
						1,
						true
					)
					UI.Enabled = true
					uitoggled = false
				end
			end
		end
	)

	dragify(ClickFrame, Main)
	local tabs = {}
	local S = false
	function tabs:Tab(Name, icon)
		local FrameTab = Instance.new("Frame")
		local Tab = Instance.new("TextButton")
		local UICorner_3 = Instance.new("UICorner")
		local UICorner_Tab = Instance.new("UICorner")
		local ImageLabel = Instance.new("ImageLabel")
		local TextLabel = Instance.new("TextLabel")

		FrameTab.Name = "FrameTab"
		FrameTab.Parent = Tab
		FrameTab.BackgroundColor3 = Color3.fromRGB(4, 175, 236) --34
		FrameTab.Size = UDim2.new(0, 130, 0, 30)
		FrameTab.BackgroundTransparency = 1.4
		UICorner_Tab.CornerRadius = UDim.new(0, 3)
		UICorner_Tab.Parent = FrameTab

		Tab.Name = "Tab"
		Tab.Parent = TabContainer
		Tab.BackgroundColor3 = Color3.fromRGB(9, 137, 207)
		Tab.Size = UDim2.new(0, 130, 0, 30)
		Tab.BackgroundTransparency = 0.5
		Tab.Text = ""
		UICorner_3.CornerRadius = UDim.new(0, 3)
		UICorner_3.Parent = Tab

		ImageLabel.Parent = Tab
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.Position = UDim2.new(0, 5, 0.2, 0)
		ImageLabel.Size = UDim2.new(0, 20, 0, 20)
		ImageLabel.Image = "http://www.roblox.com/asset/?id=129771247821193" .. icon
		ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.ImageTransparency = 0.2
		ImageLabel.BackgroundTransparency = 1

		TextLabel.Parent = Tab
		TextLabel.Text = Name.." "

		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.Position = UDim2.new(0.342105269, 0, 0.100000001, 0)
		TextLabel.Size = UDim2.new(0, 87, 0, 27)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.TextSize = 12.300
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextTransparency = 0.200

		if TextLabel.Name == Name.." " then
			Tab.Size = UDim2.new(0, 70 + TextLabel.TextBounds.X, 0, 25)
		end

		local Page = Instance.new("ScrollingFrame")
		local Left = Instance.new("ScrollingFrame")
		local Right = Instance.new("ScrollingFrame")
		local UIListLayout_5 = Instance.new("UIListLayout")
		local UIPadding_5 = Instance.new("UIPadding")

		Page.Name = "Page"
		Page.Parent = Bottom
		Page.BackgroundColor3 = Color3.fromRGB(98, 37, 209)
		Page.Position = UDim2.new(0.01, 0, 0.015, 0)
		Page.BackgroundTransparency = 1.000
		Page.Size = UDim2.new(0, 495, 0, 295)
		Page.ScrollBarThickness = 0
		Page.CanvasSize = UDim2.new(0, 0, 0, 0)
		Page.Visible = false
    
		Left.Name = "Left"
		Left.Parent = Page
		Left.Active = true
		Left.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		Left.BackgroundTransparency = 1
		Left.Size = UDim2.new(0, 242, 0, 290)
		Left.ScrollBarThickness = 3
		Left.CanvasSize = UDim2.new(2, 0, 0, 0)

		Right.Name = "Right"
		Right.Parent = Page
		Right.Active = true
		Right.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		Right.BackgroundTransparency = 1
		Right.Size = UDim2.new(0, 242, 0, 290)
		Right.ScrollBarThickness = 3
		Right.CanvasSize = UDim2.new(2, 0, 0, 0)

		local LeftList = Instance.new("UIListLayout")
		local RightList = Instance.new("UIListLayout")

		LeftList.Parent = Left
		LeftList.SortOrder = Enum.SortOrder.LayoutOrder
		LeftList.Padding = UDim.new(0, 0)

		RightList.Parent = Right
		RightList.SortOrder = Enum.SortOrder.LayoutOrder
		RightList.Padding = UDim.new(0, 0)  --5

		UIListLayout_5.Parent = Page
		UIListLayout_5.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_5.Padding = UDim.new(0, 13)

		UIPadding_5.Parent = Page

		if S == false then
			S = true
			Page.Visible = true
			TextLabel.TextColor3 = _G.Color
			TextLabel.TextTransparency = 0
			ImageLabel.ImageColor3 = _G.Color
		end

		Tab.MouseButton1Click:Connect(
			function()
				for _, x in next, TabContainer:GetChildren() do
					if x.Name == "Tab" then
						TweenService:Create(
							x.TextLabel,
							TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{TextColor3 = Color3.fromRGB(255, 255, 255)}
						):Play()
						TweenService:Create(
							x.ImageLabel,
							TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ImageColor3 = Color3.fromRGB(255, 255, 255)}
						):Play()
						TweenService:Create(
							x.ImageLabel,
							TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{ImageTransparency = 0.2}
						):Play()
						TweenService:Create(
							x.TextLabel,
							TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
							{TextTransparency = 0.2}
						):Play()
						for index, y in next, Bottom:GetChildren() do
							y.Visible = false
						end
					end
				end
				TweenService:Create(
					TextLabel,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextColor3 = _G.Color}
				):Play()
				TweenService:Create(
					ImageLabel,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ImageColor3 = _G.Color}
				):Play()
				TweenService:Create(
					ImageLabel,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ImageTransparency = 0}
				):Play()
				TweenService:Create(
					TextLabel,
					TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{TextTransparency = 0}
				):Play()

				Page.Visible = true
			end
		)

		local function GetType(value)
			if value == "Left" then
				return Left
			elseif value == "Right" then
				return Right
			else
				return Left
			end
		end

		game:GetService("RunService").Stepped:Connect(function()
			pcall(function()
				Right.CanvasSize = UDim2.new(0,0,0,RightList.AbsoluteContentSize.Y + 5)
				Left.CanvasSize = UDim2.new(0,0,0,LeftList.AbsoluteContentSize.Y + 5)
			end)
		end)

		local sections = {}
		function sections:Section(Name,side)

			if side == nil then
				return Left
			end

			local Section = Instance.new("Frame")
     		local UICorner_5 = Instance.new("UICorner")
			local Top_2 = Instance.new("Frame")
			local Line = Instance.new("Frame")
			local Sectionname = Instance.new("TextLabel")
			local SectionContainer = Instance.new("Frame")
			local SectionContainer_2 = Instance.new("Frame")
			local UIListLayout_2 = Instance.new("UIListLayout")
			local UIPadding_2 = Instance.new("UIPadding")

			Section.Name = "Section"
			Section.Parent = GetType(side)
			Section.BackgroundColor3 = Color3.fromRGB(25, 25, 25) --25
			Section.BackgroundTransparency = 0.9
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(0, 240, 0, 340)

			UICorner_5.CornerRadius = UDim.new(0, 0) --5
			UICorner_5.Parent = Section

			Top_2.Name = "Top"
			Top_2.Parent = Section
			Top_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Top_2.BackgroundTransparency = 1.000
			Top_2.BorderColor3 = Color3.fromRGB(27, 42, 53)
			Top_2.Size = UDim2.new(0, 238, 0, 35)

			Line.Name = "Line"
			Line.Parent = Top_2
			Line.BackgroundColor3 = _G.Color
			Line.BorderSizePixel = 0
			Line.Size = UDim2.new(0, 239, 0, 1.5)

			spawn(function()
			    while wait() do
			        pcall(function()
      			      wait(0.1) 
			            -- Set the color to a single color (e.g., green)
			            game:GetService('TweenService'):Create(
    			            Line, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
 			               {BackgroundColor3 = Color3.fromRGB(0, 255, 0)} -- green color
			            ):Play() 
			            wait(0.5)            
			        end)
			    end
			end)

			Sectionname.Name = "Sectionname"
			Sectionname.Parent = Top_2
			Sectionname.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Sectionname.BackgroundTransparency = 1.000
			Sectionname.Position = UDim2.new(0.3, 0, 0.1, 0)
			Sectionname.Size = UDim2.new(0, 100, 0, 20)
			Sectionname.Font = Enum.Font.GothamSemibold
			Sectionname.Text = Name
			Sectionname.TextColor3 = Color3.fromRGB(255, 255, 255)
			Sectionname.TextSize = 15.000
			Sectionname.TextTransparency = 0.300
			Sectionname.TextXAlignment = Enum.TextXAlignment.Left

			SectionContainer.Name = "SectionContainer"
			SectionContainer.Parent = Top_2
			SectionContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionContainer.BackgroundTransparency = 1.000
			SectionContainer.BorderSizePixel = 0
			SectionContainer.Position = UDim2.new(0, 0, 0.796416223, 0)
			SectionContainer.Size = UDim2.new(0, 239, 0, 318)

			SectionContainer_2.Name = "SectionContainer_2"
			SectionContainer_2.Parent = Top_2
			SectionContainer_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionContainer_2.BackgroundTransparency = 1.000
			SectionContainer_2.BorderSizePixel = 0
			SectionContainer_2.Position = UDim2.new(0, 0, 0.796416223, 0)
			SectionContainer_2.Size = UDim2.new(0, 239, 0, 318)

			UIListLayout_2.Parent = SectionContainer
			UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout_2.Padding = UDim.new(0, 5)

			UIPadding_2.Parent = SectionContainer
			UIPadding_2.PaddingLeft = UDim.new(0, 5)

			UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
			function()

				Section.Size = UDim2.new(1, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 35) --35
			end)

			local functionitem = {}

			function functionitem:Label(text)
				local textas = {}
				local Label = Instance.new("Frame")
				local Text = Instance.new("TextLabel")
				Label.Name = "Label"
				Label.Parent = SectionContainer
				Label.AnchorPoint = Vector2.new(0.5, 0.5)
				Label.BackgroundTransparency = 1.000
				Label.Size = UDim2.new(0.975000024, 0, 0, 30)

				Text.Name = "Text"
				Text.Parent = Label
				Text.AnchorPoint = Vector2.new(0.5, 0.5)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.BackgroundTransparency = 1.000
				Text.Position = UDim2.new(0.5, 0, 0.5, 0)
				Text.Size = UDim2.new(0, 53, 0, 12)
				Text.ZIndex = 15
				Text.Font = Enum.Font.GothamBold
				Text.Text = text
				Text.TextColor3 = Color3.fromRGB(255, 255, 255)
				Text.TextSize = 12.000
				function textas:Set(newtext)
					Text.Text = newtext
				end
				return textas
			end

			function functionitem:LabelColor(text,color)
				local textas = {}
				local Label = Instance.new("Frame")
				local Text = Instance.new("TextLabel")
				Label.Name = "Label"
				Label.Parent = SectionContainer
				Label.AnchorPoint = Vector2.new(0.5, 0.5)
				Label.BackgroundTransparency = 1.000
				Label.Size = UDim2.new(0.975000024, 0, 0, 30)
 
				Text.Name = "Text"
				Text.Parent = Label
				Text.AnchorPoint = Vector2.new(0.5, 0.5)
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.BackgroundTransparency = 1.000
				Text.Position = UDim2.new(0.5, 0, 0.5, 0)
				Text.Size = UDim2.new(0, 53, 0, 12)
				Text.ZIndex = 16
				Text.Font = Enum.Font.GothamBold
				Text.Text = text
				Text.TextColor3 = Color3.fromRGB(color)
				Text.TextSize = 12.000
				function textas:Set(newtext)
					Text.Text = newtext
				end
				return textas
			end
			function functionitem:Button(Title, default, callback)
				local b3Func = {}
				local callback = callback or function()
				end
				local Tgs = default
				local Button_2 = Instance.new("Frame")
				local UICorner_21 = Instance.new("UICorner")
				local TextLabel_4 = Instance.new("TextLabel")
				local TextButton_4 = Instance.new("TextButton")

				Button_2.Name = "Button"
				Button_2.Parent = SectionContainer
				Button_2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				Button_2.Size = UDim2.new(0.975000024, 0, 0, 25)
				Button_2.ZIndex = 16

				if default then
					Button_2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				else
					Button_2.BackgroundColor3 = _G.Color
				end

				UICorner_21.CornerRadius = UDim.new(0, 4)
				UICorner_21.Parent = Button_2

				TextLabel_4.Parent = Button_2
				TextLabel_4.AnchorPoint = Vector2.new(0.5, 0.5)
				TextLabel_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel_4.BackgroundTransparency = 1.000
				TextLabel_4.Position = UDim2.new(0.5, 0, 0.5, 0)
				TextLabel_4.Size = UDim2.new(0, 40, 0, 12)
				TextLabel_4.ZIndex = 16
				TextLabel_4.Font = Enum.Font.GothamBold
				TextLabel_4.Text = tostring(Title)
				TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel_4.TextSize = 12.000

				TextButton_4.Parent = Button_2
				TextButton_4.BackgroundColor3 = Color3.fromRGB(10, 10, 10) --25
				TextButton_4.BackgroundTransparency = 1.000
				TextButton_4.BorderSizePixel = 0
				TextButton_4.ClipsDescendants = true
				TextButton_4.Size = UDim2.new(1, 0, 1, 0)
				TextButton_4.ZIndex = 16
				TextButton_4.AutoButtonColor = false
				TextButton_4.Font = Enum.Font.Gotham
				TextButton_4.Text = ""
				TextButton_4.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton_4.TextSize = 14.000

				TextButton_4.MouseButton1Click:Connect(
					function()
						Tgs = not Tgs
						b3Func:Update(Tgs)
						CircleClick(Button_2, Mouse.X, Mouse.Y)
					end
				)

				if default then
					TweenService:Create(
						Button_2,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{
							BackgroundColor3 = state and _G.Color or Color3.fromRGB(154, 240, 17)
						}
					):Play()
					callback(default)
					Tgs = default
				end
				function b3Func:Update(state)
					TweenService:Create(
						Button_2,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{
							BackgroundColor3 = state and Color3.fromRGB(154, 240, 17) or _G.Color
						}
					):Play()
					callback(state)
					Tgs = state
				end

				return b3Func
			end

     function functionitem:Seperator(text)
   	  local Seperator = Instance.new("Frame")
	   local Sep2 = Instance.new("TextLabel")

	   Seperator.Name = "Seperator"
	   Seperator.Parent = SectionContainer
	   Seperator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	   Seperator.BackgroundTransparency = 1.000
	   Seperator.Size = UDim2.new(0.975, 0, 0, 20)

	   Sep2.Name = "Sep2"
	   Sep2.Parent = Seperator
	   Sep2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	   Sep2.BackgroundTransparency = 1.000
	   Sep2.Size = UDim2.new(0, 100, 0, 20)
	   Sep2.Position = UDim2.new(0.5, -50, 0, 0)
	   Sep2.Font = Enum.Font.GothamSemibold
	   Sep2.Text = text
	   Sep2.TextColor3 = Color3.fromRGB(255, 255, 255)
       Sep2.TextSize = 15
	   Sep2.TextXAlignment = Enum.TextXAlignment.Center
      end
		function functionitem:Button(Name, callback)
				local Button = Instance.new("Frame")
				local UICorner_6 = Instance.new("UICorner")
				local TextLabel_3 = Instance.new("TextLabel")
				local TextButton = Instance.new("TextButton")

				Button.Name = "Button"
				Button.Parent = SectionContainer
				Button.BackgroundColor3 = _G.Color
				Button.Size = UDim2.new(0.975000024, 0, 0, 20)
				Button.ZIndex = 16

				UICorner_6.CornerRadius = UDim.new(0, 4)
				UICorner_6.Parent = Button

				TextLabel_3.Parent = Button
				TextLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
				TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel_3.BackgroundTransparency = 1.000
				TextLabel_3.Position = UDim2.new(0.5, 0, 0.5, 0)
				TextLabel_3.Size = UDim2.new(0, 40, 0, 12)
				TextLabel_3.ZIndex = 16
				TextLabel_3.Font = Enum.Font.GothamBold
				TextLabel_3.Text = Name
				TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel_3.TextSize = 12.000

				TextButton.Parent = Button
				TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				TextButton.BackgroundTransparency = 1.000
				TextButton.BorderSizePixel = 0
				TextButton.ClipsDescendants = true
				TextButton.Size = UDim2.new(1, 0, 1, 0)
				TextButton.ZIndex = 16
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.Gotham
				TextButton.Text = ""
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.TextSize = 14.000

				TextButton.MouseButton1Click:Connect(
					function()
						CircleClick(Button, Mouse.X, Mouse.Y)
						callback()
					end
				)
			end

			function functionitem:Toggle(Name, default, callback)
				local ToglFunc = {}
				local Tgo = default
				local MainToggle = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local Text = Instance.new("TextLabel")
				local MainToggle_2 = Instance.new("ImageLabel")
				local UICorner_2 = Instance.new("UICorner")
				local MainToggle_3 = Instance.new("ImageLabel")
				local UICorner_3 = Instance.new("UICorner")
				local TextButton = Instance.new("TextButton")

				MainToggle.Name = "MainToggle"
				MainToggle.Parent = SectionContainer
				MainToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				MainToggle.BackgroundTransparency = 0.700
				MainToggle.BorderSizePixel = 0
				MainToggle.ClipsDescendants = true
				MainToggle.Size = UDim2.new(0.975000024, 0, 0, 35)
				MainToggle.ZIndex = 16

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = MainToggle

				Text.Name = "Text"
				Text.Parent = MainToggle
				Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text.BackgroundTransparency = 1.000
				Text.Position = UDim2.new(0, 10, 0, 10)
				Text.Size = UDim2.new(0, 100, 0, 12)
				Text.ZIndex = 16
				Text.Font = Enum.Font.GothamBold
				Text.Text = Name
				Text.TextColor3 = Color3.fromRGB(255, 255, 255)
				Text.TextSize = 12.000
				Text.TextTransparency = 0.4
				Text.TextXAlignment = Enum.TextXAlignment.Left

				MainToggle_2.Name = "MainToggle"
				MainToggle_2.Parent = MainToggle
				MainToggle_2.AnchorPoint = Vector2.new(0.5, 0.5)
				MainToggle_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				MainToggle_2.ClipsDescendants = true
				MainToggle_2.Position = UDim2.new(0.899999976, 0, 0.5, 0)
				MainToggle_2.Size = UDim2.new(0, 23, 0, 23)
				MainToggle_2.ZIndex = 16

				UICorner_2.CornerRadius = UDim.new(0, 3)
				UICorner_2.Parent = MainToggle_2

				MainToggle_3.Name = "MainToggle"
				MainToggle_3.Parent = MainToggle_2
				MainToggle_3.AnchorPoint = Vector2.new(0.5, 0.5)
				MainToggle_3.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				MainToggle_3.ClipsDescendants = true
				MainToggle_3.Position = UDim2.new(0.5, 0, 0.5, 0)
				MainToggle_3.Size = UDim2.new(0, 0, 0, 0)
				MainToggle_3.ZIndex = 16
				MainToggle_3.Image = "http://www.roblox.com/asset/?id=6031068421"
				MainToggle_3.ImageColor3 = _G.Color
				MainToggle_3.Visible =false
				UICorner_3.CornerRadius = UDim.new(0, 3)
				UICorner_3.Parent = MainToggle_3

				TextButton.Name = ""
				TextButton.Parent = MainToggle
				TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				TextButton.BackgroundTransparency = 1.000
				TextButton.BorderSizePixel = 0
				TextButton.Size = UDim2.new(1, 0, 1, 0)
				TextButton.ZIndex = 16
				TextButton.AutoButtonColor = false
				TextButton.Font = Enum.Font.Gotham
				TextButton.Text = ""
				TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextButton.TextSize = 14.000

				TextButton.MouseButton1Click:Connect(
					function()
						Tgo = not Tgo
						ToglFunc:Update(Tgo)
						CircleClick(Button, Mouse.X, Mouse.Y)
					end
				)

				if default then
					if default then
						MainToggle_3.Visible = default
					end
					TweenService:Create(
						Text,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{
							TextTransparency = default and 0 or 0.4
						}
					):Play()
					local we = TweenService:Create(
						MainToggle_3,
						TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{
							Size = default and UDim2.new(0, 25, 0, 25) or UDim2.new(0, 0, 0, 0) 
						}
					)
					we:Play()
					we.Completed:Wait()
					if default == false then
						MainToggle_3.Visible = default
					end
					callback(default)
					Tgo = default
				end
				function ToglFunc:Update(state)
					if state then
						MainToggle_3.Visible = state
					end
					TweenService:Create(
						Text,
						TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{
							TextTransparency = state and 0 or 0.4
						}
					):Play()
					local we = TweenService:Create(
						MainToggle_3,
						TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
						{
							Size = state and UDim2.new(0, 25, 0, 25) or UDim2.new(0, 0, 0, 0) 
						}
					)
					we:Play()
					we.Completed:Wait()
					if state == false then
						MainToggle_3.Visible = state
					end
					callback(state)
					Tgo = state
				end
				return ToglFunc
			end

			function functionitem:Textbox(Name, Placeholder, callback)
				local Textbox = Instance.new("Frame")
				local UICorner_16 = Instance.new("UICorner")
				local Text_5 = Instance.new("TextLabel")
				local TextboxHoler = Instance.new("Frame")
				local UICorner_17 = Instance.new("UICorner")
				local HeadTitle = Instance.new("TextBox")
				Textbox.Name = "Textbox"
				Textbox.Parent = SectionContainer
				Textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				Textbox.BackgroundTransparency = 0.700
				Textbox.BorderSizePixel = 0
				Textbox.ClipsDescendants = true
				Textbox.Size = UDim2.new(0.975000024, 0, 0, 60)
				Textbox.ZIndex = 16

				UICorner_16.CornerRadius = UDim.new(0, 4)
				UICorner_16.Parent = Textbox

				Text_5.Name = "Text"
				Text_5.Parent = Textbox
				Text_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text_5.BackgroundTransparency = 1.000
				Text_5.Position = UDim2.new(0, 10, 0, 10)
				Text_5.Size = UDim2.new(0, 43, 0, 12)
				Text_5.ZIndex = 16
				Text_5.Font = Enum.Font.GothamBold
				Text_5.Text = Name
				Text_5.TextColor3 = _G.Color
				Text_5.TextSize = 11.000
				Text_5.TextXAlignment = Enum.TextXAlignment.Left

				TextboxHoler.Name = "TextboxHoler"
				TextboxHoler.Parent = Textbox
				TextboxHoler.AnchorPoint = Vector2.new(0.5, 0.5)
				TextboxHoler.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
				TextboxHoler.BackgroundTransparency = 1.000
				TextboxHoler.BorderSizePixel = 0
				TextboxHoler.Position = UDim2.new(0.5, 0, 0.5, 13)
				TextboxHoler.Size = UDim2.new(0.970000029, 0, 0, 30)

				UICorner_17.CornerRadius = UDim.new(0, 6)
				UICorner_17.Parent = TextboxHoler

				HeadTitle.Name = "HeadTitle"
				HeadTitle.Parent = TextboxHoler
				HeadTitle.AnchorPoint = Vector2.new(0.5, 0.5)
				HeadTitle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				HeadTitle.BackgroundTransparency = 1.000
				HeadTitle.BorderSizePixel = 0
				HeadTitle.ClipsDescendants = true
				HeadTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
				HeadTitle.Size = UDim2.new(0.949999988, 0, 0, 40)
				HeadTitle.ZIndex = 16
				HeadTitle.Font = Enum.Font.GothamBold
				HeadTitle.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
				HeadTitle.PlaceholderText = Placeholder
				HeadTitle.Text = ""
				HeadTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
				HeadTitle.TextSize = 13.000
				HeadTitle.TextTransparency = 0.700
				HeadTitle.TextXAlignment = Enum.TextXAlignment.Left
				HeadTitle.FocusLost:Connect(
					function(ep)
						if ep then
							if #HeadTitle.Text > 0 then
								callback(HeadTitle.Text)
								HeadTitle.Text = ""
							end
						end
					end
				)
			end

			function functionitem:Dropdown(Name, list, default, callback)
				local Dropfunc = {}

				local MainDropDown = Instance.new("Frame")
				local UICorner_7 = Instance.new("UICorner")
				local MainDropDown_2 = Instance.new("Frame")
				local UICorner_8 = Instance.new("UICorner")
				local v = Instance.new("TextButton")
				local Text_2 = Instance.new("TextLabel")
				local ImageButton = Instance.new("ImageButton")
				local Scroll_Items = Instance.new("ScrollingFrame")
				local UIListLayout_3 = Instance.new("UIListLayout")
				local UIPadding_3 = Instance.new("UIPadding")

				MainDropDown.Name = "MainDropDown"
				MainDropDown.Parent = SectionContainer
				MainDropDown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				MainDropDown.BackgroundTransparency = 0.700
				MainDropDown.BorderSizePixel = 0
				MainDropDown.ClipsDescendants = true
				MainDropDown.Size = UDim2.new(0.975000024, 0, 0, 30)
				MainDropDown.ZIndex = 16

				UICorner_7.CornerRadius = UDim.new(0, 4)
				UICorner_7.Parent = MainDropDown

				MainDropDown_2.Name = "MainDropDown"
				MainDropDown_2.Parent = MainDropDown
				MainDropDown_2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				MainDropDown_2.BackgroundTransparency = 0.700
				MainDropDown_2.BorderSizePixel = 0
				MainDropDown_2.ClipsDescendants = true
				MainDropDown_2.Size = UDim2.new(1, 0, 0, 30)
				MainDropDown_2.ZIndex = 16

				UICorner_8.CornerRadius = UDim.new(0, 4)
				UICorner_8.Parent = MainDropDown_2

				v.Name = "v"
				v.Parent = MainDropDown_2
				v.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				v.BackgroundTransparency = 1.000
				v.BorderSizePixel = 0
				v.Size = UDim2.new(1, 0, 1, 0)
				v.ZIndex = 16
				v.AutoButtonColor = false
				v.Font = Enum.Font.GothamBold
				v.Text = ""
				v.TextColor3 = Color3.fromRGB(255, 255, 255)
				v.TextSize = 12.000
				function getpro()
					if default then
						if table.find(list, default) then
							callback(default)
							return Name .. " : " .. default
						else
							return Name .. " : "
						end
					else
						return Name .. " : "
					end
				end
				Text_2.Name = "Text"
				Text_2.Parent = MainDropDown_2
				Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text_2.BackgroundTransparency = 1.000
				Text_2.Position = UDim2.new(0, 10, 0, 10)
				Text_2.Size = UDim2.new(0, 62, 0, 12)
				Text_2.ZIndex = 16
				Text_2.Font = Enum.Font.GothamBold
				Text_2.Text = getpro()
				Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
				Text_2.TextSize = 12.000
				Text_2.TextXAlignment = Enum.TextXAlignment.Left

				ImageButton.Parent = MainDropDown_2
				ImageButton.AnchorPoint = Vector2.new(0, 0.5)
				ImageButton.BackgroundTransparency = 1.000
				ImageButton.Position = UDim2.new(1, -25, 0.5, 0)
				ImageButton.Size = UDim2.new(0, 12, 0, 12)
				ImageButton.ZIndex = 16
				ImageButton.Image = "http://www.roblox.com/asset/?id=6282522798"

				Scroll_Items.Name = "Scroll_Items"
				Scroll_Items.Parent = MainDropDown
				Scroll_Items.Active = true
				Scroll_Items.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Scroll_Items.BackgroundTransparency = 1.000
				Scroll_Items.BorderSizePixel = 0
				Scroll_Items.Position = UDim2.new(0, 0, 0, 35)
				Scroll_Items.Size = UDim2.new(1, 0, 1, -35)
				Scroll_Items.ZIndex = 16
				Scroll_Items.CanvasSize = UDim2.new(2, 0, 0, 0) --265
				Scroll_Items.ScrollBarThickness = 3

				UIListLayout_3.Parent = Scroll_Items
				UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_3.Padding = UDim.new(0, 5)
				UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
				function()
					Scroll_Items.CanvasSize = UDim2.new(1, 0, 0, UIListLayout_2.AbsoluteContentSize.Y+40)
				end
				)
				UIPadding_3.Parent = Scroll_Items
				UIPadding_3.PaddingLeft = UDim.new(0, 10)
				UIPadding_3.PaddingTop = UDim.new(0, 5)

				function Dropfunc:TogglePanel(state)
					TweenService:Create(
						MainDropDown,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = state and UDim2.new(0.975000024, 0, 0, 599) or UDim2.new(0.975000024, 0, 0, 30)}
					):Play()
					TweenService:Create(
						ImageButton,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Rotation = state and 180 or 0}
					):Play()
				end
				local Tof = false
				ImageButton.MouseButton1Click:Connect(
					function()
						Tof = not Tof
						Dropfunc:TogglePanel(Tof)
					end
				)
				v.MouseButton1Click:Connect(
					function()
						Tof = not Tof
						Dropfunc:TogglePanel(Tof)
					end
				)
				function Dropfunc:Clear()
					for i, v in next, Scroll_Items:GetChildren() do
						if v:IsA("TextButton") then 
							v:Destroy()
						end
					end
				end

				function Dropfunc:Add(Text)
					local _5 = Instance.new("TextButton")
					local UICorner_9 = Instance.new("UICorner")
					_5.Name = Text
					_5.Parent = Scroll_Items
					_5.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					_5.BorderSizePixel = 0
					_5.ClipsDescendants = true
					_5.Size = UDim2.new(1, -10, 0, 20)
					_5.ZIndex = 17
					_5.AutoButtonColor = false
					_5.Font = Enum.Font.GothamBold
					_5.Text = Text
					_5.TextColor3 = Color3.fromRGB(255, 255, 255)
					_5.TextSize = 12.000

					UICorner_9.CornerRadius = UDim.new(0, 4)
					UICorner_9.Parent = _5

					_5.MouseButton1Click:Connect(
						function()
							if _x == nil then
								Tof = false
								Dropfunc:TogglePanel(Tof)
								callback(Text)
								Text_2.Text = Text
								_x = nil
							end
						end
					)
				end
				for i, v in next, list do
					Dropfunc:Add(v)
				end


				return Dropfunc
			end

			function functionitem:MultiDropdown(Name, list, default, callback)
				local Dropfunc = {}

				local MainDropDown = Instance.new("Frame")
				local UICorner_7 = Instance.new("UICorner")
				local MainDropDown_2 = Instance.new("Frame")
				local UICorner_8 = Instance.new("UICorner")
				local v = Instance.new("TextButton")
				local Text_2 = Instance.new("TextLabel")
				local ImageButton = Instance.new("ImageButton")
				local Scroll_Items = Instance.new("ScrollingFrame")
				local UIListLayout_3 = Instance.new("UIListLayout")
				local UIPadding_3 = Instance.new("UIPadding")

				MainDropDown.Name = "MainDropDown"
				MainDropDown.Parent = SectionContainer
				MainDropDown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				MainDropDown.BackgroundTransparency = 0.700
				MainDropDown.BorderSizePixel = 0
				MainDropDown.ClipsDescendants = true
				MainDropDown.Size = UDim2.new(0.975000024, 0, 0, 30)
				MainDropDown.ZIndex = 16

				UICorner_7.CornerRadius = UDim.new(0, 4)
				UICorner_7.Parent = MainDropDown

				MainDropDown_2.Name = "MainDropDown"
				MainDropDown_2.Parent = MainDropDown
				MainDropDown_2.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				MainDropDown_2.BackgroundTransparency = 0.700
				MainDropDown_2.BorderSizePixel = 0
				MainDropDown_2.ClipsDescendants = true
				MainDropDown_2.Size = UDim2.new(1, 0, 0, 30)
				MainDropDown_2.ZIndex = 16

				UICorner_8.CornerRadius = UDim.new(0, 4)
				UICorner_8.Parent = MainDropDown_2

				v.Name = "v"
				v.Parent = MainDropDown_2
				v.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				v.BackgroundTransparency = 1.000
				v.BorderSizePixel = 0
				v.Size = UDim2.new(1, 0, 1, 0)
				v.ZIndex = 16
				v.AutoButtonColor = false
				v.Font = Enum.Font.GothamBold
				v.Text = ""
				v.TextColor3 = Color3.fromRGB(255, 255, 255)
				v.TextSize = 12.000
				function getpro()
					if default then
						for i, v in next, default do
							if table.find(list, v) then
								callback(default)
								return Name .. " : " .. table.concat(default, ", ")
							else
								return Name
							end
						end
					else
						return Name
					end
				end

				Text_2.Name = "Text"
				Text_2.Parent = MainDropDown_2
				Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Text_2.BackgroundTransparency = 1.000
				Text_2.Position = UDim2.new(0, 10, 0, 10)
				Text_2.Size = UDim2.new(0, 62, 0, 12)
				Text_2.ZIndex = 16
				Text_2.Font = Enum.Font.GothamBold
				Text_2.Text = getpro()
				Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
				Text_2.TextSize = 12.000
				Text_2.TextXAlignment = Enum.TextXAlignment.Left

				ImageButton.Parent = MainDropDown_2
				ImageButton.AnchorPoint = Vector2.new(0, 0.5)
				ImageButton.BackgroundTransparency = 1.000
				ImageButton.Position = UDim2.new(1, -25, 0.5, 0)
				ImageButton.Size = UDim2.new(0, 12, 0, 12)
				ImageButton.ZIndex = 16
				ImageButton.Image = "http://www.roblox.com/asset/?id=6282522798"
				local DropTable = {}
				Scroll_Items.Name = "Scroll_Items"
				Scroll_Items.Parent = MainDropDown
				Scroll_Items.Active = true
				Scroll_Items.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Scroll_Items.BackgroundTransparency = 1.000
				Scroll_Items.BorderSizePixel = 0
				Scroll_Items.Position = UDim2.new(0, 0, 0, 35)
				Scroll_Items.Size = UDim2.new(1, 0, 1, -35)
				Scroll_Items.ZIndex = 16
				Scroll_Items.CanvasSize = UDim2.new(0, 0, 0, 265)
				Scroll_Items.ScrollBarThickness = 0

				UIListLayout_3.Parent = Scroll_Items
				UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_3.Padding = UDim.new(0, 5)
				UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
				function()
					Scroll_Items.CanvasSize = UDim2.new(1, 0, 0, UIListLayout_2.AbsoluteContentSize.Y+40)
				end
				)
				UIPadding_3.Parent = Scroll_Items
				UIPadding_3.PaddingLeft = UDim.new(0, 10)
				UIPadding_3.PaddingTop = UDim.new(0, 5)

				function Dropfunc:TogglePanel(state)
					TweenService:Create(
						MainDropDown,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Size = state and UDim2.new(0.975000024, 0, 0, 200) or UDim2.new(0.975000024, 0, 0, 30)}
					):Play()
					TweenService:Create(
						ImageButton,
						TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{Rotation = state and 180 or 0}
					):Play()
				end
				local Tof = false
				ImageButton.MouseButton1Click:Connect(
					function()
						Tof = not Tof
						Dropfunc:TogglePanel(Tof)
					end
				)
				v.MouseButton1Click:Connect(
					function()
						Tof = not Tof
						Dropfunc:TogglePanel(Tof)
					end
				)
				function Dropfunc:Add(Text)
					local _5 = Instance.new("TextButton")
					local UICorner_9 = Instance.new("UICorner")
					_5.Name = Text
					_5.Parent = Scroll_Items
					_5.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					_5.BorderSizePixel = 0
					_5.ClipsDescendants = true
					_5.Size = UDim2.new(1, -10, 0, 20)
					_5.ZIndex = 17
					_5.AutoButtonColor = false
					_5.Font = Enum.Font.GothamBold
					_5.Text = Text
					_5.TextColor3 = Color3.fromRGB(255, 255, 255)
					_5.TextSize = 12.000

					UICorner_9.CornerRadius = UDim.new(0, 4)
					UICorner_9.Parent = _5
					_5.MouseButton1Click:Connect(
						function()
							if not table.find(DropTable, Text) then
								table.insert(DropTable, Text)
								callback(DropTable, Text)
								Text_2.Text = Name .. " : " .. table.concat(DropTable, ", ")
								TweenService:Create(
									_5,
									TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{TextColor3 = _G.Color}
								):Play()
							else
								TweenService:Create(
									_5,
									TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
									{TextColor3 = _G.Color}
								):Play()
								for i2, v2 in pairs(DropTable) do
									if v2 == Text then
										table.remove(DropTable, i2)
										Text_2.Text = Name .. " : " .. table.concat(DropTable, ", ")
									end
								end
								callback(DropTable, Text)
							end
						end
					)
				end
				function Dropfunc:Clear()
					for i, v in next, Scroll_Items:GetChildren() do
						if v:IsA("TextButton")  then 
							v:Destroy()

						end
					end 
				end

				for i, v in next, list do
					Dropfunc:Add(v)
				end
				return Dropfunc
			end

  function functionitem:Slider(text, floor, min, max, de, callback)
    local SliderFrame = Instance.new("Frame")
    local LabelNameSlider = Instance.new("TextLabel")
    local ShowValueFrame = Instance.new("Frame")
    local CustomValue = Instance.new("TextBox")
    local ShowValueFrameUICorner = Instance.new("UICorner")
    local ValueFrame = Instance.new("Frame")
    local ValueFrameUICorner = Instance.new("UICorner")
    local PartValue = Instance.new("Frame")
    local PartValueUICorner = Instance.new("UICorner")
    local MainValue = Instance.new("Frame")
    local MainValueUICorner = Instance.new("UICorner")
    local sliderfunc = {}

    SliderFrame.Name = "SliderFrame"
    SliderFrame.Parent = SectionContainer
    SliderFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    SliderFrame.Position = UDim2.new(0.109489053, 0, 0.708609283, 0)
    SliderFrame.Size = UDim2.new(0.975000024, 0, 0, 45)
    SliderFrame.BackgroundTransparency = 0.8  -- Adjusted transparency

    local UiToggle_UiStroke28 = Instance.new("UIStroke")
    UiToggle_UiStroke28.Color = Color3.fromRGB(60, 60, 60)
    UiToggle_UiStroke28.Thickness = 1
    UiToggle_UiStroke28.Name = "UiToggle_UiStroke1"
    UiToggle_UiStroke28.Parent = SliderFrame

    local UICorner_7 = Instance.new("UICorner")
    UICorner_7.CornerRadius = UDim.new(0, 4)
    UICorner_7.Parent = SliderFrame

    LabelNameSlider.Name = "LabelNameSlider"
    LabelNameSlider.Parent = SliderFrame
    LabelNameSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LabelNameSlider.BackgroundTransparency = 1.000
    LabelNameSlider.Position = UDim2.new(0.0729926974, 0, 0.0396823473, 0)
    LabelNameSlider.Size = UDim2.new(0, 182, 0, 25)
    LabelNameSlider.Font = Enum.Font.GothamBold
    LabelNameSlider.Text = tostring(text)
    LabelNameSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    LabelNameSlider.TextSize = 11.000
    LabelNameSlider.TextXAlignment = Enum.TextXAlignment.Left

    ShowValueFrame.Name = "ShowValueFrame"
    ShowValueFrame.Parent = SliderFrame
    ShowValueFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    ShowValueFrame.BackgroundTransparency = 0.8  -- Adjusted transparency
    ShowValueFrame.Position = UDim2.new(0.733576655, 0, 0.0656082779, 0)
    ShowValueFrame.Size = UDim2.new(0, 58, 0, 21)

    CustomValue.Name = "CustomValue"
    CustomValue.Parent = ShowValueFrame
    CustomValue.AnchorPoint = Vector2.new(0.5, 0.5)
    CustomValue.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CustomValue.BackgroundTransparency = 0.9  -- Adjusted transparency for the text box
    CustomValue.Position = UDim2.new(0.5, 0, 0.5, 0)
    CustomValue.Size = UDim2.new(0, 55, 0, 21)
    CustomValue.Font = Enum.Font.GothamBold
    CustomValue.Text = "50"
    CustomValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    CustomValue.TextSize = 11.000

    ShowValueFrameUICorner.CornerRadius = UDim.new(0, 4)
    ShowValueFrameUICorner.Name = "ShowValueFrameUICorner"
    ShowValueFrameUICorner.Parent = CustomValue

    ValueFrame.Name = "ValueFrame"
    ValueFrame.Parent = SliderFrame
    ValueFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ValueFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ValueFrame.BackgroundTransparency = 0.9  -- Adjusted transparency
    ValueFrame.Position = UDim2.new(0.5, 0, 0.8, 0)
    ValueFrame.Size = UDim2.new(0, 200, 0, 5)

    ValueFrameUICorner.CornerRadius = UDim.new(0, 30)
    ValueFrameUICorner.Name = "ValueFrameUICorner"
    ValueFrameUICorner.Parent = ValueFrame

    PartValue.Name = "PartValue"
    PartValue.Parent = ValueFrame
    PartValue.AnchorPoint = Vector2.new(0.5, 0.5)
    PartValue.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PartValue.BackgroundTransparency = 1.0  -- Full transparency
    PartValue.Position = UDim2.new(0.5, 0, 0.8, 0)
    PartValue.Size = UDim2.new(0, 200, 0, 5)

    PartValueUICorner.CornerRadius = UDim.new(0, 30)
    PartValueUICorner.Name = "PartValueUICorner"
    PartValueUICorner.Parent = PartValue

    MainValue.Name = "MainValue"
    MainValue.Parent = ValueFrame
    MainValue.BackgroundColor3 = _G.Color
    MainValue.Size = UDim2.new((de or 0) / max, 0, 0, 5)
    MainValue.BorderSizePixel = 0
    MainValue.BackgroundTransparency = 0.9  -- Transparency for main value

    MainValueUICorner.CornerRadius = UDim.new(0, 30)
    MainValueUICorner.Name = "MainValueUICorner"
    MainValueUICorner.Parent = MainValue

    local ConneValue = Instance.new("Frame")
    ConneValue.Name = "ConneValue"
    ConneValue.Parent = PartValue
    ConneValue.AnchorPoint = Vector2.new(0.7, 0.7)
    ConneValue.BackgroundColor3 = _G.Color
    ConneValue.Position = UDim2.new((de or 0) / max, 0.5, 0.5, 0)
    ConneValue.Size = UDim2.new(0, 10, 0, 10)
    ConneValue.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = ConneValue

    -- Hiển thị giá trị mặc định
    if floor == true then
        CustomValue.Text = tostring(de and string.format("%.0f", (de / max) * (max - min) + min) or 0)
    else
        CustomValue.Text = tostring(de and math.floor((de / max) * (max - min) + min) or 0)
    end

    -- Tính toán giá trị khi kéo slider
    local function move(input)
        local pos = UDim2.new(
            math.clamp((input.Position.X - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X, 0, 1),
            0,
            0.5,
            0
        )
        local pos1 = UDim2.new(
            math.clamp((input.Position.X - ValueFrame.AbsolutePosition.X) / ValueFrame.AbsoluteSize.X, 0, 1),
            0,
            0,
            5
        )
        MainValue:TweenSize(pos1, "Out", "Sine", 0.2, true)
        ConneValue:TweenPosition(pos, "Out", "Sine", 0.2, true)

        local value
        if floor == true then
            value = string.format("%.0f", ((pos.X.Scale * max) / max) * (max - min) + min)
        else
            value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
        end

        CustomValue.Text = tostring(value)
        callback(value)
    end

    -- Cài đặt sự kiện khi kéo
    local dragging = false
    ConneValue.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    ConneValue.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Cập nhật khi kéo slider
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            move(input)
        end
    end)

    -- Cập nhật giá trị khi thay đổi CustomValue
    CustomValue.FocusLost:Connect(function()
        if CustomValue.Text == "" then
            CustomValue.Text = de
        end
        if tonumber(CustomValue.Text) > max then
            CustomValue.Text = max
        end
        MainValue:TweenSize(UDim2.new((CustomValue.Text or 0) / max, 0, 0, 5), "Out", "Sine", 0.2, true)
        ConneValue:TweenPosition(UDim2.new((CustomValue.Text or 0) / max, 0, 0.6, 0), "Out", "Sine", 0.2, true)

        if floor == true then
            CustomValue.Text = tostring(string.format("%.0f", (CustomValue.Text / max) * (max - min) + min))
        else
            CustomValue.Text = tostring(math.floor((CustomValue.Text / max) * (max - min) + min))
        end

        pcall(callback, CustomValue.Text)
    end)

    return sliderfunc
end


			return functionitem
		end
		return sections
	end
	return tabs
end

----------------------------------------------------------------------------------------------------------------------------------------------

local Window = library:NaJa()

local Main = Window:Tab("General","14477284625")
local AutoQuest = Window:Tab("Items Quest","11446859498")
local Events = Window:Tab("Auto Sea Event","10734941354")
local Racer = Window:Tab("Race V4 & Esp","10747372167")
local RaidFruit = Window:Tab("Raid & Fruits","10734975692")
local Playerrss = Window:Tab("Teleport & PVP","10734910680")
local MiscShop = Window:Tab("Shop & Misc","10723434557")
local AutoStatus = Window:Tab("Status Server","10709770317")
local WebhookTab = Window:Tab("Webhook","10723434557")
local ConfigTab = Window:Tab("Config","10723434557")


-- ========== WEBHOOK TAB SECTIONS ==========
local WebhookSection = WebhookTab:Section("Discord Webhook","Left")

WebhookSection:Textbox("Your Webhook URL", "Paste URL here", function(value)
    _G.UserWebhookURL = value
end)

WebhookSection:Button("Test Webhook", function()
    SendUserWebhook()
end)

WebhookSection:Button("Send Progress Now", function()
    SendUserWebhook()
end)

-- ========== CONFIG TAB SECTIONS ==========
local ConfigSection = ConfigTab:Section("Save & Load","Left")

ConfigSection:Button("Save Config", function()
    SaveConfig()
end)

ConfigSection:Button("Load Config", function()
    LoadConfig()
end)

ConfigSection:Button("Delete Config", function()
    DeleteConfig()
end)

local AutoFarm = Main:Section("Auto Main Farm","Left")
local Settings = Main:Section("Settings Mastery","Right")

local Items = AutoQuest:Section("Auto Items Quest","Left")
local Dragon = AutoQuest:Section("Auto Dragon Quest","Right")

local Volcano = Events:Section("Auto Prehistoric","Left")
local Events = Events:Section("Auto Events","Right")

local Trailers = Racer:Section("Auto Trailer V4","Left")
local Espbruh = Racer:Section("Auto Esp Player","Right")

local AutoRaid = RaidFruit:Section("Auto Raid Fruit","Left")
local Autofruit = RaidFruit:Section("Auto Random Fruit","Right")

local Teleport = Playerrss:Section("Teleport Island","Left")
local Playersss = Playerrss:Section("Players Combat","Right")

local TikTokShop = MiscShop:Section("Lazada Shopee","Left")
local AutoMisc = MiscShop:Section("Misc Auto","Right")

local Status = AutoStatus:Section("Status Number","Left")
local StatusTime = AutoStatus:Section("Status Time Game","Right")

_G.SelectWeapon = "Melee"
  AutoFarm:Dropdown("Select Weapons",{"Melee","Sword","Gun","Blox Fruit"},{"Melee"},function(v)
    _G.SelectWeapon = v
     end)

    task.spawn(function()
        while wait() do
	    	pcall(function()
 			if _G.SelectWeapon == "Melee" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Melee" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.SelectWeapon = v.Name
						end
					end
				end
			elseif _G.SelectWeapon == "Sword" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Sword" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.SelectWeapon = v.Name
						end
					end
				end
			elseif _G.SelectWeapon == "Gun" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Gun" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.SelectWeapon = v.Name
						end
					end
				end
			elseif _G.SelectWeapon == "Fruit" then
				for i ,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
					if v.ToolTip == "Blox Fruit" then
						if game.Players.LocalPlayer.Backpack:FindFirstChild(tostring(v.Name)) then
				 			_G.SelectWeapon = v.Name
			    			end
	      				end
	    			end
		    	end
     		end)
     	end
    end)

   AutoFarm:Toggle("Auto Farm Level",false,function(value)
    _G.AutoFarm = value
      StopTween(_G.AutoFarm)		
       end)
        
        spawn(function()
        while wait() do
            if _G.AutoFarm then
                pcall(function()
                    local QuestTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
                    CheckQuest()
                    if not string.find(QuestTitle, NameMon) then
                        StartBring = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                        StartBring = false
                        if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude > 1500 then
						TP1(CFrameQuest)
						elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude < 1500 then
						TP1(CFrameQuest)
						end
					else
						TP1(CFrameQuest)
					end
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - CFrameQuest.Position).Magnitude <= 20 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest",NameQuest,LevelQuest)
                    end
                    elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "kissed") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if string.find(v.Name,"kissed Warrior") then
                                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                        if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                            repeat task.wait()
                                                EquipWeapon(_G.SelectWeapon)
                                                
                                                PosMon = v.HumanoidRootPart.CFrame
                                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                v.HumanoidRootPart.CanCollide = false
                                                v.Humanoid.WalkSpeed = 0
                                                v.Head.CanCollide = false
                                                MonFarm = v.Name          
                                                v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                                StartBring = true
                                                game:GetService'VirtualUser':CaptureController()
                                                game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                            until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                        else
                                            StartBring = false
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                        end
                                    end
                                elseif string.find(v.Name,"kissed Warrior") == nil then
                                    TP1(CFrameMon)
                                    StartBring = false
                                    if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0,20,0))
                                    end
                                end
                            end
                        else
                            if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                        if v.Name == Mon then
                                            if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) then
                                                repeat task.wait()
                                                    EquipWeapon(_G.SelectWeapon)
                                                     AutoHaki()                                            
                                                    PosMon = v.HumanoidRootPart.CFrame
                                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                    v.HumanoidRootPart.CanCollide = false
                                                    v.Humanoid.WalkSpeed = 0
                                                    v.Head.CanCollide = false
                                                    v.HumanoidRootPart.Size = Vector3.new(70,70,70)
                                                    StartBring = true
                                                    MonFarm = v.Name          
                                                    game:GetService'VirtualUser':CaptureController()
                                                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                                until not _G.AutoFarm or v.Humanoid.Health <= 0 or not v.Parent or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                            else
                                                StartBring = false
                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        end
                                    end
                                end
                            else
                                TP1(CFrameMon)
                                StartBring = false
                                if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                    TP1(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0,20,0))
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
  
  AutoFarm:Toggle("Đánh quái ở gần", false,function(value)
         _G.AutoNear = value
        StopTween(_G.AutoNear)
    end)
     
     spawn(function()
    while wait() do
        if _G.AutoNear then
            pcall(function()
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        -- Check if within 5000 studs
                        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if distance <= 5000 then
                            repeat
                                wait(_G.Fast_Delay)
                                StartBring = true
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name

                            until not _G.AutoNear or not v.Parent or v.Humanoid.Health <= 0 or not game.Workspace.Enemies:FindFirstChild(v.Name)
                            StartBring = false
                           end
                        end
                     end
                  end)
                end
             end
          end)
          
     AutoFarm:Seperator("Auto Farm Mastery")       
     
     if World1 or World2 then
     AutoFarm:Dropdown("Select Regime Farm",{"Farm Level Mastery", "Farm Level Mastery No Quest"},{"Farm Level Mastery No Quest"},function(Value)
       _G.selectFruitFarm = Value
      end)
    end      
      if World3 then
    AutoFarm:Dropdown("Select Regime Farm",{"Farm Level Mastery", "Farm Level Mastery No Quest","Farm Bone Mastery","Farm Cake Mastery"},{"Farm Level Mastery No Quest"},function(Value)
       _G.selectFruitFarm = Value
      end)
    end      

      AutoFarm:Toggle("Auto Farm Mastery Fruit", false,function(value)
         _G.AutoFarmFruits = value 
         StopTween(_G.AutoFarmFruits)
        end)  
                                          
spawn(function()
    while task.wait() do
        if _G.UseSkill then
            pcall(function()
                for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                 if v.Name == MonFarm 
                 and v:FindFirstChild("Humanoid") 
                 and v:FindFirstChild("HumanoidRootPart") 
                 and v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                 repeat
                 game:GetService("RunService").Heartbeat:Wait()
                 EquipWeapon(game.Players.LocalPlayer.Data.DevilFruit.Value)
                 topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                 PositionSkillMasteryDevilFruit = v.HumanoidRootPart.Position
                 local char = game.Players.LocalPlayer.Character
                 local fruitName = game.Players.LocalPlayer.Data.DevilFruit.Value
                 local fruit = char:FindFirstChild(fruitName)
                 if fruit then
                 fruit.MousePos.Value = PositionSkillMasteryDevilFruit
                 local DevilFruitMastery = fruit.Level.Value
                 if SkillZ and DevilFruitMastery >= 1 then
                 game:service("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                 wait()
                 game:service("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
                 end
                 if SkillX and DevilFruitMastery >= 1 then
                 game:service("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                 wait()
                 game:service("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                 end
                 if SkillC and DevilFruitMastery >= 1 then
                 game:service("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                 wait()
                 game:service("VirtualInputManager"):SendKeyEvent(false, "C", false, game)
                 end
                 if SkillV and DevilFruitMastery >= 1 then
                 game:service("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
                 wait()
                 game:service("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
                 end
                 if SkillF and DevilFruitMastery >= 1 then
                 game:service("VirtualInputManager"):SendKeyEvent(true, "F", false, game)
                 wait()
                game:service("VirtualInputManager"):SendKeyEvent(false, "F", false, game)
                end
               end
             until not _G.AutoFarmFruits or not _G.UseSkill or v.Humanoid.Health == 0
             end
            end
           end)
          end
         end
       end)

spawn(function()
    while wait() do
        if _G.AutoFarmFruits and _G.selectFruitFarm == 'Farm Level Mastery No Quest' then
            pcall(function()
                CheckQuest()
                TP1(CFrameQuest)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == Mon then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = true
                            else
                                _G.UseSkill = false
                                bringmob = true
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                            end
                        until not _G.AutoFarmFruits or not MasteryType == 'Farm Level Mastery No Quest' or not v.Parent or v.Humanoid.Health == 0 or not _G.selectFruitFarm == 'Farm Level Mastery No Quest'
                         bringmob = false
                        _G.UseSkill = false
                    end
                end
            end
        end
    end
end)

spawn(function()
    while wait() do
        if _G.AutoFarmFruits and _G.selectFruitFarm == 'Farm Level Mastery' then
            pcall(function()
                CheckQuest()
                if not string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    TP1(CFrameQuest)
                end
                if (CFrameQuest.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                end
            end)
            if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, NameMon) or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            if v.Name == Mon then
                                repeat wait(_G.Fast_Delay)
                                    if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                        _G.UseSkill = true
                                    else
                                        _G.UseSkill = false
                                        bringmob = true
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                        v.HumanoidRootPart.Transparency = 1
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.CanCollide = false
                                        FarmPos = v.HumanoidRootPart.CFrame
                                        MonFarm = v.Name
                                    end
                                until not _G.AutoFarmFruits or not MasteryType == 'Farm Level Mastery' or not v.Parent or v.Humanoid.Health == 0 or not _G.selectFruitFarm == 'Farm Level Mastery'
                                bringmob = false
                                _G.UseSkill = false
                            end
                        end
                    end
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if _G.AutoFarmFruits and _G.selectFruitFarm == 'Farm Bone Mastery' then
            pcall(function()
                local boneframe = CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625)
                TP1(boneframe)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = true

                            else
                                _G.UseSkill = false
                                bringmob = true                                
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                            end
                        until not _G.AutoFarmFruits or not MasteryType == 'Farm Bone Mastery' or not v.Parent or v.Humanoid.Health == 0 or not _G.selectFruitFarm == 'Farm Bone Mastery'
                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Reborn Skeleton" then
               topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
               elseif v.Name == "Living Zombie" then
               topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
               elseif v.Name == "Demonic Soul" then
               topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                elseif v.Name == "Posessed Mummy" then
               topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                end
            end
        end
    end
end)
spawn(function()
    while wait() do
        if _G.AutoFarmFruits and _G.selectFruitFarm == 'Farm Cake Mastery' then
            pcall(function()
                local cakepos = CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375)
                TP1(cakepos)
            end)
            for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if v.Name == "Cookie Crafter" or v.Name == "Cake Guard" or v.Name == "Baking Staff" or v.Name == "Head Baker" then
                        repeat wait(_G.Fast_Delay)
                            if v.Humanoid.Health <= v.Humanoid.MaxHealth * KillPercent / 100 then
                                _G.UseSkill = true
                            else
                                _G.UseSkill = false
                                bringmob = true                                
                                AutoHaki()
                                StartBring = false
                                EquipWeapon(_G.SelectWeapon)
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                FarmPos = v.HumanoidRootPart.CFrame
                                MonFarm = v.Name
                            end
                        until not _G.AutoFarmFruits or not MasteryType == 'Farm Cake Mastery' or not v.Parent or v.Humanoid.Health == 0 or not _G.selectFruitFarm == 'Farm Cake Mastery'
                        bringmob = false
                        _G.UseSkill = false
                    end
                end
            end
            for i, v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if v.Name == "Cookie Crafter" then
                    topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                elseif v.Name == "Cake Guard" then
                    topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                elseif v.Name == "Baking Staff" then
                    topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                elseif v.Name == "Head Baker" then
                    topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                end
            end
        end
    end
end)

      AutoFarm:Seperator("Auto Farm rương")       
         
       AutoFarm:Toggle("Auto Farm Chest", false,function(value)
         _G.FarmChest = value 
         StopTween(_G.FarmChest)
        end)  
    
    spawn(function()
	while wait() do
		if _G.FarmChest then
			local Players = game:GetService("Players")
			local Player = Players.LocalPlayer
			local Character = Player.Character or Player.CharacterAdded:Wait()
			local Position = Character:GetPivot().Position
			local CollectionService = game:GetService("CollectionService")
			local Chests = CollectionService:GetTagged("_ChestTagged")
			local Distance, Nearest = math.huge
			for i = 1, #Chests do
				local Chest = Chests[i]
				local Magnitude = (Chest:GetPivot().Position - Position).Magnitude
				if (not Chest:GetAttribute("IsDisabled") and (Magnitude < Distance)) then
					Distance, Nearest = Magnitude, Chest
				end
			end
			if Nearest then
				local ChestPosition = Nearest:GetPivot().Position
				local CFrameTarget = CFrame.new(ChestPosition)
				topos(CFrameTarget)
			end
		end
	end
end)
   
      AutoFarm:Seperator("Auto Collect Berry")       
       
    AutoFarm:Toggle("Auto Farm Berries", false,function(value)
         _G.CollectBerry = value 
         StopTween(_G.CollectBerry)
        end)               

spawn(function()
    while wait() do
        if _G.CollectBerry then
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local Position = Character:GetPivot().Position
            local CollectionService = game:GetService("CollectionService")
            local BerryBushes = CollectionService:GetTagged("BerryBush")
            local Distance, NearestBush, NearestBerryName = math.huge, nil, nil

            for _, Bush in ipairs(BerryBushes) do
                for AttributeName, _ in pairs(Bush:GetAttributes()) do
                    local Magnitude = (Bush.Parent:GetPivot().Position - Position).Magnitude
                    if Magnitude < Distance then
                        Distance = Magnitude
                        NearestBush = Bush
                        NearestBerryName = AttributeName
                    end
                end
            end

            if NearestBush and NearestBerryName then
                local BushModel = NearestBush.Parent
                local BushCenter = BushModel:GetPivot().Position

                -- Bay vào trong bụi cây
                TP1(CFrame.new(BushCenter + Vector3.new(0, 2, 0)))
                task.wait(0.5)

                -- Tìm object thật sự là trái berry (theo tên attribute)
                local BerryPart = BushModel:FindFirstChild(NearestBerryName)
                if BerryPart and BerryPart:IsA("BasePart") then
                    -- Bay đến đúng vị trí trái berry
                    TP1(BerryPart.CFrame + Vector3.new(0, 1, 0)) -- bay hơi trên trái berry một tí
                    task.wait(0.3)

                    -- Nhấn E để nhặt berry
                    local VirtualInput = game:GetService("VirtualInputManager")
                    VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    task.wait(0.1)
                    VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
            else
                if _G.CollectBerryHop then
                    Hop()
                end
            end
        end
    end
end)


   if World3 then
       AutoFarm:Seperator("Bone Farm")
                
    Boneyou = AutoFarm:Label("Check Bone")
                
    spawn(function()
        while wait() do
            pcall(function()
                Boneyou:Set("Your Bone : "..(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones","Check")))
            end)
        end
    end)
     
     AutoFarm:Toggle("Auto Farm Bone", false,function(value)
         game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
     		_G.FarmBone = value 
         StopTween(_G.FarmBone)
    end)
    
    spawn(function()
        while wait() do 
            local boneframe = CFrame.new(-9508.5673828125, 142.1398468017578, 5737.3603515625)
            if _G.FarmBone and World3 then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - boneframe.Position).Magnitude > 2000 then
                            TP1(boneframe)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(boneframe)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - boneframe.Position).Magnitude < 2000 then
                            TP1(boneframe)
                        end
                    else
                        TP1(boneframe)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Reborn Skeleton") or game:GetService("Workspace").Enemies:FindFirstChild("Living Zombie") or game:GetService("Workspace").Enemies:FindFirstChild("Demonic Soul") or game:GetService("Workspace").Enemies:FindFirstChild("Posessed Mummy") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Reborn Skeleton" or v.Name == "Living Zombie" or v.Name == "Demonic Soul" or v.Name == "Posessed Mummy" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NoAttackAnimation = true
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.FarmBone or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-9506.234375, 172.130615234375, 6117.0771484375))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Reborn Skeleton" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Living Zombie" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Demonic Soul" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Posessed Mummy" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)     
    
        AutoFarm:Toggle("Seperator Hallow Scythe", false,function(value)         
     	_G.Hallow = value 
         StopTween(_G.Hallow)
       end)
       
       spawn(function()
    while wait() do
        if _G.Hallow then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if string.find(v.Name , "Soul Reaper") then
                            repeat task.wait()
                                EquipWeapon(_G.SelectWeapon)
                                AutoHaki()
                                v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670))
                                v.HumanoidRootPart.Transparency = 1
                            until v.Humanoid.Health <= 0 or _G.Hallow == false
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hallow Essence") then
                    repeat TP1(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)) wait() until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 8                        
                    EquipWeapon("Hallow Essence")
                else
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper") then
                        TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                   
                       end
                    end
                end)
             end
         end
     end)
      
      AutoFarm:Toggle("Auto Trade Bone", false,function(value)         
     		_G.Rdbone = value 
       end)
       
       spawn(function()
            while wait(.1) do
                if _G.Rdbone then    
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones","Buy",1,1)
                end
            end
         end)  
         
         AutoFarm:Toggle("Auto Pray", false,function(value)         
     		_G.Pray = value 
       end)
       
       spawn(function()
        pcall(function()
            while wait(.1) do
                if _G.Pray then    
                    TP1(CFrame.new(-8652.99707, 143.450119, 6170.50879, -0.983064115, -2.48005533e-10, 0.18326205, -1.78910387e-09, 1, -8.24392288e-09, -0.18326205, -8.43218029e-09, -0.983064115))
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",1)
                end
            end
        end)
    end)		
    
        AutoFarm:Toggle("Auto Try Luck", false,function(value)         
     		_G.Trylux = value 
       end)
           
       spawn(function()
        pcall(function()
            while wait(.1) do
                if _G.Trylux then    
                    TP1(CFrame.new(-8652.99707, 143.450119, 6170.50879, -0.983064115, -2.48005533e-10, 0.18326205, -1.78910387e-09, 1, -8.24392288e-09, -0.18326205, -8.43218029e-09, -0.983064115))
                    wait()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("gravestoneEvent",2)
                end
            end
        end)
    end)      
    
       AutoFarm:Seperator("Tyrant of the Skies Farm")
              
       AutoFarm:Toggle("Auto Farm Tyrant of the Skies", false,function(value)         
     	_G.FarmDaiBan = value 
     	StopTween(_G.FarmDaiBan)
       end)
           local TyrantoftheSkies = CFrame.new(-16194.0048828125, 155.21844482421875, 1420.719970703125)
    local Plsmon = game:GetService("Workspace").Enemies
     task.spawn(function()
    while task.wait() do
        if _G.FarmDaiBan then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Tyrant of the Skies") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Tyrant of the Skies" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 40, 0))
                                    NeedAttacking = true
                                until not _G.FarmDaiBan or not v.Parent or v.Humanoid.Health <= 0
                                wait(1)
                            end
                        end
                    end
                else
                    local foundMob = false
                    for _, mobName in pairs({"Isle Outlaw", "Island Boy", "Isle Champion", "Serpent Hunter", "Skull Slayer"}) do
                        if game:GetService("Workspace").Enemies:FindFirstChild(mobName) then
                            foundMob = true
                            break
                        end
                    end
                    if foundMob then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Isle Outlaw" or v.Name == "Island Boy" or v.Name == "Isle Champion" or v.Name == "Serpent Hunter" or v.Name == "Skull Slayer" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        StartBring = true
                                        v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        PosMon = v.HumanoidRootPart.CFrame
                                        MonFarm = v.Name
                                        v.Head.CanCollide = false
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        NeedAttacking = true
                                        if v.Name == "Isle Outlaw" then
                                            Bring(v.Name, CFrame.new(-16442.814453125, 116.13899993896484, -264.4637756347656))
                                        elseif v.Name == "Island Boy" then
                                            Bring(v.Name, CFrame.new(-16901.26171875, 84.06756591796875, -192.88906860351562))
                                        elseif v.Name == "Isle Champion" then
                                            Bring(v.Name, CFrame.new(-16641.6796875, 235.7825469970703, 1031.282958984375))
                                        elseif v.Name == "Serpent Hunter" then
                                            Bring(v.Name, CFrame.new(-16521.0625, 106.09285, 1488.78467, 0.469467044, 0, 0.882950008, 0, 1, 0, -0.882950008, 0, 0.469467044))
                                            elseif v.Name == "Skull Slayer" then
                                            Bring(v.Name, CFrame.new(-16855.043, 122.457253, 1478.15308, -0.999392271, 0, -0.0348687991, 0, 1, 0, 0.0348687991, 0, -0.999392271))
                                        end
                                    until not _G.FarmDaiBan or not v.Parent or v.Humanoid.Health <= 0 or game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 0 or game:GetService("ReplicatedStorage"):FindFirstChild("Tyrant of the Skies [Lv. 2600] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Tyrant of the Skies [Lv. 2600] [Raid Boss]")
                                    DamageAura = false
                                end
                            end
                        end
                    else
                        local RandomTele = math.random(1, 3)
                        if RandomTele == 1 then
                            topos(CFrame.new(-1436.86011, 167.753616, -12296.9512))
                        elseif RandomTele == 2 then
                            topos(CFrame.new(-2383.78979, 150.450592, -12126.4961))
                        elseif RandomTele == 3 then
                            topos(CFrame.new(-2231.2793, 168.256653, -12845.7559))
                        end
                    end
                    if BypassTP then
                        if (playerPos - TyrantoftheSkies.Position).Magnitude > 1500 then
                            BTP(TyrantoftheSkies)
                        else
                            topos(TyrantoftheSkies)
                        end
                    else
                        topos(TyrantoftheSkies)
                    end
                    UnEquipWeapon(_G.Selectweapon)
                    topos(CFrame.new(-16194.0048828125, 155.21844482421875, 1420.719970703125))
                end
            end)
        end
    end
end)
    
        AutoFarm:Seperator("Katakuri Farm")

   CakePrinceStatus = AutoFarm:Label("Check Cake Prince")
    task.spawn(function()
       while task.wait() do
          pcall(function()
           if string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 88 then
           CakePrinceStatus:Set("Killed : "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,41)..' / 500')
          elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 87 then
          CakePrinceStatus:Set("Killed : "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,40)..' / 500')
           elseif string.len(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")) == 86 then
        CakePrinceStatus:Set("Killed : "..string.sub(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),39,39)..' / 500')
        else
      CakePrinceStatus:Set("Prince King Spawned ✅")
      end
    end)
  end
  end)
 
       AutoFarm:Toggle("Auto Farm Cake Prince", false,function(value)         
     	_G.FarmCake = value 
     	StopTween(_G.FarmCake)
       end)
       
   local CakePos = CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375)
    local Plsmon = game:GetService("Workspace").Enemies
     task.spawn(function()
    while task.wait() do
        if _G.FarmCake then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Cake Prince" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                    if game:GetService("Workspace")["_WorldOrigin"]:FindFirstChild("Ring") or game:GetService("Workspace")["_WorldOrigin"]:FindFirstChild("Fist") or game:GetService("Workspace")["_WorldOrigin"]:FindFirstChild("MochiSwirl") then
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
                                    else
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(4, 10, 10))
                                    end
                                    NeedAttacking = true
                                until not _G.FarmCake or not v.Parent or v.Humanoid.Health <= 0
                                wait(1)
                            end
                        end
                    end
                else
                    local foundMob = false
                    for _, mobName in pairs({"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}) do
                        if game:GetService("Workspace").Enemies:FindFirstChild(mobName) then
                            foundMob = true
                            break
                        end
                    end
                    if foundMob then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cookie Crafter" or v.Name == "Cake Guard" or v.Name == "Baking Staff" or v.Name == "Head Baker" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        StartBring = true
                                        v.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                                        PosMon = v.HumanoidRootPart.CFrame
                                        MonFarm = v.Name
                                        v.Head.CanCollide = false
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        NeedAttacking = true
                                        if v.Name == "Cookie Crafter" then
                                            Bring(v.Name, CFrame.new(-2212.88965, 37.0051041, -11969.2568, 0.458114207, -0, -0.888893366, 0, 1, -0, 0.888893366, 0, 0.458114207))
                                        elseif v.Name == "Cake Guard" then
                                            Bring(v.Name, CFrame.new(-1693.98047, 35.2188225, -12436.8438, -0.716115236, 0, -0.697982132, 0, 1, 0, 0.697982132, 0, -0.716115236))
                                        elseif v.Name == "Baking Staff" then
                                            Bring(v.Name, CFrame.new(-1980.4375, 34.6653099, -12983.8408, -0.254338264, 0, -0.967115223, 0, 1, 0, 0.967115223, 0, -0.254338264))
                                        elseif v.Name == "Head Baker" then
                                            Bring(v.Name, CFrame.new(-2151.37793, 51.0095749, -13033.3975, -0.996587753, 0, 0.0825396702, 0, 1, 0, -0.0825396702, 0, -0.996587753))
                                        end
                                    until not _G.FarmCake or not v.Parent or v.Humanoid.Health <= 0 or game:GetService("Workspace").Map.CakeLoaf.BigMirror.Other.Transparency == 0 or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]") or game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince [Lv. 2300] [Raid Boss]")
                                    DamageAura = false
                                end
                            end
                        end
                    else
                        local RandomTele = math.random(1, 3)
                        if RandomTele == 1 then
                            topos(CFrame.new(-1436.86011, 167.753616, -12296.9512))
                        elseif RandomTele == 2 then
                            topos(CFrame.new(-2383.78979, 150.450592, -12126.4961))
                        elseif RandomTele == 3 then
                            topos(CFrame.new(-2231.2793, 168.256653, -12845.7559))
                        end
                    end
                    if BypassTP then
                        if (playerPos - CakePos.Position).Magnitude > 1500 then
                            BTP(CakePos)
                        else
                            topos(CakePos)
                        end
                    else
                        topos(CakePos)
                    end
                    UnEquipWeapon(_G.Selectweapon)
                    topos(CFrame.new(-2130.80712890625, 69.95634460449219, -12327.83984375))
                end
            end)
        end
    end
end)

       AutoFarm:Toggle("Auto Katakuri V2", false,function(value)         
     	_G.Fullykatakuri = value 
    	StopTween(_G.Fullykatakuri)
       end)
       
   spawn(function()
		while wait() do
			if _G.Fullykatakuri then
				pcall(function()
					if game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice") then
						if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc"),"Where") then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SweetChaliceNpc")
						end
					elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Sweet Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("Sweet Chalice") then
						if string.find(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner"),"Do you want to open the portal now?") then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
						else
							if game.Workspace.Enemies:FindFirstChild("Baking Staff") or game.Workspace.Enemies:FindFirstChild("Head Baker") or game.Workspace.Enemies:FindFirstChild("Cake Guard") or game.Workspace.Enemies:FindFirstChild("Cookie Crafter")  then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do  
									if (v.Name == "Baking Staff" or v.Name == "Head Baker" or v.Name == "Cake Guard" or v.Name == "Cookie Crafter") and v.Humanoid.Health > 0 then
										repeat wait()
											AutoHaki()
											EquipWeapon(_G.SelectWeapon)
											AutoHaki()                             
											PosMon = v.HumanoidRootPart.CFrame
											topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
											v.HumanoidRootPart.CanCollide = false
											v.Humanoid.WalkSpeed = 0
											v.Head.CanCollide = false
											attackGunEnemies(v.Name , 5)
											v.HumanoidRootPart.Size = Vector3.new(70,70,70)
											StartBring = false
											MonFarm = v.Name          
											game:GetService'VirtualUser':CaptureController()
											game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
										until _G.Fullykatakuri == false or game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") or not v.Parent or v.Humanoid.Health <= 0
									end
								end
							else
								CakeBring = false
								StartBring = false
								topos(CFrame.new(-1820.0634765625, 210.74781799316406, -12297.49609375))
							end
						end						
					elseif game.ReplicatedStorage:FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
						if game:GetService("Workspace").Enemies:FindFirstChild("Dough King") then
							for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do 
								if v.Name == "Dough King" then
									repeat wait()
										AutoHaki()
										EquipWeapon(_G.SelectWeapon)
										v.HumanoidRootPart.Size = Vector3.new(70,70,70)
										v.HumanoidRootPart.CanCollide = false
										StartBring = false
										topos(v.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
							    		game:GetService'VirtualUser':CaptureController()
										game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
									until _G.Fullykatakuri == false or not v.Parent or v.Humanoid.Health <= 0
								end    
							end    
						else
							topos(CFrame.new(-2009.2802734375, 4532.97216796875, -14937.3076171875)) 
						end
					elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Red Key") or game.Players.LocalPlayer.Character:FindFirstChild("Red Key") then
						local args = {
							[1] = "CakeScientist",
							[2] = "Check"
						}

						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
					else
						if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
							if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Diablo") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Urban") then
								if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
									for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
										if v.Name == "Diablo" or v.Name == "Deandre" or v.Name == "Urban" then
											if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
												repeat wait()
					    					AutoHaki()
                                           EquipWeapon(_G.SelectWeapon)        
											PosMon = v.HumanoidRootPart.CFrame
											topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
											v.HumanoidRootPart.CanCollide = false
											v.Humanoid.WalkSpeed = 0
											v.Head.CanCollide = false
											attackGunEnemies(v.Name , 5)
											v.HumanoidRootPart.Size = Vector3.new(70,70,70)
											StartBring = false
											MonFarm = v.Name          
											game:GetService'VirtualUser':CaptureController()
											game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
									    	sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
												until _G.Fullykatakuri == false or v.Humanoid.Health <= 0 or not v.Parent or game.Players.LocalPlayer.Backpack:FindFirstChild("God's Chalice") or game.Players.LocalPlayer.Character:FindFirstChild("God's Chalice")
											end
										end
									end
								else
									if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
										topos(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
									end
								end                    
							end
						else
							wait(0.5)
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
						end
					end
				end)
			end
		end
	end)
	
	AutoFarm:Toggle("Auto Start Chocola", false,function(value)         
     	_G.FarmChocola = value 
    	StopTween(_G.FarmChocola)
       end)
       
       spawn(function()
        while wait() do 
            local Choccola = CFrame.new(87.94276428222656, 73.55451202392578, -12319.46484375)
            if _G.FarmChocola then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Choccola)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Choccola)
                        end
                    else
                        TP1(Choccola)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Chocolate Bar Battler") or game:GetService("Workspace").Enemies:FindFirstChild("Cocoa Warrior") or game:GetService("Workspace").Enemies:FindFirstChild("Sweet Thief") or game:GetService("Workspace").Enemies:FindFirstChild("Candy Rebel") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Chocolate Bar Battler" or v.Name == "Cocoa Warrior" or v.Name == "Sweet Thief" or v.Name == "Candy Rebel" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.FarmChocola or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Chocolate Bar Battler" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Cocoa Warrior" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Sweet Thief" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Candy Rebel" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)     
	
 end	

     if World1 then
       _G.SelectBoss = "The Gorilla King"
       AutoFarm:Dropdown("Auto Select Boss",{"The Saw", "The Gorilla King", "Bobby", "Yeti", "Mob Leader", "Vice Admiral", "Warden", "Chief Warden", "Swan", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God", "Cyborg", "Saber Expert"},{"The Gorilla King"},function(Value)
        _G.SelectBoss = Value
       end)
   	  elseif World2 then      
       _G.SelectBoss = "Diamond"
       AutoFarm:Dropdown("Auto Select Boss",{"Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral", "Cursed Captain", "Darkbeard", "Order", "Awakened Ice Admiral", "Tide Keeper"},{"Diamond"},function(Value)
       _G.SelectBoss = Value
      end)      
     elseif World3 then      
       _G.SelectBoss = "Stone"
       AutoFarm:Dropdown("Auto Select Boss",{"Stone", "Island Empress", "Rocket Admiral", "Captain Elephant", "Beautiful Pirate", "rip_indra True Form", "Longma", "Soul Reaper", "Cake Queen", "Cake Prince", "Dough King"
},{"Stone"},function(Value)
        _G.SelectBoss = Value
       end)      
    end     
    
       AutoFarm:Seperator("Auto Boss Farm")
      
    BossSpawn = AutoFarm:Label("Auto Check Boss")
       
       spawn(function()
    while wait() do
        pcall(function()
            if game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) or game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
                BossSpawn:Set("Status :Boss Spawn ✅")
            else
                BossSpawn:Set("Status :Boss Not Spawn ❌")
               end
            end)
          end
       end)
 
    AutoFarm:Toggle("Auto Farm Boss", false,function(value)         
      	_G.AutoBoss = value 
       	StopTween(_G.AutoBoss)
       end)
       
       spawn(function()
        while wait() do
            if _G.AutoBoss then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectBoss) then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == _G.SelectBoss then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoBoss or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss) then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectBoss).HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                        end
                    end
                end)
            end
        end
    end)     
    
      AutoFarm:Seperator("Auto Farm Material")
      
      if World1 then
      AutoFarm:Dropdown("Select Material",{"Farm Leather + Scrap Metal","Farm Fish Tail","Farm Magma Ore","Farm Angel Wings"},{"Farm Fish Tail"},function(Value)
        _G.SelectMaterial = Value
      end)
      
         spawn(function()
        while wait() do 
            local Leather = CFrame.new(-967.433105, 13.5999937, 4034.24707, -0.258864403, 0, -0.965913713, 0, 1, 0, 0.965913713, 0, -0.258864403)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Leather + Scrap Metal' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Leather)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Leather)
                        end
                    else
                        TP1(Leather)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Pirate") or game:GetService("Workspace").Enemies:FindFirstChild("Brute") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Pirate" or v.Name == "Brute"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Leather + Scrap Metal'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-1141.07483, 4.10001802, 3831.5498, 0.965929627, -0, -0.258804798, 0, 1, -0, 0.258804798, 0, 0.965929627))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Pirate" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Brute" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)     
    
   spawn(function()
        while wait() do 
            local Fish = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Fish Tail' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Fish)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Fish)
                        end
                    else
                        TP1(Fish)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Fishman Commando") or game:GetService("Workspace").Enemies:FindFirstChild("Fishman Warrior") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Fishman Commando" or v.Name == "Fishman Warrior"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Fish Tail'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Fishman Commando" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Fishman Warrior" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)    

   spawn(function()
        while wait() do 
            local Magma = CFrame.new(-5313.37012, 10.9500084, 8515.29395, -0.499959469, 0, 0.866048813, 0, 1, 0, -0.866048813, 0, -0.499959469)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Magma Ore' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Magma)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Magma)
                        end
                    else
                        TP1(Magma)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Military Soldie") or game:GetService("Workspace").Enemies:FindFirstChild("Military Spy") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Military Soldie" or v.Name == "Military Spy"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Magma Ore'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-5411.16455078125, 11.081554412841797, 8454.29296875))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Military Soldier" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Military Spy" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)      
   
   spawn(function()
        while wait() do 
            local Angel = CFrame.new(-7906.81592, 5634.6626, -1411.99194, 0, 0, -1, 0, 1, 0, 1, 0, 0)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Angel Wings' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Angel)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Angel)
                        end
                    else
                        TP1(Angel)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Royal Soldier") or game:GetService("Workspace").Enemies:FindFirstChild("Royal Squad") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Royal Soldier" or v.Name == "Royal Squad"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Angel Wings'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-7836.75341796875, 5645.6640625, -1790.6236572265625))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Royal Soldier" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Royal Squad" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)      

end

     if World2 then
      AutoFarm:Dropdown("Select Material",{"Farm Leather + Scrap Metal","Farm Radiactive Material","Farm Magma Ore","Farm Vampire Fang","Farm Mystic Droplet","Farm Ectoplasm",},{"Farm Leather + Scrap Metal"},function(Value)
        _G.SelectMaterial = Value
      end)
      
    spawn(function()
        while wait() do 
            local Leather = CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Leather + Scrap Metal' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Leather)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Leather)
                        end
                    else
                        TP1(Leather)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Mercenary") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Mercenary" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Leather + Scrap Metal'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-1004.3244018554688, 80.15886688232422, 1424.619384765625))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Mercenary" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)      

    spawn(function()
        while wait() do 
            local Radiactive = CFrame.new(-105.889565, 72.8076935, -670.247986, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Radiactive Material' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Radiactive)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Radiactive)
                        end
                    else
                        TP1(Radiactive)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Factory Staff") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Factory Staff" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Radiactive Material'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-105.889565, 72.8076935, -670.247986, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Factory Staff" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)      

    spawn(function()
        while wait() do 
            local Magma = CFrame.new(-5213.33154296875, 49.73788070678711, -4701.451171875)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Magma Ore' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Magma)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Magma)
                        end
                    else
                        TP1(Magma)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Lava Pirate") or game:GetService("Workspace").Enemies:FindFirstChild("Magma Ninja") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Lava Pirate" or v.Name == "Magma Ninja"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Magma Ore'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-5449.6728515625, 76.65874481201172, -5808.20068359375))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Lava Pirate" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Magma Ninja" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)   

    spawn(function()
        while wait() do 
            local VampireFang = CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Vampire Fang' then
            pcall(function()
               if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(VampireFang)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(VampireFang)
                        end
                    else
                        TP1(VampireFang)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Vampire") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Vampire" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Vampire Fang'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-6037.66796875, 32.18463897705078, -1340.6597900390625))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Vampire" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)         

    spawn(function()
        while wait() do 
            local MysticDroplet = CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Mystic Droplet' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(MysticDroplet)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(MysticDroplet)
                        end
                    else
                        TP1(MysticDroplet)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Water Fighter") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Water Fighter" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Mystic Droplet'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-3352.9013671875, 285.01556396484375, -10534.841796875))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Water Fighter" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)      
    
   spawn(function()
        while wait() do 
            local Ectoplasm = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)    
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Ectoplasm' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Ectoplasm.Position).Magnitude > 2000 then
                            BTP(Ectoplasm)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Ectoplasm)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Ectoplasm.Position).Magnitude < 2000 then
                            TP1(Ectoplasm)
                        end
                    else
                        TP1(Ectoplasm)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Ship Deckhand") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Engineer") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Steward") or game:GetService("Workspace").Enemies:FindFirstChild("Ship Officer") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Ship Deckhand" or v.Name == "Ship Engineer" or v.Name == "Ship Steward" or v.Name == "Ship Officer" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Ectoplasm'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Ship Deckhand" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Ship Engineer" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Ship Steward" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Ship Officer" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)     
    
end   

      if World3 then
      AutoFarm:Dropdown("Select Material",{"Farm Leather + Scrap Metal","Farm Fish Tail","Farm Mini Tusk","Farm Dragon Scale","Farm Conjured Cocoa"},{"Farm Fish Tail"},function(Value)
        _G.SelectMaterial = Value
      end)
      
      spawn(function()
        while wait() do 
            local Leather = CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Leather + Scrap Metal' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Leather)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Leather)
                        end
                    else
                        TP1(Leather)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Pirate Millionaire") or game:GetService("Workspace").Enemies:FindFirstChild("Pistol Billionaire") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Pirate Millionaire" or v.Name == "Pistol Billionaire"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Leather + Scrap Metal'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-245.9963836669922, 47.30615234375, 5584.1005859375))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Pirate Millionaire" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Pistol Billionaire" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)     
    
   spawn(function()
        while wait() do 
            local Fish = CFrame.new(-10994.701171875, 352.38140869140625, -9002.1103515625) 
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Fish Tail' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Fish)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Fish)
                        end
                    else
                        TP1(Fish)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Fishman Raider") or game:GetService("Workspace").Enemies:FindFirstChild("Fishman Captain") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Fishman Raider" or v.Name == "Fishman Captain"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Fish Tail'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-10407.5263671875, 331.76263427734375, -8368.5166015625))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Fishman Raider" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Fishman Captain" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)    

   spawn(function()
        while wait() do 
            local Mini = CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Mini Tusk' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Mini)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Mini)
                        end
                    else
                        TP1(Mini)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Mythological Pirate") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Mythological Pirate" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Mini Tusk'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(-13680.607421875, 501.08154296875, -6991.189453125))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Mythological Pirate" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)    
   
   spawn(function()
        while wait() do 
            local Dragon = CFrame.new(6668.76172, 481.376923, 329.12207, -0.121787429, 0, -0.992556155, 0, 1, 0, 0.992556155, 0, -0.121787429)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Dragon Scale' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Dragon)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Dragon)
                        end
                    else
                        TP1(Dragon)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Dragon Crew Archer") or game:GetService("Workspace").Enemies:FindFirstChild("Dragon Crew Warrior") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Dragon Crew Archer" or v.Name == "Dragon Crew Warrior"  then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Dragon Scale'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(6668.76172, 481.376923, 329.12207, -0.121787429, 0, -0.992556155, 0, 1, 0, 0.992556155, 0, -0.121787429))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Dragon Crew Archer" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Dragon Crew Warrior" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)    
    
    spawn(function()
        while wait() do 
            local Choccola = CFrame.new(87.94276428222656, 73.55451202392578, -12319.46484375)
            if _G.AutoFarmMaterial and _G.SelectMaterial == 'Farm Conjured Cocoa' then
            pcall(function()
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude > 2000 then
                            BTP(Choccola)
                            wait(.1)
                            for i = 1, 8 do
                                game.Players.localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Choccola)
			                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")	
                                wait(.1)		
                            end
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Choccola.Position).Magnitude < 2000 then
                            TP1(Choccola)
                        end
                    else
                        TP1(Choccola)
                    end
                    if game:GetService("Workspace").Enemies:FindFirstChild("Chocolate Bar Battler") or game:GetService("Workspace").Enemies:FindFirstChild("Cocoa Warrior") or game:GetService("Workspace").Enemies:FindFirstChild("Sweet Thief") or game:GetService("Workspace").Enemies:FindFirstChild("Candy Rebel") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Chocolate Bar Battler" or v.Name == "Cocoa Warrior" or v.Name == "Sweet Thief" or v.Name == "Candy Rebel" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        NeedAttacking = true
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        StartBring = true
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoFarmMaterial or not v.Parent or v.Humanoid.Health <= 0 or not _G.SelectMaterial == 'Farm Conjured Cocoa'
                                end
                            end
                        end
                    else
                        StartBring = false
    					topos(CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375))
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                            if v.Name == "Chocolate Bar Battler" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Cocoa Warrior" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Sweet Thief" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            elseif v.Name == "Candy Rebel" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                            end
                        end
                    end
                end)
            end
        end
    end)     
	
 end	

      AutoFarm:Toggle("Auto Farm Nguyên Liệu", false,function(Value)
       _G.AutoFarmMaterial = Value 
       StopTween(_G.AutoFarmMaterial)
     end)
 
 ---------------------------- Auto Settings 
 
      KillPercent = "30"
       Settings:Dropdown("Select Healt Mob Farm",{"20","25","30","35","40","45","50","55","60","65","70","75", "80"},{"25"},function(Value)
        KillPercent = Value
      end)
      
     Settings:Toggle("Auto Use Skill Z",true,function(Z)
       SkillZ = Z
     end)
     
     Settings:Toggle("Auto Use Skill X",false,function(X)
       SkillX = X
     end)          
       
     Settings:Toggle("Auto Use Skill C",false,function(C)
       SkillC = C
     end)      
     
     Settings:Toggle("Auto Use Skill V",false,function(V)
       SkillV = V
     end)      
     
     Settings:Toggle("Auto Use Skill F",false,function(F)
       SkillC = F
     end)  
     
     Settings:Seperator("Settings Farm")         
     
      
    Settings:Toggle("Auto Bring Mob", true,function(value)
      _G.BringMonster = value
      _G.BringMob = value 
       end)     
       
       spawn(function()
    while task.wait() do
        pcall(function()
            CheckQuest()
            if _G.BringMonster and StartBring and PosMon then
                for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    local isValid = (v.Name == MonFarm or v.Name == Mon)
                    local hasPart = v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Head")
                    local isAlive = v.Humanoid and v.Humanoid.Health > 0
                    local inRange = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 350

                    if isValid and hasPart and isAlive and inRange then
                        local distToPosMon = (v.HumanoidRootPart.Position - PosMon.Position).Magnitude
                        if distToPosMon <= 350 then
                            -- Gôm quái
                            v.HumanoidRootPart.CanCollide = false
                            v.Head.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v.HumanoidRootPart.CFrame = PosMon

                            -- Xoá Animator nếu có
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                        end
                    end
                end

                -- Set SimulationRadius một lần
                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
            end
        end)
    end
end)


spawn(function()
    while wait() do
        pcall(function()
            for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                if _G.BringMob and bringmob then
                    if v.Name == MonFarm and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if v.Name == "Factory Staff" then
                            if (v.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 1000000000 then
                                v.Head.CanCollide = false
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.CFrame = FarmPos
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                            end
                        elseif v.Name == MonFarm then
                            if (v.HumanoidRootPart.Position - FarmPos.Position).Magnitude <= 10000000000 then
                                v.HumanoidRootPart.CFrame = FarmPos
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 1
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                v.HumanoidRootPart.CanCollide = false
                                v.Head.CanCollide = false
                                v.Humanoid:ChangeState(11)
                                v.Humanoid:ChangeState(14)
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

if not syn then isnetworkowner = function() return true end end
getgenv().BringMobs = function(F, z)
    PosMon = F
    NameMon = z
end

task.spawn(function()
    while task.wait() do
        pcall(function()
            if PosMon then
                CheckQuest() 
                for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if syn then
                        if v.Name == NameMon and v.Name ~= "Ice Admiral" and v.Name ~= "Don Swan" and v.Name ~= "Saber Expert" and v.Name ~= "Longma" and  v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                            if isnetworkowner(v.HumanoidRootPart) then
                                v.HumanoidRootPart.CFrame = PosMon
                                v.Humanoid.JumpPower = 0
                                v.Humanoid.WalkSpeed = 0
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(2,2,2)
                                if v.Humanoid:FindFirstChild("Animator") then
                                    v.Humanoid.Animator:Destroy()
                                end
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius",  math.huge)
                                v.Humanoid:ChangeState(11)
                            end
                        end
                    else
                        if v.Name == NameMon and v.Name ~= "Ice Admiral" and v.Name ~= "Don Swan" and v.Name ~= "Saber Expert" and v.Name ~= "Longma" and  v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 300 then
                            v.HumanoidRootPart.CFrame = PosMon
                            v.Humanoid.JumpPower = 0
                            v.Humanoid.WalkSpeed = 0
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(2,2,2)
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius",  math.huge)
                            v.Humanoid:ChangeState(11)
                        end
                    end
                end
            end
        end)
    end
end)
PosY = 35            

  Settings:Toggle("Auto Walk Water", true,function(value)      
      _G.WalkWater = value
 end)

    spawn(function()
			while task.wait() do
				pcall(function()
					if _G.WalkWater then
						game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000,112,1000)
					else
						game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000,80,1000)
					end
				end)
			end
        end)
        
      Settings:Toggle("Auto Set Home Point", false,function(value)      
      _G.CheckPoint = Value
     end)
    spawn(function()
    	while wait() do
	   	if _G.CheckPoint then
			game:GetService("SetSpawnPoint")
		end
    end
  end)
  
  Settings:Toggle("Auto Haki Buso", true,function(value)
      _G.AutoHaki = value
     end)
     spawn(function()
    while task.wait(0.1) do
        if _G.AutoHaki then
            pcall(AutoHaki)
        end
    end
end)

     Settings:Toggle("Auto Active Race V3", false,function(value)    
      _G.AutoRaceV3 = value
    end)
  spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoRaceV3 then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility");
             end
          end);
       end
   end)
   
   Settings:Toggle("Auto Active Race V4", false,function(value)    
      _G.AutoRaceV4 = value
    end)
    spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoRaceV4 then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game);
                wait();
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game);
            end
        end);
    end
end)
 
  Settings:Toggle("Infinite Soru", false,function(Soru)       
      InfiniteSoru = Soru
     end)
     
    spawn(function()
    while task.wait(1) do
        if InfiniteSoru and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil  then
            pcall(function()
                for i,v in next, getgc() do
                    if getfenv(v).script == game.Players.LocalPlayer.Character:WaitForChild("Soru") then
                        for i2,v2 in pairs(debug.getupvalues(v)) do
                            if type(v2) == 'table' then
                                if v2.LastUse then
                                    repeat task.wait(.1)
                                        setupvalue(v, i2, {LastAfter = 0,LastUse = 0})
                                    until not InfiniteSoru or game:GetService("Players").LocalPlayer.Character.Humanoid.Health <= 0
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

    Settings:Toggle("Spin Position", false,function(value)       
      _G.SpinPos = Value 
     end)
     
PosY = 35
  Settings:Dropdown("Farm Distnace",{"20","25","30","35","40","45","50","55","60","65","70","75","80"},{"50"},function(Value)
        PosY = value
      end)
  
  Settings:Toggle("Dodge No CD", false,function(value)       
      DodgewithoutCool = Value 
     end)
     function NoCooldown()
    for i,v in next, getgc() do
        if typeof(v) == "function" then
            if getfenv(v).script == game.Players.LocalPlayer.Character:WaitForChild("Dodge") then
                for i2,v2 in next, getupvalues(v) do
                    if tostring(v2) == "0.4" then
                        setupvalue(v,i2,0)
                      end
                   end
               end
           end
       end
   end
    spawn(function()
       while wait() do
           if DodgewithoutCool then
             pcall(function()
                 NoCooldown()
               end)
            end
       end
    end)
  
     Settings:Toggle("Infinite Geppo", false,function(Geppo)       
         InfiniteGeppo = Geppo
        end)
        spawn(function()
    while task.wait(1) do
        if InfiniteGeppo then
            pcall(function()
                for i,v in next, getgc() do
                    if getfenv(v).script == game.Players.LocalPlayer.Character:WaitForChild("Geppo") then
                        for i2,v2 in next, getupvalues(v) do
                            if tostring(v2) == "0" then
                                repeat wait(.1)
                                    setupvalue(v,i2,0)
                                until not InfiniteGeppo or game:GetService("Players").LocalPlayer.Character.Humanoid.Health <= 0
                            end
                        end
                    end
                end
            end)
        end
    end
end)
  
    Settings:Toggle("Infinite Jump", false,function(Cokka)       
     Infinite = Cokka
 	 game:GetService("UserInputService").JumpRequest:connect(function()
     if Infinite then
     game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
     end
    end) 
  end)
    
     
     if World1 or World2  then
        Items:Seperator("Auto Quest Sea")
        end
       
      if World1 then
      Items:Toggle("Auto Second Sea", false,function(Second)   
      _G.AutoSecondSea = Second  
     end)
     
      spawn(function()
         while wait() do
          if _G.AutoSecondSea then
               pcall(function()
              if game.Players.LocalPlayer.Data.Level.Value >= 700 and World1 then
              _G.AutoFarm = false
            if game.Workspace.Map.Ice.Door.CanCollide == true and game.Workspace.Map.Ice.Door.Transparency == 0 then
          repeat wait() topos(CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563)) until (CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoSecondSea
            wait(1)
             game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DressrosaQuestProgress","Detective")
            EquipWeapon("Key")
          local pos2 = CFrame.new(1347.7124, 37.3751602, -1325.6488)
        repeat wait() topos(pos2) until (pos2.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.AutoSecondSea
        wait(3)
         elseif game.Workspace.Map.Ice.Door.CanCollide == false and game.Workspace.Map.Ice.Door.Transparency == 1 then
           if game:GetService("Workspace").Enemies:FindFirstChild("Ice Admiral") then
        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
         if v.Name == "Ice Admiral" and v.Humanoid.Health > 0 then
         repeat wait()
            AutoHaki()
              EquipWeapon(_G.SelectWeapon)
               v.HumanoidRootPart.CanCollide = false
                StartBring = true
               v.HumanoidRootPart.Size = Vector3.new(60,60,60)
                 v.HumanoidRootPart.Transparency = 1
               topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                game:GetService("VirtualUser"):CaptureController()
                 game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 870),workspace.CurrentCamera.CFrame)
              until v.Humanoid.Health <= 0 or not v.Parent or not _G.AutoSecondSea
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
                  end
                end
              else
           topos(CFrame.new(1347.7124, 37.3751602, -1325.6488))
           end
         else
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
        end
       end
      end)
     end
    end
   end)
 
end
      if World2 then
      Items:Toggle("Auto Quest Bartilo", false,function(Bartilo)      
       _G.AutoBartilo = Bartilo
       StopTween(_G.AutoBartilo)
      end)
      
      spawn(function()
    pcall(function()
        while wait(.1) do
            if _G.AutoBartilo then
                if game:GetService("Players").LocalPlayer.Data.Level.Value >= 800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then
                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then 
                        if game:GetService("Workspace").Enemies:FindFirstChild("Swan Pirate") then
                            Ms = "Swan Pirate"
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == Ms then
                                    pcall(function()
                                        repeat task.wait()
                                            sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                            EquipWeapon(_G.SelectWeapon)
                                            AutoHaki()
                                            v.HumanoidRootPart.Transparency = 1
                                            v.HumanoidRootPart.CanCollide = false
                                            v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                            topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))						
                                            PosMonBarto =  v.HumanoidRootPart.CFrame
                                            game:GetService'VirtualUser':CaptureController()
                                            game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                            StartBring = true
                                        until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoBartilo == false or game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false
                                        StartBring = false
                                    end)
                                end
                            end
                        else
                            repeat topos(CFrame.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119e-08, -0.230443969, 2.67024713e-08, 1, 8.47491108e-08, 0.230443969, 7.63147128e-08, -0.973085582)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(932.624451, 156.106079, 1180.27466, -0.973085582, 4.55137119e-08, -0.230443969, 2.67024713e-08, 1, 8.47491108e-08, 0.230443969, 7.63147128e-08, -0.973085582)).Magnitude <= 10
                        end
                    else
                        repeat topos(CFrame.new(-456.28952, 73.0200958, 299.895966)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10
                        wait(1.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest","BartiloQuest",1)
                    end 
                elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then
                    if game:GetService("Workspace").Enemies:FindFirstChild("Jeremy") then
                        Ms = "Jeremy"
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == Ms then
                                OldCFrameBartlio = v.HumanoidRootPart.CFrame
                                repeat task.wait()
                                    sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    v.HumanoidRootPart.Transparency = 1
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    v.HumanoidRootPart.CFrame = OldCFrameBartlio
                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    game:GetService'VirtualUser':CaptureController()
                                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                    sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoBartilo == false
                            end
                        end
                    elseif game:GetService("ReplicatedStorage"):FindFirstChild("Jeremy") then
                        repeat topos(CFrame.new(-456.28952, 73.0200958, 299.895966)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-456.28952, 73.0200958, 299.895966)).Magnitude <= 10
                        wait(1.1)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo")
                        wait(1)
                        repeat topos(CFrame.new(2099.88159, 448.931, 648.997375)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10
                        wait(2)
                    else
                        repeat topos(CFrame.new(2099.88159, 448.931, 648.997375)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(2099.88159, 448.931, 648.997375)).Magnitude <= 10
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Level.Value >= 800 and game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then
                    repeat topos(CFrame.new(-1850.49329, 13.1789551, 1750.89685)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1850.49329, 13.1789551, 1750.89685)).Magnitude <= 10
                    wait(1)
                    repeat topos(CFrame.new(-1858.87305, 19.3777466, 1712.01807)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1858.87305, 19.3777466, 1712.01807)).Magnitude <= 10
                    wait(1)
                    repeat topos(CFrame.new(-1803.94324, 16.5789185, 1750.89685)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1803.94324, 16.5789185, 1750.89685)).Magnitude <= 10
                    wait(1)
                    repeat topos(CFrame.new(-1858.55835, 16.8604317, 1724.79541)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1858.55835, 16.8604317, 1724.79541)).Magnitude <= 10
                    wait(1)
                    repeat topos(CFrame.new(-1869.54224, 15.987854, 1681.00659)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1869.54224, 15.987854, 1681.00659)).Magnitude <= 10
                    wait(1)
                    repeat topos(CFrame.new(-1800.0979, 16.4978027, 1684.52368)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1800.0979, 16.4978027, 1684.52368)).Magnitude <= 10
                    wait(1)
                    repeat topos(CFrame.new(-1819.26343, 14.795166, 1717.90625)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1819.26343, 14.795166, 1717.90625)).Magnitude <= 10
                    wait(1)
                    repeat topos(CFrame.new(-1813.51843, 14.8604736, 1724.79541)) wait() until not _G.AutoBartilo or (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-1813.51843, 14.8604736, 1724.79541)).Magnitude <= 10
                  end
                end 
             end
          end)
       end)

        Items:Toggle("Auto Third Sea", false,function(ThirdSea)      
          _G.ThirdSea = ThirdSea
          StopTween(_G.ThirdSea)
       end)
     spawn(function()
    while wait() do
        if _G.ThirdSea then
            pcall(function()
                if game:GetService("Players").LocalPlayer.Data.Level.Value >= 1500 and World2 then
                    _G.AutoFarm = false
                    if game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("ZQuestProgress", "General") == 0 then
                        topos(CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016))
                        if (CFrame.new(-1926.3221435547, 12.819851875305, 1738.3092041016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
                            wait(1.5)
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress","Begin")
                        end
                        wait(1.8)
                        if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "rip_indra" then
                                    OldCFrameThird = v.HumanoidRootPart.CFrame
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        v.HumanoidRootPart.CFrame = OldCFrameThird
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until _G.ThirdSea == false or v.Humanoid.Health <= 0 or not v.Parent
                                end
                            end
                        elseif not game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") and (CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1000 then
                            TP1(CFrame.new(-26880.93359375, 22.848554611206, 473.18951416016))
                        end
                    end
                end
            end)
        end
    end
end)                                                      

end               
       if World2 then
       Items:Seperator("Auto Factory")
       
        Items:Toggle("Auto Factory", false,function(Values)      
          _G.AutoFactory = Values
       end)
       
       spawn(function()
            while wait() do
                spawn(function()
                    if _G.AutoFactory then
                        if game:GetService("Workspace").Enemies:FindFirstChild("Core") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == "Core" and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()         
                                        EquipWeapon(_G.SelectWeapon)           
                                        topos(CFrame.new(448.46756, 199.356781, -441.389252))                                  
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                    until v.Humanoid.Health <= 0 or _G.AutoFactory == false
                                end
                            end
                        else
                            topos(CFrame.new(448.46756, 199.356781, -441.389252))
                        end
                    end
                end)
            end
        end)
        
end

        if World3 then
        Items:Seperator("Auto Pirate")
       
       Items:Toggle("Auto Pirate Raid", false,function(Values)      
          _G.AutoRaidPirate = Values
          StopTween(_G.AutoRaidPirate)
       end)
                 
      spawn(function()
	while wait() do
		if _G.AutoRaidPirate then
			pcall(function()
				local CFrameBoss = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
				if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 500 then
					for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
						if _G.AutoRaidPirate and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 2000 then
								repeat wait()
									AutoHaki()
									EquipWeapon(_G.SelectWeapon)
									NeedAttacking = true
									StartMagnet = true
									v.HumanoidRootPart.CanCollide = false
									v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
									topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								until v.Humanoid.Health <= 0 or not v.Parent or _G.AutoRaidPirate == false
								NeedAttacking = false
								StartMagnet = false
							end
						end
					end
				else
					if ((CFrameBoss).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 1500 then
						TP1(CFrameBoss)
					else
						TP1(CFrameBoss)
					end
				end
			end)
		end
	end
    end)

     Items:Seperator("Auto Elite Hunter")
  
    EliteHunterKill = Items:Label("Check Elite Hunter kill")
     
     spawn(function()
    while wait() do
        pcall(function()
            if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
                EliteHunterKill:Set("Number of kills  : "..game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress"))
            else
               EliteHunterKill:Set("Number of kills  : "..game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress"))	
            end
        end)
    end
end)
     
         EliteHunter = Items:Label("Check Elite Hunter")
     
     task.spawn(function()
    while wait() do
        pcall(function()
            if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
               EliteHunter:Set("Elite Hunter Spawning ✅")
            else
                EliteHunter:Set("Not Have Elite Hunter in Severs ❌")
            end
        end)
    end
end)
     
     Items:Toggle("Auto Farm Elite Hunter", false,function(Values)      
          _G.AutoElitehunter = Values
          StopTween(_G.AutoElitehunter)
       end)
     
       spawn(function()
        while wait() do
            if _G.AutoElitehunter and World3 then
                pcall(function()
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
						if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Diablo") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Deandre") or string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,"Urban") then
							if game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban") then
								for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
									if v.Name == "Diablo" or v.Name == "Deandre" or v.Name == "Urban" then
										if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
											repeat wait()
												AutoHaki()
                                                EquipWeapon(_G.SelectWeapon)
                                                NeedAttacking = true
                                                StartBring = true
                                                v.HumanoidRootPart.CanCollide = false
                                                v.Humanoid.WalkSpeed = 0
                                                
                                                topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                                sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                            until _G.AutoElitehunter == false or v.Humanoid.Health <= 0 or not v.Parent
										end
									end
								end
							else
							NeedAttacking = false
								if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
                                    TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
                                    TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                                elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
                                    TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
								end
							end                    
						end
					else					
						if _G.AutoEliteHunterHop and game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("EliteHunter") == "I don't have anything for you right now. Come back later." then
							Hop()
						else
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
						end
					end
				end)
			end
		end
	end) 
     
     
end
    
   Items:Seperator("Auto Boss Raid")
    
    if World1 then
     Items:Toggle("Auto Kill Greybeard", false,function(Values)      
          _G.Greybeard = Values
          StopTween(_G.Greybeard)
       end)
       spawn(function()
        while wait() do
            if  _G.Greybeard  then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Greybeard") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Greybeard" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                        sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                    until not  _G.Greybeard or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    topos(CFrame.new(-5023.38330078125, 28.65203285217285, 4332.3818359375))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                        else
                            if  _G.Greybeardhop then
                                Hop()
                            end
                        end
                    end
                end)
            end
        end
    end)
        
end       

     if World2 then         
       Items:Toggle("Auto Kill Darkbeard", false,function(Values)
          _G.AutoDarkBoss = Values
          StopTween(_G.AutoDarkBoss)
       end)  
       
       spawn(function()
        while wait() do
            if _G.AutoDarkBoss then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Darkbeard") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Darkbeard" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                    NeedAttacking = true
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                                                     
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoDarkBoss or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    NeedAttacking = true
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Darkbeard").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                        end
                    end
                end)
            end
        end
    end)                            
  
       Items:Toggle("Auto kKll Cursed Captaint", false,function(Values)      
          _G.CursedCaptain = Values
          StopTween(_G.CursedCaptain)
       end)
                  
         spawn(function()
        while wait() do
            if _G.CursedCaptain then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Cursed Captain") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Cursed Captain" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                    NeedAttacking = true
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                                                     
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.CursedCaptain or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    NeedAttacking = true
                    local Distance = (Vector3.new(911.35827636719, 125.95812988281, 33159.5390625) - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if Distance > 18000 then
                        elseif game:GetService("ReplicatedStorage"):FindFirstChild("Cursed Captain") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Cursed Captain").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                        end
                     end
                  end)
              end
           end
        end)            

end
      
      if World3 then 
      
     RipIndra = Items:Label("Check Rip Indra")
      
      spawn(function()
	while wait() do
		pcall(function()
		   if game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
		      RipIndra:Set("Rip Indra Spawning ✅")
		   else
		      RipIndra:Set("Not Have Rip Indra in Severs ❌")
		   end
		end)
    end
end)
      
        Items:Toggle("Auto kill Rip Indra", false,function(Values)      
          _G.RipIndraKill = Values
          StopTween(_G.RipIndraKill)
       end)
       
    local AdminPos = CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781)
     spawn(function()
        pcall(function()
            while wait() do
                if _G.RipIndraKill then
                    if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra True Form") or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == ("rip_indra True Form" or v.Name == "rip_indra") and v.Humanoid.Health > 0 and v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                                repeat task.wait()
                                    pcall(function()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                         topos(v.HumanoidRootPart.CFrame * CFrame.new(0, -40, 0))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 670),workspace.CurrentCamera.CFrame)
                                    end)
                                until _G.RipIndraKill == false or v.Humanoid.Health <= 0
                            end
                        end
                    else
                    if BypassTP then
                        if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - AdminPos.Position).Magnitude > 1500 then
                        TP1(AdminPos)
                        elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - AdminPos.Position).Magnitude < 1500 then
                        TP1(AdminPos)
                        end
                    else
                        TP1(AdminPos)
                    end
                        TP1(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
                    end
                end
            end
        end)
    end)                   

end
        
        Items:Seperator("Auto Buy Haki Colors")
        
        Items:Toggle("Auto Haki Colors", false,function(Value) 
          _G.AutoBuyEnchancementColour = Value          
       end)

     spawn(function()
        while wait() do
            if _G.AutoBuyEnchancementColour then
                local args = {
                    [1] = "ColorsDealer",
                    [2] = "2"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end
           end 
      end)
    
      if World2 then
      Items:Seperator("Auto Swords Legendary")
      
      Items:Toggle("Auto Buy Legendary Sword", false,function(Value) 
          _G.AutoBuyLegendarySword = Value
       end)
       
       spawn(function()
        while wait() do
            if _G.AutoBuyLegendarySword then
                pcall(function()
                    local args = {
                        [1] = "LegendarySwordDealer",
                        [2] = "1"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    local args = {
                        [1] = "LegendarySwordDealer",
                        [2] = "2"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                    local args = {
                        [1] = "LegendarySwordDealer",
                        [2] = "3"
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
             
                end)
            end 
        end
    end)

   end 
 
 if World3 then
       Items:Seperator("Auto Items Legendary")
         
       Items:Toggle("Auto Get Yama", false,function(Values) 
          _G.AutoYama = Values
        end)
       
       spawn(function()
            while wait() do
                if _G.AutoYama then
                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter","Progress")>=30 then
                        repeat wait()
                            fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
                        until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") or not _G.AutoYama
                    end
                end
            end
        end)
         
         Items:Toggle("Auto Holy Torch Tushita", false,function(Values) 
          _G.AutoHolyTorch = Values
          StopTween(_G.AutoHolyTorch)
       end)
       
       spawn(function()
        while wait() do
            if _G.AutoHolyTorch then
                pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625))
                    wait(1)
                     topos(CFrame.new(5711.87451171875, 45.82802963256836, 254.17005920410156))
                    wait(15)
                    EquipWeapon("Holy Torch")
                    repeat topos(CFrame.new(-10752, 417, -9366)) wait() until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-10752, 417, -9366)).Magnitude <= 10
					wait(1)
					repeat topos(CFrame.new(-11672, 334, -9474)) wait() until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-11672, 334, -9474)).Magnitude <= 10
					wait(1)
					repeat topos(CFrame.new(-12132, 521, -10655)) wait() until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-12132, 521, -10655)).Magnitude <= 10
					wait(1)
					repeat topos(CFrame.new(-13336, 486, -6985)) wait() until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-13336, 486, -6985)).Magnitude <= 10
					wait(1)
					repeat topos(CFrame.new(-13489, 332, -7925)) wait() until not _G.AutoHolyTorch or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-Vector3.new(-13489, 332, -7925)).Magnitude <= 10
                end)
            end
        end
    end)
  
      Items:Toggle("Auto Get Tushita", false,function(Values)      
          _G.AutoGetTushita = Values
          StopTween(_G.AutoGetTushita)
       end)
       
       spawn(function()
        while wait() do
            if _G.AutoGetTushita then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Longma") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Longma" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoGetTushita or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Longma") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                        end
                    end
                end)
            end
        end
    end)                            
end
  
       Items:Seperator("Auto Get Items")       
        if World1 then         
        SaberO = Items:Label("Check Boss Saber")
         
         task.spawn(function()
           while wait() do
            pcall(function()
            if game.ReplicatedStorage:FindFirstChild("Saber Expert") or game.Workspace.Enemies:FindFirstChild("Saber Expert") then
           SaberO:Set("Boss Saber Spawning ✅")
            else
           SaberO:Set("Not Have Boss Saber ❌")
           end
         end)
       end
     end)

       Items:Toggle("Auto Get Saber", false,function(Values) 
          AutoSaber = Values
          StopTween(AutoSaber)
       end)
       
       spawn(function()
        while task.wait() do
            if AutoSaber and game.Players.LocalPlayer.Data.Level.Value >= 200 then
                pcall(function()
                    if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency == 0 then
                        if game:GetService("Workspace").Map.Jungle.QuestPlates.Door.Transparency == 0 then
                            if (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
                                topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
                                wait(1)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate1.Button.CFrame
                                wait(1)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate2.Button.CFrame
                                wait(1)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate3.Button.CFrame
                                wait(1)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate4.Button.CFrame
                                wait(1)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Jungle.QuestPlates.Plate5.Button.CFrame
                                wait(1)
                            else
                                topos(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279))
                            end
                        else
                            if game:GetService("Workspace").Map.Desert.Burn.Part.Transparency == 0 then
                                if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Torch") or game.Players.LocalPlayer.Character:FindFirstChild("Torch") then
                                    EquipWeapon("Torch")
                                    topos(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-09, 0.761243105, -5.70652914e-10, 1, 1.20584542e-09, -0.761243105, 3.47544882e-10, -0.648466587))
                                  else
                                  topos(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408))
                                end
                            else
                                if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan") ~= 0 then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","GetCup")
                                    wait(0.5)
                                    EquipWeapon("Cup")
                                    wait(0.5)
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","FillCup",game:GetService("Players").LocalPlayer.Character.Cup)
                                    wait(0)
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","SickMan")
                                else
                                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == nil then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon")
                                    elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 0 then
                                    if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") or game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader") then
										topos(CFrame.new(-2967.59521, -4.91089821, 5328.70703, 0.342208564, -0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, -0.939287126, 0.0184739735, 0.342634559)) 
                                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                                if v.Name == "Mob Leader" then
                                                   if game:GetService("Workspace").Enemies:FindFirstChild("Mob Leader") then
                                                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                                        repeat task.wait()
                                                        AutoHaki()
                                                        EquipWeapon(_G.SelectWeapon)
                                                        v.HumanoidRootPart.CanCollide = false
                                                        v.Humanoid.WalkSpeed = 0
                                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                                        game:GetService("VirtualUser"):CaptureController()
                                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                                        until v.Humanoid.Health <= 0 or not AutoSaber
                                                     end
                                                end
                                                if game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader [Lv. 120] [Boss]") then
                                                    topos(game:GetService("ReplicatedStorage"):FindFirstChild("Mob Leader [Lv. 120] [Boss]").HumanoidRootPart.CFrame * Farm_Mode)
                                                end
                                            end
                                        end
                                     end
                                    elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon") == 1 then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","RichSon")
                                        wait(0.5)
                                        EquipWeapon("Relic")
                                        wait(0.5)
                                        topos(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-09, 0.481375456, 2.53851997e-08, 1, -5.79995607e-08, -0.481375456, 6.30572643e-08, 0.876514494))
                                    end
                                end
                            end
                        end
                    else
                        if game:GetService("Workspace").Enemies:FindFirstChild("Saber Expert") or game:GetService("ReplicatedStorage"):FindFirstChild("Saber Expert") then
                            for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    if v.Name == "Saber Expert" then
                                        repeat task.wait()
                                            EquipWeapon(_G.SelectWeapon)
                                            topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                            v.HumanoidRootPart.Transparency = 1
                                            v.Humanoid.JumpPower = 0
                                            v.Humanoid.WalkSpeed = 0
                                            v.HumanoidRootPart.CanCollide = false
                                            FarmPos = v.HumanoidRootPart.CFrame
                                            MonFarm = v.Name
                                            game:GetService'VirtualUser':CaptureController()
                                            game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672),workspace.CurrentCamera.CFrame)
                                        until v.Humanoid.Health <= 0 or not AutoSaber
                                        if v.Humanoid.Health <= 0 then
                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress","PlaceRelic")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
         
     PoleStatus = Items:Label("Check Boss Pole")
      
    task.spawn(function()
     while wait() do
       pcall(function()
      if game.ReplicatedStorage:FindFirstChild("Thunder God") or game.Workspace.Enemies:FindFirstChild("Thunder God") then
         PoleStatus:Set("Pole Boss Spawning ✅")
          else
         PoleStatus:Set("Not Have Pole Boss ❌")
        end
       end)
      end
    end)
    
      Items:Toggle("Auto Get Sword Pole", false,function(Values)      
          _G.Autopole = Values
          StopTween(_G.Autopole)
       end)
       
       spawn(function()
        while wait() do
            if _G.Autopole then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Thunder God") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Thunder God" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.Autopole or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Thunder God").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                        end
                    end
                end)
            end
        end
    end)                            
    
    Items:Toggle("Auto Get Sword Saw", false,function(Values)      
          _G.Autosaw = Values
          StopTween(_G.Autosaw)
       end)
       
     local SharkPos = CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094)
       spawn(function()
        while wait() do
            if  _G.Autosaw then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("The Saw") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "The Saw" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait(_G.FastAttackDelay)
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                       topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        AttackNoCD()
                                    until not  _G.Autosaw or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    if BypassTP then
                    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SharkPos.Position).Magnitude > 1500 then
			        BTP(SharkPos)
				    elseif (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - SharkPos.Position).Magnitude < 1500 then
				    topos(SharkPos)
					end
				else
				    topos(SharkPos)
				end
				    EquipWeapon(_G.SelectWeapon)
                    topos(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
                        if game:GetService("ReplicatedStorage"):FindFirstChild("The Saw") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("The Saw").HumanoidRootPart.CFrame * CFrame.new(2,40,2))
                       
                        end
                    end
                end)
            end
        end
    end)
        
      Items:Toggle("Auto Get Sword Wardens", false,function(Values)      
          _G.ChiefWarden = Values
          StopTween(_G.ChiefWarden)          
       end)
         spawn(function()
           while wait() do
             if _G.ChiefWarden then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Chief Warden") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Chief Warden" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.ChiefWarden or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Chief Warden").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)                         
             
      Items:Toggle("Auto Get Sword Trident", false,function(Values)  
          _G.Trident = Values
          StopTween(_G.Trident)          
       end)
         spawn(function()
           while wait() do
             if _G.Trident then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Fishman Lord") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Fishman Lord" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.Trident or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Lord") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Fishman Lord").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)                         
    
   end

        if World2 then
        Items:Toggle("Auto Get Longsword", false,function(Values)      
          _G.Longsword = Values
          StopTween(_G.Longsword)          
       end)
         spawn(function()
           while wait() do
             if _G.Longsword then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Diamond") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Diamond" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.Longsword or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Diamond") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Diamond").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)                         
    
         Items:Toggle("Auto Get Sword Gravity Blade", false,function(Values)      
          _G.GravityBlade = Values
          StopTween(_G.GravityBlade)          
       end)
         spawn(function()
           while wait() do
             if _G.GravityBlade then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Fajita") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Fajita" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.GravityBlade or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Fajita") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Fajita").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)                         
    
     Items:Toggle("Auto Get Sword Flail", false,function(Values)      
          _G.SwodsFlail = Values
          StopTween(_G.SwodsFlail)          
       end)
         spawn(function()
           while wait() do
             if _G.SwodsFlail then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Smoke Admiral") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Smoke Admiral" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.SwodsFlail or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Smoke Admiral") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Smoke Admiral").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)                         
    
      Items:Toggle("Auto Get Sword Rengoku", false,function(Values)      
          _G.AutoRengoku = Values
          StopTween(_G.AutoRengoku)          
       end)
      
      spawn(function()
         pcall(function()
        while wait() do
            if _G.AutoRengoku then
                if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") 
                or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Hidden Key") then
                    EquipWeapon("Hidden Key")
                    topos(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
                elseif game:GetService("Workspace").Enemies:FindFirstChild("Awakened Ice Admiral") then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Awakened Ice Admiral" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") 
                            and v.Humanoid.Health > 0 then
                                repeat 
                                    task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    PosMon = v.HumanoidRootPart.CFrame
                                    MonFarm = v.Name
                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    AttackNoCD()
                                    StartBring = true
                                until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Hidden Key") 
                                or _G.AutoRengoku == false 
                                or not v.Parent 
                                or v.Humanoid.Health <= 0
                                StartBring = false
                            end
                        end
                    end
                else
                    StartBring = false
                    topos(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
                end
            end
        end
    end)
end)

   
    
    Items:Toggle("Auto Get Sword Dragon Trident", false,function(Values)      
          _G.SwodsDRTrident = Values
          StopTween(_G.SwodsDRTrident)          
       end)
         spawn(function()
           while wait() do
             if _G.SwodsDRTrident then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Tide Keeper") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Tide Keeper" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.SwodsDRTrident or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Tide Keeper").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)           
    
   end

       if World3 then
      Items:Toggle("Auto Get Sword Twin Hooks", false,function(Values)      
          _G.SwodTwinHooks = Values
          StopTween(_G.SwodTwinHooks)          
       end)
         spawn(function()
           while wait() do
             if _G.SwodTwinHooks then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Captain Elephant") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Captain Elephant" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.SwodTwinHooks or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Captain Elephant").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)                         
    
    
       Items:Toggle("Auto Get Sword Canvander", false,function(Values)      
          _G.SwodCanvander = Values
          StopTween(_G.SwodCanvander)          
       end)
         spawn(function()
           while wait() do
             if _G.SwodCanvander then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Beautiful Pirate") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Beautiful Pirate" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.SwodCanvander or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Beautiful Pirate").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)       
         
       Items:Toggle("Auto Get Sword Buddy", false,function(Values)      
          _G.SwodsBuddy = Values
          StopTween(_G.SwodsBuddy)          
       end)
         spawn(function()
           while wait() do
             if _G.SwodsBuddy then
                 pcall(function()
                     if game:GetService("Workspace").Enemies:FindFirstChild("Cake Queen") then
                          for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                              if v.Name == "Cake Queen" then
                                 if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        StartBring = true
                                        v.Humanoid.WalkSpeed = 0
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.SwodsBuddy or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen") then
                            TP1(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                          end
                       end
                    end)
                end
             end
         end)                             
                                                 
 end      

       Dragon:Button("Tween Dragon Dojo", function()
   game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, - 334.9649963378906));
        TP1(CFrame.new(5841.298828125, 1208.32177734375, 884.3173217773438))
    end)

local CheckDojo = Dragon:Label("Check Quest Dragon")

spawn(function()
    pcall(function()
        while wait() do
            local Check = {
                [1] = {
                    Context = "Check"
                }
            };
            local Pl = game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/DragonHunter"):InvokeServer(unpack(Check));
            if (typeof(Pl) == "table") then
                for c, Tr in pairs(Pl) do
                    if (Tr == "Defeat 3 Venomous Assailants on Hydra Island.") then
                    CheckDojo:Set("Defeat 3 Venomous Assailants on Hydra Island.");
                    elseif (Tr == "Defeat 3 Venomous Assailants on Hydra Island.") then
                     CheckDojo:Set("Defeat 3 Venomous Assailants on Hydra Island.");
                    elseif (Tr == "Destroy 10 trees on Hydra Island.") then
                     CheckDojo:Set("Destroy 10 trees on Hydra Island.");
                    end
                end
            else
            end
        end
    end);
end);

   _G.SelectQuestDragon = "Venomous Assailant"
  Dragon:Dropdown("Select Mob Quest",{"Venomous Assailant","Hydra Enforcer"},{"Venomous Assailant"},function(v)
    _G.SelectQuestDragon = v
     end)

   Dragon:Toggle("Auto Farm Mob Quest", false,function(Values)      
          _G.AutoMobDragon = Values
          _G.AutoBlazeEmber = Values
          StopTween(_G.AutoMobDragon)          
       end)
       
       spawn(function()
        while wait() do
            if _G.AutoMobDragon then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild(_G.SelectQuestDragon) then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == _G.SelectQuestDragon then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        StartBring = true
                                        PosMon = v.HumanoidRootPart.CFrame
                                        v.HumanoidRootPart.Size = Vector3.new(80,80,80)                             
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        game:GetService("VirtualUser"):CaptureController()
                                        game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                    until not _G.AutoMobDragon or not v.Parent or v.Humanoid.Health <= 0
                                    StartBring = false
                                end
                            end
                        end
                    else
                        if game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectQuestDragon) then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild(_G.SelectQuestDragon).HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                        end
                    end
                end)
            end
        end
    end)
    spawn(function()
    while wait() do
        if _G.AutoBlazeEmber then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/DragonDojoEmber"):FireServer();
            end);
        end
    end
end);

   Dragon:Toggle("Auto tree destroyer", false,function(Values)      
   _G.AutoHydraTree = Values
   _G.AutoBlazeEmber = Values
   StopTween(_G.AutoHydraTree)   
  end)
  
  local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:FindFirstChildOfClass("Humanoid")

local Positions = {
    CFrame.new(5255.1049, 1004.1949, 344.7700),
    CFrame.new(5340.3584, 1004.1949, 362.6387),
    CFrame.new(5323.6436, 1004.1949, 440.7161),
    CFrame.new(5244.3618, 1004.1949, 422.4569)
}

local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    wait(0.1)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function useWeapon(weapon)
    if humanoid then
        local tool = player.Backpack:FindFirstChild(weapon)
        if tool then
            humanoid:EquipTool(tool)
            wait(0.2)
            pressKey("E")
        end
    end
end

local function useSkills()
    pressKey("Z")
    wait(0.5)
    pressKey("X")
    wait(0.5)
    pressKey("C")
end

local function TweenToPosition(targetCFrame, duration)
    local character = player.Character or player.CharacterAdded:Wait()
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local goal = {CFrame = targetCFrame}
        local tween = TweenService:Create(hrp, tweenInfo, goal)
        tween:Play()
        tween.Completed:Wait()
    end
end

spawn(function()
    while wait() do
        if _G.AutoHydraTree then
            AutoHaki()
            for _, pos in ipairs(Positions) do
                if not _G.AutoHydraTree then break end
                TweenToPosition(pos, 2)

                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local distance = (character.HumanoidRootPart.Position - pos.Position).Magnitude
                    if distance <= 1 then
                        _G.AutoSkill = true
                        wait(3)
                        _G.AutoSkill = false
                    end
                end
            end
        end
    end
end)

spawn(function()
    while wait(1) do
        if _G.AutoSkill then
            useWeapon("Melee")
            useWeapon("Sword")
            useWeapon("Gun")
            useSkills()
        end
    end
end)



   Dragon:Button("Craft Volcanic Magnet",function()
    local args = {
      [1] = "CraftItem",
      [2] = "Craft",
      [3] = "Volcanic Magnet"
    }
   game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end)

 VolcanoSP = Volcano:Label("Check Prehistoric island")
  
  spawn(function()
    while wait() do
        pcall(function()
            if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
                VolcanoSP:Set("Prehistoric island: Spawning ✅")
            else
                VolcanoSP:Set("Prehistoric island: Not Spawning ❌")
               end
            end)
          end
       end)
       
function GetLocalBoat()
    for i, v in next, game:GetService("Workspace").Boats:GetChildren() do
        if v:IsA("Model") then
            if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == game:GetService("Players").LocalPlayer.Name and v.Humanoid.Value > 0 then
                return v
            end
        end
    end
    return false
end

    Volcano:Button("Remove Lava Prehistoric",function()
        for i,v in pairs(game.Workspace:GetDescendants()) do
			if v.Name == "Lava" then   
				v:Destroy()
			end
		end
		for i,v in pairs(game.ReplicatedStorage:GetDescendants()) do
			if v.Name == "Lava" then   
				v:Destroy()
			end
		end
	end)
 
  Volcano:Toggle("Auto Tìm đảo Prehistoric", false, function(value)
    _G.AutoFindPrehistoric = value
    _G.Nocliprock = value
  end)
  
  local seatHistory = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local SetSpeedBoat = 350  

RunService.RenderStepped:Connect(function()
    for boatName, seat in pairs(seatHistory) do
        if seat and seat.Parent and seat.Name == "VehicleSeat" and not seat.Occupant then
            seatHistory[boatName] = seat
        end
    end
end)

local function tpToMyBoat()
    for boatName, seat in pairs(seatHistory) do
        if seat and seat.Parent and seat.Name == "VehicleSeat" and not seat.Occupant then
            topos(seat.CFrame)
        end
    end
end

local isTeleporting = false
local notified = false
RunService.RenderStepped:Connect(function()
    if not _G.AutoFindPrehistoric then
        notified = false
        return
    end
    local player = Players.LocalPlayer
    local character = player.Character
    if not character or not character:FindFirstChild("Humanoid") then return end
    
    local function tpToMyBoat()
        if isTeleporting then return end
        isTeleporting = true
        for boatName, seat in pairs(seatHistory) do
            if seat and seat.Parent and seat.Name == "VehicleSeat" and not seat.Occupant then
                topos(seat.CFrame)
                break
            end
        end
        isTeleporting = false
    end
    
    local humanoid = character.Humanoid
    local boatFound = false
    local currentBoat = nil
    
    for _, b in pairs(Workspace.Boats:GetChildren()) do
        local seat = b:FindFirstChild("VehicleSeat")
        if seat and seat.Occupant == humanoid then
            boatFound = true
            currentBoat = seat
            seatHistory[b.Name] = seat
        elseif seat and seat.Occupant == nil then
            tpToMyBoat()
        end
    end

    if not boatFound then return end
    
    currentBoat.MaxSpeed = SetSpeedBoat
    currentBoat.CFrame = CFrame.new(Vector3.new(currentBoat.Position.X, currentBoat.Position.Y, currentBoat.Position.Z)) * currentBoat.CFrame.Rotation
    VirtualInputManager:SendKeyEvent(true, "W", false, game)

    for _, v in pairs(Workspace.Boats:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end

    local islandsToDelete = { 
        "ShipwreckIsland", 
        "SandIsland", 
        "TreeIsland",
        "TinyIsland", 
        "MysticIsland", 
        "KitsuneIsland", 
        "FrozenDimension" 
    }
    for _, islandName in ipairs(islandsToDelete) do
        local island = Workspace.Map:FindFirstChild(islandName)
        if island and island:IsA("Model") then
            island:Destroy()
        end
    end

    local prehistoricIsland = Workspace.Map:FindFirstChild("PrehistoricIsland")
    if prehistoricIsland then
        VirtualInputManager:SendKeyEvent(false, "W", false, game)
        
        _G.AutoFindPrehistoric = false

        if not notified then
            notified = true
        end
        return
    end
end)

  Volcano:Toggle("Auto Bay vào đảo Prehistoric", false, function(value)
   _G.TweenVolcano = value
   end)
   
   spawn(function()
    local island
    while not island do
        island = game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
        wait()
    end
    while wait() do
        if _G.TweenVolcano then
            local prehistoricIslandCore = game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")
            if prehistoricIslandCore then
                local relic = prehistoricIslandCore:FindFirstChild("Core") and prehistoricIslandCore.Core:FindFirstChild("PrehistoricRelic")
                local skull = relic and relic:FindFirstChild("Skull")
                if skull then
                    TP1(CFrame.new(skull.Position))
                    _G.TweenVolcano = false
                end
            end
        end
    end
end)

  Volcano:Toggle("Auto Lấp lỗ Prehistoric", false, function(value)
    _G.DefendVolcano = value
  end)
  
   local function sendKeyEvent(key)
	game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game);
	game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game);
end
local function removeLava()
	local interiorLava = game.Workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava");
	if (interiorLava and interiorLava:IsA("Model")) then
		interiorLava:Destroy();
	end
	local prehistoricIsland = game.Workspace.Map:FindFirstChild("PrehistoricIsland");
	if prehistoricIsland then
		for _, part in pairs(prehistoricIsland:GetDescendants()) do
			if (part:IsA("Part") and part.Name:lower():find("lava")) then
				part:Destroy();
			end
		end
	end
	if prehistoricIsland then
		for _, model in pairs(prehistoricIsland:GetDescendants()) do
			if model:IsA("Model") then
				for _, mesh in pairs(model:GetDescendants()) do
					if (mesh:IsA("MeshPart") and mesh.Name:lower():find("lava")) then
						mesh:Destroy();
					end
				end
			end
		end
	end
end
local function findVolcanoRock()
	local volcanoRocks = game.Workspace.Map.PrehistoricIsland.Core.VolcanoRocks;
	for _, rockModel in pairs(volcanoRocks:GetChildren()) do
		if rockModel:IsA("Model") then
			local rock = rockModel:FindFirstChild("volcanorock");
			if (rock and rock:IsA("MeshPart")) then
				local rockColor = rock.Color;
				if ((rockColor == Color3.fromRGB(185, 53, 56)) or (rockColor == Color3.fromRGB(185, 53, 57))) then
					return rock;
				end
			end
		end
	end
	return nil;
end
local function useWeapon(weaponType)
	local player = game.Players.LocalPlayer;
	local backpack = player.Backpack;
	for _, tool in pairs(backpack:GetChildren()) do
		if (tool:IsA("Tool") and (tool.ToolTip == weaponType)) then
			tool.Parent = player.Character;
			for _, key in ipairs({"Z", "X", "C", "V", "F"}) do
				wait();
				pcall(function()
					sendKeyEvent(key);
				end);
			end
			tool.Parent = backpack;
			break;
		end
	end
end
spawn(function()
	while wait() do
		if _G.DefendVolcano then
			AutoHaki();
			pcall(removeLava);
			local volcanoRock = findVolcanoRock();
			if volcanoRock then
				local targetPosition = CFrame.new(volcanoRock.Position)
				TP1(targetPosition);
				local rockColor = volcanoRock.Color;
				if ((rockColor ~= Color3.fromRGB(185, 53, 56)) and (rockColor ~= Color3.fromRGB(185, 53, 57))) then
					volcanoRock = findVolcanoRock();
				else
					local playerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position;
					local distance = (playerPosition - volcanoRock.Position).Magnitude;
					if (distance <= 1) then
						if _G.UseMelee then
							useWeapon("Melee");
						end
						if _G.UseSword then
							useWeapon("Sword");
						end
						if _G.UseGun then
							useWeapon("Gun");
						end
					end
					_G.TpPrehistoric = false;
				end
			else
				_G.TpPrehistoric = true;
			end
		end
	end
end);

  Volcano:Toggle("Auto Lấp lỗ bằng Melee", false, function(value)
      _G.UseMelee = value
  end)
  
  Volcano:Toggle("Auto Lấp lỗ Sword", false, function(value)
      _G.UseSword = value
  end)
  
  Volcano:Toggle("Auto Lấp lỗ bằng Gun", false, function(value)
      _G.UseGun = value
  end)

  Volcano:Toggle("Auto Đánh Golem", false, function(value)
      _G.KillGolem = value
     StopTween(_G.KillGolem)
  end)

spawn(function()
    while wait() do
        if _G.KillGolem and World3 then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild("Lava Golem") then
                    for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == "Lava Golem" then
                            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                repeat task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    v.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.HumanoidRootPart.Size = Vector3.new(50,50,50)
                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",math.huge)
                                until not  _G.KillGolem or not v.Parent or v.Humanoid.Health <= 0
                            end
                        end
                    end
                else
                 UnEquipWeapon(_G.SelectWeapon)
                    if game:GetService("ReplicatedStorage"):FindFirstChild("Lava Golem") then
                        topos(game:GetService("ReplicatedStorage"):FindFirstChild("Lava Golem").HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                    end
                end
            end)
        end
    end
end)
  Volcano:Toggle("Nhặt Xương", false, function(Value)
      _G.AutoCollectBone = Value    
     StopTween(_G.AutoCollectBone)
 end)

spawn(function()
    while wait() do
        if _G.AutoCollectBone then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "DinoBone" then
                    topos(CFrame.new(obj.Position))
                end
            end
        end
    end
end)
Volcano:Toggle("Nhặt Trứng", false, function(Value)
    _G.CollectEgg = Value    
    StopTween(_G.CollectEgg)
end)
spawn(function()
    while wait() do
        if _G.CollectEgg then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/CollectedDragonEgg"):FireServer()
            end)
        end
    end
end)

    Events:Button("Remove Fog",function()
    game:GetService("Lighting").BaseAtmosphere:Destroy()
    end)

      Events:Seperator("Kitsune Islands")
   
  Kitsune = Events:Label("Check Kitsune island")
   
   spawn(function()
        pcall(function()
            while wait() do
         if game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") then
      Kitsune:Set('Kitsune Island Spawning ✅')
        else
      Kitsune:Set('Kitsune Island Not Spawning ❌' )
            end
            end
         end)
     end)
     
     Events:Toggle("Esp Kitsune Island", false, function(value)
        KitsuneIslandEsp = value
        while KitsuneIslandEsp do wait()
            UpdateIslandKisuneESP()   
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if KitsuneIslandEsp then
			    UpdateIslandKisuneESP()  
		    end
	    end
    end)
     
    Events:Toggle("Tween Kitsune Island", false, function(value)
    _G.TweenToKitsune = value
   end)
   
   spawn(function()
        local kitsuneIsland
        while not kitsuneIsland do
            kitsuneIsland = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland")
            wait(1)
        end
        while wait() do
            if _G.TweenToKitsune then
                local shrineActive = kitsuneIsland:FindFirstChild("ShrineActive")
                if shrineActive then
                    for _, v in pairs(shrineActive:GetDescendants()) do
                        if v:IsA("BasePart") and v.Name:find("NeonShrinePart") then
                            Tween(v.CFrame)
                        end
                    end
                end
            end
        end
    end)
        
	spawn(function()
        pcall(function()
            while wait() do
                if _G.TweenToKitsune then
                    topos(game.Workspace.Map.KitsuneIsland.ShrineActive.NeonShrinePart.CFrame * CFrame.new(0,0,10))
                end
            end
        end)
    end)
    
     Events:Toggle("Auto Azuer Ember", false, function(value)
    _G.AutoAzuerEmber = value
   end)
   
   spawn(function()
            while wait() do
                if _G.AutoAzuerEmber then
                    pcall(function()
                        if game:GetService("Workspace"):FindFirstChild("AttachedAzureEmber") then
                            TP1(game.Workspace.EmberTemplate.Part.CFrame)
                        end
                    end)
                end
            end
        end)
        
    Events:Seperator("Sea")
    
    Events:Toggle("Auto Drive Boats", false, function(value)
    _G.SailBoat = value
    _G.Nocliprock = value
    StopTween(_G.SailBoat)
end)
spawn(function()
    while wait() do
        pcall(function()
            if _G.SailBoat then
                if not game:GetService("Workspace").Enemies:FindFirstChild("Shark") or not game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or not game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or not game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") then
                    if not game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
                        buyb = TPP(CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781))
                        if (CFrame.new(-16927.451171875, 9.0863618850708, 433.8642883300781).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                            if buyb then buyb:Stop() end
                            local args = {
                                [1] = "BuyBoat",
                                [2] = "PirateBrigade"
                            }

                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                        end
                    elseif game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then
                        if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false then
                            TPP(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0,1,0))
                        else
                            for i,v in pairs(game:GetService("Workspace").Boats:GetChildren()) do
                                if v.Name == "PirateBrigade" then
                                    repeat wait()
                                        if (CFrame.new(-17013.80078125, 10.962434768676758, 438.0169982910156).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                            TPB(CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581e-09, 0.967632651, 2.87320709e-08, 1, 3.21888249e-09, -0.967632651, 2.86144175e-08, -0.252362996))
                                        elseif (CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581e-09, 0.967632651, 2.87320709e-08, 1, 3.21888249e-09, -0.967632651, 2.86144175e-08, -0.252362996).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                            TPB(CFrame.new(-42250.2227, -0.3221744, 9247.07715, -0.45916447, 6.39043236e-08, 0.888351262, -3.36711423e-08, 1, -8.93395651e-08, -0.888351262, -7.09333605e-08, -0.45916447))
                                        elseif (CFrame.new(-42250.2227, -0.3221744, 9247.07715, -0.45916447, 6.39043236e-08, 0.888351262, -3.36711423e-08, 1, -8.93395651e-08, -0.888351262, -7.09333605e-08, -0.45916447).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 10 then
                                            TPB(CFrame.new(-37813.6953, -0.3221744, 6105.16895, -0.252362996, 4.13621581e-09, 0.967632651, 2.87320709e-08, 1, 3.21888249e-09, -0.967632651, 2.86144175e-08, -0.252362996))
                                        end 
                                    until game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or _G.SailBoat == false
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        while wait() do
            if _G.SailBoat then
                if game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") then
                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
            end
        end
    end)
end)
    
    Events:Toggle("Auto Kill Terror Shank",false, function(state)
        _G.Autoterrorshark = state
        getgenv().SafeMode = state
        StopTween(_G.Autoterrorshark)
    end)
spawn(function()
        while wait() do 
            if _G.Autoterrorshark and World3 then
                pcall(function()                    
                    if game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Terrorshark" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(5,40,10))
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                        if game:GetService("Workspace")["_WorldOrigin"]:FindFirstChild("Typhoon Splash") then
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 300, 0)); 
                                        else
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 60, 0));
                                        end
                                    until not _G.Autoterrorshark or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else 
                      topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))		                       
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do                                 
                            if v.Name == "Terrorshark" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))
                           else   
                           game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end)
            end
        end
    end)    
    
    spawn(function()
while wait() do 
    if _G.dao then
         pcall(function()
    if not game:GetService("Workspace").Boats:FindFirstChild("PirateBrigade") then 
		             game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat","PirateBrigade")
		          end
        end)
    end
    end
end)
               
    spawn(function()
	while wait() do 
		if _G.dao then		
				if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
		TPB(CFrame.new(-25351.8418, 10.7575607, 26430.791, -0.998379767, -0.00721008703, -0.0564435199, -0.00722159958, 0.999973953, -1.53919405e-10, 0.0564420484, 0.000407612359, -0.998405814))		
		  end
		end
	end
end)   
     
 spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().SafeMode then
                local Player = game.Players.LocalPlayer
                local Character = Player.Character
                if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart") then
                    local Humanoid = Character.Humanoid
                    local Root = Character.HumanoidRootPart

                    if Humanoid.Health < 5500 then
                        while getgenv().SafeMode and Humanoid.Health < 5500 do
                            task.wait(0.1)
                            Root.CFrame = Root.CFrame + Vector3.new(0, 200, 0)
                        end
                    end
                end
            end
        end)
    end
end)
             
                                
 spawn(function()
	while wait() do
		if _G.Nocliprock then
			if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
				for _, v in pairs(game.Workspace.Boats:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide == true then
						v.CanCollide = false
					end
				end
				for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide == true then
						v.CanCollide = false
					end
				end
			elseif game.Players.LocalPlayer.Character.Humanoid.Sit == false then
				for _, v in pairs(game.Workspace.Boats:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide == false then
						v.CanCollide = true
					end
				end
				for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") and v.CanCollide == false then
						v.CanCollide = true
					end
				end
			end
		end
	end
end)
             
    Events:Toggle("Auto Kill Shark",false, function(state)
        _G.KillShark = state
        StopTween(_G.KillShark)
    end)
    
    spawn(function()
        while wait() do 
            if _G.KillShark and World3 and _G.SailBoat then
                pcall(function()                    
                    if game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Shark" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(5,40,10))
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                    until not _G.KillShark or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else        
                      topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))		                
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                        if not v.Name == "Shark" then
                                game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            elseif v.Name == "Shark" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))                                   
                            end
                        end
                    end
                end)
            end
        end
    end)    
    
    Events:Toggle("Auto Kill Piranha",false, function(state)
        _G.KillPiranha = state
        StopTween(_G.KillPiranha)
    end)
    
    spawn(function()
        while wait() do 
            if _G.KillPiranha and World3 then
                pcall(function()                    
                    if game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Piranha" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(5,40,10))
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                         game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                    until not _G.KillPiranha or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                      topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))		                        
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                        if not v.Name == "Piranha" then
                                game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            elseif v.Name == "Piranha" then
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(2,20,2))   
                            end
                        end
                    end
                end)
            end
        end
    end)    
    
    Events:Toggle("Auto Auto Kill Fish Crew Member",false, function(state)
        _G.KillFishCrew = state
        StopTween(_G.KillFishCrew)
    end)
        
      spawn(function()
        while wait() do 
            if _G.KillFishCrew and World3 then
                pcall(function()                    
                    if game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBrigade") or game:GetService("Workspace").Enemies:FindFirstChild("PirateBasic") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Fish Crew Member" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                        v.Head.CanCollide = false 
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(5,40,10))
                                        MonFarm = v.Name                
                                        PosMon = v.HumanoidRootPart.CFrame
                                        game.Players.LocalPlayer.Character.Humanoid.Sit = false
                                    until not _G.KillFishCrew or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                      topos(game:GetService("Workspace").Boats.PirateBrigade.VehicleSeat.CFrame * CFrame.new(0, -1, 0))		
                        for i,v in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do 
                        if not v.Name == "Fish Crew Member" then
                                game:GetService("Workspace").Boats.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end)
            end
        end
    end)  
    
         Events:Seperator("Mirage island")
         
        Mirragecheck = Events:Label("Check Mirage Island")
            spawn(function()
        pcall(function()
            while wait() do
                if game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') then
                    Mirragecheck:Set('Mirage Island is Spawning ✅')
                else
                    Mirragecheck:Set('Mirage Island Not Spawn ❌') 
                 end
            end
        end)
    end)           
    
      Events:Toggle("Esp Mirage Island", false, function(value)
        MirageIslandESP = value
        while MirageIslandESP do wait()
            UpdateIslandMirageESP() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if MirageIslandESP then
			    UpdateIslandMirageESP() 
		    end
	    end
    end)                                              
    
    Events:Toggle("Tween mirage island ",false, function(Value)
        _G.AutoMysticIsland = Value
        end)
    spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.AutoMysticIsland then
                for _, cac_329 in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
                    if cac_329.Name == "Mirage Island" then
                        topos(cac_329.CFrame * CFrame.new(0, 333, 0))
                    end
                end
            end
        end)
    end
end)
      Events:Toggle("Look Moon + Auto V3",false, function(Value)
        _G.AutoDooHee = Value
        end)
  local virtualInputManager = game:GetService("VirtualInputManager")
   spawn(function()
    while wait() do
        pcall(function()
            if getgenv()._G.AutoDooHee then
                local moonDir = game.Lighting:GetMoonDirection()
                local lookAtPos = game.Workspace.CurrentCamera.CFrame.p + moonDir * 100
                game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.p, lookAtPos)
                wait(2)
                virtualInputManager:SendKeyEvent(true, "T", false, game)
                wait(0.1)
                virtualInputManager:SendKeyEvent(false, "T", false, game)
            end
        end)
    end
end)
    
    Events:Toggle("Tween Gear",false, function(state)
        _G.TweenMGear = state
        StopTween(_G.TweenMGear)
    end)
    spawn(function()
    pcall(function()
        while wait() do
            if _G.TweenMGear then
				if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
					for i,v in pairs(game:GetService("Workspace").Map.MysticIsland:GetChildren()) do 
						if v:IsA("MeshPart")then 
                            if v.Material ==  Enum.Material.Neon then  
                                topos(v.CFrame)
                            end
                        end
					end
				end
			end
        end
    end)
    end)                   
    
    Events:Button("Tween Advanced Fruit Dealer",function()
    TweenNpc()
    end)
    
     function TweenNpc()
       repeat
       wait()
      until game:GetService("Workspace").Map:FindFirstChild("MysticIsland")
      if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
      AllNPCS = getnilinstances()
      for r, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
      table.insert(AllNPCS, v)
      end
      for r, v in pairs(AllNPCS) do
      if v.Name == "Advanced Fruit Dealer" then
       topos(v.HumanoidRootPart.CFrame)
      end
    end
  end
end 

  local Pulllevel = Trailers:Label("Check Temple Door")
  
   task.spawn(function()
    while wait() do
        pcall(function()
            if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor") then
                Pulllevel:Set("Pull Level: Done ✅")
            else
                Pulllevel:Set("Pull Level: Done ❌")
               end
            end)
          end
       end)


     FM = Trailers:Label("Full Moon")
    
        task.spawn(function()
            while task.wait() do
                pcall(function()
                    if game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149431" then
                        FM:Set("Full Moon: 100")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149052" then
                        FM:Set("Full Moon: 75")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709143733" then
                        FM:Set("Full Moon: 50")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709150401" then
                        FM:Set("Full Moon: 25")
                    elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149680" then
                        FM:Set("Full Moon: 15")
                    else
                        FM:Set("Full Moon: 0")
                    end
                end)
            end
    end)
    
    Trailers:Button("Teleport To Top GreatTree",function()
    topos(CFrame.new(3030.39453125, 2280.6171875, -7320.18359375))
    end)
    
    Trailers:Button("Teleport Temple Of Time",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28286.35546875, 14895.3017578125, 102.62469482421875))
    end)
      
    Trailers:Button("Teleport Lever Pull",function()
    topos(CFrame.new(28575.181640625, 14936.6279296875, 72.31636810302734))
    end)
    
    Trailers:Button("Teleport To The Clock",function()
    topos(CFrame.new(29553.7812, 15066.6133, -88.2750015, 1, 0, 0, 0, 1, 0, 0, 0, 1))
    end)
    
    Trailers:Button("Auto Race Door",function()
            Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875) 
        wait(0.1)
           Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875) 
           wait(0.1)
              Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875) 
              wait(0.1)
                 Game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875) 
            wait(0.5)
                    if game:GetService("Players").LocalPlayer.Data.Race.Value == "Human" then
                    topos(CFrame.new(29221.822265625, 14890.9755859375, -205.99114990234375))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Skypiea" then
                    topos(CFrame.new(28960.158203125, 14919.6240234375, 235.03948974609375))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Fishman" then
                    topos(CFrame.new(28231.17578125, 14890.9755859375, -211.64173889160156))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Cyborg" then
                    topos(CFrame.new(28502.681640625, 14895.9755859375, -423.7279357910156))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Ghoul" then
                    topos(CFrame.new(28674.244140625, 14890.6767578125, 445.4310607910156))
                    elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
                    topos(CFrame.new(29012.341796875, 14890.9755859375, -380.1492614746094))
                    end
                 end)
                 
       Trailers:Button("Buy Acient One Quest",function()
       game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer('UpgradeRace','Buy')
        end)
     
     Trailers:Seperator("Race V4 Trials")
           
        Trailers:Toggle("Auto Trial Human Ghost",false, function(Value)
        _G.Kill_Aura = Value
        end)
        
        Trailers:Toggle("Auto Trial All Race",false, function(Value)
        _G.AutoQuestRace = Value
        end)
        spawn(function()
    pcall(function()
        while wait() do
            if _G.AutoQuestRace then
             if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == true then
                if game:GetService("Players").LocalPlayer.Data.Race.Value == "Human" then
                    for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            pcall(function()
                                repeat wait(.1)
                                    v.Humanoid.Health = 0
                                    v.HumanoidRootPart.CanCollide = false
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.AutoQuestRace or not v.Parent or v.Humanoid.Health <= 0
                            end)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Skypiea" then
                    for i,v in pairs(game:GetService("Workspace").Map.SkyTrial.Model:GetDescendants()) do
                        if v.Name ==  "snowisland_Cylinder.081" then
                            topos(v.CFrame* CFrame.new(0,0,0))
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Fishman" then
                    for i,v in pairs(game:GetService("Workspace").SeaBeasts.SeaBeast1:GetDescendants()) do
                        if v.Name ==  "HumanoidRootPart" then
                            topos(v.CFrame* Pos)
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip == "Melee" then -- "Blox Fruit" , "Sword" , "Wear" , "Agility"
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip == "Blox Fruit" then -- "Blox Fruit" , "Sword" , "Wear" , "Agility"
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                    
                            wait(0.5)
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip == "Sword" then -- "Blox Fruit" , "Sword" , "Wear" , "Agility"
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(0.5)
                            for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    if v.ToolTip == "Gun" then -- "Blox Fruit" , "Sword" , "Wear" , "Agility"
                                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                                    end
                                end
                            end
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,122,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,120,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            wait(.2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false,99,false,game.Players.LocalPlayer.Character.HumanoidRootPart)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Cyborg" then
                    topos(CFrame.new(28654, 14898.7832, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Ghoul" then
                    for i,v in pairs(game.Workspace.Enemies:GetDescendants()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            pcall(function()
                                repeat wait(.1)
                                    v.Humanoid.Health = 0
                                    v.HumanoidRootPart.CanCollide = false
                                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                until not _G.AutoQuestRace or not v.Parent or v.Humanoid.Health <= 0
                            end)
                        end
                    end
                elseif game:GetService("Players").LocalPlayer.Data.Race.Value == "Mink" then
                    for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
                        if v.Name == "StartPoint" then
                            topos(v.CFrame* CFrame.new(0,3,0))
                            if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible == false then
                                _G.AutoQuestRace = false
                                StopTween(_G.AutoQuestRace)
                                end
                            end
                          end
                       end
                end
            end
        end
    end)
end)

     Trailers:Toggle("Auto Kill Player V4",false, function(Value)
        ProjectTrialPro = Value
        end)
        spawn(function()
    while task.wait() do 
        pcall(function()
            if ProjectTrialPro then
                for i, v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
                    local player = game.Players.LocalPlayer
                    local character = player.Character                    
                    if v.Name ~= player.Name and (v.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 450 then
                        if v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.SelectWeapon)
                                NameTarget = v.Name
                                topos(v.HumanoidRootPart.CFrame * CFrame.new(1,1,10))
                                v.HumanoidRootPart.CanCollide = false
                                ProjectXTrial = true
                                Click()                                
                            until not ProjectTrialPro or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end)
    end
end)
spawn(
    function()
        while wait() do
            if ProjectXTrial then
                pcall(
                    function()
                        ac = aQ.activeController
                        ac:attack()
                        AttackFunctgggggion()
                        ac.hitboxMagnitude = 55
                        wait(.1)
                    end
                )
            end
        end
    end
)

spawn(function()
    while wait(0.2) do
        pcall(function()
            if _G.XaiSkillZ and ProjectTrialPro then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, 122, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
            end
            if _G.XaiSkillX and ProjectTrialPro then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, 120, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
            end
            if _G.XaiSkillC and ProjectTrialPro then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, 99, false, game.Players.LocalPlayer.Character.HumanoidRootPart)
            end
        end)
    end
end)

Trailers:Toggle("Skill Z",false, function(Value)
        _G.XaiSkillZ = Value
        end)
Trailers:Toggle("Skill X",false, function(Value)
        _G.XaiSkillX = Value
        end)
Trailers:Toggle("Skill C",false, function(Value)
        _G.XaiSkillC = Value
        end)        

    Espbruh:Toggle("Esp Island", false, function(value)
        IslandESP = value
        while IslandESP do wait()
            UpdateIslandESP() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if IslandESP then
			    UpdateIslandESP() 
		    end
	    end
    end)
    
        Espbruh:Toggle("Esp Player", false, function(value)
        ESPPlayer = value
        while ESPPlayer do wait()
            UpdatePlayerChams()
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if ESPPlayer then
			    UpdatePlayerChams()
		    end
	    end
    end)
    
    Espbruh:Toggle("Esp Chest", false, function(value)
        _G.ChestESP = value
        while _G.ChestESP do wait()
            UpdateChestESP()
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if _G.ChestESP then
			    UpdateChestESP()
		    end
	    end
    end)
        
        Espbruh:Toggle("Esp Fruit", false, function(value)
        DevilFruitESP = value
        while DevilFruitESP do wait()
            UpdateDevilChams() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if DevilFruitESP then
			    UpdateDevilChams() 
		    end
	    end
    end)
    
    Espbruh:Toggle("Esp Berry", false, function(value)
        Berry = value
        while Berry do wait()
            UpdateBerriesESP()
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if Berry then
			    UpdateBerriesESP()
		    end
	    end
    end)
    
    Espbruh:Toggle("Esp Real Fruits", false, function(value)
        RealFruitESP = value
        while RealFruitESP do wait()
            UpdateRealFruitChams() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if RealFruitESP then
			    UpdateRealFruitChams() 
		    end
	    end
    end)
    
    Espbruh:Toggle("Esp Gear", false, function(value)
        GearESP = value
        while GearESP do wait()
            UpdateGeaESP() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if GearESP then
			    UpdateGeaESP() 
		    end
	    end
    end)
    
    Espbruh:Toggle("Esp Flower", false, function(value)
        FlowerESP = value
        while FlowerESP do wait()
            UpdateFlowerChams() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if FlowerESP then
			    UpdateFlowerChams() 
		    end
	    end
    end)
        
       Espbruh:Toggle("Esp Mirage Island", false, function(value)
        MirageIslandESP = value
        while MirageIslandESP do wait()
            UpdateIslandMirageESP() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if MirageIslandESP then
			    UpdateIslandMirageESP() 
		    end
	    end
    end)                       
    
    Espbruh:Toggle("Esp Prehistoric Island", false, function(value)
        PrehistoricIslandESP = value
        while PrehistoricIslandESP do wait()
            UpdatePrehistoricIslandESP() 
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if PrehistoricIslandESP then
			    UpdatePrehistoricIslandESP() 
		    end
	    end
    end)
    
    Espbruh:Toggle("Esp Kitsune Island", false, function(value)
        KitsuneIslandEsp = value
        while KitsuneIslandEsp do wait()
            UpdateIslandKisuneESP()   
        end
    end)
    
    spawn(function()
	    while wait(2) do
		    if KitsuneIslandEsp then
			    UpdateIslandKisuneESP()  
		    end
	    end
    end)
    
   TimeRaid = AutoRaid:Label("Auto Time Raid")

   spawn(function()
    pcall(function()
        while wait() do
   if game.Workspace._WorldOrigin.Locations:FindFirstChild('Island 5') then
    TimeRaid:Set('Status : Island 5')
    elseif game.Workspace._WorldOrigin.Locations:FindFirstChild('Island 4') then
      TimeRaid:Set('Status : Island 4')
     elseif game.Workspace._WorldOrigin.Locations:FindFirstChild('Island 3') then
      TimeRaid:Set('Status : Island 3')
     elseif game.Workspace._WorldOrigin.Locations:FindFirstChild('Island 2') then
      TimeRaid:Set('Status : Island 2')
      elseif game.Workspace._WorldOrigin.Locations:FindFirstChild('Island 1') then
        TimeRaid:Set('Status : Island 1')
        else
         TimeRaid:Set("Status : Start Dungeon") 
         end
        end
     end)
   end)        
    
    AutoRaid:Dropdown("Select Chip Raid",{"Flame","Ice","Sand","Dark","Light","Magma","Quake","Buddha","Spider","Phoenix","Rumble","Dough"},{"Flame"},function(v)
    SelectChip = v
     end)
    
    AutoRaid:Toggle("Auto Buy Chip", false, function(value)
    _G.AutoBuyChip = value
    end)
    spawn(function()
    while wait() do
        if _G.AutoBuyChip then
            pcall(function()
                local args = {
                    [1]="RaidsNpc",
                    [2]="Select",
                    [3]=SelectChip
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
            end)
        end
    end
end)

   AutoRaid:Toggle("Auto Start Raid", false, function(value)
    _G.StartRaid = value
    end)

spawn(function()
    while wait() do
        pcall(function()
            if _G.StartRaid then
                if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Timer.Visible==false then
                    if not game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island 1") and
                        (game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Special Microchip") or
                         game:GetService("Players").LocalPlayer.Character:FindFirstChild("Special Microchip")) then
                        if World2 then
                            topos(CFrame.new(-6438.73535, 250.645355,-4501.50684))
                            local args = {
                                [1]="SetSpawnPoint"
                            }
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                            fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
                        elseif World3 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5075.50927734375, 314.5155029296875,-3150.0224609375))
                            topos(CFrame.new(-5017.40869, 314.844055,-2823.0127,-0.925743818, 4.48217499e-08,-0.378151238, 4.55503146e-09, 1, 1.07377559e-07, 0.378151238, 9.7681621e-08,-0.925743818))
                            local args = {
                                [1]="SetSpawnPoint"
                            }
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                            fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
                        end
                    end
                end
            end
        end)
    end
end)

   AutoRaid:Toggle("Auto Farm Raid Next Island", false, function(value)
    _G.Dungeon = value
    getgenv().SafeMode = value
    StopTween(_G.Dungeon)
    end)

 function IsIslandRaid(cu)
    if game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild("Island " .. cu) then
        min = 4500
        for r, v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
            if
                v.Name == "Island " .. cu and
                    (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < min
            then
                min = (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            end
        end
        for r, v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
            if
                v.Name == "Island " .. cu and
                    (v.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= min
            then
                return v
            end
        end
    end
end

function getNextIsland()
    TableIslandsRaid = {5, 4, 3, 2, 1}
    for r, v in pairs(TableIslandsRaid) do
        if IsIslandRaid(v) and (IsIslandRaid(v).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 4500 then
            return IsIslandRaid(v)
        end
    end
end

function attackNearbyEnemies()
    local enemies = {}
    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local distance = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= 1000 then
                table.insert(enemies, v)
            end
        end
    end

    for _, enemy in pairs(enemies) do
        repeat
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                EquipWeapon(_G.SelectWeapon)
                topos(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                wait(0.1)
            end
        until not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0
    end
end

spawn(function()
    while wait() do
        if _G.Dungeon then
            attackNearbyEnemies()
            if getNextIsland() then
                spawn(topos(getNextIsland().CFrame * CFrame.new(0, 60, 0)), 1)
            end
        end
    end
end)

   AutoRaid:Toggle("Awakener Fruit", false, function(value)
    AutoAwakenAbilities = value
    end)
  
  spawn(function()
    while task.wait() do
        if AutoAwakenAbilities then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Awakener","Awaken")
            end)
        end
    end
end)

    AutoRaid:Toggle("Auto Get Fruit Low Beli", false, function(value)
    _G.Autofruit = value
    end)

 spawn(function()
    while wait(.1) do
        pcall(function()
     if _G.Autofruit then
         
local args = {
    [1] = "LoadFruit",
    [2] = "Rocket-Rocket"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Spin-Spin"
}
game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Chop-Chop"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Spring-Spring"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Bomb-Bomb"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Smoke-Smoke"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Spike-Spike"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Flame-Flame"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Falcon-Falcon"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Ice-Ice"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Sand-Sand"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Dark-Dark"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Ghost-Ghost"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Diamond-Diamond"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Light-Light"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Rubber-Rubber"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))

local args = {
    [1] = "LoadFruit",
    [2] = "Creation-Creation"
}

game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end
end)
end
end)

      if World2 then
     AutoRaid:Seperator("Auto Law Raid")
     
     Events:Button("Auto Buy Chip Law",function()
    local args = {
       [1] = "BlackbeardReward",
       [2] = "Microchip",
       [3] = "2"
    }
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
    
    Events:Button("Auto Start Raid Law",function()
    fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
    end)
     
     AutoRaid:Toggle("Auto Farm Law Raid", false, function(value)
    _G.AutoLawRaid = value
    StopTween(_G.AutoLawRaid)
    end)
     
      spawn(function()
        while wait() do
            if _G.AutoLawRaid then
                pcall(function()
                    if game:GetService("Workspace").Enemies:FindFirstChild("Order") then
                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v.Name == "Order" then
                                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                    repeat task.wait()
                                        AutoHaki()
                                        EquipWeapon(_G.SelectWeapon)
                                        v.HumanoidRootPart.CanCollide = false
                                        v.Humanoid.WalkSpeed = 0
                                                                     
                                        topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                        sethiddenproperty(game:GetService("Players").LocalPlayer,"SimulationRadius",math.huge)
                                    until not _G.AutoLawRaid or not v.Parent or v.Humanoid.Health <= 0
                                end
                            end
                        end
                    else
                    NeedAttacking = true
                        if game:GetService("ReplicatedStorage"):FindFirstChild("Order") then
                            topos(game:GetService("ReplicatedStorage"):FindFirstChild("Order").HumanoidRootPart.CFrame * CFrame.new(5,10,2))
                        end
                    end
                end)
            end
        end
    end)
    
end    

  local FindFruit = Autofruit:Label("Check Fruit")

spawn(function()
	pcall(function()
		while wait() do
			for i, v in pairs(game.Workspace:GetChildren()) do
				if string.find(v.Name, "Fruit") then
					FindFruit:Set("🍏 Find " .. v.Name);
				else
					FindFruit:Set("🍏 Not Have Fruits");
				end;
			end;
		end;
	end);
end);

  Autofruit:Toggle("Auto Random Fruits", false, function(value)
    _G.RandomAuto = value
    end)
    
spawn(function()
    pcall(function()
        while wait() do
            if _G.RandomAuto then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
            end 
        end
    end)
end)
   Autofruit:Button("Random Fruits",function()
     game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin","Buy")
    end)
   
   Autofruit:Toggle("Auto Stores Fruits", false, function(value)
    _G.AutoStoreFruit = value
    end)
    
    spawn(function()
        while wait() do
            pcall(function()
                if _G.AutoStoreFruit then
                    for i, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                        if string.find(v.Name, "Fruit") then
                            ResultStoreFruits = {}
                            CheckFruits()
                            for z, Res in pairs(ResultStoreFruits) do
                            if v.Name == Res then
                                local NameFruit = v.Name
                                local FirstNameFruit = string.gsub(v.Name, " Fruit", "")
                                if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(NameFruit) then
                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit",FirstNameFruit.."-"..FirstNameFruit,game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(NameFruit))
                                end
                            end
                            end
                        end
                    end
                end
            end)
        end
    end)
   
   Autofruit:Toggle("Auto Tween Fruits", false, function(value)
    _G.TweenFruit = value
    end)
        spawn(function()
		while wait(.1) do
			if _G.TweenFruit then
				for i,v in pairs(game.Workspace:GetChildren()) do
					if string.find(v.Name, "Fruit") then
						TP1(v.Handle.CFrame)
					end
				end
			end
        end
    end)
    
    Autofruit:Toggle("Auto Grab Fruit", false, function(value)
    _G.Grabfruit = value
    end)
    spawn(function()
    while wait(.1) do
        if _G.Grabfruit then
            pcall(function()
                for i,v in pairs(game.Workspace:GetChildren()) do
                    if string.find(v.Name, "Fruit") and v:FindFirstChild("Handle") then
                        -- Tween to fruit
                        topos(v.Handle.CFrame)
                        wait(0.3)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
                        wait(0.5)
                        -- Auto store fruit
                        pcall(function()
                            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool and string.find(tool.Name, "Fruit") then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", tool.Name, game.Players.LocalPlayer.Backpack)
                                game:GetService("StarterGui"):SetCore("SendNotification", {
                                    Title = "ReaperHub",
                                    Text = "Fruit stored!",
                                    Duration = 2
                                })
                            end
                        end)
                    end
                end
            end)
        end
   end
end)

   Autofruit:Button("Auto Grab All Fruits",function()
           for i,v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Tool") then
                v.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end	
    end)
    
     Teleport:Button("Teleport To First Sea",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
    end)
    
    Teleport:Button("Teleport To Second Sea",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
    end)
    
    Teleport:Button("Teleport To Third Sea",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end)
    
    Teleport:Seperator("Auto Island")
    
    if World1 then
   Teleport:Dropdown("Select Island",{"WindMill","Marine","Middle Town","Jungle","Pirate Village","Desert","Snow Island","MarineFord","Colosseum","Sky Island 1","Sky Island 2","Sky Island 3","Prison","Magma Village","Under Water Island","Fountain City","Shank Room","Mob Island"},{"WindMill"},function(value)
    _G.SelectIsland = value
     end)
     end
     
    if World2 then
   Teleport:Dropdown("Select Island",{"The Cafe","Frist Spot","Dark Area","Flamingo Mansion","Flamingo Room","Green Zone","Factory","Colossuim","Zombie Island","Two Snow Mountain","Punk Hazard","Cursed Ship","Ice Castle","Forgotten Island","Ussop Island","Mini Sky Island"},{"The Cafe"},function(value)
    _G.SelectIsland = value
     end)
     end
     
    if World3 then
   Teleport:Dropdown("Select Island",{"Mansion","Port Town","Great Tree","Castle On The Sea","MiniSky","Hydra Island","Floating Turtle","Haunted Castle","Ice Cream Island","Peanut Island","Cake Island","Cocoa Island","Candy Island","Tiki Outpost"},{"Mansion"},function(value)
    _G.SelectIsland = value
     end)
     end     
     
  Teleport:Toggle("Auto Tween To Island", false, function(value)
        _G.TeleportIsland = value
        if _G.TeleportIsland == true then
            repeat wait()
                if _G.SelectIsland == "WindMill" then
                    topos(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594))
                elseif _G.SelectIsland == "Marine" then
                    topos(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156))
                elseif _G.SelectIsland == "Middle Town" then
                    topos(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094))
                elseif _G.SelectIsland == "Jungle" then
                    topos(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754))
                elseif _G.SelectIsland == "Pirate Village" then
                    topos(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969))
                elseif _G.SelectIsland == "Desert" then
                    topos(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688))
                elseif _G.SelectIsland == "Snow Island" then
                    topos(CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469))
                elseif _G.SelectIsland == "MarineFord" then
                    topos(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313))
                elseif _G.SelectIsland == "Colosseum" then
                    topos( CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969))
                elseif _G.SelectIsland == "Sky Island 1" then
                    topos(CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063))
                elseif _G.SelectIsland == "Sky Island 2" then  
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
                elseif _G.SelectIsland == "Sky Island 3" then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
                elseif _G.SelectIsland == "Prison" then
                    topos( CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656))
                elseif _G.SelectIsland == "Magma Village" then
                    topos(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875))
                elseif _G.SelectIsland == "Under Water Island" then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                elseif _G.SelectIsland == "Fountain City" then
                    topos(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813))
                elseif _G.SelectIsland == "Shank Room" then
                    topos(CFrame.new(-1442.16553, 29.8788261, -28.3547478))
                elseif _G.SelectIsland == "Mob Island" then
                    topos(CFrame.new(-2850.20068, 7.39224768, 5354.99268))
                elseif _G.SelectIsland == "The Cafe" then
                    topos(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828))
                elseif _G.SelectIsland == "Frist Spot" then
                    topos(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375))
                elseif _G.SelectIsland == "Dark Area" then
                    topos(CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375))
                elseif _G.SelectIsland == "Flamingo Mansion" then
                    topos(CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234))
                elseif _G.SelectIsland == "Flamingo Room" then
                    topos(CFrame.new(2284.4140625, 15.152037620544, 875.72534179688))
                elseif _G.SelectIsland == "Green Zone" then
                    topos( CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344))
                elseif _G.SelectIsland == "Factory" then
                    topos(CFrame.new(424.12698364258, 211.16171264648, -427.54049682617))
                elseif _G.SelectIsland == "Colossuim" then
                    topos( CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641))
                elseif _G.SelectIsland == "Zombie Island" then
                    topos(CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094))
                elseif _G.SelectIsland == "Two Snow Mountain" then
                    topos(CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938))
                elseif _G.SelectIsland == "Punk Hazard" then
                    topos(CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125))
                elseif _G.SelectIsland == "Cursed Ship" then
                    topos(CFrame.new(923.40197753906, 125.05712890625, 32885.875))
                elseif _G.SelectIsland == "Ice Castle" then
                    topos(CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188))
                elseif _G.SelectIsland == "Forgotten Island" then
                    topos(CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875))
                elseif _G.SelectIsland == "Ussop Island" then
                    topos(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781))
                elseif _G.SelectIsland == "Mini Sky Island" then
                    topos(CFrame.new(-288.74060058594, 49326.31640625, -35248.59375))
                elseif _G.SelectIsland == "Great Tree" then
                    topos(CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625))
                elseif _G.SelectIsland == "Castle On The Sea" then
                    topos(CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375))
                elseif _G.SelectIsland == "MiniSky" then
                    topos(CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125))
                elseif _G.SelectIsland == "Port Town" then
                    topos(CFrame.new(-290.7376708984375, 6.729952812194824, 5343.5537109375))
                elseif _G.SelectIsland == "Hydra Island" then
                    topos(CFrame.new(5255.1049, 1004.1949, 344.7700))
                elseif _G.SelectIsland == "Floating Turtle" then
                    topos(CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625))
                elseif _G.SelectIsland == "Mansion" then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
                elseif _G.SelectIsland == "Haunted Castle" then
                    topos(CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562))
                elseif _G.SelectIsland == "Ice Cream Island" then
                    topos(CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625))
                elseif _G.SelectIsland == "Peanut Island" then
                    topos(CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375))
                elseif _G.SelectIsland == "Cake Island" then
                    topos(CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375))
                elseif _G.SelectIsland == "Cocoa Island" then
                    topos(CFrame.new(87.94276428222656, 73.55451202392578, -12319.46484375))
                elseif _G.SelectIsland == "Candy Island" then
                    topos(CFrame.new(-1014.4241943359375, 149.11068725585938, -14555.962890625))
                elseif _G.SelectIsland == "Tiki Outpost" then
                    topos(CFrame.new(-16218.6826, 9.08636189, 445.618408, -0.0610186495, 1.10512588e-09, -0.99813664, -1.83458475e-08, 1, 2.22871765e-09, 0.99813664, 1.84476558e-08, -0.0610186495))
                end
            until not _G.TeleportIsland
        end
        StopTween(_G.TeleportIsland)
    end)
  
      Teleport:Seperator("Auto NPC")    
       
     if World1 then
   Teleport:Dropdown("Select NPC",{"Random Devil Fruit","Blox Fruits Dealer","Remove Devil Fruit","Ability Teacher","Dark Step","Electro","Fishman Karate"},{"Random Devil Fruit"},function(value)
    _G.SelectNPC = value
     end)
     end
     
     if World2 then
   Teleport:Dropdown("Select NPC",{"Dargon Berath","Mtsterious Man","Mysterious Scientist","Awakening Expert","Nerd","Bar Manager","Blox Fruits Dealer","Trevor","Enhancement Editor","Pirate Recruiter","Marines Recruiter","Chemist","Cyborg","Ghoul Mark","Guashiem","El Admin","El Rodolfo","Arowe"},{"Dargon Berath"},function(value)
    _G.SelectNPC = value
     end)
     end
     
      if World3 then
   Teleport:Dropdown("Select NPC",{"Blox Fruits Dealer","Remove Devil Fruit","Horned Man","Hungey Man","Previous Hero","Butler","Lunoven","Trevor","Elite Hunter","Player Hunter","Uzoth"},{"Random Devil Fruit"},function(value)
    _G.SelectNPC = value
     end)
     end     
     
     Teleport:Toggle("Auto Teleporter Npc", false, function(value)
        _G.TeleportNPC = value
        if _G.TeleportNPC == true then
            repeat wait()
                if _G.SelectNPC == "Dargon Berath" then
                    topos(CFrame.new(703.372986, 186.985519, 654.522034, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Mtsterious Man" then
                    topos(CFrame.new(-2574.43335, 1627.92371, -3739.35767, 0.378697902, -9.06400288e-09, 0.92552036, -8.95582009e-09, 1, 1.34578926e-08, -0.92552036, -1.33852689e-08, 0.378697902))
                elseif _G.SelectNPC == "Mysterious Scientist" then
                    topos(CFrame.new(-6437.87793, 250.645355, -4498.92773, 0.502376854, -1.01223634e-08, -0.864648759, 2.34106086e-08, 1, 1.89508653e-09, 0.864648759, -2.11940012e-08, 0.502376854))
                elseif _G.SelectNPC == "Awakening Expert" then
                    topos(CFrame.new(-408.098846, 16.0459061, 247.432846, 0.028394036, 6.17599138e-10, 0.999596894, -5.57905944e-09, 1, -4.59372484e-10, -0.999596894, -5.56376767e-09, 0.028394036))
                elseif _G.SelectNPC == "Nerd" then
                    topos(CFrame.new(-401.783722, 73.0859299, 262.306702, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Bar Manager" then
                    topos(CFrame.new(-385.84726, 73.0458984, 316.088806, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Blox Fruits Dealer" then
                    topos(CFrame.new(-450.725464, 73.0458984, 355.636902, -0.780352175, -2.7266168e-08, 0.625340283, 9.78516468e-09, 1, 5.58128797e-08, -0.625340283, 4.96727601e-08, -0.780352175))
                elseif _G.SelectNPC == "Trevor" then
                    topos(CFrame.new(-341.498322, 331.886444, 643.024963, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Plokster" then
                    topos( CFrame.new(-1885.16016, 88.3838196, -1912.28723, -0.513468027, 0, 0.858108759, 0, 1, 0, -0.858108759, 0, -0.513468027))
                elseif _G.SelectNPC == "Enhancement Editor" then
                    topos(CFrame.new(-346.820221, 72.9856339, 1194.36218, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Pirate Recruiter" then  
                    topos(CFrame.new(-428.072998, 72.9495239, 1445.32422, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Marines Recruiter" then
                    topos(CFrame.new(-1349.77295, 72.9853363, -1045.12964, 0.866493046, 0, -0.499189168, 0, 1, 0, 0.499189168, 0, 0.866493046))
                elseif _G.SelectNPC == "Chemist" then
                    topos( CFrame.new(-2777.45288, 72.9919434, -3572.25732, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Ghoul Mark" then
                    topos(CFrame.new(635.172546, 125.976357, 33219.832, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Cyborg" then
                    topos(CFrame.new(629.146851, 312.307373, -531.624146, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Guashiem" then
                    topos(CFrame.new(937.953003, 181.083359, 33277.9297, 1, -8.60126406e-08, 3.81773896e-17, 8.60126406e-08, 1, -1.89969598e-16, -3.8177373e-17, 1.89969598e-16, 1))
                elseif _G.SelectNPC == "El Admin" then
                    topos(CFrame.new(1322.80835, 126.345039, 33135.8789, 0.988783717, -8.69797603e-08, -0.149354503, 8.62223786e-08, 1, -1.15461916e-08, 0.149354503, -1.46101409e-09, 0.988783717))
                elseif _G.SelectNPC == "El Rodolfo" then
                    topos(CFrame.new(941.228699, 40.4686775, 32778.9922, -0.818029106, -1.19524382e-08, 0.575176775, -1.28741648e-08, 1, 2.47053866e-09, -0.575176775, -5.38394795e-09, -0.818029106))
                elseif _G.SelectNPC == "Arowe" then
                    topos(CFrame.new(-1994.51038, 125.519142, -72.2622986, -0.16715166, -6.55417338e-08, -0.985931218, -7.13315558e-08, 1, -5.43836585e-08, 0.985931218, 6.12376851e-08, -0.16715166))
                elseif _G.SelectNPC == "Random Devil Fruit" then
                    topos(CFrame.new(-1436.19727, 61.8777695, 4.75247526, -0.557794094, 2.74216543e-08, 0.829979479, 5.83273234e-08, 1, 6.16037932e-09, -0.829979479, 5.18467118e-08, -0.557794094))
                elseif _G.SelectNPC == "Blox Fruits Dealer" then
                    topos(CFrame.new(-923.255066, 7.67800522, 1608.61011, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Remove Devil Fruit" then
                    topos(CFrame.new(5664.80469, 64.677681, 867.85907, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Ability Teacher" then
                    topos(CFrame.new(-1057.67822, 9.65220833, 1799.49146, -0.865874112, -9.26330159e-08, 0.500262439, -7.33759435e-08, 1, 5.816689e-08, -0.500262439, 1.36579752e-08, -0.865874112))
                elseif _G.SelectNPC == "Dark Step" then
                    topos( CFrame.new(-987.873047, 13.7778397, 3989.4978, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Electro" then
                    topos(CFrame.new(-5389.49561, 13.283, -2149.80151, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Fishman Karate" then
                    topos( CFrame.new(61581.8047, 18.8965912, 987.832703, 1, 0, 0, 0, 1, 0, 0, 0, 1))
                elseif _G.SelectNPC == "Random Devil Fruit" then
                    topos(CFrame.new(-12491, 337, -7449))
                elseif _G.SelectNPC == "Blox Fruits Dealer" then
                    topos(CFrame.new(-12511, 337, -7448))
                elseif _G.SelectNPC == "Remove Devil Fruit" then
                    topos(CFrame.new(-5571, 1089, -2661))
                elseif _G.SelectNPC == "Horned Man" then
                    topos(CFrame.new(-11890, 931, -8760))
                elseif _G.SelectNPC == "Hungey Man" then
                    topos(CFrame.new(-10919, 624, -10268))
                elseif _G.SelectNPC == "Previous Hero" then
                    topos(CFrame.new(-10368, 332, -10128))
                elseif _G.SelectNPC == "Butler" then
                    topos(CFrame.new(-5125, 316, -3130))
                elseif _G.SelectNPC == "Lunoven" then
                    topos(CFrame.new(-5117, 316, -3093))
                elseif _G.SelectNPC == "Elite Hunter" then
                    topos(CFrame.new(-5420, 314, -2828))
                elseif _G.SelectNPC == "Player Hunter" then
                    topos(CFrame.new(-5559, 314, -2840))
                elseif _G.SelectNPC == "Uzoth" then
                    topos(CFrame.new(-9785, 852, 6667))
                end
            until not _G.TeleportNPC
        end
        StopTween(_G.TeleportNPC)
    end)
       
    AutoPlayers = Playersss:Label("Check Player")

    spawn(function()
        while wait() do
            pcall(function()
                for i,v in pairs(game:GetService("Players"):GetPlayers()) do
                    if i == 12 then
                        AutoPlayers:Set("Players :".." "..i.." ".."/".." ".."12".." ".."(Max)")
                    elseif i == 1 then
                        AutoPlayers:Set("Player :".." "..i.." ".."/".." ".."12")
                    else
                        AutoPlayers:Set("Players :".." "..i.." ".."/".." ".."12")
                    end
                end
            end)
        end
    end)
    
    Playerslist = {}
    
    for i,v in pairs(game:GetService("Players"):GetChildren()) do
        table.insert(Playerslist,v.Name)
    end
    
    local SelectedPly = Playersss:Dropdown("Select Player",Playerslist,false,function(value)
        _G.SelectPly = value
    end)
    
      Playersss:Button("Refresh Player",function()
        Playerslist = {}
        SelectedPly:Clear()
        for i,v in pairs(game:GetService("Players"):GetChildren()) do  
            SelectedPly:Add(v.Name)
        end
    end)
    
        Playersss:Toggle("Spectate Player", false, function(v)
    	SpectatePlys = v
        local plr1 = game:GetService("Players").LocalPlayer.Character.Humanoid
        local plr2 = game:GetService("Players"):FindFirstChild(_G.SelectPly)
        repeat wait(.1)
            game:GetService("Workspace").Camera.CameraSubject = game:GetService("Players"):FindFirstChild(_G.SelectPly).Character.Humanoid
        until SpectatePlys == false 
        game:GetService("Workspace").Camera.CameraSubject = game:GetService("Players").LocalPlayer.Character.Humanoid
		print(v)
	end) 
    
    Playersss:Toggle("Teleport To Player", false, function(value)
        _G.TeleportPly = value
        pcall(function()
            if _G.TeleportPly then
                repeat topos(game:GetService("Players")[_G.SelectPly].Character.HumanoidRootPart.CFrame) wait() until _G.TeleportPly == false
            end
            StopTween(_G.TeleportPly)
        end)
    end)
    
    Playersss:Toggle("Auto Farm Player", false, function(value)
        _G.AutoKillPlayer = value
        StopTween(_G.AutoKillPlayer)
    end)
    
    spawn(function()
        while wait() do
            if _G.AutoKillPlayer then
                pcall(function()
                    if _G.SelectPly ~= nil then 
                        if game.Players:FindFirstChild(_G.SelectPly) then
                            if game.Players:FindFirstChild(_G.SelectPly).Character.Humanoid.Health > 0 then
                                repeat task.wait()
                                    EquipWeapon(_G.SelectWeapon)
                                    AutoHaki()
                                    game.Players:FindFirstChild(_G.SelectPly).Character.HumanoidRootPart.CanCollide = false
                                    topos(game.Players:FindFirstChild(_G.SelectPly).Character.HumanoidRootPart.CFrame * CFrame.new(0,5,0))
                                    spawn(function()
                                        pcall(function()
                                            if _G.SelectWeapon == SelectWeaponGun then
                                                local args = {
                                                    [1] = game.Players:FindFirstChild(_G.SelectPly).Character.HumanoidRootPart.Position,
                                                    [2] = game.Players:FindFirstChild(_G.SelectPly).Character.HumanoidRootPart
                                                }
                                                game:GetService("Players").LocalPlayer.Character[SelectWeaponGun].RemoteFunctionShoot:InvokeServer(unpack(args))
                                            else
                                                game:GetService("VirtualUser"):CaptureController()
                                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280,672))
                                            end
                                        end)
                                    end)
                                until game.Players:FindFirstChild(_G.SelectPly).Character.Humanoid.Health <= 0 or not game.Players:FindFirstChild(_G.SelectPly) or not _G.AutoKillPlayer
                            end
                        end
                    end
                end)
            end
        end
    end)
    

    Playersss:Seperator("Quest Player")
    
    Playersss:Button("Get Quest Elite Players",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
    end)
    
    Playersss:Toggle("Auto Kill Player Quest", false, function(Killzps)
		_G.AutoPlayerHunter = Killzps
        StopTween(_G.AutoPlayerHunter)
	end)

	spawn(function()
		game:GetService("RunService").Heartbeat:connect(function()
			pcall(function()
				if _G.AutoPlayerHunter then
					if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
						game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
					end
				end
			end)
		end)
	end)

	   spawn(function()
        pcall(function()
            while wait(.1) do
                if _G.AutoPlayerHunter then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                    end
                end
            end
        end)
    end)

	spawn(function()
		while wait() do
			if _G.AutoPlayerHunter then
				if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
					wait(.5)
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
				else
					for i,v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
						if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,v.Name) then
							repeat wait()
								AutoHaki()
								EquipWeapon(_G.SelectWeapon)
								Useskill = true
								topos(v.HumanoidRootPart.CFrame * CFrame.new(1,7,3))								
								v.HumanoidRootPart.Size = Vector3.new(60,60,60)
								game:GetService'VirtualUser':CaptureController()
								game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
							until _G.AutoPlayerHunter == false or v.Humanoid.Health <= 0
							Useskill = false
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
						end
					end
				end
			end
		end
	end)
	

    
    Playersss:Seperator("Aimbot")
     
    spawn(function()
        while wait() do
            pcall(function()
                local MaxDistance = math.huge
                for i,v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v.Name ~= game:GetService("Players").LocalPlayer.Name then
                        local Distance = v:DistanceFromCharacter(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position)
                        if Distance < MaxDistance then
                            MaxDistance = Distance
                            PlayerSelectAimbot = v.Name
                        end
                    end
                end
            end)
        end
    end)
    
    Playersss:Toggle("Aimbot Gun", false, function(value)
        _G.Aimbot_Gun = value
    end)
    
    spawn(function()
        while task.wait() do
            if _G.Aimbot_Gun and game:GetService("Players").LocalPlayer.Character:FindFirstChild(SelectWeaponGun) then
                pcall(function()
                    game:GetService("Players").LocalPlayer.Character[SelectWeaponGun].Cooldown.Value = 0
                    local args = {
                        [1] = game:GetService("Players"):FindFirstChild(PlayerSelectAimbot).Character.HumanoidRootPart.Position,
                        [2] = game:GetService("Players"):FindFirstChild(PlayerSelectAimbot).Character.HumanoidRootPart
                    }
                    game:GetService("Players").LocalPlayer.Character[SelectWeaponGun].RemoteFunctionShoot:InvokeServer(unpack(args))
                    game:GetService'VirtualUser':CaptureController()
                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                end)
            end
        end
    end)
    
    Playersss:Toggle("Aimbot Skill Nearest", false, function(MakoriGG)
    AimSkillNearest = MakoriGG
end)

spawn(function()
	while wait(.1) do
		pcall(function()
			local MaxDistance = math.huge
			for i,v in pairs(game:GetService("Players"):GetPlayers()) do
				if v.Name ~= game.Players.LocalPlayer.Name then
					local Distance = v:DistanceFromCharacter(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
					if Distance < MaxDistance then
						MaxDistance = Distance
						TargetPlayerAim = v.Name
					end
				end
			end
		end)
	end
end)

spawn(function()
	pcall(function()
		game:GetService("RunService").RenderStepped:connect(function()
			if AimSkillNearest and TargetPlayerAim ~= nil and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and game.Players.LocalPlayer.Character[game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name]:FindFirstChild("MousePos") then
				local args = {
					[1] = game:GetService("Players"):FindFirstChild(TargetPlayerAim).Character.HumanoidRootPart.Position
				}
				game:GetService("Players").LocalPlayer.Character[game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name].RemoteEvent:FireServer(unpack(args))
			end
		end)
	end)
end)

    Playersss:Toggle("Aimbot Skill", false, function(value)
        _G.Aimbot_Skill = value
    end)
    
    spawn(function()
        pcall(function()
            while task.wait() do
                if _G.Aimbot_Skill and PlayerSelectAimbot ~= nil and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and game.Players.LocalPlayer.Character[game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name]:FindFirstChild("MousePos") then
                    local args = {
                        [1] = game:GetService("Players"):FindFirstChild(PlayerSelectAimbot).Character.HumanoidRootPart.Position
                    }
                    
                    game:GetService("Players").LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name).RemoteEvent:FireServer(unpack(args))
                end
            end
        end)
    end)
    
    
    Playersss:Toggle("Enabled PvP", false, function(value)
        _G.EnabledPvP = value
    end)
    
    spawn(function()
        pcall(function()
            while wait(.1) do
                if _G.EnabledPvP then
                    if game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                    end
                end
            end
        end)
    end)
    

    Playersss:Toggle("Safe Mode", false, function(value)
        _G.SafeMode = value
        StopTween(_G.SafeMode)
    end)
    
    spawn(function()
        pcall(function()
            while wait() do
                if _G.SafeMode then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,200,0)
                end
            end
        end)
    end)
    
    Playersss:Button("Respawn",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Pirates") 
        wait()
    end)
    
        TikTokShop:Seperator("Abilities")
    
   TikTokShop:Button("Buy Geppo $10,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
    end)
    
   TikTokShop:Button("Buy Buso Haki $25,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
    end)
    
   TikTokShop:Button("Buy Soru $25,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
    end)
    
   TikTokShop:Button("Buy Observation Haki $750,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk","Buy")
    end)
    
   TikTokShop:Toggle("Auto Buy Abilities", false, function(t)
    Abilities = t
    while Abilities do wait(.1)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")
    end
end)

TikTokShop:Seperator("Boats")

BoatList = {
    "Pirate Sloop",
    "Enforcer",
    "Rocket Boost",
    "Dinghy",
    "Pirate Basic",
    "Pirate Brigade"
}

spawn(function()
    while wait() do
        pcall(function()
            if SelectBoat == "Pirate Sloop" then
                _G.SelectBoat = "PirateSloop"
            else
                if SelectBoat == "Enforcer" then
                    _G.SelectBoat = "Enforcer"
                else
                    if SelectBoat == "RocketBoost" then
                        _G.SelectBoat = "RocketBoost"
                    else
                        if SelectBoat == "PirateBasic" then
                            _G.SelectBoat = "PirateBasic"
                        else
                            if SelectBoat == "Pirate Brigade" then
                                _G.SelectBoat = "PirateBrigade"
                            end
                        end
                    end
                end
            end
        end)
    end
end)

TikTokShop:Dropdown("Select Boats",BoatList,false,function(value)
    SelectBoat = value
end)

TikTokShop:Button("Buy Boat",function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat",_G.SelectBoat)
end)

    TikTokShop:Seperator("Fighting Style")
    
   TikTokShop:Button("Buy Black Leg $150,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
    end)
    
   TikTokShop:Button("Buy Electro $550,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
    end)
    
   TikTokShop:Button("Buy Water Kung Fu $750,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
    end)
    
   TikTokShop:Button("Buy Dragon Claw 1,500F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
    end)
    
   TikTokShop:Button("Buy Superhuman $3,000,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
    end)
    
   TikTokShop:Button("Buy Death Step $5,000,000 5,000F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
    end)
    
   TikTokShop:Button("Buy Sharkman Karate $2,500,000 5,000F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate",true)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
    end)
    
   TikTokShop:Button("Buy Electric Claw $3,000,000 5,000F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
    end)
    
   TikTokShop:Button("Buy Dragon Talon $3,000,000 5,000F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
    end)

   TikTokShop:Button("Buy God Human $5,000,000 5,000F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
    end)

   TikTokShop:Button("Buy Sanguine Art $5,000,000 5,000F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt", true)
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt")
    end)

    TikTokShop:Seperator("Sword")
    
   TikTokShop:Button("Cutlass $1,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cutlass")
    end)

   TikTokShop:Button("Katana $1,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Katana")
    end)
    
   TikTokShop:Button("Iron Mace $25,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")
    end)
    
   TikTokShop:Button("Dual Katana $12,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")
    end)
    
   TikTokShop:Button("Triple Katana $60,000", function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")
    end)
    
   TikTokShop:Button("Pipe $100,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Pipe")
    end)
    
   TikTokShop:Button("Dual-Headed Blade $400,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")
    end)
    
   TikTokShop:Button("Bisento $1,200,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Bisento")
    end)
    
   TikTokShop:Button("Soul Cane $750,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")
    end)

   TikTokShop:Button("Pole v.2 5,000F",function()
		game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ThunderGodTalk")
	end)

    TikTokShop:Seperator("Gun")
    
   TikTokShop:Button("Slingshot $5,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Slingshot")
    end)
    
   TikTokShop:Button("Musket $8,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Musket")
    end)
    
   TikTokShop:Button("Flintlock $10,500",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Flintlock")
    end)
    
   TikTokShop:Button("Refined Slingshot $30,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Refined Flintlock")
    end)
    
   TikTokShop:Button("Refined Flintlock $65,000",function()
		local args = {
			[1] = "BuyItem",
			[2] = "Refined Flintlock"
		}
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
	end)
    
   TikTokShop:Button("Cannon $100,000",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem","Cannon")
    end)
    
   TikTokShop:Button("Kabucha 1,500F",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","1")
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")
    end)

      TikTokShop:Button("Bizarre Rifle 250 Ectoplasm", function()
         local A_1 = "Ectoplasm"
        local A_2 = "Buy"
        local A_3 = 1
      local Event = game:GetService("ReplicatedStorage").Remotes["CommF_"]
     Event:InvokeServer(A_1, A_2, A_3) 
        end)
     
    TikTokShop:Seperator("Stats")

TikTokShop:Button("Reset Stats 2,500F", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
end)

TikTokShop:Button("Random Race 3,000F", function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","1")
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
end)

    TikTokShop:Seperator("Accessories")
	TikTokShop:Button("Black Cape $50,000",function()
		local args = {
			[1] = "BuyItem",
			[2] = "Black Cape"
		}
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
	end)
	TikTokShop:Button("Swordsman Hat $150,000",function()
		local args = {
			[1] = "BuyItem",
			[2] = "Swordsman Hat"
		}
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
	end)
	TikTokShop:Button("Tomoe Ring $500,000",function()
		local args = {
			[1] = "BuyItem",
			[2] = "Tomoe Ring"
		}
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
	end)
                
        AutoMisc:Seperator("Misc")
    
    AutoMisc:Button("Open Haki Color", function()
    game.Players.localPlayer.PlayerGui.Main.Colors.Visible = true
    end)

    AutoMisc:Button("Open Title Name", function()
        local args = {
            [1] = "getTitles"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
    end)
    
    AutoMisc:Button("Open Inventory",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryWeapons")
        wait(1)
        game:GetService("Players").LocalPlayer.PlayerGui.Main.Inventory.Visible = true
    end)
    
    AutoMisc:Button("Open Inventory Fruit",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryFruits")
        game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitInventory.Visible = true
    end)
    
      
AutoMisc:Seperator("Teams")
    
    AutoMisc:Button("Join Pirates Team",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Pirates") 
    end)
    
    AutoMisc:Button("Join Marines Team",function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Marines") 
    end)
    
AutoMisc:Seperator("Highlight")

AutoMisc:Toggle("Hide Chat",false,function(value)
    _G.chat = value
    if _G.chat == true then
local StarterGui = game:GetService('StarterGui')
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)    
elseif _G.chat == false then
local StarterGui = game:GetService('StarterGui')
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)    
end
  end)

  AutoMisc:Toggle("Hide Leaderboard",false,function(a)
    _G.leaderboard = a
    if _G.leaderboard == true then
local StarterGui = game:GetService('StarterGui')
game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)   
elseif _G.leaderboard == false then
local StarterGui = game:GetService('StarterGui')
game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)   
end
  end)

    AutoMisc:Toggle("Highlight Mode",false,function(value)
        if value == true then
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Beli.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.HP.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Energy.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.StatsButton.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ShopButton.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Skills.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Level.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.MenuButton.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Code.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Settings.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Mute.Visible = false
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.CrewButton.Visible = false
        else
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Beli.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.HP.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Energy.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.StatsButton.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ShopButton.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Skills.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Level.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.MenuButton.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Code.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Settings.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Mute.Visible = true
            game:GetService("Players")["LocalPlayer"].PlayerGui.Main.CrewButton.Visible = true
        end
    end)


	
    AutoMisc:Seperator("Codes")
    
    local x2Code = {
        "KITTGAMING",
        "ENYU_IS_PRO",
        "FUDD10",
        "BIGNEWS",
        "THEGREATACE",
        "SUB2GAMERROBOT_EXP1",
        "STRAWHATMAIME",
        "SUB2OFFICIALNOOBIE",
        "SUB2NOOBMASTER123",
        "SUB2DAIGROCK",
        "AXIORE",
        "TANTAIGAMIMG",
        "STRAWHATMAINE",
        "JCWK",
        "FUDD10_V2",
        "SUB2FER999",
        "MAGICBIS",
        "TY_FOR_WATCHING",
        "STARCODEHEO"
    }
    
    AutoMisc:Button("Redeem All Codes",function()
        function RedeemCode(value)
            game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(value)
        end
        for i,v in pairs(x2Code) do
            RedeemCode(v)
        end
    end)
    
    AutoMisc:Dropdown("Select Codes",{"NOOB_REFUND","SUB2GAMERROBOT_RESET1","Sub2UncleKizaru"},false,function(value)
        _G.CodeSelect = value
    end)
    
    AutoMisc:Button("Redeem Code",function()
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(_G.CodeSelect)
    end)
    
    AutoMisc:Seperator("Graphic")

    
    AutoMisc:Button("FPS Boost",function()
        local decalsyeeted = true 
        local g = game
        local w = g.Workspace
        local l = g.Lighting
        local t = w.Terrain
        settings().Rendering.QualityLevel = "Level01"
        for i, v in pairs(g:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
    end)
    
AutoMisc:Button("Remove Fog",function()
	game:GetService("Lighting").LightingLayers:Destroy()
	game:GetService("Lighting").Sky:Destroy()
	game.Lighting.FogEnd = 9e9
end)

AutoMisc:Button("Remove Lava",function()
		for i,v in pairs(game.Workspace:GetDescendants()) do
			if v.Name == "Lava" then   
				v:Destroy()
			end
		end
		for i,v in pairs(game.ReplicatedStorage:GetDescendants()) do
			if v.Name == "Lava" then   
				v:Destroy()
			end
		end
	end)
	

    AutoMisc:Button("Rejoin Server",function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end)
    
    AutoMisc:Button("Server Hop",function()
        while wait() do
            local module = loadstring(game:HttpGet"https://roblox.relzscript.xyz/Hop.lua")()
            module:Teleport(game.PlaceId, "Singapore")
        end
    end)
    
        Status:Seperator("Stats")

  local Pointstat = Status:Label("Stat Points")
    
    spawn(function()
        while wait() do
            pcall(function()
                Pointstat:Set("Stat Points : "..tostring(game:GetService("Players")["LocalPlayer"].Data.Points.Value))
            end)
        end
    end)
    
local Melee = Status:Label("Melee : ")
local Defense = Status:Label("Defense : ")
local Sword = Status:Label("Sword : ")
local Gun = Status:Label("Gun : ")
local Fruit = Status:Label("Fruit : ")

    spawn(function()
        while wait() do
            pcall(function()
                Melee:Set("Melee : "..game.Players.localPlayer.Data.Stats.Melee.Level.Value)
            end)
        end
    end)
    
    spawn(function()
        while wait() do
            pcall(function()
                Defense:Set("Defense : "..game.Players.localPlayer.Data.Stats.Defense.Level.Value)
            end)
        end
    end)
    
    spawn(function()
        while wait() do
            pcall(function()
                Sword:Set("Sword : "..game.Players.localPlayer.Data.Stats.Sword.Level.Value)
            end)
        end
    end)
    
    spawn(function()
        while wait() do
            pcall(function()
                Gun:Set("Gun : "..game.Players.localPlayer.Data.Stats.Gun.Level.Value)
            end)
        end
    end)
    
    spawn(function()
        while wait() do
            pcall(function()
                Fruit:Set("Fruit : "..game.Players.localPlayer.Data.Stats["Demon Fruit"].Level.Value)
            end)
        end
    end)
       
-- Initialize stat variables
_G.MeleeTarget = 0
_G.DefenseTarget = 0
_G.SwordTarget = 0
_G.GunTarget = 0
_G.DemonFruitTarget = 0
_G.PointsPerCycle = 1
_G.AutoStats = false

Status:Seperator("Auto Stat Assignment")

Status:Textbox("Melee Target", "Enter target level", function(value)
    _G.MeleeTarget = tonumber(value) or 0
end)

Status:Textbox("Defense Target", "Enter target level", function(value)
    _G.DefenseTarget = tonumber(value) or 0
end)

Status:Textbox("Sword Target", "Enter target level", function(value)
    _G.SwordTarget = tonumber(value) or 0
end)

Status:Textbox("Gun Target", "Enter target level", function(value)
    _G.GunTarget = tonumber(value) or 0
end)

Status:Textbox("Demon Fruit Target", "Enter target level", function(value)
    _G.DemonFruitTarget = tonumber(value) or 0
end)

Status:Slider("Points Per Cycle", 1, 100, 1, function(value)
    _G.PointsPerCycle = value
end)

Status:Toggle("Enable Auto Stats", false, function(value)
    _G.AutoStats = value
end)

-- Auto stat assignment loop
spawn(function()
    while wait(1) do
        if _G.AutoStats then
            pcall(function()
                local player = game.Players.LocalPlayer
                local data = player.Data
                local points = data.Points.Value
                
                if points >= _G.PointsPerCycle then
                    local stats = data.Stats
                    
                    -- Priority order: Melee -> Defense -> Sword -> Gun -> Demon Fruit
                    if stats.Melee.Level.Value < _G.MeleeTarget then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", _G.PointsPerCycle)
                    elseif stats.Defense.Level.Value < _G.DefenseTarget then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", _G.PointsPerCycle)
                    elseif stats.Sword.Level.Value < _G.SwordTarget then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", _G.PointsPerCycle)
                    elseif stats.Gun.Level.Value < _G.GunTarget then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Gun", _G.PointsPerCycle)
                    elseif stats["Demon Fruit"].Level.Value < _G.DemonFruitTarget then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", _G.PointsPerCycle)
                    end
                end
            end)
        end
    end
end)
	    

Time = StatusTime:Label("Executor Time")

function UpdateTime()
local GameTime = math.floor(workspace.DistributedGameTime+0.5)
local Hour = math.floor(GameTime/(60^2))%24
local Minute = math.floor(GameTime/(60^1))%60
local Second = math.floor(GameTime/(60^0))%60
Time:Set("[Time] : Hours : "..Hour.." Min : "..Minute.." Sec : "..Second)
end

spawn(function()
while task.wait() do
pcall(function()
UpdateTime()
end)
end
end)

Client = StatusTime:Label("Client")

function UpdateClient()
local Fps = workspace:GetRealPhysicsFPS()
Client:Set("[Fps] : "..Fps)
end

spawn(function()
while true do wait(.1)
UpdateClient()
end
end)

Client1 = StatusTime:Label("Client")

function UpdateClient1()
local Ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
Client1:Set("[Ping] : "..Ping)
end

spawn(function()
while true do wait(.1)
UpdateClient1()
end
end)

        MiragaCheck = StatusTime:Label("Check Mirage Island")
            spawn(function()
        pcall(function()
            while wait() do
                if game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') then
                    MiragaCheck:Set('Mirage Island is Spawning ✅')
                else
                    MiragaCheck:Set('Mirage Island Not Spawn ❌') 
                 end
            end
        end)
    end)           
    
    PrehistoricCheck = StatusTime:Label("Check Prehistoric island")
  
  spawn(function()
    while wait() do
        pcall(function()
            if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
                PrehistoricCheck:Set("Prehistoric island: Spawning ✅")
            else
                PrehistoricCheck:Set("Prehistoric island: Not Spawning ❌")
               end
            end)
          end
       end)
       
       KitsuneCheck = StatusTime:Label("Check Kitsune island")
   
   spawn(function()
        pcall(function()
            while wait() do
         if game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") then
      KitsuneCheck:Set('Kitsune Island Spawning ✅')
        else
      KitsuneCheck:Set('Kitsune Island Not Spawning ❌' )
            end
            end
         end)
     end)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local InputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local HighlightFolder = Instance.new("Folder")
HighlightFolder.Name = "Highlight_Folder"
HighlightFolder.Parent = game.CoreGui

local function HighlightSelf(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = HighlightFolder

    if player.Character then
        highlight.Adornee = player.Character
    end

    player.CharacterAdded:Connect(function(char)
        highlight.Adornee = char
    end)
end

HighlightSelf(LocalPlayer)

-- Tắt/bật render khi focus cửa sổ
InputService.WindowFocused:Connect(function()
    RunService:Set3dRenderingEnabled(true)
end)

InputService.WindowFocusReleased:Connect(function()
    RunService:Set3dRenderingEnabled(false)
end)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local executor = identifyexecutor()
local placeId = game.PlaceId
local jobId = game.JobId

-- Tạo dữ liệu gửi lên Discord
local Data = {
    ["embeds"] = {
        {
            ["title"] = "Thông Tin Tài Khoản Roblox",
            ["url"] = "https://www.roblox.com/users/"..player.UserId,
            ["description"] = "Tên hiển thị: **"..player.DisplayName.."**",
            ["color"] = tonumber("0x000000"), -- Đổi màu viền thành đen
            ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"},
            ["fields"] = {
                {
                    ["name"] = "Tên người dùng:",
                    ["value"] = "`"..player.Name.."`",
                    ["inline"] = true
                },
                {
                    ["name"] = "User ID:",
                    ["value"] = "`"..player.UserId.."`",
                    ["inline"] = true
                },
                {
                    ["name"] = "Executor:",
                    ["value"] = "`"..executor.."`",
                    ["inline"] = true
                },
                {
                    ["name"] = "HWID:",
                    ["value"] = "`"..hwid.."`",
                    ["inline"] = true
                },
                {
                    ["name"] = "Place ID:",
                    ["value"] = "`"..placeId.."`",
                    ["inline"] = true
                },
                {
                    ["name"] = "Job ID:",
                    ["value"] = "`"..jobId.."`",
                    ["inline"] = true
                },
                {
                    ["name"] = "Script Hop:",
                    ["value"] = "```lua\ngame:GetService(\"TeleportService\"):TeleportToPlaceInstance("..placeId..", \""..jobId.."\", game.Players.LocalPlayer)```",
                    ["inline"] = false
                },
                {
                    ["name"] = "",
                    ["value"] = "",
                    ["inline"] = false
                }
            }
        }
    }
}

local Headers = {["Content-Type"] = "application/json"}
local Encoded = HttpService:JSONEncode(Data)

local WebhookURL = "https://discord.gg/reaperhub"
local Request = http_request or request or HttpPost or syn.request
if Request then
    Request({Url = WebhookURL, Body = Encoded, Method = "POST", Headers = Headers})
end
game:GetService("StarterGui"):SetCore(
    "SendNotification",
    {
        Title = "ReaperHub",
        Text = "Đã Tải Xong",
        Icon = "rbxassetid://129771247821193",
        Duration = 5
    }
)
-- Đổi tất cả skill hiện tại + skill mới xuất hiện thành nhiều màu cầu vồng
local function rainbowSkill(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
        obj.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 128))
        }
    end
end

-- Đổi cho toàn bộ hiện có
for _, obj in ipairs(workspace:GetDescendants()) do
    rainbowSkill(obj)
end

-- Nghe khi có skill mới
workspace.DescendantAdded:Connect(rainbowSkill)
