local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player and player:FindFirstChild("PlayerGui")

local function destroyIfExists(instance)
	if instance then
		instance:Destroy()
	end
end

destroyIfExists(playerGui and playerGui:FindFirstChild("PerfectMobileMenu"))

local parent = typeof(script) == "Instance" and script.Parent or nil
if parent then
	destroyIfExists(parent:FindFirstChild("menu"))
	destroyIfExists(parent:FindFirstChild("main"))
end

if _G.__PerfectMobileMenuDesign then
	_G.__PerfectMobileMenuDesign = nil
end

if typeof(script) == "Instance" then
	script:Destroy()
end