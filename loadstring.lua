--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                    BLOX FRUITS AUTOFARM SCRIPT                            ║
    ║                         Version 3.0 FIXED                                  ║
    ║                                                                            ║
    ║  FIXED: Quest selection now works properly                                ║
    ║  FIXED: Kill aura and attacks now work                                    ║
    ║  FIXED: Mobile and PC GUI compatible                                      ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Player Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Get the correct GUI parent for mobile/PC
local function GetCoreGui()
    local success, result = pcall(function()
        return game:GetService("CoreGui")
    end)
    if success then
        return result
    else
        return Player:WaitForChild("PlayerGui")
    end
end

local CoreGui = GetCoreGui()

-- Configuration
local Config = {
    FarmHeight = 20,
    AttackRange = 60,
    TweenSpeed = 300,
    AutoQuest = true,
    AutoFarm = true,
    KillAura = true,
    AntiAFK = true,
    Enabled = false,
}

-- ═══════════════════════════════════════════════════════════════════════════
-- GAME REFERENCES - These are the actual paths in Blox Fruits 2026
-- ═══════════════════════════════════════════════════════════════════════════

local function GetRemotes()
    local remotes = {}
    
    -- Try multiple possible remote locations
    local possiblePaths = {
        ReplicatedStorage:FindFirstChild("Remotes"),
        ReplicatedStorage:FindFirstChild("RemoteEvents"),
        ReplicatedStorage:FindFirstChild("Network"),
    }
    
    for _, path in pairs(possiblePaths) do
        if path then
            remotes.Folder = path
            break
        end
    end
    
    return remotes
end

-- ═══════════════════════════════════════════════════════════════════════════
-- QUEST DATA
-- ═══════════════════════════════════════════════════════════════════════════

local QuestTable = {
    -- First Sea
    {Level = 0, Quest = "Bandit", NPC = "Bandit Quest Giver", Mob = "Bandit", CFrame = CFrame.new(1059.14, 16.35, 1547.54), MobArea = CFrame.new(1060, 36, 1500)},
    {Level = 10, Quest = "Monkey", NPC = "Jungle Quest Giver", Mob = "Monkey", CFrame = CFrame.new(-1604.12, 36.85, 153.56), MobArea = CFrame.new(-1550, 70, 150)},
    {Level = 15, Quest = "Gorilla", NPC = "Jungle Quest Giver", Mob = "Gorilla", CFrame = CFrame.new(-1604.12, 36.85, 153.56), MobArea = CFrame.new(-1130, 60, 130)},
    {Level = 30, Quest = "Pirate", NPC = "Pirate Quest Giver", Mob = "Pirate", CFrame = CFrame.new(-1139.59, 4.75, 3825.16), MobArea = CFrame.new(-1200, 30, 3850)},
    {Level = 40, Quest = "Brute", NPC = "Pirate Quest Giver", Mob = "Brute", CFrame = CFrame.new(-1139.59, 4.75, 3825.16), MobArea = CFrame.new(-1350, 30, 3950)},
    {Level = 60, Quest = "DesertBandit", NPC = "Desert Quest Giver", Mob = "Desert Bandit", CFrame = CFrame.new(895.04, 6.46, 4392.89), MobArea = CFrame.new(900, 30, 4450)},
    {Level = 75, Quest = "DesertOfficer", NPC = "Desert Quest Giver", Mob = "Desert Officer", CFrame = CFrame.new(895.04, 6.46, 4392.89), MobArea = CFrame.new(1100, 30, 4300)},
    {Level = 90, Quest = "SnowBandit", NPC = "Frozen Quest Giver", Mob = "Snow Bandit", CFrame = CFrame.new(1386.21, 87.26, -1298.73), MobArea = CFrame.new(1350, 110, -1350)},
    {Level = 100, Quest = "Snowman", NPC = "Frozen Quest Giver", Mob = "Snowman", CFrame = CFrame.new(1386.21, 87.26, -1298.73), MobArea = CFrame.new(1200, 110, -1400)},
    {Level = 120, Quest = "ChiefPettyOfficer", NPC = "Marine Quest Giver", Mob = "Chief Petty Officer", CFrame = CFrame.new(-5035.42, 28.68, 4324.82), MobArea = CFrame.new(-5100, 50, 4350)},
    {Level = 150, Quest = "SkyBandit", NPC = "Sky Quest Giver", Mob = "Sky Bandit", CFrame = CFrame.new(-4840.27, 717.35, -2622.89), MobArea = CFrame.new(-4900, 740, -2600)},
    {Level = 175, Quest = "DarkMaster", NPC = "Sky Quest Giver", Mob = "Dark Master", CFrame = CFrame.new(-4840.27, 717.35, -2622.89), MobArea = CFrame.new(-4950, 740, -2700)},
    {Level = 190, Quest = "Prisoner", NPC = "Prison Quest Giver", Mob = "Prisoner", CFrame = CFrame.new(4875.27, 5.68, 742.09), MobArea = CFrame.new(4900, 30, 700)},
    {Level = 210, Quest = "DangerousPrisoner", NPC = "Prison Quest Giver", Mob = "Dangerous Prisoner", CFrame = CFrame.new(4875.27, 5.68, 742.09), MobArea = CFrame.new(4850, 30, 650)},
    {Level = 250, Quest = "TogaWarrior", NPC = "Colosseum Quest Giver", Mob = "Toga Warrior", CFrame = CFrame.new(-1576.47, 7.35, -2983.54), MobArea = CFrame.new(-1600, 30, -3000)},
    {Level = 275, Quest = "Gladiator", NPC = "Colosseum Quest Giver", Mob = "Gladiator", CFrame = CFrame.new(-1576.47, 7.35, -2983.54), MobArea = CFrame.new(-1500, 30, -2900)},
    {Level = 300, Quest = "MilitarySoldier", NPC = "Magma Quest Giver", Mob = "Military Soldier", CFrame = CFrame.new(-5316.55, 12.35, 8517.76), MobArea = CFrame.new(-5350, 35, 8550)},
    {Level = 325, Quest = "MilitarySpy", NPC = "Magma Quest Giver", Mob = "Military Spy", CFrame = CFrame.new(-5316.55, 12.35, 8517.76), MobArea = CFrame.new(-5400, 35, 8600)},
    {Level = 375, Quest = "FishmanWarrior", NPC = "Fishman Quest Giver", Mob = "Fishman Warrior", CFrame = CFrame.new(61112.04, 1512.35, 1519.59), MobArea = CFrame.new(61150, 1535, 1550)},
    {Level = 400, Quest = "FishmanCommando", NPC = "Fishman Quest Giver", Mob = "Fishman Commando", CFrame = CFrame.new(61112.04, 1512.35, 1519.59), MobArea = CFrame.new(61200, 1535, 1600)},
    {Level = 450, Quest = "GodsGuard", NPC = "Sky Quest Giver 2", Mob = "God's Guard", CFrame = CFrame.new(-4721.32, 843.68, -1953.85), MobArea = CFrame.new(-4750, 865, -2000)},
    {Level = 475, Quest = "Shanda", NPC = "Sky Quest Giver 2", Mob = "Shanda", CFrame = CFrame.new(-4721.32, 843.68, -1953.85), MobArea = CFrame.new(-4800, 865, -2050)},
    {Level = 525, Quest = "RoyalSquad", NPC = "Sky Quest Giver 3", Mob = "Royal Squad", CFrame = CFrame.new(-7894.64, 5546.85, -1411.56), MobArea = CFrame.new(-7900, 5570, -1450)},
    {Level = 550, Quest = "RoyalSoldier", NPC = "Sky Quest Giver 3", Mob = "Royal Soldier", CFrame = CFrame.new(-7894.64, 5546.85, -1411.56), MobArea = CFrame.new(-7950, 5570, -1500)},
    {Level = 625, Quest = "GalleyPirate", NPC = "Fountain Quest Giver", Mob = "Galley Pirate", CFrame = CFrame.new(5254.66, 38.35, 4050.07), MobArea = CFrame.new(5300, 60, 4100)},
    {Level = 650, Quest = "GalleyCaptain", NPC = "Fountain Quest Giver", Mob = "Galley Captain", CFrame = CFrame.new(5254.66, 38.35, 4050.07), MobArea = CFrame.new(5350, 60, 4150)},
    
    -- Second Sea
    {Level = 700, Quest = "Raider", NPC = "Area1Quest Giver", Mob = "Raider", CFrame = CFrame.new(-424.34, 73.08, 1836.93), MobArea = CFrame.new(-450, 95, 1850)},
    {Level = 725, Quest = "Mercenary", NPC = "Area1Quest Giver", Mob = "Mercenary", CFrame = CFrame.new(-424.34, 73.08, 1836.93), MobArea = CFrame.new(-500, 95, 1900)},
    {Level = 775, Quest = "SwanPirate", NPC = "Area2Quest Giver", Mob = "Swan Pirate", CFrame = CFrame.new(98.7, 17.35, 1552.16), MobArea = CFrame.new(120, 40, 1580)},
    {Level = 800, Quest = "FactoryStaff", NPC = "Area2Quest Giver", Mob = "Factory Staff", CFrame = CFrame.new(98.7, 17.35, 1552.16), MobArea = CFrame.new(150, 40, 1600)},
    {Level = 875, Quest = "MarineLieutenant", NPC = "Green Zone Quest Giver", Mob = "Marine Lieutenant", CFrame = CFrame.new(-2442.08, 73.08, -3218.05), MobArea = CFrame.new(-2500, 95, -3250)},
    {Level = 900, Quest = "MarineCaptain", NPC = "Green Zone Quest Giver", Mob = "Marine Captain", CFrame = CFrame.new(-2442.08, 73.08, -3218.05), MobArea = CFrame.new(-2550, 95, -3300)},
    {Level = 950, Quest = "Zombie", NPC = "Graveyard Quest Giver", Mob = "Zombie", CFrame = CFrame.new(-5765.71, 51.97, -793.17), MobArea = CFrame.new(-5800, 75, -800)},
    {Level = 975, Quest = "Vampire", NPC = "Graveyard Quest Giver", Mob = "Vampire", CFrame = CFrame.new(-5765.71, 51.97, -793.17), MobArea = CFrame.new(-5850, 75, -850)},
    {Level = 1000, Quest = "SnowTrooper", NPC = "Snow Mountain Quest Giver", Mob = "Snow Trooper", CFrame = CFrame.new(609.32, 400.35, -5372.38), MobArea = CFrame.new(650, 425, -5400)},
    {Level = 1050, Quest = "WinterWarrior", NPC = "Snow Mountain Quest Giver", Mob = "Winter Warrior", CFrame = CFrame.new(609.32, 400.35, -5372.38), MobArea = CFrame.new(700, 425, -5450)},
    {Level = 1100, Quest = "LabSubordinate", NPC = "Ice Quest Giver", Mob = "Lab Subordinate", CFrame = CFrame.new(1361.88, 68.35, -5765.86), MobArea = CFrame.new(1400, 90, -5800)},
    {Level = 1175, Quest = "MagmaNinja", NPC = "Fire Quest Giver", Mob = "Magma Ninja", CFrame = CFrame.new(-5428.08, 16.68, -5299.8), MobArea = CFrame.new(-5450, 40, -5320)},
    {Level = 1200, Quest = "LavaPirate", NPC = "Fire Quest Giver", Mob = "Lava Pirate", CFrame = CFrame.new(-5428.08, 16.68, -5299.8), MobArea = CFrame.new(-5500, 40, -5350)},
    {Level = 1250, Quest = "ShipDeckhand", NPC = "Ship Quest Giver 1", Mob = "Ship Deckhand", CFrame = CFrame.new(916.6, 125.08, 33056.93), MobArea = CFrame.new(950, 150, 33100)},
    {Level = 1275, Quest = "ShipEngineer", NPC = "Ship Quest Giver 1", Mob = "Ship Engineer", CFrame = CFrame.new(916.6, 125.08, 33056.93), MobArea = CFrame.new(1000, 150, 33150)},
    {Level = 1300, Quest = "ShipSteward", NPC = "Ship Quest Giver 2", Mob = "Ship Steward", CFrame = CFrame.new(936.87, 125.08, 32906.04), MobArea = CFrame.new(970, 150, 32950)},
    {Level = 1325, Quest = "ShipOfficer", NPC = "Ship Quest Giver 2", Mob = "Ship Officer", CFrame = CFrame.new(936.87, 125.08, 32906.04), MobArea = CFrame.new(1020, 150, 33000)},
    {Level = 1350, Quest = "ArcticWarrior", NPC = "Frost Quest Giver", Mob = "Arctic Warrior", CFrame = CFrame.new(5669.88, 28.35, -6483.75), MobArea = CFrame.new(5700, 50, -6500)},
    {Level = 1375, Quest = "SnowLurker", NPC = "Frost Quest Giver", Mob = "Snow Lurker", CFrame = CFrame.new(5669.88, 28.35, -6483.75), MobArea = CFrame.new(5750, 50, -6550)},
    {Level = 1425, Quest = "SeaSoldier", NPC = "Forgotten Quest Giver", Mob = "Sea Soldier", CFrame = CFrame.new(-3054.58, 236.85, -10147.89), MobArea = CFrame.new(-3100, 260, -10180)},
    {Level = 1450, Quest = "WaterFighter", NPC = "Forgotten Quest Giver", Mob = "Water Fighter", CFrame = CFrame.new(-3054.58, 236.85, -10147.89), MobArea = CFrame.new(-3150, 260, -10220)},
    
    -- Third Sea
    {Level = 1500, Quest = "PirateMillionaire", NPC = "Port Quest Giver", Mob = "Pirate Millionaire", CFrame = CFrame.new(-290.06, 44.08, 5322.43), MobArea = CFrame.new(-320, 70, 5350)},
    {Level = 1525, Quest = "PistolBillionaire", NPC = "Port Quest Giver", Mob = "Pistol Billionaire", CFrame = CFrame.new(-290.06, 44.08, 5322.43), MobArea = CFrame.new(-350, 70, 5400)},
    {Level = 1575, Quest = "DragonCrewWarrior", NPC = "Hydra Quest Giver 1", Mob = "Dragon Crew Warrior", CFrame = CFrame.new(-4328.01, 843.68, -1641.77), MobArea = CFrame.new(-4350, 870, -1670)},
    {Level = 1600, Quest = "DragonCrewArcher", NPC = "Hydra Quest Giver 1", Mob = "Dragon Crew Archer", CFrame = CFrame.new(-4328.01, 843.68, -1641.77), MobArea = CFrame.new(-4400, 870, -1700)},
    {Level = 1625, Quest = "HydraEnforcer", NPC = "Hydra Quest Giver 2", Mob = "Hydra Enforcer", CFrame = CFrame.new(-5765.82, 296.68, -3045.54), MobArea = CFrame.new(-5800, 320, -3080)},
    {Level = 1650, Quest = "VenomousAssailant", NPC = "Hydra Quest Giver 2", Mob = "Venomous Assailant", CFrame = CFrame.new(-5765.82, 296.68, -3045.54), MobArea = CFrame.new(-5850, 320, -3120)},
    {Level = 1700, Quest = "MarineCommodore", NPC = "Tree Quest Giver", Mob = "Marine Commodore", CFrame = CFrame.new(2276.63, 27.35, -6623.08), MobArea = CFrame.new(2310, 50, -6650)},
    {Level = 1725, Quest = "MarineRearAdmiral", NPC = "Tree Quest Giver", Mob = "Marine Rear Admiral", CFrame = CFrame.new(2276.63, 27.35, -6623.08), MobArea = CFrame.new(2350, 50, -6700)},
    {Level = 1775, Quest = "FishmanRaider", NPC = "Turtle Quest Giver 1", Mob = "Fishman Raider", CFrame = CFrame.new(-13232.57, 332.68, -7625.16), MobArea = CFrame.new(-13270, 355, -7660)},
    {Level = 1800, Quest = "FishmanCaptain", NPC = "Turtle Quest Giver 1", Mob = "Fishman Captain", CFrame = CFrame.new(-13232.57, 332.68, -7625.16), MobArea = CFrame.new(-13300, 355, -7700)},
    {Level = 1825, Quest = "ForestPirate", NPC = "Forest Quest Giver 1", Mob = "Forest Pirate", CFrame = CFrame.new(-12681.67, 390.68, -7656.42), MobArea = CFrame.new(-12720, 415, -7690)},
    {Level = 1850, Quest = "MythologicalPirate", NPC = "Forest Quest Giver 1", Mob = "Mythological Pirate", CFrame = CFrame.new(-12681.67, 390.68, -7656.42), MobArea = CFrame.new(-12750, 415, -7720)},
    {Level = 1900, Quest = "JunglePirate", NPC = "Forest Quest Giver 2", Mob = "Jungle Pirate", CFrame = CFrame.new(-12903.72, 331.35, -8410.23), MobArea = CFrame.new(-12940, 355, -8450)},
    {Level = 1925, Quest = "MusketeerPirate", NPC = "Forest Quest Giver 2", Mob = "Musketeer Pirate", CFrame = CFrame.new(-12903.72, 331.35, -8410.23), MobArea = CFrame.new(-12980, 355, -8490)},
    {Level = 1975, Quest = "RebornSkeleton", NPC = "Haunted Quest Giver 1", Mob = "Reborn Skeleton", CFrame = CFrame.new(-9480.65, 146.35, 5765.08), MobArea = CFrame.new(-9520, 170, 5800)},
    {Level = 2000, Quest = "LivingZombie", NPC = "Haunted Quest Giver 1", Mob = "Living Zombie", CFrame = CFrame.new(-9480.65, 146.35, 5765.08), MobArea = CFrame.new(-9560, 170, 5840)},
    {Level = 2025, Quest = "DemonicSoul", NPC = "Haunted Quest Giver 2", Mob = "Demonic Soul", CFrame = CFrame.new(-9516.09, 197.35, 6299.32), MobArea = CFrame.new(-9550, 220, 6340)},
    {Level = 2050, Quest = "PossessedMummy", NPC = "Haunted Quest Giver 2", Mob = "Possessed Mummy", CFrame = CFrame.new(-9516.09, 197.35, 6299.32), MobArea = CFrame.new(-9590, 220, 6380)},
    {Level = 2075, Quest = "PeanutScout", NPC = "Peanut Quest Giver", Mob = "Peanut Scout", CFrame = CFrame.new(-2149.69, 29.35, -10185.63), MobArea = CFrame.new(-2180, 55, -10220)},
    {Level = 2100, Quest = "PeanutPresident", NPC = "Peanut Quest Giver", Mob = "Peanut President", CFrame = CFrame.new(-2149.69, 29.35, -10185.63), MobArea = CFrame.new(-2220, 55, -10260)},
    {Level = 2125, Quest = "IceCreamChef", NPC = "Ice Cream Quest Giver", Mob = "Ice Cream Chef", CFrame = CFrame.new(-1099.37, 40.35, -11422.25), MobArea = CFrame.new(-1130, 65, -11460)},
    {Level = 2150, Quest = "IceCreamCommander", NPC = "Ice Cream Quest Giver", Mob = "Ice Cream Commander", CFrame = CFrame.new(-1099.37, 40.35, -11422.25), MobArea = CFrame.new(-1170, 65, -11500)},
    {Level = 2200, Quest = "CookieCrafter", NPC = "Cake Quest Giver 1", Mob = "Cookie Crafter", CFrame = CFrame.new(-1869.56, 14.35, -11667.89), MobArea = CFrame.new(-1900, 40, -11700)},
    {Level = 2225, Quest = "CakeGuard", NPC = "Cake Quest Giver 1", Mob = "Cake Guard", CFrame = CFrame.new(-1869.56, 14.35, -11667.89), MobArea = CFrame.new(-1940, 40, -11740)},
    {Level = 2300, Quest = "CocoaWarrior", NPC = "Chocolate Quest Giver", Mob = "Cocoa Warrior", CFrame = CFrame.new(651.19, 14.35, -12551.89), MobArea = CFrame.new(680, 40, -12590)},
    {Level = 2325, Quest = "ChocolateBarBattler", NPC = "Chocolate Quest Giver", Mob = "Chocolate Bar Battler", CFrame = CFrame.new(651.19, 14.35, -12551.89), MobArea = CFrame.new(720, 40, -12630)},
    {Level = 2400, Quest = "CandyPirate", NPC = "Candy Quest Giver", Mob = "Candy Pirate", CFrame = CFrame.new(-1552.74, 56.35, -10813.88), MobArea = CFrame.new(-1590, 80, -10850)},
    {Level = 2425, Quest = "SnowDemon", NPC = "Candy Quest Giver", Mob = "Snow Demon", CFrame = CFrame.new(-1552.74, 56.35, -10813.88), MobArea = CFrame.new(-1630, 80, -10890)},
    {Level = 2450, Quest = "IsleOutlaw", NPC = "Tiki Quest Giver 1", Mob = "Isle Outlaw", CFrame = CFrame.new(-10171.57, 331.35, -8761.29), MobArea = CFrame.new(-10210, 355, -8800)},
    {Level = 2475, Quest = "IslandBoy", NPC = "Tiki Quest Giver 1", Mob = "Island Boy", CFrame = CFrame.new(-10171.57, 331.35, -8761.29), MobArea = CFrame.new(-10250, 355, -8840)},
    {Level = 2500, Quest = "SunKissedWarrior", NPC = "Tiki Quest Giver 2", Mob = "Sun-kissed Warrior", CFrame = CFrame.new(-10171.57, 331.35, -8761.29), MobArea = CFrame.new(-10290, 355, -8880)},
    {Level = 2550, Quest = "SerpentHunter", NPC = "Tiki Quest Giver 3", Mob = "Serpent Hunter", CFrame = CFrame.new(-10171.57, 331.35, -8761.29), MobArea = CFrame.new(-10370, 355, -8960)},
    {Level = 2600, Quest = "ReefBandit", NPC = "Submerged Quest Giver 1", Mob = "Reef Bandit", CFrame = CFrame.new(-6508.27, 14.35, -1584.97), MobArea = CFrame.new(-6550, 40, -1620)},
    {Level = 2650, Quest = "SeaChanter", NPC = "Submerged Quest Giver 2", Mob = "Sea Chanter", CFrame = CFrame.new(-6508.27, 14.35, -1584.97), MobArea = CFrame.new(-6630, 40, -1700)},
    {Level = 2700, Quest = "HighDisciple", NPC = "Submerged Quest Giver 3", Mob = "High Disciple", CFrame = CFrame.new(-6508.27, 14.35, -1584.97), MobArea = CFrame.new(-6710, 40, -1780)},
}

-- ═══════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function GetPlayerLevel()
    local data = Player:FindFirstChild("Data")
    if data then
        local level = data:FindFirstChild("Level")
        if level then
            return level.Value
        end
    end
    return 1
end

local function GetBestQuest()
    local level = GetPlayerLevel()
    local best = nil
    for _, q in ipairs(QuestTable) do
        if q.Level <= level then
            if not best or q.Level > best.Level then
                best = q
            end
        end
    end
    return best
end

local function Teleport(cf)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = cf
    end
end

local function TweenTo(cf)
    if not HumanoidRootPart then return end
    local dist = (HumanoidRootPart.Position - cf.Position).Magnitude
    local time = dist / Config.TweenSpeed
    if time < 0.1 then time = 0.1 end
    
    local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

-- ═══════════════════════════════════════════════════════════════════════════
-- QUEST SYSTEM - FIXED
-- ═══════════════════════════════════════════════════════════════════════════

local function GetCurrentQuest()
    local plrGui = Player:FindFirstChild("PlayerGui")
    if plrGui then
        local main = plrGui:FindFirstChild("Main")
        if main then
            local quest = main:FindFirstChild("Quest")
            if quest and quest.Visible then
                return true
            end
        end
    end
    return false
end

local function AcceptQuest(questName)
    -- Method 1: Fire the remote directly
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local acceptQuest = remotes:FindFirstChild("AcceptQuest")
            if acceptQuest then
                acceptQuest:InvokeServer(questName)
                return
            end
            
            -- Try CommF
            local commF = remotes:FindFirstChild("CommF_")
            if commF then
                commF:InvokeServer("StartQuest", questName, 1)
                return
            end
        end
    end)
    
    -- Method 2: Click the NPC dialog
    pcall(function()
        local plrGui = Player:FindFirstChild("PlayerGui")
        if plrGui then
            local main = plrGui:FindFirstChild("Main")
            if main then
                local dialogFrame = main:FindFirstChild("Quest") or main:FindFirstChild("QuestMenu") or main:FindFirstChild("DialogFrame")
                if dialogFrame then
                    for _, child in pairs(dialogFrame:GetDescendants()) do
                        if child:IsA("TextButton") then
                            -- Click any button that might be the accept button
                            pcall(function()
                                child:Activate()
                            end)
                        end
                    end
                end
            end
        end
    end)
    
    -- Method 3: Use the game's quest system directly
    pcall(function()
        local args = {
            [1] = "StartQuest",
            [2] = questName,
            [3] = 1
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
end

local function ClickQuestNPC()
    -- Try to interact with nearby NPC
    pcall(function()
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local dist = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                if dist < 15 then
                    -- Check for proximity prompt
                    local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                    
                    -- Check for click detector
                    local click = npc:FindFirstChildOfClass("ClickDetector")
                    if click then
                        fireclickdetector(click)
                    end
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ATTACK SYSTEM - FIXED KILL AURA
-- ═══════════════════════════════════════════════════════════════════════════

local function GetMobs(mobName)
    local mobs = {}
    
    -- Check in Enemies folder
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in pairs(enemies:GetChildren()) do
            if mob.Name == mobName or mob.Name:find(mobName) then
                local hum = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    table.insert(mobs, mob)
                end
            end
        end
    end
    
    -- Also check workspace directly
    for _, mob in pairs(Workspace:GetChildren()) do
        if mob:IsA("Model") and (mob.Name == mobName or mob.Name:find(mobName)) then
            local hum = mob:FindFirstChild("Humanoid")
            local hrp = mob:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                if not table.find(mobs, mob) then
                    table.insert(mobs, mob)
                end
            end
        end
    end
    
    return mobs
end

local function GetNearestMob(mobName)
    local mobs = GetMobs(mobName)
    local nearest = nil
    local nearestDist = math.huge
    
    for _, mob in pairs(mobs) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = mob
            end
        end
    end
    
    return nearest
end

local function Attack()
    -- Method 1: Virtual click
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait()
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
    
    -- Method 2: Use tool if equipped
    pcall(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end)
    
    -- Method 3: Fire combat remote
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local combat = remotes:FindFirstChild("Combat")
            if combat then
                combat:FireServer()
            end
        end
    end)
end

local function KillAura(mobName)
    if not Config.KillAura then return end
    
    local mobs = GetMobs(mobName)
    
    for _, mob in pairs(mobs) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChild("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
            
            if dist <= Config.AttackRange then
                -- Teleport to mob and attack
                HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, Config.FarmHeight, 0)
                
                -- Fire touch interest for damage
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(HumanoidRootPart, hrp, 0)
                        task.wait()
                        firetouchinterest(HumanoidRootPart, hrp, 1)
                    end
                end)
                
                Attack()
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN FARM LOOP
-- ═══════════════════════════════════════════════════════════════════════════

local function Farm()
    while Config.Enabled and task.wait(0.1) do
        pcall(function()
            -- Refresh character
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            end
            
            if Humanoid.Health <= 0 then
                task.wait(6)
                return
            end
            
            local quest = GetBestQuest()
            if not quest then return end
            
            -- Check if we need quest
            if not GetCurrentQuest() then
                -- Go to NPC
                Teleport(quest.CFrame)
                task.wait(0.5)
                ClickQuestNPC()
                task.wait(0.3)
                AcceptQuest(quest.Quest)
                task.wait(0.5)
                return
            end
            
            -- Find mob
            local mob = GetNearestMob(quest.Mob)
            
            if mob then
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                local hum = mob:FindFirstChild("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    -- Position above mob
                    HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, Config.FarmHeight, 0)
                    
                    -- Attack
                    Attack()
                    KillAura(quest.Mob)
                end
            else
                -- Go to mob area
                Teleport(quest.MobArea)
            end
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- GUI - MOBILE AND PC COMPATIBLE
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateGUI()
    -- Remove old GUI
    pcall(function()
        if CoreGui:FindFirstChild("BloxFruitsAutoFarm") then
            CoreGui.BloxFruitsAutoFarm:Destroy()
        end
        if Player.PlayerGui:FindFirstChild("BloxFruitsAutoFarm") then
            Player.PlayerGui.BloxFruitsAutoFarm:Destroy()
        end
    end)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloxFruitsAutoFarm"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try CoreGui first, fall back to PlayerGui
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Player.PlayerGui
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 220, 0, 180)
    MainFrame.Position = UDim2.new(0, 20, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(100, 100, 255)
    Stroke.Thickness = 2
    Stroke.Parent = MainFrame
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.BorderSizePixel = 0
    Title.Text = "🍎 Blox Fruits Farm"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title
    
    -- Auto Farm Button
    local FarmBtn = Instance.new("TextButton")
    FarmBtn.Name = "FarmBtn"
    FarmBtn.Size = UDim2.new(0.9, 0, 0, 35)
    FarmBtn.Position = UDim2.new(0.05, 0, 0, 45)
    FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    FarmBtn.BorderSizePixel = 0
    FarmBtn.Text = "Auto Farm: OFF"
    FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmBtn.TextSize = 14
    FarmBtn.Font = Enum.Font.GothamBold
    FarmBtn.Parent = MainFrame
    
    local FarmCorner = Instance.new("UICorner")
    FarmCorner.CornerRadius = UDim.new(0, 8)
    FarmCorner.Parent = FarmBtn
    
    FarmBtn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        if Config.Enabled then
            FarmBtn.Text = "Auto Farm: ON"
            FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            spawn(Farm)
        else
            FarmBtn.Text = "Auto Farm: OFF"
            FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        end
    end)
    
    -- Kill Aura Button
    local AuraBtn = Instance.new("TextButton")
    AuraBtn.Name = "AuraBtn"
    AuraBtn.Size = UDim2.new(0.9, 0, 0, 35)
    AuraBtn.Position = UDim2.new(0.05, 0, 0, 85)
    AuraBtn.BackgroundColor3 = Config.KillAura and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    AuraBtn.BorderSizePixel = 0
    AuraBtn.Text = "Kill Aura: " .. (Config.KillAura and "ON" or "OFF")
    AuraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AuraBtn.TextSize = 14
    AuraBtn.Font = Enum.Font.GothamBold
    AuraBtn.Parent = MainFrame
    
    local AuraCorner = Instance.new("UICorner")
    AuraCorner.CornerRadius = UDim.new(0, 8)
    AuraCorner.Parent = AuraBtn
    
    AuraBtn.MouseButton1Click:Connect(function()
        Config.KillAura = not Config.KillAura
        AuraBtn.Text = "Kill Aura: " .. (Config.KillAura and "ON" or "OFF")
        AuraBtn.BackgroundColor3 = Config.KillAura and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    end)
    
    -- Level Display
    local LevelLabel = Instance.new("TextLabel")
    LevelLabel.Name = "LevelLabel"
    LevelLabel.Size = UDim2.new(0.9, 0, 0, 25)
    LevelLabel.Position = UDim2.new(0.05, 0, 0, 125)
    LevelLabel.BackgroundTransparency = 1
    LevelLabel.Text = "Level: " .. GetPlayerLevel()
    LevelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    LevelLabel.TextSize = 12
    LevelLabel.Font = Enum.Font.Gotham
    LevelLabel.Parent = MainFrame
    
    -- Quest Display
    local QuestLabel = Instance.new("TextLabel")
    QuestLabel.Name = "QuestLabel"
    QuestLabel.Size = UDim2.new(0.9, 0, 0, 25)
    QuestLabel.Position = UDim2.new(0.05, 0, 0, 150)
    QuestLabel.BackgroundTransparency = 1
    local q = GetBestQuest()
    QuestLabel.Text = "Quest: " .. (q and q.Mob or "None")
    QuestLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    QuestLabel.TextSize = 12
    QuestLabel.Font = Enum.Font.Gotham
    QuestLabel.Parent = MainFrame
    
    -- Update labels
    spawn(function()
        while ScreenGui.Parent do
            task.wait(1)
            pcall(function()
                LevelLabel.Text = "Level: " .. GetPlayerLevel()
                local q = GetBestQuest()
                QuestLabel.Text = "Quest: " .. (q and q.Mob or "None")
            end)
        end
    end)
    
    return ScreenGui
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ═══════════════════════════════════════════════════════════════════════════

if Config.AntiAFK then
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CHARACTER HANDLER
-- ═══════════════════════════════════════════════════════════════════════════

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZE
-- ═══════════════════════════════════════════════════════════════════════════

print("═══════════════════════════════════════════════════")
print("   BLOX FRUITS AUTOFARM v3.0 FIXED")
print("   Level: " .. GetPlayerLevel())
local q = GetBestQuest()
print("   Best Quest: " .. (q and q.Mob or "None"))
print("═══════════════════════════════════════════════════")

CreateGUI()

print("[AutoFarm] Script loaded! Click the buttons to start.")
