local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local SocialService = game:GetService("SocialService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Dọn dẹp GUI cũ để tránh kẹt bộ nhớ
if game.CoreGui:FindFirstChild("GeminiHub") then game.CoreGui.GeminiHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "GeminiHub"
ScreenGui.ResetOnSpawn = false

-- Hàm tạo Bo Góc nhanh
local function createCorner(p, radius) 
    local c = Instance.new("UICorner", p) 
    c.CornerRadius = UDim.new(0, radius or 8) 
    return c 
end

-- --- Hàm Kéo Thả GUI Mượt Mà ---
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

-- --- CẤU HÌNH TỶ LỆ KÍCH THƯỚC (SCALE UI) ---
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local ScaleFactor = IsMobile and 0.55 or 1.2 

local BaseWidth = 280
local BaseHeight = IsMobile and 560 or 510

local FrameWidth = math.floor(BaseWidth * ScaleFactor)
local FrameHeight = math.floor(BaseHeight * ScaleFactor)

-- --- Giao Diện Chính ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, FrameWidth, 0, FrameHeight)
MainFrame.Position = UDim2.new(0.5, -(FrameWidth/2), 0.5, -(FrameHeight/2))
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.ClipsDescendants = true
createCorner(MainFrame, math.floor(16 * ScaleFactor))
makeDraggable(MainFrame)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = math.max(1, 1.5 * ScaleFactor)
UIStroke.Transparency = 0.3

-- Thùng chứa trên cùng (Thông tin Game & Profile)
local TopFrame = Instance.new("Frame", MainFrame)
TopFrame.Size = UDim2.new(1, 0, 0, math.floor(165 * ScaleFactor))
TopFrame.BackgroundTransparency = 1

-- --- KHU VỰC THÔNG TIN GAME ROBLOX & ID SERVER ---
local GameFrame = Instance.new("Frame", TopFrame)
GameFrame.Size = UDim2.new(1, -20, 0, math.floor(75 * ScaleFactor))
GameFrame.Position = UDim2.new(0, 10, 0, 10)
GameFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
createCorner(GameFrame, math.floor(10 * ScaleFactor))

local GameStroke = Instance.new("UIStroke", GameFrame)
GameStroke.Color = Color3.fromRGB(0, 200, 255)
GameStroke.Thickness = 1
GameStroke.Transparency = 0.5

local GameNameLabel = Instance.new("TextLabel", GameFrame)
GameNameLabel.Text = "🎮 Đang tải tên game..."
GameNameLabel.Position = UDim2.new(0, 10, 0, math.floor(6 * ScaleFactor))
GameNameLabel.Size = UDim2.new(1, -20, 0, math.floor(20 * ScaleFactor))
GameNameLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameNameLabel.Font = Enum.Font.GothamBold
GameNameLabel.TextSize = math.floor(13 * ScaleFactor)

local GameIdLabel = Instance.new("TextLabel", GameFrame)
GameIdLabel.Text = "ID Game: " .. game.PlaceId
GameIdLabel.Position = UDim2.new(0, 10, 0, math.floor(26 * ScaleFactor))
GameIdLabel.Size = UDim2.new(1, -20, 0, math.floor(20 * ScaleFactor))
GameIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
GameIdLabel.TextXAlignment = Enum.TextXAlignment.Left
GameIdLabel.Font = Enum.Font.Code
GameIdLabel.TextSize = math.floor(11 * ScaleFactor)

local JobIdLabel = Instance.new("TextButton", GameFrame)
JobIdLabel.Text = "JobId: " .. game.JobId:sub(1, 12) .. "..."
JobIdLabel.Position = UDim2.new(0, 10, 0, math.floor(46 * ScaleFactor))
JobIdLabel.Size = UDim2.new(1, -20, 0, math.floor(20 * ScaleFactor))
JobIdLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
JobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
JobIdLabel.BackgroundTransparency = 1
JobIdLabel.Font = Enum.Font.Code
JobIdLabel.TextSize = math.floor(11 * ScaleFactor)

task.spawn(function()
    pcall(function()
        local success, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
        if success and info then GameNameLabel.Text = "🎮 " .. info.Name end
    end)
end)

JobIdLabel.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        local oldText = JobIdLabel.Text
        JobIdLabel.Text = "✅ Đã copy JobID Server!"
        task.wait(2)
        JobIdLabel.Text = oldText
    end
end)

-- --- Khu Vực Hồ Sơ Người Chơi ---
local ProfileFrame = Instance.new("Frame", TopFrame)
ProfileFrame.Size = UDim2.new(1, -20, 0, math.floor(65 * ScaleFactor))
ProfileFrame.Position = UDim2.new(0, 10, 0, math.floor(95 * ScaleFactor))
ProfileFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
createCorner(ProfileFrame, math.floor(10 * ScaleFactor))

local ProfileImg = Instance.new("ImageLabel", ProfileFrame)
ProfileImg.Size = UDim2.new(0, math.floor(45 * ScaleFactor), 0, math.floor(45 * ScaleFactor))
ProfileImg.Position = UDim2.new(0, 10, 0, math.floor(10 * ScaleFactor))
ProfileImg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
createCorner(ProfileImg, math.floor(22 * ScaleFactor))

pcall(function() ProfileImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)

local NameLabel = Instance.new("TextLabel", ProfileFrame)
NameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name
NameLabel.Position = UDim2.new(0, math.floor(65 * ScaleFactor), 0, math.floor(12 * ScaleFactor))
NameLabel.Size = UDim2.new(0, math.floor(170 * ScaleFactor), 0, math.floor(20 * ScaleFactor))
NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = math.floor(13 * ScaleFactor)

local StatsLabel = Instance.new("TextLabel", ProfileFrame)
StatsLabel.Position = UDim2.new(0, math.floor(65 * ScaleFactor), 0, math.floor(32 * ScaleFactor))
StatsLabel.Size = UDim2.new(0, math.floor(170 * ScaleFactor), 0, math.floor(20 * ScaleFactor))
StatsLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Font = Enum.Font.Code
StatsLabel.TextSize = math.floor(11 * ScaleFactor)

spawn(function()
    while task.wait(0.5) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local ping = 0
        pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        StatsLabel.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms"
    end
end)
-- --- LƯỚI CHỨA TÍNH NĂNG DẠNG LƯỚI 2 CỘT TỰ CUỘN (ĐÃ TỐI ƯU) ---
local GridScrollFrame = Instance.new("ScrollingFrame", MainFrame)
GridScrollFrame.Size = UDim2.new(1, -20, 1, math.floor(-225 * ScaleFactor))
GridScrollFrame.Position = UDim2.new(0, 10, 0, math.floor(170 * ScaleFactor))
GridScrollFrame.BackgroundTransparency = 1
GridScrollFrame.ScrollBarThickness = 4 -- Bật lại thanh cuộn để dễ thao tác
GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0) 

local Grid = Instance.new("UIGridLayout", GridScrollFrame)
Grid.CellSize = UDim2.new(0.5, -6, 0, math.floor(52 * ScaleFactor))
Grid.CellPadding = UDim2.new(0, 12, 0, 12)
Grid.SortOrder = Enum.SortOrder.LayoutOrder

-- [FIX QUAN TRỌNG]: Tự động mở rộng độ dài khi có thêm nút
Grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    GridScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 20)
end)

-- 1. Hàm tạo Nút Lưới Toggle (Bật/Tắt)
local function createToggle(text, callback)
    local Btn = Instance.new("TextButton", GridScrollFrame)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.Text = text .. "\n[TẮT]"
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = math.floor(11 * ScaleFactor)
    createCorner(Btn, 8)
    
    local isToggled = false
    Btn.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        if isToggled then
            Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            Btn.Text = text .. "\n[BẬT]"
            Btn.TextColor3 = Color3.new(1, 1, 1)
        else
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Btn.Text = text .. "\n[TẮT]"
            Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        callback(isToggled)
    end)
    return function(extState) isToggled = extState if isToggled then Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) Btn.Text = text .. "\n[BẬT]" Btn.TextColor3 = Color3.new(1, 1, 1) else Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40) Btn.Text = text .. "\n[TẮT]" Btn.TextColor3 = Color3.fromRGB(180, 180, 180) end end
end

-- 2. Hàm tạo Thanh Kéo Lưới (Slider)
local function createSlider(text, minVal, maxVal, defaultVal, callback)
    local SliderBox = Instance.new("Frame", GridScrollFrame)
    SliderBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    createCorner(SliderBox, 8)
    
    local Title = Instance.new("TextLabel", SliderBox)
    Title.Size = UDim2.new(1, -10, 0, math.floor(20 * ScaleFactor))
    Title.Position = UDim2.new(0, 8, 0, 4)
    Title.BackgroundTransparency = 1
    Title.Text = text .. ": " .. defaultVal
    Title.TextColor3 = Color3.fromRGB(0, 220, 255)
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = math.floor(10 * ScaleFactor)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Track = Instance.new("TextButton", SliderBox)
    Track.Size = UDim2.new(1, -16, 0, math.floor(4 * ScaleFactor))
    Track.Position = UDim2.new(0, 8, 1, math.floor(-14 * ScaleFactor))
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Track.Text = ""
    Track.AutoButtonColor = false
    createCorner(Track, 2)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    createCorner(Fill, 2)

    local Knob = Instance.new("Frame", Track)
    local kDim = math.floor(10 * ScaleFactor)
    Knob.Size = UDim2.new(0, kDim, 0, kDim)
    Knob.Position = UDim2.new((defaultVal - minVal)/(maxVal - minVal), -kDim/2, 0.5, -kDim/2)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    createCorner(Knob, kDim/2)

    local dragging = false
    local function updateSlider(inputX)
        local percentage = math.clamp((inputX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (percentage * (maxVal - minVal)))
        Title.Text = text .. ": " .. value
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Knob.Position = UDim2.new(percentage, -kDim/2, 0.5, -kDim/2)
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

-- 3. Hàm tạo Nút Hành Động (Action Button) như Mời Bạn
local function createButton(text, color, callback)
    local Btn = Instance.new("TextButton", GridScrollFrame)
    Btn.BackgroundColor3 = color
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = math.floor(12 * ScaleFactor)
    createCorner(Btn, 8)
    Btn.MouseButton1Click:Connect(callback)
end

-- --- NÚT TRÒN MỞ MENU TO RÕ (70x70) ---
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

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- --- LOGIC CÁC CHỨC NĂNG HACK ---
local Fly_Active = false
local FlySpeed = 60
local FlyConnection

local function StartFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = LocalPlayer.Character.HumanoidRootPart
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local BV = Instance.new("BodyVelocity", HRP)
    BV.Name = "FlyVelocity"
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Humanoid.PlatformStand = true

    FlyConnection = RunService.RenderStepped:Connect(function()
        if Fly_Active and HRP and Humanoid then
            local moveDir = Humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                local look = Camera.CFrame.LookVector
                local right = Camera.CFrame.RightVector
                local forwardAmount = moveDir:Dot(CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(look.X, 0, look.Z)).LookVector)
                local sideAmount = moveDir:Dot(CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Vector3.new(look.X, 0, look.Z)).RightVector)
                BV.Velocity = (look * forwardAmount * FlySpeed) + (right * sideAmount * FlySpeed)
            else BV.Velocity = Vector3.new(0, 0, 0) end
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Camera.CFrame.LookVector)
        end
    end)
end

local function StopFly()
    Fly_Active = false
    if FlyConnection then FlyConnection:Disconnect() end
    pcall(function() LocalPlayer.Character.HumanoidRootPart.FlyVelocity:Destroy() end)
    pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end)
end

-- --- THIẾT LẬP CÁC PHẦN TỬ LƯỚI ---

-- 1. Fly
local setFlyToggle = createToggle("Chế Độ Bay", function(state)
    Fly_Active = state
    if Fly_Active then StartFly() else StopFly() end
end)

-- Keybind E nhanh cho máy tính
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.E then
        Fly_Active = not Fly_Active
        setFlyToggle(Fly_Active)
        if Fly_Active then StartFly() else StopFly() end
    end
end)

-- 2. Tốc độ bay
createSlider("Tốc Độ Bay", 20, 300, FlySpeed, function(val) FlySpeed = val end)

-- 3. Noclip
local Noclip_Active = false
RunService.Stepped:Connect(function()
    if (Noclip_Active or Fly_Active) and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)
createToggle("Xuyên Tường", function(state) Noclip_Active = state end)

-- --- 4. ESP NGƯỜI CHƠI (KHUNG + TÊN) ---
local ESP_Active = false

local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            -- Xóa cũ nếu có để tránh trùng lặp
            pcall(function() p.Character.ESPHighlight:Destroy() end)
            pcall(function() p.Character.Head:FindFirstChild("ESP_NameTag"):Destroy() end)

            if ESP_Active then
                -- 1. Khung (Highlight)
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "ESPHighlight"
                hl.FillColor = Color3.fromRGB(0, 255, 150)
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

                -- 2. Tên (BillboardGui)
                local bill = Instance.new("BillboardGui", p.Character.Head)
                bill.Name = "ESP_NameTag"
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.StudsOffset = Vector3.new(0, 2, 0)
                bill.AlwaysOnTop = true

                local name = Instance.new("TextLabel", bill)
                name.Size = UDim2.new(1, 0, 1, 0)
                name.Text = p.Name
                name.TextColor3 = Color3.fromRGB(255, 255, 255)
                name.TextStrokeTransparency = 0 -- Làm viền chữ cho dễ đọc
                name.BackgroundTransparency = 1
                name.Font = Enum.Font.GothamBold
            end
        end
    end
end

createToggle("ESP + Tên", function(state) 
    ESP_Active = state 
    updateESP() 
end)

-- Tự động cập nhật khi có người vào server
Players.PlayerAdded:Connect(function(p) 
    p.CharacterAdded:Connect(function() 
        task.wait(1) 
        if ESP_Active then updateESP() end 
    end) 
end)

-- 5. Anti AFK
local AFK_Active = false
LocalPlayer.Idled:Connect(function() if AFK_Active then VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame) task.wait(1) VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame) end end)
createToggle("Treo Máy (Anti-AFK)", function(state) AFK_Active = state end)

-- 6. Anti Kick
local AntiKick_Active = false
local oldKick
oldKick = hookfunction(LocalPlayer.Kick, function(self, reason) if AntiKick_Active then warn("Chặn kick: " .. tostring(reason)) return nil end return oldKick(self, reason) end)
createToggle("Chống Kick", function(state) AntiKick_Active = state end)

-- 7. Shift Lock Mobile
if IsMobile then
    local ShiftLock_Active = false
    createToggle("Khóa Tâm (Mobile)", function(state) ShiftLock_Active = state if not state then UserInputService.MouseBehavior = Enum.MouseBehavior.Default end end)
    RunService.RenderStepped:Connect(function()
        if ShiftLock_Active and IsMobile and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            local HRP = LocalPlayer.Character.HumanoidRootPart
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z))
        end
    end)
end

-- 8. NÚT MỜI BẠN BÈ (Nổi bật màu xanh lá)
createButton("✉️ Mời Bạn Bè", Color3.fromRGB(35, 140, 75), function()
    pcall(function() SocialService:PromptGameInvite(LocalPlayer) end)
end)

-- 9. Siêu Nhảy (Dạng thanh kéo tùy chỉnh lực nhảy)
local JumpPower = 50 -- Lực nhảy mặc định
local function updateJumpPower(val)
    JumpPower = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end

-- Thêm vào Grid
createSlider("Lực Nhảy", 50, 300, JumpPower, function(val)
    updateJumpPower(val)
end)

-- Đảm bảo lực nhảy giữ nguyên khi hồi sinh
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    updateJumpPower(JumpPower)
end)

-- --- 10. THÊM TÍNH NĂNG SIÊU TỐC ĐỘ (SPEED) ---
local Speed_Val = 16 -- Tốc độ mặc định của Roblox là 16
local Speed_Active = false

-- Hàm cập nhật tốc độ liên tục
RunService.RenderStepped:Connect(function()
    if Speed_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Speed_Val
    end
end)

-- Tạo nút bật/tắt Speed
createToggle("Siêu Tốc Độ", function(state)
    Speed_Active = state
    if not state then 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 
        end
    end
end)

-- Tạo thanh trượt để chỉnh độ nhanh (Kéo từ 16 đến 100)
createSlider("Chỉnh Speed", 16, 100, Speed_Val, function(val)
    Speed_Val = val
end)

-- --- 11. THÊM TÍNH NĂNG THEO DÕI CHUYÊN NGHIỆP ---
local SpectateFrame = Instance.new("Frame", MainFrame)
SpectateFrame.Size = UDim2.new(1, -20, 0, 80)
SpectateFrame.Position = UDim2.new(0, 10, 0, 85)
SpectateFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
SpectateFrame.Visible = false
createCorner(SpectateFrame, 8)

local SpecAvatar = Instance.new("ImageLabel", SpectateFrame)
SpecAvatar.Size = UDim2.new(0, 60, 0, 60)
SpecAvatar.Position = UDim2.new(0, 10, 0, 10)
SpecAvatar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
createCorner(SpecAvatar, 30)

local SpecName = Instance.new("TextLabel", SpectateFrame)
SpecName.Size = UDim2.new(1, -150, 0, 30)
SpecName.Position = UDim2.new(0, 80, 0, 5)
SpecName.BackgroundTransparency = 1
SpecName.TextColor3 = Color3.new(1, 1, 1)
SpecName.Font = Enum.Font.GothamBold

local curSpecIndex = 1
local playersList = {}

local function updateSpec()
    playersList = Players:GetPlayers()
    local target = playersList[curSpecIndex]
    if target and target ~= LocalPlayer then
        SpecName.Text = target.Name
        SpecAvatar.Image = Players:GetUserThumbnailAsync(target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        Camera.CameraSubject = target.Character:FindFirstChild("Humanoid")
    end
end

-- Nút <
local BtnBack = Instance.new("TextButton", SpectateFrame)
BtnBack.Size = UDim2.new(0, 30, 0, 30)
BtnBack.Position = UDim2.new(0, 80, 0, 40)
BtnBack.Text = "<"
BtnBack.MouseButton1Click:Connect(function()
    curSpecIndex = math.max(1, curSpecIndex - 1)
    updateSpec()
end)

-- Nút >
local BtnNext = Instance.new("TextButton", SpectateFrame)
BtnNext.Size = UDim2.new(0, 30, 0, 30)
BtnNext.Position = UDim2.new(0, 120, 0, 40)
BtnNext.Text = ">"
BtnNext.MouseButton1Click:Connect(function()
    curSpecIndex = math.min(#playersList, curSpecIndex + 1)
    updateSpec()
end)

createToggle("Chế Độ Theo Dõi", function(state)
    SpectateFrame.Visible = state
    if state then
        updateSpec()
    else
        Camera.CameraSubject = LocalPlayer.Character:FindFirstChild("Humanoid")
    end
end)

-- --- 12. THÊM TÍNH NĂNG CHẾ ĐỘ AI (TỰ ĐỘNG DI CHUYỂN) ---
local AI_Active = false

RunService.RenderStepped:Connect(function()
    if AI_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        local Humanoid = LocalPlayer.Character.Humanoid
        
        -- Tìm người chơi gần nhất
        local nearestPlayer = nil
        local shortestDistance = 50 -- Khoảng cách AI nhận diện
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (p.Character.HumanoidRootPart.Position - HRP.Position).Magnitude
                if distance < shortestDistance then
                    nearestPlayer = p
                    shortestDistance = distance
                end
            end
        end
        
        -- AI di chuyển đến mục tiêu
        if nearestPlayer then
            Humanoid:MoveTo(nearestPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

-- Tạo nút bấm bật/tắt AI
createToggle("Chế Độ AI (Bot)", function(state)
    AI_Active = state
end)

-- --- 13. THÊM NÚT SAO CHÉP LINK GAME ---
createButton("🔗 Sao chép Link Game", Color3.fromRGB(80, 50, 150), function()
    local GameLink = "https://www.roblox.com/games/" .. game.PlaceId
    if setclipboard then
        setclipboard(GameLink)
        -- Hiệu ứng đổi tên nút tạm thời để báo thành công
        local oldText = "🔗 Sao chép Link Game"
        -- Ở đây mình giả định bạn đang dùng hàm createButton
        -- Nếu bạn muốn đổi text, bạn cần truy cập trực tiếp vào TextLabel của nút
        print("Đã copy link: " .. GameLink)
    end
end)

-- --- 14. THÊM TÍNH NĂNG XOAY NHÂN VẬT (SPIN) ---
local Spin_Active = false
local SpinSpeed = 50 -- Bạn có thể chỉnh tốc độ xoay ở đây

RunService.RenderStepped:Connect(function()
    if Spin_Active and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        -- Xoay nhân vật bằng cách thay đổi CFrame mỗi khung hình
        HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
    end
end)

-- Tạo nút bật/tắt xoay
createToggle("Xoay Tròn (Spin)", function(state)
    Spin_Active = state
end)

-- --- 15. THÊM TÍNH NĂNG GHOST HIT ---
local GhostHit_Active = false

-- Logic: Mở rộng phạm vi chạm của vũ khí (thường là Tool)
RunService.RenderStepped:Connect(function()
    if GhostHit_Active and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            -- Thay đổi kích thước Handle để tăng tầm đánh ảo
            tool.Handle.Size = Vector3.new(20, 20, 20)
            tool.Handle.Transparency = 1 -- Làm tàng hình phần đánh
        end
    end
end)

-- Tạo nút bật/tắt
createToggle("Ghost Hit", function(state)
    GhostHit_Active = state
    if not state and LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool.Handle.Size = Vector3.new(1, 1, 1) -- Trả về cũ
            tool.Handle.Transparency = 0
        end
    end
end)

-- --- TÍNH NĂNG AUTO OBBY ---
local AutoObby_Active = false

local function getNextCheckpoint()
    -- Tìm tất cả các phần tử có tên là "Checkpoint" hoặc chứa từ khóa trong Workspace
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("finish")) and obj:IsA("BasePart") then
            return obj.Position
        end
    end
    return nil
end

createToggle("Auto Obby (Tự chơi)", function(state)
    AutoObby_Active = state
    while AutoObby_Active and task.wait(0.5) do
        local target = getNextCheckpoint()
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
        end
    end
end)

-- --- AUTO FARM/AUTO ATTACK ---
local AutoAttack_Active = false

createToggle("Tự Đánh Người", function(state)
    AutoAttack_Active = state
    while AutoAttack_Active do
        task.wait(0.3) -- Tốc độ đánh
        local closestPlayer = nil
        local maxDist = 50 -- Khoảng cách tối đa để đánh

        -- Tìm người chơi gần nhất
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < maxDist then
                    closestPlayer = p.Character
                    maxDist = dist
                end
            end
        end

        -- Tự trang bị kiếm và đánh
        if closestPlayer then
            local myTool = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if myTool then
                myTool.Parent = LocalPlayer.Character
                myTool:Activate()
                -- Hướng mặt về phía đối thủ
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, closestPlayer.HumanoidRootPart.Position)
            end
        end
    end
end)

-- --- Nút Đóng GUI ở dưới cùng ---
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(1, -20, 0, math.floor(35 * ScaleFactor))
CloseBtn.Position = UDim2.new(0, 10, 1, math.floor(-45 * ScaleFactor))
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = math.floor(12 * ScaleFactor)
CloseBtn.Text = "Ẩn Bảng Menu"
createCorner(CloseBtn, 8)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)
-- --- SERVER HOPPER (TỰ CHẠY LẠI SCRIPT KHI SANG SERVER MỚI) ---
local function serverHop()
    -- Lưu script của bạn lại để nó tự thực thi khi qua server mới
    if syn and syn.queue_on_teleport then
        syn.queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))()]])
    elseif queue_on_teleport then
        queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/3hbin/Gemini-Hub/refs/heads/main/GeminiHub.lua"))()]])
    end

    -- Tìm server mới
    local HttpService = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
    
    local response = game:HttpGet(api)
    local data = HttpService:JSONDecode(response)
    
    for _, v in pairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
            break
        end
    end
end

createToggle("Server Hopper", function(state)
    if state then
        serverHop()
    end
end)
