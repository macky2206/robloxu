-- Wait for the player's screen to be ready
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Create the Main UI Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PerfectMobileMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Create the Open Button (Bottom Center of the screen)
local openButton = Instance.new("TextButton")
openButton.Name = "OpenMenuButton"
openButton.Size = UDim2.new(0.3, 0, 0.1, 0) -- 30% of screen width, 10% of height
openButton.Position = UDim2.new(0.5, 0, 0.85, 0) -- Places it near the bottom
openButton.AnchorPoint = Vector2.new(0.5, 0.5) -- Perfectly centers the button itself
openButton.TextScaled = true
openButton.Text = "Open Menu"
openButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Parent = screenGui

-- Add an Aspect Ratio Constraint so the button doesn't stretch into a weird noodle on wide screens
local btnConstraint = Instance.new("UIAspectRatioConstraint")
btnConstraint.AspectRatio = 3.5 
btnConstraint.Parent = openButton

-- 3. Create the Main Menu (Perfectly Centered)
local mainMenu = Instance.new("Frame")
mainMenu.Name = "MainMenu"
mainMenu.Size = UDim2.new(0.8, 0, 0.7, 0) -- 80% of screen width, 70% of height
mainMenu.Position = UDim2.new(0.5, 0, 0.5, 0) -- Dead center of the screen
mainMenu.AnchorPoint = Vector2.new(0.5, 0.5) -- THIS is the magic property that locks it to the center
mainMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainMenu.Visible = false
mainMenu.Parent = screenGui

-- Round the corners of the menu so it looks polished
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0.05, 0)
menuCorner.Parent = mainMenu

-- Keep the menu a nice rectangle on Android/tablets
local menuConstraint = Instance.new("UIAspectRatioConstraint")
menuConstraint.AspectRatio = 1.3 
menuConstraint.Parent = mainMenu

-- 4. Create the Close Button (Top Right Corner of Menu)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0.12, 0, 0.12, 0)
closeButton.Position = UDim2.new(0.98, 0, 0.02, 0) -- Tucked into the top right corner
closeButton.AnchorPoint = Vector2.new(1, 0) -- Anchors the button to its own top-right edge
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Text = "X"
closeButton.Parent = mainMenu

local closeConstraint = Instance.new("UIAspectRatioConstraint")
closeConstraint.AspectRatio = 1 -- Forces the close button to always be a perfect square
closeConstraint.Parent = closeButton

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.2, 0)
closeCorner.Parent = closeButton

-- 5. The Mobile-Friendly Logic
openButton.Activated:Connect(function()
	mainMenu.Visible = true
	openButton.Visible = false -- Hides the open button so it's not in the way
end)

closeButton.Activated:Connect(function()
	mainMenu.Visible = false
	openButton.Visible = true -- Brings the open button back
end)
