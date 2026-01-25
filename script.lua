-- ========================================
-- REAPER HUB | BLADEBALL
-- ========================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

-- ========================================
-- GUI LIBRARY
-- ========================================

local Library = {}

function Library:CreateWindow(config)
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Screen
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReaperHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- MINIMIZED PILL (Top bar)
    local MinimizedPill = Instance.new("Frame")
    MinimizedPill.Name = "MinimizedPill"
    MinimizedPill.Parent = ScreenGui
    MinimizedPill.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MinimizedPill.BorderSizePixel = 0
    MinimizedPill.Position = UDim2.new(0.5, -130, 0, 10)
    MinimizedPill.Size = UDim2.new(0, 260, 0, 35)
    MinimizedPill.Visible = false
    
    local pillCorner = Instance.new("UICorner")
    pillCorner.CornerRadius = UDim.new(0, 20)
    pillCorner.Parent = MinimizedPill
    
    local pillIcon = Instance.new("TextLabel")
    pillIcon.Parent = MinimizedPill
    pillIcon.BackgroundTransparency = 1
    pillIcon.Position = UDim2.new(0, 12, 0, 0)
    pillIcon.Size = UDim2.new(0, 25, 1, 0)
    pillIcon.Font = Enum.Font.GothamBold
    pillIcon.Text = "⚔"
    pillIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    pillIcon.TextSize = 16
    
    local pillText = Instance.new("TextLabel")
    pillText.Parent = MinimizedPill
    pillText.BackgroundTransparency = 1
    pillText.Position = UDim2.new(0, 40, 0, 0)
    pillText.Size = UDim2.new(1, -50, 1, 0)
    pillText.Font = Enum.Font.GothamBold
    pillText.Text = config.Title or "Reaper Hub | Bladeball"
    pillText.TextColor3 = Color3.fromRGB(255, 255, 255)
    pillText.TextSize = 13
    pillText.TextXAlignment = Enum.TextXAlignment.Left
    
    local pillButton = Instance.new("TextButton")
    pillButton.Parent = MinimizedPill
    pillButton.BackgroundTransparency = 1
    pillButton.Size = UDim2.new(1, 0, 1, 0)
    pillButton.Text = ""
    
    -- Make pill draggable
    local draggingPill = false
    local pillDragStart, pillStartPos
    
    MinimizedPill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingPill = true
            pillDragStart = input.Position
            pillStartPos = MinimizedPill.Position
        end
    end)
    
    MinimizedPill.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and draggingPill then
            local delta = input.Position - pillDragStart
            MinimizedPill.Position = UDim2.new(pillStartPos.X.Scale, pillStartPos.X.Offset + delta.X, pillStartPos.Y.Scale, pillStartPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingPill = false
        end
    end)
    
    -- MAIN WINDOW
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = TitleBar
    
    -- Fix bottom corners of title bar
    local titleFix = Instance.new("Frame")
    titleFix.Parent = TitleBar
    titleFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleFix.BorderSizePixel = 0
    titleFix.Position = UDim2.new(0, 0, 1, -10)
    titleFix.Size = UDim2.new(1, 0, 0, 10)
    
    -- Title icon
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Parent = TitleBar
    titleIcon.BackgroundTransparency = 1
    titleIcon.Position = UDim2.new(0, 15, 0, 0)
    titleIcon.Size = UDim2.new(0, 30, 1, 0)
    titleIcon.Font = Enum.Font.GothamBold
    titleIcon.Text = "⚔"
    titleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleIcon.TextSize = 18
    
    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = TitleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 45, 0, 5)
    titleLabel.Size = UDim2.new(1, -100, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = config.Title or "Reaper Hub | Bladeball"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Subtitle
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Parent = TitleBar
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Position = UDim2.new(0, 45, 0, 24)
    subtitleLabel.Size = UDim2.new(1, -100, 0, 15)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.Text = config.SubTitle or "Reaper Hub"
    subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitleLabel.TextSize = 11
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Minimize button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Parent = TitleBar
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Position = UDim2.new(1, -35, 0.5, -10)
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    minimizeBtn.TextSize = 20
    
    minimizeBtn.MouseEnter:Connect(function()
        Tween(minimizeBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        Tween(minimizeBtn, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.15)
    end)
    
    -- Minimize/Restore
    minimizeBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        MainFrame.Visible = false
        MinimizedPill.Visible = true
        MinimizedPill.Size = UDim2.new(0, 0, 0, 35)
        Tween(MinimizedPill, {Size = UDim2.new(0, 260, 0, 35)}, 0.3)
    end)
    
    pillButton.MouseButton1Click:Connect(function()
        Tween(MinimizedPill, {Size = UDim2.new(0, 0, 0, 35)}, 0.3)
        task.wait(0.3)
        MinimizedPill.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Tween(MainFrame, {Size = UDim2.new(0, 450, 0, 350)}, 0.3)
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 45)
    Sidebar.Size = UDim2.new(0, 120, 1, -45)
    
    local sidebarLine = Instance.new("Frame")
    sidebarLine.Parent = Sidebar
    sidebarLine.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    sidebarLine.BorderSizePixel = 0
    sidebarLine.Position = UDim2.new(1, -1, 0, 10)
    sidebarLine.Size = UDim2.new(0, 1, 1, -20)
    
    -- Tab buttons container
    local TabButtonsContainer = Instance.new("Frame")
    TabButtonsContainer.Name = "TabButtons"
    TabButtonsContainer.Parent = Sidebar
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.Position = UDim2.new(0, 0, 0, 10)
    TabButtonsContainer.Size = UDim2.new(1, 0, 1, -10)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = TabButtonsContainer
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    
    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 130, 0, 55)
    ContentArea.Size = UDim2.new(1, -140, 1, -65)
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
    
    -- Add Tab function
    function Window:AddTab(config)
        local Tab = {
            Name = config.Title,
            Sections = {}
        }
        
        -- Tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = config.Title
        tabBtn.Parent = TabButtonsContainer
        tabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Size = UDim2.new(1, -10, 0, 35)
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabBtn
        
        -- Tab icon
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Parent = tabBtn
        tabIcon.BackgroundTransparency = 1
        tabIcon.Position = UDim2.new(0, 10, 0, 0)
        tabIcon.Size = UDim2.new(0, 20, 1, 0)
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.Text = config.Icon or "◆"
        tabIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabIcon.TextSize = 14
        
        -- Tab text
        local tabText = Instance.new("TextLabel")
        tabText.Parent = tabBtn
        tabText.BackgroundTransparency = 1
        tabText.Position = UDim2.new(0, 35, 0, 0)
        tabText.Size = UDim2.new(1, -40, 1, 0)
        tabText.Font = Enum.Font.Gotham
        tabText.Text = config.Title
        tabText.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabText.TextSize = 12
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Tab content scroll
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = config.Title .. "_Content"
        tabContent.Parent = ContentArea
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        tabContent.Visible = false
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = tabContent
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        
        local contentPadding = Instance.new("UIPadding")
        contentPadding.Parent = tabContent
        contentPadding.PaddingRight = UDim.new(0, 5)
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        Tab.Button = tabBtn
        Tab.Content = tabContent
        Tab.Icon = tabIcon
        Tab.Text = tabText
        
        -- Tab click
        tabBtn.MouseButton1Click:Connect(function()
            Window:SwitchTab(Tab)
        end)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(tabBtn, {BackgroundTransparency = 0.5}, 0.15)
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
        
        -- Add Section function
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
            
            -- Section title
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Parent = sectionFrame
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Size = UDim2.new(1, 0, 0, 25)
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.Text = title
            sectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionTitle.TextSize = 14
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            Section.Frame = sectionFrame
            
            -- Add Toggle
            function Section:AddToggle(config)
                local Toggle = {State = config.Default or false}
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Parent = sectionFrame
                toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Size = UDim2.new(1, 0, 0, 40)
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 8)
                toggleCorner.Parent = toggleFrame
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Parent = toggleFrame
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Position = UDim2.new(0, 15, 0, 0)
                toggleLabel.Size = UDim2.new(1, -70, 1, 0)
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.Text = config.Title
                toggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                toggleLabel.TextSize = 13
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                -- Toggle switch background
                local switchBg = Instance.new("Frame")
                switchBg.Parent = toggleFrame
                switchBg.BackgroundColor3 = Toggle.State and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 60)
                switchBg.BorderSizePixel = 0
                switchBg.Position = UDim2.new(1, -55, 0.5, -10)
                switchBg.Size = UDim2.new(0, 40, 0, 20)
                
                local switchCorner = Instance.new("UICorner")
                switchCorner.CornerRadius = UDim.new(1, 0)
                switchCorner.Parent = switchBg
                
                -- Toggle knob
                local knob = Instance.new("Frame")
                knob.Parent = switchBg
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.Position = Toggle.State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                knob.Size = UDim2.new(0, 16, 0, 16)
                
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
                    Tween(switchBg, {BackgroundColor3 = Toggle.State and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(60, 60, 60)}, 0.2)
                    Tween(knob, {Position = Toggle.State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    if config.Callback then
                        pcall(config.Callback, Toggle.State)
                    end
                end)
                
                toggleBtn.MouseEnter:Connect(function()
                    Tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.15)
                end)
                
                toggleBtn.MouseLeave:Connect(function()
                    Tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.15)
                end)
                
                return Toggle
            end
            
            -- Add Slider
            function Section:AddSlider(config)
                local Slider = {Value = config.Default or config.Min or 0}
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Parent = sectionFrame
                sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Size = UDim2.new(1, 0, 0, 55)
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 8)
                sliderCorner.Parent = sliderFrame
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Parent = sliderFrame
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Position = UDim2.new(0, 15, 0, 8)
                sliderLabel.Size = UDim2.new(1, -70, 0, 18)
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.Text = config.Title
                sliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                sliderLabel.TextSize = 13
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Parent = sliderFrame
                valueLabel.BackgroundTransparency = 1
                valueLabel.Position = UDim2.new(1, -55, 0, 8)
                valueLabel.Size = UDim2.new(0, 40, 0, 18)
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.Text = tostring(Slider.Value)
                valueLabel.TextColor3 = Color3.fromRGB(80, 200, 120)
                valueLabel.TextSize = 12
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                
                -- Slider bar
                local sliderBg = Instance.new("Frame")
                sliderBg.Parent = sliderFrame
                sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                sliderBg.BorderSizePixel = 0
                sliderBg.Position = UDim2.new(0, 15, 0, 35)
                sliderBg.Size = UDim2.new(1, -30, 0, 6)
                
                local sliderBgCorner = Instance.new("UICorner")
                sliderBgCorner.CornerRadius = UDim.new(1, 0)
                sliderBgCorner.Parent = sliderBg
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Parent = sliderBg
                sliderFill.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                
                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(1, 0)
                sliderFillCorner.Parent = sliderFill
                
                local function updateSlider(input)
                    local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local min = config.Min or 0
                    local max = config.Max or 100
                    Slider.Value = math.floor(min + (max - min) * pos)
                    valueLabel.Text = tostring(Slider.Value)
                    Tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
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
                
                return Slider
            end
            
            -- Add Button
            function Section:AddButton(config)
                local buttonFrame = Instance.new("TextButton")
                buttonFrame.Parent = sectionFrame
                buttonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                buttonFrame.BorderSizePixel = 0
                buttonFrame.Size = UDim2.new(1, 0, 0, 40)
                buttonFrame.Font = Enum.Font.Gotham
                buttonFrame.Text = config.Title
                buttonFrame.TextColor3 = Color3.fromRGB(220, 220, 220)
                buttonFrame.TextSize = 13
                buttonFrame.AutoButtonColor = false
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 8)
                buttonCorner.Parent = buttonFrame
                
                buttonFrame.MouseButton1Click:Connect(function()
                    if config.Callback then
                        pcall(config.Callback)
                    end
                end)
                
                buttonFrame.MouseEnter:Connect(function()
                    Tween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.15)
                end)
                
                buttonFrame.MouseLeave:Connect(function()
                    Tween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.15)
                end)
            end
            
            table.insert(Tab.Sections, Section)
            return Section
        end
        
        return Tab
    end
    
    -- Switch Tab
    function Window:SwitchTab(tab)
        for _, t in ipairs(self.Tabs) do
            t.Content.Visible = false
            Tween(t.Button, {BackgroundTransparency = 1}, 0.15)
            Tween(t.Icon, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.15)
            Tween(t.Text, {TextColor3 = Color3.fromRGB(150, 150, 150)}, 0.15)
        end
        
        tab.Content.Visible = true
        self.CurrentTab = tab
        Tween(tab.Button, {BackgroundTransparency = 0}, 0.15)
        Tween(tab.Icon, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
        Tween(tab.Text, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
    end
    
    return Window
end

-- ========================================
-- FEATURES
-- ========================================

local Features = {
    AutoParry = {Enabled = false, Connection = nil, Distance = 0.75},
    ManualSpam = {Enabled = false},
    ESP = {Enabled = false, Highlights = {}},
    BallESP = {Enabled = false, Highlight = nil},
    Speed = {Enabled = false, Value = 50},
    Jump = {Enabled = false, Value = 100},
    Fullbright = {Enabled = false},
    NoFog = {Enabled = false},
    InfiniteJump = {Enabled = false, Connection = nil}
}

-- Auto Parry
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
        local char = player.Character
        if not char then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Parent = char
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        self.Highlights[player] = highlight
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            addHighlight(player)
        end
    end
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
    if humanoid then humanoid.WalkSpeed = self.Value end
end

function Features.Speed:Stop()
    self.Enabled = false
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = 16 end
end

function Features.Speed:Update()
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and self.Enabled then humanoid.WalkSpeed = self.Value end
end

-- Jump
function Features.Jump:Start()
    if self.Enabled then return end
    self.Enabled = true
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.JumpPower = self.Value end
end

function Features.Jump:Stop()
    self.Enabled = false
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then humanoid.JumpPower = 50 end
end

function Features.Jump:Update()
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Humanoid")
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
-- CREATE GUI
-- ========================================

local Window = Library:CreateWindow({
    Title = "Reaper Hub | Bladeball",
    SubTitle = "Reaper Hub"
})

-- MAIN TAB
local MainTab = Window:AddTab({Title = "Main", Icon = "◆"})

local CombatSection = MainTab:AddSection("Combat")

CombatSection:AddToggle({
    Title = "Auto Parry",
    Default = false,
    Callback = function(state)
        if state then Features.AutoParry:Start() else Features.AutoParry:Stop() end
    end
})

CombatSection:AddSlider({
    Title = "Parry Distance",
    Min = 25,
    Max = 200,
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
    Title = "Refresh ESP",
    Callback = function()
        Features.ESP:Stop()
        task.wait(0.1)
        Features.ESP:Start()
    end
})

print("========================================")
print("✓ REAPER HUB | BLADEBALL LOADED")
print("========================================")
