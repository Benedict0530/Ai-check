local module = {}

function module.ShowObjective(player, objectiveText)
	local playerGui = player:WaitForChild("PlayerGui")

	local screenGui = playerGui:FindFirstChild("ObjectiveGUI")
	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ObjectiveGUI"
		screenGui.Parent = playerGui

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
		textLabel.Position = UDim2.new(0.25, 0, -0.10, 0) -- Moved higher
		textLabel.Text = objectiveText
		textLabel.Parent = screenGui

		print("Objective GUI created!")
	else
		local textLabel = screenGui:FindFirstChild("TextLabel")
		if textLabel then
			textLabel.Text = objectiveText
		else
			local newTextLabel = Instance.new("TextLabel")
			newTextLabel.Size = UDim2.new(0.5, 0, 0.1, 0)
			newTextLabel.Position = UDim2.new(0.25, 0, 0.05, 0) -- Moved higher
			newTextLabel.Text = objectiveText
			newTextLabel.Parent = screenGui
		end

		print("Objective GUI updated!")
	end
end

return module
