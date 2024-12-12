local CameraFocusModule = {}
local TweenService = game:GetService("TweenService")

function CameraFocusModule.FocusCameraOnModel(camera, model, primaryPartName, offset, tweenDuration)
	camera.CameraType = Enum.CameraType.Scriptable

	local modelPrimaryPart = model:WaitForChild(primaryPartName)
	if not modelPrimaryPart then
		warn("Model does not have the specified primary part: " .. tostring(primaryPartName))
		return
	end

	local targetPosition = modelPrimaryPart.Position + (offset )
	local targetCFrame = CFrame.new(targetPosition, modelPrimaryPart.Position)

	local tweenInfo = TweenInfo.new(
		tweenDuration or 1, -- Duration in seconds
		Enum.EasingStyle.Quad, -- Easing style
		Enum.EasingDirection.Out -- Easing direction
	)

	local tween = TweenService:Create(camera, tweenInfo, {CFrame = targetCFrame})
	tween:Play()

	-- Keep the camera type as Scriptable
	tween.Completed:Connect(function()
		camera.CameraType = Enum.CameraType.Scriptable
	end)
end

return CameraFocusModule
