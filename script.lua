local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local treesFolder = workspace.Map.Trees
local thrownFolder = workspace.Thrown
local liveFolder = workspace.Live
local terrain = workspace.Terrain
local resources = game:GetService("ReplicatedStorage"):WaitForChild("Resources")
local esperFolder = resources.EsperAwakening
local purpleFolder = resources:FindFirstChild("PurpleM1")
local crackFolder = resources:FindFirstChild("LegacyReplication"):FindFirstChild("garcrack")
local circleSmoke = resources:FindFirstChild("LegacyReplication"):FindFirstChild("CircleSmoke")
local folderName = "tsb-faofha"
local fileName = folderName .. "/settings.json"
if not isfolder(folderName) then makefolder(folderName) end
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
local sg = Instance.new("ScreenGui")
sg.Name = "StatsGui"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999
if gethui then sg.Parent = gethui() else sg.Parent = player.PlayerGui end
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 120, 0, 50)
frame.BackgroundTransparency = 1 
frame.Active = true 
frame.Position = (savedData and savedData.StatPos) and UDim2.new(savedData.StatPos.Xn, savedData.StatPos.Xo, savedData.StatPos.Yn, savedData.StatPos.Yo) or UDim2.new(0.5, -60, 0.5, -25)
frame.Parent = sg
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0.5, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextStrokeTransparency = 0
fpsLabel.TextSize = 16
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = frame
local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, 0, 0.5, 0)
pingLabel.Position = UDim2.new(0, 0, 0.5, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.TextStrokeTransparency = 0
pingLabel.TextSize = 16
pingLabel.Font = Enum.Font.Code
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Parent = frame
_G.Toggles = _G.Toggles or {}
local function saveSettings()
    local settings = {}
    for name, btn in pairs(_G.Toggles) do
        settings[name] = (btn.IconButton.IconImage.Image == "rbxassetid://12343172777")
    end
    settings.StatPos = {
        Xn = frame.Position.X.Scale, Xo = frame.Position.X.Offset,
        Yn = frame.Position.Y.Scale, Yo = frame.Position.Y.Offset
    }
    writefile(fileName, HttpService:JSONEncode(settings))
end
local topbarContainer = player.PlayerGui.TopbarPlus.TopbarContainer:GetChildren()[7].DropdownContainer.DropdownFrame
local topbarBase = topbarContainer.AutoActivate
local isMobile = topbarContainer:FindFirstChild("UnnamedIcon") ~= nil
local function createToggle(name, text, defaultOn)
    local existing = topbarContainer:FindFirstChild(name)
    if existing then existing:Destroy() end
    local btn = topbarBase:Clone()
    btn.Name = name
    btn.Parent = topbarContainer
    btn.IconButton.IconLabel.Text = text
    local overlay = btn:FindFirstChild("IconOverlay") or Instance.new("Frame")
    overlay.Name = "IconOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = btn.IconButton.ZIndex + 1
    overlay.Parent = btn
    local isOn = defaultOn
    if savedData and savedData[name] ~= nil then isOn = savedData[name] end
    btn.IconButton.IconImage.Image = isOn and "rbxassetid://12343172777" or "rbxassetid://12343172715"
    if not isMobile then
        btn.IconButton.MouseEnter:Connect(function()
            overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            overlay.BackgroundTransparency = 0.9
        end)
        btn.IconButton.MouseLeave:Connect(function()
            overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            overlay.BackgroundTransparency = 1
        end)
        btn.IconButton.MouseButton1Down:Connect(function()
            overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            overlay.BackgroundTransparency = 0.7
        end)
        btn.IconButton.MouseButton1Up:Connect(function()
            overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            overlay.BackgroundTransparency = 0.9
        end)
    end
    btn.IconButton.MouseButton1Click:Connect(function()
        btn.IconButton.IconImage.Image = (btn.IconButton.IconImage.Image == "rbxassetid://12343172715") and "rbxassetid://12343172777" or "rbxassetid://12343172715"
        saveSettings()
    end)
    _G.Toggles[name] = btn
    return btn
end
local treeT = createToggle("TreeToggle", "See Through Trees", false)
local waterT = createToggle("WaterToggle", "Remove Water M1", false)
local purpleT = createToggle("PurpleToggle", "Remove Purple M1", false)
local crackT = createToggle("CrackToggle", "Hero Hunter Ground Cracks", true)
local cloneT = createToggle("CloneToggle", "Remove After Clones", false)
local jumpT = createToggle("JumpToggle", "Auto Jump", false)
local guiT = createToggle("GuiToggle", "FPS, Ping GUI", false)
local lockT = createToggle("LockToggle", "Lock Menu FPS, Ping", true)
if circleSmoke and circleSmoke:FindFirstChild("Attachment") and circleSmoke.Attachment:FindFirstChild("UpSmoke") then
    circleSmoke.Attachment.UpSmoke.Texture = "rbxassetid://0"
end
local function updateTrees()
    local active = treeT.IconButton.IconImage.Image == "rbxassetid://12343172777"
    for _, tree in ipairs(treesFolder:GetChildren()) do
        local group = tree:FindFirstChild("Tree")
        if group then
            for _, part in ipairs(group:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = active and 0.65 or 0
                    part.CastShadow = not active
                end
            end
        end
    end
end
local function updateCracks()
    if not crackFolder then return end
    local isNormal = crackT.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local crackIds = {["Crack"] = "rbxassetid://10186322998", ["Crack1"] = "rbxassetid://10186322998", ["Crack2"] = "rbxassetid://10186322998", ["Crack3"] = "rbxassetid://10186322998", ["Crack4"] = "rbxassetid://10253382415"}
    for name, id in pairs(crackIds) do
        local obj = crackFolder:FindFirstChild(name)
        if obj and obj:IsA("Decal") then obj.Texture = isNormal and id or "rbxassetid://0" end
    end
end
local function updatePurple()
    if not purpleFolder then return end
    local active = purpleT.IconButton.IconImage.Image == "rbxassetid://12343172777"
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
local function updateJump()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoJumpEnabled = (jumpT.IconButton.IconImage.Image == "rbxassetid://12343172777") end
end
local function updateGuiVisibility()
    frame.Visible = (guiT.IconButton.IconImage.Image == "rbxassetid://12343172777")
end
treeT.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(updateTrees)
purpleT.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(updatePurple)
crackT.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(updateCracks)
jumpT.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(updateJump)
guiT.IconButton.IconImage:GetPropertyChangedSignal("Image"):Connect(updateGuiVisibility)
player.CharacterAdded:Connect(function() task.wait(1) updateJump() end)
for _, item in ipairs(esperFolder:GetChildren()) do
    if not keepList[item.Name] then item:Destroy() end
end
RunService.PreRender:Connect(function()
    local waterActive = waterT.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local cloneActive = cloneT.IconButton.IconImage.Image == "rbxassetid://12343172777"
    local itemsToKill = {"BodySmokez", "BodySmoke", "Debris", "SmallDebris"}
    for _, name in ipairs(itemsToKill) do
        local item = thrownFolder:FindFirstChild(name)
        if item then item:Destroy() end
    end
    if cloneActive then
        local rig = thrownFolder:FindFirstChild("Clone_Rig")
        if rig then rig:Destroy() end
    end
    for _, child in ipairs(terrain:GetChildren()) do
        if child.Name == "SmokeBack" or child:IsA("Attachment") then child:Destroy() end
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
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if lockT.IconButton.IconImage.Image == "rbxassetid://12343172715" and frame.Visible then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    saveSettings()
                end
            end)
        end
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
local fpsInterval = 0.5 
local nextUpdate = 0
local frameCount = 0
RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    local now = os.clock()
    if now >= nextUpdate then
        local fps = math.round(frameCount / (now - (nextUpdate - fpsInterval)))
        fpsLabel.Text = "FPS: " .. fps
        frameCount = 0
        nextUpdate = now + fpsInterval
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        pingLabel.Text = "Ping: " .. math.floor(ping) .. "ms"
    end
end)
updateTrees()
updatePurple()
updateCracks()
updateJump()
updateGuiVisibility()
