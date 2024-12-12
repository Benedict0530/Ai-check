local DragManager = {}
local Players = game:GetService("Players")

-- Require NozzleSpawner
local NozzleSpawner = require(game:GetService("ReplicatedStorage"):WaitForChild("NozzleSpawner"))

-- Helper function to move the model
local function moveModel(model, newPosition)
	local currentCFrame = model.PrimaryPart.CFrame
	local newCFrame = CFrame.new(newPosition) * CFrame.Angles(currentCFrame:ToEulerAnglesXYZ())
	local offset = newCFrame.Position - currentCFrame.Position

	-- Apply offset to all parts of the model
	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CFrame = part.CFrame + offset
		end
	end
end

-- Function to handle making a model draggable
function DragManager.MakeDraggable(model, spawnParts, occupiedParts)
	local player = Players.LocalPlayer
	local mouse = player:GetMouse()

	local down = false
	local originalCFrame = model.PrimaryPart.CFrame

	-- Mouse down event to start dragging
	mouse.Button1Down:Connect(function()
		if mouse.Target and mouse.Target:IsDescendantOf(model) then
			mouse.TargetFilter = model
			down = true
			originalCFrame = model.PrimaryPart.CFrame
		end
	end)

	-- Mouse move event to update model position
	mouse.Move:Connect(function()
		if down then
			local closestPart = nil
			local minDistance = math.huge

			-- Find closest spawn part to the mouse position
			for _, part in ipairs(spawnParts) do
				local distance = (mouse.Hit.Position - part.Position).Magnitude
				if distance < minDistance then
					minDistance = distance
					closestPart = part
				end
			end

			-- If a valid part is found, move the model to the new position
			if closestPart then
				local newPosition = Vector3.new(closestPart.Position.X, originalCFrame.Position.Y, closestPart.Position.Z)
				moveModel(model, newPosition)
			end
		end
	end)

	-- Mouse up event to drop the model
	mouse.Button1Up:Connect(function()
		if down then
			down = false
			mouse.TargetFilter = nil

			-- Find the initial part where the model was
			local initialPart = nil
			for part, bottle in pairs(occupiedParts) do
				if bottle == model then
					initialPart = part
					break
				end
			end

			local nearestPart = nil
			local minDistance = math.huge

			-- Find the nearest spawn part
			for _, part in ipairs(spawnParts) do
				local distance = (model.PrimaryPart.Position - part.Position).Magnitude
				if distance < minDistance then
					minDistance = distance
					nearestPart = part
				end
			end

			-- If a nearest part is found, place the model there
			if nearestPart then
				-- Swap bottles if the part is occupied
				if occupiedParts[nearestPart] then
					local otherBottle = occupiedParts[nearestPart]
					occupiedParts[nearestPart] = model

					if initialPart then
						occupiedParts[initialPart] = otherBottle
						otherBottle:SetPrimaryPartCFrame(CFrame.new(initialPart.Position) * CFrame.Angles(originalCFrame:ToEulerAnglesXYZ()))
					end
				else
					occupiedParts[nearestPart] = model
					if initialPart then
						occupiedParts[initialPart] = nil
					end
				end

				-- Set the final position of the model
				model:SetPrimaryPartCFrame(CFrame.new(nearestPart.Position) * CFrame.Angles(originalCFrame:ToEulerAnglesXYZ()))

				-- Update nozzle position in NozzleSpawner
				NozzleSpawner.UpdateNozzlePosition(model, nearestPart)
			elseif initialPart then
				model:SetPrimaryPartCFrame(CFrame.new(initialPart.Position) * CFrame.Angles(originalCFrame:ToEulerAnglesXYZ()))
			end
		end
	end)
end

return DragManager
