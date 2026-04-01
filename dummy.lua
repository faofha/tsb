local blockKeyword = "blockMode"
local normalKeyword = "normalMode"
local m1Keyword = "m1Mode"
local loopInterval = 1.5
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local m1LoopActive = false
local function sendCommunicate(goal, key)
    local character = localPlayer.Character
    if character then
        local communicate = character:FindFirstChild("Communicate")
        if communicate and communicate:IsA("RemoteEvent") then
            local args = {
                {
                    Goal = goal,
                    Key = key
                }
            }
            communicate:FireServer(unpack(args))
        end
    end
end
task.spawn(function()
    while true do
        if m1LoopActive then
            local liveFolder = workspace:FindFirstChild("Live")
            local myLiveChar = liveFolder and liveFolder:FindFirstChild(localPlayer.Name)
            if myLiveChar and myLiveChar:FindFirstChild("Freeze") then
                while myLiveChar:FindFirstChild("Freeze") do
                    task.wait(0.1)
                end
            end
            sendCommunicate("LeftClick")
            sendCommunicate("LeftClickRelease")
        end
        task.wait(loopInterval) 
    end
end)
local function onChatted(message)
    local msg = message:lower()
    if msg == blockKeyword:lower() then
        m1LoopActive = false
        sendCommunicate("KeyPress", Enum.KeyCode.F)  
    elseif msg == m1Keyword:lower() then
        m1LoopActive = true   
    elseif msg == normalKeyword:lower() then
        m1LoopActive = false
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
