--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                    BLOX FRUITS AUTOFARM SCRIPT                            ║
    ║                         Version 5.0 - ALL FIXES                           ║
    ║                                                                            ║
    ║  ✓ Fixed quest selection based on your level                              ║
    ║  ✓ Attacks ALL mobs of the quest type (not just 1)                        ║
    ║  ✓ Fixed quest auto-accept                                                ║
    ║  ✓ Smooth tweening + flying                                               ║
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

-- Get the correct GUI parent
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
    FarmHeight = 25,
    AttackRange = 100,         -- Increased range to find more mobs
    TweenSpeed = 200,
    AutoQuest = true,
    AutoFarm = true,
    KillAura = true,
    AntiAFK = true,
    Enabled = false,
    Flying = false,
    MobSwitchDelay = 0.3,      -- Delay between switching mobs
}

-- State
local ActiveTween = nil
local BodyVelocity = nil
local BodyGyro = nil
local IsTweening = false
local CurrentMobIndex = 1

-- ═══════════════════════════════════════════════════════════════════════════
-- QUEST DATA - Organized by level ranges
-- ═══════════════════════════════════════════════════════════════════════════

local QuestTable = {
    -- First Sea (0-700)
    {MinLevel = 0, MaxLevel = 9, Quest = "Bandit", QuestId = "Bandit", Mob = "Bandit", NPCLocation = CFrame.new(1059.14, 16.35, 1547.54), MobLocation = CFrame.new(1060, 36, 1500)},
    {MinLevel = 10, MaxLevel = 14, Quest = "Monkey", QuestId = "Monkey", Mob = "Monkey", NPCLocation = CFrame.new(-1604.12, 36.85, 153.56), MobLocation = CFrame.new(-1550, 70, 150)},
    {MinLevel = 15, MaxLevel = 29, Quest = "Gorilla", QuestId = "Gorilla", Mob = "Gorilla", NPCLocation = CFrame.new(-1604.12, 36.85, 153.56), MobLocation = CFrame.new(-1130, 60, 130)},
    {MinLevel = 30, MaxLevel = 39, Quest = "Pirate", QuestId = "Pirate", Mob = "Pirate", NPCLocation = CFrame.new(-1139.59, 4.75, 3825.16), MobLocation = CFrame.new(-1200, 30, 3850)},
    {MinLevel = 40, MaxLevel = 59, Quest = "Brute", QuestId = "Brute", Mob = "Brute", NPCLocation = CFrame.new(-1139.59, 4.75, 3825.16), MobLocation = CFrame.new(-1350, 30, 3950)},
    {MinLevel = 60, MaxLevel = 74, Quest = "Desert Bandit", QuestId = "DesertBandit", Mob = "Desert Bandit", NPCLocation = CFrame.new(895.04, 6.46, 4392.89), MobLocation = CFrame.new(900, 30, 4450)},
    {MinLevel = 75, MaxLevel = 89, Quest = "Desert Officer", QuestId = "DesertOfficer", Mob = "Desert Officer", NPCLocation = CFrame.new(895.04, 6.46, 4392.89), MobLocation = CFrame.new(1100, 30, 4300)},
    {MinLevel = 90, MaxLevel = 99, Quest = "Snow Bandit", QuestId = "SnowBandit", Mob = "Snow Bandit", NPCLocation = CFrame.new(1386.21, 87.26, -1298.73), MobLocation = CFrame.new(1350, 110, -1350)},
    {MinLevel = 100, MaxLevel = 119, Quest = "Snowman", QuestId = "Snowman", Mob = "Snowman", NPCLocation = CFrame.new(1386.21, 87.26, -1298.73), MobLocation = CFrame.new(1200, 110, -1400)},
    {MinLevel = 120, MaxLevel = 149, Quest = "Chief Petty Officer", QuestId = "ChiefPettyOfficer", Mob = "Chief Petty Officer", NPCLocation = CFrame.new(-5035.42, 28.68, 4324.82), MobLocation = CFrame.new(-5100, 50, 4350)},
    {MinLevel = 150, MaxLevel = 174, Quest = "Sky Bandit", QuestId = "SkyBandit", Mob = "Sky Bandit", NPCLocation = CFrame.new(-4840.27, 717.35, -2622.89), MobLocation = CFrame.new(-4900, 740, -2600)},
    {MinLevel = 175, MaxLevel = 189, Quest = "Dark Master", QuestId = "DarkMaster", Mob = "Dark Master", NPCLocation = CFrame.new(-4840.27, 717.35, -2622.89), MobLocation = CFrame.new(-4950, 740, -2700)},
    {MinLevel = 190, MaxLevel = 209, Quest = "Prisoner", QuestId = "Prisoner", Mob = "Prisoner", NPCLocation = CFrame.new(4875.27, 5.68, 742.09), MobLocation = CFrame.new(4900, 30, 700)},
    {MinLevel = 210, MaxLevel = 249, Quest = "Dangerous Prisoner", QuestId = "DangerousPrisoner", Mob = "Dangerous Prisoner", NPCLocation = CFrame.new(4875.27, 5.68, 742.09), MobLocation = CFrame.new(4850, 30, 650)},
    {MinLevel = 250, MaxLevel = 274, Quest = "Toga Warrior", QuestId = "TogaWarrior", Mob = "Toga Warrior", NPCLocation = CFrame.new(-1576.47, 7.35, -2983.54), MobLocation = CFrame.new(-1600, 30, -3000)},
    {MinLevel = 275, MaxLevel = 299, Quest = "Gladiator", QuestId = "Gladiator", Mob = "Gladiator", NPCLocation = CFrame.new(-1576.47, 7.35, -2983.54), MobLocation = CFrame.new(-1500, 30, -2900)},
    {MinLevel = 300, MaxLevel = 324, Quest = "Military Soldier", QuestId = "MilitarySoldier", Mob = "Military Soldier", NPCLocation = CFrame.new(-5316.55, 12.35, 8517.76), MobLocation = CFrame.new(-5350, 35, 8550)},
    {MinLevel = 325, MaxLevel = 374, Quest = "Military Spy", QuestId = "MilitarySpy", Mob = "Military Spy", NPCLocation = CFrame.new(-5316.55, 12.35, 8517.76), MobLocation = CFrame.new(-5400, 35, 8600)},
    {MinLevel = 375, MaxLevel = 399, Quest = "Fishman Warrior", QuestId = "FishmanWarrior", Mob = "Fishman Warrior", NPCLocation = CFrame.new(61112.04, 1512.35, 1519.59), MobLocation = CFrame.new(61150, 1535, 1550)},
    {MinLevel = 400, MaxLevel = 449, Quest = "Fishman Commando", QuestId = "FishmanCommando", Mob = "Fishman Commando", NPCLocation = CFrame.new(61112.04, 1512.35, 1519.59), MobLocation = CFrame.new(61200, 1535, 1600)},
    {MinLevel = 450, MaxLevel = 474, Quest = "God's Guard", QuestId = "GodsGuard", Mob = "God's Guard", NPCLocation = CFrame.new(-4721.32, 843.68, -1953.85), MobLocation = CFrame.new(-4750, 865, -2000)},
    {MinLevel = 475, MaxLevel = 524, Quest = "Shanda", QuestId = "Shanda", Mob = "Shanda", NPCLocation = CFrame.new(-4721.32, 843.68, -1953.85), MobLocation = CFrame.new(-4800, 865, -2050)},
    {MinLevel = 525, MaxLevel = 549, Quest = "Royal Squad", QuestId = "RoyalSquad", Mob = "Royal Squad", NPCLocation = CFrame.new(-7894.64, 5546.85, -1411.56), MobLocation = CFrame.new(-7900, 5570, -1450)},
    {MinLevel = 550, MaxLevel = 624, Quest = "Royal Soldier", QuestId = "RoyalSoldier", Mob = "Royal Soldier", NPCLocation = CFrame.new(-7894.64, 5546.85, -1411.56), MobLocation = CFrame.new(-7950, 5570, -1500)},
    {MinLevel = 625, MaxLevel = 649, Quest = "Galley Pirate", QuestId = "GalleyPirate", Mob = "Galley Pirate", NPCLocation = CFrame.new(5254.66, 38.35, 4050.07), MobLocation = CFrame.new(5300, 60, 4100)},
    {MinLevel = 650, MaxLevel = 699, Quest = "Galley Captain", QuestId = "GalleyCaptain", Mob = "Galley Captain", NPCLocation = CFrame.new(5254.66, 38.35, 4050.07), MobLocation = CFrame.new(5350, 60, 4150)},
    
    -- Second Sea (700-1500)
    {MinLevel = 700, MaxLevel = 724, Quest = "Raider", QuestId = "Raider", Mob = "Raider", NPCLocation = CFrame.new(-424.34, 73.08, 1836.93), MobLocation = CFrame.new(-450, 95, 1850)},
    {MinLevel = 725, MaxLevel = 774, Quest = "Mercenary", QuestId = "Mercenary", Mob = "Mercenary", NPCLocation = CFrame.new(-424.34, 73.08, 1836.93), MobLocation = CFrame.new(-500, 95, 1900)},
    {MinLevel = 775, MaxLevel = 799, Quest = "Swan Pirate", QuestId = "SwanPirate", Mob = "Swan Pirate", NPCLocation = CFrame.new(98.7, 17.35, 1552.16), MobLocation = CFrame.new(120, 40, 1580)},
    {MinLevel = 800, MaxLevel = 874, Quest = "Factory Staff", QuestId = "FactoryStaff", Mob = "Factory Staff", NPCLocation = CFrame.new(98.7, 17.35, 1552.16), MobLocation = CFrame.new(150, 40, 1600)},
    {MinLevel = 875, MaxLevel = 899, Quest = "Marine Lieutenant", QuestId = "MarineLieutenant", Mob = "Marine Lieutenant", NPCLocation = CFrame.new(-2442.08, 73.08, -3218.05), MobLocation = CFrame.new(-2500, 95, -3250)},
    {MinLevel = 900, MaxLevel = 949, Quest = "Marine Captain", QuestId = "MarineCaptain", Mob = "Marine Captain", NPCLocation = CFrame.new(-2442.08, 73.08, -3218.05), MobLocation = CFrame.new(-2550, 95, -3300)},
    {MinLevel = 950, MaxLevel = 974, Quest = "Zombie", QuestId = "Zombie", Mob = "Zombie", NPCLocation = CFrame.new(-5765.71, 51.97, -793.17), MobLocation = CFrame.new(-5800, 75, -800)},
    {MinLevel = 975, MaxLevel = 999, Quest = "Vampire", QuestId = "Vampire", Mob = "Vampire", NPCLocation = CFrame.new(-5765.71, 51.97, -793.17), MobLocation = CFrame.new(-5850, 75, -850)},
    {MinLevel = 1000, MaxLevel = 1049, Quest = "Snow Trooper", QuestId = "SnowTrooper", Mob = "Snow Trooper", NPCLocation = CFrame.new(609.32, 400.35, -5372.38), MobLocation = CFrame.new(650, 425, -5400)},
    {MinLevel = 1050, MaxLevel = 1099, Quest = "Winter Warrior", QuestId = "WinterWarrior", Mob = "Winter Warrior", NPCLocation = CFrame.new(609.32, 400.35, -5372.38), MobLocation = CFrame.new(700, 425, -5450)},
    {MinLevel = 1100, MaxLevel = 1174, Quest = "Lab Subordinate", QuestId = "LabSubordinate", Mob = "Lab Subordinate", NPCLocation = CFrame.new(1361.88, 68.35, -5765.86), MobLocation = CFrame.new(1400, 90, -5800)},
    {MinLevel = 1175, MaxLevel = 1199, Quest = "Magma Ninja", QuestId = "MagmaNinja", Mob = "Magma Ninja", NPCLocation = CFrame.new(-5428.08, 16.68, -5299.8), MobLocation = CFrame.new(-5450, 40, -5320)},
    {MinLevel = 1200, MaxLevel = 1249, Quest = "Lava Pirate", QuestId = "LavaPirate", Mob = "Lava Pirate", NPCLocation = CFrame.new(-5428.08, 16.68, -5299.8), MobLocation = CFrame.new(-5500, 40, -5350)},
    {MinLevel = 1250, MaxLevel = 1274, Quest = "Ship Deckhand", QuestId = "ShipDeckhand", Mob = "Ship Deckhand", NPCLocation = CFrame.new(916.6, 125.08, 33056.93), MobLocation = CFrame.new(950, 150, 33100)},
    {MinLevel = 1275, MaxLevel = 1299, Quest = "Ship Engineer", QuestId = "ShipEngineer", Mob = "Ship Engineer", NPCLocation = CFrame.new(916.6, 125.08, 33056.93), MobLocation = CFrame.new(1000, 150, 33150)},
    {MinLevel = 1300, MaxLevel = 1324, Quest = "Ship Steward", QuestId = "ShipSteward", Mob = "Ship Steward", NPCLocation = CFrame.new(936.87, 125.08, 32906.04), MobLocation = CFrame.new(970, 150, 32950)},
    {MinLevel = 1325, MaxLevel = 1349, Quest = "Ship Officer", QuestId = "ShipOfficer", Mob = "Ship Officer", NPCLocation = CFrame.new(936.87, 125.08, 32906.04), MobLocation = CFrame.new(1020, 150, 33000)},
    {MinLevel = 1350, MaxLevel = 1374, Quest = "Arctic Warrior", QuestId = "ArcticWarrior", Mob = "Arctic Warrior", NPCLocation = CFrame.new(5669.88, 28.35, -6483.75), MobLocation = CFrame.new(5700, 50, -6500)},
    {MinLevel = 1375, MaxLevel = 1424, Quest = "Snow Lurker", QuestId = "SnowLurker", Mob = "Snow Lurker", NPCLocation = CFrame.new(5669.88, 28.35, -6483.75), MobLocation = CFrame.new(5750, 50, -6550)},
    {MinLevel = 1425, MaxLevel = 1449, Quest = "Sea Soldier", QuestId = "SeaSoldier", Mob = "Sea Soldier", NPCLocation = CFrame.new(-3054.58, 236.85, -10147.89), MobLocation = CFrame.new(-3100, 260, -10180)},
    {MinLevel = 1450, MaxLevel = 1499, Quest = "Water Fighter", QuestId = "WaterFighter", Mob = "Water Fighter", NPCLocation = CFrame.new(-3054.58, 236.85, -10147.89), MobLocation = CFrame.new(-3150, 260, -10220)},
    
    -- Third Sea (1500+)
    {MinLevel = 1500, MaxLevel = 1524, Quest = "Pirate Millionaire", QuestId = "PirateMillionaire", Mob = "Pirate Millionaire", NPCLocation = CFrame.new(-290.06, 44.08, 5322.43), MobLocation = CFrame.new(-320, 70, 5350)},
    {MinLevel = 1525, MaxLevel = 1574, Quest = "Pistol Billionaire", QuestId = "PistolBillionaire", Mob = "Pistol Billionaire", NPCLocation = CFrame.new(-290.06, 44.08, 5322.43), MobLocation = CFrame.new(-350, 70, 5400)},
    {MinLevel = 1575, MaxLevel = 1599, Quest = "Dragon Crew Warrior", QuestId = "DragonCrewWarrior", Mob = "Dragon Crew Warrior", NPCLocation = CFrame.new(-4328.01, 843.68, -1641.77), MobLocation = CFrame.new(-4350, 870, -1670)},
    {MinLevel = 1600, MaxLevel = 1624, Quest = "Dragon Crew Archer", QuestId = "DragonCrewArcher", Mob = "Dragon Crew Archer", NPCLocation = CFrame.new(-4328.01, 843.68, -1641.77), MobLocation = CFrame.new(-4400, 870, -1700)},
    {MinLevel = 1625, MaxLevel = 1649, Quest = "Hydra Enforcer", QuestId = "HydraEnforcer", Mob = "Hydra Enforcer", NPCLocation = CFrame.new(-5765.82, 296.68, -3045.54), MobLocation = CFrame.new(-5800, 320, -3080)},
    {MinLevel = 1650, MaxLevel = 1699, Quest = "Venomous Assailant", QuestId = "VenomousAssailant", Mob = "Venomous Assailant", NPCLocation = CFrame.new(-5765.82, 296.68, -3045.54), MobLocation = CFrame.new(-5850, 320, -3120)},
    {MinLevel = 1700, MaxLevel = 1724, Quest = "Marine Commodore", QuestId = "MarineCommodore", Mob = "Marine Commodore", NPCLocation = CFrame.new(2276.63, 27.35, -6623.08), MobLocation = CFrame.new(2310, 50, -6650)},
    {MinLevel = 1725, MaxLevel = 1774, Quest = "Marine Rear Admiral", QuestId = "MarineRearAdmiral", Mob = "Marine Rear Admiral", NPCLocation = CFrame.new(2276.63, 27.35, -6623.08), MobLocation = CFrame.new(2350, 50, -6700)},
    {MinLevel = 1775, MaxLevel = 1799, Quest = "Fishman Raider", QuestId = "FishmanRaider", Mob = "Fishman Raider", NPCLocation = CFrame.new(-13232.57, 332.68, -7625.16), MobLocation = CFrame.new(-13270, 355, -7660)},
    {MinLevel = 1800, MaxLevel = 1824, Quest = "Fishman Captain", QuestId = "FishmanCaptain", Mob = "Fishman Captain", NPCLocation = CFrame.new(-13232.57, 332.68, -7625.16), MobLocation = CFrame.new(-13300, 355, -7700)},
    {MinLevel = 1825, MaxLevel = 1849, Quest = "Forest Pirate", QuestId = "ForestPirate", Mob = "Forest Pirate", NPCLocation = CFrame.new(-12681.67, 390.68, -7656.42), MobLocation = CFrame.new(-12720, 415, -7690)},
    {MinLevel = 1850, MaxLevel = 1899, Quest = "Mythological Pirate", QuestId = "MythologicalPirate", Mob = "Mythological Pirate", NPCLocation = CFrame.new(-12681.67, 390.68, -7656.42), MobLocation = CFrame.new(-12750, 415, -7720)},
    {MinLevel = 1900, MaxLevel = 1924, Quest = "Jungle Pirate", QuestId = "JunglePirate", Mob = "Jungle Pirate", NPCLocation = CFrame.new(-12903.72, 331.35, -8410.23), MobLocation = CFrame.new(-12940, 355, -8450)},
    {MinLevel = 1925, MaxLevel = 1974, Quest = "Musketeer Pirate", QuestId = "MusketeerPirate", Mob = "Musketeer Pirate", NPCLocation = CFrame.new(-12903.72, 331.35, -8410.23), MobLocation = CFrame.new(-12980, 355, -8490)},
    {MinLevel = 1975, MaxLevel = 1999, Quest = "Reborn Skeleton", QuestId = "RebornSkeleton", Mob = "Reborn Skeleton", NPCLocation = CFrame.new(-9480.65, 146.35, 5765.08), MobLocation = CFrame.new(-9520, 170, 5800)},
    {MinLevel = 2000, MaxLevel = 2024, Quest = "Living Zombie", QuestId = "LivingZombie", Mob = "Living Zombie", NPCLocation = CFrame.new(-9480.65, 146.35, 5765.08), MobLocation = CFrame.new(-9560, 170, 5840)},
    {MinLevel = 2025, MaxLevel = 2049, Quest = "Demonic Soul", QuestId = "DemonicSoul", Mob = "Demonic Soul", NPCLocation = CFrame.new(-9516.09, 197.35, 6299.32), MobLocation = CFrame.new(-9550, 220, 6340)},
    {MinLevel = 2050, MaxLevel = 2074, Quest = "Possessed Mummy", QuestId = "PossessedMummy", Mob = "Possessed Mummy", NPCLocation = CFrame.new(-9516.09, 197.35, 6299.32), MobLocation = CFrame.new(-9590, 220, 6380)},
    {MinLevel = 2075, MaxLevel = 2099, Quest = "Peanut Scout", QuestId = "PeanutScout", Mob = "Peanut Scout", NPCLocation = CFrame.new(-2149.69, 29.35, -10185.63), MobLocation = CFrame.new(-2180, 55, -10220)},
    {MinLevel = 2100, MaxLevel = 2124, Quest = "Peanut President", QuestId = "PeanutPresident", Mob = "Peanut President", NPCLocation = CFrame.new(-2149.69, 29.35, -10185.63), MobLocation = CFrame.new(-2220, 55, -10260)},
    {MinLevel = 2125, MaxLevel = 2149, Quest = "Ice Cream Chef", QuestId = "IceCreamChef", Mob = "Ice Cream Chef", NPCLocation = CFrame.new(-1099.37, 40.35, -11422.25), MobLocation = CFrame.new(-1130, 65, -11460)},
    {MinLevel = 2150, MaxLevel = 2199, Quest = "Ice Cream Commander", QuestId = "IceCreamCommander", Mob = "Ice Cream Commander", NPCLocation = CFrame.new(-1099.37, 40.35, -11422.25), MobLocation = CFrame.new(-1170, 65, -11500)},
    {MinLevel = 2200, MaxLevel = 2224, Quest = "Cookie Crafter", QuestId = "CookieCrafter", Mob = "Cookie Crafter", NPCLocation = CFrame.new(-1869.56, 14.35, -11667.89), MobLocation = CFrame.new(-1900, 40, -11700)},
    {MinLevel = 2225, MaxLevel = 2299, Quest = "Cake Guard", QuestId = "CakeGuard", Mob = "Cake Guard", NPCLocation = CFrame.new(-1869.56, 14.35, -11667.89), MobLocation = CFrame.new(-1940, 40, -11740)},
    {MinLevel = 2300, MaxLevel = 2324, Quest = "Cocoa Warrior", QuestId = "CocoaWarrior", Mob = "Cocoa Warrior", NPCLocation = CFrame.new(651.19, 14.35, -12551.89), MobLocation = CFrame.new(680, 40, -12590)},
    {MinLevel = 2325, MaxLevel = 2399, Quest = "Chocolate Bar Battler", QuestId = "ChocolateBarBattler", Mob = "Chocolate Bar Battler", NPCLocation = CFrame.new(651.19, 14.35, -12551.89), MobLocation = CFrame.new(720, 40, -12630)},
    {MinLevel = 2400, MaxLevel = 2424, Quest = "Candy Pirate", QuestId = "CandyPirate", Mob = "Candy Pirate", NPCLocation = CFrame.new(-1552.74, 56.35, -10813.88), MobLocation = CFrame.new(-1590, 80, -10850)},
    {MinLevel = 2425, MaxLevel = 2449, Quest = "Snow Demon", QuestId = "SnowDemon", Mob = "Snow Demon", NPCLocation = CFrame.new(-1552.74, 56.35, -10813.88), MobLocation = CFrame.new(-1630, 80, -10890)},
    {MinLevel = 2450, MaxLevel = 2474, Quest = "Isle Outlaw", QuestId = "IsleOutlaw", Mob = "Isle Outlaw", NPCLocation = CFrame.new(-10171.57, 331.35, -8761.29), MobLocation = CFrame.new(-10210, 355, -8800)},
    {MinLevel = 2475, MaxLevel = 2499, Quest = "Island Boy", QuestId = "IslandBoy", Mob = "Island Boy", NPCLocation = CFrame.new(-10171.57, 331.35, -8761.29), MobLocation = CFrame.new(-10250, 355, -8840)},
    {MinLevel = 2500, MaxLevel = 2549, Quest = "Sun-kissed Warrior", QuestId = "SunKissedWarrior", Mob = "Sun-kissed Warrior", NPCLocation = CFrame.new(-10171.57, 331.35, -8761.29), MobLocation = CFrame.new(-10290, 355, -8880)},
    {MinLevel = 2550, MaxLevel = 2599, Quest = "Serpent Hunter", QuestId = "SerpentHunter", Mob = "Serpent Hunter", NPCLocation = CFrame.new(-10171.57, 331.35, -8761.29), MobLocation = CFrame.new(-10370, 355, -8960)},
    {MinLevel = 2600, MaxLevel = 2649, Quest = "Reef Bandit", QuestId = "ReefBandit", Mob = "Reef Bandit", NPCLocation = CFrame.new(-6508.27, 14.35, -1584.97), MobLocation = CFrame.new(-6550, 40, -1620)},
    {MinLevel = 2650, MaxLevel = 2699, Quest = "Sea Chanter", QuestId = "SeaChanter", Mob = "Sea Chanter", NPCLocation = CFrame.new(-6508.27, 14.35, -1584.97), MobLocation = CFrame.new(-6630, 40, -1700)},
    {MinLevel = 2700, MaxLevel = 9999, Quest = "High Disciple", QuestId = "HighDisciple", Mob = "High Disciple", NPCLocation = CFrame.new(-6508.27, 14.35, -1584.97), MobLocation = CFrame.new(-6710, 40, -1780)},
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

-- FIXED: Get quest based on level range, not just minimum level
local function GetBestQuest()
    local level = GetPlayerLevel()
    
    for _, q in ipairs(QuestTable) do
        if level >= q.MinLevel and level <= q.MaxLevel then
            return q
        end
    end
    
    -- Fallback to highest level quest if above all ranges
    return QuestTable[#QuestTable]
end

-- ═══════════════════════════════════════════════════════════════════════════
-- FLYING SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function StartFlying()
    if Config.Flying then return end
    Config.Flying = true
    
    pcall(function()
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = HumanoidRootPart
        
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.P = 10000
        BodyGyro.D = 100
        BodyGyro.CFrame = HumanoidRootPart.CFrame
        BodyGyro.Parent = HumanoidRootPart
    end)
end

local function StopFlying()
    Config.Flying = false
    
    pcall(function()
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        if BodyGyro then
            BodyGyro:Destroy()
            BodyGyro = nil
        end
    end)
end

local function SetFlyVelocity(velocity)
    if BodyVelocity then
        BodyVelocity.Velocity = velocity
    end
end

local function SetFlyRotation(cf)
    if BodyGyro then
        BodyGyro.CFrame = cf
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- TWEEN MOVEMENT
-- ═══════════════════════════════════════════════════════════════════════════

local function StopTween()
    if ActiveTween then
        pcall(function()
            ActiveTween:Cancel()
        end)
        ActiveTween = nil
    end
end

local function TweenTo(targetCFrame, callback)
    if not HumanoidRootPart then return end
    
    StopTween()
    StartFlying()
    IsTweening = true
    
    local startPos = HumanoidRootPart.Position
    local endPos = targetCFrame.Position
    local distance = (endPos - startPos).Magnitude
    local duration = distance / Config.TweenSpeed
    
    if duration < 0.1 then duration = 0.1 end
    if duration > 30 then duration = 30 end
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not Config.Enabled or not HumanoidRootPart then
            StopTween()
            IsTweening = false
            if connection then connection:Disconnect() end
            return
        end
        
        local currentPos = HumanoidRootPart.Position
        local remainingDist = (endPos - currentPos).Magnitude
        
        local newDirection = (endPos - currentPos).Unit
        if newDirection == newDirection then
            SetFlyVelocity(newDirection * Config.TweenSpeed)
            SetFlyRotation(CFrame.new(currentPos, endPos))
        end
        
        if remainingDist < 10 then
            StopTween()
            SetFlyVelocity(Vector3.new(0, 0, 0))
            IsTweening = false
            if connection then connection:Disconnect() end
            if callback then callback() end
        end
    end)
    
    -- Timeout safety
    task.delay(duration + 2, function()
        if connection then
            connection:Disconnect()
            IsTweening = false
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- QUEST SYSTEM - FIXED AUTO ACCEPT
-- ═══════════════════════════════════════════════════════════════════════════

local function HasQuest()
    -- Check if player has an active quest
    local plrGui = Player:FindFirstChild("PlayerGui")
    if plrGui then
        local main = plrGui:FindFirstChild("Main")
        if main then
            local quest = main:FindFirstChild("Quest")
            if quest then
                -- Check if quest frame is visible and has content
                if quest.Visible then
                    local container = quest:FindFirstChild("Container")
                    if container then
                        return true
                    end
                    return true
                end
            end
        end
    end
    
    -- Also check quest progress
    local questProgress = Player:FindFirstChild("PlayerGui")
    if questProgress then
        for _, v in pairs(questProgress:GetDescendants()) do
            if v.Name == "QuestProgress" or v.Name == "QuestTitle" then
                if v:IsA("TextLabel") and v.Text ~= "" then
                    return true
                end
            end
        end
    end
    
    return false
end

local function AcceptQuest(questData)
    -- Multiple methods to accept quest
    
    -- Method 1: CommF_ StartQuest
    pcall(function()
        local args = {
            [1] = "StartQuest",
            [2] = questData.QuestId,
            [3] = 1
        }
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
    
    task.wait(0.2)
    
    -- Method 2: Alternative quest ID format
    pcall(function()
        local args = {
            [1] = "StartQuest",
            [2] = questData.Quest,
            [3] = 1
        }
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
    
    task.wait(0.2)
    
    -- Method 3: Try with mob name
    pcall(function()
        local args = {
            [1] = "StartQuest",
            [2] = questData.Mob,
            [3] = 1
        }
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
    end)
    
    task.wait(0.2)
    
    -- Method 4: Click any visible quest buttons in GUI
    pcall(function()
        local plrGui = Player:FindFirstChild("PlayerGui")
        if plrGui then
            for _, gui in pairs(plrGui:GetDescendants()) do
                if gui:IsA("TextButton") then
                    local text = gui.Text:lower()
                    if text:find("accept") or text:find("start") or text:find("ok") or text:find("yes") then
                        gui:Activate()
                        task.wait(0.1)
                    end
                end
            end
        end
    end)
    
    -- Method 5: Fire proximity prompts near NPC
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                local dist = (HumanoidRootPart.Position - obj.Parent.Position).Magnitude
                if dist < 20 then
                    fireproximityprompt(obj)
                    task.wait(0.1)
                end
            end
        end
    end)
    
    -- Method 6: Fire click detectors
    pcall(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") then
                local parent = obj.Parent
                if parent:FindFirstChild("HumanoidRootPart") or parent:FindFirstChild("Head") then
                    local pos = parent:FindFirstChild("HumanoidRootPart") and parent.HumanoidRootPart.Position or parent.Head.Position
                    local dist = (HumanoidRootPart.Position - pos).Magnitude
                    if dist < 20 then
                        fireclickdetector(obj)
                        task.wait(0.1)
                    end
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MOB SYSTEM - FIXED TO TARGET ALL MOBS
-- ═══════════════════════════════════════════════════════════════════════════

local function GetAllMobs(mobName)
    local mobs = {}
    
    -- Check Enemies folder
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in pairs(enemies:GetChildren()) do
            if mob:IsA("Model") then
                -- Match exact name or partial name
                if mob.Name == mobName or mob.Name:find(mobName) or mobName:find(mob.Name) then
                    local hum = mob:FindFirstChild("Humanoid")
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.Health > 0 then
                        table.insert(mobs, mob)
                    end
                end
            end
        end
    end
    
    -- Also check workspace root
    for _, mob in pairs(Workspace:GetChildren()) do
        if mob:IsA("Model") then
            if mob.Name == mobName or mob.Name:find(mobName) or mobName:find(mob.Name) then
                local hum = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    if not table.find(mobs, mob) then
                        table.insert(mobs, mob)
                    end
                end
            end
        end
    end
    
    -- Sort by distance
    table.sort(mobs, function(a, b)
        local distA = (HumanoidRootPart.Position - a.HumanoidRootPart.Position).Magnitude
        local distB = (HumanoidRootPart.Position - b.HumanoidRootPart.Position).Magnitude
        return distA < distB
    end)
    
    return mobs
end

local function GetNextMob(mobName)
    local mobs = GetAllMobs(mobName)
    
    if #mobs == 0 then
        return nil
    end
    
    -- Cycle through mobs
    CurrentMobIndex = CurrentMobIndex + 1
    if CurrentMobIndex > #mobs then
        CurrentMobIndex = 1
    end
    
    return mobs[CurrentMobIndex]
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ATTACK SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function Attack()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait()
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
    
    pcall(function()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end)
end

local function AttackMob(mob)
    if not mob then return end
    
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    local hum = mob:FindFirstChild("Humanoid")
    
    if not hrp or not hum or hum.Health <= 0 then return end
    
    -- Position above mob
    local targetPos = hrp.Position + Vector3.new(0, Config.FarmHeight, 0)
    local currentPos = HumanoidRootPart.Position
    local direction = (targetPos - currentPos).Unit
    local distance = (targetPos - currentPos).Magnitude
    
    if distance > 5 then
        if direction == direction then
            SetFlyVelocity(direction * math.min(Config.TweenSpeed, distance * 3))
        end
    else
        SetFlyVelocity(Vector3.new(0, 0, 0))
    end
    
    -- Look at mob
    SetFlyRotation(CFrame.new(HumanoidRootPart.Position, hrp.Position))
    
    -- Attack
    Attack()
    
    -- Fire touch interest
    pcall(function()
        if firetouchinterest then
            firetouchinterest(HumanoidRootPart, hrp, 0)
            task.wait()
            firetouchinterest(HumanoidRootPart, hrp, 1)
        end
    end)
end

local function KillAura(mobName)
    if not Config.KillAura then return end
    
    local mobs = GetAllMobs(mobName)
    
    for _, mob in pairs(mobs) do
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        local hum = mob:FindFirstChild("Humanoid")
        
        if hrp and hum and hum.Health > 0 then
            local dist = (HumanoidRootPart.Position - hrp.Position).Magnitude
            
            if dist <= Config.AttackRange then
                pcall(function()
                    if firetouchinterest then
                        firetouchinterest(HumanoidRootPart, hrp, 0)
                        task.wait()
                        firetouchinterest(HumanoidRootPart, hrp, 1)
                    end
                end)
            end
        end
    end
    
    Attack()
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN FARM LOOP
-- ═══════════════════════════════════════════════════════════════════════════

local LastMobSwitchTime = 0

local function Farm()
    while Config.Enabled and task.wait(0.1) do
        pcall(function()
            -- Refresh character
            if not Character or not Character.Parent then
                Character = Player.Character or Player.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild("Humanoid")
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                StopFlying()
            end
            
            if Humanoid.Health <= 0 then
                StopFlying()
                StopTween()
                task.wait(6)
                return
            end
            
            local quest = GetBestQuest()
            if not quest then return end
            
            -- Check if we need quest
            if not HasQuest() then
                if not IsTweening then
                    -- Tween to quest NPC
                    TweenTo(quest.NPCLocation, function()
                        task.wait(0.5)
                        AcceptQuest(quest)
                        task.wait(0.5)
                        AcceptQuest(quest) -- Try twice
                        task.wait(0.5)
                    end)
                end
                return
            end
            
            -- Find mobs - cycle through all of them
            local mobs = GetAllMobs(quest.Mob)
            
            if #mobs > 0 then
                StartFlying()
                
                -- Switch to next mob periodically or if current is dead
                local currentTime = tick()
                if currentTime - LastMobSwitchTime > Config.MobSwitchDelay then
                    LastMobSwitchTime = currentTime
                    
                    -- Find a mob that's alive
                    local targetMob = nil
                    for _, mob in pairs(mobs) do
                        local hum = mob:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then
                            targetMob = mob
                            break
                        end
                    end
                    
                    if targetMob then
                        AttackMob(targetMob)
                        KillAura(quest.Mob)
                    end
                end
            else
                -- No mobs found, tween to mob area
                if not IsTweening then
                    TweenTo(quest.MobLocation, function()
                        task.wait(0.5)
                    end)
                end
            end
        end)
    end
    
    StopFlying()
    StopTween()
end

-- ═══════════════════════════════════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateGUI()
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
    
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Player.PlayerGui
    end
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 240, 0, 250)
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
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.BorderSizePixel = 0
    Title.Text = "🍎 Blox Fruits Farm v5"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame
    
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)
    
    -- Auto Farm Button
    local FarmBtn = Instance.new("TextButton")
    FarmBtn.Size = UDim2.new(0.9, 0, 0, 35)
    FarmBtn.Position = UDim2.new(0.05, 0, 0, 45)
    FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    FarmBtn.BorderSizePixel = 0
    FarmBtn.Text = "Auto Farm: OFF"
    FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmBtn.TextSize = 14
    FarmBtn.Font = Enum.Font.GothamBold
    FarmBtn.Parent = MainFrame
    Instance.new("UICorner", FarmBtn).CornerRadius = UDim.new(0, 8)
    
    FarmBtn.MouseButton1Click:Connect(function()
        Config.Enabled = not Config.Enabled
        if Config.Enabled then
            FarmBtn.Text = "Auto Farm: ON"
            FarmBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            spawn(Farm)
        else
            FarmBtn.Text = "Auto Farm: OFF"
            FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            StopFlying()
            StopTween()
        end
    end)
    
    -- Kill Aura Button
    local AuraBtn = Instance.new("TextButton")
    AuraBtn.Size = UDim2.new(0.9, 0, 0, 35)
    AuraBtn.Position = UDim2.new(0.05, 0, 0, 85)
    AuraBtn.BackgroundColor3 = Config.KillAura and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    AuraBtn.BorderSizePixel = 0
    AuraBtn.Text = "Kill Aura: " .. (Config.KillAura and "ON" or "OFF")
    AuraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AuraBtn.TextSize = 14
    AuraBtn.Font = Enum.Font.GothamBold
    AuraBtn.Parent = MainFrame
    Instance.new("UICorner", AuraBtn).CornerRadius = UDim.new(0, 8)
    
    AuraBtn.MouseButton1Click:Connect(function()
        Config.KillAura = not Config.KillAura
        AuraBtn.Text = "Kill Aura: " .. (Config.KillAura and "ON" or "OFF")
        AuraBtn.BackgroundColor3 = Config.KillAura and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
    end)
    
    -- Info Labels
    local yPos = 130
    
    local LevelLabel = Instance.new("TextLabel")
    LevelLabel.Size = UDim2.new(0.9, 0, 0, 20)
    LevelLabel.Position = UDim2.new(0.05, 0, 0, yPos)
    LevelLabel.BackgroundTransparency = 1
    LevelLabel.Text = "Level: " .. GetPlayerLevel()
    LevelLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    LevelLabel.TextSize = 12
    LevelLabel.Font = Enum.Font.Gotham
    LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
    LevelLabel.Parent = MainFrame
    
    local QuestLabel = Instance.new("TextLabel")
    QuestLabel.Size = UDim2.new(0.9, 0, 0, 20)
    QuestLabel.Position = UDim2.new(0.05, 0, 0, yPos + 22)
    QuestLabel.BackgroundTransparency = 1
    local q = GetBestQuest()
    QuestLabel.Text = "Quest: " .. (q and q.Mob or "None")
    QuestLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    QuestLabel.TextSize = 12
    QuestLabel.Font = Enum.Font.Gotham
    QuestLabel.TextXAlignment = Enum.TextXAlignment.Left
    QuestLabel.Parent = MainFrame
    
    local MobCountLabel = Instance.new("TextLabel")
    MobCountLabel.Size = UDim2.new(0.9, 0, 0, 20)
    MobCountLabel.Position = UDim2.new(0.05, 0, 0, yPos + 44)
    MobCountLabel.BackgroundTransparency = 1
    MobCountLabel.Text = "Mobs Found: 0"
    MobCountLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MobCountLabel.TextSize = 12
    MobCountLabel.Font = Enum.Font.Gotham
    MobCountLabel.TextXAlignment = Enum.TextXAlignment.Left
    MobCountLabel.Parent = MainFrame
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, yPos + 66)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Idle"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = MainFrame
    
    local HasQuestLabel = Instance.new("TextLabel")
    HasQuestLabel.Size = UDim2.new(0.9, 0, 0, 20)
    HasQuestLabel.Position = UDim2.new(0.05, 0, 0, yPos + 88)
    HasQuestLabel.BackgroundTransparency = 1
    HasQuestLabel.Text = "Has Quest: No"
    HasQuestLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    HasQuestLabel.TextSize = 12
    HasQuestLabel.Font = Enum.Font.Gotham
    HasQuestLabel.TextXAlignment = Enum.TextXAlignment.Left
    HasQuestLabel.Parent = MainFrame
    
    -- Update labels
    spawn(function()
        while ScreenGui.Parent do
            task.wait(0.5)
            pcall(function()
                local level = GetPlayerLevel()
                LevelLabel.Text = "Level: " .. level
                
                local q = GetBestQuest()
                QuestLabel.Text = "Quest: " .. (q and q.Mob or "None")
                
                local mobs = q and GetAllMobs(q.Mob) or {}
                MobCountLabel.Text = "Mobs Found: " .. #mobs
                
                HasQuestLabel.Text = "Has Quest: " .. (HasQuest() and "Yes" or "No")
                HasQuestLabel.TextColor3 = HasQuest() and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
                
                if Config.Enabled then
                    if IsTweening then
                        StatusLabel.Text = "Status: Tweening..."
                        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
                    elseif #mobs > 0 then
                        StatusLabel.Text = "Status: Farming"
                        StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
                    else
                        StatusLabel.Text = "Status: Searching..."
                        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
                    end
                else
                    StatusLabel.Text = "Status: Idle"
                    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                end
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
    StopFlying()
    
    if Config.Enabled then
        task.wait(1)
        StartFlying()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZE
-- ═══════════════════════════════════════════════════════════════════════════

local level = GetPlayerLevel()
local q = GetBestQuest()

print("═══════════════════════════════════════════════════")
print("   BLOX FRUITS AUTOFARM v5.0 - ALL FIXES")
print("   Your Level: " .. level)
print("   Quest Range: " .. (q and (q.MinLevel .. "-" .. q.MaxLevel) or "N/A"))
print("   Target Mob: " .. (q and q.Mob or "None"))
print("═══════════════════════════════════════════════════")
print("   FIXES:")
print("   ✓ Correct quest for your level range")
print("   ✓ Attacks ALL mobs (not just 1)")
print("   ✓ Multiple quest accept methods")
print("   ✓ Smooth tweening + flying")
print("═══════════════════════════════════════════════════")

CreateGUI()

print("[AutoFarm] Script loaded! Click Auto Farm to start.")
