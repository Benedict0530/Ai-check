local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local QuestModule = require(ReplicatedStorage:WaitForChild("QuestModule"))
local BottleSpawner = require(ReplicatedStorage:WaitForChild("BottleSpawner"))

-- Automatically require modules and store RemoteEvents/RemoteFunctions
local ReplicatedStorageItems = QuestModule.autoRequireReplicatedStorage()

-- Now you can access your items like this:
local EquationGenerator = ReplicatedStorageItems["EquationGenerator"]
local Objective = ReplicatedStorageItems["Objective"]
local focusOnHouse1Event = ReplicatedStorageItems["FocusOnHouse1"]
local focusOnHouse2Event = ReplicatedStorageItems["FocusOnHouse2"]
local focusOnHouse3Event = ReplicatedStorageItems["FocusOnHouse3"]
local focusOnStation = ReplicatedStorageItems["FocusOnStation"]
local questAccepted = ReplicatedStorageItems["QuestAcceptedEvent"]

-- Example usage of the required modules and events
-- MilkStation Setup
local station = game:GetService("Workspace"):WaitForChild("MilkStation")
station.PrimaryPart = station:WaitForChild("PrimaryPart")

-- Define NPCs
local NPCs = {
	{name = "NPC1", initialPrompt = "", number1 = 0, number2 = 0},
	{name = "NPC2", initialPrompt = "", number1 = 0, number2 = 0},
	{name = "NPC3", initialPrompt = "", number1 = 0, number2 = 0}
}

-- Generate prompts for each NPC
QuestModule.generatePrompts(NPCs, EquationGenerator)

-- Initialize the dialogs and icons
QuestModule.initializeDialogs(NPCs)

print("Server script running: RemoteEvents connected")

-- Handle quest acceptance from client
questAccepted.OnServerEvent:Connect(function(player, npcName)
	local npc = nil
	for _, n in ipairs(NPCs) do
		if n.name == npcName then
			npc = n
			break
		end
	end
	if npc then
		QuestModule.acceptQuest(player, npc, focusOnStation, Objective)
		-- Forward the values to the BottleSpawner
		BottleSpawner.SetNumbersValue(npc.number1, npc.number2)
	else
		warn("NPC not found for quest acceptance: " .. npcName)
	end
end)

-- Event handling when the game is fully loaded
local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function()
		-- Perform this when the game is fully loaded
		focusOnHouse1Event:FireAllClients()
		--wait(5)
		--focusOnHouse2Event:FireAllClients()
		--wait(5)
		--focusOnHouse3Event:FireAllClients()
		print("Game fully loaded: RemoteEvents connected")
	end)
end

-- Connect the PlayerAdded event
Players.PlayerAdded:Connect(onPlayerAdded)
