local NozzleSpawner = {}
local nextNozzleId = 1 -- Initialize nozzle ID counter

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Required Modules
local ClickDetectorManager = require(ReplicatedStorage:WaitForChild("ClickDetectorManager"))

-- NozzleModel and NozzleGuide parts
local nozzleModel = ReplicatedStorage:WaitForChild("NozzleModel")
local nozzleGuide = Workspace:WaitForChild("MilkStation"):WaitForChild("SpawnArea")

-- Define the spawn parts
local spawnParts = {
	nozzleGuide:WaitForChild("Pos1"):WaitForChild("ns1"),
	nozzleGuide:WaitForChild("Pos2"):WaitForChild("ns2"),
	nozzleGuide:WaitForChild("Pos3"):WaitForChild("ns3"),
	nozzleGuide:WaitForChild("Pos4"):WaitForChild("ns4"),
	nozzleGuide:WaitForChild("Pos5"):WaitForChild("ns5"),
	nozzleGuide:WaitForChild("Pos6"):WaitForChild("ns6"),
	nozzleGuide:WaitForChild("Pos7"):WaitForChild("ns7"),
	nozzleGuide:WaitForChild("Pos8"):WaitForChild("ns8"),
	nozzleGuide:WaitForChild("Pos9"):WaitForChild("ns9"),
	nozzleGuide:WaitForChild("Pos10"):WaitForChild("ns10"),
}

-- Track occupied parts
local occupiedParts = {}

-- Track the single spawned nozzle
local spawnedNozzle = nil

-- Function to update the nozzle's spawn part attribute
local function UpdateNozzleSpawnPart(nozzle, part)
	if nozzle:IsA("Model") and nozzle.PrimaryPart then
		nozzle:SetAttribute("CurrentSpawnPart", part.Name)
		print(nozzle.Name .. " is now in: " .. part.Name)
	end
end

-- Function to spawn a nozzle at a specific part
function NozzleSpawner.SpawnNozzle(DragManager, ClickDetectorManager)
	-- Check if we have already spawned a nozzle
	if spawnedNozzle then
		warn("Nozzle already spawned")
		return spawnedNozzle
	end

	-- Define the spawn order
	local orderedParts = {
		nozzleGuide:WaitForChild("Pos1"):WaitForChild("ns1"),
		nozzleGuide:WaitForChild("Pos2"):WaitForChild("ns2"),
		nozzleGuide:WaitForChild("Pos3"):WaitForChild("ns3"),
		nozzleGuide:WaitForChild("Pos4"):WaitForChild("ns4"),
		nozzleGuide:WaitForChild("Pos5"):WaitForChild("ns5"),
		nozzleGuide:WaitForChild("Pos6"):WaitForChild("ns6"),
		nozzleGuide:WaitForChild("Pos7"):WaitForChild("ns7"),
		nozzleGuide:WaitForChild("Pos8"):WaitForChild("ns8"),
		nozzleGuide:WaitForChild("Pos9"):WaitForChild("ns9"),
		nozzleGuide:WaitForChild("Pos10"):WaitForChild("ns10"),
	}

	-- Find the first unoccupied part based on the order
	local spawnPart = nil
	for _, part in ipairs(orderedParts) do
		if not occupiedParts[part] then
			spawnPart = part
			break
		end
	end

	-- If a valid spawn part is found
	if spawnPart then
		-- Clone the nozzle model
		local newNozzle = nozzleModel:Clone()
		newNozzle.Parent = Workspace

		-- Assign a unique ID to the nozzle and increment the counter
		local nozzleID = "Nozzle" .. nextNozzleId
		newNozzle.Name = nozzleID
		nextNozzleId = nextNozzleId + 1

		-- Add a vertical offset (higher position) and rotate horizontally
		local verticalOffset = 0 -- Adjust this value to change the height
		local rotatedCFrame = spawnPart.CFrame * CFrame.Angles(0, 0, math.rad(0))
		local finalCFrame = rotatedCFrame + Vector3.new(0, verticalOffset, 0)

		-- Apply the final CFrame to the nozzle
		newNozzle:SetPrimaryPartCFrame(finalCFrame)

		-- Mark this spawn part as occupied
		occupiedParts[spawnPart] = newNozzle

		-- Ensure the nozzle has a PrimaryPart
		newNozzle.PrimaryPart = newNozzle:FindFirstChild("PrimaryPart")
		if not newNozzle.PrimaryPart then
			warn("Nozzle model missing PrimaryPart")
			return
		end

		-- Add a ClickDetector to the primary part of the new nozzle
		ClickDetectorManager.AddClickDetectorToPrimaryPart(newNozzle)
		print("ClickDetector added to the primary part of the nozzle")

		-- Make the nozzle draggable
		DragManager.MakeDraggable(newNozzle, spawnParts, occupiedParts)

		-- Update nozzle spawn part
		UpdateNozzleSpawnPart(newNozzle, spawnPart)

		-- Track the spawned nozzle
		spawnedNozzle = newNozzle
	else
		warn("Capacity Full")
	end

	return spawnedNozzle
end

-- Function to update the nozzle's position when moved
function NozzleSpawner.UpdateNozzlePosition(nozzle, newPart)
	if nozzle:IsA("Model") and nozzle.PrimaryPart then
		UpdateNozzleSpawnPart(nozzle, newPart)
	end
end

return NozzleSpawner
