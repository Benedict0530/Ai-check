-- QuestModule
local QuestModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

function QuestModule.autoRequireReplicatedStorage()
	local requiredModules = {}
	for _, item in ipairs(ReplicatedStorage:GetChildren()) do
		if item:IsA("ModuleScript") then
			requiredModules[item.Name] = require(item)
			print(item.Name .. " module required and stored.")
		elseif item:IsA("RemoteEvent") then
			requiredModules[item.Name] = item
			print(item.Name .. " RemoteEvent stored.")
		elseif item:IsA("RemoteFunction") then
			requiredModules[item.Name] = item
			print(item.Name .. " RemoteFunction stored.")
		else
			print(item.Name .. " is not a ModuleScript, RemoteEvent, or RemoteFunction and was skipped.")
		end
	end
	return requiredModules
end

function QuestModule.generatePrompts(NPCs, EquationGenerator)
	for _, npc in ipairs(NPCs) do
		local number1, number2 = EquationGenerator:GenerateValues()
		npc.number1 = number1
		npc.number2 = number2
		npc.initialPrompt = "I need a total of " .. number1 .. "L of Milk that will be rationed by " .. number2 .. " people."
	end
end

function QuestModule.acceptQuest(player, npc, focusOnStation, Objective)
	print(player.Name .. " has accepted the quest: " .. npc.initialPrompt)
	focusOnStation:FireClient(player)
	ReplicatedStorage:FindFirstChild("QuestAcceptedEvent"):FireClient(player)
	local objectiveText = "Objective: Distribute the " .. npc.number1 .. "L of milk equally into " .. npc.number2 .. " bottles"
	Objective.ShowObjective(player, objectiveText)

end


function QuestModule.initializeDialogs(NPCs)
	for _, npc in ipairs(NPCs) do
		local npcModel = game:GetService("Workspace"):FindFirstChild(npc.name)
		if npcModel then
			print(npc.name .. " found in the workspace")
			local head = npcModel:FindFirstChild("Head")
			if head then
				local dialog = head:FindFirstChildOfClass("Dialog") or Instance.new("Dialog", head)
				dialog.InitialPrompt = npc.initialPrompt
				dialog.Purpose = Enum.DialogPurpose.Quest
				dialog.Tone = Enum.DialogTone.Friendly
				dialog.ConversationDistance = 999999
				print("InitialPrompt for " .. npc.name .. ": " .. dialog.InitialPrompt)
				local dialogChoice = dialog:FindFirstChildOfClass("DialogChoice") or Instance.new("DialogChoice", dialog)
				dialogChoice.UserDialog = "Accept Quest"
				dialogChoice.ResponseDialog = "Thank you for accepting the quest!"
				local billboardGui = Instance.new("BillboardGui", head)
				billboardGui.Name = "InteractionIcon"
				billboardGui.Size = UDim2.new(0, 50, 0, 50)
				billboardGui.StudsOffset = Vector3.new(0, 5, 0)
				billboardGui.AlwaysOnTop = true
				local imageLabel = Instance.new("ImageLabel", billboardGui)
				imageLabel.Size = UDim2.new(1, 0, 1, 0)
				imageLabel.BackgroundTransparency = 1
				print("Icon added to " .. npc.name)
			else
				warn("Head not found for " .. npc.name)
			end
		else
			warn(npc.name .. " not found in the workspace")
		end
	end
end

return QuestModule
