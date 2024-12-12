local ClickDetectorManager = {}

-- Function to add a ClickDetector to the model's primary part
function ClickDetectorManager.AddClickDetectorToPrimaryPart(model)
	local primaryPart = model.PrimaryPart
	if primaryPart then
		local clickDetector = Instance.new("ClickDetector")
		clickDetector.MaxActivationDistance = 1000 -- Increase this value if necessary
		clickDetector.Parent = primaryPart
		clickDetector.MouseClick:Connect(function(player)
			print("Bottle clicked: " .. model.Name)
		end)
	else
		warn("Model is missing PrimaryPart")
	end
end

return ClickDetectorManager
