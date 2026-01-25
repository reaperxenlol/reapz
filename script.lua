-- ========================================
-- REAPER HUB | BLADEBALL
-- 3D Animations + Glassmorphic Design
-- ========================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Balls = Workspace:WaitForChild("Balls")

-- Glassmorphic Color Scheme (slightly transparent)
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundTransparency = 0.15,
    Card = Color3.fromRGB(25, 25, 32),
    CardTransparency = 0.1,
    CardHover = Color3.fromRGB(35, 35, 45),
    Sidebar = Color3.fromRGB(18, 18, 24),
    SidebarTransparency = 0.1,
    Border = Color3.fromRGB(50, 50, 65),
    Accent = Color3.fromRGB(99, 102, 241),
    AccentGlow = Color3.fromRGB(129, 132, 255),
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(255, 180, 50),
    Danger = Color3.fromRGB(255, 75, 75),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 160),
    TextMuted = Color3.fromRGB(80, 80, 100)
}

local function Tween(obj, props, time, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

-- ========================================
-- MOBILE + PC DRAG FUNCTION
-- ========================================
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function update(inputPos)
        if dragging and dragStart and startPos then
            local delta = inputPos - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            startPos = frame.Position
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                update(Vector2.new(input.Position.X, input.Position.Y))
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                update(Vector2.new(input.Position.X, input.Position.Y))
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Destroy old GUI
if game.CoreGui:FindFirstChild("ReaperHub") then
    game.CoreGui:FindFirstChild("ReaperHub"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ReaperHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- =====================
-- MINIMIZED PILL
-- =====================
local MinimizedPill = Instance.new("Frame")
MinimizedPill.Name = "MinimizedPill"
MinimizedPill.Parent = ScreenGui
MinimizedPill.BackgroundColor3 = Colors.Card
MinimizedPill.BackgroundTransparency = Colors.CardTransparency
MinimizedPill.BorderSizePixel = 0
MinimizedPill.Position = UDim2.new(0.5, -120, 0, 15)
MinimizedPill.Size = UDim2.new(0, 240, 0, 45)
MinimizedPill.Visible = false
MinimizedPill.Active = true

local pillCorner = Instance.new("UICorner")
pillCorner.CornerRadius = UDim.new(0, 25)
pillCorner.Parent = MinimizedPill

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = Colors.Accent
pillStroke.Thickness = 2
pillStroke.Transparency = 0.5
pillStroke.Parent = MinimizedPill

local pillIcon = Instance.new("TextLabel")
pillIcon.Parent = MinimizedPill
pillIcon.BackgroundTransparency = 1
pillIcon.Position = UDim2.new(0, 18, 0, 0)
pillIcon.Size = UDim2.new(0, 25, 1, 0)
pillIcon.Font = Enum.Font.GothamBold
pillIcon.Text = "[R]"
pillIcon.TextColor3 = Colors.Accent
pillIcon.TextSize = 14
pillIcon.ZIndex = 2

local pillText = Instance.new("TextLabel")
pillText.Parent = MinimizedPill
pillText.BackgroundTransparency = 1
pillText.Position = UDim2.new(0, 45, 0, 0)
pillText.Size = UDim2.new(1, -55, 1, 0)
pillText.Font = Enum.Font.GothamBold
pillText.Text = "Reaper Hub"
pillText.TextColor3 = Colors.Text
pillText.TextSize = 14
pillText.TextXAlignment = Enum.TextXAlignment.Left
pillText.ZIndex = 2

local pillButton = Instance.new("TextButton")
pillButton.Parent = MinimizedPill
pillButton.BackgroundTransparency = 1
pillButton.Size = UDim2.new(1, 0, 1, 0)
pillButton.Text = ""
pillButton.ZIndex = 3

MakeDraggable(MinimizedPill, pillButton)

pillButton.MouseEnter:Connect(function()
    Tween(MinimizedPill, {BackgroundColor3 = Colors.CardHover}, 0.2)
    Tween(pillStroke, {Transparency = 0}, 0.2)
end)

pillButton.MouseLeave:Connect(function()
    Tween(MinimizedPill, {BackgroundColor3 = Colors.Card}, 0.2)
    Tween(pillStroke, {Transparency = 0.5}, 0.2)
end)

-- =====================
-- MAIN WINDOW (GLASSMORPHIC)
-- =====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = Colors.BackgroundTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -180)
MainFrame.Size = UDim2.new(0, 500, 0, 360)
MainFrame.ClipsDescendants = true
MainFrame.Active = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Colors.Border
mainStroke.Thickness = 1
mainStroke.Transparency = 0.3
mainStroke.Parent = MainFrame

-- =====================
-- TITLE BAR
-- =====================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Colors.Sidebar
TitleBar.BackgroundTransparency = Colors.SidebarTransparency
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.Active = true

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local titleFix = Instance.new("Frame")
titleFix.Parent = TitleBar
titleFix.BackgroundColor3 = Colors.Sidebar
titleFix.BackgroundTransparency = Colors.SidebarTransparency
titleFix.BorderSizePixel = 0
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.Size = UDim2.new(1, 0, 0, 12)

local accentLine = Instance.new("Frame")
accentLine.Parent = TitleBar
accentLine.BackgroundColor3 = Colors.Accent
accentLine.BorderSizePixel = 0
accentLine.Position = UDim2.new(0, 0, 1, -2)
accentLine.Size = UDim2.new(1, 0, 0, 2)

local titleIconBg = Instance.new("Frame")
titleIconBg.Parent = TitleBar
titleIconBg.BackgroundColor3 = Colors.Accent
titleIconBg.BackgroundTransparency = 0.85
titleIconBg.Position = UDim2.new(0, 15, 0.5, -15)
titleIconBg.Size = UDim2.new(0, 30, 0, 30)

local titleIconCorner = Instance.new("UICorner")
titleIconCorner.CornerRadius = UDim.new(0, 8)
titleIconCorner.Parent = titleIconBg

local titleIcon = Instance.new("TextLabel")
titleIcon.Parent = titleIconBg
titleIcon.BackgroundTransparency = 1
titleIcon.Size = UDim2.new(1, 0, 1, 0)
titleIcon.Font = Enum.Font.GothamBold
titleIcon.Text = "R"
titleIcon.TextColor3 = Colors.Accent
titleIcon.TextSize = 16

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = TitleBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 55, 0, 8)
titleLabel.Size = UDim2.new(1, -120, 0, 18)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Reaper Hub | Bladeball"
titleLabel.TextColor3 = Colors.Text
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Parent = TitleBar
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Position = UDim2.new(0, 55, 0, 26)
subtitleLabel.Size = UDim2.new(1, -120, 0, 14)
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "v2.0 | Mobile Ready"
subtitleLabel.TextColor3 = Colors.TextMuted
subtitleLabel.TextSize = 11
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = TitleBar
minimizeBtn.BackgroundColor3 = Colors.Card
minimizeBtn.BackgroundTransparency = 0.3
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Position = UDim2.new(1, -45, 0.5, -12)
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Colors.TextDim
minimizeBtn.TextSize = 18
minimizeBtn.AutoButtonColor = false

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
minimizeBtnCorner.Parent = minimizeBtn

minimizeBtn.MouseEnter:Connect(function()
    Tween(minimizeBtn, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0, TextColor3 = Colors.Text}, 0.15)
end)

minimizeBtn.MouseLeave:Connect(function()
    Tween(minimizeBtn, {BackgroundColor3 = Colors.Card, BackgroundTransparency = 0.3, TextColor3 = Colors.TextDim}, 0.15)
end)

MakeDraggable(MainFrame, TitleBar)

-- Minimize/Restore with 3D animation
minimizeBtn.MouseButton1Click:Connect(function()
    Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 0), BackgroundTransparency = 1}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.35)
    MainFrame.Visible = false
    MinimizedPill.Visible = true
    MinimizedPill.Size = UDim2.new(0, 0, 0, 45)
    Tween(MinimizedPill, {Size = UDim2.new(0, 240, 0, 45)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

pillButton.MouseButton1Click:Connect(function()
    Tween(MinimizedPill, {Size = UDim2.new(0, 0, 0, 45)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.35)
    MinimizedPill.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 500, 0, 0)
    MainFrame.BackgroundTransparency = 1
    Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 360), BackgroundTransparency = Colors.BackgroundTransparency}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end)

-- =====================
-- SIDEBAR (GLASSMORPHIC)
-- =====================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BackgroundTransparency = Colors.SidebarTransparency
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.Size = UDim2.new(0, 130, 1, -50)

local sidebarLine = Instance.new("Frame")
sidebarLine.Parent = Sidebar
sidebarLine.BackgroundColor3 = Colors.Border
sidebarLine.BackgroundTransparency = 0.5
sidebarLine.BorderSizePixel = 0
sidebarLine.Position = UDim2.new(1, -1, 0, 15)
sidebarLine.Size = UDim2.new(0, 1, 1, -30)

local TabButtonsContainer = Instance.new("Frame")
TabButtonsContainer.Name = "TabButtons"
TabButtonsContainer.Parent = Sidebar
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Position = UDim2.new(0, 10, 0, 15)
TabButtonsContainer.Size = UDim2.new(1, -20, 1, -20)

local tabLayout = Instance.new("UIListLayout")
tabLayout.Parent = TabButtonsContainer
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)

-- =====================
-- CONTENT AREA
-- =====================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 140, 0, 60)
ContentArea.Size = UDim2.new(1, -150, 1, -70)
ContentArea.ClipsDescendants = true

-- ========================================
-- TAB SYSTEM WITH 3D ANIMATIONS
-- ========================================
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    local Tab = {Name = name, Sections = {}}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name
    tabBtn.Parent = TabButtonsContainer
    tabBtn.BackgroundColor3 = Colors.Card
    tabBtn.BackgroundTransparency = 1
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(1, 0, 0, 38)
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabBtn
    
    local activeIndicator = Instance.new("Frame")
    activeIndicator.Name = "Indicator"
    activeIndicator.Parent = tabBtn
    activeIndicator.BackgroundColor3 = Colors.Accent
    activeIndicator.BorderSizePixel = 0
    activeIndicator.Position = UDim2.new(0, 0, 0.5, -10)
    activeIndicator.Size = UDim2.new(0, 3, 0, 20)
    activeIndicator.Visible = false
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = activeIndicator
    
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Parent = tabBtn
    tabIcon.BackgroundTransparency = 1
    tabIcon.Position = UDim2.new(0, 12, 0, 0)
    tabIcon.Size = UDim2.new(0, 20, 1, 0)
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.Text = icon or ">"
    tabIcon.TextColor3 = Colors.TextMuted
    tabIcon.TextSize = 12
    
    local tabText = Instance.new("TextLabel")
    tabText.Parent = tabBtn
    tabText.BackgroundTransparency = 1
    tabText.Position = UDim2.new(0, 35, 0, 0)
    tabText.Size = UDim2.new(1, -40, 1, 0)
    tabText.Font = Enum.Font.GothamSemibold
    tabText.Text = name
    tabText.TextColor3 = Colors.TextMuted
    tabText.TextSize = 12
    tabText.TextXAlignment = Enum.TextXAlignment.Left
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = name .. "_Content"
    tabContent.Parent = ContentArea
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3
    tabContent.ScrollBarImageColor3 = Colors.Accent
    tabContent.ScrollBarImageTransparency = 0.5
    tabContent.Visible = false
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = tabContent
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 12)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 15)
    end)
    
    Tab.Button = tabBtn
    Tab.Content = tabContent
    Tab.Icon = tabIcon
    Tab.Text = tabText
    Tab.Indicator = activeIndicator
    
    -- 3D TAB SWITCH ANIMATION
    local function SwitchToTab()
        if CurrentTab == Tab then return end
        
        -- Animate out old tab with 3D effect
        if CurrentTab then
            local oldContent = CurrentTab.Content
            -- Slide out + fade + scale down (3D effect)
            Tween(oldContent, {Position = UDim2.new(-0.1, 0, 0, 0), Size = UDim2.new(0.9, 0, 0.9, 0)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            for _, child in ipairs(oldContent:GetChildren()) do
                if child:IsA("Frame") then
                    Tween(child, {BackgroundTransparency = 1}, 0.15)
                end
            end
            task.delay(0.25, function()
                oldContent.Visible = false
                oldContent.Position = UDim2.new(0, 0, 0, 0)
                oldContent.Size = UDim2.new(1, 0, 1, 0)
                for _, child in ipairs(oldContent:GetChildren()) do
                    if child:IsA("Frame") then
                        child.BackgroundTransparency = Colors.CardTransparency
                    end
                end
            end)
            
            CurrentTab.Indicator.Visible = false
            Tween(CurrentTab.Button, {BackgroundTransparency = 1}, 0.2)
            Tween(CurrentTab.Icon, {TextColor3 = Colors.TextMuted}, 0.2)
            Tween(CurrentTab.Text, {TextColor3 = Colors.TextMuted}, 0.2)
        end
        
        -- Animate in new tab with 3D effect
        Tab.Content.Position = UDim2.new(0.1, 0, 0, 0)
        Tab.Content.Size = UDim2.new(0.9, 0, 0.9, 0)
        for _, child in ipairs(Tab.Content:GetChildren()) do
            if child:IsA("Frame") then
                child.BackgroundTransparency = 1
            end
        end
        Tab.Content.Visible = true
        
        -- Slide in + fade + scale up (3D effect)
        Tween(Tab.Content, {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.delay(0.1, function()
            for _, child in ipairs(Tab.Content:GetChildren()) do
                if child:IsA("Frame") then
                    Tween(child, {BackgroundTransparency = Colors.CardTransparency}, 0.25)
                end
            end
        end)
        
        Tab.Indicator.Visible = true
        CurrentTab = Tab
        Tween(Tab.Button, {BackgroundTransparency = 0.5}, 0.2)
        Tween(Tab.Icon, {TextColor3 = Colors.Accent}, 0.2)
        Tween(Tab.Text, {TextColor3 = Colors.Text}, 0.2)
    end
    
    tabBtn.MouseButton1Click:Connect(SwitchToTab)
    
    tabBtn.MouseEnter:Connect(function()
        if CurrentTab ~= Tab then
            Tween(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if CurrentTab ~= Tab then
            Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
        end
    end)
    
    table.insert(Tabs, Tab)
    
    if #Tabs == 1 then
        Tab.Content.Visible = true
        Tab.Indicator.Visible = true
        CurrentTab = Tab
        Tab.Button.BackgroundTransparency = 0.5
        Tab.Icon.TextColor3 = Colors.Accent
        Tab.Text.TextColor3 = Colors.Text
    end
    
    -- Section creator
    function Tab:AddSection(title)
        local Section = {}
        
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Parent = tabContent
        sectionFrame.BackgroundTransparency = 1
        sectionFrame.Size = UDim2.new(1, 0, 0, 0)
        sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.Parent = sectionFrame
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        sectionLayout.Padding = UDim.new(0, 8)
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Parent = sectionFrame
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Size = UDim2.new(1, 0, 0, 25)
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Text = title
        sectionTitle.TextColor3 = Colors.Text
        sectionTitle.TextSize = 13
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Toggle creator (GLASSMORPHIC)
        function Section:AddToggle(config)
            local Toggle = {State = config.Default or false}
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Parent = sectionFrame
            toggleFrame.BackgroundColor3 = Colors.Card
            toggleFrame.BackgroundTransparency = Colors.CardTransparency
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 45)
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 10)
            toggleCorner.Parent = toggleFrame
            
            local toggleStroke = Instance.new("UIStroke")
            toggleStroke.Color = Colors.Border
            toggleStroke.Thickness = 1
            toggleStroke.Transparency = 0.5
            toggleStroke.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Parent = toggleFrame
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Position = UDim2.new(0, 15, 0, 0)
            toggleLabel.Size = UDim2.new(1, -75, 1, 0)
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.Text = config.Title
            toggleLabel.TextColor3 = Colors.Text
            toggleLabel.TextSize = 13
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local switchBg = Instance.new("Frame")
            switchBg.Parent = toggleFrame
            switchBg.BackgroundColor3 = Toggle.State and Colors.Success or Colors.Border
            switchBg.BorderSizePixel = 0
            switchBg.Position = UDim2.new(1, -60, 0.5, -12)
            switchBg.Size = UDim2.new(0, 46, 0, 24)
            
            local switchCorner = Instance.new("UICorner")
            switchCorner.CornerRadius = UDim.new(1, 0)
            switchCorner.Parent = switchBg
            
            local knob = Instance.new("Frame")
            knob.Parent = switchBg
            knob.BackgroundColor3 = Colors.Text
            knob.BorderSizePixel = 0
            knob.Position = Toggle.State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            knob.Size = UDim2.new(0, 20, 0, 20)
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = toggleFrame
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.Text = ""
            
            toggleBtn.MouseButton1Click:Connect(function()
                Toggle.State = not Toggle.State
                Tween(switchBg, {BackgroundColor3 = Toggle.State and Colors.Success or Colors.Border}, 0.25)
                Tween(knob, {Position = Toggle.State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.25, Enum.EasingStyle.Back)
                if config.Callback then pcall(config.Callback, Toggle.State) end
            end)
            
            toggleBtn.MouseEnter:Connect(function()
                Tween(toggleFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
            end)
            
            toggleBtn.MouseLeave:Connect(function()
                Tween(toggleFrame, {BackgroundColor3 = Colors.Card}, 0.15)
            end)
            
            return Toggle
        end
        
        -- Slider creator (GLASSMORPHIC)
        function Section:AddSlider(config)
            local Slider = {Value = config.Default or config.Min or 0}
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = sectionFrame
            sliderFrame.BackgroundColor3 = Colors.Card
            sliderFrame.BackgroundTransparency = Colors.CardTransparency
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 60)
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 10)
            sliderCorner.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Parent = sliderFrame
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Position = UDim2.new(0, 15, 0, 10)
            sliderLabel.Size = UDim2.new(1, -70, 0, 18)
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.Text = config.Title
            sliderLabel.TextColor3 = Colors.Text
            sliderLabel.TextSize = 13
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -55, 0, 10)
            valueLabel.Size = UDim2.new(0, 40, 0, 18)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(Slider.Value)
            valueLabel.TextColor3 = Colors.Accent
            valueLabel.TextSize = 13
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Parent = sliderFrame
            sliderBg.BackgroundColor3 = Colors.Border
            sliderBg.BorderSizePixel = 0
            sliderBg.Position = UDim2.new(0, 15, 0, 40)
            sliderBg.Size = UDim2.new(1, -30, 0, 6)
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(1, 0)
            sliderBgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBg
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Parent = sliderBg
            sliderKnob.BackgroundColor3 = Colors.Text
            sliderKnob.BorderSizePixel = 0
            sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
            sliderKnob.Position = UDim2.new(0, 0, 0.5, 0)
            sliderKnob.Size = UDim2.new(0, 14, 0, 14)
            sliderKnob.ZIndex = 2
            
            local sliderKnobCorner = Instance.new("UICorner")
            sliderKnobCorner.CornerRadius = UDim.new(1, 0)
            sliderKnobCorner.Parent = sliderKnob
            
            local function updateSlider(inputPos)
                local pos = math.clamp((inputPos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local min = config.Min or 0
                local max = config.Max or 100
                Slider.Value = math.floor(min + (max - min) * pos)
                valueLabel.Text = tostring(Slider.Value)
                Tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                Tween(sliderKnob, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.05)
                if config.Callback then pcall(config.Callback, Slider.Value) end
            end
            
            local draggingSlider = false
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    updateSlider(input.Position)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input.Position)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)
            
            local initialPos = (Slider.Value - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0))
            sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
            sliderKnob.Position = UDim2.new(initialPos, 0, 0.5, 0)
            
            return Slider
        end
        
        -- Button creator (GLASSMORPHIC)
        function Section:AddButton(config)
            local buttonFrame = Instance.new("TextButton")
            buttonFrame.Parent = sectionFrame
            buttonFrame.BackgroundColor3 = Colors.Card
            buttonFrame.BackgroundTransparency = Colors.CardTransparency
            buttonFrame.BorderSizePixel = 0
            buttonFrame.Size = UDim2.new(1, 0, 0, 45)
            buttonFrame.Font = Enum.Font.GothamSemibold
            buttonFrame.Text = config.Title
            buttonFrame.TextColor3 = Colors.Text
            buttonFrame.TextSize = 13
            buttonFrame.AutoButtonColor = false
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 10)
            buttonCorner.Parent = buttonFrame
            
            buttonFrame.MouseButton1Click:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Colors.Accent, BackgroundTransparency = 0}, 0.1)
                task.wait(0.1)
                Tween(buttonFrame, {BackgroundColor3 = Colors.CardHover, BackgroundTransparency = Colors.CardTransparency}, 0.1)
                if config.Callback then pcall(config.Callback) end
            end)
            
            buttonFrame.MouseEnter:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
            end)
            
            buttonFrame.MouseLeave:Connect(function()
                Tween(buttonFrame, {BackgroundColor3 = Colors.Card}, 0.15)
            end)
        end
        
        -- Dropdown creator (GLASSMORPHIC)
        function Section:AddDropdown(config)
            local Dropdown = {Value = config.Default or config.Options[1]}
            local open = false
            
            local dropFrame = Instance.new("Frame")
            dropFrame.Parent = sectionFrame
            dropFrame.BackgroundColor3 = Colors.Card
            dropFrame.BackgroundTransparency = Colors.CardTransparency
            dropFrame.BorderSizePixel = 0
            dropFrame.Size = UDim2.new(1, 0, 0, 45)
            dropFrame.ClipsDescendants = true
            
            local dropCorner = Instance.new("UICorner")
            dropCorner.CornerRadius = UDim.new(0, 10)
            dropCorner.Parent = dropFrame
            
            local dropLabel = Instance.new("TextLabel")
            dropLabel.Parent = dropFrame
            dropLabel.BackgroundTransparency = 1
            dropLabel.Position = UDim2.new(0, 15, 0, 0)
            dropLabel.Size = UDim2.new(0.5, -15, 0, 45)
            dropLabel.Font = Enum.Font.Gotham
            dropLabel.Text = config.Title
            dropLabel.TextColor3 = Colors.Text
            dropLabel.TextSize = 13
            dropLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropValue = Instance.new("TextLabel")
            dropValue.Parent = dropFrame
            dropValue.BackgroundTransparency = 1
            dropValue.Position = UDim2.new(0.5, 0, 0, 0)
            dropValue.Size = UDim2.new(0.5, -35, 0, 45)
            dropValue.Font = Enum.Font.GothamSemibold
            dropValue.Text = Dropdown.Value
            dropValue.TextColor3 = Colors.Accent
            dropValue.TextSize = 12
            dropValue.TextXAlignment = Enum.TextXAlignment.Right
            
            local dropArrow = Instance.new("TextLabel")
            dropArrow.Parent = dropFrame
            dropArrow.BackgroundTransparency = 1
            dropArrow.Position = UDim2.new(1, -25, 0, 0)
            dropArrow.Size = UDim2.new(0, 20, 0, 45)
            dropArrow.Font = Enum.Font.GothamBold
            dropArrow.Text = "v"
            dropArrow.TextColor3 = Colors.TextDim
            dropArrow.TextSize = 12
            
            local dropBtn = Instance.new("TextButton")
            dropBtn.Parent = dropFrame
            dropBtn.BackgroundTransparency = 1
            dropBtn.Size = UDim2.new(1, 0, 0, 45)
            dropBtn.Text = ""
            
            local optionContainer = Instance.new("Frame")
            optionContainer.Parent = dropFrame
            optionContainer.BackgroundTransparency = 1
            optionContainer.Position = UDim2.new(0, 10, 0, 50)
            optionContainer.Size = UDim2.new(1, -20, 0, #config.Options * 35)
            
            local optionLayout = Instance.new("UIListLayout")
            optionLayout.Parent = optionContainer
            optionLayout.Padding = UDim.new(0, 5)
            
            for _, opt in ipairs(config.Options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = optionContainer
                optBtn.BackgroundColor3 = Colors.CardHover
                optBtn.BackgroundTransparency = 0.3
                optBtn.BorderSizePixel = 0
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = opt
                optBtn.TextColor3 = opt == Dropdown.Value and Colors.Accent or Colors.TextDim
                optBtn.TextSize = 12
                optBtn.AutoButtonColor = false
                
                local optCorner = Instance.new("UICorner")
                optCorner.CornerRadius = UDim.new(0, 6)
                optCorner.Parent = optBtn
                
                optBtn.MouseButton1Click:Connect(function()
                    Dropdown.Value = opt
                    dropValue.Text = opt
                    for _, child in ipairs(optionContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.TextColor3 = child.Text == opt and Colors.Accent or Colors.TextDim
                        end
                    end
                    open = false
                    Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.25, Enum.EasingStyle.Back)
                    Tween(dropArrow, {Rotation = 0}, 0.25)
                    if config.Callback then pcall(config.Callback, opt) end
                end)
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 55 + #config.Options * 35)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    Tween(dropArrow, {Rotation = 180}, 0.25)
                else
                    Tween(dropFrame, {Size = UDim2.new(1, 0, 0, 45)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    Tween(dropArrow, {Rotation = 0}, 0.25)
                end
            end)
            
            return Dropdown
        end
        
        return Section
    end
    
    return Tab
end

-- ========================================
-- YOUR EXACT ORIGINAL AUTO PARRY
-- ========================================

local Features = {
    AutoParry = {Enabled = false, Connection = nil},
    ManualSpam = {Enabled = false},
    BallESP = {Enabled = false, Items = {}},
    ESP = {Enabled = false, Items = {}},
    Speed = {Enabled = false, Value = 50},
    Jump = {Enabled = false, Value = 100},
    AutoPlay = {Enabled = false, Style = "Balanced"},
    AntiAFK = {Enabled = true},
    InfiniteJump = {Enabled = false, Connection = nil}
}

-- YOUR EXACT ORIGINAL AUTO PARRY CODE
local parryDistance = 0.75
local parrySpeed = 20
local parryCooldown = 0.5
local Cooldown = tick()
local Parried = false
local ParryConnection = nil

local function GetBall()
    for _, Ball in ipairs(Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then
            return Ball
        end
    end
end

local function ResetParryConnection()
    if ParryConnection then
        ParryConnection:Disconnect()
        ParryConnection = nil
    end
end

Balls.ChildAdded:Connect(function()
    local Ball = GetBall()
    if not Ball then return end
    ResetParryConnection()
    ParryConnection = Ball:GetAttributeChangedSignal("target"):Connect(function()
        Parried = false
    end)
end)

function Features.AutoParry:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    self.Connection = RunService.PreSimulation:Connect(function()
        if not self.Enabled then return end
        
        local Ball = GetBall()
        local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not Ball or not HRP then return end
        
        local Speed = Ball.zoomies.VectorVelocity.Magnitude
        local Distance = (HRP.Position - Ball.Position).Magnitude
        
        if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= parryDistance then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            Parried = true
            Cooldown = tick()
        end
        
        if Parried and (tick() - Cooldown) >= parryCooldown then
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

function Features.AutoParry:SetDistance(value)
    parryDistance = value
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

-- Ball ESP
function Features.BallESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function CreateBallESP(ball)
        if self.Items[ball] then return end
        self.Items[ball] = {}
        
        local hl = Instance.new("Highlight")
        hl.Parent = ball
        hl.FillColor = Color3.fromRGB(0, 200, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        table.insert(self.Items[ball], hl)
        
        local bb = Instance.new("BillboardGui")
        bb.Parent = ball
        bb.Size = UDim2.new(0, 100, 0, 40)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        table.insert(self.Items[ball], bb)
        
        local bg = Instance.new("Frame")
        bg.Parent = bb
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        bg.BackgroundTransparency = 0.2
        
        local bgCorner = Instance.new("UICorner")
        bgCorner.CornerRadius = UDim.new(0, 8)
        bgCorner.Parent = bg
        
        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Parent = bg
        status.Position = UDim2.new(0, 0, 0, 2)
        status.Size = UDim2.new(1, 0, 0.5, 0)
        status.BackgroundTransparency = 1
        status.Font = Enum.Font.GothamBold
        status.Text = "SAFE"
        status.TextColor3 = Colors.Success
        status.TextSize = 12
        
        local info = Instance.new("TextLabel")
        info.Name = "Info"
        info.Parent = bg
        info.Position = UDim2.new(0, 0, 0.5, 0)
        info.Size = UDim2.new(1, 0, 0.5, 0)
        info.BackgroundTransparency = 1
        info.Font = Enum.Font.Gotham
        info.Text = "0 studs"
        info.TextColor3 = Colors.TextDim
        info.TextSize = 10
        
        local conn = RunService.RenderStepped:Connect(function()
            if not ball or not ball.Parent then conn:Disconnect() return end
            if not self.Enabled then hl.Enabled = false bb.Enabled = false return end
            
            hl.Enabled = true
            bb.Enabled = true
            
            local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not HRP then return end
            
            local dist = (HRP.Position - ball.Position).Magnitude
            local target = ball:GetAttribute("target")
            local isTargeting = target == Player.Name
            
            info.Text = string.format("%.0f studs", dist)
            
            if isTargeting then
                if dist <= 10 then
                    hl.FillColor = Colors.Danger
                    status.Text = "!! PARRY !!"
                    status.TextColor3 = Colors.Danger
                elseif dist <= 25 then
                    hl.FillColor = Colors.Warning
                    status.Text = "INCOMING"
                    status.TextColor3 = Colors.Warning
                else
                    hl.FillColor = Color3.fromRGB(255, 200, 100)
                    status.Text = "TRACKING"
                    status.TextColor3 = Color3.fromRGB(255, 200, 100)
                end
            else
                hl.FillColor = Colors.Success
                status.Text = "SAFE"
                status.TextColor3 = Colors.Success
            end
        end)
        
        table.insert(self.Items[ball], conn)
        
        ball.Destroying:Connect(function()
            conn:Disconnect()
            for _, item in pairs(self.Items[ball] or {}) do
                if typeof(item) == "RBXScriptConnection" then item:Disconnect()
                else pcall(function() item:Destroy() end) end
            end
            self.Items[ball] = nil
        end)
    end
    
    for _, ball in pairs(Balls:GetChildren()) do
        if ball:IsA("BasePart") then CreateBallESP(ball) end
    end
    
    Balls.ChildAdded:Connect(function(ball)
        if self.Enabled and ball:IsA("BasePart") then
            task.wait(0.1)
            CreateBallESP(ball)
        end
    end)
end

function Features.BallESP:Stop()
    self.Enabled = false
    for ball, items in pairs(self.Items) do
        for _, item in pairs(items) do
            if typeof(item) == "RBXScriptConnection" then item:Disconnect()
            else pcall(function() item:Destroy() end) end
        end
    end
    self.Items = {}
end

-- Player ESP
function Features.ESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function addHighlight(player)
        if player == Player then return end
        local function createHighlight(char)
            if not char then return end
            if self.Items[player] then pcall(function() self.Items[player]:Destroy() end) end
            local highlight = Instance.new("Highlight")
            highlight.Parent = char
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            self.Items[player] = highlight
        end
        if player.Character then createHighlight(player.Character) end
        player.CharacterAdded:Connect(function(char)
            task.wait(0.1)
            if self.Enabled then createHighlight(char) end
        end)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do addHighlight(player) end
    Players.PlayerAdded:Connect(function(player) if self.Enabled then addHighlight(player) end end)
end

function Features.ESP:Stop()
    self.Enabled = false
    for _, highlight in pairs(self.Items) do if highlight then pcall(function() highlight:Destroy() end) end end
    self.Items = {}
end

-- Auto Play
local autoPlayAngle = 0
local autoPlaySmooth = 0

RunService.Heartbeat:Connect(function(dt)
    if not Features.AutoPlay.Enabled then return end
    local ball = GetBall()
    if not ball or not ball.Parent then return end
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not HRP then return end
    
    local ballPos = ball.Position
    autoPlayAngle = autoPlayAngle + dt * 1.5
    autoPlaySmooth = autoPlaySmooth + (autoPlayAngle - autoPlaySmooth) * 0.1
    
    local targetPos
    local style = Features.AutoPlay.Style
    
    if style == "Aggressive" then
        local dist = (HRP.Position - ballPos).Magnitude
        if dist > 12 then targetPos = ballPos
        else targetPos = ballPos + Vector3.new(math.cos(autoPlaySmooth) * 8, 0, math.sin(autoPlaySmooth) * 8) end
    elseif style == "Defensive" then
        targetPos = ballPos + Vector3.new(math.cos(autoPlaySmooth) * 28, 0, math.sin(autoPlaySmooth) * 28)
    else
        targetPos = ballPos + Vector3.new(math.cos(autoPlaySmooth) * 16, 0, math.sin(autoPlaySmooth) * 16)
    end
    
    if targetPos then Humanoid:MoveTo(targetPos) end
end)

-- Speed/Jump
function Features.Speed:Start()
    if self.Enabled then return end
    self.Enabled = true
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = self.Value end
end
function Features.Speed:Stop()
    self.Enabled = false
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = 16 end
end
function Features.Speed:Update()
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid and self.Enabled then humanoid.WalkSpeed = self.Value end
end

function Features.Jump:Start()
    if self.Enabled then return end
    self.Enabled = true
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.JumpPower = self.Value end
end
function Features.Jump:Stop()
    self.Enabled = false
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.JumpPower = 50 end
end
function Features.Jump:Update()
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid and self.Enabled then humanoid.JumpPower = self.Value end
end

-- Infinite Jump
function Features.InfiniteJump:Start()
    if self.Enabled then return end
    self.Enabled = true
    self.Connection = UserInputService.JumpRequest:Connect(function()
        if self.Enabled then
            local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end
function Features.InfiniteJump:Stop()
    self.Enabled = false
    if self.Connection then self.Connection:Disconnect() self.Connection = nil end
end

-- Anti-AFK
Player.Idled:Connect(function()
    if Features.AntiAFK.Enabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Character respawn
Player.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Features.Speed.Enabled then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = Features.Speed.Value end
    end
    if Features.Jump.Enabled then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpPower = Features.Jump.Value end
    end
end)

-- ========================================
-- CREATE TABS
-- ========================================

local MainTab = CreateTab("Main", "[M]")
local PlayTab = CreateTab("Play", "[P]")
local ESPTab = CreateTab("ESP", "[E]")
local MiscTab = CreateTab("Misc", "[+]")

-- MAIN TAB
local CombatSection = MainTab:AddSection("Combat")
CombatSection:AddToggle({Title = "Auto Parry", Default = false, Callback = function(state) if state then Features.AutoParry:Start() else Features.AutoParry:Stop() end end})
CombatSection:AddSlider({Title = "Parry Timing", Min = 25, Max = 150, Default = 75, Callback = function(value) Features.AutoParry:SetDistance(value / 100) end})
CombatSection:AddToggle({Title = "Manual Spam", Default = false, Callback = function(state) if state then Features.ManualSpam:Start() else Features.ManualSpam:Stop() end end})

-- PLAY TAB
local MovementSection = PlayTab:AddSection("Movement")
MovementSection:AddToggle({Title = "Speed Boost", Default = false, Callback = function(state) if state then Features.Speed:Start() else Features.Speed:Stop() end end})
MovementSection:AddSlider({Title = "Speed Value", Min = 16, Max = 100, Default = 50, Callback = function(value) Features.Speed.Value = value Features.Speed:Update() end})
MovementSection:AddToggle({Title = "Jump Boost", Default = false, Callback = function(state) if state then Features.Jump:Start() else Features.Jump:Stop() end end})
MovementSection:AddSlider({Title = "Jump Power", Min = 50, Max = 200, Default = 100, Callback = function(value) Features.Jump.Value = value Features.Jump:Update() end})
MovementSection:AddToggle({Title = "Infinite Jump", Default = false, Callback = function(state) if state then Features.InfiniteJump:Start() else Features.InfiniteJump:Stop() end end})

local AutoSection = PlayTab:AddSection("Auto Play")
AutoSection:AddToggle({Title = "Auto Play", Default = false, Callback = function(state) Features.AutoPlay.Enabled = state end})
AutoSection:AddDropdown({Title = "Play Style", Options = {"Aggressive", "Balanced", "Defensive"}, Default = "Balanced", Callback = function(value) Features.AutoPlay.Style = value end})

-- ESP TAB
local ESPSection = ESPTab:AddSection("ESP Options")
ESPSection:AddToggle({Title = "Ball ESP", Default = false, Callback = function(state) if state then Features.BallESP:Start() else Features.BallESP:Stop() end end})
ESPSection:AddToggle({Title = "Player ESP", Default = false, Callback = function(state) if state then Features.ESP:Start() else Features.ESP:Stop() end end})
ESPSection:AddButton({Title = "Refresh All ESP", Callback = function()
    if Features.ESP.Enabled then Features.ESP:Stop() task.wait(0.1) Features.ESP:Start() end
    if Features.BallESP.Enabled then Features.BallESP:Stop() task.wait(0.1) Features.BallESP:Start() end
end})

-- MISC TAB
local UtilSection = MiscTab:AddSection("Utility")
UtilSection:AddToggle({Title = "Anti-AFK", Default = true, Callback = function(state) Features.AntiAFK.Enabled = state end})
UtilSection:AddButton({Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, Player) end})

-- Notification
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Reaper Hub",
        Text = "Loaded! 3D Animations enabled.",
        Duration = 3
    })
end)

print("========================================")
print("[R] REAPER HUB | BLADEBALL v2.0")
print("[+] 3D Tab Animations")
print("[+] Glassmorphic Design")
print("[+] Your Original Auto Parry")
print("[+] Mobile + PC Support")
print("========================================")
