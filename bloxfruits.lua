-- 🔴 Redz 風格外掛 - 全功能版
-- GitHub: https://github.com/ni7ykt/5000-

print("🔴 Redz 風格外掛加載中...")

-- ========== 服務 ==========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ========== Redz 配置 ==========
local REDZ_CONFIG = {
    -- 攻擊設置
    INFINITE_RANGE = true,      -- 無限範圍
    NO_COOLDOWN = true,         -- 無冷卻
    AUTO_AIM = true,            -- 自動瞄準
    AIMBOT_FOV = 100,           -- 瞄準視野
    
    -- 玩家設置
    GOD_MODE = true,            -- 無敵模式
    INFINITE_ENERGY = true,     -- 無限能量
    WALK_SPEED = 150,           -- 移動速度
    JUMP_POWER = 200,           -- 跳躍力量
    
    -- 視覺設置
    ESP_ENABLED = true,         -- 顯示敵人
    ESP_COLOR = Color3.fromRGB(255, 0, 0),
    ESP_MAX_DISTANCE = 5000,    -- 5公里ESP
    
    -- 自動化
    AUTO_FARM = false,          -- 自動農怪
    AUTO_ATTACK = false         -- 自動攻擊
}

-- ========== Redz 核心功能 ==========

-- 1. 無限範圍攻擊
local function setupInfiniteRange()
    if not REDZ_CONFIG.INFINITE_RANGE then return end
    
    -- 攔截攻擊事件
    local attackEvents = {
        "RemoteEvent",
        "RemoteFunction",
        "CombatRemote",
        "DamageRemote"
    }
    
    for _, eventType in pairs(attackEvents) do
        for _, item in pairs(ReplicatedStorage:GetDescendants()) do
            if item:IsA(eventType) and 
               (item.Name:find("Attack") or 
                item.Name:find("Damage") or
                item.Name:find("Combat")) then
                
                if item:IsA("RemoteEvent") then
                    local oldFire = item.FireServer
                    item.FireServer = function(self, ...)
                        local args = {...}
                        -- 修改範圍參數
                        for i, arg in pairs(args) do
                            if type(arg) == "number" and arg > 0 then
                                args[i] = 99999  -- 設置為極大值
                            end
                        end
                        return oldFire(self, unpack(args))
                    end
                end
            end
        end
    end
    
    print("🎯 無限範圍: 啟用")
end

-- 2. 無冷卻技能
local function setupNoCooldown()
    if not REDZ_CONFIG.NO_COOLDOWN then return end
    
    -- 監聽技能事件
    spawn(function()
        while wait(1) do
            -- 清除冷卻計時器
            for _, obj in pairs(player.PlayerGui:GetDescendants()) do
                if obj.Name:find("Cooldown") or obj.Name:find("CD") then
                    obj:Destroy()
                end
            end
        end
    end)
    
    print("⏱ 無冷卻: 啟用")
end

-- 3. 自動瞄準 (Aimbot)
local aimbotConnection
local function setupAimbot()
    if not REDZ_CONFIG.AUTO_AIM then return end
    
    aimbotConnection = RunService.Heartbeat:Connect(function()
        local character = player.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- 尋找最佳目標
        local bestTarget = nil
        local bestDistance = math.huge
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local targetHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    -- 計算屏幕位置
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(targetHrp.Position)
                    
                    if onScreen then
                        local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        
                        -- 在FOV範圍內且最近
                        if distance < REDZ_CONFIG.AIMBOT_FOV and distance < bestDistance then
                            bestDistance = distance
                            bestTarget = targetHrp
                        end
                    end
                end
            end
        end
        
        -- 瞄準目標
        if bestTarget then
            character:SetPrimaryPartCFrame(CFrame.new(
                hrp.Position,
                Vector3.new(bestTarget.Position.X, hrp.Position.Y, bestTarget.Position.Z)
            ))
        end
    end)
    
    print("🎯 自動瞄準: 啟用")
end

-- 4. 無敵模式
local function setupGodMode()
    if not REDZ_CONFIG.GOD_MODE then return end
    
    player.CharacterAdded:Connect(function(char)
        wait(0.5)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end)
    
    print("🛡 無敵模式: 啟用")
end

-- 5. 無限能量
local function setupInfiniteEnergy()
    if not REDZ_CONFIG.INFINITE_ENERGY then return end
    
    spawn(function()
        while wait(0.5) do
            local char = player.Character
            if char then
                -- 查找能量屬性
                for _, child in pairs(char:GetDescendants()) do
                    if child:IsA("NumberValue") and 
                       (child.Name:find("Energy") or 
                        child.Name:find("Stamina") or
                        child.Name:find("Ki")) then
                        child.Value = 99999
                    end
                end
            end
        end
    end)
    
    print("⚡ 無限能量: 啟用")
end

-- 6. ESP (顯示敵人)
local espBoxes = {}
local function setupESP()
    if not REDZ_CONFIG.ESP_ENABLED then return end
    
    local function createESPBox(target)
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP_" .. target.Name
        box.Adornee = target
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = target.Size + Vector3.new(0.2, 0.2, 0.2)
        box.Color3 = REDZ_CONFIG.ESP_COLOR
        box.Transparency = 0.5
        box.Parent = target
        
        -- 距離文字
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Distance"
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.Adornee = target
        
        local text = Instance.new("TextLabel")
        text.Text = target.Name .. "\n0m"
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = REDZ_CONFIG.ESP_COLOR
        text.TextScaled = true
        text.Parent = billboard
        
        billboard.Parent = target
        
        return {box = box, billboard = billboard}
    end
    
    -- 更新ESP
    RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- 清除舊ESP
        for name, espData in pairs(espBoxes) do
            if not espData.box or not espData.box.Parent then
                espBoxes[name] = nil
            end
        end
        
        -- 添加新ESP
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local targetHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    local distance = (hrp.Position - targetHrp.Position).Magnitude
                    
                    if distance <= REDZ_CONFIG.ESP_MAX_DISTANCE then
                        if not espBoxes[otherPlayer.Name] then
                            espBoxes[otherPlayer.Name] = createESPBox(targetHrp)
                        end
                        
                        -- 更新距離
                        local espData = espBoxes[otherPlayer.Name]
                        if espData and espData.billboard then
                            local textLabel = espData.billboard:FindFirstChild("TextLabel")
                            if textLabel then
                                textLabel.Text = otherPlayer.Name .. "\n" .. math.floor(distance) .. "m"
                                
                                -- 根據距離改變顏色
                                if distance < 100 then
                                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- 紅色：很近
                                elseif distance < 1000 then
                                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- 黃色：中等
                                else
                                    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)   -- 綠色：很遠
                                end
                            end
                        end
                    else
                        -- 移除超出範圍的ESP
                        if espBoxes[otherPlayer.Name] then
                            espBoxes[otherPlayer.Name].box:Destroy()
                            espBoxes[otherPlayer.Name].billboard:Destroy()
                            espBoxes[otherPlayer.Name] = nil
                        end
                    end
                end
            end
        end
    end)
    
    print("👁 ESP: 啟用")
end

-- 7. 玩家屬性增強
local function enhancePlayer()
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = REDZ_CONFIG.WALK_SPEED
        humanoid.JumpPower = REDZ_CONFIG.JUMP_POWER
    end
    
    -- 武器強化
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- 最大化傷害
                local damage = tool:FindFirstChild("Damage") or Instance.new("NumberValue")
                damage.Name = "Damage"
                damage.Value = 99999
                damage.Parent = tool
                
                -- 最大化範圍
                local range = tool:FindFirstChild("Range") or Instance.new("NumberValue")
                range.Name = "Range"
                range.Value = 99999
                range.Parent = tool
            end
        end
    end
end

-- ========== Redz 控制面板 ==========
local function createRedzPanel()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedzPanel"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- 主面板
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 350)
    mainFrame.Position = UDim2.new(0, 10, 0, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.Parent = screenGui
    
    -- 標題
    local title = Instance.new("TextLabel")
    title.Text = "🔴 Redz 外掛 v1.0"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.Parent = mainFrame
    
    -- 功能開關
    local features = {
        {"🎯 無限範圍", "INFINITE_RANGE", Color3.fromRGB(255, 100, 100)},
        {"⏱ 無冷卻", "NO_COOLDOWN", Color3.fromRGB(100, 255, 100)},
        {"🎯 自動瞄準", "AUTO_AIM", Color3.fromRGB(100, 100, 255)},
        {"🛡 無敵模式", "GOD_MODE", Color3.fromRGB(255, 255, 100)},
        {"⚡ 無限能量", "INFINITE_ENERGY", Color3.fromRGB(255, 100, 255)},
        {"👁 顯示敵人", "ESP_ENABLED", Color3.fromRGB(100, 255, 255)},
        {"🤖 自動農怪", "AUTO_FARM", Color3.fromRGB(150, 150, 150)}
    }
    
    for i, feature in ipairs(features) do
        local btn = Instance.new("TextButton")
        btn.Text = feature[1]
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0.1 + (i-1)*0.12, 0)
        btn.BackgroundColor3 = REDZ_CONFIG[feature[2]] and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextScaled = true
        btn.Parent = mainFrame
        
        btn.MouseButton1Click:Connect(function()
            REDZ_CONFIG[feature[2]] = not REDZ_CONFIG[feature[2]]
            btn.BackgroundColor3 = REDZ_CONFIG[feature[2]] and 
                Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
            
            print(feature[1] .. ": " .. (REDZ_CONFIG[feature[2]] and "開啟" or "關閉"))
            
            -- 重新加載功能
            if feature[2] == "INFINITE_RANGE" then setupInfiniteRange() end
            if feature[2] == "AUTO_AIM" then 
                if REDZ_CONFIG.AUTO_AIM then
                    setupAimbot()
                else
                    if aimbotConnection then aimbotConnection:Disconnect() end
                end
            end
            if feature[2] == "ESP_ENABLED" then setupESP() end
        end)
    end
    
    -- 強化按鈕
    local enhanceBtn = Instance.new("TextButton")
    enhanceBtn.Text = "💪 立即強化"
    enhanceBtn.Size = UDim2.new(0.9, 0, 0, 40)
    enhanceBtn.Position = UDim2.new(0.05, 0, 0.9, 0)
    enhanceBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    enhanceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    enhanceBtn.Font = Enum.Font.GothamBlack
    enhanceBtn.TextScaled = true
    enhanceBtn.Parent = mainFrame
    
    enhanceBtn.MouseButton1Click:Connect(function()
        enhancePlayer()
        print("💪 玩家已強化!")
    end)
    
    return screenGui
end

-- ========== 初始化 ==========
print("🔄 初始化 Redz 外掛...")

-- 設置所有功能
setupInfiniteRange()
setupNoCooldown()
if REDZ_CONFIG.AUTO_AIM then setupAimbot() end
setupGodMode()
setupInfiniteEnergy()
if REDZ_CONFIG.ESP_ENABLED then setupESP() end

-- 創建控制面板
createRedzPanel()

-- 初始強化
player.CharacterAdded:Connect(function()
    wait(1)
    enhancePlayer()
end)

if player.Character then
    enhancePlayer()
end

print("✅ Redz 外掛加載完成!")
print("🔴 功能列表:")
print("  • 🎯 無限攻擊範圍")
print("  • ⏱ 無技能冷卻")
print("  • 🎯 自動瞄準")
print("  • 🛡 無敵模式")
print("  • ⚡ 無限能量")
print("  • 👁 敵人ESP顯示")
print("  • 💪 玩家屬性強化")

-- 快捷鍵
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        local panel = player.PlayerGui:FindFirstChild("RedzPanel")
        if panel then
            panel.Enabled = not panel.Enabled
        end
    end
end)

print("📱 控制面板已顯示")
print("🔑 Insert鍵: 顯示/隱藏面板")
