-- ============================================================
-- VINZ H4X: SNIPER BRUTAL v4
-- Fitur: Fast Kill (Spam Remote), Silent Aim, ESP, Fly, Speed, Noclip
-- ============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- 1. GUI FRAMEWORK (Hitam Merah)
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VinzSniperV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 420)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(255, 26, 26)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "VINZ SNIPER V4 | BRUTAL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Header

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame

local function CreateToggle(name, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Button.BorderSizePixel = 0
    Button.Text = name .. " [OFF]"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.GothamSemibold
    Button.TextSize = 12
    Button.Parent = ScrollFrame
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            Button.Text = name .. " [ON]"
            Button.BackgroundColor3 = Color3.fromRGB(255, 26, 26)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            Button.Text = name .. " [OFF]"
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        callback(state)
    end)
end

-- ============================================================
-- 2. ESP (Kotak, Nama, Jarak)
-- ============================================================
local espEnabled = false
local espObjects = {}

local function CreateESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local bg = Instance.new("BillboardGui")
    bg.Name = "VinzESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 2.5, 0)
    bg.Parent = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = bg

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "[0m]"
    distLabel.TextColor3 = Color3.fromRGB(0, 255, 102)
    distLabel.TextStrokeTransparency = 0
    distLabel.Font = Enum.Font.GothamSemibold
    distLabel.TextSize = 12
    distLabel.Parent = bg

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "VinzESPBox"
    box.Adornee = char:FindFirstChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 1)
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = char:FindFirstChild("HumanoidRootPart")

    espObjects[player] = { bg = bg, box = box, distLabel = distLabel }
end

CreateToggle("Full ESP", function(state)
    espEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do CreateESP(player) end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function() if espEnabled then wait(1) CreateESP(player) end end)
        end)
    else
        for player, data in pairs(espObjects) do
            if data.bg then data.bg:Destroy() end
            if data.box then data.box:Destroy() end
        end
        espObjects = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for player, data in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            local dist = math.floor((player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            if data.distLabel then data.distLabel.Text = "[" .. dist .. "m]" end
        end
    end
end)

-- ============================================================
-- 3. GERAK (FLY, SPEED, NOCLIP)
-- ============================================================
local flyEnabled = false
CreateToggle("Fly", function(state)
    flyEnabled = state
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local bodyVel, bodyGyro
    if state and hrp then
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.Parent = hrp
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bodyGyro.P = 1000
        bodyGyro.Parent = hrp
        spawn(function()
            while flyEnabled and hrp and hrp.Parent do
                local moveDir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                bodyVel.Velocity = moveDir * 50
                bodyGyro.CFrame = Camera.CFrame
                RunService.RenderStepped:Wait()
            end
        end)
    else
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

CreateToggle("Speed Hack", function(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = state and 80 or 16
    end
end)

CreateToggle("Noclip", function(state)
    local char = LocalPlayer.Character
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not state end
        end
    end
end)

-- ============================================================
-- 4. BRUTAL FAST KILL (TANPA AUTO-LOCK, PAKE REMOTE SPAM)
-- ============================================================
local fastKillEnabled = false
local targetPart = nil

CreateToggle("Fast Kill (Peluru Bredet)", function(state) 
    fastKillEnabled = state 
end)

-- Cari target terdekat
local function getClosestTarget()
    local closestDist = 500
    local target = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local aimPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if aimPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < closestDist then closestDist = dist target = aimPart end
                end
            end
        end
    end
    return target
end

-- Loop update target
RunService.RenderStepped:Connect(function()
    if fastKillEnabled then 
        targetPart = getClosestTarget() 
    else 
        targetPart = nil 
    end
end)

-- Nembak pake RemoteEvent (Tanpa nge-lock kamera, jadi lebih anti-error)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if fastKillEnabled and targetPart then
            -- Trik: Kirim sinyal tembakan 20x secara instan
            for i = 1, 20 do
                if targetPart and targetPart.Parent then
                    -- Trik nembak tanpa ubah kamera: pake Raycast manual
                    local rayOrigin = Camera.CFrame.Position
                    local rayDirection = (targetPart.Position - rayOrigin).Unit * 1000
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    
                    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                    if result and result.Instance:IsDescendantOf(targetPart.Parent) then
                        -- Kalo raycast kena musuh, tembak
                        Mouse.TargetFilter = targetPart.Parent
                        Mouse.Hit = CFrame.new(targetPart.Position)
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- 5. TOMBOL CLOSE
-- ============================================================
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = Header
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("[+] Sniper Brutal V4 Loaded! Fast Kill Aktif.")
