-- =========================
-- WHITELIST SYSTEM
-- ========================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🔐 Put your allowed UserIds here
local WHITELIST = {
    [312905316] = true, -- you
    [1904462199] = true,
    [7790074927] = true,
    [3143941478] = true,-- friend
    -- add more like this:
    -- [USERID] = true,
}

-- Check whitelist
if not WHITELIST[player.UserId] then
    player:Kick("You are not whitelisted to use this script.")
    return
end

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local lp = player  -- Alias for compatibility

-- =========================
-- Character References
-- =========================
local backpack = player:WaitForChild("Backpack")
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
    char = c
    humanoid = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")
end)

-- =========================
-- Block Delay Configuration
-- =========================
local blockDelay = 0.7
local minDelay = 0.1
local maxDelay = 5.0

-- =========================
-- GUI Setup (Mobile Optimized - See-through)
-- =========================
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "WUXO HUB Teleport"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 160, 0, 220)
Frame.Position = UDim2.new(0.5, -80, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Frame.BackgroundTransparency = 0.5  -- see-through
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Frame).Color = Color3.fromRGB(255,255,255)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -20, 0, 25)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.Text = "XUNO HUB Teleport"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Center

-- =========================
-- Helper function for button click color
-- =========================
local function setupButton(btn)
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) -- blue on click
    end)
end

-- Teleport Button
local TeleportButton = Instance.new("TextButton", Frame)
TeleportButton.Size = UDim2.new(0, 130, 0, 25)
TeleportButton.Position = UDim2.new(0, 15, 0, 38)
TeleportButton.Text = "Teleport"
TeleportButton.TextColor3 = Color3.fromRGB(0,0,0)
TeleportButton.Font = Enum.Font.FredokaOne
TeleportButton.TextSize = 12
TeleportButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", TeleportButton).CornerRadius = UDim.new(0,6)
setupButton(TeleportButton)

-- Keybind Button
local KeybindButton = Instance.new("TextButton", Frame)
KeybindButton.Size = UDim2.new(0, 130, 0, 25)
KeybindButton.Position = UDim2.new(0, 15, 0, 68)
KeybindButton.Text = "Keybind: [F]"
KeybindButton.TextColor3 = Color3.fromRGB(0,0,0)
KeybindButton.Font = Enum.Font.FredokaOne
KeybindButton.TextSize = 12
KeybindButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", KeybindButton).CornerRadius = UDim.new(0,6)
setupButton(KeybindButton)

-- Auto Block Toggle Button
local autoBlockEnabled = true
local AutoBlockButton = Instance.new("TextButton", Frame)
AutoBlockButton.Size = UDim2.new(0, 130, 0, 25)
AutoBlockButton.Position = UDim2.new(0, 15, 0, 98)
AutoBlockButton.Font = Enum.Font.FredokaOne
AutoBlockButton.TextSize = 11
AutoBlockButton.TextColor3 = Color3.fromRGB(0,0,0)
AutoBlockButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", AutoBlockButton).CornerRadius = UDim.new(0,6)
setupButton(AutoBlockButton)

-- Block Delay Label
local DelayLabel = Instance.new("TextLabel", Frame)
DelayLabel.Size = UDim2.new(1, -20, 0, 16)
DelayLabel.Position = UDim2.new(0, 10, 0, 128)
DelayLabel.Text = "Delay:"
DelayLabel.TextColor3 = Color3.fromRGB(255,255,255)
DelayLabel.Font = Enum.Font.FredokaOne
DelayLabel.TextSize = 10
DelayLabel.BackgroundTransparency = 1
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Block Delay Text Box
local DelayTextBox = Instance.new("TextBox", Frame)
DelayTextBox.Size = UDim2.new(0, 75, 0, 20)
DelayTextBox.Position = UDim2.new(0, 15, 0, 145)
DelayTextBox.Text = tostring(blockDelay)
DelayTextBox.TextColor3 = Color3.fromRGB(0,0,0)
DelayTextBox.Font = Enum.Font.FredokaOne
DelayTextBox.TextSize = 11
DelayTextBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
DelayTextBox.PlaceholderText = "0.1-5.0"
DelayTextBox.PlaceholderColor3 = Color3.fromRGB(150,150,150)
Instance.new("UICorner", DelayTextBox).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", DelayTextBox).Color = Color3.fromRGB(100,100,100)

-- Set Delay Button
local SetDelayButton = Instance.new("TextButton", Frame)
SetDelayButton.Size = UDim2.new(0, 40, 0, 20)
SetDelayButton.Position = UDim2.new(0, 100, 0, 145)
SetDelayButton.Text = "Set"
SetDelayButton.TextColor3 = Color3.fromRGB(0,0,0)
SetDelayButton.Font = Enum.Font.FredokaOne
SetDelayButton.TextSize = 10
SetDelayButton.BackgroundColor3 = Color3.fromRGB(200,200,200)
Instance.new("UICorner", SetDelayButton).CornerRadius = UDim.new(0,4)
setupButton(SetDelayButton)

-- Block All Button
local BlockAllButton = Instance.new("TextButton", Frame)
BlockAllButton.Size = UDim2.new(0, 130, 0, 25)
BlockAllButton.Position = UDim2.new(0, 15, 0, 175)
BlockAllButton.Text = "Block All"
BlockAllButton.TextColor3 = Color3.fromRGB(0,0,0)
BlockAllButton.Font = Enum.Font.FredokaOne
BlockAllButton.TextSize = 11
BlockAllButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", BlockAllButton).CornerRadius = UDim.new(0,6)
setupButton(BlockAllButton)

-- Current Delay Display
local CurrentDelayLabel = Instance.new("TextLabel", Frame)
CurrentDelayLabel.Size = UDim2.new(1, -20, 0, 16)
CurrentDelayLabel.Position = UDim2.new(0, 10, 0, 205)
CurrentDelayLabel.Text = "Delay: " .. tostring(blockDelay) .. "s"
CurrentDelayLabel.TextColor3 = Color3.fromRGB(255,255,255)
CurrentDelayLabel.Font = Enum.Font.FredokaOne
CurrentDelayLabel.TextSize = 9
CurrentDelayLabel.BackgroundTransparency = 1
CurrentDelayLabel.TextXAlignment = Enum.TextXAlignment.Center

-- =========================
-- Minimize Button
-- =========================
local ToggleCircle = Instance.new("ImageButton", ScreenGui)
ToggleCircle.Size = UDim2.new(0, 40, 0, 40)
ToggleCircle.Position = UDim2.new(0, 10, 0, 10)
ToggleCircle.BackgroundColor3 = Color3.fromRGB(0,0,0)
ToggleCircle.BackgroundTransparency = 0.2
ToggleCircle.Image = "rbxassetid://6034834113"
ToggleCircle.ImageColor3 = Color3.new(1,1,1)
ToggleCircle.ZIndex = 10
ToggleCircle.Active = true
ToggleCircle.Draggable = true
local ToggleCorner = Instance.new("UICorner", ToggleCircle)
ToggleCorner.CornerRadius = UDim.new(1,0)
local ToggleStroke = Instance.new("UIStroke", ToggleCircle)
ToggleStroke.Color = Color3.fromRGB(255,255,255)
ToggleStroke.Thickness = 1

ToggleCircle.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
    if Frame.Visible then
        ToggleCircle.Image = "rbxassetid://6034834113"
    else
        ToggleCircle.Image = "rbxassetid://6034835320"
    end
end)

-- =========================
-- UI Functions
-- =========================
local function updateAutoBlockUI()
    if autoBlockEnabled then
        AutoBlockButton.Text = "Auto: ON"
        AutoBlockButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    else
        AutoBlockButton.Text = "Auto: OFF"
        AutoBlockButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
    end
end

local function setBlockDelay()
    local text = DelayTextBox.Text
    local num = tonumber(text)
    if num then
        if num < minDelay then num = minDelay end
        if num > maxDelay then num = maxDelay end
        blockDelay = math.floor(num*100+0.5)/100
        DelayTextBox.Text = tostring(blockDelay)
        CurrentDelayLabel.Text = "Delay: "..tostring(blockDelay).."s"
    else
        DelayTextBox.Text = tostring(blockDelay)
    end
end

updateAutoBlockUI()
DelayTextBox.FocusLost:Connect(setBlockDelay)
SetDelayButton.MouseButton1Click:Connect(setBlockDelay)
AutoBlockButton.MouseButton1Click:Connect(function()
    autoBlockEnabled = not autoBlockEnabled
    updateAutoBlockUI()
end)

-- =========================
-- Teleport & Block Logic
-- =========================
local spots = {
    CFrame.new(-402.18, -6.34, 131.83) * CFrame.Angles(0, math.rad(-20.08), 0),
    CFrame.new(-416.66, -6.34, -2.05) * CFrame.Angles(0, math.rad(-62.89), 0),
    CFrame.new(-329.37, -4.68, 18.12) * CFrame.Angles(0, math.rad(-30.53), 0),
}

local REQUIRED_TOOL = "Flying Carpet"
local teleportKey = Enum.KeyCode.F
local waitingForKey = false
local lastTarget = nil

local function equipFlyingCarpet()
    local tool = backpack:FindFirstChild(REQUIRED_TOOL) or char:FindFirstChild(REQUIRED_TOOL)
    if tool and tool.Parent ~= char then humanoid:EquipTool(tool) end
    return tool ~= nil
end

local function FastClick()
    task.wait(blockDelay)
    local cam = workspace.CurrentCamera.ViewportSize
    local x = cam.X/2
    local y = cam.Y/2+23
    for _=1,8 do
        VirtualInputManager:SendMouseButtonEvent(x,y,0,true,game,1)
        VirtualInputManager:SendMouseButtonEvent(x,y,0,false,game,1)
        task.wait(0.008)
    end
end

local function blockPlayer(plr)
    if not plr or plr==player then return end
    pcall(function() StarterGui:SetCore("PromptBlockPlayer",plr) end)
end

local function blockAllPlayers()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=player then blockPlayer(plr); FastClick(); task.wait(0.25) end
    end
end

local function teleportAll()
    if not equipFlyingCarpet() then return end
    lastTarget=nil
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=player then lastTarget=plr; break end
    end
    for _,spot in ipairs(spots) do
        equipFlyingCarpet()
        hrp.CFrame = spot
        task.wait(0.12)
    end
    if lastTarget and autoBlockEnabled then blockPlayer(lastTarget); FastClick() end
end

TeleportButton.MouseButton1Click:Connect(teleportAll)
BlockAllButton.MouseButton1Click:Connect(blockAllPlayers)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if waitingForKey and input.UserInputType==Enum.UserInputType.Keyboard then
        teleportKey=input.KeyCode
        KeybindButton.Text="Keybind: ["..teleportKey.Name.."]"
        waitingForKey=false
    elseif input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==teleportKey then
        teleportAll()
    end
end)
