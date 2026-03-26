local treesFolder = workspace.Map.Trees
local thrownFolder = workspace.Thrown
local liveFolder = workspace.Live
local terrain = workspace.Terrain
local esperFolder = game:GetService("ReplicatedStorage").Resources.EsperAwakening
local purpleFolder = game:GetService("ReplicatedStorage").Resources:FindFirstChild("PurpleM1")
local crackFolder = game:GetService("ReplicatedStorage").Resources.LegacyReplication:FindFirstChild("garcrack")
local circleSmoke = game:GetService("ReplicatedStorage").Resources.LegacyReplication:FindFirstChild("CircleSmoke")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local folderName = "tsb-faofha"
local fileName = folderName .. "/settings.json"
if not isfolder(folderName) then
    makefolder(folderName)
end
local function loadSettings()
    if isfile(fileName) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(fileName)) end)
        if success then return data end
    end
    return nil
end
local savedData = loadSettings()
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
local topbarContainer = player.PlayerGui.TopbarPlus.TopbarContainer:GetChildren()[7].DropdownContainer.DropdownFrame
local topbarBase = topbarContainer.AutoActivate
local treeToggle, waterToggle, purpleToggle, crackToggle, cloneToggle, jumpToggle
local function saveSettings()
    if not (treeToggle and waterToggle and purpleToggle and crackToggle and cloneToggle and jumpToggle) then return end
    local settings = {
        TreeToggle = treeToggle.IconButton.IconImage.Image == "rbxassetid://12343172777",
        WaterToggle = waterToggle.IconButton.IconImage.Image == "rbxassetid://12343172777",
        PurpleToggle = purpleToggle.IconButton.IconImage.Image == "rbxassetid://12343172777",
        CrackToggle = crackToggle.IconButton.IconImage.Image == "rbxassetid://12343172777",
        CloneToggle = cloneToggle.IconButton.IconImage.Image == "rbxassetid://12343172777",
        JumpToggle = jumpToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    }
    writefile(fileName, HttpService:JSONEncode(settings))
end
local function createToggle(name, text, defaultOn)
    local existing = topbarContainer:FindFirstChild(name)
    if existing then existing:Destroy() end
    local btn = topbarBase:Clone()
    btn.Name = name
    btn.Parent = topbarContainer
    btn.IconButton.IconLabel.Text = text
    local isOn = defaultOn
    if savedData and savedData[name] ~= nil then
        isOn = savedData[name]
    end
    btn.IconButton.IconImage.Image = isOn and "rbxassetid://12343172777" or "rbxassetid://12343172715"
    btn.IconOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.IconOverlay.BackgroundTransparency = 1
    btn.IconButton.MouseEnter:Connect(function() btn.IconOverlay.BackgroundTransparency = 0.9 end)
    btn.IconButton.MouseLeave:Connect(function() btn.IconOverlay.BackgroundTransparency = 1 end)
    btn.IconButton.MouseButton1Click:Connect(function()
        btn.IconButton.IconImage.Image = (btn.IconButton.IconImage.Image == "rbxassetid://12343172715") and "rbxassetid://12343172777" or "rbxassetid://12343172715"
        saveSettings()
    end)
    return btn
end
treeToggle = createToggle("TreeToggle", "See Through Trees", false)
waterToggle = createToggle("WaterToggle", "Remove Water M1 Effects", false)
purpleToggle = createToggle("PurpleToggle", "Remove Purple M1 Effects", false)
crackToggle = createToggle("CrackToggle", "Hero Hunter Ground Cracks", true)
cloneToggle = createToggle("CloneToggle", "Remove After Effects Clone", false)
jumpToggle = createToggle("JumpToggle", "Auto Jump", false)
if circleSmoke and circleSmoke:FindFirstChild("Attachment") and circleSmoke.Attachment:FindFirstChild("UpSmoke") then
    circleSmoke.Attachment.UpSmoke.Texture = "rbxassetid://0"
end
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
local function setCrackState()
    if not crackFolder then return end
    local isNormal = crackToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local crackIds = {
        ["Crack"] = "rbxassetid://10186322998",
        ["Crack1"] = "rbxassetid://10186322998",
        ["Crack2"] = "rbxassetid://10186322998",
        ["Crack3"] = "rbxassetid://10186322998",
        ["Crack4"] = "rbxassetid://10253382415"
    }
    for name, id in pairs(crackIds) do
        local obj = crackFolder:FindFirstChild(name)
        if obj and obj:IsA("Decal") then
            obj.Texture = isNormal and id or "rbxassetid://0"
        end
    end
end
local function setPurpleState()
    if not purpleFolder then return end
    local active = purpleToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local cone = purpleFolder.Cone.Cone
    cone.Mesh.MeshId = active and "rbxassetid://0" or "rbxassetid://6665452633"
    cone.Mesh.TextureId = active and "rbxassetid://0" or "rbxassetid://6665452633"
    cone.Mesh.Scale = active and Vector3.new(0,0,0) or Vector3.new(11.313, 73.867, 10.411)
    cone.Decal.Texture = active and "rbxassetid://0" or "rbxassetid://12460756787"
    cone.Decal.Transparency = active and 1 or 0.3
    local lastE = purpleFolder.Last.End
    lastE.Mesh.MeshId = active and "rbxassetid://0" or "rbxassetid://8501563708"
    lastE.Mesh.Scale = active and Vector3.new(0,0,0) or Vector3.new(1.7, 0.591, 0.571)
    lastE.Decal.Texture = active and "rbxassetid://0" or "rbxassetid://12363773628"
    local lastS = purpleFolder.Last.Start
    lastS.Mesh.MeshId = active and "rbxassetid://0" or "rbxassetid://8501563708"
    lastS.Mesh.Scale = active and Vector3.new(0,0,0) or Vector3.new(1.489, 0.078, 0.076)
    lastS.Decal.Texture = active and "rbxassetid://0" or "rbxassetid://12363773628"
    lastS.Decal.Transparency = active and 1 or 0
    local longE = purpleFolder.Long.End
    longE.Mesh.MeshId = active and "rbxassetid://0" or "rbxassetid://8501563708"
    longE.Mesh.Scale = active and Vector3.new(0,0,0) or Vector3.new(1.489, 0.078, 0.076)
    longE.Decal.Texture = active and "rbxassetid://0" or "rbxassetid://13020112504"
    local longS = purpleFolder.Long.Start
    longS.Mesh.MeshId = active and "rbxassetid://0" or "rbxassetid://8501563708"
    longS.Mesh.Scale = active and Vector3.new(0,0,0) or Vector3.new(0.866, 0.048, 0.046)
    longS.Decal.Texture = active and "rbxassetid://0" or "rbxassetid://13020112504"
    longS.Decal.Transparency = active and 1 or 0
    local trailGroups = {purpleFolder.FasterM1Trail, purpleFolder.M1Trail}
    for _, group in ipairs(trailGroups) do
        group.New.Texture = active and "rbxassetid://0" or "rbxassetid://15939897388"
        group.NewSide.Texture = active and "rbxassetid://0" or "rbxassetid://1177196540"
        group.Trail.Texture = active and "rbxassetid://0" or "rbxassetid://15412407507"
        group:GetChildren()[4].Texture = active and "rbxassetid://0" or "rbxassetid://15939897388"
    end
    purpleFolder.Trail.Trail.Texture = active and "rbxassetid://0" or "rbxassetid://15939897388"
    purpleFolder.Trail:GetChildren()[2].Texture = active and "rbxassetid://0" or "rbxassetid://15412407507"
    purpleFolder.Trail3.Trail.Texture = active and "rbxassetid://0" or "rbxassetid://15939897388"
    purpleFolder.Trail3:GetChildren()[2].Texture = active and "rbxassetid://0" or "rbxassetid://15412407507"
end
local function setJumpState()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoJumpEnabled = (jumpToggle.IconButton.IconImage.Image == "rbxassetid://12343172777") end
end
treeToggle.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(setTreeState)
purpleToggle.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(setPurpleState)
crackToggle.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(setCrackState)
jumpToggle.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(setJumpState)
player.CharacterAdded:Connect(function() task.wait(1) setJumpState() end)
for _, item in ipairs(esperFolder:GetChildren()) do
    if not keepList[item.Name] then item:Destroy() end
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
for _, desc in ipairs(workspace:GetDescendants()) do applyOverride(desc) end
workspace.DescendantAdded:Connect(applyOverride)
RunService.PreRender:Connect(function()
    local waterActive = waterToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local cloneActive = cloneToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local treesActive = treeToggle.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local itemsToKill = {"BodySmokez", "BodySmoke", "Debris", "SmallDebris"}
    for _, name in ipairs(itemsToKill) do
        local item = thrownFolder:FindFirstChild(name)
        if item then item:Destroy() end
    end
    if cloneActive then
        local cloneRig = thrownFolder:FindFirstChild("Clone_Rig")
        if cloneRig then cloneRig:Destroy() end
    end
    for _, child in ipairs(terrain:GetChildren()) do
        if child.Name == "SmokeBack" or child:IsA("Attachment") then
            child:Destroy()
        end
    end
    if treesActive then
        for _, tree in ipairs(treesFolder:GetChildren()) do
            local treeGroup = tree:FindFirstChild("Tree")
            if treeGroup then
                local root = treeGroup:FindFirstChild("TreeRoot")
                if root and root.Transparency ~= 0.65 then root.Transparency = 0.65 end
                for _, part in ipairs(treeGroup:GetChildren()) do
                    if part:IsA("BasePart") then
                        if part.Transparency ~= 0.65 then part.Transparency = 0.65 end
                        if part.CastShadow then part.CastShadow = false end
                    end
                end
            end
        end
    end
    local target = liveFolder:FindFirstChild(player.Name)
    if target and waterActive then
        local fists = target:FindFirstChild("HunterFists")
        if fists then fists:Destroy() end
        for _, side in ipairs({"Right Arm", "Left Arm"}) do
            local part = target:FindFirstChild(side)
            local palm = part and part:FindFirstChild("WaterPalm")
            if palm then
                if palm:FindFirstChild("ConstantEmit") then palm.ConstantEmit:Destroy() end
                if palm:FindFirstChild("WaterTrail") then palm.WaterTrail.Texture = "rbxassetid://0" end
            end
        end
    end
end)
setTreeState()
setPurpleState()
setCrackState()
setJumpState()
