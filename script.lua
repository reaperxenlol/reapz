-- ========================================
-- REAPER HUB | BLADEBALL
-- Modern Futuristic Design
-- ========================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

-- Modern Color Scheme
local Colors = {
    Background = Color3.fromRGB(12, 12, 15),
    Card = Color3.fromRGB(18, 18, 22),
    CardHover = Color3.fromRGB(25, 25, 30),
    Sidebar = Color3.fromRGB(15, 15, 18),
    Border = Color3.fromRGB(40, 40, 50),
    Accent = Color3.fromRGB(99, 102, 241), -- Purple/Indigo
    AccentGlow = Color3.fromRGB(129, 132, 255),
    Success = Color3.fromRGB(34, 197, 94),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(140, 140, 160),
    TextMuted = Color3.fromRGB(80, 80, 100)
}

local function Tween(obj, props, time, style, dir)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function CreateShadow(parent, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Size = UDim2.new(1, size or 40, 1, size or 40)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    return shadow
end

-- ========================================
-- GUI LIBRARY
-- ========================================

local Library = {}

function Library:CreateWindow(config)
    local Window = {Tabs = {}, CurrentTab = nil}
    
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
    MinimizedPill.BorderSizePixel = 0
    MinimizedPill.Position = UDim2.new(0.5, -120, 0, 15)
    MinimizedPill.Size = UDim2.new(0, 240, 0, 45)
    MinimizedPill.Visible = false
    MinimizedPill.Active = true
    MinimizedPill.Draggable = false
    
    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(0, 25)
    pillCorner.Parent = MinimizedPill
    
    local pillStroke = Instance.new("UIStroke")
    pillStroke.Color = Colors.Accent
    pillStroke.Thickness = 2
    pillStroke.Transparency = 0.5
    pillStroke.Parent = MinimizedPill
    
    CreateShadow(MinimizedPill, 30)
    
    -- Pill glow effect
    local pillGlow = Instance.new("Frame")
    pillGlow.Parent = MinimizedPill
    pillGlow.BackgroundColor3 = Colors.Accent
    pillGlow.BackgroundTransparency = 0.9
    pillGlow.Size = UDim2.new(1, 0, 1, 0)
    pillGlow.ZIndex = 0
    
    local pillGlowCorner = Instance.new("UICorner")
    pillGlowCorner.CornerRadius = UDim.new(0, 25)
    pillGlowCorner.Parent = pillGlow
    
    local pillIcon = Instance.new("TextLabel")
    pillIcon.Parent = MinimizedPill
    pillIcon.BackgroundTransparency = 1
    pillIcon.Position = UDim2.new(0, 18, 0, 0)
    pillIcon.Size = UDim2.new(0, 25, 1, 0)
    pillIcon.Font = Enum.Font.GothamBold
    pillIcon.Text = "⚔"
    pillIcon.TextColor3 = Colors.Accent
    pillIcon.TextSize = 18
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
    
    -- FIXED: Pill dragging
    local draggingPill = false
    local pillDragStart = nil
    local pillStartPos = nil
    
    pillButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingPill = true
            pillDragStart = input.Position
            pillStartPos = MinimizedPill.Position
        end
    end)
    
    pillButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and draggingPill then
            local delta = input.Position - pillDragStart
            MinimizedPill.Position = UDim2.new(
                pillStartPos.X.Scale,
                pillStartPos.X.Offset + delta.X,
                pillStartPos.Y.Scale,
                pillStartPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingPill = false
        end
    end)
    
    -- Pill hover effect
    pillButton.MouseEnter:Connect(function()
        Tween(MinimizedPill, {BackgroundColor3 = Colors.CardHover}, 0.2)
        Tween(pillStroke, {Transparency = 0}, 0.2)
        Tween(pillGlow, {BackgroundTransparency = 0.8}, 0.2)
    end)
    
    pillButton.MouseLeave:Connect(function()
        Tween(MinimizedPill, {BackgroundColor3 = Colors.Card}, 0.2)
        Tween(pillStroke, {Transparency = 0.5}, 0.2)
        Tween(pillGlow, {BackgroundTransparency = 0.9}, 0.2)
    end)
    
    -- =====================
    -- MAIN WINDOW
    -- =====================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -180)
    MainFrame.Size = UDim2.new(0, 500, 0, 360)
    MainFrame.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Colors.Border
    mainStroke.Thickness = 1
    mainStroke.Parent = MainFrame
    
    CreateShadow(MainFrame, 60)
    
    -- =====================
    -- TITLE BAR
    -- =====================
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Colors.Sidebar
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = TitleBar
    
    -- Fix bottom corners
    local titleFix = Instance.new("Frame")
    titleFix.Parent = TitleBar
    titleFix.BackgroundColor3 = Colors.Sidebar
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 1, -12)
    titleFix.Size = UDim2.new(1, 0, 0, 12)
    
    -- Accent line under title
    local accentLine = Instance.new("Frame")
    accentLine.Parent = TitleBar
    accentLine.BackgroundColor3 = Colors.Accent
    accentLine.BorderSizePixel = 0
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    
    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.Accent),
        ColorSequenceKeypoint.new(0.5, Colors.AccentGlow),
        ColorSequenceKeypoint.new(1, Colors.Accent)
    })
    accentGradient.Parent = accentLine
    
    -- Title icon with glow
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
    titleIcon.Text = "⚔"
    titleIcon.TextColor3 = Colors.Accent
    titleIcon.TextSize = 16
    
    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = TitleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 55, 0, 8)
    titleLabel.Size = UDim2.new(1, -120, 0, 18)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = config.Title or "Reaper Hub | Bladeball"
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Parent = TitleBar
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Position = UDim2.new(0, 55, 0, 26)
    subtitleLabel.Size = UDim2.new(1, -120, 0, 14)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.Text = config.SubTitle or "v1.0"
    subtitleLabel.TextColor3 = Colors.TextMuted
    subtitleLabel.TextSize = 11
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Window controls
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Parent = TitleBar
    minimizeBtn.BackgroundColor3 = Colors.Card
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Position = UDim2.new(1, -45, 0.5, -12)
    minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Colors.TextDim
    minimizeBtn.TextSize = 18
    minimizeBtn.AutoButtonColor = false
    
    local minimizeBtnCorner = Instance.new("UICorner")
    minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
    minimizeBtnCorner.Parent = minimizeBtn
    
    minimizeBtn.MouseEnter:Connect(function()
        Tween(minimizeBtn, {BackgroundColor3 = Colors.Accent, TextColor3 = Colors.Text}, 0.15)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        Tween(minimizeBtn, {BackgroundColor3 = Colors.Card, TextColor3 = Colors.TextDim}, 0.15)
    end)
    
    -- Minimize/Restore functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 0), Position = UDim2.new(0.5, -250, 0.5, 0)}, 0.35)
        task.wait(0.35)
        MainFrame.Visible = false
        MinimizedPill.Visible = true
        MinimizedPill.Size = UDim2.new(0, 0, 0, 45)
        Tween(MinimizedPill, {Size = UDim2.new(0, 240, 0, 45)}, 0.35)
    end)
    
    pillButton.MouseButton1Click:Connect(function()
        if not draggingPill or (pillDragStart and (pillDragStart - UserInputService:GetMouseLocation()).Magnitude < 5) then
            Tween(MinimizedPill, {Size = UDim2.new(0, 0, 0, 45)}, 0.35)
            task.wait(0.35)
            MinimizedPill.Visible = false
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 500, 0, 0)
            MainFrame.Position = UDim2.new(0.5, -250, 0.5, 0)
            Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 360), Position = UDim2.new(0.5, -250, 0.5, -180)}, 0.35)
        end
    end)
    
    -- =====================
    -- SIDEBAR
    -- =====================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 130, 1, -50)
    
    local sidebarLine = Instance.new("Frame")
    sidebarLine.Parent = Sidebar
    sidebarLine.BackgroundColor3 = Colors.Border
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
    
    -- Make window draggable
    local dragging = false
    local dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- =====================
    -- ADD TAB FUNCTION
    -- =====================
    function Window:AddTab(config)
        local Tab = {Name = config.Title, Sections = {}}
        
        -- Tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = config.Title
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
        
        -- Active indicator
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
        
        -- Tab icon
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Parent = tabBtn
        tabIcon.BackgroundTransparency = 1
        tabIcon.Position = UDim2.new(0, 12, 0, 0)
        tabIcon.Size = UDim2.new(0, 20, 1, 0)
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.Text = config.Icon or "◆"
        tabIcon.TextColor3 = Colors.TextMuted
        tabIcon.TextSize = 14
        
        -- Tab text
        local tabText = Instance.new("TextLabel")
        tabText.Parent = tabBtn
        tabText.BackgroundTransparency = 1
        tabText.Position = UDim2.new(0, 38, 0, 0)
        tabText.Size = UDim2.new(1, -45, 1, 0)
        tabText.Font = Enum.Font.GothamSemibold
        tabText.Text = config.Title
        tabText.TextColor3 = Colors.TextMuted
        tabText.TextSize = 12
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Tab content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = config.Title .. "_Content"
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
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.Parent = tabContent
        contentPadding.PaddingRight = UDim.new(0, 8)
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 15)
        end)
        
        Tab.Button = tabBtn
        Tab.Content = tabContent
        Tab.Icon = tabIcon
        Tab.Text = tabText
        Tab.Indicator = activeIndicator
        
        tabBtn.MouseButton1Click:Connect(function()
            Window:SwitchTab(Tab)
        end)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.7}, 0.15)
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            Window:SwitchTab(Tab)
        end
        
        -- =====================
        -- ADD SECTION
        -- =====================
        function Tab:AddSection(title)
            local Section = {}
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = "Section_" .. title
            sectionFrame.Parent = tabContent
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.Parent = sectionFrame
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 8)
            
            -- Section header
            local sectionHeader = Instance.new("Frame")
            sectionHeader.Parent = sectionFrame
            sectionHeader.BackgroundTransparency = 1
            sectionHeader.Size = UDim2.new(1, 0, 0, 25)
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Parent = sectionHeader
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Size = UDim2.new(1, 0, 1, 0)
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.Text = title
            sectionTitle.TextColor3 = Colors.Text
            sectionTitle.TextSize = 13
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            Section.Frame = sectionFrame
            
            -- =====================
            -- ADD TOGGLE
            -- =====================
            function Section:AddToggle(config)
                local Toggle = {State = config.Default or false}
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Parent = sectionFrame
                toggleFrame.BackgroundColor3 = Colors.Card
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
                
                -- Modern toggle switch
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
                
                -- Knob shadow
                local knobShadow = Instance.new("ImageLabel")
                knobShadow.Parent = knob
                knobShadow.BackgroundTransparency = 1
                knobShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
                knobShadow.AnchorPoint = Vector2.new(0.5, 0.5)
                knobShadow.Size = UDim2.new(1, 10, 1, 10)
                knobShadow.ZIndex = -1
                knobShadow.Image = "rbxassetid://6014261993"
                knobShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                knobShadow.ImageTransparency = 0.7
                knobShadow.ScaleType = Enum.ScaleType.Slice
                knobShadow.SliceCenter = Rect.new(49, 49, 450, 450)
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Parent = toggleFrame
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Size = UDim2.new(1, 0, 1, 0)
                toggleBtn.Text = ""
                
                toggleBtn.MouseButton1Click:Connect(function()
                    Toggle.State = not Toggle.State
                    Tween(switchBg, {BackgroundColor3 = Toggle.State and Colors.Success or Colors.Border}, 0.25)
                    Tween(knob, {Position = Toggle.State and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}, 0.25)
                    if config.Callback then
                        pcall(config.Callback, Toggle.State)
                    end
                end)
                
                toggleBtn.MouseEnter:Connect(function()
                    Tween(toggleFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
                    Tween(toggleStroke, {Transparency = 0}, 0.15)
                end)
                
                toggleBtn.MouseLeave:Connect(function()
                    Tween(toggleFrame, {BackgroundColor3 = Colors.Card}, 0.15)
                    Tween(toggleStroke, {Transparency = 0.5}, 0.15)
                end)
                
                return Toggle
            end
            
            -- =====================
            -- ADD SLIDER
            -- =====================
            function Section:AddSlider(config)
                local Slider = {Value = config.Default or config.Min or 0}
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Parent = sectionFrame
                sliderFrame.BackgroundColor3 = Colors.Card
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Size = UDim2.new(1, 0, 0, 60)
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 10)
                sliderCorner.Parent = sliderFrame
                
                local sliderStroke = Instance.new("UIStroke")
                sliderStroke.Color = Colors.Border
                sliderStroke.Thickness = 1
                sliderStroke.Transparency = 0.5
                sliderStroke.Parent = sliderFrame
                
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
                
                -- Slider track
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
                
                -- Slider knob
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
                
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local min = config.Min or 0
                    local max = config.Max or 100
                    Slider.Value = math.floor(min + (max - min) * pos)
                    valueLabel.Text = tostring(Slider.Value)
                    Tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                    Tween(sliderKnob, {Position = UDim2.new(pos, 0, 0.5, 0)}, 0.05)
                    if config.Callback then
                        pcall(config.Callback, Slider.Value)
                    end
                end
                
                local draggingSlider = false
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = true
                        updateSlider(input)
                    end
                end)
                
                sliderBg.InputChanged:Connect(function(input)
                    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = false
                    end
                end)
                
                -- Set initial
                local initialPos = (Slider.Value - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0))
                sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
                sliderKnob.Position = UDim2.new(initialPos, 0, 0.5, 0)
                
                return Slider
            end
            
            -- =====================
            -- ADD BUTTON
            -- =====================
            function Section:AddButton(config)
                local buttonFrame = Instance.new("TextButton")
                buttonFrame.Parent = sectionFrame
                buttonFrame.BackgroundColor3 = Colors.Card
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
                
                local buttonStroke = Instance.new("UIStroke")
                buttonStroke.Color = Colors.Border
                buttonStroke.Thickness = 1
                buttonStroke.Transparency = 0.5
                buttonStroke.Parent = buttonFrame
                
                buttonFrame.MouseButton1Click:Connect(function()
                    -- Click animation
                    Tween(buttonFrame, {BackgroundColor3 = Colors.Accent}, 0.1)
                    task.wait(0.1)
                    Tween(buttonFrame, {BackgroundColor3 = Colors.CardHover}, 0.1)
                    if config.Callback then
                        pcall(config.Callback)
                    end
                end)
                
                buttonFrame.MouseEnter:Connect(function()
                    Tween(buttonFrame, {BackgroundColor3 = Colors.CardHover}, 0.15)
                    Tween(buttonStroke, {Transparency = 0, Color = Colors.Accent}, 0.15)
                end)
                
                buttonFrame.MouseLeave:Connect(function()
                    Tween(buttonFrame, {BackgroundColor3 = Colors.Card}, 0.15)
                    Tween(buttonStroke, {Transparency = 0.5, Color = Colors.Border}, 0.15)
                end)
            end
            
            table.insert(Tab.Sections, Section)
            return Section
        end
        
        return Tab
    end
    
    -- =====================
    -- SWITCH TAB
    -- =====================
    function Window:SwitchTab(tab)
        for _, t in ipairs(self.Tabs) do
            t.Content.Visible = false
            t.Indicator.Visible = false
            Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
            Tween(t.Icon, {TextColor3 = Colors.TextMuted}, 0.2)
            Tween(t.Text, {TextColor3 = Colors.TextMuted}, 0.2)
        end
        
        tab.Content.Visible = true
        tab.Indicator.Visible = true
        self.CurrentTab = tab
        Tween(tab.Button, {BackgroundTransparency = 0}, 0.2)
        Tween(tab.Icon, {TextColor3 = Colors.Accent}, 0.2)
        Tween(tab.Text, {TextColor3 = Colors.Text}, 0.2)
    end
    
    return Window
end

-- ========================================
-- IMPROVED FEATURES
-- ========================================

local Features = {
    AutoParry = {Enabled = false, Connection = nil, Distance = 0.75},
    ManualSpam = {Enabled = false},
    ESP = {Enabled = false, Highlights = {}, Connections = {}},
    BallESP = {Enabled = false, Highlight = nil, Connection = nil},
    Speed = {Enabled = false, Value = 50},
    Jump = {Enabled = false, Value = 100},
    Fullbright = {Enabled = false},
    NoFog = {Enabled = false},
    InfiniteJump = {Enabled = false, Connection = nil}
}

-- ========================================
-- IMPROVED AUTO PARRY WITH CLASH DETECTION
-- ========================================
function Features.AutoParry:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local Cooldown = tick()
    local Parried = false
    local LastTarget = nil
    
    local function GetBall()
        for _, Ball in ipairs(workspace.Balls:GetChildren()) do
            if Ball:GetAttribute("realBall") then
                return Ball
            end
        end
    end
    
    local function GetBallSpeed(ball)
        if ball:FindFirstChild("zoomies") and ball.zoomies:FindFirstChild("VectorVelocity") then
            return ball.zoomies.VectorVelocity.Magnitude
        end
        return 0
    end
    
    local function GetBallTarget(ball)
        return ball:GetAttribute("target")
    end
    
    local function IsClashing(ball)
        -- Check if ball is in clash state (multiple targets or special attribute)
        local target = GetBallTarget(ball)
        if target == nil or target == "" then
            return true -- No target means potential clash
        end
        return false
    end
    
    local function Parry()
        task.spawn(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
    end
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        local Ball = GetBall()
        local Character = Player.Character
        local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
        
        if not Ball or not HRP then return end
        
        local BallSpeed = GetBallSpeed(Ball)
        local Distance = (HRP.Position - Ball.Position).Magnitude
        local Target = GetBallTarget(Ball)
        local TimeToHit = Distance / math.max(BallSpeed, 1)
        
        -- Reset parry flag when target changes
        if Target ~= LastTarget then
            Parried = false
            LastTarget = Target
        end
        
        -- Check if we should parry
        local shouldParry = false
        
        -- Normal parry when targeted
        if Target == Player.Name and not Parried then
            if TimeToHit <= self.Distance then
                shouldParry = true
            end
        end
        
        -- Clash detection - parry when ball is close and has no target or we're in clash
        if IsClashing(Ball) and not Parried then
            if Distance <= 25 and TimeToHit <= 0.3 then
                shouldParry = true
            end
        end
        
        -- Also check if ball is very close regardless of target (for clash situations)
        if Distance <= 15 and TimeToHit <= 0.2 and not Parried then
            shouldParry = true
        end
        
        if shouldParry and (tick() - Cooldown) >= 0.15 then
            Parry()
            Parried = true
            Cooldown = tick()
        end
        
        -- Reset parry after cooldown
        if Parried and (tick() - Cooldown) >= 0.4 then
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

-- FIXED Player ESP
function Features.ESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function addHighlight(player)
        if player == Player then return end
        
        local function createHighlight(char)
            if not char then return end
            if self.Highlights[player] then
                self.Highlights[player]:Destroy()
            end
            
            local highlight = Instance.new("Highlight")
            highlight.Parent = char
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            self.Highlights[player] = highlight
        end
        
        if player.Character then
            createHighlight(player.Character)
        end
        
        local conn = player.CharacterAdded:Connect(function(char)
            task.wait(0.1)
            if self.Enabled then
                createHighlight(char)
            end
        end)
        table.insert(self.Connections, conn)
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        addHighlight(player)
    end
    
    local playerAddedConn = Players.PlayerAdded:Connect(function(player)
        if self.Enabled then
            addHighlight(player)
        end
    end)
    table.insert(self.Connections, playerAddedConn)
end

function Features.ESP:Stop()
    self.Enabled = false
    for _, highlight in pairs(self.Highlights) do
        if highlight then highlight:Destroy() end
    end
    self.Highlights = {}
    for _, conn in ipairs(self.Connections) do
        if conn then conn:Disconnect() end
    end
    self.Connections = {}
end

-- FIXED Ball ESP
function Features.BallESP:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local function updateBallHighlight()
        if self.Highlight then
            self.Highlight:Destroy()
            self.Highlight = nil
        end
        
        for _, Ball in ipairs(workspace.Balls:GetChildren()) do
            if Ball:GetAttribute("realBall") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = Ball
                highlight.FillColor = Color3.fromRGB(0, 200, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
                self.Highlight = highlight
                break
            end
        end
    end
    
    updateBallHighlight()
    
    -- Watch for new balls
    self.Connection = workspace.Balls.ChildAdded:Connect(function(child)
        task.wait(0.1)
        if self.Enabled then
            updateBallHighlight()
        end
    end)
end

function Features.BallESP:Stop()
    self.Enabled = false
    if self.Highlight then
        self.Highlight:Destroy()
        self.Highlight = nil
    end
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

-- Speed
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

-- Jump
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

-- Fullbright
function Features.Fullbright:Start()
    if self.Enabled then return end
    self.Enabled = true
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end

function Features.Fullbright:Stop()
    self.Enabled = false
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(127, 127, 127)
end

-- No Fog
function Features.NoFog:Start()
    if self.Enabled then return end
    self.Enabled = true
    Lighting.FogEnd = 100000
end

function Features.NoFog:Stop()
    self.Enabled = false
    Lighting.FogEnd = 1000
end

-- Infinite Jump
function Features.InfiniteJump:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    self.Connection = UserInputService.JumpRequest:Connect(function()
        if self.Enabled then
            local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
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
-- CREATE GUI
-- ========================================

local Window = Library:CreateWindow({
    Title = "Reaper Hub | Bladeball",
    SubTitle = "v1.0 • Modern"
})

-- MAIN TAB
local MainTab = Window:AddTab({Title = "Main", Icon = "⚔"})

local CombatSection = MainTab:AddSection("Combat")

CombatSection:AddToggle({
    Title = "Auto Parry",
    Default = false,
    Callback = function(state)
        if state then Features.AutoParry:Start() else Features.AutoParry:Stop() end
    end
})

CombatSection:AddSlider({
    Title = "Parry Timing",
    Min = 20,
    Max = 150,
    Default = 75,
    Callback = function(value)
        Features.AutoParry.Distance = value / 100
    end
})

CombatSection:AddToggle({
    Title = "Manual Spam",
    Default = false,
    Callback = function(state)
        if state then Features.ManualSpam:Start() else Features.ManualSpam:Stop() end
    end
})

-- PLAY TAB
local PlayTab = Window:AddTab({Title = "Play", Icon = "▶"})

local MovementSection = PlayTab:AddSection("Movement")

MovementSection:AddToggle({
    Title = "Speed Boost",
    Default = false,
    Callback = function(state)
        if state then Features.Speed:Start() else Features.Speed:Stop() end
    end
})

MovementSection:AddSlider({
    Title = "Speed Value",
    Min = 16,
    Max = 100,
    Default = 50,
    Callback = function(value)
        Features.Speed.Value = value
        Features.Speed:Update()
    end
})

MovementSection:AddToggle({
    Title = "Jump Boost",
    Default = false,
    Callback = function(state)
        if state then Features.Jump:Start() else Features.Jump:Stop() end
    end
})

MovementSection:AddSlider({
    Title = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 100,
    Callback = function(value)
        Features.Jump.Value = value
        Features.Jump:Update()
    end
})

MovementSection:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(state)
        if state then Features.InfiniteJump:Start() else Features.InfiniteJump:Stop() end
    end
})

local VisualsSection = PlayTab:AddSection("Visuals")

VisualsSection:AddToggle({
    Title = "Fullbright",
    Default = false,
    Callback = function(state)
        if state then Features.Fullbright:Start() else Features.Fullbright:Stop() end
    end
})

VisualsSection:AddToggle({
    Title = "No Fog",
    Default = false,
    Callback = function(state)
        if state then Features.NoFog:Start() else Features.NoFog:Stop() end
    end
})

-- ESP TAB
local ESPTab = Window:AddTab({Title = "ESP", Icon = "👁"})

local ESPSection = ESPTab:AddSection("ESP Options")

ESPSection:AddToggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(state)
        if state then Features.ESP:Start() else Features.ESP:Stop() end
    end
})

ESPSection:AddToggle({
    Title = "Ball ESP",
    Default = false,
    Callback = function(state)
        if state then Features.BallESP:Start() else Features.BallESP:Stop() end
    end
})

ESPSection:AddButton({
    Title = "Refresh All ESP",
    Callback = function()
        if Features.ESP.Enabled then
            Features.ESP:Stop()
            task.wait(0.1)
            Features.ESP:Start()
        end
        if Features.BallESP.Enabled then
            Features.BallESP:Stop()
            task.wait(0.1)
            Features.BallESP:Start()
        end
    end
})

print("========================================")
print("⚔ REAPER HUB | BLADEBALL")
print("✓ Modern Futuristic UI Loaded")
print("✓ Improved Auto Parry with Clash")
print("========================================")
