--[[
    Dandy's World - Ultimate Full Script v5.0
    Обновлён с учётом актуальных скриптов 2026 года
    Добавлено: Highlight ESP, Item Aura, FullBright, улучшенный автофарм
]]

-- ================== НАСТРОЙКИ ==================
local Settings = {
    PlayerESP = true,
    TwistedESP = true,
    ItemESP = true,
    AutoSkillCheck = true,
    AutoFarm = false,
    AutoCollect = false,        -- Авто-сбор предметов (Item Aura)
    NoclipMode = "Safe",
    RepelDome = false,
    RepelRadius = 15,
    FullBright = false,
    SpeedBoost = false,
    SpeedValue = 25,
    JumpBoost = false,
    JumpValue = 50,
    InfiniteJump = false,
    AntiBan = true,
    UIHidden = false
}

-- ================== GUI ==================
local function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "DandyUI_" .. tostring(math.random(10000, 99999))
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    gui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer.PlayerGui

    local mf = Instance.new("Frame")
    mf.Size = UDim2.new(0, 250, 0, 520)
    mf.Position = UDim2.new(0, 10, 0, 50)
    mf.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mf.BorderSizePixel = 0
    mf.Active = true
    mf.Draggable = true
    mf.ClipsDescendants = true
    Instance.new("UICorner", mf).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "Dandy World v5.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mf

    local function createToggle(name, state, callback, yOffset)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 25)
        f.Position = UDim2.new(0, 10, 0, 40 + yOffset)
        f.BackgroundTransparency = 1
        f.Parent = mf

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.7, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(200, 200, 200)
        l.Font = Enum.Font.Gotham
        l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 40, 0, 20)
        b.Position = UDim2.new(1, -45, 0.5, -10)
        b.BackgroundColor3 = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
        b.Text = state and "ON" or "OFF"
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.Parent = f

        local cur = state
        b.MouseButton1Click:Connect(function()
            cur = not cur
            b.BackgroundColor3 = cur and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0)
            b.Text = cur and "ON" or "OFF"
            if callback then callback(cur) end
        end)
        return function(ns) if ns ~= nil then cur = ns; b.BackgroundColor3 = cur and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(170, 0, 0); b.Text = cur and "ON" or "OFF" end end
    end

    local function createSlider(name, min, max, default, callback, yOffset)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -20, 0, 30)
        f.Position = UDim2.new(0, 10, 0, 40 + yOffset)
        f.BackgroundTransparency = 1
        f.Parent = mf

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = name
        l.TextColor3 = Color3.fromRGB(200, 200, 200)
        l.Font = Enum.Font.Gotham
        l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(0.2, 0, 1, 0)
        val.Position = UDim2.new(0.8, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = tostring(default)
        val.TextColor3 = Color3.fromRGB(255, 255, 255)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 14
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.Parent = f

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(0.7, 0, 0, 4)
        slider.Position = UDim2.new(0, 0, 0.7, 0)
        slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        slider.BorderSizePixel = 0
        Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 2)
        slider.Parent = f

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 2)
        fill.Parent = slider

        local dragging = false
        local function update(input)
            local pos = input.Position.X
            local size = slider.AbsoluteSize.X
            local newVal = math.clamp((pos - slider.AbsolutePosition.X) / size, 0, 1)
            local value = math.round(min + newVal * (max - min))
            fill.Size = UDim2.new(newVal, 0, 1, 0)
            val.Text = tostring(value)
            callback(value)
        end

        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                update(input)
            end
        end)
        slider.InputEnded:Connect(function()
            dragging = false
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                update(input)
            end
        end)
        return f
    end

    local yOff = 0
    createToggle("ESP Игроков", Settings.PlayerESP, function(v) Settings.PlayerESP = v end, yOff); yOff = yOff + 25
    createToggle("ESP Твистедов", Settings.TwistedESP, function(v) Settings.TwistedESP = v end, yOff); yOff = yOff + 25
    createToggle("ESP Предметов", Settings.ItemESP, function(v) Settings.ItemESP = v end, yOff); yOff = yOff + 25
    createToggle("Авто-скиллчек", Settings.AutoSkillCheck, function(v) Settings.AutoSkillCheck = v end, yOff); yOff = yOff + 25
    createToggle("Автофарм", Settings.AutoFarm, function(v) Settings.AutoFarm = v end, yOff); yOff = yOff + 25
    createToggle("Авто-сбор", Settings.AutoCollect, function(v) Settings.AutoCollect = v end, yOff); yOff = yOff + 25
    createToggle("Полная яркость", Settings.FullBright, function(v) Settings.FullBright = v end, yOff); yOff = yOff + 25
    createToggle("Отталк. купол", Settings.RepelDome, function(v) Settings.RepelDome = v end, yOff); yOff = yOff + 25
    createToggle("Беск. прыжок", Settings.InfiniteJump, function(v) Settings.InfiniteJump = v end, yOff); yOff = yOff + 25

    -- Ноклип
    local nf = Instance.new("Frame")
    nf.Size = UDim2.new(1, -20, 0, 25)
    nf.Position = UDim2.new(0, 10, 0, 40 + yOff)
    nf.BackgroundTransparency = 1
    nf.Parent = mf
    yOff = yOff + 25
    local nl = Instance.new("TextLabel")
    nl.Size = UDim2.new(0.6, 0, 1, 0)
    nl.BackgroundTransparency = 1
    nl.Text = "Ноклип"
    nl.TextColor3 = Color3.fromRGB(200, 200, 200)
    nl.Font = Enum.Font.Gotham
    nl.TextSize = 14
    nl.TextXAlignment = Enum.TextXAlignment.Left
    nl.Parent = nf
    local modes = {"Off", "Simple", "Safe"}
    local modeIdx = 3
    local nb = Instance.new("TextButton")
    nb.Size = UDim2.new(0, 55, 0, 20)
    nb.Position = UDim2.new(1, -60, 0.5, -10)
    nb.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
    nb.Text = Settings.NoclipMode
    nb.TextColor3 = Color3.fromRGB(255, 255, 255)
    nb.Font = Enum.Font.GothamBold
    nb.TextSize = 12
    nb.BorderSizePixel = 0
    Instance.new("UICorner", nb).CornerRadius = UDim.new(0, 6)
    nb.Parent = nf
    nb.MouseButton1Click:Connect(function()
        modeIdx = modeIdx % #modes + 1
        Settings.NoclipMode = modes[modeIdx]
        nb.Text = Settings.NoclipMode
    end)

    -- Слайдеры
    createSlider("Скорость", 0, 100, 16, function(v) Settings.SpeedValue = v; Settings.SpeedBoost = true end, yOff); yOff = yOff + 35
    createSlider("Прыжок", 0, 100, 50, function(v) Settings.JumpValue = v; Settings.JumpBoost = true end, yOff); yOff = yOff + 35

    createToggle("Анти-Бан", Settings.AntiBan, function(v) Settings.AntiBan = v end, yOff); yOff = yOff + 25

    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
    closeBtn.Parent = mf

    local hiddenFrame = Instance.new("Frame")
    hiddenFrame.Size = UDim2.new(0, 30, 0, 30)
    hiddenFrame.Position = UDim2.new(0, 10, 0, 10)
    hiddenFrame.BackgroundTransparency = 1
    hiddenFrame.Visible = false
    hiddenFrame.Parent = gui
    local showBtn = Instance.new("TextButton")
    showBtn.Size = UDim2.new(0, 30, 0, 30)
    showBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    showBtn.Text = "≡"
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.Font = Enum.Font.GothamBold
    showBtn.TextSize = 20
    showBtn.BorderSizePixel = 0
    Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0, 6)
    showBtn.Parent = hiddenFrame

    closeBtn.MouseButton1Click:Connect(function()
        mf.Visible = false; hiddenFrame.Visible = true; Settings.UIHidden = true
    end)
    showBtn.MouseButton1Click:Connect(function()
        mf.Visible = true; hiddenFrame.Visible = false; Settings.UIHidden = false
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input, proc)
        if proc then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            if Settings.UIHidden then
                mf.Visible = true; hiddenFrame.Visible = false; Settings.UIHidden = false
            else
                mf.Visible = false; hiddenFrame.Visible = true; Settings.UIHidden = true
            end
        end
    end)

    if Settings.AntiBan then
        task.spawn(function()
            while true do
                task.wait(5)
                if not gui or not gui.Parent then createUI(); break end
            end
        end)
    end
end

-- ================== ESP через Highlight ==================
local function setupHighlightESP()
    local player = game.Players.LocalPlayer
    local function createESP(color, name)
        local h = Instance.new("Highlight")
        h.Name = name
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 1
        return h
    end

    local espPlayers = createESP(Color3.fromRGB(0, 255, 0), "PlayerESP")
    local espTwisted = createESP(Color3.fromRGB(255, 0, 0), "TwistedESP")
    local espItems = createESP(Color3.fromRGB(0, 255, 255), "ItemESP")

    game:GetService("RunService").Heartbeat:Connect(function()
        -- Очистка старых ESP
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") and v.Name:match("ESP$") then
                v:Destroy()
            end
        end

        -- ESP игроков
        if Settings.PlayerESP then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local clone = espPlayers:Clone()
                    clone.Adornee = p.Character
                    clone.Parent = p.Character
                end
            end
        end

        -- ESP твистедов
        if Settings.TwistedESP then
            local twisted = workspace:FindFirstChild("Twisted") or workspace:FindFirstChild("Enemies")
            if twisted then
                for _, t in ipairs(twisted:GetChildren()) do
                    if t:IsA("Model") or t:IsA("BasePart") then
                        local clone = espTwisted:Clone()
                        clone.Adornee = t
                        clone.Parent = t
                    end
                end
            end
        end

        -- ESP предметов
        if Settings.ItemESP then
            local items = workspace:FindFirstChild("Items") or workspace:FindFirstChild("Tapes")
            if items then
                for _, item in ipairs(items:GetChildren()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        local clone = espItems:Clone()
                        clone.Adornee = item
                        clone.Parent = item
                    end
                end
            end
        end
    end)
end

-- ================== АВТО-СКИЛЛЧЕК ==================
task.spawn(function()
    while task.wait(0.05) do
        if not Settings.AutoSkillCheck then continue end
        local gui = game.Players.LocalPlayer.PlayerGui
        if gui then
            local sc = gui:FindFirstChild("SkillCheck", true) or gui:FindFirstChild("MiniGame", true)
            if sc and sc.Visible then
                local btn = sc:FindFirstChild("Button") or sc:FindFirstChild("Click") or sc:FindFirstChild("SkillCheckButton")
                if btn and btn:IsA("TextButton") then
                    pcall(function() btn:FireServer() end)
                    pcall(function() btn:Click() end)
                end
                -- Для кругового скиллчека
                local circle = sc:FindFirstChild("Circle") or sc:FindFirstChild("SkillCheckCircle")
                if circle then
                    pcall(function() 
                        local rs = game:GetService("ReplicatedStorage")
                        local ev = rs:FindFirstChild("SkillCheckPass") or rs:FindFirstChild("PassSkillCheck")
                        if ev then ev:FireServer() end
                    end)
                end
            end
        end
    end
end)

-- ================== АВТОФАРМ + ТЕЛЕПОРТ К ЛИФТУ ==================
local farm = { active = false, step = 0, genIdx = 1 }

local function getGenerators()
    local gens = {}
    local folder = workspace:FindFirstChild("Generators") or workspace
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj.Name:lower():match("generator") or obj.Name:lower():match("gen") then
            if obj:IsA("BasePart") or obj:IsA("Model") then
                table.insert(gens, obj)
            end
        end
    end
    return gens
end

local function getElevator()
    return workspace:FindFirstChild("Elevator", true) or workspace:FindFirstChild("Lift", true)
end

local function teleportTo(pos)
    local p = game.Players.LocalPlayer
    if p and p.Character then
        local r = p.Character.PrimaryPart
        if r then r.CFrame = CFrame.new(pos) end
    end
end

local function interactWith(thing)
    local cd = thing:FindFirstChild("ClickDetector") or thing:FindFirstChild("ProximityPrompt")
    if cd then
        if cd:IsA("ClickDetector") then
            cd:FireClick(game.Players.LocalPlayer)
        elseif cd:IsA("ProximityPrompt") then
            cd:Hold()
            task.wait(0.5)
            cd:Release()
        end
    end
end

local function isTwistedNearby(pos, radius)
    radius = radius or 20
    local twisted = workspace:FindFirstChild("Twisted") or workspace:FindFirstChild("Enemies")
    if twisted then
        for _, t in ipairs(twisted:GetChildren()) do
            local part = t.PrimaryPart or t
            if part and part:IsA("BasePart") then
                if (part.Position - pos).Magnitude < radius then
                    return true
                end
            end
        end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoFarm and not farm.active then
            farm.active = true
            local gens = getGenerators()
            if #gens > 0 then
                farm.genIdx = 1
                farm.step = 0
                while farm.active do
                    local p = game.Players.LocalPlayer
                    if not p or not p.Character then task.wait(1) continue end
                    local root = p.Character.PrimaryPart
                    if not root then task.wait(1) continue end
                    local gen = gens[farm.genIdx]
                    if not gen then
                        -- Все генераторы собраны → телепорт к лифту
                        local el = getElevator()
                        if el then
                            local elPos = el.PrimaryPart and el.PrimaryPart.Position or el.Position
                            -- Проверка: есть ли твистед рядом с лифтом
                            if isTwistedNearby(elPos, 25) then
                                task.wait(2) -- ждём, пока твистед уйдёт
                            end
                            if (root.Position - elPos).Magnitude > 5 then
                                teleportTo(elPos)
                            end
                            task.wait(0.5)
                            interactWith(el)
                        end
                        farm.active = false
                        break
                    end
                    local genPos = gen.PrimaryPart and gen.PrimaryPart.Position or gen.Position
                    if farm.step == 0 then
                        if (root.Position - genPos).Magnitude > 5 then
                            teleportTo(genPos + Vector3.new(0, 2, 0))
                        else
                            farm.step = 1
                        end
                    elseif farm.step == 1 then
                        interactWith(gen)
                        task.wait(1)
                        farm.step = 2
                    elseif farm.step == 2 then
                        teleportTo(genPos + Vector3.new(0, 30, 0))
                        task.wait(1)
                        farm.step = 3
                    elseif farm.step == 3 then
                        teleportTo(genPos + Vector3.new(0, 2, 0))
                        task.wait(0.5)
                        farm.step = 4
                    elseif farm.step == 4 then
                        farm.genIdx = farm.genIdx + 1
                        if farm.genIdx <= #gens then farm.step = 0 else farm.step = 0 end
                    end
                    task.wait(0.5)
                end
            else
                farm.active = false
            end
        elseif not Settings.AutoFarm and farm.active then
            farm.active = false
        end
    end
end)

-- ================== АВТО-СБОР ПРЕДМЕТОВ (ITEM AURA) ==================
task.spawn(function()
    while task.wait(0.3) do
        if not Settings.AutoCollect then continue end
        local p = game.Players.LocalPlayer
        if not p or not p.Character then continue end
        local root = p.Character.PrimaryPart
        if not root then continue end
        local items = workspace:FindFirstChild("Items") or workspace:FindFirstChild("Tapes")
        if items then
            for _, item in ipairs(items:GetChildren()) do
                if item:IsA("BasePart") or item.PrimaryPart then
                    local ipos = item.PrimaryPart and item.PrimaryPart.Position or item.Position
                    if (root.Position - ipos).Magnitude < 20 then
                        root.CFrame = CFrame.new(ipos + Vector3.new(0, 2, 0))
                        task.wait(0.1)
                        interactWith(item)
                        break
                    end
                end
            end
        end
    end
end)

-- ================== НОКЛИП ==================
local noclipConn = nil
local function setupNoclip()
    if noclipConn then noclipConn:Disconnect() end
    if Settings.NoclipMode == "Off" then return end
    noclipConn = game:GetService("RunService").Stepped:Connect(function()
        if Settings.NoclipMode == "Off" then return end
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
        if Settings.NoclipMode == "Safe" then task.wait(0.1) end
    end)
end
setupNoclip()

task.spawn(function()
    local last = Settings.NoclipMode
    while task.wait(0.5) do
        if Settings.NoclipMode ~= last then last = Settings.NoclipMode; setupNoclip() end
    end
end)

-- ================== ОТТАЛКИВАЮЩИЙ КУПОЛ ==================
task.spawn(function()
    while task.wait(0.1) do
        if not Settings.RepelDome then continue end
        local p = game.Players.LocalPlayer
        if not p or not p.Character then continue end
        local root = p.Character.PrimaryPart
        if not root then continue end
        local pos = root.Position
        local twisted = workspace:FindFirstChild("Twisted") or workspace:FindFirstChild("Enemies")
        if twisted then
            for _, t in ipairs(twisted:GetChildren()) do
                local part = t.PrimaryPart or t
                if part and part:IsA("BasePart") then
                    local dist = (part.Position - pos).Magnitude
                    if dist < Settings.RepelRadius and dist > 0.1 then
                        local dir = (part.Position - pos).Unit
                        part.CFrame = CFrame.new(part.Position + dir * 2)
                    end
                end
            end
        end
    end
end)

-- ================== FULLBRIGHT ==================
task.spawn(function()
    while task.wait(0.5) do
        local lighting = game:GetService("Lighting")
        if Settings.FullBright then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            lighting.Brightness = 0.5
            lighting.ClockTime = 0
            lighting.FogEnd = 1000
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end
    end
end)

-- ================== СКОРОСТЬ И ПРЫЖОК ==================
task.spawn(function()
    while task.wait(0.1) do
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if Settings.SpeedBoost then
                    hum.WalkSpeed = Settings.SpeedValue
                else
                    hum.WalkSpeed = 16
                end
                if Settings.JumpBoost then
                    hum.JumpPower = Settings.JumpValue
                else
                    hum.JumpPower = 50
                end
            end
        end
    end
end)

-- ================== БЕСКОНЕЧНЫЙ ПРЫЖОК ==================
task.spawn(function()
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if Settings.InfiniteJump then
            local char = game.Players.LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end
    end)
end)

-- ================== ЗАПУСК ==================
createUI()
setupHighlightESP()
print("Dandy World v5.0 loaded! Press Right Shift to hide GUI.")
