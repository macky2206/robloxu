local MenuDesign = {}

local theme = {
	appBg = Color3.fromRGB(5, 11, 21),
	windowBg = Color3.fromRGB(7, 14, 27),
	windowBorder = Color3.fromRGB(20, 58, 74),
	sidebar = Color3.fromRGB(6, 12, 24),
	sectionText = Color3.fromRGB(38, 179, 160),
	mainText = Color3.fromRGB(205, 216, 223),
	subText = Color3.fromRGB(90, 104, 121),
	line = Color3.fromRGB(19, 52, 65),
	track = Color3.fromRGB(30, 38, 54),
	accent = Color3.fromRGB(26, 233, 191),
	switchOff = Color3.fromRGB(32, 39, 55),
	switchKnob = Color3.fromRGB(200, 211, 217),
}

local function round(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = instance
	return corner
end

local function stroke(instance, color, thickness, transparency)
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = color
	uiStroke.Thickness = thickness or 1
	uiStroke.Transparency = transparency or 0
	uiStroke.Parent = instance
	return uiStroke
end

local function textSize(label, minSize, maxSize)
	local constraint = Instance.new("UITextSizeConstraint")
	constraint.MinTextSize = minSize
	constraint.MaxTextSize = maxSize
	constraint.Parent = label
	return constraint
end

function MenuDesign.build(playerGui)
	local existing = playerGui:FindFirstChild("PerfectMobileMenu")
	if existing then
		existing:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PerfectMobileMenu"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui

	local currentCamera = workspace.CurrentCamera

	local openButton = Instance.new("TextButton")
	openButton.Name = "OpenMenuButton"
	openButton.AnchorPoint = Vector2.new(0.5, 0.5)
	openButton.Position = UDim2.fromScale(0.5, 0.9)
	openButton.Size = UDim2.fromOffset(66, 66)
	openButton.BackgroundColor3 = Color3.fromRGB(10, 18, 33)
	openButton.Text = ""
	openButton.AutoButtonColor = false
	openButton.Parent = screenGui
	round(openButton, 18)
	stroke(openButton, Color3.fromRGB(23, 78, 92), 1, 0.15)

	local openGlow = Instance.new("Frame")
	openGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	openGlow.Position = UDim2.fromScale(0.5, 0.5)
	openGlow.Size = UDim2.fromScale(1, 1)
	openGlow.BackgroundTransparency = 1
	openGlow.Parent = openButton
	round(openGlow, 18)
	stroke(openGlow, theme.accent, 1, 0.55)

	local iconHolder = Instance.new("Frame")
	iconHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	iconHolder.Position = UDim2.fromScale(0.5, 0.5)
	iconHolder.Size = UDim2.fromScale(0.54, 0.54)
	iconHolder.BackgroundTransparency = 1
	iconHolder.Parent = openButton

	for i = 0, 2 do
		local line = Instance.new("Frame")
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.Position = UDim2.fromScale(0.5, 0.3 + i * 0.2)
		line.Size = UDim2.fromScale(0.74, 0.11)
		line.BackgroundColor3 = theme.mainText
		line.BorderSizePixel = 0
		line.Parent = iconHolder
		round(line, 999)
	end

	local menu = Instance.new("Frame")
	menu.Name = "MainMenu"
	menu.AnchorPoint = Vector2.new(0.5, 0.5)
	menu.Position = UDim2.fromScale(0.5, 0.5)
	menu.Size = UDim2.fromOffset(470, 820)
	menu.BackgroundColor3 = theme.windowBg
	menu.Visible = false
	menu.Parent = screenGui
	menu.ClipsDescendants = true
	round(menu, 22)
	stroke(menu, theme.windowBorder, 1, 0.2)

	local menuAspect = Instance.new("UIAspectRatioConstraint")
	menuAspect.AspectRatio = 0.58
	menuAspect.Parent = menu

	local function getViewportSize()
		local camera = workspace.CurrentCamera or currentCamera
		if camera then
			currentCamera = camera
			return camera.ViewportSize
		end

		return screenGui.AbsoluteSize.X > 0 and screenGui.AbsoluteSize or Vector2.new(1920, 1080)
	end

	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.fromOffset(72, 1)
	sidebar.AutomaticSize = Enum.AutomaticSize.Y
	sidebar.BackgroundColor3 = theme.sidebar
	sidebar.BorderSizePixel = 0
	sidebar.Parent = menu

	local sidebarHeight = Instance.new("UISizeConstraint")
	sidebarHeight.MinSize = Vector2.new(72, 0)
	sidebarHeight.Parent = sidebar

	local sidebarPatch = Instance.new("Frame")
	sidebarPatch.Size = UDim2.new(0, 26, 1, 0)
	sidebarPatch.Position = UDim2.new(1, -26, 0, 0)
	sidebarPatch.BackgroundColor3 = theme.sidebar
	sidebarPatch.BorderSizePixel = 0
	sidebarPatch.Parent = sidebar

	round(sidebar, 22)

	local navLayout = Instance.new("UIListLayout")
	navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	navLayout.Padding = UDim.new(0, 14)
	navLayout.Parent = sidebar

	local navPadding = Instance.new("UIPadding")
	navPadding.PaddingTop = UDim.new(0, 14)
	navPadding.PaddingBottom = UDim.new(0, 16)
	navPadding.Parent = sidebar

	local function makeSideIcon(symbol, selected)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.fromOffset(54, 54)
		holder.BackgroundColor3 = selected and Color3.fromRGB(10, 25, 35) or Color3.fromRGB(8, 14, 27)
		holder.BackgroundTransparency = selected and 0 or 0.2
		holder.Parent = sidebar
		round(holder, 16)
		stroke(holder, selected and theme.accent or Color3.fromRGB(33, 54, 73), selected and 2 or 1, selected and 0.05 or 0.55)

		if selected then
			local indicator = Instance.new("Frame")
			indicator.AnchorPoint = Vector2.new(0, 0.5)
			indicator.Position = UDim2.fromScale(0, 0.5)
			indicator.Size = UDim2.new(0, 4, 0.75, 0)
			indicator.BackgroundColor3 = theme.accent
			indicator.BorderSizePixel = 0
			indicator.Parent = holder
			round(indicator, 999)
		end

		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
		label.TextColor3 = selected and theme.accent or Color3.fromRGB(82, 100, 122)
		label.Text = symbol
		label.TextScaled = true
		label.Parent = holder
		textSize(label, 11, 24)

		return holder
	end

	makeSideIcon("⌂", true)

	local spacer = Instance.new("Frame")
	spacer.BackgroundTransparency = 1
	spacer.Size = UDim2.new(1, 0, 1, -120)
	spacer.Parent = sidebar

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.fromOffset(54, 54)
	closeButton.BackgroundColor3 = Color3.fromRGB(8, 14, 27)
	closeButton.BackgroundTransparency = 0.35
	closeButton.Text = "✕"
	closeButton.Font = Enum.Font.GothamMedium
	closeButton.TextColor3 = Color3.fromRGB(112, 56, 74)
	closeButton.TextScaled = true
	closeButton.AutoButtonColor = false
	closeButton.Parent = sidebar
	round(closeButton, 16)
	textSize(closeButton, 18, 28)

	local contentWrap = Instance.new("Frame")
	contentWrap.Size = UDim2.new(1, -72, 1, 0)
	contentWrap.Position = UDim2.fromOffset(72, 0)
	contentWrap.BackgroundTransparency = 1
	contentWrap.Parent = menu

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 86)
	header.BackgroundTransparency = 1
	header.Parent = contentWrap

	local headerLine = Instance.new("Frame")
	headerLine.AnchorPoint = Vector2.new(0, 1)
	headerLine.Position = UDim2.fromScale(0, 1)
	headerLine.Size = UDim2.new(1, 0, 0, 1)
	headerLine.BackgroundColor3 = theme.line
	headerLine.BorderSizePixel = 0
	headerLine.Parent = header

	local headerIcon = Instance.new("TextLabel")
	headerIcon.Position = UDim2.fromOffset(28, 25)
	headerIcon.Size = UDim2.fromOffset(26, 34)
	headerIcon.BackgroundTransparency = 1
	headerIcon.Font = Enum.Font.GothamBold
	headerIcon.Text = "⌂"
	headerIcon.TextColor3 = theme.accent
	headerIcon.TextScaled = true
	headerIcon.TextXAlignment = Enum.TextXAlignment.Left
	headerIcon.Parent = header
	textSize(headerIcon, 14, 24)

	local headerTitle = Instance.new("TextLabel")
	headerTitle.Position = UDim2.fromOffset(56, 24)
	headerTitle.Size = UDim2.new(0.58, 0, 0, 34)
	headerTitle.BackgroundTransparency = 1
	headerTitle.Font = Enum.Font.GothamBlack
	headerTitle.Text = "H O M E"
	headerTitle.TextColor3 = theme.mainText
	headerTitle.TextXAlignment = Enum.TextXAlignment.Left
	headerTitle.TextScaled = true
	headerTitle.Parent = header
	textSize(headerTitle, 20, 34)

	local headerTag = Instance.new("TextLabel")
	headerTag.AnchorPoint = Vector2.new(1, 0)
	headerTag.Position = UDim2.new(1, -26, 0, 30)
	headerTag.Size = UDim2.fromOffset(130, 24)
	headerTag.BackgroundTransparency = 1
	headerTag.Font = Enum.Font.Code
	headerTag.Text = "MENU SETTINGS"
	headerTag.TextColor3 = Color3.fromRGB(36, 131, 117)
	headerTag.TextXAlignment = Enum.TextXAlignment.Right
	headerTag.TextScaled = true
	headerTag.Parent = header
	textSize(headerTag, 12, 20)

	local body = Instance.new("ScrollingFrame")
	body.Size = UDim2.new(1, 0, 1, -86)
	body.Position = UDim2.fromOffset(0, 86)
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.ScrollBarThickness = 2
	body.ScrollBarImageTransparency = 0.5
	body.ScrollBarImageColor3 = theme.accent
	body.AutomaticCanvasSize = Enum.AutomaticSize.Y
	body.CanvasSize = UDim2.new()
	body.Parent = contentWrap

	local bodyPadding = Instance.new("UIPadding")
	bodyPadding.PaddingTop = UDim.new(0, 18)
	bodyPadding.PaddingBottom = UDim.new(0, 16)
	bodyPadding.PaddingLeft = UDim.new(0, 28)
	bodyPadding.PaddingRight = UDim.new(0, 24)
	bodyPadding.Parent = body

	local bodyLayout = Instance.new("UIListLayout")
	bodyLayout.Padding = UDim.new(0, 12)
	bodyLayout.Parent = body

	local function makeSection(title)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1, 0, 0, 22)
		holder.BackgroundTransparency = 1
		holder.Parent = body

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromOffset(180, 22)
		label.Font = Enum.Font.Code
		label.Text = title
		label.TextColor3 = theme.sectionText
		label.TextScaled = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = holder
		textSize(label, 12, 24)

		local divider = Instance.new("Frame")
		divider.AnchorPoint = Vector2.new(1, 0.5)
		divider.Position = UDim2.new(1, 0, 0.5, 0)
		divider.Size = UDim2.new(1, -145, 0, 1)
		divider.BackgroundColor3 = theme.line
		divider.BorderSizePixel = 0
		divider.Parent = holder
	end

	local function makeTitleRow(text)
		local row = Instance.new("TextLabel")
		row.Size = UDim2.new(1, 0, 0, 36)
		row.BackgroundTransparency = 1
		row.Font = Enum.Font.GothamSemibold
		row.Text = text
		row.TextColor3 = theme.mainText
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.TextScaled = true
		row.Parent = body
		textSize(row, 14, 40)
	end

	local function makeSlider(value)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 26)
		row.BackgroundTransparency = 1
		row.Parent = body

		local track = Instance.new("Frame")
		track.Position = UDim2.new(0, 0, 0.5, -4)
		track.Size = UDim2.new(1, -88, 0, 8)
		track.BackgroundColor3 = theme.track
		track.BorderSizePixel = 0
		track.Parent = row
		round(track, 999)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.fromScale(value, 1)
		fill.BackgroundColor3 = theme.accent
		fill.BorderSizePixel = 0
		fill.Parent = track
		round(fill, 999)

		local valueLabel = Instance.new("TextLabel")
		valueLabel.AnchorPoint = Vector2.new(1, 0.5)
		valueLabel.Position = UDim2.new(1, 0, 0.5, 0)
		valueLabel.Size = UDim2.fromOffset(70, 22)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Font = Enum.Font.Code
		valueLabel.TextColor3 = theme.accent
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Text = string.format("%d%%", math.floor(value * 100 + 0.5))
		valueLabel.TextScaled = true
		valueLabel.Parent = row
		textSize(valueLabel, 12, 24)
	end

	local function makeAccentRow()
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 44)
		row.BackgroundTransparency = 1
		row.Parent = body

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 180, 1, 0)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamSemibold
		label.Text = "Accent Color"
		label.TextColor3 = theme.mainText
		label.TextScaled = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		textSize(label, 13, 34)

		local colors = {
			Color3.fromRGB(21, 216, 180),
			Color3.fromRGB(128, 100, 225),
			Color3.fromRGB(220, 95, 173),
			Color3.fromRGB(245, 134, 60),
			Color3.fromRGB(77, 148, 230),
		}

		for i, color in ipairs(colors) do
			local chip = Instance.new("Frame")
			chip.AnchorPoint = Vector2.new(1, 0.5)
			chip.Size = UDim2.fromOffset(34, 34)
			chip.Position = UDim2.new(1, -(6 + (6 - i) * 40), 0.5, 0)
			chip.BackgroundColor3 = color
			chip.Parent = row
			round(chip, 999)

			if i == 1 then
				stroke(chip, Color3.fromRGB(231, 255, 255), 2, 0.08)
				local halo = Instance.new("Frame")
				halo.AnchorPoint = Vector2.new(0.5, 0.5)
				halo.Position = UDim2.fromScale(0.5, 0.5)
				halo.Size = UDim2.fromScale(1.35, 1.35)
				halo.BackgroundTransparency = 1
				halo.Parent = chip
				round(halo, 999)
				stroke(halo, color, 1, 0.25)
			end
		end
	end

	local toggles = {}
	local dropdowns = {}

	local function makeToggleRow(title, subtitle, enabled)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 66)
		row.BackgroundTransparency = 1
		row.Parent = body

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, -88, 0, 30)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Font = Enum.Font.GothamSemibold
		titleLabel.Text = title
		titleLabel.TextColor3 = theme.mainText
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextScaled = true
		titleLabel.Parent = row
		textSize(titleLabel, 14, 30)

		local subtitleLabel = Instance.new("TextLabel")
		subtitleLabel.Position = UDim2.fromOffset(0, 30)
		subtitleLabel.Size = UDim2.new(1, -88, 0, 34)
		subtitleLabel.BackgroundTransparency = 1
		subtitleLabel.Font = Enum.Font.Code
		subtitleLabel.Text = subtitle
		subtitleLabel.TextColor3 = theme.subText
		subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
		subtitleLabel.TextWrapped = true
		subtitleLabel.TextScaled = true
		subtitleLabel.Parent = row
		textSize(subtitleLabel, 10, 20)

		local toggle = Instance.new("TextButton")
		toggle.AnchorPoint = Vector2.new(1, 0.5)
		toggle.Position = UDim2.new(1, 0, 0.5, 0)
		toggle.Size = UDim2.fromOffset(86, 40)
		toggle.AutoButtonColor = false
		toggle.Text = ""
		toggle.BackgroundColor3 = enabled and theme.accent or theme.switchOff
		toggle.Parent = row
		round(toggle, 999)

		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Size = UDim2.fromOffset(30, 30)
		knob.Position = enabled and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 20, 0.5, 0)
		knob.BackgroundColor3 = theme.switchKnob
		knob.BorderSizePixel = 0
		knob.Parent = toggle
		round(knob, 999)

		if enabled then
			local glow = Instance.new("UIStroke")
			glow.Color = theme.accent
			glow.Thickness = 1
			glow.Transparency = 0.4
			glow.Parent = toggle
		end

		table.insert(toggles, {
			button = toggle,
			knob = knob,
			enabled = enabled,
		})
	end

	local function makeDropdownRow(title, options, selectedIndex)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 0)
		row.AutomaticSize = Enum.AutomaticSize.Y
		row.BackgroundTransparency = 1
		row.Parent = body

		local rowLayout = Instance.new("UIListLayout")
		rowLayout.Padding = UDim.new(0, 6)
		rowLayout.Parent = row

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, 0, 0, 28)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Font = Enum.Font.GothamSemibold
		titleLabel.Text = title
		titleLabel.TextColor3 = theme.mainText
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextScaled = true
		titleLabel.Parent = row
		textSize(titleLabel, 13, 30)

		local mainButton = Instance.new("TextButton")
		mainButton.Size = UDim2.new(1, 0, 0, 40)
		mainButton.BackgroundColor3 = Color3.fromRGB(7, 18, 32)
		mainButton.AutoButtonColor = false
		mainButton.Font = Enum.Font.Code
		mainButton.TextColor3 = theme.accent
		mainButton.TextXAlignment = Enum.TextXAlignment.Left
		mainButton.TextScaled = true
		mainButton.Parent = row
		round(mainButton, 10)
		stroke(mainButton, Color3.fromRGB(32, 92, 97), 1, 0.25)
		textSize(mainButton, 13, 22)

		local buttonPadding = Instance.new("UIPadding")
		buttonPadding.PaddingLeft = UDim.new(0, 12)
		buttonPadding.PaddingRight = UDim.new(0, 12)
		buttonPadding.Parent = mainButton

		local buttonArrow = Instance.new("TextLabel")
		buttonArrow.AnchorPoint = Vector2.new(1, 0.5)
		buttonArrow.Position = UDim2.new(1, -10, 0.5, 0)
		buttonArrow.Size = UDim2.fromOffset(20, 20)
		buttonArrow.BackgroundTransparency = 1
		buttonArrow.Font = Enum.Font.GothamBold
		buttonArrow.Text = "▾"
		buttonArrow.TextColor3 = theme.subText
		buttonArrow.TextScaled = true
		buttonArrow.Parent = mainButton
		textSize(buttonArrow, 12, 18)

		local list = Instance.new("Frame")
		list.Size = UDim2.new(1, 0, 0, 0)
		list.AutomaticSize = Enum.AutomaticSize.Y
		list.BackgroundColor3 = Color3.fromRGB(8, 16, 28)
		list.BorderSizePixel = 0
		list.Visible = false
		list.Parent = row
		round(list, 10)
		stroke(list, Color3.fromRGB(32, 92, 97), 1, 0.35)

		local listLayout = Instance.new("UIListLayout")
		listLayout.Padding = UDim.new(0, 4)
		listLayout.Parent = list

		local listPadding = Instance.new("UIPadding")
		listPadding.PaddingTop = UDim.new(0, 6)
		listPadding.PaddingBottom = UDim.new(0, 6)
		listPadding.PaddingLeft = UDim.new(0, 6)
		listPadding.PaddingRight = UDim.new(0, 6)
		listPadding.Parent = list

		local optionButtons = {}
		for _, option in ipairs(options) do
			local optionButton = Instance.new("TextButton")
			optionButton.Size = UDim2.new(1, 0, 0, 30)
			optionButton.BackgroundColor3 = Color3.fromRGB(10, 23, 38)
			optionButton.BorderSizePixel = 0
			optionButton.AutoButtonColor = false
			optionButton.Font = Enum.Font.Code
			optionButton.Text = option
			optionButton.TextColor3 = theme.mainText
			optionButton.TextScaled = true
			optionButton.Parent = list
			round(optionButton, 8)
			textSize(optionButton, 11, 18)
			table.insert(optionButtons, optionButton)
		end

		local selected = options[selectedIndex] or options[1] or "Select"
		mainButton.Text = selected

		table.insert(dropdowns, {
			button = mainButton,
			arrow = buttonArrow,
			list = list,
			options = options,
			optionButtons = optionButtons,
			selected = selected,
		})
	end

	makeSection("MENU BEHAVIOR")
	makeTitleRow("Menu Opacity")
	makeSlider(0.92)
	makeTitleRow("Menu Scale")
	makeSlider(1)
	makeAccentRow()
	makeDropdownRow("Open Animation", { "Smooth", "Instant", "Elastic" }, 1)
	makeDropdownRow("Close Animation", { "Smooth", "Instant", "Elastic" }, 1)

	local function applyResponsiveMenuLayout()
		local viewportSize = getViewportSize()
		local baseWidth = 470
		local baseHeight = 820
		local availableWidth = math.max(0, viewportSize.X - 48)
		local availableHeight = math.max(0, viewportSize.Y - 48)
		local needsCompactLayout = availableWidth < baseWidth or availableHeight < baseHeight

		if needsCompactLayout then
			menuAspect.Enabled = false

			local targetWidth = math.floor(math.min(baseWidth, availableWidth))
			local targetHeight = math.floor(math.min(baseHeight, availableHeight))

			menu.Size = UDim2.fromOffset(targetWidth, targetHeight)

			sidebar.Size = UDim2.fromOffset(68, 1)
			sidebarHeight.MinSize = Vector2.new(68, 0)
			contentWrap.Position = UDim2.fromOffset(68, 0)
			contentWrap.Size = UDim2.new(1, -68, 1, 0)
			bodyPadding.PaddingLeft = UDim.new(0, 18)
			bodyPadding.PaddingRight = UDim.new(0, 18)
			header.Size = UDim2.new(1, 0, 0, 80)
			body.Size = UDim2.new(1, 0, 1, -80)
			headerIcon.Position = UDim2.fromOffset(22, 22)
			headerTitle.Position = UDim2.fromOffset(48, 21)
			headerTag.Position = UDim2.new(1, -20, 0, 28)
			headerTag.Size = UDim2.fromOffset(116, 22)
		else
			menu.Size = UDim2.fromOffset(baseWidth, baseHeight)
			menuAspect.DominantAxis = Enum.DominantAxis.Width
			menuAspect.Enabled = true
			sidebar.Size = UDim2.fromOffset(72, 1)
			sidebarHeight.MinSize = Vector2.new(72, 0)
			contentWrap.Position = UDim2.fromOffset(72, 0)
			contentWrap.Size = UDim2.new(1, -72, 1, 0)
			bodyPadding.PaddingLeft = UDim.new(0, 28)
			bodyPadding.PaddingRight = UDim.new(0, 24)
			header.Size = UDim2.new(1, 0, 0, 86)
			body.Size = UDim2.new(1, 0, 1, -86)
			headerIcon.Position = UDim2.fromOffset(28, 25)
			headerTitle.Position = UDim2.fromOffset(56, 24)
			headerTag.Position = UDim2.new(1, -26, 0, 30)
			headerTag.Size = UDim2.fromOffset(130, 24)
		end
	end

	applyResponsiveMenuLayout()

	if currentCamera then
		currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveMenuLayout)
	end

	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		currentCamera = workspace.CurrentCamera
		if currentCamera then
			currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveMenuLayout)
		end
		applyResponsiveMenuLayout()
	end)

	return {
		theme = theme,
		screenGui = screenGui,
		openButton = openButton,
		menu = menu,
		closeButton = closeButton,
		header = header,
		toggles = toggles,
		dropdowns = dropdowns,
	}
end

return MenuDesign
