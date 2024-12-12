local ContainerSpawner = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContainerModel = ReplicatedStorage:WaitForChild("ContainerModel")

-- Function to spawn container at a given location with offset and rotation
function ContainerSpawner.SpawnContainerAt(location)
	local newContainer = ContainerModel:Clone()

	-- Add a vertical offset (higher position) and rotate horizontally
	local verticalOffset = 3 -- Adjust this value to change the height
	local rotatedCFrame = location.CFrame * CFrame.Angles(0, 0, math.rad(270)) -- Rotate 90 degrees around the Z-axis
	local finalCFrame = rotatedCFrame + Vector3.new(0, verticalOffset, 0) -- Move the container higher on the Y-axis

	newContainer:SetPrimaryPartCFrame(finalCFrame)
	newContainer.Parent = workspace
	print("Container spawned at:", location.Name)
end

return ContainerSpawner
