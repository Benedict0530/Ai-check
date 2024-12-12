local BottleSpawner = {}
local nextBottleId = 1 -- Initialize bottle ID counter

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- BottleModel and MilkStation parts
local bottleModel = ReplicatedStorage:WaitForChild("BottleModel")
local milkStationSpawnArea = Workspace:WaitForChild("MilkStation"):WaitForChild("SpawnArea")

-- Define the spawn parts
local spawnParts = {
	milkStationSpawnArea:WaitForChild("Pos1"):WaitForChild("s1"),
	milkStationSpawnArea:WaitForChild("Pos2"):WaitForChild("s2"),
	milkStationSpawnArea:WaitForChild("Pos3"):WaitForChild("s3"),
	milkStationSpawnArea:WaitForChild("Pos4"):WaitForChild("s4"),
	milkStationSpawnArea:WaitForChild("Pos5"):WaitForChild("s5"),
	milkStationSpawnArea:WaitForChild("Pos6"):WaitForChild("s6"),
	milkStationSpawnArea:WaitForChild("Pos7"):WaitForChild("s7"),
	milkStationSpawnArea:WaitForChild("Pos8"):WaitForChild("s8"),
	milkStationSpawnArea:WaitForChild("Pos9"):WaitForChild("s9"),
	milkStationSpawnArea:WaitForChild("Pos10"):WaitForChild("s10")
}

-- Track occupied parts
local occupiedParts = {}

-- Variables to store the NPC values
local number1, number2

-- Function to set bottle values
function BottleSpawner.SetNumbersValue(n1, n2)
	number1 = n1
	number2 = n2
	print("Number Objectives values set to: " .. number1 .. " / " .. number2)
end

-- Function to update the bottle's spawn part attribute
local function UpdateBottleSpawnPart(bottle, part)
	if bottle:IsA("Model") and bottle.PrimaryPart then
		bottle:SetAttribute("CurrentSpawnPart", part.Name)
		print(bottle.Name .. " is now in: " .. part.Name)
	end
end

-- Function to spawn a bottle at a random part
function BottleSpawner.SpawnBottle(DragManager, ClickDetectorManager)
	-- Check if we have already spawned 5 bottles
	if #occupiedParts >= #spawnParts then
		warn("All slots are occupied!")
		return
	end

	-- Define the spawn order
	local orderedParts = {
		milkStationSpawnArea:WaitForChild("Pos3"):WaitForChild("s3"),
		milkStationSpawnArea:WaitForChild("Pos4"):WaitForChild("s4"),
		milkStationSpawnArea:WaitForChild("Pos2"):WaitForChild("s2"),
		milkStationSpawnArea:WaitForChild("Pos5"):WaitForChild("s5"),
		milkStationSpawnArea:WaitForChild("Pos1"):WaitForChild("s1"),
		milkStationSpawnArea:WaitForChild("Pos6"):WaitForChild("s6"),
		milkStationSpawnArea:WaitForChild("Pos7"):WaitForChild("s7"),
		milkStationSpawnArea:WaitForChild("Pos8"):WaitForChild("s8"),
		milkStationSpawnArea:WaitForChild("Pos9"):WaitForChild("s9"),
		milkStationSpawnArea:WaitForChild("Pos10"):WaitForChild("s10")
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
		-- Clone the bottle model
		local newBottle = bottleModel:Clone()
		newBottle.Parent = Workspace

		-- Assign a unique ID to the bottle and increment the counter
		local bottleID = "Bottle" .. nextBottleId
		newBottle.Name = bottleID
		nextBottleId = nextBottleId + 1

		-- Add a vertical offset (higher position) and rotate horizontally
		local verticalOffset = 0 -- Adjust this value to change the height
		local rotatedCFrame = spawnPart.CFrame * CFrame.Angles(0, 0, math.rad(270))
		local finalCFrame = rotatedCFrame + Vector3.new(0, verticalOffset, 0)

		-- Apply the final CFrame to the bottle
		newBottle:SetPrimaryPartCFrame(finalCFrame)

		-- Mark this spawn part as occupied
		occupiedParts[spawnPart] = newBottle

		-- Ensure the bottle has a PrimaryPart
		newBottle.PrimaryPart = newBottle:FindFirstChild("PrimaryPart")
		if not newBottle.PrimaryPart then
			warn("Bottle model missing PrimaryPart")
			return
		end

		-- Add a ClickDetector to the primary part of the new bottle
		ClickDetectorManager.AddClickDetectorToPrimaryPart(newBottle)
		print("ClickDetector added to the primary part of the bottle")

		-- Make the bottle draggable
		DragManager.MakeDraggable(newBottle, spawnParts, occupiedParts)

		-- Update bottle spawn part
		UpdateBottleSpawnPart(newBottle, spawnPart)
	else
		warn("Capacity Full")
	end
end

-- Function to update the bottle's position when moved
function BottleSpawner.UpdateBottlePosition(bottle, newPart)
	if bottle:IsA("Model") and bottle.PrimaryPart then
		UpdateBottleSpawnPart(bottle, newPart)
	end
end

return BottleSpawner
