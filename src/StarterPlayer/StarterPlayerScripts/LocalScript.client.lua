-- Player Local Script

local CameraFocusModule = require(game.ReplicatedStorage.CameraFocusModule)
local BottleSpawner = require(game.ReplicatedStorage.BottleSpawner)
local ContainerSpawner = require(game.ReplicatedStorage.ContainerSpawner)
local DragManager = require(game.ReplicatedStorage.DragManager)
local ClickDetectorManager = require(game.ReplicatedStorage.ClickDetectorManager)
local NozzleSpawner = require(game.ReplicatedStorage.NozzleSpawner)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local camera = workspace.CurrentCamera
local house1 = workspace:WaitForChild("House1"):WaitForChild("House")
local house2 = workspace:WaitForChild("House2"):WaitForChild("House")
local house3 = workspace:WaitForChild("House3"):WaitForChild("House")
local station = workspace:WaitForChild("MilkStation")

local primaryPartName = "PrimaryPart"

local focusOnHouse1Event = ReplicatedStorage:WaitForChild("FocusOnHouse1")
local focusOnHouse2Event = ReplicatedStorage:WaitForChild("FocusOnHouse2")
local focusOnHouse3Event = ReplicatedStorage:WaitForChild("FocusOnHouse3")
local focusOnStation = ReplicatedStorage:WaitForChild("FocusOnStation")
local questAcceptedEvent = ReplicatedStorage:WaitForChild("QuestAcceptedEvent")
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = playerGui:WaitForChild("ScreenGui")
local button = screenGui:WaitForChild("SpawnBottleButton")

-- Function to show the button
local function showButton()
	button.Visible = true
	print("Button shown")
end

-- Function to hide the button
local function hideButton()
	button.Visible = false
	print("Button hidden")
end

-- Function to get offset from attribute
local function getOffsetFromAttribute(attributeName)
	local attributeValue = script:GetAttribute(attributeName)
	if attributeValue then
		return attributeValue
	else
		warn(attributeName .. " not found on script")
		return Vector3.new(0, 0, 0) -- Default fallback value if the attribute is not found
	end
end

-- Event listeners with attribute-based offsets
focusOnHouse1Event.OnClientEvent:Connect(function()
	if house1 then
		print("Focusing camera on House1")
		local house1Offset = getOffsetFromAttribute("NPCCameraDefault")
		CameraFocusModule.FocusCameraOnModel(camera, house1, primaryPartName, house1Offset, 1)
	else
		warn("House1 not found")
	end
end)

focusOnHouse2Event.OnClientEvent:Connect(function()
	if house2 then
		print("Focusing camera on House2")
		local house2Offset = getOffsetFromAttribute("NPCCameraDefault")
		CameraFocusModule.FocusCameraOnModel(camera, house2, primaryPartName, house2Offset, 1)
	else
		warn("House2 not found")
	end
end)

focusOnHouse3Event.OnClientEvent:Connect(function()
	if house3 then
		print("Focusing camera on House3")
		local house3Offset = getOffsetFromAttribute("NPCCameraDefault")
		CameraFocusModule.FocusCameraOnModel(camera, house3, primaryPartName, house3Offset, 1)
	else
		warn("House3 not found")
	end
end)

focusOnStation.OnClientEvent:Connect(function()
	if station then
		print("Focusing camera on Station")
		local stationOffset = getOffsetFromAttribute("StationCameraDefault")
		CameraFocusModule.FocusCameraOnModel(camera, station, primaryPartName, stationOffset, 1)
	else
		warn("Station not found")
	end
end)

questAcceptedEvent.OnClientEvent:Connect(function()
	print("Quest accepted event received, showing button")
	showButton()
	ContainerSpawner.SpawnContainerAt(workspace.MilkStation.SContainer)

	-- Spawn the nozzle at the first part
	local newNozzle = NozzleSpawner.SpawnNozzle(DragManager, ClickDetectorManager)

end)

-- Handle button click event
button.MouseButton1Click:Connect(function()
	print("Button clicked")
	BottleSpawner.SpawnBottle(DragManager, ClickDetectorManager)
end)

-- Client-side script to handle Dialog selection
local function onDialogChoiceSelected(player, dialogChoice)
	local npcModel = dialogChoice.Parent.Parent
	while npcModel and not npcModel.Name:match("NPC%d") do
		npcModel = npcModel.Parent
	end

	if npcModel then
		print(player.Name .. " selected quest from " .. npcModel.Name)
		questAcceptedEvent:FireServer(npcModel.Name)
	else
		warn("NPC model not found for dialog choice selection")
	end
end

-- Function to wait for NPC models and set up dialog choice connections
local function waitForNPCs()
	for _, npc in ipairs(workspace:GetChildren()) do
		if npc.Name:match("NPC%d") then
			local head = npc:WaitForChild("Head")
			if head then
				local dialog = head:WaitForChild("Dialog")
				if dialog then
					dialog.DialogChoiceSelected:Connect(function(player, dialogChoice)
						onDialogChoiceSelected(player, dialogChoice)
					end)
					print("Dialog choice connected for " .. npc.Name)
				else
					warn("No dialog found for " .. npc.Name)
				end
			else
				warn("No head found for " .. npc.Name)
			end
		end
	end
end

-- Call function to wait for NPC models
waitForNPCs()

-- Initially hide the button
hideButton()
print("Script initialized")
