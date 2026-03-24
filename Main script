local treesFolder = workspace.Map.Trees
local thrownFolder = workspace.Thrown
local liveFolder = workspace.Live
local esperFolder = game:GetService("ReplicatedStorage").Resources.EsperAwakening
local RunService = game:GetService("RunService")

local keepList = {
    ["Aura"] = true,
    ["WindTimeGreen"] = true,
    ["WindTime"] = true,
    ["Whirl"] = true,
    ["Wave"] = true,
    ["Trail"] = true,
    ["EsperVa2r"] = true,
    ["EsperAura"] = true
}

for _, tree in ipairs(treesFolder:GetChildren()) do
    if tree.Tree:FindFirstChild("TreeRoot") then
        tree.Tree.TreeRoot.Transparency = 0.65
    end
    for _, part in ipairs(tree.Tree:GetChildren()) do
            part.Transparency = 0.65
            part.CastShadow = false
    end
end

for _, item in ipairs(esperFolder:GetChildren()) do
    if not keepList[item.Name] then
        item:Destroy()
    end
end

local function applyOverride(obj)
    if obj.Name == "WaterTrail" and obj:IsA("Trail") then
        obj.Texture = "rbxassetid://0"
        obj:GetPropertyChangedSignal("Texture"):Connect(function()
            if obj.Texture ~= "rbxassetid://0" then
                obj.Texture = "rbxassetid://0"
            end
        end)
    elseif obj.Name == "ConstantEmit" or obj.Name == "BodySmokez" or obj.Name == "BodySmoke" or obj.Name == "Debris" or obj.Name == "HunterFists" then
        obj:Destroy()
    end
end

for _, desc in ipairs(workspace:GetDescendants()) do
    applyOverride(desc)
end

workspace.DescendantAdded:Connect(applyOverride)

RunService.PreRender:Connect(function()
    local smokez = thrownFolder:FindFirstChild("BodySmokez")
    local smoke = thrownFolder:FindFirstChild("BodySmoke")
    local debris = thrownFolder:FindFirstChild("Debris")
    
    if smokez then smokez:Destroy() end
    if smoke then smoke:Destroy() end
    if debris then debris:Destroy() end
    
    local targetModel = liveFolder:FindFirstChild("dzrfklsfklgjhi")
    if targetModel then
        local hunterFists = targetModel:FindFirstChild("HunterFists")
        if hunterFists then hunterFists:Destroy() end
        
        local arms = {"Right Arm", "Left Arm"}
        for _, armName in ipairs(arms) do
            local arm = targetModel:FindFirstChild(armName)
            local waterPalm = arm and arm:FindFirstChild("WaterPalm")
            if waterPalm then
                local constantEmit = waterPalm:FindFirstChild("ConstantEmit")
                local waterTrail = waterPalm:FindFirstChild("WaterTrail")
                
                if constantEmit then constantEmit:Destroy() end
                if waterTrail then applyOverride(waterTrail) end
            end
        end
    end
end)
