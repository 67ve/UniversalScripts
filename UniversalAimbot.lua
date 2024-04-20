
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local espKey = Enum.KeyCode.F
local smoothness = 0.05

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local function createESP(part)
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Adornee = part
    espBox.AlwaysOnTop = true
    espBox.Size = part.Size
    espBox.Color3 = Color3.new(1, 0, 0)
    espBox.Transparency = 0.5
    espBox.ZIndex = 5
    espBox.Parent = gui
    return espBox
end

local espEnabled = false
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        StarterGui:SetCore("TopbarEnabled", false)
    else
        StarterGui:SetCore("TopbarEnabled", true)
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == espKey then
        toggleESP()
    end
end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end

    local target = nil
    local minDistance = math.huge

    for _, ply in ipairs(Players:GetPlayers()) do
        if ply ~= player and ply.Character and ply.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = ply.Character.HumanoidRootPart
            local distance = (hrp.Position - camera.CFrame.Position).Magnitude
            local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)

            if onScreen and distance < minDistance then
                minDistance = distance
                target = hrp
            end
        end
    end

    if target then
        local relativePos = camera:WorldToScreenPoint(target.Position)
        local deltaX = relativePos.X - mouse.X
        local deltaY = relativePos.Y - mouse.Y

        mousemoverel(deltaX * smoothness, deltaY * smoothness)
    end
end)
