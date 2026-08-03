local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local REMOTE_MENU_URLS = {
	"https://raw.githubusercontent.com/macky2206/robloxu/refs/heads/main/menu.lua",
}

local function loadRemoteMenuDesign()
	for _, url in ipairs(REMOTE_MENU_URLS) do
		local okSource, sourceOrError = pcall(game.HttpGet, game, url)
		if okSource and type(sourceOrError) == "string" and #sourceOrError > 0 then
			local chunk, compileError = loadstring(sourceOrError)
			if chunk then
				local okChunk, moduleOrError = pcall(chunk)
				if okChunk and type(moduleOrError) == "table" and type(moduleOrError.build) == "function" then
					return moduleOrError
				end
			end
		end
	end

	return nil
end

local function resolveMenuDesign()
	if _G.__PerfectMobileMenuDesign then
		return _G.__PerfectMobileMenuDesign
	end

	local menuModule = script and script:FindFirstChild("menu")

	if not menuModule and script and script.Parent then
		menuModule = script.Parent:FindFirstChild("menu")
	end

	if not menuModule then
		menuModule = game:GetService("ReplicatedStorage"):FindFirstChild("menu")
	end

	if not menuModule then
		local remoteMenu = loadRemoteMenuDesign()
		if remoteMenu then
			_G.__PerfectMobileMenuDesign = remoteMenu
			return remoteMenu
		end
		error("Unable to find ModuleScript 'menu'. Place it under the script, as a sibling, in ReplicatedStorage, or ensure remote menu.lua is accessible.")
	end

	local loadedMenuDesign = require(menuModule)
	_G.__PerfectMobileMenuDesign = loadedMenuDesign
	return loadedMenuDesign
end

local MenuDesign = resolveMenuDesign()
local ui = MenuDesign.build(playerGui)
local theme = ui.theme

local BASE_MENU_SIZE = Vector2.new(470, 820)
local function fitMenuToViewport()
	local camera = workspace.CurrentCamera
	local viewportSize = camera and camera.ViewportSize or Vector2.new(1920, 1080)
	local menu = ui.menu
	local aspect = menu and menu:FindFirstChildOfClass("UIAspectRatioConstraint")
	if not menu then
		return
	end

	local landscapeShort = viewportSize.X > viewportSize.Y and viewportSize.Y <= 780
	local compactViewport = viewportSize.X < BASE_MENU_SIZE.X + 160 or viewportSize.Y < BASE_MENU_SIZE.Y

	if landscapeShort then
		if aspect then
			aspect.Enabled = false
		end

		local targetWidth = math.floor(math.clamp(viewportSize.X * 0.42, 360, 420))
		local targetHeight = math.floor(math.clamp(viewportSize.Y * 0.86, 520, viewportSize.Y - 36))
		menu.Size = UDim2.fromOffset(targetWidth, targetHeight)
	elseif compactViewport then
		if aspect then
			aspect.Enabled = false
		end

		local scale = math.min((viewportSize.X - 36) / BASE_MENU_SIZE.X, (viewportSize.Y - 36) / BASE_MENU_SIZE.Y, 1)
		scale = math.clamp(scale, 0.68, 1)
		menu.Size = UDim2.fromOffset(
			math.floor(BASE_MENU_SIZE.X * scale),
			math.floor(BASE_MENU_SIZE.Y * scale)
		)
	elseif aspect then
		aspect.Enabled = true
		menu.Size = UDim2.fromOffset(BASE_MENU_SIZE.X, BASE_MENU_SIZE.Y)
	end
end

fitMenuToViewport()

local camera = workspace.CurrentCamera
if camera then
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitMenuToViewport)
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	camera = workspace.CurrentCamera
	if camera then
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitMenuToViewport)
	end
	fitMenuToViewport()
end)

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
	for _, dropdownData in ipairs(ui.dropdowns or {}) do
		dropdownData.list.Visible = false
		dropdownData.arrow.Text = "▾"
	end
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

local function closeAllDropdowns()
	for _, dropdownData in ipairs(ui.dropdowns or {}) do
		dropdownData.list.Visible = false
		dropdownData.arrow.Text = "▾"
	end
end

for _, dropdownData in ipairs(ui.dropdowns or {}) do
	dropdownData.button.Activated:Connect(function()
		local shouldOpen = not dropdownData.list.Visible
		closeAllDropdowns()
		dropdownData.list.Visible = shouldOpen
		dropdownData.arrow.Text = shouldOpen and "▴" or "▾"
	end)

	for _, optionButton in ipairs(dropdownData.optionButtons) do
		optionButton.Activated:Connect(function()
			dropdownData.selected = optionButton.Text
			dropdownData.button.Text = optionButton.Text
			dropdownData.list.Visible = false
			dropdownData.arrow.Text = "▾"
		end)
	end
end

ui.openButton.Activated:Connect(showMenu)
ui.closeButton.Activated:Connect(hideMenu)

makeDraggable(ui.header, ui.menu)
makeDraggable(ui.openButton, ui.openButton)
