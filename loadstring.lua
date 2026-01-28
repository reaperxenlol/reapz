-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()

-- Variables
local currentLevel = Player.leaderstats.Level.Value
local quest = nil
local mobTarget = nil
local questNPC = nil
local mobHeight = 20 -- height above mobs to stay
local attackDistance = 10 -- distance for auto-attacking mobs

-- Helper function to get quest based on player's level
function getQuestForLevel(level)
    -- Define quests for each level range
    if level >= 0 and level < 50 then
        return "Quest1", game.Workspace.QuestNPCs.Quest1 -- Example quest
    elseif level >= 50 and level < 100 then
        return "Quest2", game.Workspace.QuestNPCs.Quest2
    elseif level >= 100 then
        return "Quest3", game.Workspace.QuestNPCs.Quest3
    end
end

-- Select quest automatically based on the current level
function selectQuest()
    quest, questNPC = getQuestForLevel(currentLevel)
    if questNPC then
        print("Selected quest: " .. quest)
        -- You can add more code here to interact with the quest NPC, e.g., accepting quests.
    else
        print("No quest found for this level.")
    end
end

-- Function to move the character above mobs using tweening
function moveAboveMobs(targetPosition)
    local targetPositionAbove = targetPosition + Vector3.new(0, mobHeight, 0) -- Moves above mobs
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local goal = {Position = targetPositionAbove}

    local tween = TweenService:Create(Character.HumanoidRootPart, tweenInfo, goal)
    tween:Play()

    tween.Completed:Connect(function()
        print("Arrived above mobs!")
    end)
end

-- Function to attack mobs automatically
function attackMobs()
    while true do
        -- Check if the mob is within attacking range
        if mobTarget and (Character.HumanoidRootPart.Position - mobTarget.Position).magnitude <= attackDistance then
            -- Trigger attack animation or function
            print("Attacking mob...")
            -- Add your attack logic here (e.g., call attack function or animation)
        else
            -- If not in range, move closer
            moveAboveMobs(mobTarget.Position)
        end
        wait(0.5) -- Short wait to prevent rapid-fire commands
    end
end

-- Function to handle errors and script health checks
function errorHandling()
    while true do
        -- Example: Check if player is still alive and reset if not
        if not Character or not Character.Parent then
            print("Character lost, respawning...")
            -- Reset character logic or respawn
        end
        wait(5) -- Check every 5 seconds
    end
end

-- Main function to start the auto-farming script
function startAutoFarm()
    -- Select the appropriate quest
    selectQuest()

    -- Continuously scan for mobs to attack
    while true do
        -- Assume mobs are located in a specific area or defined list
        -- This part needs to be adjusted based on your game's mob locations
        mobTarget = game.Workspace.Mobs:GetChildren()[1] -- Example: Picking the first mob in the workspace

        if mobTarget then
            moveAboveMobs(mobTarget.Position)
            attackMobs()
        end

        wait(1) -- Main loop wait time
    end
end

-- Run the script
startAutoFarm()

-- Call the error handling function in a separate thread to ensure stability
spawn(errorHandling)
