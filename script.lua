 -- // yoo befor skidding like the hell up skid or search on youtube (how to make a blade ball script) it you choise
local function startAutoParry()
    -- Variables for parry settings
local parryDistance = 0.75   -- The maximum time (in seconds) before impact to trigger a parry
local parrySpeed = 20        -- The speed threshold for a parry

-- Function to set the parry distance dynamically
local function SetParryDistance(value)
    parryDistance = value
    print("Parry Distance set to: " .. value)
end

-- Function to set the parry speed dynamically
local function SetParrySpeed(value)
    parrySpeed = value
    print("Parry Speed set to: " .. value)
end

-- Services required for the script to function
local RunService = game:GetService("RunService") or game:FindFirstDescendant("RunService")
local Players = game:GetService("Players") or game:FindFirstDescendant("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") or game:FindFirstDescendant("VirtualInputManager")

local Player = Players.LocalPlayer  -- Get the local player
local Cooldown = tick()             -- Stores the time since the last parry
local Parried = false               -- Flag to check if a parry has been performed
local Connection = nil              -- Stores the connection to attribute changes

-- Function to get the active ball in the game
local function GetBall()
    for _, Ball in ipairs(workspace.Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then  -- Check if it's the real ball
            return Ball
        end
    end
end

-- Function to reset the connection listener
local function ResetConnection()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end

-- Detect when a new ball is added to the workspace
workspace.Balls.ChildAdded:Connect(function()
    local Ball = GetBall()
    if not Ball then return end  -- Exit if no ball is found
    ResetConnection()            -- Remove any previous connection
    Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
        Parried = false  -- Reset parry state when the ball's target changes
    end)
end)

-- Main loop that runs before each physics simulation step
RunService.PreSimulation:Connect(function()
    local Ball, HRP = GetBall(), Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if not Ball or not HRP then
        return
    end
    
    local Speed = Ball.zoomies.VectorVelocity.Magnitude  -- Get the ball's speed
    local Distance = (HRP.Position - Ball.Position).Magnitude  -- Calculate distance to player

    -- Check if the ball is targeting the player and within the parry window
    if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= parryDistance then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)  -- Simulate a mouse click to parry
        Parried = true
        Cooldown = tick()  -- Store the time the parry happened
    end
    
    -- Reset the parry flag after a cooldown period
    if Parried and (tick() - Cooldown) >= parryCooldown then
        Parried = false
    end
end)

-- Return functions for external control of the script
return {
    SetParryDistance = SetParryDistance,
    SetParrySpeed = SetParrySpeed,
    SetParryCooldown = SetParryCooldown
}
end

local function startManualsspam()
    print("fuckhole")





local UserInputService = game:GetService("UserInputService") -- Handles user input
local RunService = game:GetService("RunService") -- Runs code every frame
local VirtualInputManager = game:GetService("VirtualInputManager") -- Simulates input events

-- Create a ScreenGui to hold UI elements
local ManualSpam = Instance.new("ScreenGui")
ManualSpam.Name = "ManualSpam"
ManualSpam.Parent = game.CoreGui -- Parent it to CoreGui so it remains visible
ManualSpam.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ManualSpam.ResetOnSpawn = false -- Prevents UI from resetting on respawn

-- Main UI frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ManualSpam
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
Main.BorderSizePixel = 0 -- Removes border
Main.Position = UDim2.new(0.414, 0, 0.404, 0) -- Sets initial position
Main.Size = UDim2.new(0.227, 0, 0.191, 0) -- Sets size

local UICorner = Instance.new("UICorner", Main) -- Adds rounded corners to the Main frame

-- Status indicator to show spam click status
local Indicator = Instance.new("Frame")
Indicator.Name = "Indicator"
Indicator.Parent = Main
Indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red (inactive state)
Indicator.BorderSizePixel = 0
Indicator.Position = UDim2.new(0.028, 0, 0.073, 0)
Indicator.Size = UDim2.new(0.072, 0, 0.12, 0)

local UICorner_Indicator = Instance.new("UICorner", Indicator) -- Makes the indicator rounded
UICorner_Indicator.CornerRadius = UDim.new(1, 0)

-- Button to toggle spam clicking
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = Main
ToggleButton.BackgroundTransparency = 1.0 -- Makes background transparent
ToggleButton.Position = UDim2.new(0.164, 0, 0.327, 0)
ToggleButton.Size = UDim2.new(0.668, 0, 0.347, 0)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Mercury owner"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
ToggleButton.TextScaled = true
ToggleButton.TextWrapped = true

-- Variable to track spam clicking state
local isSpamming = false

-- Function to toggle spam clicking
local function toggleSpamClicking()
    isSpamming = not isSpamming
    
    if isSpamming then
        Indicator.BackgroundColor3 = Color3.new(0, 1, 0) -- Green when active
        ToggleButton.TextColor3 = Color3.new(0, 1, 0) -- Green text
        print("Spam Clicking Enabled")

        task.spawn(function()
            while isSpamming do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game) -- Press F key
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game) -- Release F key
                task.wait(1 / 100000000000000000000000000000000000000000000000000000000000000000000000) -- ✅ Fastest safe delay (runs as fast as possible without crashing)
            end
        end)        
    else
        Indicator.BackgroundColor3 = Color3.new(1, 0, 0) -- Red when inactive
        ToggleButton.TextColor3 = Color3.new(1, 0, 0) -- Red text
        print("Spam Clicking Disabled")
    end
end

-- Connect button click to toggle function
ToggleButton.MouseButton1Click:Connect(toggleSpamClicking)

-- Toggle spam clicking with "E" key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        toggleSpamClicking()
    end
end)

-- Function to make the UI draggable
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
            local delta = input.Position - dragStart -- Calculates movement delta
            gui.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Stop dragging when mouse is released
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

makeDraggable(Main) -- Makes the Main frame draggable

end


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "skidder " .. Fluent.Version,
    SubTitle = "by you skid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

Fluent:Notify({
    Title = "thanks for useing the script",
    Content = "made by a pro skidder",
    SubContent = "", -- Optional
    Duration = 5 -- Set to nil to make the notification not disappear
})

-- Fluent provides Lucide Icons, they are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Add a section to the "auto" tab
local Section = Tabs.Main:AddSection("yoooo")

-- Add a paragraph to the section
Section:AddParagraph({
    Title = "hello skidder"
})

-- Add a toggle to the "auto" tab
local Toggle = Tabs.Main:AddToggle("AutoParry", 
{
    Title = "Auto Parry", 
    Description = "parry thru gui",
    Default = false,
    Callback = function(state)
        if state then
            startAutoParry()
        else
            print("Auto Parry Disabled")
        end
    end 
})

-- Add a toggle to the "auto" tab
local Toggle = Tabs.Main:AddToggle("Manualspam", 
{
    Title = "Manual spam", 
    Description = "spams thru gui",
    Default = false,
    Callback = function(state)
        if state then
            startManualsspam()
        else
            print("Auto Parry Disabled")
        end
    end 
})
