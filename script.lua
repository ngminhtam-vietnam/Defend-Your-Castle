-- [ignoring loop detection]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Defend Your Castle | Premium",
   LoadingTitle = "Defend Your Castle | Premium",
   LoadingSubtitle = "by ngminhtam-vietnam",
   ConfigurationSaving = { Enabled = true, FolderName = "DefendYourCastle", FileName = "Config" },
   Discord = { Enabled = false, Invite = "noinvite", RememberJoins = true },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)
local Flags = {
    AutoBuyAllBlueprints = false,
    AutoRollEnchant = false,
    AutoStartChallenge = false,
    AutoRequestEnemies = false
}

-- Danh sách toàn bộ Blueprints từ dữ liệu bạn gửi
local BlueprintList = {
    "Cannon", "Mortar", "Tesla", "Wizard Tower", "Archer Tower", "Inferno Beam", 
    "Crossbow", "Mega Tesla", "Flamethrower", "Mega Mortar", "Magma Cannon", 
    "Double Cannon", "Mega Crossbow", "Catapult", "Mystic Artillery", 
    "Double Magma Cannon", "Volcanic Artillery", "Snowball Launcher", 
    "The Crusher", "The Shocker", "Double Catapult", "Bomb Tower", 
    "Rocket Artillery", "Cosmic Beam", "Flamespitter", "Triple Mortar", 
    "Toxic Exterminator", "Toxic Artillery", "Railgun", "Mega Cannon", 
    "Demonic Flamethrower", "Quad Rocket Launcher", "Hidden Tesla", 
    "Minigun", "The Forcefielder", "Trident Tower", "Octogun"
}

-- Services & Remotes
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
    while task.wait(0.5) do -- Tốc độ thử mua (0.5 giây/lần)
        if Flags.AutoBuyAllBlueprints then
            for _, itemName in pairs(BlueprintList) do
                if not Flags.AutoBuyAllBlueprints then break end
                pcall(function()
                    -- Gọi lệnh mua món đồ với số lượng 1
                    BuyDefense:InvokeServer(itemName, 1)
                end)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Flags.AutoRollEnchant then pcall(function() RollForEnchant:InvokeServer() end) end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Flags.AutoStartChallenge then pcall(function() StartChallenge:InvokeServer() end) end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if Flags.AutoRequestEnemies then pcall(function() RequestEnemies:FireServer() end) end
    end
end)

-- UI Elements
MainTab:CreateSection("Auto Blueprints")

MainTab:CreateToggle({
   Name = "Auto Buy ALL Blueprints",
   Info = "Tự động mua sạch mọi thứ trong shop khi có hàng (Restock)",
   CurrentValue = false,
   Flag = "ToggleBuyAll",
   Callback = function(Value)
      Flags.AutoBuyAllBlueprints = Value
   end,
})

MainTab:CreateSection("Other Automation")
MainTab:CreateToggle({ Name = "Auto Roll Enchant", CurrentValue = false, Callback = function(V) Flags.AutoRollEnchant = V end })
MainTab:CreateToggle({ Name = "Auto Start Challenge", CurrentValue = false, Callback = function(V) Flags.AutoStartChallenge = V end })
MainTab:CreateToggle({ Name = "Auto Request Enemies", CurrentValue = false, Callback = function(V) Flags.AutoRequestEnemies = V end })

-- Misc Tab (Giữ nguyên các tính năng trước)
local MiscTab = Window:CreateTab("Misc", 4483362458)
MiscTab:CreateSection("Utilities")
MiscTab:CreateButton({ Name = "Enable Anti-AFK", Callback = function() 
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
    Rayfield:Notify({ Title = "Anti-AFK Enabled", Content = "Đã kích hoạt chống treo máy.", Duration = 5 })
end })

MiscTab:CreateSlider({ Name = "WalkSpeed", Range = {16, 250}, Increment = 1, CurrentValue = 16, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = V end })
MiscTab:CreateSlider({ Name = "JumpPower", Range = {50, 500}, Increment = 1, CurrentValue = 50, Callback = function(V) game.Players.LocalPlayer.Character.Humanoid.JumpPower = V end })

Rayfield:LoadConfiguration()
