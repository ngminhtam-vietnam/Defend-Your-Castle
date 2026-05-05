local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Defend Your Castle | Automation",
   LoadingTitle = "Defend Your Castle | Premium",
   LoadingSubtitle = "by ngminhtam-vietnam",
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

local MiscTab = Window:CreateTab("Misc", 4483362458) -- Misc Tab

MiscTab:CreateSection("Utilities")

MiscTab:CreateButton({
   Name = "Enable Anti-AFK",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
         vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
         task.wait(1)
         vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({
         Title = "Anti-AFK Enabled",
         Content = "You will no longer be kicked for idling.",
         Duration = 5,
         Image = 4483362458,
      })
   end,
})

MiscTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SliderWalkSpeed",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

MiscTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "SliderJumpPower",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

MiscTab:CreateSection("Server")

MiscTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local PlaceID = game.PlaceId
      local AllIDs = {}
      local foundAnything = ""
      local ActualID = ""
      local function TPReturner()
         local Site;
         if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
         else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
         end
         local ID = ""
         if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
         end
         local num = 0;
         for i,v in pairs(Site.data) do
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
               for _,Existing in pairs(AllIDs) do
                  if num ~= 0 then
                     if ID == tostring(Existing) then
                        continue
                     end
                  else
                     num = 1
                  end
               end
               table.insert(AllIDs, ID)
               task.wait()
               game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
            end
         end
      end
      TPReturner()
   end,
})

MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
   end,
})

Rayfield:LoadConfiguration()
