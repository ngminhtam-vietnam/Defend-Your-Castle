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

-- Biến lưu trữ
local Flags = {
    AutoBuySelected = false,
    AutoRollEnchant = false,
    AutoStartChallenge = false,
    AutoRequestEnemies = false
}

-- Bảng lưu trữ danh sách các trụ đã chọn (Mặc định là trống)
local SelectedBlueprints = {}

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

-- Khởi tạo giá trị cho SelectedBlueprints
for _, name in pairs(BlueprintList) do
    SelectedBlueprints[name] = false
end

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Functions = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Functions")
local Remotes = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Remotes")

local BuyDefense = Functions:WaitForChild("BuyDefense")
local RollForEnchant = Functions:WaitForChild("RollForEnchant")
local StartChallenge = Functions:WaitForChild("StartChallenge")
local RequestEnemies = Remotes:WaitForChild("RequestEnemies")

-- Vòng lặp Auto Buy
task.spawn(function()
    while task.wait(0.5) do
        if Flags.AutoBuySelected then
            for itemName, isSelected in pairs(SelectedBlueprints) do
                if isSelected and Flags.AutoBuySelected then
                    pcall(function()
                        BuyDefense:InvokeServer(itemName, 1)
                    end)
                end
            end
        end
    end
end)

-- Vòng lặp khác
task.spawn(function()
    while task.wait(1) do
        if Flags.AutoRollEnchant then pcall(function() RollForEnchant:InvokeServer() end) end
        if Flags.AutoStartChallenge then pcall(function() StartChallenge:InvokeServer() end) end
        if Flags.AutoRequestEnemies then pcall(function() RequestEnemies:FireServer() end) end
    end
end)

-- TẠO UI
local MainTab = Window:CreateTab("Main", 4483362458)
local ShopTab = Window:CreateTab("Blueprint Selector", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Tab Chính
MainTab:CreateSection("Master Switch")
MainTab:CreateToggle({
   Name = "AUTO BUY SELECTED",
   Info = "Chỉ mua những trụ bạn đã tick ở Tab 'Blueprint Selector'",
   CurrentValue = false,
   Flag = "MasterAutoBuy",
   Callback = function(Value)
      Flags.AutoBuySelected = Value
   end,
})

MainTab:CreateSection("Other Automation")
MainTab:CreateToggle({ Name = "Auto Roll Enchant", CurrentValue = false, Callback = function(V) Flags.AutoRollEnchant = V end })
MainTab:CreateToggle({ Name = "Auto Start Challenge", CurrentValue = false, Callback = function(V) Flags.AutoStartChallenge = V end })
MainTab:CreateToggle({ Name = "Auto Request Enemies", CurrentValue = false, Callback = function(V) Flags.AutoRequestEnemies = V end })

-- Tab Chọn Trụ (Blueprint Selector)
ShopTab:CreateSection("Chọn các loại trụ bạn muốn mua")

-- Nút hỗ trợ chọn nhanh
ShopTab:CreateButton({
    Name = "Chọn Tất Cả (Select All)",
    Callback = function()
        for _, name in pairs(BlueprintList) do
            SelectedBlueprints[name] = true
        end
        Rayfield:Notify({Title = "Thông báo", Content = "Đã chọn tất cả trụ!", Duration = 3})
    end,
})

ShopTab:CreateButton({
    Name = "Bỏ Chọn Tất Cả (Clear All)",
    Callback = function()
        for _, name in pairs(BlueprintList) do
            SelectedBlueprints[name] = false
        end
        Rayfield:Notify({Title = "Thông báo", Content = "Đã bỏ chọn tất cả!", Duration = 3})
    end,
})

-- Tạo danh sách Toggle cho từng loại trụ
for _, itemName in pairs(BlueprintList) do
    ShopTab:CreateToggle({
        Name = itemName,
        CurrentValue = false,
        Callback = function(Value)
            SelectedBlueprints[itemName] = Value
        end,
    })
end

-- Tab Misc (Tiện ích)
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
