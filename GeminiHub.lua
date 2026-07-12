local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local SocialService = game:GetService("SocialService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Remove existing GUI if present
if game.CoreGui:FindFirstChild("GeminiHub") then game.CoreGui.GeminiHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GeminiHub"
ScreenGui.ResetOnSpawn = false

local function createCorner(p, radius)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, radius or 8)
    return c
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ScaleFactor = 1 -- default scale factor to avoid nil usage

-- MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
if IsMobile then
    MainFrame.Size = UDim2.new(0, 245, 0, 370)
    MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
else
    MainFrame.Size = UDim2.new(0, 255, 0, 440)
    MainFrame.Position = UDim2.new(0.5, -127, 0.5, -220)
end
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true
createCorner(MainFrame, 12)
makeDraggable(MainFrame)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3

-- TOP / STATS
local TopFrame = Instance.new("Frame", MainFrame)
TopFrame.Size = UDim2.new(1, 0, 0, 75)
TopFrame.BackgroundTransparency = 1

local GameFrame = Instance.new("Frame", TopFrame)
GameFrame.Size = UDim2.new(1, -16, 0, 60)
GameFrame.Position = UDim2.new(0, 8, 0, 8)
GameFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
createCorner(GameFrame, 8)

local GameNameLabel = Instance.new("TextLabel", GameFrame)
GameNameLabel.Text = "🎮 Đang tải tên game..."
GameNameLabel.Position = UDim2.new(0, 8, 0, 8)
GameNameLabel.Size = UDim2.new(1, -16, 0, 16)
GameNameLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.TextSize = 11
GameNameLabel.BackgroundTransparency = 1

local StatsLabel = Instance.new("TextLabel", GameFrame)
StatsLabel.Position = UDim2.new(0, 8, 0, 28)
StatsLabel.Size = UDim2.new(1, -16, 0, 14)
StatsLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = 9
StatsLabel.BackgroundTransparency = 1

task.spawn(function()
    pcall(function()
        local info = MarketplaceService:GetProductInfo(game.PlaceId)
        if info then GameNameLabel.Text = "🎮 " .. info.Name end
    end)
end)

task.spawn(function()
    while task.wait(0.5) do
        local ok, delta = pcall(function() return RunService.RenderStepped:Wait() end)
        local fps = 0
        if ok and delta then
            -- estimate FPS by time between frames not precise but okay
            fps = math.floor(1 / delta)
        end
        local ping = 0
        pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        StatsLabel.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms"
    end
end)

-- SPECTATE
local SpectateFrame = Instance.new("Frame", MainFrame)
SpectateFrame.Size = UDim2.new(1, -16, 0, 45)
SpectateFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
SpectateFrame.Visible = false
createCorner(SpectateFrame, 8)

local SpecAvatar = Instance.new("ImageLabel", SpectateFrame)
SpecAvatar.Size = UDim2.new(0, 32, 0, 32)
SpecAvatar.Position = UDim2.new(0, 6, 0, 6)
SpecAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
createCorner(SpecAvatar, 16)

local SpecName = Instance.new("TextLabel", SpectateFrame)
SpecName.Size = UDim2.new(1, -120, 0, 16)
SpecName.Position = UDim2.new(0, 45, 0, 4)
SpecName.BackgroundTransparency = 1
SpecName.TextColor3 = Color3.new(1, 1, 1)
SpecName.Font = Enum.Font.GothamBold
SpecName.TextSize = 9
SpecName.TextXAlignment = Enum.TextXAlignment.Left

local curSpecIndex = 1
local playersList = {}

local function updateSpec()
    playersList = Players:GetPlayers()
    -- build a players list excluding LocalPlayer for navigation simplicity
    local viewable = {}
    for _, p in ipairs(playersList) do
        if p ~= LocalPlayer then table.insert(viewable, p) end
    end
    if #viewable == 0 then
        SpecName.Text = "Không có người chơi khác"
        return
    end
    -- Clamp curSpecIndex
    if curSpecIndex < 1 then curSpecIndex = 1 end
    if curSpecIndex > #viewable then curSpecIndex = 1 end

    local target = viewable[curSpecIndex]
    if target and target.Character and target.Character.Parent then
        SpecName.Text = "Đang xem: " .. (target.DisplayName or target.Name)
        SpecAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. target.UserId .. "&w=150&h=150"
        local hum = target.Character:FindFirstChildOfClass("Humanoid")
        Camera.CameraSubject = hum or target.Character
    else
        SpecName.Text = "Người chơi không có character"
    end
end

local BtnBack = Instance.new("TextButton", SpectateFrame)
BtnBack.Size = UDim2.new(0, 22, 0, 18)
BtnBack.Position = UDim2.new(0, 45, 0, 22)
BtnBack.Text = "<"
BtnBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BtnBack.TextColor3 = Color3.new(1, 1, 1)
createCorner(BtnBack, 4)
BtnBack.MouseButton1Click:Connect(function()
    curSpecIndex = curSpecIndex - 1
    updateSpec()
end)

local BtnNext = Instance.new("TextButton", SpectateFrame)
BtnNext.Size = UDim2.new(0, 22, 0, 18)
BtnNext.Position = UDim2.new(0, 72, 0, 22)
BtnNext.Text = ">"
BtnNext.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BtnNext.TextColor3 = Color3.new(1, 1, 1)
createCorner(BtnNext, 4)
BtnNext.MouseButton1Click:Connect(function()
    curSpecIndex = curSpecIndex + 1
    updateSpec()
end)

-- CHAT AI
local ChatFrame = Instance.new("Frame", MainFrame)
ChatFrame.Size = UDim2.new(1, -16, 0, 90)
ChatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
ChatFrame.Visible = false
createCorner(ChatFrame, 8)

local ResponseLabel = Instance.new("TextLabel", ChatFrame)
ResponseLabel.Size = UDim2.new(1, -12, 0, 55)
ResponseLabel.Position = UDim2.new(0, 6, 0, 4)
ResponseLabel.BackgroundTransparency = 1
ResponseLabel.Text = "Nhập tin nhắn bên dưới để chat với AI..."
ResponseLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ResponseLabel.TextSize = 9
ResponseLabel.Font = Enum.Font.Gotham
ResponseLabel.TextWrapped = true
ResponseLabel.TextYAlignment = Enum.TextYAlignment.Top -- fixed enum
ResponseLabel.TextXAlignment = Enum.TextXAlignment.Left

local InputBox = Instance.new("TextBox", ChatFrame)
InputBox.Size = UDim2.new(1, -12, 0, 20)
InputBox.Position = UDim2.new(0, 6, 1, -24)
InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
InputBox.Text = ""
InputBox.PlaceholderText = "Nhập nội dung..."
InputBox.TextColor3 = Color3.new(1, 1, 1)
InputBox.TextSize = 9
InputBox.Font = Enum.Font.Gotham
createCorner(InputBox, 6)

-- SendToAI: use HttpService safely
local function SendToAI(message)
    ResponseLabel.Text = "AI đang suy nghĩ..."
    task.spawn(function()
        local url = "https://api.simsimi.vn/v1/simtalk"
        local bodyData = "text=" .. HttpService:UrlEncode(message) .. "&lc=vn"

        local success, result = pcall(function()
            return HttpService:PostAsync(url, bodyData, "application/x-www-form-urlencoded")
        end)

        if success and result then
            local dataSuccess, data = pcall(function()
                return HttpService:JSONDecode(result)
            end)
            if dataSuccess and data and data.message then
                ResponseLabel.Text = data.message
            else
                ResponseLabel.Text = "🤖 AI: Tôi chưa hiểu ý bạn lắm."
            end
        else
            ResponseLabel.Text = "❌ Lỗi kết nối tới hệ thống AI!"
        end
    end)
end

InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and InputBox.Text ~= "" then
        SendToAI(InputBox.Text)
        InputBox.Text = ""
    end
end)

-- GRID / BUTTON AREA
local GridScrollFrame = Instance.new("ScrollingFrame", MainFrame)
GridScrollFrame.BackgroundTransparency = 1
GridScrollFrame.ScrollBarThickness = 4
GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
GridScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)

local Grid = Instance.new("UIGridLayout", GridScrollFrame)
Grid.CellSize = UDim2.new(0.98, 0, 0, 36)
Grid.CellPadding = UDim2.new(0, 0, 0, 8)
Grid.SortOrder = Enum.SortOrder.LayoutOrder

local function recaculateCanvas()
    GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 20)
end
Grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(recaculateCanvas)

local function updateLayoutPositions()
    local currentY = 75

    if SpectateFrame and SpectateFrame.Visible then
        SpectateFrame.Position = UDim2.new(0, 8, 0, currentY)
        currentY = currentY + SpectateFrame.Size.Y.Offset + 8
    end

    if ChatFrame and ChatFrame.Visible then
        ChatFrame.Position = UDim2.new(0, 8, 0, currentY)
        currentY = currentY + ChatFrame.Size.Y.Offset + 8
    end

    GridScrollFrame.Position = UDim2.new(0, 8, 0, currentY)
    local remainingHeight = MainFrame.Size.Y.Offset - currentY - 45
    if remainingHeight < 50 then remainingHeight = 50 end
    GridScrollFrame.Size = UDim2.new(1, -16, 0, remainingHeight)

    task.defer(recaculateCanvas)
end

local function createToggle(text, callback)
    local Btn = Instance.new("TextButton", GridScrollFrame)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.Text = text .. " : [TẮT]"
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    createCorner(Btn, 6)

    local isToggled = false
    Btn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            Btn.Text = text .. " : [BẬT]"
            Btn.TextColor3 = Color3.new(1, 1, 1)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Btn.Text = text .. " : [TẮT]"
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(isToggled)
    end)
    return function(extState)
        isToggled = extState
        if isToggled then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            Btn.Text = text .. " : [BẬT]"
            Btn.TextColor3 = Color3.new(1, 1, 1)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Btn.Text = text .. " : [TẮT]"
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
end

local function createSlider(text, minVal, maxVal, defaultVal, callback)
    local SliderBox = Instance.new("Frame", GridScrollFrame)
    SliderBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    createCorner(SliderBox, 6)

    local Title = Instance.new("TextLabel", SliderBox)
    Title.Size = UDim2.new(1, -10, 0, 14)
    Title.Position = UDim2.new(0, 8, 0, 2)
    Title.BackgroundTransparency = 1
    Title.Text = text .. ": " .. defaultVal
    Title.TextColor3 = Color3.fromRGB(0, 220, 255)
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 9
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("TextButton", SliderBox)
    Track.Size = UDim2.new(1, -16, 0, 4)
    Track.Position = UDim2.new(0, 8, 1, -8)
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Track.Text = ""
    Track.AutoButtonColor = false
    createCorner(Track, 2)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    createCorner(Fill, 2)

    local Knob = Instance.new("Frame", Track)
    local kDim = 8
    Knob.Size = UDim2.new(0, kDim, 0, kDim)
    Knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -kDim / 2, 0.5, -kDim / 2)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    createCorner(Knob, kDim / 2)

    local dragging = false
    local function updateSlider(inputX)
        local percentage = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (percentage * (maxVal - minVal)))
        Title.Text = text .. ": " .. value
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -kDim / 2, 0.5, -kDim / 2)
        callback(value)
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true updateSlider(input.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

local function createButton(text, color, callback)
    local Btn = Instance.new("TextButton", GridScrollFrame)
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    createCorner(Btn, 6)
    Btn.MouseButton1Click:Connect(callback)
end

-- TOGGLE BUTTON (the round button)
local ButtonSize = math.floor(70 * ScaleFactor)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, ButtonSize, 0, ButtonSize)
ToggleBtn.Position = UDim2.new(0, 20, 0.4, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ToggleBtn.Text = "📜"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.TextSize = math.floor(32 * ScaleFactor)
createCorner(ToggleBtn, ButtonSize / 2)
makeDraggable(ToggleBtn)

local ButtonStroke = Instance.new("UIStroke", ToggleBtn)
ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
ButtonStroke.Thickness = math.max(1.5, 2 * ScaleFactor)

-- Smooth open/close for MainFrame (optional, more polished)
local TweenService = game:GetService("TweenService")
local MainOpenPos = MainFrame.Position
local MainClosedPos = UDim2.new(MainOpenPos.X.Scale, MainOpenPos.X.Offset, -1, 0)
MainFrame.Position = MainClosedPos
MainFrame.Visible = false
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local isMainOpen = false

ToggleBtn.MouseButton1Click:Connect(function()
    if isMainOpen then
        local t = TweenService:Create(MainFrame, tweenInfo, {Position = MainClosedPos})
        t:Play()
        t.Completed:Wait()
        MainFrame.Visible = false
        isMainOpen = false
        ToggleBtn.Text = "📜"
    else
        MainFrame.Visible = true
        local t = TweenService:Create(MainFrame, tweenInfo, {Position = MainOpenPos})
        t:Play()
        isMainOpen = true
        ToggleBtn.Text = "✖️"
    end
end)

-- FEATURES
local Fly_Active = false
local FlySpeed = 60
local FlyConnection

local function StartFly()
    if not LocalPlayer.Character then return end
    local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not HRP or not Humanoid then return end

    local BV = Instance.new("BodyVelocity", HRP)
    BV.Name = "FlyVelocity"
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Velocity = Vector3.new(0, 0, 0)
    Humanoid.PlatformStand = true

    if FlyConnection then FlyConnection:Disconnect() end
    FlyConnection = RunService.RenderStepped:Connect(function()
        if Fly_Active and HRP and Humanoid then
            local moveDir = Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                local look = Camera.CFrame.LookVector
                local right = Camera.CFrame.RightVector
                local flatLook = Vector3.new(look.X, 0, look.Z).Unit
                local flatRight = Vector3.new(right.X, 0, right.Z).Unit
                if flatLook ~= flatLook then flatLook = Vector3.new(0, 0, -1) end
                if flatRight ~= flatRight then flatRight = Vector3.new(1, 0, 0) end
                local forwardAmount = moveDir:Dot(flatLook)
                local sideAmount = moveDir:Dot(flatRight)
                BV.Velocity = (flatLook * forwardAmount * FlySpeed) + (flatRight * sideAmount * FlySpeed)
            else
                BV.Velocity = Vector3.new(0, 0, 0)
            end
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        end
    end)
end

local function StopFly()
    Fly_Active = false
    if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
    pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyVelocity"):Destroy() end end)
    pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end end)
end

local setFlyToggle = createToggle("Chế Độ Bay", function(state)
    Fly_Active = state
    if Fly_Active then StartFly() else StopFly() end
end)

createSlider("Tốc Độ Bay", 20, 300, FlySpeed, function(val) FlySpeed = val end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        Fly_Active = not Fly_Active
        setFlyToggle(Fly_Active)
        if Fly_Active then StartFly() else StopFly() end
    end
end)

local InfHP_Active = false
createToggle("Vô Hạn Máu (Inf HP)", function(state)
    InfHP_Active = state
    if state then
        task.spawn(function()
            while InfHP_Active do
                task.wait()
                pcall(function()
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        local h = char:FindFirstChildOfClass("Humanoid")
                        h.Health = h.MaxHealth
                    end
                end)
            end
        end)
    end
end)

local InfJump_Active = false
local JumpConnection
createToggle("Nhảy Vô Hạn (Inf Jump)", function(state)
    InfJump_Active = state
    if InfJump_Active then
        JumpConnection = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end)
    else
        if JumpConnection then JumpConnection:Disconnect() JumpConnection = nil end
    end
end)

local AutoKite_Active = false
createToggle("Tự Lùi Khi Đánh", function(state) AutoKite_Active = state end)

local ESP_Active = false
local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            pcall(function() if p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight:Destroy() end end)
            pcall(function() if p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESP_NameTag") then p.Character.Head:FindFirstChild("ESP_NameTag"):Destroy() end end)

            if ESP_Active then
                local ok, _ = pcall(function()
                    local hl = Instance.new("Highlight", p.Character)
                    hl.Name = "ESPHighlight"
                    hl.FillColor = Color3.fromRGB(0, 255, 150)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                    local head = p.Character:FindFirstChild("Head")
                    if head then
                        local bill = Instance.new("BillboardGui", head)
                        bill.Name = "ESP_NameTag"
                        bill.Size = UDim2.new(0, 200, 0, 50)
                        bill.StudsOffset = Vector3.new(0, 2, 0)
                        bill.AlwaysOnTop = true

                        local name = Instance.new("TextLabel", bill)
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.Text = p.DisplayName or p.Name
                        name.TextColor3 = Color3.fromRGB(255, 255, 255)
                        name.TextStrokeTransparency = 0
                        name.BackgroundTransparency = 1
                        name.Font = Enum.Font.GothamBold
                        name.TextSize = 12
                    end
                end)
            end
        end
    end
end
createToggle("ESP Khung + Tên", function(state) ESP_Active = state updateESP() end)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(1) if ESP_Active then updateESP() end end) end)

local AntiKick_Active = false
task.spawn(function()
    local ok, oldKick = pcall(function() return hookfunction(LocalPlayer.Kick, function(self, reason) end) end)
    -- Note: hooking Kick may be restricted; keep safe
end)
createToggle("Chống Máy Châu Kick", function(state) AntiKick_Active = state end)

if IsMobile then
    local ShiftLock_Active = false
    createToggle("Khóa Tâm Mobile", function(state)
        ShiftLock_Active = state
        if not state then UserInputService.MouseBehavior = Enum.MouseBehavior.Default end
    end)
    RunService.RenderStepped:Connect(function()
        if ShiftLock_Active and IsMobile and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            local HRP = LocalPlayer.Character.HumanoidRootPart
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
        end
    end)
end

local AutoClick_Active = false
local ClickSpeed = 0.1
createToggle("Auto Click Chuột", function(state)
    AutoClick_Active = state
    if state then
        task.spawn(function()
            while AutoClick_Active do
                task.wait(ClickSpeed)
                pcall(function() VirtualUser:ClickButton1(Vector2.new(0, 0), Camera.CFrame) end)
            end
        end)
    end
end)
createSlider("Tốc Độ Click", 1, 10, 2, function(val) ClickSpeed = 1 / val end)

createToggle("Bật Khung Chat AI", function(state)
    ChatFrame.Visible = state
    updateLayoutPositions()
end)

createButton("✉️ Mời Bạn Bè Chơi", Color3.fromRGB(35, 140, 75), function()
    pcall(function() SocialService:PromptGameInvite(LocalPlayer) end)
end)

createToggle("Bật Khung Theo Dõi", function(state)
    SpectateFrame.Visible = state
    updateLayoutPositions()
    if state then updateSpec() else
        pcall(function() Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end)
    end
end)

-- AI BOT: safer implementation
local AI_Active = false
RunService.RenderStepped:Connect(function()
    if AI_Active then
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            local HRP = char:FindFirstChild("HumanoidRootPart")
            local Humanoid = char:FindFirstChildOfClass("Humanoid")
            if not HRP or not Humanoid then return end

            local nearestPlayer = nil
            local shortestDistance = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character.Parent then
                    local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                    local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                    if targetHRP and targetHum and targetHum.Health > 0 then
                        local distance = (targetHRP.Position - HRP.Position).Magnitude
                        if distance < shortestDistance then
                            nearestPlayer = p
                            shortestDistance = distance
                        end
                    end
                end
            end

            if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- call MoveTo safely
                local targetPos = nearestPlayer.Character.HumanoidRootPart.Position
                pcall(function() Humanoid:MoveTo(targetPos) end)
            end
        end)
    end
end)
createToggle("Chế Độ AI Bot", function(state) AI_Active = state end)

createButton("🔗 Copy Link Game", Color3.fromRGB(80, 50, 150), function()
    if setclipboard then setclipboard("https://www.roblox.com/games/" .. tostring(game.PlaceId)) end
end)

local Spin_Active = false
RunService.RenderStepped:Connect(function()
    if Spin_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)
createToggle("Xoay Tròn (Spin)", function(state) Spin_Active = state end)

local AutoObby_Active = false
createToggle("Auto Obby (Tự Chơi)", function(state)
    AutoObby_Active = state
    task.spawn(function()
        while AutoObby_Active do
            task.wait(0.4)
            pcall(function()
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("finish")) and obj:IsA("BasePart") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end)
end)

local AutoFarm_Active = false
createToggle("Auto Farm / Attack", function(state)
    AutoFarm_Active = state
    task.spawn(function()
        while AutoFarm_Active do
            task.wait(0.1)
            pcall(function()
                if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then return end
                local target = nil
                local maxDist = 200
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local th = p.Character:FindFirstChildOfClass("Humanoid")
                        if th and th.Health > 0 then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < maxDist then target = p.Character maxDist = dist end
                        end
                    end
                end
                if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = LocalPlayer.Character.HumanoidRootPart
                    if AutoKite_Active then
                        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 6)
                        task.wait(0.05)
                    else
                        HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if tool then
                        if tool.Parent ~= LocalPlayer.Character then tool.Parent = LocalPlayer.Character end
                        pcall(function() tool:Activate() end)
                    end
                end
            end)
        end
    end)
end)

local GhostHit_Active = false
createToggle("Ghost Hit (Sửa Lỗi)", function(state)
    GhostHit_Active = state
    pcall(function()
        local tool = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool"))
        if tool and tool:FindFirstChild("Handle") then
            if GhostHit_Active then
                tool.Handle.Massless = true
                tool.Handle.Size = Vector3.new(20, 20, 20)
                tool.Handle.CanCollide = false
                tool.Handle.Transparency = 0.7
            else
                tool.Handle.Size = Vector3.new(1, 1, 1)
                tool.Handle.Transparency = 0
            end
        end
    end)
end)

local Noclip_Active = false
RunService.Stepped:Connect(function()
    if (Noclip_Active or Fly_Active) and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)
createToggle("Xuyên Tường", function(state) Noclip_Active = state end)

local AFK_Active = false
LocalPlayer.Idled:Connect(function()
    if AFK_Active then
        pcall(function() VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame) task.wait(1) VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame) end)
    end
end)
createToggle("Treo Máy (Anti-AFK)", function(state) AFK_Active = state end)

local JumpPower = 50
createSlider("Chỉnh Lực Nhảy", 50, 300, JumpPower, function(val)
    JumpPower = val
    pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = val end end)
end)

local Speed_Val = 16
createSlider("Chỉnh Tốc Độ", 16, 150, Speed_Val, function(val)
    Speed_Val = val
    pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = val end end)
end)

createButton("Mở Infinite Yield", Color3.fromRGB(150, 50, 50), function()
    pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
end)

-- SERVER LIST area
local ServerListScroll = Instance.new("ScrollingFrame", GridScrollFrame)
ServerListScroll.Size = UDim2.new(0.98, 0, 0, 100)
ServerListScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ServerListScroll.ScrollBarThickness = 3
ServerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
createCorner(ServerListScroll, 6)

local ServerGrid = Instance.new("UIGridLayout", ServerListScroll)
ServerGrid.CellSize = UDim2.new(0.96, 0, 0, 24)
ServerGrid.CellPadding = UDim2.new(0, 0, 0, 4)
ServerGrid.SortOrder = Enum.SortOrder.LayoutOrder

ServerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerListScroll.CanvasSize = UDim2.new(0, 0, 0, ServerGrid.AbsoluteContentSize.Y + 10)
end)

-- Consolidated RefreshServers with sorting and guard checks
local function RefreshServers()
    -- Remove previous server buttons (keep layouts, corners, etc.)
    for _, v in pairs(ServerListScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    task.spawn(function()
        local ok, result = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?limit=100")
        end)
        if not ok or not result then return end

        local success, data = pcall(function() return HttpService:JSONDecode(result) end)
        if not success or not data or not data.data then return end

        -- Sort ascending by playing (small servers first)
        table.sort(data.data, function(a, b)
            return (a.playing or 0) < (b.playing or 0)
        end)

        local currentJobId = tostring(game.JobId or "")

        for _, server in ipairs(data.data) do
            if server and server.playing and server.maxPlayers and server.id and tostring(server.id) ~= currentJobId and server.playing < server.maxPlayers then
                local ServerBtn = Instance.new("TextButton", ServerListScroll)
                ServerBtn.Name = "ServerBtn_" .. tostring(server.id)
                ServerBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

                if server.playing <= 3 then
                    ServerBtn.Text = "🌱 [Small] " .. server.playing .. "/" .. server.maxPlayers .. " | ID: " .. string.sub(tostring(server.id), 1, 8) .. "..."
                    ServerBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
                else
                    ServerBtn.Text = "👤 " .. server.playing .. "/" .. server.maxPlayers .. " | ID: " .. string.sub(tostring(server.id), 1, 8) .. "..."
                    ServerBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
                end

                ServerBtn.Font = Enum.Font.GothamSemibold
                ServerBtn.TextSize = 8
                createCorner(ServerBtn, 4)

                ServerBtn.MouseButton1Click:Connect(function()
                    ServerBtn.Text = "🔄 Vào..."
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    end)
                end)
            end
        end
    end)
end

createButton("🔄 Làm Mới JobId Server", Color3.fromRGB(0, 120, 255), function()
    RefreshServers()
end)

-- Loading effect
local LoadingFrame = Instance.new("Frame", MainFrame)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
LoadingFrame.ZIndex = 10
createCorner(LoadingFrame, 12)

local LoadingLabel = Instance.new("TextLabel", LoadingFrame)
LoadingLabel.Size = UDim2.new(1, 0, 1, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Gemini Hub đang tải..."
LoadingLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
LoadingLabel.Font = Enum.Font.GothamBold
LoadingLabel.TextSize = 14
LoadingLabel.ZIndex = 11

task.spawn(function()
    while LoadingFrame.Parent do
        for i = 1, 3 do
            LoadingLabel.Text = "Gemini Hub đang tải" .. string.rep(".", i)
            task.wait(0.4)
        end
    end
end)

task.delay(2, function()
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(LoadingFrame, info, {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingLabel, info, {TextTransparency = 1}):Play()
    task.wait(0.5)
    LoadingFrame:Destroy()
end)

-- CODE BOX + EXECUTE
local CodeInputBox = Instance.new("TextBox", GridScrollFrame)
CodeInputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
CodeInputBox.Text = ""
CodeInputBox.PlaceholderText = "Dán mã script (.lua) vào đây..."
CodeInputBox.TextColor3 = Color3.fromRGB(0, 255, 150)
CodeInputBox.Font = Enum.Font.Code
CodeInputBox.TextSize = 9
CodeInputBox.TextXAlignment = Enum.TextXAlignment.Left
CodeInputBox.ClearTextOnFocus = false
createCorner(CodeInputBox, 6)

createButton("⚡ Execute Code", Color3.fromRGB(230, 130, 0), function()
    local scriptCode = CodeInputBox.Text
    if scriptCode == "" then
        CodeInputBox.Text = "❌ Bạn chưa dán code!"
        task.wait(1.5)
        CodeInputBox.Text = ""
        return
    end

    local success, err = pcall(function()
        local compiled = loadstring(scriptCode)
        if compiled then
            task.spawn(compiled)
        else
            error("Code bị lỗi cú pháp không chạy được!")
        end
    end)

    if success then
        CodeInputBox.Text = "✅ Đã chạy script thành công!"
        task.wait(1.5)
        CodeInputBox.Text = ""
    else
        CodeInputBox.Text = "❌ Lỗi: " .. tostring(err)
        task.wait(3)
        CodeInputBox.Text = ""
    end
end)

-- EMOTES
local Emotes = {
    {"👋 Xin chào", "Wave"},
    {"😊 Vui vẻ", "Cheer"},
    {"😂 Cười", "Laugh"},
    {"💃 Nhảy", "Dance"},
    {"🤔 Suy nghĩ", "Point"}
}

local EmoteFrame = Instance.new("ScrollingFrame", GridScrollFrame)
EmoteFrame.Size = UDim2.new(0.98, 0, 0, 80)
EmoteFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
EmoteFrame.ScrollBarThickness = 2
createCorner(EmoteFrame, 6)

local EmoteGrid = Instance.new("UIGridLayout", EmoteFrame)
EmoteGrid.CellSize = UDim2.new(0.47, 0, 0, 24)
EmoteGrid.CellPadding = UDim2.new(0.04, 0, 0, 4)
EmoteGrid.SortOrder = Enum.SortOrder.LayoutOrder

for _, emote in pairs(Emotes) do
    local EBtn = Instance.new("TextButton", EmoteFrame)
    EBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    EBtn.Text = emote[1]
    EBtn.TextColor3 = Color3.new(1, 1, 1)
    EBtn.Font = Enum.Font.Gotham
    EBtn.TextSize = 9
    createCorner(EBtn, 4)

    EBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.PlayEmote then
                humanoid:PlayEmote(emote[2])
            end
        end)
    end)
end

EmoteGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    EmoteFrame.CanvasSize = UDim2.new(0, 0, 0, EmoteGrid.AbsoluteContentSize.Y + 10)
end)

-- INVISIBLE
local Invisible_Active = false
createToggle("Chế độ Tàng Hình", function(state)
    Invisible_Active = state
    local char = LocalPlayer.Character
    if not char then return end

    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            pcall(function()
                part.Transparency = Invisible_Active and 1 or 0
            end)
        end
    end

    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        for _, part in pairs(tool:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part.Transparency = Invisible_Active and 0.5 or 0 end)
            end
        end
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Invisible_Active and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    end

    if char:FindFirstChild("Head") and char.Head:FindFirstChild("NameTag") then
        char.Head.NameTag.Enabled = not Invisible_Active
    end
end)

-- PLAYER LIST
local PlayerListScroll = Instance.new("ScrollingFrame", GridScrollFrame)
PlayerListScroll.Size = UDim2.new(0.98, 0, 0, 100)
PlayerListScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
PlayerListScroll.ScrollBarThickness = 3
createCorner(PlayerListScroll, 6)

local PlayerGrid = Instance.new("UIGridLayout", PlayerListScroll)
PlayerGrid.CellSize = UDim2.new(0.96, 0, 0, 24)
PlayerGrid.CellPadding = UDim2.new(0, 0, 0, 4)
PlayerGrid.SortOrder = Enum.SortOrder.LayoutOrder

local function RefreshPlayerList()
    for _, v in pairs(PlayerListScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for _, p in pairs(Players:GetPlayers()) do
        local PBtn = Instance.new("TextButton", PlayerListScroll)
        PBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        PBtn.Text = "👤 " .. p.Name
        PBtn.TextColor3 = Color3.new(1, 1, 1)
        PBtn.Font = Enum.Font.Gotham
        PBtn.TextSize = 9
        createCorner(PBtn, 4)

        PBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(p.Name)
                PBtn.Text = "✅ Đã Copy Tên!"
                task.wait(1)
                PBtn.Text = "👤 " .. p.Name
            end
        end)
    end
end

createButton("🔄 Cập Nhật Người Chơi", Color3.fromRGB(80, 80, 100), function()
    RefreshPlayerList()
end)

PlayerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerGrid.AbsoluteContentSize.Y + 10)
end)

RefreshPlayerList()

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(1, -16, 0, 28)
CloseBtn.Position = UDim2.new(0, 8, 1, -36)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 10
CloseBtn.Text = "Ẩn Bảng Menu"
createCorner(CloseBtn, 6)
CloseBtn.MouseButton1Click:Connect(function()
    -- close with tween
    if isMainOpen then
        local t = TweenService:Create(MainFrame, tweenInfo, {Position = MainClosedPos})
        t:Play()
        t.Completed:Wait()
        MainFrame.Visible = false
        isMainOpen = false
        ToggleBtn.Text = "📜"
    else
        MainFrame.Visible = false
    end
end)

-- ACTIVATE
RefreshServers()
updateLayoutPositions()
