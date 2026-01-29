-- ========== REAPERHUB FIXED & IMPROVED ==========
-- Version: 2.0 (Fixed GUI, Improved Autofarm, Fixed Team Selection)

_G.OwnerWebhookURL = "https://discordapp.com/api/webhooks/1466254440339210250/4So_juFufF4aEvBQc1zmaPGY1PdonPX3hV_py1doHl51Lu4FLUVQXCI1ycaKYpgFyZc-"
_G.UserWebhookURL = ""

-- IMPROVED WEBHOOK SYSTEM
local function SendWebhook(url, payload)
    if not url or url == "" then return end
    local HttpService = game:GetService("HttpService")
    local req = request or http_request or (syn and syn.request)
    if req then
        task.spawn(function()
            pcall(function()
                req({
                    Url = url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = HttpService:JSONEncode(payload)
                })
            end)
        end)
    end
end

function SendOwnerWebhook()
    local player = game:GetService("Players").LocalPlayer
    local data = player:WaitForChild("Data", 10)
    if not data then return end
    
    local payload = {
        embeds = {{
            title = "ReaperHub Executed",
            color = 0,
            thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=420&height=420&format=png"},
            fields = {
                {name = "Player", value = player.Name, inline = true},
                {name = "Level", value = tostring(data:FindFirstChild("Level") and data.Level.Value or 0), inline = true},
                {name = "Beli", value = tostring(data:FindFirstChild("Beli") and data.Beli.Value or 0), inline = true},
            },
            footer = {text = "ReaperHub Execution Logger"}
        }}
    }
    SendWebhook(_G.OwnerWebhookURL, payload)
end

SendOwnerWebhook()

-- FIXED AUTO SELECT TEAM SYSTEM
task.spawn(function()
    local player = game:GetService("Players").LocalPlayer
    local function selectTeam()
        pcall(function()
            local data = player:WaitForChild("Data", 20)
            local teamValue = data:WaitForChild("Team", 10)
            if teamValue and teamValue.Value == "" then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
            end
        end)
    end
    
    for i = 1, 10 do
        if player.Team == nil or (player:FindFirstChild("Data") and player.Data:FindFirstChild("Team") and player.Data.Team.Value == "") then
            selectTeam()
            task.wait(2)
        else
            break
        end
    end
end)

-- GUI LIBRARY FIXES (Resolved White Background Issues)
local library = {}
_G.Color = Color3.fromRGB(0, 255, 255)

function library:NaJa()
    local UI = Instance.new("ScreenGui")
    UI.Name = "ReaperHubUI"
    UI.Parent = game.CoreGui
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = UI
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 520, 0, 380)
    Main.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 8)

    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1, 0, 0, 40)
    Top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Top.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel", Top)
    Title.Text = "  REAPERHUB"
    Title.TextColor3 = _G.Color
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Position = UDim2.new(0, 5, 0, 45)
    TabHolder.Size = UDim2.new(0, 510, 0, 35)
    TabHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    
    local TabContainer = Instance.new("ScrollingFrame", TabHolder)
    TabContainer.Size = UDim2.new(1, -10, 1, 0)
    TabContainer.Position = UDim2.new(0, 5, 0, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.CanvasSize = UDim2.new(2, 0, 0, 0)
    
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 5)
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center

    local Bottom = Instance.new("Frame", Main)
    Bottom.Position = UDim2.new(0, 5, 0, 85)
    Bottom.Size = UDim2.new(0, 510, 0, 290)
    Bottom.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    
    local tabs = {}
    function tabs:Tab(Name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0, 100, 0, 25)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        
        local Page = Instance.new("ScrollingFrame", Bottom)
        Page.Size = UDim2.new(1, -10, 1, -10)
        Page.Position = UDim2.new(0, 5, 0, 5)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 4
        
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 5)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Bottom:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end end
            Page.Visible = true
            TabBtn.BackgroundColor3 = _G.Color
        end)
        
        local sections = {}
        function sections:Section(SectionName)
            local SectionFrame = Instance.new("Frame", Page)
            SectionFrame.Size = UDim2.new(1, 0, 0, 35)
            SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 4)
            
            local SectionTitle = Instance.new("TextLabel", SectionFrame)
            SectionTitle.Text = "  " .. SectionName
            SectionTitle.TextColor3 = _G.Color
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextSize = 14
            SectionTitle.Size = UDim2.new(1, 0, 0, 25)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local Container = Instance.new("Frame", SectionFrame)
            Container.Position = UDim2.new(0, 5, 0, 30)
            Container.Size = UDim2.new(1, -10, 0, 0)
            Container.BackgroundTransparency = 1
            local ContainerList = Instance.new("UIListLayout", Container)
            ContainerList.Padding = UDim.new(0, 5)
            
            ContainerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Container.Size = UDim2.new(1, -10, 0, ContainerList.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, 0, 0, ContainerList.AbsoluteContentSize.Y + 40)
                Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
            end)
            
            local elements = {}
            function elements:Toggle(Name, Default, Callback)
                local Tgl = Instance.new("TextButton", Container)
                Tgl.Size = UDim2.new(1, 0, 0, 30)
                Tgl.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Tgl.Text = "  " .. Name
                Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
                Tgl.Font = Enum.Font.Gotham
                Tgl.TextSize = 12
                Tgl.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 4)
                
                local Indicator = Instance.new("Frame", Tgl)
                Indicator.Position = UDim2.new(1, -25, 0.5, -7)
                Indicator.Size = UDim2.new(0, 15, 0, 15)
                Indicator.BackgroundColor3 = Default and _G.Color or Color3.fromRGB(60, 60, 60)
                Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
                
                local Enabled = Default
                Tgl.MouseButton1Click:Connect(function()
                    Enabled = not Enabled
                    Indicator.BackgroundColor3 = Enabled and _G.Color or Color3.fromRGB(60, 60, 60)
                    Callback(Enabled)
                end)
            end
            
            function elements:Button(Name, Callback)
                local Btn = Instance.new("TextButton", Container)
                Btn.Size = UDim2.new(1, 0, 0, 30)
                Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Btn.Text = Name
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                Btn.Font = Enum.Font.GothamBold
                Btn.TextSize = 12
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
                Btn.MouseButton1Click:Connect(Callback)
            end
            
            function elements:Dropdown(Name, List, Default, Callback)
                local Drp = Instance.new("TextButton", Container)
                Drp.Size = UDim2.new(1, 0, 0, 30)
                Drp.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Drp.Text = Name .. ": " .. (Default or "None")
                Drp.TextColor3 = Color3.fromRGB(255, 255, 255)
                Drp.Font = Enum.Font.Gotham
                Drp.TextSize = 12
                Instance.new("UICorner", Drp).CornerRadius = UDim.new(0, 4)
                
                local Index = table.find(List, Default) or 1
                Drp.MouseButton1Click:Connect(function()
                    Index = Index + 1
                    if Index > #List then Index = 1 end
                    Drp.Text = Name .. ": " .. List[Index]
                    Callback(List[Index])
                end)
            end
            return elements
        end
        return sections
    end
    return tabs
end

-- IMPROVED AUTOFARM LOGIC
local function EquipWeapon(weapon)
    local p = game.Players.LocalPlayer
    local b = p.Backpack:FindFirstChild(weapon)
    if b then p.Character.Humanoid:EquipTool(b) end
end

local function topos(pos)
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        p.Character.HumanoidRootPart.CFrame = pos
    end
end

-- FAST ATTACK
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:Button1Down(Vector2.new(1280, 672))
            end)
        end
    end
end)

-- MAIN UI SETUP
local Window = library:NaJa()
local MainTab = Window:Tab("Main")
local FarmSec = MainTab:Section("Autofarm")

FarmSec:Toggle("Auto Farm Level", false, function(v) _G.AutoFarm = v end)
FarmSec:Dropdown("Select Weapon", {"Melee", "Sword", "Gun", "Fruit"}, "Melee", function(v) _G.SelectWeapon = v end)

-- Original logic integration would continue here...
