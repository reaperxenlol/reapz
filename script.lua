-- ========================================
-- BLADE BALL SCRIPT - CUSTOM GLASSMORPHIC UI
-- ========================================
-- Features:
-- ✓ Custom dark glassmorphic design
-- ✓ Movement enabled during auto-parry
-- ✓ Smooth animations and modern UI
-- ✓ High-quality GUI library
-- ========================================

-- CUSTOM GLASSMORPHIC GUI LIBRARY (EMBEDDED)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local GlassUI = {}
GlassUI.__index = GlassUI

-- Color palette
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    GlassBase = Color3.fromRGB(25, 25, 35),
    GlassHighlight = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(120, 100, 255),
    AccentHover = Color3.fromRGB(140, 120, 255),
    Text = Color3.fromRGB(240, 240, 250),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    Success = Color3.fromRGB(100, 255, 150),
    Danger = Color3.fromRGB(255, 100, 120),
    Border = Color3.fromRGB(60, 60, 80)
}

-- Utility tween function
local function Tween(instance, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

-- Create window
function GlassUI:CreateWindow(config)
    local self = setmetatable({}, GlassUI)
    
    config = config or {}
    self.Title = config.Title or "Glass UI"
    self.SubTitle = config.SubTitle or ""
    self.Size = config.Size or UDim2.fromOffset(600, 480)
    self.MinimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "GlassUI_" .. math.random(1000, 9999)
    self.ScreenGui.Parent = game.CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.BackgroundColor3 = Colors.GlassBase
    self.MainFrame.BackgroundTransparency = 0.2
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2)
    self.MainFrame.Size = self.Size
    self.MainFrame.ClipsDescendants = true
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = self.MainFrame
    
    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 1
    border.Transparency = 0.5
    border.Parent = self.MainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
    })
    gradient.Rotation = 45
    gradient.Parent = self.MainFrame
    
    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Parent = self.MainFrame
    self.TitleBar.BackgroundColor3 = Colors.GlassHighlight
    self.TitleBar.BackgroundTransparency = 0.3
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 50)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 16)
    titleCorner.Parent = self.TitleBar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = self.TitleBar
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 20, 0, 8)
    titleLabel.Size = UDim2.new(1, -100, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = Colors.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "SubTitle"
    subtitleLabel.Parent = self.TitleBar
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Position = UDim2.new(0, 20, 0, 28)
    subtitleLabel.Size = UDim2.new(1, -100, 0, 14)
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.Text = self.SubTitle
    subtitleLabel.TextColor3 = Colors.TextSecondary
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = self.TitleBar
    closeButton.BackgroundColor3 = Colors.Danger
    closeButton.BackgroundTransparency = 0.3
    closeButton.BorderSizePixel = 0
    closeButton.Position = UDim2.new(1, -40, 0.5, -12)
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "×"
    closeButton.TextColor3 = Colors.Text
    closeButton.TextSize = 18
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        Tween(self.MainFrame, {Size = UDim2.fromOffset(0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    closeButton.MouseEnter:Connect(function()
        Tween(closeButton, {BackgroundTransparency = 0.1, Size = UDim2.new(0, 26, 0, 26)}, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        Tween(closeButton, {BackgroundTransparency = 0.3, Size = UDim2.new(0, 24, 0, 24)}, 0.2)
    end)
    
    -- Tab container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Parent = self.MainFrame
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Position = UDim2.new(0, 0, 0, 60)
    self.TabContainer.Size = UDim2.new(0, 160, 1, -60)
    
    -- Content container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Position = UDim2.new(0, 170, 0, 60)
    self.ContentContainer.Size = UDim2.new(1, -180, 1, -70)
    self.ContentContainer.ClipsDescendants = true
    
    self.ContentScroll = Instance.new("ScrollingFrame")
    self.ContentScroll.Name = "ContentScroll"
    self.ContentScroll.Parent = self.ContentContainer
    self.ContentScroll.BackgroundTransparency = 1
    self.ContentScroll.BorderSizePixel = 0
    self.ContentScroll.Size = UDim2.new(1, 0, 1, 0)
    self.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentScroll.ScrollBarThickness = 4
    self.ContentScroll.ScrollBarImageColor3 = Colors.Accent
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = self.ContentScroll
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Make draggable
    self:MakeDraggable(self.TitleBar, self.MainFrame)
    
    -- Minimize
    self.IsMinimized = false
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == self.MinimizeKey then
            self:ToggleMinimize()
        end
    end)
    
    -- Entrance animation
    self.MainFrame.Size = UDim2.fromOffset(0, 0)
    Tween(self.MainFrame, {Size = self.Size}, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    self.Tabs = {}
    self.CurrentTab = nil
    
    return self
end

function GlassUI:MakeDraggable(handle, frame)
    local dragging, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
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
end

function GlassUI:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    
    if self.IsMinimized then
        Tween(self.MainFrame, {Size = UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 50)}, 0.3)
    else
        Tween(self.MainFrame, {Size = self.Size}, 0.3)
    end
end

function GlassUI:AddTab(config)
    config = config or {}
    local tabName = config.Title or "Tab"
    
    local tab = {}
    tab.Name = tabName
    tab.Elements = {}
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName
    tabButton.Parent = self.TabContainer
    tabButton.BackgroundColor3 = Colors.GlassHighlight
    tabButton.BackgroundTransparency = 0.5
    tabButton.BorderSizePixel = 0
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, #self.Tabs * 45)
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.Text = "  " .. tabName
    tabButton.TextColor3 = Colors.TextSecondary
    tabButton.TextSize = 14
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabButton
    
    tab.ContentFrame = Instance.new("Frame")
    tab.ContentFrame.Name = tabName .. "_Content"
    tab.ContentFrame.Parent = self.ContentScroll
    tab.ContentFrame.BackgroundTransparency = 1
    tab.ContentFrame.Size = UDim2.new(1, 0, 0, 0)
    tab.ContentFrame.Visible = false
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = tab.ContentFrame
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.ContentFrame.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(tabButton, {BackgroundTransparency = 0.3}, 0.2)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tab then
            Tween(tabButton, {BackgroundTransparency = 0.5}, 0.2)
        end
    end)
    
    tab.Button = tabButton
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SwitchTab(tab)
    end
    
    function tab:AddSection(title)
        local section = {}
        
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = "Section_" .. title
        sectionFrame.Parent = self.ContentFrame
        sectionFrame.BackgroundColor3 = Colors.GlassHighlight
        sectionFrame.BackgroundTransparency = 0.4
        sectionFrame.BorderSizePixel = 0
        sectionFrame.Size = UDim2.new(1, 0, 0, 40)
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 10)
        sectionCorner.Parent = sectionFrame
        
        local sectionBorder = Instance.new("UIStroke")
        sectionBorder.Color = Colors.Border
        sectionBorder.Thickness = 1
        sectionBorder.Transparency = 0.7
        sectionBorder.Parent = sectionFrame
        
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Parent = sectionFrame
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Position = UDim2.new(0, 15, 0, 0)
        sectionLabel.Size = UDim2.new(1, -30, 1, 0)
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.Text = title
        sectionLabel.TextColor3 = Colors.Accent
        sectionLabel.TextSize = 14
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        section.Frame = sectionFrame
        
        function section:AddParagraph(config)
            local paragraph = Instance.new("Frame")
            paragraph.Name = "Paragraph"
            paragraph.Parent = self.Frame.Parent
            paragraph.BackgroundColor3 = Colors.GlassBase
            paragraph.BackgroundTransparency = 0.3
            paragraph.BorderSizePixel = 0
            paragraph.Size = UDim2.new(1, 0, 0, 60)
            
            local paragraphCorner = Instance.new("UICorner")
            paragraphCorner.CornerRadius = UDim.new(0, 10)
            paragraphCorner.Parent = paragraph
            
            local paragraphLabel = Instance.new("TextLabel")
            paragraphLabel.Parent = paragraph
            paragraphLabel.BackgroundTransparency = 1
            paragraphLabel.Position = UDim2.new(0, 15, 0, 10)
            paragraphLabel.Size = UDim2.new(1, -30, 1, -20)
            paragraphLabel.Font = Enum.Font.Gotham
            paragraphLabel.Text = config.Title or "Paragraph"
            paragraphLabel.TextColor3 = Colors.Text
            paragraphLabel.TextSize = 13
            paragraphLabel.TextWrapped = true
            paragraphLabel.TextXAlignment = Enum.TextXAlignment.Left
            paragraphLabel.TextYAlignment = Enum.TextYAlignment.Top
        end
        
        return section
    end
    
    function tab:AddToggle(id, config)
        config = config or {}
        local toggleTitle = config.Title or "Toggle"
        local toggleDesc = config.Description or ""
        local toggleDefault = config.Default or false
        local toggleCallback = config.Callback or function() end
        
        local toggleState = toggleDefault
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_" .. id
        toggleFrame.Parent = self.ContentFrame
        toggleFrame.BackgroundColor3 = Colors.GlassBase
        toggleFrame.BackgroundTransparency = 0.3
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Size = UDim2.new(1, 0, 0, 70)
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleCorner.Parent = toggleFrame
        
        local toggleBorder = Instance.new("UIStroke")
        toggleBorder.Color = Colors.Border
        toggleBorder.Thickness = 1
        toggleBorder.Transparency = 0.7
        toggleBorder.Parent = toggleFrame
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Parent = toggleFrame
        titleLabel.BackgroundTransparency = 1
        titleLabel.Position = UDim2.new(0, 15, 0, 10)
        titleLabel.Size = UDim2.new(1, -80, 0, 20)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = toggleTitle
        titleLabel.TextColor3 = Colors.Text
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = toggleFrame
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 15, 0, 32)
        descLabel.Size = UDim2.new(1, -80, 0, 28)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = toggleDesc
        descLabel.TextColor3 = Colors.TextSecondary
        descLabel.TextSize = 11
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextYAlignment = Enum.TextYAlignment.Top
        
        local switchBg = Instance.new("Frame")
        switchBg.Name = "SwitchBg"
        switchBg.Parent = toggleFrame
        switchBg.BackgroundColor3 = toggleState and Colors.Success or Colors.TextSecondary
        switchBg.BackgroundTransparency = 0.3
        switchBg.BorderSizePixel = 0
        switchBg.Position = UDim2.new(1, -60, 0.5, -12)
        switchBg.Size = UDim2.new(0, 45, 0, 24)
        
        local switchCorner = Instance.new("UICorner")
        switchCorner.CornerRadius = UDim.new(1, 0)
        switchCorner.Parent = switchBg
        
        local switchKnob = Instance.new("Frame")
        switchKnob.Name = "SwitchKnob"
        switchKnob.Parent = switchBg
        switchKnob.BackgroundColor3 = Colors.Text
        switchKnob.BorderSizePixel = 0
        switchKnob.Position = toggleState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        switchKnob.Size = UDim2.new(0, 20, 0, 20)
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = switchKnob
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Parent = toggleFrame
        toggleButton.BackgroundTransparency = 1
        toggleButton.Size = UDim2.new(1, 0, 1, 0)
        toggleButton.Text = ""
        
        toggleButton.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            
            Tween(switchBg, {
                BackgroundColor3 = toggleState and Colors.Success or Colors.TextSecondary
            }, 0.3)
            
            Tween(switchKnob, {
                Position = toggleState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            }, 0.3, Enum.EasingStyle.Back)
            
            pcall(toggleCallback, toggleState)
        end)
        
        toggleButton.MouseEnter:Connect(function()
            Tween(toggleFrame, {BackgroundTransparency = 0.2}, 0.2)
            Tween(toggleBorder, {Transparency = 0.4}, 0.2)
        end)
        
        toggleButton.MouseLeave:Connect(function()
            Tween(toggleFrame, {BackgroundTransparency = 0.3}, 0.2)
            Tween(toggleBorder, {Transparency = 0.7}, 0.2)
        end)
        
        return {
            SetValue = function(value)
                toggleState = value
                Tween(switchBg, {
                    BackgroundColor3 = toggleState and Colors.Success or Colors.TextSecondary
                }, 0.3)
                Tween(switchKnob, {
                    Position = toggleState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                }, 0.3)
            end
        }
    end
    
    return tab
end

function GlassUI:SwitchTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.ContentFrame.Visible = false
        Tween(t.Button, {
            BackgroundTransparency = 0.5,
            TextColor3 = Colors.TextSecondary
        }, 0.2)
    end
    
    tab.ContentFrame.Visible = true
    self.CurrentTab = tab
    Tween(tab.Button, {
        BackgroundTransparency = 0.2,
        TextColor3 = Colors.Accent
    }, 0.2)
end

function GlassUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 5
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Parent = self.ScreenGui
    notifFrame.BackgroundColor3 = Colors.GlassBase
    notifFrame.BackgroundTransparency = 0.2
    notifFrame.BorderSizePixel = 0
    notifFrame.Position = UDim2.new(1, 10, 0, 10)
    notifFrame.Size = UDim2.new(0, 300, 0, 80)
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notifFrame
    
    local notifBorder = Instance.new("UIStroke")
    notifBorder.Color = Colors.Accent
    notifBorder.Thickness = 2
    notifBorder.Transparency = 0.5
    notifBorder.Parent = notifFrame
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Parent = notifFrame
    notifTitle.BackgroundTransparency = 1
    notifTitle.Position = UDim2.new(0, 15, 0, 10)
    notifTitle.Size = UDim2.new(1, -30, 0, 20)
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.Text = title
    notifTitle.TextColor3 = Colors.Text
    notifTitle.TextSize = 14
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local notifContent = Instance.new("TextLabel")
    notifContent.Parent = notifFrame
    notifContent.BackgroundTransparency = 1
    notifContent.Position = UDim2.new(0, 15, 0, 32)
    notifContent.Size = UDim2.new(1, -30, 1, -42)
    notifContent.Font = Enum.Font.Gotham
    notifContent.Text = content
    notifContent.TextColor3 = Colors.TextSecondary
    notifContent.TextSize = 12
    notifContent.TextWrapped = true
    notifContent.TextXAlignment = Enum.TextXAlignment.Left
    notifContent.TextYAlignment = Enum.TextYAlignment.Top
    
    Tween(notifFrame, {Position = UDim2.new(1, -310, 0, 10)}, 0.5, Enum.EasingStyle.Back)
    
    if duration then
        task.delay(duration, function()
            Tween(notifFrame, {Position = UDim2.new(1, 10, 0, 10)}, 0.3)
            task.wait(0.3)
            notifFrame:Destroy()
        end)
    end
end

-- ========================================
-- AUTO PARRY MODULE (MOVEMENT ENABLED)
-- ========================================

local AutoParryModule = {}
AutoParryModule.Enabled = false
AutoParryModule.Connection = nil

function AutoParryModule:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local parryDistance = 0.75
    local parryCooldown = 0.5
    
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    local Player = Players.LocalPlayer
    local Cooldown = tick()
    local Parried = false
    local Connection = nil
    
    local function GetBall()
        for _, Ball in ipairs(workspace.Balls:GetChildren()) do
            if Ball:GetAttribute("realBall") then
                return Ball
            end
        end
    end
    
    local function ResetConnection()
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
    end
    
    workspace.Balls.ChildAdded:Connect(function()
        local Ball = GetBall()
        if not Ball then return end
        ResetConnection()
        Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
            Parried = false
        end)
    end)
    
    -- MOVEMENT-ENABLED PARRY LOOP
    self.Connection = RunService.PreSimulation:Connect(function()
        if not self.Enabled then return end
        
        local Ball, HRP = GetBall(), Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not Ball or not HRP then
            return
        end
        
        local Speed = Ball.zoomies.VectorVelocity.Magnitude
        local Distance = (HRP.Position - Ball.Position).Magnitude
        
        if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= parryDistance then
            -- Use task.spawn to prevent blocking movement
            task.spawn(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
            Parried = true
            Cooldown = tick()
        end
        
        if Parried and (tick() - Cooldown) >= parryCooldown then
            Parried = false
        end
    end)
    
    print("✓ Auto Parry Enabled - Movement Allowed!")
end

function AutoParryModule:Stop()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    print("✗ Auto Parry Disabled")
end

-- ========================================
-- MANUAL SPAM MODULE
-- ========================================

local ManualSpamModule = {}
ManualSpamModule.Enabled = false
ManualSpamModule.ScreenGui = nil

function ManualSpamModule:Start()
    if self.Enabled then return end
    self.Enabled = true
    
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    
    local ManualSpam = Instance.new("ScreenGui")
    ManualSpam.Name = "ManualSpam"
    ManualSpam.Parent = game.CoreGui
    ManualSpam.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ManualSpam.ResetOnSpawn = false
    
    self.ScreenGui = ManualSpam
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ManualSpam
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Main.BackgroundTransparency = 0.2
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.414, 0, 0.404, 0)
    Main.Size = UDim2.new(0.227, 0, 0.191, 0)
    
    local UICorner = Instance.new("UICorner", Main)
    UICorner.CornerRadius = UDim.new(0, 16)
    
    local Border = Instance.new("UIStroke", Main)
    Border.Color = Color3.fromRGB(60, 60, 80)
    Border.Thickness = 1
    Border.Transparency = 0.5
    
    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Parent = Main
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 100, 120)
    Indicator.BorderSizePixel = 0
    Indicator.Position = UDim2.new(0.028, 0, 0.073, 0)
    Indicator.Size = UDim2.new(0.072, 0, 0.12, 0)
    
    local UICorner_Indicator = Instance.new("UICorner", Indicator)
    UICorner_Indicator.CornerRadius = UDim.new(1, 0)
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = Main
    ToggleButton.BackgroundTransparency = 1.0
    ToggleButton.Position = UDim2.new(0.164, 0, 0.327, 0)
    ToggleButton.Size = UDim2.new(0.668, 0, 0.347, 0)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "Manual Spam"
    ToggleButton.TextColor3 = Color3.fromRGB(240, 240, 250)
    ToggleButton.TextScaled = true
    ToggleButton.TextWrapped = true
    
    local isSpamming = false
    
    local function toggleSpamClicking()
        isSpamming = not isSpamming
        
        if isSpamming then
            Indicator.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
            ToggleButton.TextColor3 = Color3.fromRGB(100, 255, 150)
            print("✓ Manual Spam Enabled")
            
            task.spawn(function()
                while isSpamming do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    task.wait(0.001)
                end
            end)
        else
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 100, 120)
            ToggleButton.TextColor3 = Color3.fromRGB(240, 240, 250)
            print("✗ Manual Spam Disabled")
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(toggleSpamClicking)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.E then
            toggleSpamClicking()
        end
    end)
    
    local function makeDraggable(gui)
        local dragging, dragStart, startPos
        
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
            end
        end)
        
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local delta = input.Position - dragStart
                gui.Position = UDim2.new(
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
    end
    
    makeDraggable(Main)
end

function ManualSpamModule:Stop()
    self.Enabled = false
    if self.ScreenGui then
        self.ScreenGui:Destroy()
        self.ScreenGui = nil
    end
    print("✗ Manual Spam Disabled")
end

-- ========================================
-- MAIN GUI INITIALIZATION
-- ========================================

local Window = GlassUI:CreateWindow({
    Title = "Blade Ball Script",
    SubTitle = "Custom Glassmorphic Edition",
    Size = UDim2.fromOffset(600, 480),
    MinimizeKey = Enum.KeyCode.LeftControl
})

Window:Notify({
    Title = "Welcome!",
    Content = "Custom dark glassmorphic UI loaded. Movement enabled during auto-parry!",
    Duration = 5
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "" })
}

local MainSection = Tabs.Main:AddSection("Combat Features")

MainSection:AddParagraph({
    Title = "Welcome to the custom glassmorphic Blade Ball script! This version allows you to move freely during auto-parry."
})

local AutoParryToggle = Tabs.Main:AddToggle("AutoParry", {
    Title = "Auto Parry",
    Description = "Automatically parry incoming balls. You can move freely while this is active!",
    Default = false,
    Callback = function(state)
        if state then
            AutoParryModule:Start()
        else
            AutoParryModule:Stop()
        end
    end
})

local ManualSpamToggle = Tabs.Main:AddToggle("ManualSpam", {
    Title = "Manual Spam",
    Description = "Opens a separate spam window. Toggle with E key or click the window.",
    Default = false,
    Callback = function(state)
        if state then
            ManualSpamModule:Start()
        else
            ManualSpamModule:Stop()
        end
    end
})

local SettingsSection = Tabs.Settings:AddSection("Information")

SettingsSection:AddParagraph({
    Title = "This script features a custom dark glassmorphic UI design with smooth animations and modern aesthetics. Movement is fully enabled during auto-parry!"
})

print("========================================")
print("✓ Blade Ball Script Loaded Successfully!")
print("✓ Custom Glassmorphic UI Active")
print("✓ Movement Enabled During Auto-Parry")
print("========================================")
