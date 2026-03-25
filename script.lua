local treesFolder = workspace.Map.Trees
local thrownFolder = workspace.Thrown
local liveFolder = workspace.Live
local esperFolder = game:GetService("ReplicatedStorage").Resources.EsperAwakening
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

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

local topbarBase = player.PlayerGui.TopbarPlus.TopbarContainer:GetChildren()[7].DropdownContainer.DropdownFrame.AutoActivate
local treeToggle = topbarBase:Clone()
treeToggle.Name = "TreeToggle"
treeToggle.Parent = topbarBase.Parent
treeToggle.IconButton.IconLabel.Text = "See through trees"
treeToggle.IconButton.IconImage.Image = "rbxassetid://12343172715"

treeToggle.IconOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
treeToggle.IconOverlay.BackgroundTransparency = 1

local function setTreeState(isTransparent)
    for _, tree in ipairs(treesFolder:GetChildren()) do
        if tree.Tree:FindFirstChild("TreeRoot") then
            tree.Tree.TreeRoot.Transparency = isTransparent and 0.65 or 0
        end
        for _, part in ipairs(tree.Tree:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = isTransparent and 0.65 or 0
                part.CastShadow = not isTransparent
            end
        end
    end
end

local function updateToggle()
    local img = treeToggle.IconButton.IconImage.Image
    if img == "rbxassetid://12343172777" then
        setTreeState(true)
    elseif img == "rbxassetid://12343172715" then
        setTreeState(false)
    end
end

treeToggle.IconButton.MouseEnter:Connect(function()
    treeToggle.IconOverlay.BackgroundTransparency = 0.9
end)

treeToggle.IconButton.MouseLeave:Connect(function()
    treeToggle.IconOverlay.BackgroundTransparency = 1
end)

treeToggle.IconButton.MouseButton1Click:Connect(function()
    if treeToggle.IconButton.IconImage.Image == "rbxassetid://12343172715" then
        treeToggle.IconButton.IconImage.Image = "rbxassetid://12343172777"
    else
        treeToggle.IconButton.IconImage.Image = "rbxassetid://12343172715"
    end
end)

treeToggle.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(updateToggle)

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

updateToggle()
