local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local theme = {
	background = Color3.fromRGB(11, 18, 32),
	surface = Color3.fromRGB(20, 30, 49),
	surfaceBright = Color3.fromRGB(29, 42, 66),
	accent = Color3.fromRGB(0, 203, 255),
	accentDark = Color3.fromRGB(0, 137, 255),
	text = Color3.fromRGB(240, 249, 255),
	subText = Color3.fromRGB(154, 177, 209),
	danger = Color3.fromRGB(255, 94, 125),
	success = Color3.fromRGB(66, 240, 161),
}

local function round(target, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = target
	return corner
end

local function stroke(target, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0
	s.Parent = target
	return s
end

local function makeDraggable(dragHandle, dragTarget)
	dragHandle.Active = true

	local dragging = false
	local dragInput
	local startPos = Vector2.zero
	local startTargetPos = dragTarget.Position

	local function update(inputPos)
		local delta = inputPos - startPos
		dragTarget.Position = UDim2.new(
			startTargetPos.X.Scale,
			startTargetPos.X.Offset + delta.X,
			startTargetPos.Y.Scale,
			startTargetPos.Y.Offset + delta.Y
		)
	end

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = input.Position
			startTargetPos = dragTarget.Position
			dragInput = input

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			update(input.Position)
		end
	end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerfectMobileMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local openButton = Instance.new("TextButton")
openButton.Name = "OpenMenuButton"
openButton.AnchorPoint = Vector2.new(0.5, 0.5)
openButton.Size = UDim2.fromScale(0.23, 0.075)
openButton.Position = UDim2.fromScale(0.5, 0.9)
openButton.BackgroundColor3 = theme.surface
openButton.TextColor3 = theme.text
openButton.Text = "OPEN"
openButton.Font = Enum.Font.GothamBold
openButton.TextScaled = true
openButton.AutoButtonColor = false
openButton.Parent = screenGui
round(openButton, 16)
stroke(openButton, Color3.fromRGB(112, 142, 187), 1, 0.45)

local openGradient = Instance.new("UIGradient")
openGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, theme.accent),
	ColorSequenceKeypoint.new(1, theme.accentDark),
})
openGradient.Rotation = 20
openGradient.Parent = openButton

local openTextLimit = Instance.new("UITextSizeConstraint")
openTextLimit.MinTextSize = 14
openTextLimit.MaxTextSize = 24
openTextLimit.Parent = openButton

local openAspect = Instance.new("UIAspectRatioConstraint")
openAspect.AspectRatio = 3.1
openAspect.Parent = openButton

local mainMenu = Instance.new("Frame")
mainMenu.Name = "MainMenu"
mainMenu.AnchorPoint = Vector2.new(0.5, 0.5)
mainMenu.Size = UDim2.fromScale(0.84, 0.72)
mainMenu.Position = UDim2.fromScale(0.5, 0.5)
mainMenu.BackgroundColor3 = theme.background
mainMenu.Visible = false
mainMenu.Parent = screenGui
round(mainMenu, 18)
stroke(mainMenu, Color3.fromRGB(124, 163, 216), 1, 0.5)

local menuAspect = Instance.new("UIAspectRatioConstraint")
menuAspect.AspectRatio = 0.78
menuAspect.Parent = mainMenu

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.fromScale(1, 0.17)
topBar.BackgroundColor3 = theme.surface
topBar.Parent = mainMenu
round(topBar, 18)

local barPatch = Instance.new("Frame")
barPatch.Size = UDim2.fromScale(1, 0.3)
barPatch.Position = UDim2.fromScale(0, 0.7)
barPatch.BackgroundColor3 = theme.surface
barPatch.BorderSizePixel = 0
barPatch.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(0.68, 0.46)
title.Position = UDim2.fromScale(0.06, 0.15)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "ROBLOXU MENU"
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = theme.text
title.Parent = topBar

local titleSize = Instance.new("UITextSizeConstraint")
titleSize.MaxTextSize = 24
titleSize.MinTextSize = 13
titleSize.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.fromScale(0.68, 0.3)
subtitle.Position = UDim2.fromScale(0.06, 0.56)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "Stylish • Smooth • Mobile Friendly"
subtitle.TextScaled = true
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextColor3 = theme.subText
subtitle.Parent = topBar

local subtitleSize = Instance.new("UITextSizeConstraint")
subtitleSize.MaxTextSize = 16
subtitleSize.MinTextSize = 10
subtitleSize.Parent = subtitle

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.AnchorPoint = Vector2.new(1, 0.5)
closeButton.Size = UDim2.fromScale(0.13, 0.56)
closeButton.Position = UDim2.fromScale(0.965, 0.5)
closeButton.BackgroundColor3 = theme.danger
closeButton.Text = "✕"
closeButton.TextColor3 = theme.text
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.Parent = topBar
round(closeButton, 12)
stroke(closeButton, Color3.fromRGB(255, 170, 189), 1, 0.35)

local closeSize = Instance.new("UITextSizeConstraint")
closeSize.MaxTextSize = 24
closeSize.MinTextSize = 14
closeSize.Parent = closeButton

local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.fromScale(0.93, 0.77)
content.Position = UDim2.fromScale(0.035, 0.2)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = theme.accent
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = mainMenu

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = content

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 2)
contentPadding.PaddingBottom = UDim.new(0, 8)
contentPadding.Parent = content

local function createCard(name)
	local card = Instance.new("Frame")
	card.Name = name
	card.Size = UDim2.fromScale(1, 0)
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.BackgroundColor3 = theme.surface
	card.Parent = content
	round(card, 12)
	stroke(card, Color3.fromRGB(96, 121, 161), 1, 0.6)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = card

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = card

	return card
end

local function createCardTitle(parent, text)
	local heading = Instance.new("TextLabel")
	heading.Size = UDim2.fromScale(1, 0.22)
	heading.AutomaticSize = Enum.AutomaticSize.Y
	heading.BackgroundTransparency = 1
	heading.Font = Enum.Font.GothamBold
	heading.Text = text
	heading.TextColor3 = theme.text
	heading.TextScaled = true
	heading.TextXAlignment = Enum.TextXAlignment.Left
	heading.Parent = parent

	local headingSize = Instance.new("UITextSizeConstraint")
	headingSize.MinTextSize = 12
	headingSize.MaxTextSize = 18
	headingSize.Parent = heading
end

local function createRow(parent)
	local row = Instance.new("Frame")
	row.Size = UDim2.fromScale(1, 0)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.BackgroundTransparency = 1
	row.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 8)
	layout.Parent = row

	return row
end

local buttonCard = createCard("ButtonCard")
createCardTitle(buttonCard, "Button")

local actionButton = Instance.new("TextButton")
actionButton.Size = UDim2.fromScale(1, 0.34)
actionButton.AutomaticSize = Enum.AutomaticSize.Y
actionButton.BackgroundColor3 = theme.accentDark
actionButton.Font = Enum.Font.GothamSemibold
actionButton.Text = "Run Action"
actionButton.TextColor3 = theme.text
actionButton.TextScaled = true
actionButton.Parent = buttonCard
round(actionButton, 10)
stroke(actionButton, Color3.fromRGB(145, 217, 255), 1, 0.5)

local actionButtonSize = Instance.new("UITextSizeConstraint")
actionButtonSize.MinTextSize = 12
actionButtonSize.MaxTextSize = 18
actionButtonSize.Parent = actionButton

actionButton.Activated:Connect(function()
	actionButton.Text = "Action Complete"
	actionButton.BackgroundColor3 = theme.success
	task.delay(0.6, function()
		actionButton.Text = "Run Action"
		actionButton.BackgroundColor3 = theme.accentDark
	end)
end)

local toggleCard = createCard("ToggleCard")
createCardTitle(toggleCard, "Toggle")

local toggleRow = createRow(toggleCard)

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.fromScale(0.7, 0)
toggleLabel.AutomaticSize = Enum.AutomaticSize.Y
toggleLabel.BackgroundTransparency = 1
toggleLabel.Font = Enum.Font.GothamMedium
toggleLabel.Text = "Enable smooth mode"
toggleLabel.TextColor3 = theme.subText
toggleLabel.TextScaled = true
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.Parent = toggleRow

local toggleLabelSize = Instance.new("UITextSizeConstraint")
toggleLabelSize.MinTextSize = 11
toggleLabelSize.MaxTextSize = 16
toggleLabelSize.Parent = toggleLabel

local toggleSwitch = Instance.new("TextButton")
toggleSwitch.Size = UDim2.fromScale(0.28, 0)
toggleSwitch.AutomaticSize = Enum.AutomaticSize.Y
toggleSwitch.BackgroundColor3 = Color3.fromRGB(58, 72, 96)
toggleSwitch.Text = ""
toggleSwitch.Parent = toggleRow
round(toggleSwitch, 999)
stroke(toggleSwitch, Color3.fromRGB(120, 143, 183), 1, 0.4)

local toggleSwitchAspect = Instance.new("UIAspectRatioConstraint")
toggleSwitchAspect.AspectRatio = 2.1
toggleSwitchAspect.Parent = toggleSwitch

local toggleKnob = Instance.new("Frame")
toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
toggleKnob.Size = UDim2.fromScale(0.42, 0.78)
toggleKnob.Position = UDim2.fromScale(0.05, 0.5)
toggleKnob.BackgroundColor3 = theme.text
toggleKnob.Parent = toggleSwitch
round(toggleKnob, 999)

local isEnabled = false
local function refreshToggle()
	local toggleGoal = {
		BackgroundColor3 = isEnabled and theme.accentDark or Color3.fromRGB(58, 72, 96),
	}
	local knobGoal = {
		Position = isEnabled and UDim2.fromScale(0.53, 0.5) or UDim2.fromScale(0.05, 0.5),
	}
	TweenService:Create(toggleSwitch, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), toggleGoal):Play()
	TweenService:Create(toggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), knobGoal):Play()
end

toggleSwitch.Activated:Connect(function()
	isEnabled = not isEnabled
	refreshToggle()
end)

local sliderCard = createCard("SliderCard")
createCardTitle(sliderCard, "Slider")

local sliderRow = createRow(sliderCard)

local sliderValue = Instance.new("TextLabel")
sliderValue.Size = UDim2.fromScale(0.22, 0)
sliderValue.AutomaticSize = Enum.AutomaticSize.Y
sliderValue.BackgroundTransparency = 1
sliderValue.Font = Enum.Font.GothamSemibold
sliderValue.Text = "50%"
sliderValue.TextColor3 = theme.text
sliderValue.TextScaled = true
sliderValue.TextXAlignment = Enum.TextXAlignment.Right
sliderValue.Parent = sliderRow

local sliderValueSize = Instance.new("UITextSizeConstraint")
sliderValueSize.MinTextSize = 11
sliderValueSize.MaxTextSize = 16
sliderValueSize.Parent = sliderValue

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.fromScale(0.78, 0)
sliderTrack.AutomaticSize = Enum.AutomaticSize.Y
sliderTrack.BackgroundColor3 = Color3.fromRGB(58, 72, 96)
sliderTrack.Parent = sliderRow
round(sliderTrack, 999)

local sliderTrackAspect = Instance.new("UIAspectRatioConstraint")
sliderTrackAspect.AspectRatio = 8
sliderTrackAspect.Parent = sliderTrack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.fromScale(0.5, 1)
sliderFill.BackgroundColor3 = theme.accent
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack
round(sliderFill, 999)

local sliderKnob = Instance.new("Frame")
sliderKnob.AnchorPoint = Vector2.new(0.5, 0.5)
sliderKnob.Size = UDim2.fromScale(0.09, 1.45)
sliderKnob.Position = UDim2.fromScale(0.5, 0.5)
sliderKnob.BackgroundColor3 = theme.text
sliderKnob.Parent = sliderTrack
round(sliderKnob, 999)
stroke(sliderKnob, Color3.fromRGB(187, 221, 255), 1, 0.4)

local sliderButton = Instance.new("TextButton")
sliderButton.BackgroundTransparency = 1
sliderButton.Size = UDim2.fromScale(1, 1)
sliderButton.Text = ""
sliderButton.Parent = sliderTrack

local sliderHeld = false
local function setSliderFromPosition(xPos)
	local absoluteX = sliderTrack.AbsolutePosition.X
	local absoluteWidth = sliderTrack.AbsoluteSize.X
	if absoluteWidth <= 0 then
		return
	end
	local alpha = math.clamp((xPos - absoluteX) / absoluteWidth, 0, 1)
	sliderFill.Size = UDim2.fromScale(alpha, 1)
	sliderKnob.Position = UDim2.fromScale(alpha, 0.5)
	sliderValue.Text = string.format("%d%%", math.floor(alpha * 100 + 0.5))
end

sliderButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliderHeld = true
		setSliderFromPosition(input.Position.X)
	end
end)

sliderButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		sliderHeld = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if sliderHeld and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		setSliderFromPosition(input.Position.X)
	end
end)

local dropdownCard = createCard("DropdownCard")
createCardTitle(dropdownCard, "Dropdown")

local dropdownButton = Instance.new("TextButton")
dropdownButton.Size = UDim2.fromScale(1, 0)
dropdownButton.AutomaticSize = Enum.AutomaticSize.Y
dropdownButton.BackgroundColor3 = theme.surfaceBright
dropdownButton.Font = Enum.Font.GothamSemibold
dropdownButton.Text = "Select Option  ▾"
dropdownButton.TextColor3 = theme.text
dropdownButton.TextScaled = true
dropdownButton.Parent = dropdownCard
round(dropdownButton, 10)
stroke(dropdownButton, Color3.fromRGB(96, 121, 161), 1, 0.45)

local dropdownButtonSize = Instance.new("UITextSizeConstraint")
dropdownButtonSize.MinTextSize = 12
dropdownButtonSize.MaxTextSize = 17
dropdownButtonSize.Parent = dropdownButton

local dropdownList = Instance.new("Frame")
dropdownList.Size = UDim2.fromScale(1, 0)
dropdownList.AutomaticSize = Enum.AutomaticSize.Y
dropdownList.BackgroundColor3 = Color3.fromRGB(15, 24, 39)
dropdownList.Visible = false
dropdownList.Parent = dropdownCard
round(dropdownList, 10)
stroke(dropdownList, Color3.fromRGB(96, 121, 161), 1, 0.5)

local dropdownLayout = Instance.new("UIListLayout")
dropdownLayout.Padding = UDim.new(0, 6)
dropdownLayout.Parent = dropdownList

local dropdownPadding = Instance.new("UIPadding")
dropdownPadding.PaddingTop = UDim.new(0, 8)
dropdownPadding.PaddingBottom = UDim.new(0, 8)
dropdownPadding.PaddingLeft = UDim.new(0, 8)
dropdownPadding.PaddingRight = UDim.new(0, 8)
dropdownPadding.Parent = dropdownList

local options = { "Normal", "Competitive", "Casual", "Ultra" }
for _, option in ipairs(options) do
	local optionButton = Instance.new("TextButton")
	optionButton.Size = UDim2.fromScale(1, 0)
	optionButton.AutomaticSize = Enum.AutomaticSize.Y
	optionButton.BackgroundColor3 = theme.surface
	optionButton.Font = Enum.Font.GothamMedium
	optionButton.Text = option
	optionButton.TextColor3 = theme.subText
	optionButton.TextScaled = true
	optionButton.Parent = dropdownList
	round(optionButton, 8)

	local optionTextSize = Instance.new("UITextSizeConstraint")
	optionTextSize.MinTextSize = 11
	optionTextSize.MaxTextSize = 16
	optionTextSize.Parent = optionButton

	optionButton.Activated:Connect(function()
		dropdownButton.Text = option .. "  ▾"
		dropdownList.Visible = false
	end)
end

dropdownButton.Activated:Connect(function()
	dropdownList.Visible = not dropdownList.Visible
	dropdownButton.Text = (dropdownList.Visible and "Select Option  ▴") or "Select Option  ▾"
end)

openButton.Activated:Connect(function()
	mainMenu.Visible = true
	openButton.Visible = false
end)

closeButton.Activated:Connect(function()
	mainMenu.Visible = false
	openButton.Visible = true
end)

makeDraggable(topBar, mainMenu)
makeDraggable(openButton, openButton)
