--[[
    ╔═══════════════════════════════════════════════════════════════════════════╗
    ║                    BLOX FRUITS AUTOFARM SCRIPT                            ║
    ║                         Version 2.0                                        ║
    ║                                                                            ║
    ║  Features:                                                                 ║
    ║  • Auto quest selection based on your level                               ║
    ║  • Tweens above mobs for safe farming                                     ║
    ║  • Auto-attack from above                                                 ║
    ║  • Works for First Sea, Second Sea, and Third Sea                         ║
    ║  • Anti-AFK system                                                        ║
    ║                                                                            ║
    ║  Instructions:                                                            ║
    ║  1. Execute this script with your preferred executor                      ║
    ║  2. The script will automatically detect your level                       ║
    ║  3. It will get the appropriate quest and start farming                   ║
    ╚═══════════════════════════════════════════════════════════════════════════╝
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local Config = {
    FarmHeight = 25,           -- Height above mobs to farm from
    AttackRange = 50,          -- Range to detect and attack mobs
    TweenSpeed = 250,          -- Speed of tweening (higher = faster)
    AutoQuest = true,          -- Automatically get quests
    AutoFarm = true,           -- Automatically farm mobs
    BringMobs = false,         -- Bring mobs to you (optional)
    FastAttack = true,         -- Enable fast attack
    KillAura = true,           -- Attack all nearby mobs
    AntiAFK = true,            -- Prevent AFK kick
}

-- ═══════════════════════════════════════════════════════════════════════════
-- QUEST DATA - All quests organized by level requirement
-- ═══════════════════════════════════════════════════════════════════════════

local QuestData = {
    -- ═══════════════════════════════════════════════════════════════════════
    -- FIRST SEA (Levels 0-700)
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Marine Starter / Pirate Starter (Level 0)
    {
        Level = 0,
        QuestName = "Bandit",
        QuestNPC = "Bandit Quest Giver",
        MobName = "Bandit",
        Island = "Pirate Starter",
        QuestNPCPosition = CFrame.new(1059.14, 16.35, 1547.54),
        MobPosition = CFrame.new(1060, 16, 1500),
        Sea = 1
    },
    {
        Level = 0,
        QuestName = "Trainee",
        QuestNPC = "Marine Leader",
        MobName = "Trainee",
        Island = "Marine Starter",
        QuestNPCPosition = CFrame.new(-2573.89, 7.18, 2055.27),
        MobPosition = CFrame.new(-2600, 7, 2100),
        Sea = 1
    },
    
    -- Jungle (Level 10-20)
    {
        Level = 10,
        QuestName = "Monkey",
        QuestNPC = "Adventurer",
        MobName = "Monkey",
        Island = "Jungle",
        QuestNPCPosition = CFrame.new(-1604.12, 36.85, 153.56),
        MobPosition = CFrame.new(-1550, 50, 150),
        Sea = 1
    },
    {
        Level = 15,
        QuestName = "Gorilla",
        QuestNPC = "Adventurer",
        MobName = "Gorilla",
        Island = "Jungle",
        QuestNPCPosition = CFrame.new(-1604.12, 36.85, 153.56),
        MobPosition = CFrame.new(-1130, 40, 130),
        Sea = 1
    },
    {
        Level = 20,
        QuestName = "GorillaBoss",
        QuestNPC = "Adventurer",
        MobName = "Gorilla King",
        Island = "Jungle",
        QuestNPCPosition = CFrame.new(-1604.12, 36.85, 153.56),
        MobPosition = CFrame.new(-1223.69, 75.35, -401.23),
        IsBoss = true,
        Sea = 1
    },
    
    -- Pirate Village (Level 30-55)
    {
        Level = 30,
        QuestName = "Pirate",
        QuestNPC = "Pirate Adventurer",
        MobName = "Pirate",
        Island = "Pirate Village",
        QuestNPCPosition = CFrame.new(-1139.59, 4.75, 3825.16),
        MobPosition = CFrame.new(-1200, 10, 3850),
        Sea = 1
    },
    {
        Level = 40,
        QuestName = "Brute",
        QuestNPC = "Pirate Adventurer",
        MobName = "Brute",
        Island = "Pirate Village",
        QuestNPCPosition = CFrame.new(-1139.59, 4.75, 3825.16),
        MobPosition = CFrame.new(-1350, 10, 3950),
        Sea = 1
    },
    {
        Level = 55,
        QuestName = "ChefBoss",
        QuestNPC = "Pirate Adventurer",
        MobName = "Bobby",
        Island = "Pirate Village",
        QuestNPCPosition = CFrame.new(-1139.59, 4.75, 3825.16),
        MobPosition = CFrame.new(-1182.75, 4.75, 3806.32),
        IsBoss = true,
        Sea = 1
    },
    
    -- Desert (Level 60-75)
    {
        Level = 60,
        QuestName = "DesertBandit",
        QuestNPC = "Desert Adventurer",
        MobName = "Desert Bandit",
        Island = "Desert",
        QuestNPCPosition = CFrame.new(895.04, 6.46, 4392.89),
        MobPosition = CFrame.new(900, 10, 4450),
        Sea = 1
    },
    {
        Level = 75,
        QuestName = "DesertOfficer",
        QuestNPC = "Desert Adventurer",
        MobName = "Desert Officer",
        Island = "Desert",
        QuestNPCPosition = CFrame.new(895.04, 6.46, 4392.89),
        MobPosition = CFrame.new(1100, 10, 4300),
        Sea = 1
    },
    
    -- Frozen Village (Level 90-110)
    {
        Level = 90,
        QuestName = "SnowBandit",
        QuestNPC = "Villager",
        MobName = "Snow Bandit",
        Island = "Frozen Village",
        QuestNPCPosition = CFrame.new(1386.21, 87.26, -1298.73),
        MobPosition = CFrame.new(1350, 90, -1350),
        Sea = 1
    },
    {
        Level = 100,
        QuestName = "Snowman",
        QuestNPC = "Villager",
        MobName = "Snowman",
        Island = "Frozen Village",
        QuestNPCPosition = CFrame.new(1386.21, 87.26, -1298.73),
        MobPosition = CFrame.new(1200, 90, -1400),
        Sea = 1
    },
    {
        Level = 105,
        QuestName = "YetiBoss",
        QuestNPC = "Villager",
        MobName = "Yeti",
        Island = "Frozen Village",
        QuestNPCPosition = CFrame.new(1386.21, 87.26, -1298.73),
        MobPosition = CFrame.new(1245.52, 145.35, -1488.46),
        IsBoss = true,
        Sea = 1
    },
    
    -- Marine Fortress (Level 120-130)
    {
        Level = 120,
        QuestName = "ChiefPettyOfficer",
        QuestNPC = "Marine",
        MobName = "Chief Petty Officer",
        Island = "Marine Fortress",
        QuestNPCPosition = CFrame.new(-5035.42, 28.68, 4324.82),
        MobPosition = CFrame.new(-5100, 30, 4350),
        Sea = 1
    },
    {
        Level = 130,
        QuestName = "ViceAdmiralBoss",
        QuestNPC = "Marine",
        MobName = "Vice Admiral",
        Island = "Marine Fortress",
        QuestNPCPosition = CFrame.new(-5035.42, 28.68, 4324.82),
        MobPosition = CFrame.new(-5078.27, 57.85, 4402.07),
        IsBoss = true,
        Sea = 1
    },
    
    -- Skylands (Level 150-175)
    {
        Level = 150,
        QuestName = "SkyBandit",
        QuestNPC = "Sky Adventurer",
        MobName = "Sky Bandit",
        Island = "Skylands",
        QuestNPCPosition = CFrame.new(-4840.27, 717.35, -2622.89),
        MobPosition = CFrame.new(-4900, 720, -2600),
        Sea = 1
    },
    {
        Level = 175,
        QuestName = "DarkMaster",
        QuestNPC = "Sky Adventurer",
        MobName = "Dark Master",
        Island = "Skylands",
        QuestNPCPosition = CFrame.new(-4840.27, 717.35, -2622.89),
        MobPosition = CFrame.new(-4950, 720, -2700),
        Sea = 1
    },
    
    -- Prison (Level 190-240)
    {
        Level = 190,
        QuestName = "Prisoner",
        QuestNPC = "Jail Keeper",
        MobName = "Prisoner",
        Island = "Prison",
        QuestNPCPosition = CFrame.new(4875.27, 5.68, 742.09),
        MobPosition = CFrame.new(4900, 10, 700),
        Sea = 1
    },
    {
        Level = 210,
        QuestName = "DangerousPrisoner",
        QuestNPC = "Jail Keeper",
        MobName = "Dangerous Prisoner",
        Island = "Prison",
        QuestNPCPosition = CFrame.new(4875.27, 5.68, 742.09),
        MobPosition = CFrame.new(4850, 10, 650),
        Sea = 1
    },
    {
        Level = 220,
        QuestName = "WardenBoss",
        QuestNPC = "Head Jailer",
        MobName = "Warden",
        Island = "Prison",
        QuestNPCPosition = CFrame.new(5232.23, 5.68, 474.17),
        MobPosition = CFrame.new(5315.43, 5.68, 476.23),
        IsBoss = true,
        Sea = 1
    },
    {
        Level = 230,
        QuestName = "ChiefWardenBoss",
        QuestNPC = "Head Jailer",
        MobName = "Chief Warden",
        Island = "Prison",
        QuestNPCPosition = CFrame.new(5232.23, 5.68, 474.17),
        MobPosition = CFrame.new(5232.23, 5.68, 474.17),
        IsBoss = true,
        Sea = 1
    },
    {
        Level = 240,
        QuestName = "SwanBoss",
        QuestNPC = "Head Jailer",
        MobName = "Swan",
        Island = "Prison",
        QuestNPCPosition = CFrame.new(5232.23, 5.68, 474.17),
        MobPosition = CFrame.new(5232.23, 5.68, 474.17),
        IsBoss = true,
        Sea = 1
    },
    
    -- Colosseum (Level 250-275)
    {
        Level = 250,
        QuestName = "TogaWarrior",
        QuestNPC = "Colosseum Quest Giver",
        MobName = "Toga Warrior",
        Island = "Colosseum",
        QuestNPCPosition = CFrame.new(-1576.47, 7.35, -2983.54),
        MobPosition = CFrame.new(-1600, 10, -3000),
        Sea = 1
    },
    {
        Level = 275,
        QuestName = "Gladiator",
        QuestNPC = "Colosseum Quest Giver",
        MobName = "Gladiator",
        Island = "Colosseum",
        QuestNPCPosition = CFrame.new(-1576.47, 7.35, -2983.54),
        MobPosition = CFrame.new(-1500, 10, -2900),
        Sea = 1
    },
    
    -- Magma Village (Level 300-350)
    {
        Level = 300,
        QuestName = "MilitarySoldier",
        QuestNPC = "The Mayor",
        MobName = "Military Soldier",
        Island = "Magma Village",
        QuestNPCPosition = CFrame.new(-5316.55, 12.35, 8517.76),
        MobPosition = CFrame.new(-5350, 15, 8550),
        Sea = 1
    },
    {
        Level = 325,
        QuestName = "MilitarySpy",
        QuestNPC = "The Mayor",
        MobName = "Military Spy",
        Island = "Magma Village",
        QuestNPCPosition = CFrame.new(-5316.55, 12.35, 8517.76),
        MobPosition = CFrame.new(-5400, 15, 8600),
        Sea = 1
    },
    {
        Level = 350,
        QuestName = "MagmaAdmiralBoss",
        QuestNPC = "The Mayor",
        MobName = "Magma Admiral",
        Island = "Magma Village",
        QuestNPCPosition = CFrame.new(-5316.55, 12.35, 8517.76),
        MobPosition = CFrame.new(-5316.55, 12.35, 8517.76),
        IsBoss = true,
        Sea = 1
    },
    
    -- Underwater City (Level 375-425)
    {
        Level = 375,
        QuestName = "FishmanWarrior",
        QuestNPC = "King Neptune",
        MobName = "Fishman Warrior",
        Island = "Underwater City",
        QuestNPCPosition = CFrame.new(61112.04, 1512.35, 1519.59),
        MobPosition = CFrame.new(61150, 1515, 1550),
        Sea = 1
    },
    {
        Level = 400,
        QuestName = "FishmanCommando",
        QuestNPC = "King Neptune",
        MobName = "Fishman Commando",
        Island = "Underwater City",
        QuestNPCPosition = CFrame.new(61112.04, 1512.35, 1519.59),
        MobPosition = CFrame.new(61200, 1515, 1600),
        Sea = 1
    },
    {
        Level = 425,
        QuestName = "FishmanLordBoss",
        QuestNPC = "King Neptune",
        MobName = "Fishman Lord",
        Island = "Underwater City",
        QuestNPCPosition = CFrame.new(61112.04, 1512.35, 1519.59),
        MobPosition = CFrame.new(61112.04, 1512.35, 1519.59),
        IsBoss = true,
        Sea = 1
    },
    
    -- Upper Skylands (Level 450-575)
    {
        Level = 450,
        QuestName = "GodsGuard",
        QuestNPC = "Mole",
        MobName = "God's Guard",
        Island = "Upper Skylands",
        QuestNPCPosition = CFrame.new(-4721.32, 843.68, -1953.85),
        MobPosition = CFrame.new(-4750, 845, -2000),
        Sea = 1
    },
    {
        Level = 475,
        QuestName = "Shanda",
        QuestNPC = "Mole",
        MobName = "Shanda",
        Island = "Upper Skylands",
        QuestNPCPosition = CFrame.new(-4721.32, 843.68, -1953.85),
        MobPosition = CFrame.new(-4800, 845, -2050),
        Sea = 1
    },
    {
        Level = 500,
        QuestName = "WysperBoss",
        QuestNPC = "Mole",
        MobName = "Wysper",
        Island = "Upper Skylands",
        QuestNPCPosition = CFrame.new(-4721.32, 843.68, -1953.85),
        MobPosition = CFrame.new(-7859.47, 5545.68, -380.29),
        IsBoss = true,
        Sea = 1
    },
    {
        Level = 525,
        QuestName = "RoyalSquad",
        QuestNPC = "Sky Quest Giver 2",
        MobName = "Royal Squad",
        Island = "Upper Skylands",
        QuestNPCPosition = CFrame.new(-7894.64, 5546.85, -1411.56),
        MobPosition = CFrame.new(-7900, 5550, -1450),
        Sea = 1
    },
    {
        Level = 550,
        QuestName = "RoyalSoldier",
        QuestNPC = "Sky Quest Giver 2",
        MobName = "Royal Soldier",
        Island = "Upper Skylands",
        QuestNPCPosition = CFrame.new(-7894.64, 5546.85, -1411.56),
        MobPosition = CFrame.new(-7950, 5550, -1500),
        Sea = 1
    },
    {
        Level = 575,
        QuestName = "ThunderGodBoss",
        QuestNPC = "Sky Quest Giver 2",
        MobName = "Thunder God",
        Island = "Upper Skylands",
        QuestNPCPosition = CFrame.new(-7894.64, 5546.85, -1411.56),
        MobPosition = CFrame.new(-7894.64, 5546.85, -1411.56),
        IsBoss = true,
        Sea = 1
    },
    
    -- Fountain City (Level 625-675)
    {
        Level = 625,
        QuestName = "GalleyPirate",
        QuestNPC = "Freezeburg Quest Giver",
        MobName = "Galley Pirate",
        Island = "Fountain City",
        QuestNPCPosition = CFrame.new(5254.66, 38.35, 4050.07),
        MobPosition = CFrame.new(5300, 40, 4100),
        Sea = 1
    },
    {
        Level = 650,
        QuestName = "GalleyCaptain",
        QuestNPC = "Freezeburg Quest Giver",
        MobName = "Galley Captain",
        Island = "Fountain City",
        QuestNPCPosition = CFrame.new(5254.66, 38.35, 4050.07),
        MobPosition = CFrame.new(5350, 40, 4150),
        Sea = 1
    },
    {
        Level = 675,
        QuestName = "CyborgBoss",
        QuestNPC = "Freezeburg Quest Giver",
        MobName = "Cyborg",
        Island = "Fountain City",
        QuestNPCPosition = CFrame.new(5254.66, 38.35, 4050.07),
        MobPosition = CFrame.new(5254.66, 38.35, 4050.07),
        IsBoss = true,
        Sea = 1
    },
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- SECOND SEA (Levels 700-1475)
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Kingdom of Rose (Level 700-850)
    {
        Level = 700,
        QuestName = "Raider",
        QuestNPC = "Area 1 Quest Giver",
        MobName = "Raider",
        Island = "Kingdom of Rose",
        QuestNPCPosition = CFrame.new(-424.34, 73.08, 1836.93),
        MobPosition = CFrame.new(-450, 75, 1850),
        Sea = 2
    },
    {
        Level = 725,
        QuestName = "Mercenary",
        QuestNPC = "Area 1 Quest Giver",
        MobName = "Mercenary",
        Island = "Kingdom of Rose",
        QuestNPCPosition = CFrame.new(-424.34, 73.08, 1836.93),
        MobPosition = CFrame.new(-500, 75, 1900),
        Sea = 2
    },
    {
        Level = 750,
        QuestName = "DiamondBoss",
        QuestNPC = "Area 1 Quest Giver",
        MobName = "Diamond",
        Island = "Kingdom of Rose",
        QuestNPCPosition = CFrame.new(-424.34, 73.08, 1836.93),
        MobPosition = CFrame.new(-1897.72, 73.08, 2372.42),
        IsBoss = true,
        Sea = 2
    },
    {
        Level = 775,
        QuestName = "SwanPirate",
        QuestNPC = "Area 2 Quest Giver",
        MobName = "Swan Pirate",
        Island = "Kingdom of Rose",
        QuestNPCPosition = CFrame.new(98.7, 17.35, 1552.16),
        MobPosition = CFrame.new(120, 20, 1580),
        Sea = 2
    },
    {
        Level = 800,
        QuestName = "FactoryStaff",
        QuestNPC = "Area 2 Quest Giver",
        MobName = "Factory Staff",
        Island = "Kingdom of Rose",
        QuestNPCPosition = CFrame.new(98.7, 17.35, 1552.16),
        MobPosition = CFrame.new(150, 20, 1600),
        Sea = 2
    },
    {
        Level = 850,
        QuestName = "JeremyBoss",
        QuestNPC = "Area 2 Quest Giver",
        MobName = "Jeremy",
        Island = "Kingdom of Rose",
        QuestNPCPosition = CFrame.new(98.7, 17.35, 1552.16),
        MobPosition = CFrame.new(98.7, 17.35, 1552.16),
        IsBoss = true,
        Sea = 2
    },
    
    -- Green Zone (Level 875-925)
    {
        Level = 875,
        QuestName = "MarineLieutenant",
        QuestNPC = "Marine Quest Giver",
        MobName = "Marine Lieutenant",
        Island = "Green Zone",
        QuestNPCPosition = CFrame.new(-2442.08, 73.08, -3218.05),
        MobPosition = CFrame.new(-2500, 75, -3250),
        Sea = 2
    },
    {
        Level = 900,
        QuestName = "MarineCaptain",
        QuestNPC = "Marine Quest Giver",
        MobName = "Marine Captain",
        Island = "Green Zone",
        QuestNPCPosition = CFrame.new(-2442.08, 73.08, -3218.05),
        MobPosition = CFrame.new(-2550, 75, -3300),
        Sea = 2
    },
    {
        Level = 925,
        QuestName = "OrbitusBoss",
        QuestNPC = "Marine Quest Giver",
        MobName = "Orbitus",
        Island = "Green Zone",
        QuestNPCPosition = CFrame.new(-2442.08, 73.08, -3218.05),
        MobPosition = CFrame.new(-2442.08, 73.08, -3218.05),
        IsBoss = true,
        Sea = 2
    },
    
    -- Graveyard Island (Level 950-975)
    {
        Level = 950,
        QuestName = "Zombie",
        QuestNPC = "Graveyard Quest Giver",
        MobName = "Zombie",
        Island = "Graveyard Island",
        QuestNPCPosition = CFrame.new(-5765.71, 51.97, -793.17),
        MobPosition = CFrame.new(-5800, 55, -800),
        Sea = 2
    },
    {
        Level = 975,
        QuestName = "Vampire",
        QuestNPC = "Graveyard Quest Giver",
        MobName = "Vampire",
        Island = "Graveyard Island",
        QuestNPCPosition = CFrame.new(-5765.71, 51.97, -793.17),
        MobPosition = CFrame.new(-5850, 55, -850),
        Sea = 2
    },
    
    -- Snow Mountain (Level 1000-1150)
    {
        Level = 1000,
        QuestName = "SnowTrooper",
        QuestNPC = "Snow Quest Giver",
        MobName = "Snow Trooper",
        Island = "Snow Mountain",
        QuestNPCPosition = CFrame.new(609.32, 400.35, -5372.38),
        MobPosition = CFrame.new(650, 405, -5400),
        Sea = 2
    },
    {
        Level = 1050,
        QuestName = "WinterWarrior",
        QuestNPC = "Snow Quest Giver",
        MobName = "Winter Warrior",
        Island = "Snow Mountain",
        QuestNPCPosition = CFrame.new(609.32, 400.35, -5372.38),
        MobPosition = CFrame.new(700, 405, -5450),
        Sea = 2
    },
    {
        Level = 1100,
        QuestName = "LabSubordinate",
        QuestNPC = "Ice Quest Giver",
        MobName = "Lab Subordinate",
        Island = "Snow Mountain",
        QuestNPCPosition = CFrame.new(1361.88, 68.35, -5765.86),
        MobPosition = CFrame.new(1400, 70, -5800),
        Sea = 2
    },
    {
        Level = 1125,
        QuestName = "HornedWarrior",
        QuestNPC = "Ice Quest Giver",
        MobName = "Horned Warrior",
        Island = "Snow Mountain",
        QuestNPCPosition = CFrame.new(1361.88, 68.35, -5765.86),
        MobPosition = CFrame.new(1450, 70, -5850),
        Sea = 2
    },
    {
        Level = 1150,
        QuestName = "SmokeAdmiralBoss",
        QuestNPC = "Ice Quest Giver",
        MobName = "Smoke Admiral",
        Island = "Hot and Cold",
        QuestNPCPosition = CFrame.new(1361.88, 68.35, -5765.86),
        MobPosition = CFrame.new(1361.88, 68.35, -5765.86),
        IsBoss = true,
        Sea = 2
    },
    
    -- Hot and Cold (Level 1175-1200)
    {
        Level = 1175,
        QuestName = "MagmaNinja",
        QuestNPC = "Fire Quest Giver",
        MobName = "Magma Ninja",
        Island = "Hot and Cold",
        QuestNPCPosition = CFrame.new(-5428.08, 16.68, -5299.8),
        MobPosition = CFrame.new(-5450, 20, -5320),
        Sea = 2
    },
    {
        Level = 1200,
        QuestName = "LavaPirate",
        QuestNPC = "Fire Quest Giver",
        MobName = "Lava Pirate",
        Island = "Hot and Cold",
        QuestNPCPosition = CFrame.new(-5428.08, 16.68, -5299.8),
        MobPosition = CFrame.new(-5500, 20, -5350),
        Sea = 2
    },
    
    -- Cursed Ship (Level 1250-1325)
    {
        Level = 1250,
        QuestName = "ShipDeckhand",
        QuestNPC = "Rear Crew Quest Giver",
        MobName = "Ship Deckhand",
        Island = "Cursed Ship",
        QuestNPCPosition = CFrame.new(916.6, 125.08, 33056.93),
        MobPosition = CFrame.new(950, 130, 33100),
        Sea = 2
    },
    {
        Level = 1275,
        QuestName = "ShipEngineer",
        QuestNPC = "Rear Crew Quest Giver",
        MobName = "Ship Engineer",
        Island = "Cursed Ship",
        QuestNPCPosition = CFrame.new(916.6, 125.08, 33056.93),
        MobPosition = CFrame.new(1000, 130, 33150),
        Sea = 2
    },
    {
        Level = 1300,
        QuestName = "ShipSteward",
        QuestNPC = "Front Crew Quest Giver",
        MobName = "Ship Steward",
        Island = "Cursed Ship",
        QuestNPCPosition = CFrame.new(936.87, 125.08, 32906.04),
        MobPosition = CFrame.new(970, 130, 32950),
        Sea = 2
    },
    {
        Level = 1325,
        QuestName = "ShipOfficer",
        QuestNPC = "Front Crew Quest Giver",
        MobName = "Ship Officer",
        Island = "Cursed Ship",
        QuestNPCPosition = CFrame.new(936.87, 125.08, 32906.04),
        MobPosition = CFrame.new(1020, 130, 33000),
        Sea = 2
    },
    
    -- Ice Castle (Level 1350-1400)
    {
        Level = 1350,
        QuestName = "ArcticWarrior",
        QuestNPC = "Frost Quest Giver",
        MobName = "Arctic Warrior",
        Island = "Ice Castle",
        QuestNPCPosition = CFrame.new(5669.88, 28.35, -6483.75),
        MobPosition = CFrame.new(5700, 30, -6500),
        Sea = 2
    },
    {
        Level = 1375,
        QuestName = "SnowLurker",
        QuestNPC = "Frost Quest Giver",
        MobName = "Snow Lurker",
        Island = "Ice Castle",
        QuestNPCPosition = CFrame.new(5669.88, 28.35, -6483.75),
        MobPosition = CFrame.new(5750, 30, -6550),
        Sea = 2
    },
    {
        Level = 1400,
        QuestName = "AwakenedIceAdmiralBoss",
        QuestNPC = "Frost Quest Giver",
        MobName = "Awakened Ice Admiral",
        Island = "Ice Castle",
        QuestNPCPosition = CFrame.new(5669.88, 28.35, -6483.75),
        MobPosition = CFrame.new(5669.88, 28.35, -6483.75),
        IsBoss = true,
        Sea = 2
    },
    
    -- Forgotten Island (Level 1425-1475)
    {
        Level = 1425,
        QuestName = "SeaSoldier",
        QuestNPC = "Forgotten Quest Giver",
        MobName = "Sea Soldier",
        Island = "Forgotten Island",
        QuestNPCPosition = CFrame.new(-3054.58, 236.85, -10147.89),
        MobPosition = CFrame.new(-3100, 240, -10180),
        Sea = 2
    },
    {
        Level = 1450,
        QuestName = "WaterFighter",
        QuestNPC = "Forgotten Quest Giver",
        MobName = "Water Fighter",
        Island = "Forgotten Island",
        QuestNPCPosition = CFrame.new(-3054.58, 236.85, -10147.89),
        MobPosition = CFrame.new(-3150, 240, -10220),
        Sea = 2
    },
    {
        Level = 1475,
        QuestName = "TideKeeperBoss",
        QuestNPC = "Forgotten Quest Giver",
        MobName = "Tide Keeper",
        Island = "Forgotten Island",
        QuestNPCPosition = CFrame.new(-3054.58, 236.85, -10147.89),
        MobPosition = CFrame.new(-3054.58, 236.85, -10147.89),
        IsBoss = true,
        Sea = 2
    },
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- THIRD SEA (Levels 1500-2725)
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Port Town (Level 1500-1550)
    {
        Level = 1500,
        QuestName = "PirateMillionaire",
        QuestNPC = "Pirate Port Quest Giver",
        MobName = "Pirate Millionaire",
        Island = "Port Town",
        QuestNPCPosition = CFrame.new(-290.06, 44.08, 5322.43),
        MobPosition = CFrame.new(-320, 50, 5350),
        Sea = 3
    },
    {
        Level = 1525,
        QuestName = "PistolBillionaire",
        QuestNPC = "Pirate Port Quest Giver",
        MobName = "Pistol Billionaire",
        Island = "Port Town",
        QuestNPCPosition = CFrame.new(-290.06, 44.08, 5322.43),
        MobPosition = CFrame.new(-350, 50, 5400),
        Sea = 3
    },
    {
        Level = 1550,
        QuestName = "StoneBoss",
        QuestNPC = "Pirate Port Quest Giver",
        MobName = "Stone",
        Island = "Port Town",
        QuestNPCPosition = CFrame.new(-290.06, 44.08, 5322.43),
        MobPosition = CFrame.new(-290.06, 44.08, 5322.43),
        IsBoss = true,
        Sea = 3
    },
    
    -- Hydra Island (Level 1575-1675)
    {
        Level = 1575,
        QuestName = "DragonCrewWarrior",
        QuestNPC = "Dragon Crew Quest Giver",
        MobName = "Dragon Crew Warrior",
        Island = "Hydra Island",
        QuestNPCPosition = CFrame.new(-4328.01, 843.68, -1641.77),
        MobPosition = CFrame.new(-4350, 850, -1670),
        Sea = 3
    },
    {
        Level = 1600,
        QuestName = "DragonCrewArcher",
        QuestNPC = "Dragon Crew Quest Giver",
        MobName = "Dragon Crew Archer",
        Island = "Hydra Island",
        QuestNPCPosition = CFrame.new(-4328.01, 843.68, -1641.77),
        MobPosition = CFrame.new(-4400, 850, -1700),
        Sea = 3
    },
    {
        Level = 1625,
        QuestName = "HydraEnforcer",
        QuestNPC = "Hydra Town Quest Giver",
        MobName = "Hydra Enforcer",
        Island = "Hydra Island",
        QuestNPCPosition = CFrame.new(-5765.82, 296.68, -3045.54),
        MobPosition = CFrame.new(-5800, 300, -3080),
        Sea = 3
    },
    {
        Level = 1650,
        QuestName = "VenomousAssailant",
        QuestNPC = "Hydra Town Quest Giver",
        MobName = "Venomous Assailant",
        Island = "Hydra Island",
        QuestNPCPosition = CFrame.new(-5765.82, 296.68, -3045.54),
        MobPosition = CFrame.new(-5850, 300, -3120),
        Sea = 3
    },
    {
        Level = 1675,
        QuestName = "HydraLeaderBoss",
        QuestNPC = "Hydra Town Quest Giver",
        MobName = "Hydra Leader",
        Island = "Hydra Island",
        QuestNPCPosition = CFrame.new(-5765.82, 296.68, -3045.54),
        MobPosition = CFrame.new(-5765.82, 296.68, -3045.54),
        IsBoss = true,
        Sea = 3
    },
    
    -- Great Tree (Level 1700-1750)
    {
        Level = 1700,
        QuestName = "MarineCommodore",
        QuestNPC = "Marine Tree Quest Giver",
        MobName = "Marine Commodore",
        Island = "Great Tree",
        QuestNPCPosition = CFrame.new(2276.63, 27.35, -6623.08),
        MobPosition = CFrame.new(2310, 30, -6650),
        Sea = 3
    },
    {
        Level = 1725,
        QuestName = "MarineRearAdmiral",
        QuestNPC = "Marine Tree Quest Giver",
        MobName = "Marine Rear Admiral",
        Island = "Great Tree",
        QuestNPCPosition = CFrame.new(2276.63, 27.35, -6623.08),
        MobPosition = CFrame.new(2350, 30, -6700),
        Sea = 3
    },
    {
        Level = 1750,
        QuestName = "KiloAdmiralBoss",
        QuestNPC = "Marine Tree Quest Giver",
        MobName = "Kilo Admiral",
        Island = "Great Tree",
        QuestNPCPosition = CFrame.new(2276.63, 27.35, -6623.08),
        MobPosition = CFrame.new(2276.63, 27.35, -6623.08),
        IsBoss = true,
        Sea = 3
    },
    
    -- Floating Turtle (Level 1775-1950)
    {
        Level = 1775,
        QuestName = "FishmanRaider",
        QuestNPC = "Turtle Adventure Quest Giver",
        MobName = "Fishman Raider",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-13232.57, 332.68, -7625.16),
        MobPosition = CFrame.new(-13270, 335, -7660),
        Sea = 3
    },
    {
        Level = 1800,
        QuestName = "FishmanCaptain",
        QuestNPC = "Turtle Adventure Quest Giver",
        MobName = "Fishman Captain",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-13232.57, 332.68, -7625.16),
        MobPosition = CFrame.new(-13300, 335, -7700),
        Sea = 3
    },
    {
        Level = 1825,
        QuestName = "ForestPirate",
        QuestNPC = "Deep Forest Quest Giver",
        MobName = "Forest Pirate",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-12681.67, 390.68, -7656.42),
        MobPosition = CFrame.new(-12720, 395, -7690),
        Sea = 3
    },
    {
        Level = 1850,
        QuestName = "MythologicalPirate",
        QuestNPC = "Deep Forest Quest Giver",
        MobName = "Mythological Pirate",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-12681.67, 390.68, -7656.42),
        MobPosition = CFrame.new(-12750, 395, -7720),
        Sea = 3
    },
    {
        Level = 1875,
        QuestName = "CaptainElephantBoss",
        QuestNPC = "Deep Forest Quest Giver",
        MobName = "Captain Elephant",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-12681.67, 390.68, -7656.42),
        MobPosition = CFrame.new(-12681.67, 390.68, -7656.42),
        IsBoss = true,
        Sea = 3
    },
    {
        Level = 1900,
        QuestName = "JunglePirate",
        QuestNPC = "Deep Forest Area 2 Quest Giver",
        MobName = "Jungle Pirate",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-12903.72, 331.35, -8410.23),
        MobPosition = CFrame.new(-12940, 335, -8450),
        Sea = 3
    },
    {
        Level = 1925,
        QuestName = "MusketeerPirate",
        QuestNPC = "Deep Forest Area 2 Quest Giver",
        MobName = "Musketeer Pirate",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-12903.72, 331.35, -8410.23),
        MobPosition = CFrame.new(-12980, 335, -8490),
        Sea = 3
    },
    {
        Level = 1950,
        QuestName = "BeautifulPirateBoss",
        QuestNPC = "Deep Forest Area 2 Quest Giver",
        MobName = "Beautiful Pirate",
        Island = "Floating Turtle",
        QuestNPCPosition = CFrame.new(-12903.72, 331.35, -8410.23),
        MobPosition = CFrame.new(-12903.72, 331.35, -8410.23),
        IsBoss = true,
        Sea = 3
    },
    
    -- Haunted Castle (Level 1975-2050)
    {
        Level = 1975,
        QuestName = "RebornSkeleton",
        QuestNPC = "Haunted Castle Quest Giver 1",
        MobName = "Reborn Skeleton",
        Island = "Haunted Castle",
        QuestNPCPosition = CFrame.new(-9480.65, 146.35, 5765.08),
        MobPosition = CFrame.new(-9520, 150, 5800),
        Sea = 3
    },
    {
        Level = 2000,
        QuestName = "LivingZombie",
        QuestNPC = "Haunted Castle Quest Giver 1",
        MobName = "Living Zombie",
        Island = "Haunted Castle",
        QuestNPCPosition = CFrame.new(-9480.65, 146.35, 5765.08),
        MobPosition = CFrame.new(-9560, 150, 5840),
        Sea = 3
    },
    {
        Level = 2025,
        QuestName = "DemonicSoul",
        QuestNPC = "Haunted Castle Quest Giver 2",
        MobName = "Demonic Soul",
        Island = "Haunted Castle",
        QuestNPCPosition = CFrame.new(-9516.09, 197.35, 6299.32),
        MobPosition = CFrame.new(-9550, 200, 6340),
        Sea = 3
    },
    {
        Level = 2050,
        QuestName = "PossessedMummy",
        QuestNPC = "Haunted Castle Quest Giver 2",
        MobName = "Possessed Mummy",
        Island = "Haunted Castle",
        QuestNPCPosition = CFrame.new(-9516.09, 197.35, 6299.32),
        MobPosition = CFrame.new(-9590, 200, 6380),
        Sea = 3
    },
    
    -- Sea of Treats (Level 2075-2425)
    {
        Level = 2075,
        QuestName = "PeanutScout",
        QuestNPC = "Peanut Quest Giver",
        MobName = "Peanut Scout",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-2149.69, 29.35, -10185.63),
        MobPosition = CFrame.new(-2180, 35, -10220),
        Sea = 3
    },
    {
        Level = 2100,
        QuestName = "PeanutPresident",
        QuestNPC = "Peanut Quest Giver",
        MobName = "Peanut President",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-2149.69, 29.35, -10185.63),
        MobPosition = CFrame.new(-2220, 35, -10260),
        Sea = 3
    },
    {
        Level = 2125,
        QuestName = "IceCreamChef",
        QuestNPC = "Ice Cream Quest Giver",
        MobName = "Ice Cream Chef",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1099.37, 40.35, -11422.25),
        MobPosition = CFrame.new(-1130, 45, -11460),
        Sea = 3
    },
    {
        Level = 2150,
        QuestName = "IceCreamCommander",
        QuestNPC = "Ice Cream Quest Giver",
        MobName = "Ice Cream Commander",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1099.37, 40.35, -11422.25),
        MobPosition = CFrame.new(-1170, 45, -11500),
        Sea = 3
    },
    {
        Level = 2175,
        QuestName = "CakeQueenBoss",
        QuestNPC = "Ice Cream Quest Giver",
        MobName = "Cake Queen",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1099.37, 40.35, -11422.25),
        MobPosition = CFrame.new(-1099.37, 40.35, -11422.25),
        IsBoss = true,
        Sea = 3
    },
    {
        Level = 2200,
        QuestName = "CookieCrafter",
        QuestNPC = "Cake Quest Giver 1",
        MobName = "Cookie Crafter",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1869.56, 14.35, -11667.89),
        MobPosition = CFrame.new(-1900, 20, -11700),
        Sea = 3
    },
    {
        Level = 2225,
        QuestName = "CakeGuard",
        QuestNPC = "Cake Quest Giver 1",
        MobName = "Cake Guard",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1869.56, 14.35, -11667.89),
        MobPosition = CFrame.new(-1940, 20, -11740),
        Sea = 3
    },
    {
        Level = 2250,
        QuestName = "BakingStaff",
        QuestNPC = "Cake Quest Giver 2",
        MobName = "Baking Staff",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1869.56, 14.35, -11667.89),
        MobPosition = CFrame.new(-1980, 20, -11780),
        Sea = 3
    },
    {
        Level = 2275,
        QuestName = "HeadBaker",
        QuestNPC = "Cake Quest Giver 2",
        MobName = "Head Baker",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1869.56, 14.35, -11667.89),
        MobPosition = CFrame.new(-2020, 20, -11820),
        Sea = 3
    },
    {
        Level = 2300,
        QuestName = "CocoaWarrior",
        QuestNPC = "Chocolate Quest Giver 1",
        MobName = "Cocoa Warrior",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(651.19, 14.35, -12551.89),
        MobPosition = CFrame.new(680, 20, -12590),
        Sea = 3
    },
    {
        Level = 2325,
        QuestName = "ChocolateBarBattler",
        QuestNPC = "Chocolate Quest Giver 1",
        MobName = "Chocolate Bar Battler",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(651.19, 14.35, -12551.89),
        MobPosition = CFrame.new(720, 20, -12630),
        Sea = 3
    },
    {
        Level = 2350,
        QuestName = "SweetThief",
        QuestNPC = "Chocolate Quest Giver 2",
        MobName = "Sweet Thief",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(651.19, 14.35, -12551.89),
        MobPosition = CFrame.new(760, 20, -12670),
        Sea = 3
    },
    {
        Level = 2375,
        QuestName = "CandyRebel",
        QuestNPC = "Chocolate Quest Giver 2",
        MobName = "Candy Rebel",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(651.19, 14.35, -12551.89),
        MobPosition = CFrame.new(800, 20, -12710),
        Sea = 3
    },
    {
        Level = 2400,
        QuestName = "CandyPirate",
        QuestNPC = "Candy Cane Quest Giver",
        MobName = "Candy Pirate",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1552.74, 56.35, -10813.88),
        MobPosition = CFrame.new(-1590, 60, -10850),
        Sea = 3
    },
    {
        Level = 2425,
        QuestName = "SnowDemon",
        QuestNPC = "Candy Cane Quest Giver",
        MobName = "Snow Demon",
        Island = "Sea of Treats",
        QuestNPCPosition = CFrame.new(-1552.74, 56.35, -10813.88),
        MobPosition = CFrame.new(-1630, 60, -10890),
        Sea = 3
    },
    
    -- Tiki Outpost (Level 2450-2575)
    {
        Level = 2450,
        QuestName = "IsleOutlaw",
        QuestNPC = "Tiki Quest Giver 1",
        MobName = "Isle Outlaw",
        Island = "Tiki Outpost",
        QuestNPCPosition = CFrame.new(-10171.57, 331.35, -8761.29),
        MobPosition = CFrame.new(-10210, 335, -8800),
        Sea = 3
    },
    {
        Level = 2475,
        QuestName = "IslandBoy",
        QuestNPC = "Tiki Quest Giver 1",
        MobName = "Island Boy",
        Island = "Tiki Outpost",
        QuestNPCPosition = CFrame.new(-10171.57, 331.35, -8761.29),
        MobPosition = CFrame.new(-10250, 335, -8840),
        Sea = 3
    },
    {
        Level = 2500,
        QuestName = "SunKissedWarrior",
        QuestNPC = "Tiki Quest Giver 2",
        MobName = "Sun-kissed Warrior",
        Island = "Tiki Outpost",
        QuestNPCPosition = CFrame.new(-10171.57, 331.35, -8761.29),
        MobPosition = CFrame.new(-10290, 335, -8880),
        Sea = 3
    },
    {
        Level = 2525,
        QuestName = "IsleChampion",
        QuestNPC = "Tiki Quest Giver 2",
        MobName = "Isle Champion",
        Island = "Tiki Outpost",
        QuestNPCPosition = CFrame.new(-10171.57, 331.35, -8761.29),
        MobPosition = CFrame.new(-10330, 335, -8920),
        Sea = 3
    },
    {
        Level = 2550,
        QuestName = "SerpentHunter",
        QuestNPC = "Tiki Quest Giver 3",
        MobName = "Serpent Hunter",
        Island = "Tiki Outpost",
        QuestNPCPosition = CFrame.new(-10171.57, 331.35, -8761.29),
        MobPosition = CFrame.new(-10370, 335, -8960),
        Sea = 3
    },
    {
        Level = 2575,
        QuestName = "SkullSlayer",
        QuestNPC = "Tiki Quest Giver 3",
        MobName = "Skull Slayer",
        Island = "Tiki Outpost",
        QuestNPCPosition = CFrame.new(-10171.57, 331.35, -8761.29),
        MobPosition = CFrame.new(-10410, 335, -9000),
        Sea = 3
    },
    
    -- Submerged Island (Level 2600-2725)
    {
        Level = 2600,
        QuestName = "ReefBandit",
        QuestNPC = "Submerged Quest Giver 1",
        MobName = "Reef Bandit",
        Island = "Submerged Island",
        QuestNPCPosition = CFrame.new(-6508.27, 14.35, -1584.97),
        MobPosition = CFrame.new(-6550, 20, -1620),
        Sea = 3
    },
    {
        Level = 2625,
        QuestName = "CoralPirate",
        QuestNPC = "Submerged Quest Giver 1",
        MobName = "Coral Pirate",
        Island = "Submerged Island",
        QuestNPCPosition = CFrame.new(-6508.27, 14.35, -1584.97),
        MobPosition = CFrame.new(-6590, 20, -1660),
        Sea = 3
    },
    {
        Level = 2650,
        QuestName = "SeaChanter",
        QuestNPC = "Submerged Quest Giver 2",
        MobName = "Sea Chanter",
        Island = "Submerged Island",
        QuestNPCPosition = CFrame.new(-6508.27, 14.35, -1584.97),
        MobPosition = CFrame.new(-6630, 20, -1700),
        Sea = 3
    },
    {
        Level = 2675,
        QuestName = "OceanProphet",
        QuestNPC = "Submerged Quest Giver 2",
        MobName = "Ocean Prophet",
        Island = "Submerged Island",
        QuestNPCPosition = CFrame.new(-6508.27, 14.35, -1584.97),
        MobPosition = CFrame.new(-6670, 20, -1740),
        Sea = 3
    },
    {
        Level = 2700,
        QuestName = "HighDisciple",
        QuestNPC = "Submerged Quest Giver 3",
        MobName = "High Disciple",
        Island = "Submerged Island",
        QuestNPCPosition = CFrame.new(-6508.27, 14.35, -1584.97),
        MobPosition = CFrame.new(-6710, 20, -1780),
        Sea = 3
    },
    {
        Level = 2725,
        QuestName = "GrandDevotee",
        QuestNPC = "Submerged Quest Giver 3",
        MobName = "Grand Devotee",
        Island = "Submerged Island",
        QuestNPCPosition = CFrame.new(-6508.27, 14.35, -1584.97),
        MobPosition = CFrame.new(-6750, 20, -1820),
        Sea = 3
    },
}

-- ═══════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Get player's current level
local function GetPlayerLevel()
    local stats = Player:FindFirstChild("Data")
    if stats then
        local level = stats:FindFirstChild("Level")
        if level then
            return level.Value
        end
    end
    return 0
end

-- Get current sea (1, 2, or 3)
local function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        return 1 -- First Sea
    elseif placeId == 4442272183 then
        return 2 -- Second Sea
    elseif placeId == 7449423635 then
        return 3 -- Third Sea
    end
    return 1 -- Default to First Sea
end

-- Find the best quest for player's level
local function GetBestQuest()
    local playerLevel = GetPlayerLevel()
    local currentSea = GetCurrentSea()
    local bestQuest = nil
    
    for _, quest in ipairs(QuestData) do
        if quest.Sea == currentSea and quest.Level <= playerLevel then
            if not bestQuest or quest.Level > bestQuest.Level then
                bestQuest = quest
            end
        end
    end
    
    return bestQuest
end

-- Check if player has an active quest
local function HasActiveQuest()
    local questUI = Player.PlayerGui:FindFirstChild("Main")
    if questUI then
        local questFrame = questUI:FindFirstChild("Quest")
        if questFrame and questFrame.Visible then
            return true
        end
    end
    return false
end

-- Get current quest progress
local function GetQuestProgress()
    local questUI = Player.PlayerGui:FindFirstChild("Main")
    if questUI then
        local questFrame = questUI:FindFirstChild("Quest")
        if questFrame then
            local container = questFrame:FindFirstChild("Container")
            if container then
                local questText = container:FindFirstChild("QuestTitle")
                if questText then
                    local text = questText.Text
                    local current, total = text:match("(%d+)/(%d+)")
                    if current and total then
                        return tonumber(current), tonumber(total)
                    end
                end
            end
        end
    end
    return 0, 0
end

-- Check if quest is complete
local function IsQuestComplete()
    local current, total = GetQuestProgress()
    return current >= total and total > 0
end

-- Tween to position
local function TweenTo(targetCFrame, speed)
    speed = speed or Config.TweenSpeed
    
    if not Character or not HumanoidRootPart then
        Character = Player.Character or Player.CharacterAdded:Wait()
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    end
    
    local distance = (HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local tweenTime = distance / speed
    
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    tween.Completed:Wait()
end

-- Find nearest mob by name
local function FindNearestMob(mobName)
    local mobs = workspace:FindFirstChild("Enemies") or workspace
    local nearestMob = nil
    local nearestDistance = math.huge
    
    for _, mob in pairs(mobs:GetDescendants()) do
        if mob:IsA("Model") and mob.Name == mobName then
            local humanoid = mob:FindFirstChild("Humanoid")
            local rootPart = mob:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - rootPart.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestMob = mob
                end
            end
        end
    end
    
    return nearestMob
end

-- Find all mobs by name
local function FindAllMobs(mobName)
    local mobs = workspace:FindFirstChild("Enemies") or workspace
    local foundMobs = {}
    
    for _, mob in pairs(mobs:GetDescendants()) do
        if mob:IsA("Model") and mob.Name == mobName then
            local humanoid = mob:FindFirstChild("Humanoid")
            local rootPart = mob:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 then
                table.insert(foundMobs, mob)
            end
        end
    end
    
    return foundMobs
end

-- Attack mob
local function AttackMob(mob)
    if not mob then return end
    
    local rootPart = mob:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Position above the mob
    local targetPosition = rootPart.CFrame * CFrame.new(0, Config.FarmHeight, 0)
    HumanoidRootPart.CFrame = targetPosition
    
    -- Click attack
    local args = {
        [1] = rootPart.Position
    }
    
    -- Use virtual input for attack
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.05)
    virtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- Fast attack function
local function FastAttack()
    if not Config.FastAttack then return end
    
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool then
        local remote = tool:FindFirstChild("RemoteEvent") or tool:FindFirstChildOfClass("RemoteEvent")
        if remote then
            remote:FireServer()
        end
    end
    
    -- Also try to attack using virtual click
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    task.wait(0.01)
    virtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- Kill aura - attack all nearby mobs
local function KillAura(mobName)
    if not Config.KillAura then return end
    
    local mobs = FindAllMobs(mobName)
    
    for _, mob in pairs(mobs) do
        local rootPart = mob:FindFirstChild("HumanoidRootPart")
        local humanoid = mob:FindFirstChild("Humanoid")
        
        if rootPart and humanoid and humanoid.Health > 0 then
            local distance = (HumanoidRootPart.Position - rootPart.Position).Magnitude
            
            if distance <= Config.AttackRange then
                -- Damage the mob
                firetouchinterest(HumanoidRootPart, rootPart, 0)
                task.wait()
                firetouchinterest(HumanoidRootPart, rootPart, 1)
            end
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- QUEST FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

-- Get quest from NPC
local function GetQuest(questData)
    if not questData then return false end
    
    -- Tween to quest NPC
    print("[AutoFarm] Going to quest NPC: " .. questData.QuestNPC)
    TweenTo(questData.QuestNPCPosition)
    task.wait(0.5)
    
    -- Find and interact with NPC
    local npcs = workspace:FindFirstChild("NPCs") or workspace
    for _, npc in pairs(npcs:GetDescendants()) do
        if npc.Name == questData.QuestNPC or npc.Name:find(questData.QuestNPC) then
            local npcRoot = npc:FindFirstChild("HumanoidRootPart")
            if npcRoot then
                HumanoidRootPart.CFrame = npcRoot.CFrame * CFrame.new(0, 0, 3)
                task.wait(0.3)
                
                -- Fire proximity prompt or click
                local prompt = npc:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
                
                task.wait(0.5)
                break
            end
        end
    end
    
    -- Click on quest dialog
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local startQuest = remotes:FindFirstChild("StartQuest")
        if startQuest then
            startQuest:InvokeServer(questData.QuestName)
            print("[AutoFarm] Started quest: " .. questData.QuestName)
            return true
        end
    end
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN AUTOFARM LOOP
-- ═══════════════════════════════════════════════════════════════════════════

local function AutoFarm()
    while Config.AutoFarm do
        task.wait(0.1)
        
        -- Refresh character references
        if not Character or not Character.Parent then
            Character = Player.Character or Player.CharacterAdded:Wait()
            Humanoid = Character:WaitForChild("Humanoid")
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        end
        
        -- Check if dead
        if Humanoid.Health <= 0 then
            task.wait(5)
            continue
        end
        
        -- Get best quest for current level
        local questData = GetBestQuest()
        
        if not questData then
            print("[AutoFarm] No suitable quest found for your level!")
            task.wait(5)
            continue
        end
        
        -- Check if we need to get a quest
        if Config.AutoQuest and not HasActiveQuest() then
            print("[AutoFarm] Getting quest: " .. questData.MobName)
            GetQuest(questData)
            task.wait(1)
            continue
        end
        
        -- Check if quest is complete
        if IsQuestComplete() then
            print("[AutoFarm] Quest complete! Getting new quest...")
            GetQuest(questData)
            task.wait(1)
            continue
        end
        
        -- Find and attack mobs
        local mob = FindNearestMob(questData.MobName)
        
        if mob then
            local rootPart = mob:FindFirstChild("HumanoidRootPart")
            local humanoid = mob:FindFirstChild("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                -- Position above the mob
                local targetPosition = rootPart.CFrame * CFrame.new(0, Config.FarmHeight, 0)
                HumanoidRootPart.CFrame = targetPosition
                
                -- Attack
                FastAttack()
                KillAura(questData.MobName)
                
                -- Keep attacking until mob is dead
                while humanoid and humanoid.Health > 0 and Config.AutoFarm do
                    HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, Config.FarmHeight, 0)
                    FastAttack()
                    task.wait(0.1)
                end
            end
        else
            -- No mob found, tween to mob spawn location
            print("[AutoFarm] No mobs found, going to spawn location...")
            TweenTo(questData.MobPosition * CFrame.new(0, Config.FarmHeight, 0))
            task.wait(1)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ANTI-AFK SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function AntiAFK()
    if not Config.AntiAFK then return end
    
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("[AutoFarm] Anti-AFK triggered")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- GUI (Optional - Simple Toggle)
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateGUI()
    -- Create a simple GUI for toggling the script
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AutoFarmGUI"
    ScreenGui.Parent = Player.PlayerGui
    ScreenGui.ResetOnSpawn = false
    
    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Size = UDim2.new(0, 200, 0, 150)
    Frame.Position = UDim2.new(0, 10, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Title.BorderSizePixel = 0
    Title.Text = "Blox Fruits AutoFarm"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title
    
    -- Auto Farm Toggle
    local AutoFarmToggle = Instance.new("TextButton")
    AutoFarmToggle.Name = "AutoFarmToggle"
    AutoFarmToggle.Size = UDim2.new(0.9, 0, 0, 30)
    AutoFarmToggle.Position = UDim2.new(0.05, 0, 0, 40)
    AutoFarmToggle.BackgroundColor3 = Config.AutoFarm and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    AutoFarmToggle.BorderSizePixel = 0
    AutoFarmToggle.Text = "Auto Farm: " .. (Config.AutoFarm and "ON" or "OFF")
    AutoFarmToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoFarmToggle.TextSize = 12
    AutoFarmToggle.Font = Enum.Font.Gotham
    AutoFarmToggle.Parent = Frame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = AutoFarmToggle
    
    AutoFarmToggle.MouseButton1Click:Connect(function()
        Config.AutoFarm = not Config.AutoFarm
        AutoFarmToggle.Text = "Auto Farm: " .. (Config.AutoFarm and "ON" or "OFF")
        AutoFarmToggle.BackgroundColor3 = Config.AutoFarm and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        
        if Config.AutoFarm then
            spawn(AutoFarm)
        end
    end)
    
    -- Kill Aura Toggle
    local KillAuraToggle = Instance.new("TextButton")
    KillAuraToggle.Name = "KillAuraToggle"
    KillAuraToggle.Size = UDim2.new(0.9, 0, 0, 30)
    KillAuraToggle.Position = UDim2.new(0.05, 0, 0, 75)
    KillAuraToggle.BackgroundColor3 = Config.KillAura and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    KillAuraToggle.BorderSizePixel = 0
    KillAuraToggle.Text = "Kill Aura: " .. (Config.KillAura and "ON" or "OFF")
    KillAuraToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KillAuraToggle.TextSize = 12
    KillAuraToggle.Font = Enum.Font.Gotham
    KillAuraToggle.Parent = Frame
    
    local KillAuraCorner = Instance.new("UICorner")
    KillAuraCorner.CornerRadius = UDim.new(0, 6)
    KillAuraCorner.Parent = KillAuraToggle
    
    KillAuraToggle.MouseButton1Click:Connect(function()
        Config.KillAura = not Config.KillAura
        KillAuraToggle.Text = "Kill Aura: " .. (Config.KillAura and "ON" or "OFF")
        KillAuraToggle.BackgroundColor3 = Config.KillAura and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    end)
    
    -- Level Display
    local LevelDisplay = Instance.new("TextLabel")
    LevelDisplay.Name = "LevelDisplay"
    LevelDisplay.Size = UDim2.new(0.9, 0, 0, 25)
    LevelDisplay.Position = UDim2.new(0.05, 0, 0, 115)
    LevelDisplay.BackgroundTransparency = 1
    LevelDisplay.Text = "Level: " .. GetPlayerLevel()
    LevelDisplay.TextColor3 = Color3.fromRGB(200, 200, 200)
    LevelDisplay.TextSize = 11
    LevelDisplay.Font = Enum.Font.Gotham
    LevelDisplay.Parent = Frame
    
    -- Update level display
    spawn(function()
        while true do
            task.wait(1)
            LevelDisplay.Text = "Level: " .. GetPlayerLevel()
        end
    end)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
        end
    end)
    
    Title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CHARACTER RESPAWN HANDLER
-- ═══════════════════════════════════════════════════════════════════════════

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    task.wait(1)
    
    if Config.AutoFarm then
        print("[AutoFarm] Character respawned, resuming farm...")
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

print("═══════════════════════════════════════════════════════════════")
print("        BLOX FRUITS AUTOFARM SCRIPT LOADED")
print("═══════════════════════════════════════════════════════════════")
print("Current Level: " .. GetPlayerLevel())
print("Current Sea: " .. GetCurrentSea())

local bestQuest = GetBestQuest()
if bestQuest then
    print("Best Quest: " .. bestQuest.MobName .. " (Level " .. bestQuest.Level .. ")")
    print("Island: " .. bestQuest.Island)
else
    print("No suitable quest found for your level in this sea!")
end

print("═══════════════════════════════════════════════════════════════")

-- Start systems
AntiAFK()
CreateGUI()

-- Start auto farm if enabled
if Config.AutoFarm then
    spawn(AutoFarm)
end

print("[AutoFarm] Script initialized successfully!")
