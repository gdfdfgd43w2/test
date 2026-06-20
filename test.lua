-- =====================================================
-- DANDY'S WORLD ULTIMATE SCRIPT v12.0 (Mobile)
-- Все функции в одном скрипте. Нажми ☰ для меню.
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- ====== НАСТРОЙКИ ======
local Settings = {
    ESP_Players = false,
    ESP_Twisted = false,
    ESP_Generators = false,
    ESP_Items = false,
    ESP_Elevator = false,
    AutoSkillCheck = false,
    AutoFarm = false,
    AutoCollect = false,
    AutoCollectCapsules = false,
    AutoGTE = false,
    Noclip = false,
    Fly = false,
    InfiniteJump = false,
    FullBright = false,
    AntiTwisted = false,
    Speed = 16,
    Jump = 50,
    FlySpeed = 50,
    AntiTwistedRadius = 15,
}

-- ====== СОЗДАНИЕ GUI (МЕНЮ) ======
local gui = Instance.new("ScreenGui")
gui.Name = "DandyUltimate"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 480)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
title.Text = "Dandy World Ultimate"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.Parent = title
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = scroll

local function createToggle(text, state, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.92, 0, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    f.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 26)
    btn.Position = UDim2.new(1, -55, 0.5, -13)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(180, 60, 60)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = f

    local cur = state
    btn.MouseButton1Click:Connect(function()
        cur = not cur
        btn.BackgroundColor3 = cur and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(180, 60, 60)
        btn.Text = cur and "ON" or "OFF"
        callback(cur)
    end)
end

local function createSlider(text, min, max, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.92, 0, 0, 45)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    f.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0.4, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = f

    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0.2, 0, 0.4, 0)
    value.Position = UDim2.new(0.8, 0, 0, 0)
    value.BackgroundTransparency = 1
    value.Text = tostring(default)
    value.TextColor3 = Color3.fromRGB(255, 255, 255)
    value.Font = Enum.Font.GothamBold
    value.TextSize = 15
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Parent = f

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.8, 0, 0, 6)
    slider.Position = UDim2.new(0, 10, 0, 32)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    slider.BorderSizePixel = 0
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 3)
    slider.Parent = f

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
    fill.Parent = slider

    local dragging = false
    local function update(input)
        local pos = input.Position.X
        local size = slider.AbsoluteSize.X
        if size == 0 then return end
        local newVal = math.clamp((pos - slider.AbsolutePosition.X) / size, 0, 1)
        local val = math.round(min + newVal * (max - min))
        fill.Size = UDim2.new(newVal, 0, 1, 0)
        value.Text = tostring(val)
        callback(val)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    slider.InputEnded:Connect(function() dragging = false end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- ====== СОЗДАНИЕ КНОПОК МЕНЮ ======
createToggle("ESP Игроков", Settings.ESP_Players, function(v) Settings.ESP_Players = v end)
createToggle("ESP Твистедов", Settings.ESP_Twisted, function(v) Settings.ESP_Twisted = v end)
createToggle("ESP Генераторов", Settings.ESP_Generators, function(v) Settings.ESP_Generators = v end)
createToggle("ESP Предметов", Settings.ESP_Items, function(v) Settings.ESP_Items = v end)
createToggle("ESP Лифта", Settings.ESP_Elevator, function(v) Settings.ESP_Elevator = v end)
createToggle("Авто-скиллчек", Settings.AutoSkillCheck, function(v) Settings.AutoSkillCheck = v end)
createToggle("Автофарм (генераторы)", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
createToggle("Авто-сбор предметов", Settings.AutoCollect, function(v) Settings.AutoCollect = v end)
createToggle("Авто-сбор капсул", Settings.AutoCollectCapsules, function(v) Settings.AutoCollectCapsules = v end)
createToggle("Авто-уход в лифт (GTE)", Settings.AutoGTE, function(v) Settings.AutoGTE = v end)
createToggle("Ноклип", Settings.Noclip, function(v) Settings.Noclip = v end)
createToggle("Полёт", Settings.Fly, function(v) Settings.Fly = v end)
createToggle("Бесконечный прыжок", Settings.InfiniteJump, function(v) Settings.InfiniteJump = v end)
createToggle("Полная яркость", Settings.FullBright, function(v) Settings.FullBright = v end)
createToggle("Анти-твистед (уклонение)", Settings.AntiTwisted, function(v) Settings.AntiTwisted = v end)
createSlider("Скорость", 0, 100, 16, function(v) Settings.Speed = v end)
createSlider("Прыжок", 0, 100, 50, function(v) Settings.Jump = v end)
createSlider("Скорость полёта", 10, 200, 50, function(v) Settings.FlySpeed = v end)
createSlider("Радиус анти-твистеда", 5, 30, 15, function(v) Settings.AntiTwistedRadius = v end)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
end)

-- ====== БУРГЕР-КНОПКА ======
local burger = Instance.new("TextButton")
burger.Size = UDim2.new(0, 55, 0, 55)
burger.Position = UDim2.new(0, 10, 0, 10)
burger.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
burger.Text = "☰"
burger.TextColor3 = Color3.fromRGB(255, 255, 255)
burger.Font = Enum.Font.GothamBold
burger.TextSize = 30
burger.BorderSizePixel = 0
burger.BackgroundTransparency = 0.2
Instance.new("UICorner", burger).CornerRadius = UDim.new(0, 12)
burger.Parent = gui
burger.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- ====== 1. ESP (ПОДСВЕТКА) ======
local activeHighlights = {}
local function applyESP(obj, enabled, color)
    if not obj or not obj.Parent then return end
    local h = activeHighlights[obj]
    if enabled then
        if not h then
            h = Instance.new("Highlight")
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            activeHighlights[obj] = h
        end
        h.FillColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 1
        h.Adornee = obj
        h.Parent = obj
    else
        if h then h:Destroy(); activeHighlights[obj] = nil end
    end
end

task.spawn(function()
    while task.wait(0.3) do
        local player = LocalPlayer
        if not player or not player.Character then continue end
        local myPos = player.Character:FindFirstChild("HumanoidRootPart")
        if not myPos then continue end
        local fromPos = myPos.Position

        for obj, h in pairs(activeHighlights) do
            if not obj or not obj.Parent then
                h:Destroy()
                activeHighlights[obj] = nil
            end
        end

        if Settings.ESP_Players then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if root and (root.Position - fromPos).Magnitude < 150 then
                        applyESP(plr.Character, true, Color3.fromRGB(0,255,0))
                    else
                        applyESP(plr.Character, false)
                    end
                end
            end
        end

        if Settings.ESP_Twisted then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj.Name:lower():match("twisted") or obj.Name:lower():match("enemy")) then
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                    if root and (root.Position - fromPos).Magnitude < 150 then
                        applyESP(obj, true, Color3.fromRGB(255,0,0))
                    else
                        applyESP(obj, false)
                    end
                end
            end
        end

        if Settings.ESP_Generators then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:lower():match("generator") then
                    local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                    if root and (root.Position - fromPos).Magnitude < 150 then
                        applyESP(obj, true, Color3.fromRGB(255,255,0))
                    else
                        applyESP(obj, false)
                    end
                end
            end
        end

        if Settings.ESP_Items then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():match("item") then
                    if (obj.Position - fromPos).Magnitude < 150 then
                        applyESP(obj, true, Color3.fromRGB(0,255,255))
                    else
                        applyESP(obj, false)
                    end
                end
            end
        end

        if Settings.ESP_Elevator then
            local el = workspace:FindFirstChild("Elevator", true) or workspace:FindFirstChild("Lift", true)
            if el then
                local root = el:FindFirstChild("HumanoidRootPart") or el.PrimaryPart
                if root and (root.Position - fromPos).Magnitude < 150 then
                    applyESP(el, true, Color3.fromRGB(0,200,200))
                else
                    applyESP(el, false)
                end
            end
        end
    end
end)

-- ====== 2. АВТО-СКИЛЛЧЕК (ОТСЛЕЖИВАНИЕ НОВЫХ ЭЛЕМЕНТОВ) ======[reference:3]
local oldVisible = {}
local function getVisible()
    local list = {}
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return list end
    for _, v in ipairs(gui:GetDescendants()) do
        if v.Visible and (v:IsA("Frame") or v:IsA("ImageLabel") or v:IsA("TextButton")) then
            table.insert(list, v)
        end
    end
    return list
end

task.spawn(function()
    while task.wait(0.1) do
        if not Settings.AutoSkillCheck then
            oldVisible = getVisible()
            continue
        end
        local current = getVisible()
        for _, obj in ipairs(current) do
            local found = false
            for _, old in ipairs(oldVisible) do
                if obj == old then found = true break end
            end
            if not found then
                local x = obj.AbsolutePosition.X + obj.AbsoluteSize.X / 2
                local y = obj.AbsolutePosition.Y + obj.AbsoluteSize.Y / 2
                if x > 0 and y > 0 then
                    pcall(function()
                        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                        task.wait(0.02)
                        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
                    end)
                end
                break
            end
        end
        oldVisible = current
    end
end)

-- ====== 3. АВТОФАРМ ======[reference:4][reference:5]
local farm = { active = false, idx = 1, step = 0 }

local function getGenerators()
    local gens = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():match("generator") then
            local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if root then
                local isBroken = true
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("BasePart") and child.Material == Enum.Material.Neon then
                        isBroken = false
                        break
                    end
                end
                if isBroken then table.insert(gens, obj) end
            end
        end
    end
    return gens
end

local function teleportTo(pos)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(pos) end
end

local function interactWith(obj)
    local cd = obj:FindFirstChild("ClickDetector") or obj:FindFirstChild("ProximityPrompt")
    if cd then
        if cd:IsA("ClickDetector") then cd:FireClick(LocalPlayer)
        elseif cd:IsA("ProximityPrompt") then cd:Hold(); task.wait(0.3); cd:Release() end
    end
end

local function isTwistedNear(pos, radius)
    radius = radius or 20
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():match("twisted") or obj.Name:lower():match("enemy")) then
            local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if root and (root.Position - pos).Magnitude < radius then
                return true
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(1)
        if not Settings.AutoFarm then
            farm.active = false
            continue
        end
        if not farm.active then
            local gens = getGenerators()
            if #gens > 0 then
                farm.active = true
                farm.idx = 1
                farm.step = 0
            else
                farm.active = false
            end
            continue
        end
        local gens = getGenerators()
        if #gens == 0 then
            if Settings.AutoGTE then
                local el = workspace:FindFirstChild("Elevator", true) or workspace:FindFirstChild("Lift", true)
                if el then
                    local elPos = el.PrimaryPart and el.PrimaryPart.Position or el:FindFirstChild("HumanoidRootPart") and el:FindFirstChild("HumanoidRootPart").Position
                    if elPos and not isTwistedNear(elPos, 20) then
                        teleportTo(elPos)
                        task.wait(0.5)
                        interactWith(el)
                    end
                end
            end
            farm.active = false
            continue
        end
        local gen = gens[farm.idx]
        if not gen then
            farm.active = false
            continue
        end
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then task.wait(1) continue end
        local genPos = gen:FindFirstChild("HumanoidRootPart") and gen:FindFirstChild("HumanoidRootPart").Position or gen.PrimaryPart and gen.PrimaryPart.Position
        if not genPos then task.wait(1) continue end

        local isDone = true
        for _, child in ipairs(gen:GetDescendants()) do
            if child:IsA("BasePart") and child.Material == Enum.Material.Neon then
                isDone = false
                break
            end
        end
        if isDone then
            farm.idx = farm.idx + 1
            farm.step = 0
            continue
        end

        if farm.step == 0 then
            if (root.Position - genPos).Magnitude > 5 then
                teleportTo(genPos + Vector3.new(0,2,0))
            else
                farm.step = 1
            end
        elseif farm.step == 1 then
            interactWith(gen)
            task.wait(1)
            farm.step = 2
        elseif farm.step == 2 then
            teleportTo(genPos + Vector3.new(0,30,0))
            task.wait(1)
            farm.step = 3
        elseif farm.step == 3 then
            teleportTo(genPos + Vector3.new(0,2,0))
            task.wait(0.5)
            farm.step = 4
        elseif farm.step == 4 then
            farm.idx = farm.idx + 1
            farm.step = 0
        end
        task.wait(0.3)
    end
end)

-- ====== 4. АВТО-СБОР (ПРЕДМЕТЫ, КАПСУЛЫ) ======[reference:6]
task.spawn(function()
    while task.wait(0.3) do
        if not Settings.AutoCollect and not Settings.AutoCollectCapsules then continue end
        local player = LocalPlayer
        if not player or not player.Character then continue end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local fromPos = root.Position

        if Settings.AutoCollect then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():match("item") then
                    if (obj.Position - fromPos).Magnitude < 15 then
                        teleportTo(obj.Position + Vector3.new(0,2,0))
                        task.wait(0.1)
                        interactWith(obj)
                        break
                    end
                end
            end
        end

        if Settings.AutoCollectCapsules then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:lower():match("capsule") then
                    if (obj.Position - fromPos).Magnitude < 15 then
                        teleportTo(obj.Position + Vector3.new(0,2,0))
                        task.wait(0.1)
                        interactWith(obj)
                        break
                    end
                end
            end
        end
    end
end)

-- ====== 5. НОКЛИП ======[reference:7]
task.spawn(function()
    while task.wait(0.05) do
        if Settings.Noclip then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- ====== 6. ПОЛЁТ ======[reference:8]
local fly = { active = false, bodyVelocity = nil, bodyGyro = nil }
task.spawn(function()
    while task.wait(0.1) do
        if Settings.Fly and not fly.active then
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    fly.active = true
                    fly.bodyVelocity = Instance.new("BodyVelocity")
                    fly.bodyVelocity.MaxForce = Vector3.new(100000,100000,100000)
                    fly.bodyVelocity.Parent = root
                    fly.bodyGyro = Instance.new("BodyGyro")
                    fly.bodyGyro.MaxTorque = Vector3.new(100000,100000,100000)
                    fly.bodyGyro.Parent = root
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then hum.PlatformStand = true
                end
            end
        elseif not Settings.Fly and fly.active then
            if fly.bodyVelocity then fly.bodyVelocity:Destroy() end
            if fly.bodyGyro then fly.bodyGyro:Destroy() end
            fly.active = false
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.PlatformStand = false
            end
        end
        if fly.active then
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and fly.bodyVelocity then
                    local moveDir = Vector3.new(0,0,0)
                    local speed = Settings.FlySpeed or 50
                    local camera = workspace.CurrentCamera
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
                    if moveDir.Magnitude > 0 then
                        fly.bodyVelocity.Velocity = moveDir.Unit * speed
                    else
                        fly.bodyVelocity.Velocity = Vector3.new(0,0,0)
                    end
                    fly.bodyGyro.CFrame = CFrame.new(root.Position, root.Position + camera.CFrame.LookVector)
                end
            end
        end
    end
end)

-- ====== 7. БЕСКОНЕЧНЫЙ ПРЫЖОК ======[reference:9]
task.spawn(function()
    while task.wait(0.05) do
        if Settings.InfiniteJump then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end
end)

-- ====== 8. СКОРОСТЬ И ПРЫЖОК ======[reference:10]
task.spawn(function()
    while task.wait(0.1) do
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = Settings.Speed or 16
                hum.JumpPower = Settings.Jump or 50
            end
        end
    end
end)

-- ====== 9. FULLBRIGHT ======[reference:11][reference:12]
task.spawn(function()
    while task.wait(0.5) do
        local lighting = game:GetService("Lighting")
        if Settings.FullBright then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        else
            lighting.Brightness = 0.5
            lighting.ClockTime = 0
            lighting.FogEnd = 1000
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
        end
    end
end)

-- ====== 10. АНТИ-ТВИСТЕД (АВТО-УКЛОНЕНИЕ) ======[reference:13]
task.spawn(function()
    while task.wait(0.2) do
        if not Settings.AntiTwisted then continue end
        local player = LocalPlayer
        if not player or not player.Character then continue end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local fromPos = root.Position
        local radius = Settings.AntiTwistedRadius or 15

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():match("twisted") or obj.Name:lower():match("enemy")) then
                local pos = obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("HumanoidRootPart").Position or obj.PrimaryPart and obj.PrimaryPart.Position
                if pos and (fromPos - pos).Magnitude < radius then
                    local dir = (fromPos - pos).Unit
                    local safePos = fromPos + dir * (radius + 5)
                    teleportTo(safePos + Vector3.new(0,2,0))
                    break
                end
            end
        end
    end
end)

-- ====== ЗАПУСК ======
print("✅ Dandy World Ultimate v12.0 загружен!")
print("🔹 Нажми ☰ в левом углу для открытия меню.")
print("🔹 Все функции включаются через меню.")
