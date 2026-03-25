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
local function createToggle(name, text)
    local btn = topbarBase:Clone()
    btn.Name = name
    btn.Parent = topbarBase.Parent
    btn.IconButton.IconLabel.Text = text
    btn.IconButton.IconImage.Image = "rbxassetid://12343172715"
    btn.IconOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.IconOverlay.BackgroundTransparency = 1
    btn.IconButton.MouseEnter:Connect(function() btn.IconOverlay.BackgroundTransparency = 0.9 end)
    btn.IconButton.MouseLeave:Connect(function() btn.IconOverlay.BackgroundTransparency = 1 end)
    btn.IconButton.MouseButton1Click:Connect(function()
        if btn.IconButton.IconImage.Image == "rbxassetid://12343172715" then
            btn.IconButton.IconImage.Image = "rbxassetid://12343172777"
        else
            btn.IconButton.IconImage.Image = "rbxassetid://12343172715"
        end
    end)
    return btn
end
local treeToggle = createToggle("TreeToggle", "See Through Trees")
local waterToggle = createToggle("WaterToggle", "Remove Water M1 Effects")
local jumpToggle = createToggle("JumpToggle", "Auto Jump")
local function setTreeState()
    local isTransparent = treeToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
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
local function setJumpState()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoJumpEnabled = (jumpToggle.IconButton.IconImage.Image == "rbxassetid://12343172777")
        end
    end
end
treeToggle.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(setTreeState)
jumpToggle.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(setJumpState)
player.CharacterAdded:Connect(function()
    task.wait(1)
    setJumpState()
end)
for _, item in ipairs(esperFolder:GetChildren()) do
    if not keepList[item.Name] then
        item:Destroy()
    end
end
local function applyOverride(obj)
    local waterActive = waterToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    if obj.Name == "WaterTrail" and obj:IsA("Trail") then
        if waterActive then obj.Texture = "rbxassetid://0" end
        obj:GetPropertyChangedSignal("Texture"):Connect(function()
            if waterToggle.IconButton.IconImage.Image == "rbxassetid://12343172777" and obj.Texture ~= "rbxassetid://0" then
                obj.Texture = "rbxassetid://0"
            end
        end)
    elseif (obj.Name == "ConstantEmit" or obj.Name == "HunterFists") and waterActive then
        obj:Destroy()
    elseif obj.Name == "BodySmokez" or obj.Name == "BodySmoke" or obj.Name == "Debris" then
        obj:Destroy()
    end
end
for _, desc in ipairs(workspace:GetDescendants()) do
    applyOverride(desc)
end
workspace.DescendantAdded:Connect(applyOverride)
RunService.PreRender:Connect(function()
    local waterActive = waterToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local smokez = thrownFolder:FindFirstChild("BodySmokez")
    local smoke = thrownFolder:FindFirstChild("BodySmoke")
    local debris = thrownFolder:FindFirstChild("Debris")
    if smokez then smokez:Destroy() end
    if smoke then smoke:Destroy() end
    if debris then debris:Destroy() end
    local targetModel = liveFolder:FindFirstChild("dzrfklsfklgjhi")
    if targetModel and waterActive then
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
                if waterTrail then waterTrail.Texture = "rbxassetid://0" end
            end
        end
    end
end)
setTreeState()
setJumpState()
