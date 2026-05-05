local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Defend Your Castle | Automation",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Antigravity",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DefendYourCastle",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvite",
      RememberJoins = true
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458) -- Main Tab

-- Variables for toggles
local Flags = {
    AutoBuyDefense = false,
    AutoRollEnchant = false,
    AutoStartChallenge = false,
    AutoRequestEnemies = false
}

-- Services and Remotes
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local Functions = Events:WaitForChild("Functions")
local Remotes = Events:WaitForChild("Remotes")

local BuyDefense = Functions:WaitForChild("BuyDefense")
local RollForEnchant = Functions:WaitForChild("RollForEnchant")
local StartChallenge = Functions:WaitForChild("StartChallenge")
local RequestEnemies = Remotes:WaitForChild("RequestEnemies")

-- Automation Loops
task.spawn(function()
    while task.wait(1) do
        if Flags.AutoBuyDefense then
            pcall(function()
                BuyDefense:InvokeServer()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Flags.AutoRollEnchant then
            pcall(function()
                RollForEnchant:InvokeServer()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Flags.AutoStartChallenge then
            pcall(function()
                StartChallenge:InvokeServer()
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Flags.AutoRequestEnemies then
            pcall(function()
                RequestEnemies:FireServer()
            end)
        end
    end
end)

-- UI Elements
MainTab:CreateSection("Auto Features")

MainTab:CreateToggle({
   Name = "Auto Buy Defense",
   CurrentValue = false,
   Flag = "ToggleBuyDefense",
   Callback = function(Value)
      Flags.AutoBuyDefense = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Roll Enchant",
   CurrentValue = false,
   Flag = "ToggleRollEnchant",
   Callback = function(Value)
      Flags.AutoRollEnchant = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Start Challenge",
   CurrentValue = false,
   Flag = "ToggleStartChallenge",
   Callback = function(Value)
      Flags.AutoStartChallenge = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto Request Enemies",
   CurrentValue = false,
   Flag = "ToggleRequestEnemies",
   Callback = function(Value)
      Flags.AutoRequestEnemies = Value
   end,
})

Rayfield:LoadConfiguration()
