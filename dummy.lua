local blockKeyword = "blockMode"
local normalKeyword = "normalMode"
local m1Keyword = "m1Mode"
local loopInterval = 1.5
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local isMobile = false
local playerGui = localPlayer:WaitForChild("PlayerGui")
local topbar = playerGui:FindFirstChild("TopbarPlus")
if topbar then
    local container = topbar:FindFirstChild("TopbarContainer")
    if container then
        local children = container:GetChildren()
        if children[7] and children[7]:FindFirstChild("DropdownContainer") then
            local frame = children[7].DropdownContainer:FindFirstChild("DropdownFrame")
            if frame and frame:FindFirstChild("UnnamedIcon") then
                isMobile = true
            end
        end
    end
end
local m1LoopActive = false
local isBlocking = false
local function sendCommunicate(goal, key, mobileFlag)
    local character = localPlayer.Character
    if character then
        local communicate = character:FindFirstChild("Communicate")
        if communicate and communicate:IsA("RemoteEvent") then
            local args = {
                {
                    Goal = goal,
                    Key = key,
                    Mobile = mobileFlag
                }
            }
            communicate:FireServer(unpack(args))
        end
    end
end
task.spawn(function()
    while true do
        local liveFolder = workspace:FindFirstChild("Live")
        local myLiveChar = liveFolder and liveFolder:FindFirstChild(localPlayer.Name)
        if myLiveChar and myLiveChar:FindFirstChild("Freeze") then
            if isBlocking then
                sendCommunicate("KeyRelease", Enum.KeyCode.F)
            end
            while myLiveChar:FindFirstChild("Freeze") do
                task.wait(0.1)
            end
            task.wait(0.1)
            if isBlocking then
                sendCommunicate("KeyPress", Enum.KeyCode.F)
                task.delay(0.2, function()
                    if isBlocking then sendCommunicate("KeyPress", Enum.KeyCode.F) end
                end)
            end
        end

        if m1LoopActive then
            if not isMobile then
                sendCommunicate("LeftClick")
                sendCommunicate("LeftClickRelease")
            else
                sendCommunicate("LeftClick", nil, true)
                sendCommunicate("LeftClickRelease", nil, true)
            end
        end
        task.wait(loopInterval)
    end
end)
local function onChatted(message)
    local msg = message:lower()
    if msg == blockKeyword:lower() then
        m1LoopActive = false
        isBlocking = true
        sendCommunicate("KeyPress", Enum.KeyCode.F)
    elseif msg == m1Keyword:lower() then
        m1LoopActive = true 
    elseif msg == normalKeyword:lower() then
        m1LoopActive = false
        isBlocking = false
        sendCommunicate("KeyRelease", Enum.KeyCode.F)
    end
end
local function setupPlayer(player)
    player.Chatted:Connect(onChatted)
end
for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end
Players.PlayerAdded:Connect(setupPlayer)
