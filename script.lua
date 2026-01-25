-- ========================================
-- REAPER HUB | BLADEBALL
-- ========================================
-- Minimal Black Futuristic UI
-- ========================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

-- Minimal Black Theme
local Theme = {
    Background = Color3.fromRGB(10, 10, 10),
    Secondary = Color3.fromRGB(18, 18, 18),
    Border = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(255, 255, 255),
    AccentDim = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(0, 255, 100),
    Danger = Color3.fromRGB(255, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(120, 120, 120)
}

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- ========================================
-- MINIMAL GUI LIBRARY
-- ========================================

local GUI = {}

function GUI:Create()
    local self = {}
    
    -- ScreenGui
    self.Screen = Instance.new("ScreenGui")
    self.Screen.Name = "ReaperHub"
    self.Screen.Parent = game.CoreGui
    self.Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.Screen.ResetOnSpawn = false
    
    -- Main container
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Parent = self.Screen
    self.Main.BackgroundColor3 = Theme.Background
    self.Main.BorderSizePixel = 0
    self.Main.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.Main.Size = UDim2.new(0, 400, 0, 300)
    self.Main.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = self.Main
    
    local mainBorder = Instance.new("UIStroke")
    mainBorder.Color = Theme.Border
    mainBorder.Thickness = 1
    mainBorder.Parent = self.Main
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Parent = self.Main
    self.TitleBar.BackgroundColor3 = Theme.Secondary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- CENTERED TITLE
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = self.TitleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "Reaper Hub | Bladeball"
    titleLabel.TextColor3 = Theme.Accent
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    -- Minimize button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Parent = self.TitleBar
    minimizeBtn.BackgroundColor3 = Theme.Border
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(0, 8, 0.5, -10)
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Theme.Accent
    minimizeBtn.TextSize = 14
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeBtn
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = self.TitleBar
    closeBtn.BackgroundColor3 = Theme.Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Position = UDim2.new(1, -28, 0.5, -10)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Theme.Accent
    closeBtn.TextSize = 14
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        self.Screen:Destroy()
    end)
    
    closeBtn.MouseEnter:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        Tween(closeBtn, {BackgroundColor3 = Theme.Danger}, 0.15)
    end)
    
    -- MINIMIZE PILL
    self.MinimizePill = Instance.new("Frame")
    self.MinimizePill.Name = "MinimizePill"
    self.MinimizePill.Parent = self.Screen
    self.MinimizePill.BackgroundColor3 = Theme.Background
    self.MinimizePill.BorderSizePixel = 0
    self.MinimizePill.Position = UDim2.new(0.5, -100, 0, 20)
    self.MinimizePill.Size = UDim2.new(0, 200, 0, 40)
    self.MinimizePill.Visible = false
    
    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(1, 0)
    pillCorner.Parent = self.MinimizePill
    
    local pillBorder = Instance.new("UIStroke")
    pillBorder.Color = Theme.Border
    pillBorder.Thickness = 1
    pillBorder.Parent = self.MinimizePill
    
    local pillLabel = Instance.new("TextLabel")
    pillLabel.Parent = self.MinimizePill
    pillLabel.BackgroundTransparency = 1
    pillLabel.Size = UDim2.new(1, 0, 1, 0)
    pillLabel.Font = Enum.Font.GothamBold
    pillLabel.Text = "Reaper Hub"
    pillLabel.TextColor3 = Theme.Accent
    pillLabel.TextSize = 12
    
    local pillButton = Instance.new("TextButton")
    pillButton.Parent = self.MinimizePill
    pillButton.BackgroundTransparency = 1
    pillButton.Size = UDim2.new(1, 0, 1, 0)
    pillButton.Text = ""
    
    -- Minimize/Restore functionality
    self.IsMinimized = false
    
    minimizeBtn.MouseButton1Click:Connect(function()
        self.IsMinimized = true
        Tween(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        self.Main.Visible = false
        self.MinimizePill.Visible = true
        Tween(self.MinimizePill, {Size = UDim2.new(0, 200, 0, 40)}, 0.3)
    end)
    
    pillButton.MouseButton1Click:Connect(function()
        self.IsMinimized = false
        Tween(self.MinimizePill, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        self.MinimizePill.Visible = false
        self.Main.Visible = true
        self.Main.Size = UDim2.new(0, 0, 0, 0)
        Tween(self.Main, {Size = UDim2.new(0, 400, 0, 300)}, 0.3)
    end)
    
    pillButton.MouseEnter:Connect(function()
        Tween(self.MinimizePill, {BackgroundColor3 = Theme.Secondary}, 0.15)
    end)
    
    pillButton.MouseLeave:Connect(function()
        Tween(self.MinimizePill, {BackgroundColor3 = Theme.Background}, 0.15)
    end)
    
    minimizeBtn.MouseEnter:Connect(function()
        Tween(minimizeBtn, {BackgroundColor3 = Theme.Secondary}, 0.15)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        Tween(minimizeBtn, {BackgroundColor3 = Theme.Border}, 0.15)
    end)
    
    -- Make pill draggable
    local draggingPill, pillDragStart, pillStartPos
    self.MinimizePill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingPill = true
            pillDragStart = input.Position
            pillStartPos = self.MinimizePill.Position
        end
    end)
    
    self.MinimizePill.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and draggingPill then
            local delta = input.Position - pillDragStart
            self.MinimizePill.Position = UDim2.new(
                pillStartPos.X.Scale, pillStartPos.X.Offset + delta.X,
                pillStartPos.Y.Scale, pillStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingPill = false
        end
    end)
    
    -- Tab container (VERTICAL LEFT SIDE)
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Parent = self.Main
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.Size = UDim2.new(0, 80, 1, -40)
    
    -- Content area
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.Parent = self.Main
    self.Content.BackgroundTransparency = 1
    self.Content.Position = UDim2.new(0, 85, 0, 40)
    self.Content.Size = UDim2.new(1, -90, 1, -45)
    self.Content.ClipsDescendants = true
    
    -- Scroll frame
    self.Scroll = Instance.new("ScrollingFrame")
    self.Scroll.Parent = self.Content
    self.Scroll.BackgroundTransparency = 1
    self.Scroll.BorderSizePixel = 0
    self.Scroll.Size = UDim2.new(1, 0, 1, 0)
    self.Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Scroll.ScrollBarThickness = 2
    self.Scroll.ScrollBarImageColor3 = Theme.Border
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = self.Scroll
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Make main window draggable
    local dragging, dragStart, startPos
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

function GUI:AddTab(name)
    local tab = {Name = name, Elements = {}}
    
    -- Tab button (VERTICAL)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = self.TabContainer
    btn.BackgroundColor3 = Theme.Secondary
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 5, 0, #self.Tabs * 35)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name:upper()
    btn.TextColor3 = Theme.TextDim
    btn.TextSize = 10
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextXOffset = 8
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    -- Tab content frame
    tab.Frame = Instance.new("Frame")
    tab.Frame.Name = name .. "_Content"
    tab.Frame.Parent = self.Scroll
    tab.Frame.BackgroundTransparency = 1
    tab.Frame.Size = UDim2.new(1, 0, 0, 0)
    tab.Frame.Visible = false
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tab.Frame
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 6)
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Frame.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    
    btn.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)
    
    btn.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(btn, {BackgroundTransparency = 0.7}, 0.15)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(btn, {BackgroundTransparency = 1}, 0.15)
        end
    end)
    
    tab.Button = btn
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SwitchTab(tab)
    end
    
    -- Add toggle method
    function tab:AddToggle(config)
        local toggle = {State = config.Default or false}
        
        local frame = Instance.new("Frame")
        frame.Parent = self.Frame
        frame.BackgroundColor3 = Theme.Secondary
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(1, 0, 0, 35)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame
        
        local border = Instance.new("UIStroke")
        border.Color = Theme.Border
        border.Thickness = 1
        border.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Font = Enum.Font.Gotham
        label.Text = config.Title
        label.TextColor3 = Theme.Text
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Toggle switch
        local switchBg = Instance.new("Frame")
        switchBg.Parent = frame
        switchBg.BackgroundColor3 = toggle.State and Theme.Success or Theme.Border
        switchBg.BorderSizePixel = 0
        switchBg.Position = UDim2.new(1, -40, 0.5, -8)
        switchBg.Size = UDim2.new(0, 35, 0, 16)
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0)
        switchCorner.Parent = switchBg
        
        local knob = Instance.new("Frame")
        knob.Parent = switchBg
        knob.BackgroundColor3 = Theme.Accent
        knob.BorderSizePixel = 0
        knob.Position = toggle.State and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        knob.Size = UDim2.new(0, 12, 0, 12)
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        local btn = Instance.new("TextButton")
        btn.Parent = frame
        btn.BackgroundTransparency = 1
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.Text = ""
        
        btn.MouseButton1Click:Connect(function()
            toggle.State = not toggle.State
            Tween(switchBg, {BackgroundColor3 = toggle.State and Theme.Success or Theme.Border}, 0.2)
            Tween(knob, {Position = toggle.State and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}, 0.2)
            if config.Callback then
                pcall(config.Callback, toggle.State)
            end
        end)
        
        btn.MouseEnter:Connect(function()
            Tween(border, {Color = Theme.Accent}, 0.15)
        end)
        
        btn.MouseLeave:Connect(function()
            Tween(border, {Color = Theme.Border}, 0.15)
        end)
        
        return toggle
    end
    
    -- Add slider method
    function tab:AddSlider(config)
        local slider = {Value = config.Default or config.Min or 0}
        
        local frame = Instance.new("Frame")
        frame.Parent = self.Frame
        frame.BackgroundColor3 = Theme.Secondary
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(1, 0, 0, 45)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame
        
        local border = Instance.new("UIStroke")
        border.Color = Theme.Border
        border.Thickness = 1
        border.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 5)
        label.Size = UDim2.new(1, -60, 0, 15)
        label.Font = Enum.Font.Gotham
        label.Text = config.Title
        label.TextColor3 = Theme.Text
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = frame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Position = UDim2.new(1, -50, 0, 5)
        valueLabel.Size = UDim2.new(0, 40, 0, 15)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Text = tostring(slider.Value)
        valueLabel.TextColor3 = Theme.Success
        valueLabel.TextSize = 11
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        -- Slider bar
        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = frame
        sliderBg.BackgroundColor3 = Theme.Border
        sliderBg.BorderSizePixel = 0
        sliderBg.Position = UDim2.new(0, 10, 1, -15)
        sliderBg.Size = UDim2.new(1, -20, 0, 4)
        
        local sliderBgCorner = Instance.new("UICorner")
        sliderBgCorner.CornerRadius = UDim.new(1, 0)
        sliderBgCorner.Parent = sliderBg
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBg
        sliderFill.BackgroundColor3 = Theme.Success
        sliderFill.BorderSizePixel = 0
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        
        local sliderFillCorner = Instance.new("UICorner")
        sliderFillCorner.CornerRadius = UDim.new(1, 0)
        sliderFillCorner.Parent = sliderFill
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local min = config.Min or 0
            local max = config.Max or 100
            slider.Value = math.floor(min + (max - min) * pos)
            valueLabel.Text = tostring(slider.Value)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            if config.Callback then
                pcall(config.Callback, slider.Value)
            end
        end
        
        local dragging = false
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        sliderBg.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        -- Set initial value
        local initialPos = (slider.Value - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0))
        sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
        
        return slider
    end
    
    -- Add button method
    function tab:AddButton(config)
        local frame = Instance.new("TextButton")
        frame.Parent = self.Frame
        frame.BackgroundColor3 = Theme.Secondary
        frame.BorderSizePixel = 0
        frame.Size = UDim2.new(1, 0, 0, 35)
        frame.Font = Enum.Font.GothamBold
        frame.Text = config.Title
        frame.TextColor3 = Theme.Accent
        frame.TextSize = 11
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = frame
        
        local border = Instance.new("UIStroke")
        border.Color = Theme.Border
        border.Thickness = 1
        border.Parent = frame
        
        frame.MouseButton1Click:Connect(function()
            if config.Callback then
                pcall(config.Callback)
            end
        end)
        
        frame.MouseEnter:Connect(function()
            Tween(frame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.15)
            Tween(border, {Color = Theme.Accent}, 0.15)
        end)
        
        frame.MouseLeave:Connect(function()
            Tween(frame, {BackgroundColor3 = Theme.Secondary}, 0.15)
            Tween(border, {Color = Theme.Border}, 0.15)
        end)
    end
    
    return tab
end

function GUI:SwitchTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Frame.Visible = false
        Tween(t.Button, {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}, 0.15)
    end
    
    tab.Frame.Visible = true
    self.CurrentTab = tab
    Tween(tab.Button, {BackgroundTransparency = 0, TextColor3 = Theme.Accent}, 0.15)
end

-- ========================================
-- FEATURES
-- ========================================

local Features = {
    AutoParry = {Enabled = false, Connection = nil, Distance = 0.75},
    ManualSpam = {Enabled = false, Connection = nil},
    ESP = {Enabled = false, Highlights = {}},
    BallESP = {Enabled = false, Highlight = nil},
    Speed = {Enabled = false, Value = 16},
    Jump = {Enabled = false, Value = 50},
    Fullbright = {Enabled = false, OriginalBrightness = nil, OriginalAmbient = nil},
    NoFog = {Enabled = false, OriginalFogEnd = nil},
    AutoClicker = {Enabled = false, CPS = 10},
    InfiniteJump = {Enabled = false, Connection = nil}
}

-- Auto Parry (Movement Enabled)
function Features.AutoParry:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local Cooldown = tick()
    local Parried = false
    
    local function GetBall()
        for _, Ball in ipairs(workspace.Balls:GetChildren()) do
            if Ball:GetAttribute("realBall") then
                return Ball
            end
        end
    end
    
    self.Connection = RunService.PreSimulation:Connect(function()
        if not self.Enabled then return end
        
        local Ball = GetBall()
        local HRP = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not Ball or not HRP then return end
        
        local Speed = Ball.zoomies.VectorVelocity.Magnitude
        local Distance = (HRP.Position - Ball.Position).Magnitude
        
        if Ball:GetAttribute("target") == Players.LocalPlayer.Name and not Parried and Distance / Speed <= self.Distance then
            task.spawn(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
            Parried = true
            Cooldown = tick()
        end
        
        if Parried and (tick() - Cooldown) >= 0.5 then
            Parried = false
        end
    end)
end

function Features.AutoParry:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

-- Manual Spam
function Features.ManualSpam:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    task.spawn(function()
        while self.Enabled do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            task.wait(0.001)
        end
    end)
end

function Features.ManualSpam:Stop()
    self.Enabled = false
end

-- Player ESP
function Features.ESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function addHighlight(player)
        if player == Players.LocalPlayer then return end
        
        local char = player.Character or player.CharacterAdded:Wait()
        local highlight = Instance.new("Highlight")
        highlight.Parent = char
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        self.Highlights[player] = highlight
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            addHighlight(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if self.Enabled then
                addHighlight(player)
            end
        end)
    end)
end

function Features.ESP:Stop()
    self.Enabled = false
    for _, highlight in pairs(self.Highlights) do
        highlight:Destroy()
    end
    self.Highlights = {}
end

-- Ball ESP
function Features.BallESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function GetBall()
        for _, Ball in ipairs(workspace.Balls:GetChildren()) do
            if Ball:GetAttribute("realBall") then
                return Ball
            end
        end
    end
    
    local ball = GetBall()
    if ball then
        local highlight = Instance.new("Highlight")
        highlight.Parent = ball
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.3
        highlight.OutlineTransparency = 0
        self.Highlight = highlight
    end
end

function Features.BallESP:Stop()
    self.Enabled = false
    if self.Highlight then
        self.Highlight:Destroy()
        self.Highlight = nil
    end
end

-- Speed
function Features.Speed:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = self.Value
    end
end

function Features.Speed:Stop()
    self.Enabled = false
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
    end
end

function Features.Speed:Update()
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and self.Enabled then
        humanoid.WalkSpeed = self.Value
    end
end

-- Jump
function Features.Jump:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = self.Value
    end
end

function Features.Jump:Stop()
    self.Enabled = false
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = 50
    end
end

function Features.Jump:Update()
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and self.Enabled then
        humanoid.JumpPower = self.Value
    end
end

-- Fullbright
function Features.Fullbright:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    self.OriginalBrightness = Lighting.Brightness
    self.OriginalAmbient = Lighting.Ambient
    
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end

function Features.Fullbright:Stop()
    self.Enabled = false
    if self.OriginalBrightness then
        Lighting.Brightness = self.OriginalBrightness
        Lighting.Ambient = self.OriginalAmbient
    end
end

-- No Fog
function Features.NoFog:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    self.OriginalFogEnd = Lighting.FogEnd
    Lighting.FogEnd = 100000
end

function Features.NoFog:Stop()
    self.Enabled = false
    if self.OriginalFogEnd then
        Lighting.FogEnd = self.OriginalFogEnd
    end
end

-- Auto Clicker
function Features.AutoClicker:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    task.spawn(function()
        while self.Enabled do
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            task.wait(1 / self.CPS)
        end
    end)
end

function Features.AutoClicker:Stop()
    self.Enabled = false
end

-- Infinite Jump
function Features.InfiniteJump:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    self.Connection = UserInputService.JumpRequest:Connect(function()
        if self.Enabled then
            local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

function Features.InfiniteJump:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

-- ========================================
-- INITIALIZE GUI
-- ========================================

local ui = GUI:Create()

-- MAIN TAB
local mainTab = ui:AddTab("MAIN")

mainTab:AddToggle({
    Title = "Auto Parry",
    Default = false,
    Callback = function(state)
        if state then
            Features.AutoParry:Start()
        else
            Features.AutoParry:Stop()
        end
    end
})

mainTab:AddSlider({
    Title = "Parry Distance",
    Min = 25,
    Max = 200,
    Default = 75,
    Callback = function(value)
        Features.AutoParry.Distance = value / 100
    end
})

mainTab:AddToggle({
    Title = "Manual Spam",
    Default = false,
    Callback = function(state)
        if state then
            Features.ManualSpam:Start()
        else
            Features.ManualSpam:Stop()
        end
    end
})

mainTab:AddToggle({
    Title = "Auto Clicker",
    Default = false,
    Callback = function(state)
        if state then
            Features.AutoClicker:Start()
        else
            Features.AutoClicker:Stop()
        end
    end
})

mainTab:AddSlider({
    Title = "CPS (Clicks/Sec)",
    Min = 1,
    Max = 50,
    Default = 10,
    Callback = function(value)
        Features.AutoClicker.CPS = value
    end
})

-- PLAY TAB
local playTab = ui:AddTab("PLAY")

playTab:AddToggle({
    Title = "Speed Boost",
    Default = false,
    Callback = function(state)
        if state then
            Features.Speed:Start()
        else
            Features.Speed:Stop()
        end
    end
})

playTab:AddSlider({
    Title = "Speed Value",
    Min = 16,
    Max = 100,
    Default = 50,
    Callback = function(value)
        Features.Speed.Value = value
        Features.Speed:Update()
    end
})

playTab:AddToggle({
    Title = "Jump Boost",
    Default = false,
    Callback = function(state)
        if state then
            Features.Jump:Start()
        else
            Features.Jump:Stop()
        end
    end
})

playTab:AddSlider({
    Title = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 100,
    Callback = function(value)
        Features.Jump.Value = value
        Features.Jump:Update()
    end
})

playTab:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        if state then
            Features.InfiniteJump:Start()
        else
            Features.InfiniteJump:Stop()
        end
    end
})

playTab:AddToggle({
    Title = "Fullbright",
    Default = false,
    Callback = function(state)
        if state then
            Features.Fullbright:Start()
        else
            Features.Fullbright:Stop()
        end
    end
})

playTab:AddToggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then
            Features.NoFog:Start()
        else
            Features.NoFog:Stop()
        end
    end
})

-- ESP TAB
local espTab = ui:AddTab("ESP")

espTab:AddToggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        if state then
            Features.ESP:Start()
        else
            Features.ESP:Stop()
        end
    end
})

espTab:AddToggle({
    Title = "Ball ESP",
    Default = false,
    Callback = function(state)
        if state then
            Features.BallESP:Start()
        else
            Features.BallESP:Stop()
        end
    end
})

espTab:AddButton({
    Title = "Refresh ESP",
    Callback = function()
        Features.ESP:Stop()
        task.wait(0.1)
        Features.ESP:Start()
    end
})

print("========================================")
print("✓ REAPER HUB | BLADEBALL LOADED")
print("✓ Minimal Black UI | Movement Enabled")
print("========================================")
