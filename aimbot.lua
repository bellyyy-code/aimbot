local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local enabled = false
local maxStuds = 10

local function getNearestTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myRoot = char.HumanoidRootPart
    local nearest = nil
    local minDist = maxStuds

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local enemyRoot = p.Character:FindFirstChild("HumanoidRootPart")
            local enemyHum = p.Character:FindFirstChildOfClass("Humanoid")
            
            if enemyRoot and enemyHum and enemyHum.Health > 0 then
                local dist = (myRoot.Position - enemyRoot.Position).Magnitude
                if dist <= minDist then
                    minDist = dist
                    nearest = enemyRoot
                end
            end
        end
    end
    return nearest
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.R then
        enabled = not enabled
    end
end)

RunService.RenderStepped:Connect(function()
    if enabled then
        local target = getNearestTarget()
        if target then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
    end
end)
