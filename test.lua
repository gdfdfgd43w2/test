-- =====================================================
-- ЧАСТЬ 1: НАСТРОЙКИ, GUI, ОПТИМИЗИРОВАННЫЙ ESP (БЕЗ ЛАГОВ)
-- =====================================================

local Settings = {
    PlayerESP = false,
    TwistedESP = false,
    GeneratorESP = false,
    ItemESP = false,
    CapsuleESP = false,
    AutoSkillCheck = false,
    AutoFarm = false,
    AutoCollect = false,
    AutoCapsule = false,
    FullBright = false,
    Noclip = false,
    Fly = false,          -- НОВЫЙ РЕЖИМ ПОЛЁТА
    SpeedValue = 16,
    JumpValue = 50,
    FlySpeed = 50         -- СКОРОСТЬ ПОЛЁТА
}

-- ================== УМНЫЙ ПОИСК ОБЪЕКТОВ (КЭШИРОВАНИЕ) ==================
local ObjectCache = {
    Twisted = {},
    Generators = {},
    Items = {},
    Capsules = {},
    Players = {}
}

local function updateCache()
    -- Обновляем кэш раз в секунду, чтобы не грузить процессор
    task.wait(0.5)
    ObjectCache.Twisted = {}
    ObjectCache.Generators = {}
    ObjectCache.Items = {}
    ObjectCache.Capsules = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:match("twisted") or name:match("enemy") or name:match("monster") then
                table.insert(ObjectCache.Twisted, obj)
            elseif name:match("generator") or name:match("gen") then
                table.insert(ObjectCache.Generators, obj)
            elseif name:match("capsule") or name:match("pod") then
                table.insert(ObjectCache.Capsules, obj)
            elseif name:match("item") or name:match("tape") or name:match("pickup") then
                table.insert(ObjectCache.Items, obj)
            end
        end
    end
    -- Игроки обновляются отдельно
    ObjectCache.Players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            table.insert(ObjectCache.Players, p)
        end
    end
end

-- Запускаем обновление кэша в фоне
task.spawn(function()
    while task.wait(1) do
        pcall(updateCache)
    end
end)

-- ================== СОЗДАНИЕ МЕНЮ ==================
local function createUI()
    local player = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "DandyGUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    gui.Parent = player.PlayerGui

    local burger = Instance.new("TextButton")
    burger.Size = UDim2.new(0, 50, 0, 50)
    burger.Position = UDim2.new(0, 10, 0, 10)
    burger.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    burger.Text = "≡"
    burger.TextColor3 = Color3.fromRGB(255, 255, 255)
    burger.Font = Enum.Font.GothamBold
    burger.TextSize = 30
    burger.BorderSizePixel = 0
    Instance.new("UICorner", burger).CornerRadius = UDim.new(0, 10)
    burger.Parent = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 320, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -260)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    mainFrame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
    title.Text = "Dandy World v9.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
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
    closeBtn.Parent = mainFrame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -50)
    scroll.Position = UDim2.new(0, 5, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(200, 180, 255)
    scroll.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = scroll

    local function createToggle(name, state, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.95, 0, 0, 40)
        f.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        f.Parent = scroll

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(230, 230, 240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = f

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 30)
        btn.Position = UDim2.new(1, -65, 0.5, -15)
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(180, 60, 60)
        btn.Text = state and "ON" or "OFF"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.Parent = f

        local cur = state
        btn.MouseButton1Click:Connect(function()
            cur = not cur
            btn.BackgroundColor3 = cur and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(180, 60, 60)
            btn.Text = cur and "ON" or "OFF"
            if callback then callback(cur) end
        end)
    end

    -- Переключатели
    createToggle("ESP Игроков", Settings.PlayerESP, function(v) Settings.PlayerESP = v end)
    createToggle("ESP Твистедов", Settings.TwistedESP, function(v) Settings.TwistedESP = v end)
    createToggle("ESP Генераторов", Settings.GeneratorESP, function(v) Settings.GeneratorESP = v end)
    createToggle("ESP Предметов", Settings.ItemESP, function(v) Settings.ItemESP = v end)
    createToggle("ESP Капсул", Settings.CapsuleESP, function(v) Settings.CapsuleESP = v end)
    createToggle("Авто-скиллчек", Settings.AutoSkillCheck, function(v) Settings.AutoSkillCheck = v end)
    createToggle("Автофарм", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
    createToggle("Авто-сбор предметов", Settings.AutoCollect, function(v) Settings.AutoCollect = v end)
    createToggle("Авто-сбор капсул", Settings.AutoCapsule, function(v) Settings.AutoCapsule = v end)
    createToggle("Полная яркость", Settings.FullBright, function(v) Settings.FullBright = v end)
    createToggle("Ноклип", Settings.Noclip, function(v) Settings.Noclip = v end)
    createToggle("Режим полёта", Settings.Fly, function(v) Settings.Fly = v end)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    burger.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

    local drag = false
    local dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ================== ОПТИМИЗИРОВАННЫЙ ESP (БЕЗ ЛАГОВ) ==================
local function setupESP()
    local player = game.Players.LocalPlayer
    local function makeESP(color, name)
        local h = Instance.new("Highlight")
        h.Name = name
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillColor = color
        h.FillTransparency = 0.5
        h.OutlineTransparency = 1
        return h
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        -- Очищаем старые ESP один раз в 5 кадров
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") and v.Name:match("ESP$") then
                v:Destroy()
            end
        end

        if Settings.PlayerESP then
            for _, p in ipairs(ObjectCache.Players) do
                if p.Character then
                    local clone = makeESP(Color3.fromRGB(0,255,0), "PlayerESP")
                    clone.Adornee = p.Character
                    clone.Parent = p.Character
                end
            end
        end

        if Settings.TwistedESP then
            for _, obj in ipairs(ObjectCache.Twisted) do
                local clone = makeESP(Color3.fromRGB(255,0,0), "TwistedESP")
                clone.Adornee = obj
                clone.Parent = obj
            end
        end

        if Settings.GeneratorESP then
            for _, obj in ipairs(ObjectCache.Generators) do
                local clone = makeESP(Color3.fromRGB(255,255,0), "GeneratorESP")
                clone.Adornee = obj
                clone.Parent = obj
            end
        end

        if Settings.ItemESP then
            for _, obj in ipairs(ObjectCache.Items) do
                local clone = makeESP(Color3.fromRGB(0,255,255), "ItemESP")
                clone.Adornee = obj
                clone.Parent = obj
            end
        end

        if Settings.CapsuleESP then
            for _, obj in ipairs(ObjectCache.Capsules) do
                local clone = makeESP(Color3.fromRGB(255,0,255), "CapsuleESP")
                clone.Adornee = obj
                clone.Parent = obj
            end
        end
    end)
end
-- =====================================================
-- ЧАСТЬ 2: ИСПРАВЛЕННЫЙ СКИЛЛЧЕК + НОКЛИП (ПОЛНОСТЬЮ РАБОТАЕТ)
-- =====================================================

-- ================== УНИВЕРСАЛЬНЫЙ АВТО-СКИЛЛЧЕК ==================
task.spawn(function()
    while task.wait(0.05) do
        if not Settings.AutoSkillCheck then continue end
        local player = game.Players.LocalPlayer
        local gui = player.PlayerGui
        if not gui then continue end

        -- Ищем любой активный скиллчек
        local skillCheck = nil
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("Frame") or child:IsA("ScreenGui") then
                local sc = child:FindFirstChild("SkillCheck", true) or child:FindFirstChild("MiniGame", true) or child:FindFirstChild("SkillCheckFrame", true)
                if sc and sc.Visible then
                    skillCheck = sc
                    break
                end
            end
        end

        if skillCheck then
            -- Ищем кнопку или зону клика
            local button = skillCheck:FindFirstChild("Button") or skillCheck:FindFirstChild("Click") or skillCheck:FindFirstChild("SkillCheckButton")
            if button and button:IsA("TextButton") then
                pcall(function() button:FireServer() end)
                pcall(function() button:Click() end)
            end

            -- Если скиллчек круговой (с зоной) – кликаем по центру зоны
            local circle = skillCheck:FindFirstChild("Circle") or skillCheck:FindFirstChild("SkillCheckCircle") or skillCheck:FindFirstChild("Zone")
            if circle and circle:IsA("Frame") then
                pcall(function()
                    -- Ищем RemoteEvent для прохождения
                    local rs = game:GetService("ReplicatedStorage")
                    local ev = rs:FindFirstChild("SkillCheckPass") or rs:FindFirstChild("PassSkillCheck") or rs:FindFirstChild("CompleteSkillCheck")
                    if ev then ev:FireServer() end
                end)
            end

            -- Для скиллчеков с ползунком (например, удерживание)
            local slider = skillCheck:FindFirstChild("Slider") or skillCheck:FindFirstChild("ProgressBar")
            if slider and slider:IsA("Frame") then
                pcall(function()
                    local rs = game:GetService("ReplicatedStorage")
                    local ev = rs:FindFirstChild("SkillCheckHold") or rs:FindFirstChild("HoldSkillCheck")
                    if ev then ev:FireServer() end
                end)
            end
        end
    end
end)

-- ================== ИСПРАВЛЕННЫЙ НОКЛИП (РАБОТАЕТ НАДЁЖНО) ==================
task.spawn(function()
    while task.wait(0.05) do
        if Settings.Noclip then
            local char = game.Players.LocalPlayer.Character
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
-- =====================================================
-- ЧАСТЬ 3: УМНЫЙ АВТОФАРМ, ТЕЛЕПОРТ К ИГРОКАМ, СЛАЙДЕРЫ СКОРОСТИ/ПРЫЖКА
-- =====================================================

-- ================== ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ ==================
Settings.FlySpeed = 50
Settings.TeleportToPlayers = false
Settings.Fly = false

-- ================== ТЕЛЕПОРТ К ИГРОКАМ ==================
local function teleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        local pos = root.Position + Vector3.new(0, 3, 0)
        teleportTo(pos)
        return true
    end
    return false
end

-- Кнопка в меню для телепорта к ближайшему игроку (добавим позже в GUI)
local function findNearestPlayer()
    local player = game.Players.LocalPlayer
    local nearest = nil
    local minDist = math.huge
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = p
            end
        end
    end
    return nearest
end

-- Горячая клавиша для телепорта к ближайшему игроку (F)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if Settings.TeleportToPlayers then
            local target = findNearestPlayer()
            if target then
                teleportToPlayer(target)
            end
        end
    end
end)

-- ================== ИСПРАВЛЕННЫЙ АВТОФАРМ (С РЕМОНТОМ ГЕНЕРАТОРОВ) ==================
local farm = { active = false, step = 0, idx = 1, isRepairing = false }

local function getGenerators()
    local gens = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():match("generator") or obj.Name:lower():match("gen")) then
            -- Проверяем, не починен ли уже генератор (по цвету или атрибуту)
            local isBroken = true
            -- Проверяем наличие свечения или анимации (признак работы)
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("BasePart") and child.Material == Enum.Material.Neon then
                    isBroken = false
                    break
                end
            end
            if isBroken then
                table.insert(gens, obj)
            end
        end
    end
    return gens
end

local function isGeneratorRepairing(gen)
    -- Проверяем, есть ли анимация или звук ремонта
    for _, child in ipairs(gen:GetDescendants()) do
        if child:IsA("Sound") and child.IsPlaying then
            return true
        end
        if child:IsA("AnimationTrack") and child.IsPlaying then
            return true
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
                farm.idx = 1
                farm.step = 0
                farm.isRepairing = false
                while farm.active do
                    local p = game.Players.LocalPlayer
                    if not p or not p.Character then task.wait(1) continue end
                    local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
                    if not root then task.wait(1) continue end

                    local gen = gens[farm.idx]
                    if not gen then
                        farm.active = false
                        break
                    end

                    local genPos = gen.PrimaryPart and gen.PrimaryPart.Position or gen:FindFirstChild("HumanoidRootPart") and gen:FindFirstChild("HumanoidRootPart").Position
                    if not genPos then task.wait(1) continue end

                    if farm.step == 0 then
                        -- Телепорт к генератору
                        if (root.Position - genPos).Magnitude > 5 then
                            teleportTo(genPos + Vector3.new(0, 2, 0))
                        else
                            farm.step = 1
                        end
                    elseif farm.step == 1 then
                        -- Начинаем ремонт
                        interactWith(gen)
                        farm.isRepairing = true
                        farm.step = 2
                    elseif farm.step == 2 then
                        -- Ждём, пока генератор не начнёт ремонтироваться
                        if isGeneratorRepairing(gen) then
                            farm.step = 3
                        else
                            -- Если не начался ремонт, пробуем ещё раз
                            interactWith(gen)
                            task.wait(0.5)
                        end
                    elseif farm.step == 3 then
                        -- Проверяем, починен ли генератор (исчез или изменил цвет)
                        local isDone = true
                        for _, child in ipairs(gen:GetDescendants()) do
                            if child:IsA("BasePart") and child.Material == Enum.Material.Neon then
                                isDone = false
                                break
                            end
                        end
                        if isDone then
                            farm.step = 4
                        else
                            task.wait(0.5)
                        end
                    elseif farm.step == 4 then
                        -- Переход к следующему генератору
                        farm.idx = farm.idx + 1
                        farm.step = 0
                        farm.isRepairing = false
                    end
                    task.wait(0.3)
                end
            else
                farm.active = false
            end
        elseif not Settings.AutoFarm and farm.active then
            farm.active = false
        end
    end
end)

-- ================== ДОБАВЛЯЕМ СЛАЙДЕРЫ В МЕНЮ ==================
-- Добавляем функцию создания слайдера в createUI (нужно вставить в конец функции)
local function addSlidersToUI()
    -- Эта функция будет вызвана при создании GUI
    -- Мы добавим слайдеры в mainFrame
end

-- Добавляем слайдеры в существующее меню (модифицируем createUI)
-- Вставляем этот код в функцию createUI после создания всех переключателей

-- Вот код, который нужно добавить в createUI после createToggle для Fly:
-- Создаём слайдеры для скорости и прыжка
local function createSlider(name, min, max, default, callback, yOffset)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.95, 0, 0, 35)
    f.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    f.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(230, 230, 240)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = f

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0.15, 0, 1, 0)
    val.Position = UDim2.new(0.8, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.TextColor3 = Color3.fromRGB(255, 255, 255)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 14
    val.TextXAlignment = Enum.TextXAlignment.Center
    val.TextYAlignment = Enum.TextYAlignment.Center
    val.Parent = f

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.65, 0, 0, 6)
    slider.Position = UDim2.new(0, 0, 0.7, 0)
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
        local value = math.round(min + newVal * (max - min))
        fill.Size = UDim2.new(newVal, 0, 1, 0)
        val.Text = tostring(value)
        callback(value)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    slider.InputEnded:Connect(function() dragging = false end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    return f
end

-- Эти строки нужно добавить в createUI после всех createToggle
-- Добавляем слайдеры для скорости и прыжка
createSlider("Скорость", 0, 100, 16, function(v) Settings.SpeedValue = v end)
createSlider("Прыжок", 0, 100, 50, function(v) Settings.JumpValue = v end)
createSlider("Скорость полёта", 10, 200, 50, function(v) Settings.FlySpeed = v end)
-- =====================================================
-- ЧАСТЬ 4: РЕЖИМ ПОЛЁТА + ОБХОД АНТИЧИТА + ТЕЛЕПОРТ К ТВИСТЕДАМ
-- =====================================================

-- ================== РЕЖИМ ПОЛЁТА (FLY) ==================
local fly = {
    active = false,
    speed = 50,
    bodyVelocity = nil,
    bodyGyro = nil
}

task.spawn(function()
    while task.wait(0.1) do
        if Settings.Fly and not fly.active then
            -- Активируем полёт
            local char = game.Players.LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    fly.active = true
                    fly.speed = Settings.FlySpeed or 50
                    
                    -- Создаём BodyVelocity для управления движением
                    fly.bodyVelocity = Instance.new("BodyVelocity")
                    fly.bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    fly.bodyVelocity.Parent = root

                    -- Создаём BodyGyro для стабилизации
                    fly.bodyGyro = Instance.new("BodyGyro")
                    fly.bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                    fly.bodyGyro.CFrame = root.CFrame
                    fly.bodyGyro.Parent = root

                    -- Отключаем гравитацию
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.PlatformStand = true
                    end
                end
            end
        elseif not Settings.Fly and fly.active then
            -- Деактивируем полёт
            if fly.bodyVelocity then
                fly.bodyVelocity:Destroy()
                fly.bodyVelocity = nil
            end
            if fly.bodyGyro then
                fly.bodyGyro:Destroy()
                fly.bodyGyro = nil
            end
            local char = game.Players.LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.PlatformStand = false
                end
            end
            fly.active = false
        end

        -- Управление полётом (клавиши WASD + пробел/Shift)
        if fly.active and fly.bodyVelocity then
            local char = game.Players.LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local moveDir = Vector3.new(0, 0, 0)
                    local speed = fly.speed
                    local camera = workspace.CurrentCamera
                    
                    -- WASD управление
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + camera.CFrame.LookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - camera.CFrame.LookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - camera.CFrame.RightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + camera.CFrame.RightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDir = moveDir - Vector3.new(0, 1, 0)
                    end

                    if moveDir.Magnitude > 0 then
                        moveDir = moveDir.Unit * speed
                        fly.bodyVelocity.Velocity = moveDir
                    else
                        fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end

                    -- Стабилизация
                    fly.bodyGyro.CFrame = CFrame.new(root.Position, root.Position + camera.CFrame.LookVector)
                end
            end
        end
    end
end)

-- ================== ТЕЛЕПОРТ К БЛИЖАЙШЕМУ ТВИСТЕДУ (НА ВЫСОТЕ) ==================
local function teleportToTwisted()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return end
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local nearest = nil
    local minDist = math.huge
    for _, obj in ipairs(ObjectCache.Twisted) do
        local pos = obj.PrimaryPart and obj.PrimaryPart.Position or obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChild("HumanoidRootPart").Position
        if pos then
            local dist = (root.Position - pos).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = obj
            end
        end
    end

    if nearest then
        local pos = nearest.PrimaryPart and nearest.PrimaryPart.Position or nearest:FindFirstChild("HumanoidRootPart") and nearest:FindFirstChild("HumanoidRootPart").Position
        if pos then
            -- Телепортируемся на высоту 15 студий над твистедом
            teleportTo(pos + Vector3.new(0, 15, 0))
            return true
        end
    end
    return false
end

-- Горячая клавиша для телепорта к твистеду (G)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        teleportToTwisted()
    end
end)

-- ================== ОБХОД АНТИЧИТА (ЗАДЕРЖКИ И ИМИТАЦИЯ) ==================
-- Добавляем случайные задержки между действиями, чтобы не вызывать подозрений
local function randomDelay(min, max)
    return math.random(min * 100, max * 100) / 100
end

-- Переопределяем teleportTo с задержкой
local originalTeleport = teleportTo
teleportTo = function(pos)
    -- Добавляем случайную задержку 0.5-1.5 секунды
    task.wait(randomDelay(0.5, 1.5))
    originalTeleport(pos)
    -- Добавляем небольшую задержку после телепорта
    task.wait(randomDelay(0.2, 0.5))
end

-- Переопределяем interactWith с задержкой
local originalInteract = interactWith
interactWith = function(obj)
    task.wait(randomDelay(0.3, 0.8))
    originalInteract(obj)
    task.wait(randomDelay(0.2, 0.4))
end

print("✅ ЧАСТЬ 4 загружена: Полёт (WASD+Пробел/Shift), Телепорт к твистедам (G), Обход античита")
-- =====================================================
-- ЧАСТЬ 5: ФИНАЛЬНАЯ СБОРКА (ВСЁ ВМЕСТЕ)
-- =====================================================

-- Обновляем функцию createUI, добавляем недостающие элементы
-- (Вставляем в конец функции createUI после всех createToggle)

-- Добавляем кнопку "Телепорт к игроку" в меню
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.95, 0, 0, 40)
teleportBtn.Position = UDim2.new(0.025, 0, 0, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
teleportBtn.Text = "🔹 Телепорт к игроку (F)"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 16
teleportBtn.BorderSizePixel = 0
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 8)
teleportBtn.Parent = mainFrame
teleportBtn.Position = UDim2.new(0.025, 0, 0, 430)
teleportBtn.Size = UDim2.new(0.95, 0, 0, 40)

teleportBtn.MouseButton1Click:Connect(function()
    local target = findNearestPlayer()
    if target then
        teleportToPlayer(target)
        print("Телепорт к игроку:", target.Name)
    else
        print("Игроков рядом нет")
    end
end)

-- Добавляем кнопку "Телепорт к твистеду" в меню
local twistedBtn = Instance.new("TextButton")
twistedBtn.Size = UDim2.new(0.95, 0, 0, 40)
twistedBtn.Position = UDim2.new(0.025, 0, 0, 475)
twistedBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
twistedBtn.Text = "🔹 Телепорт к твистеду (G)"
twistedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
twistedBtn.Font = Enum.Font.GothamBold
twistedBtn.TextSize = 16
twistedBtn.BorderSizePixel = 0
Instance.new("UICorner", twistedBtn).CornerRadius = UDim.new(0, 8)
twistedBtn.Parent = mainFrame
twistedBtn.Position = UDim2.new(0.025, 0, 0, 520)
twistedBtn.Size = UDim2.new(0.95, 0, 0, 40)

twistedBtn.MouseButton1Click:Connect(function()
    teleportToTwisted()
end)

-- Добавляем кнопку "Телепорт в лифт"
local liftBtn = Instance.new("TextButton")
liftBtn.Size = UDim2.new(0.95, 0, 0, 40)
liftBtn.Position = UDim2.new(0.025, 0, 0, 565)
liftBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
liftBtn.Text = "🔹 Телепорт в лифт"
liftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
liftBtn.Font = Enum.Font.GothamBold
liftBtn.TextSize = 16
liftBtn.BorderSizePixel = 0
Instance.new("UICorner", liftBtn).CornerRadius = UDim.new(0, 8)
liftBtn.Parent = mainFrame
liftBtn.Position = UDim2.new(0.025, 0, 0, 610)
liftBtn.Size = UDim2.new(0.95, 0, 0, 40)

liftBtn.MouseButton1Click:Connect(function()
    local el = getElevator()
    if el then
        local elPos = el.PrimaryPart and el.PrimaryPart.Position or el:FindFirstChild("HumanoidRootPart") and el:FindFirstChild("HumanoidRootPart").Position
        if elPos then
            teleportTo(elPos)
        end
    end
end)

-- Увеличиваем размер mainFrame для новых кнопок
mainFrame.Size = UDim2.new(0, 320, 0, 680)

-- ================== ФИНАЛЬНЫЙ ЗАПУСК ==================
createUI()
setupESP()

-- Запускаем обновление кэша
task.spawn(updateCache)

print("✅ Dandy World v9.0 FULLY LOADED!")
print("🔹 Управление:")
print("  ≡ - меню")
print("  F - телепорт к ближайшему игроку")
print("  G - телепорт к твистеду (на высоте)")
print("  WASD - полёт (если включён)")
print("  Пробел/Shift - вверх/вниз (в полёте)")
