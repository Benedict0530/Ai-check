local MilkStation = {}
local workspace = game:GetService("Workspace")

function MilkStation.setupStation(station, bottleModel, numberOfBottles)
	local stationPart = station.PrimaryPart or station:FindFirstChildWhichIsA("BasePart")
	if not stationPart then
		warn("No valid part found in the MilkStation model for positioning bottles.")
		return
	end

	for i = 1, numberOfBottles do
		local bottleClone = bottleModel:Clone()
		bottleClone.Parent = station
		-- Adjust the position to place the bottles in front of the PrimaryPart and lower them
		-- You can change the values for vertical and horizontal adjustment here
		local newPos = stationPart.Position + stationPart.CFrame.LookVector * -3 + Vector3.new(0, i * 2, 2) 
		-- ^^^ The second parameter of Vector3.new is for vertical adjustment (y-axis)
		-- ^^^ The third parameter of Vector3.new is for horizontal adjustment (z-axis)

		bottleClone:SetPrimaryPartCFrame(CFrame.new(newPos) * CFrame.Angles(0, math.rad(90), 0)) -- Rotate 90 degrees
		print("Bottle " .. i .. " positioned at:", newPos)
	end
	print(numberOfBottles .. " bottles have been placed on the station.")
end

return MilkStation
