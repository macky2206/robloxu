local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MenuDesign = require(script.Parent:WaitForChild("menu"))
local ui = MenuDesign.build(playerGui)
local theme = ui.theme

local function makeDraggable(handle, target)
	handle.Active = true

	local dragging = false
	local dragInput
	local startPos
	local startTargetPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = input.Position
			startTargetPos = target.Position
			dragInput = input

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - startPos
			target.Position = UDim2.new(
				startTargetPos.X.Scale,
				startTargetPos.X.Offset + delta.X,
				startTargetPos.Y.Scale,
				startTargetPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function showMenu()
	ui.menu.Visible = true
	ui.openButton.Visible = false
end

local function hideMenu()
	ui.menu.Visible = false
	ui.openButton.Visible = true
end

local function refreshToggle(toggleData)
	TweenService:Create(toggleData.button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = toggleData.enabled and theme.accent or theme.switchOff,
	}):Play()

	TweenService:Create(toggleData.knob, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = toggleData.enabled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 20, 0.5, 0),
	}):Play()

	local glow = toggleData.button:FindFirstChildOfClass("UIStroke")
	if toggleData.enabled then
		if not glow then
			glow = Instance.new("UIStroke")
			glow.Color = theme.accent
			glow.Thickness = 1
			glow.Parent = toggleData.button
		end
		glow.Transparency = 0.4
	elseif glow then
		glow:Destroy()
	end
end

for _, toggleData in ipairs(ui.toggles) do
	toggleData.button.Activated:Connect(function()
		toggleData.enabled = not toggleData.enabled
		refreshToggle(toggleData)
	end)
end

ui.openButton.Activated:Connect(showMenu)
ui.closeButton.Activated:Connect(hideMenu)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.Insert then
		if ui.menu.Visible then
			hideMenu()
		else
			showMenu()
		end
	end
end)

makeDraggable(ui.header, ui.menu)
makeDraggable(ui.openButton, ui.openButton)
