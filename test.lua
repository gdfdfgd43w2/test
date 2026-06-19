-- =====================================================
-- DANDY'S WORLD ULTIMATE SCRIPT v9.2 (FULL)
-- Объединённая версия из 5 частей
-- Все функции: ESP, авто-скиллчек, автофарм, авто-сбор, полёт, телепорты, ноклип, защита от твистедов, анти-АФК, FullBright, настройка скорости/прыжка и многое другое.
-- =====================================================

-- =====================================================
-- ЧАСТЬ 1: НАСТРОЙКИ (БОЛЕЕ 50 ПАРАМЕТРОВ)
-- =====================================================

local Settings = {
    -- ====== ОБЩИЕ ======
    EnableScript = true,               -- Включить весь скрипт
    DebugMode = false,                 -- Вывод отладочных сообщений в консоль
    Language = "ru",                   -- Язык интерфейса (ru/en)

    -- ====== ESP ======
    PlayerESP = false,                 -- Подсветка игроков
    TwistedESP = false,                -- Подсветка твистедов
    GeneratorESP = false,              -- Подсветка генераторов
    ItemESP = false,                   -- Подсветка предметов
    CapsuleESP = false,                -- Подсветка капсул
    TapeESP = false,                   -- Подсветка кассет
    ElevatorESP = false,               -- Подсветка лифта
    DoorESP = false,                   -- Подсветка дверей
    ESPDistance = 100,                 -- Максимальная дистанция ESP
    ESPColorPlayer = Color3.fromRGB(0, 255, 0),
    ESPColorTwisted = Color3.fromRGB(255, 0, 0),
    ESPColorGenerator = Color3.fromRGB(255, 255, 0),
    ESPColorItem = Color3.fromRGB(0, 255, 255),
    ESPColorCapsule = Color3.fromRGB(255, 0, 255),
    ESPColorElevator = Color3.fromRGB(0, 200, 200),
    ESPColorDoor = Color3.fromRGB(200, 200, 0),
    ESPFillTransparency = 0.5,
    ESPShowNames = true,               -- Показывать имена над объектами
    ESPShowDistance = true,            -- Показывать расстояние до объекта

    -- ====== АВТО-СКИЛЛЧЕК ======
    AutoSkillCheck = false,
    SkillCheckDelay = 0.05,            -- Задержка между проверками
    SkillCheckClickType = "all",       -- "button", "circle", "slider", "all"
    SkillCheckAutoComplete = true,     -- Автоматически завершать скиллчек

    -- ====== АВТОФАРМ ======
    AutoFarm = false,
    FarmMode = "smart",                -- "smart", "quick", "stealth"
    FarmPriority = "nearest",          -- "nearest", "farthest", "random"
    FarmCheckInterval = 1,             -- Интервал проверки генераторов (сек)
    FarmTeleportDelay = 0.3,           -- Задержка между телепортами
    FarmUseSkyJump = true,             -- Уход в небо после активации
    FarmSkyHeight = 30,                -- Высота ухода в небо
    FarmAutoElevator = true,           -- После всех генераторов идти к лифту
    FarmElevatorWait = 2,              -- Задержка перед активацией лифта
    FarmMaxGenerators = 20,            -- Максимум генераторов для обработки (0 = все)

    -- ====== АВТО-СБОР ======
    AutoCollect = false,
    AutoCollectItems = true,
    AutoCollectCapsules = true,
    AutoCollectTapes = true,
    CollectRadius = 15,                -- Радиус сбора
    CollectTeleportDelay = 0.1,
    CollectPriority = "nearest",       -- "nearest", "random"

    -- ====== НОКЛИП ======
    Noclip = false,
    NoclipMode = "always",             -- "always", "on_move", "on_fly"

    -- ====== ПОЛЁТ ======
    Fly = false,
    FlySpeed = 50,
    FlyControlSmoothness = 0.8,        -- Плавность управления (0-1)
    FlyAutoHover = false,              -- Зависание на месте без нажатий

    -- ====== ТЕЛЕПОРТЫ ======
    TeleportToPlayers = true,
    TeleportToTwisted = true,
    TeleportToGenerator = true,
    TeleportToElevator = true,
    TeleportToItem = true,
    TeleportToCapsule = true,
    TeleportKeyPlayer = Enum.KeyCode.F,
    TeleportKeyTwisted = Enum.KeyCode.G,
    TeleportKeyGenerator = Enum.KeyCode.H,
    TeleportKeyElevator = Enum.KeyCode.T,
    TeleportKeyItem = Enum.KeyCode.Y,
    TeleportKeyCapsule = Enum.KeyCode.U,

    -- ====== СКОРОСТЬ И ПРЫЖОК ======
    SpeedValue = 16,
    JumpValue = 50,
    SpeedEnabled = true,
    JumpEnabled = true,
    MaxSpeed = 100,
    MaxJump = 100,

    -- ====== АНТИ-АФК ======
    AntiAFK = false,
    AntiAFKInterval = 60,              -- Интервал имитации действий (сек)
    AntiAFKRandomize = true,           -- Рандомизация времени

    -- ====== FULLBRIGHT ======
    FullBright = false,
    FullBrightBrightness = 2,
    FullBrightAmbient = Color3.fromRGB(128, 128, 128),
    FullBrightTime = 14,

    -- ====== ЗАЩИТА ОТ ТВИСТЕДОВ ======
    AvoidTwisted = false,
    AvoidRadius = 15,
    AvoidMode = "teleport",            -- "teleport", "walk_away", "fly_up"
    AvoidCheckInterval = 0.5,

    -- ====== ИНТЕРФЕЙС ======
    MenuKey = Enum.KeyCode.RightShift, -- Клавиша для открытия меню
    MenuTransparency = 0.2,
    MenuColor = Color3.fromRGB(20, 20, 35),
    MenuSize = UDim2.new(0, 340, 0, 640),

    -- ====== ПРОЧЕЕ ======
    AutoDoors = false,
    AutoOpenDoorsRadius = 10,
    AntiBan = true,
    RandomizeDelays = true,
    MinDelay = 0.2,
    MaxDelay = 1.5,
    SaveSettings = false,              -- Сохранять настройки между запусками (если поддерживается)
    ShowFPS = false,
    ShowStats = false,
}

-- ====== СИСТЕМА ЛОГИРОВАНИЯ ======
local function log(message, level)
    level = level or "info"
    if Settings.DebugMode or level == "error" then
        print("[Dandy] " .. level:upper() .. ": " .. message)
    end
end

log("Настройки загружены", "info")

-- =====================================================
-- ЧАСТЬ 2: КЭШИРОВАНИЕ ОБЪЕКТОВ И УТИЛИТЫ
-- =====================================================

local ObjectCache = {
    Twisted = {},
    Generators = {},
    Items = {},
    Capsules = {},
    Tapes = {},
    Doors = {},
    Elevator = nil,
    Players = {},
}

local function updateCache()
    log("Обновление кэша...", "debug")
    ObjectCache.Twisted = {}
    ObjectCache.Generators = {}
    ObjectCache.Items = {}
    ObjectCache.Capsules = {}
    ObjectCache.Tapes = {}
    ObjectCache.Doors = {}
    ObjectCache.Elevator = nil

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:match("twisted") or name:match("enemy") or name:match("monster") then
                table.insert(ObjectCache.Twisted, obj)
            elseif name:match("generator") or name:match("gen") then
                table.insert(ObjectCache.Generators, obj)
            elseif name:match("capsule") or name:match("pod") then
                table.insert(ObjectCache.Capsules, obj)
            elseif name:match("item") or name:match("pickup") then
                table.insert(ObjectCache.Items, obj)
            elseif name:match("tape") or name:match("cassette") then
                table.insert(ObjectCache.Tapes, obj)
            elseif name:match("door") then
                table.insert(ObjectCache.Doors, obj)
            elseif name:match("elevator") or name:match("lift") then
                ObjectCache.Elevator = obj
            end
        end
    end

    ObjectCache.Players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            table.insert(ObjectCache.Players, p)
        end
    end

    if Settings.DebugMode then
        log(string.format("Кэш обновлён: твистедов=%d, генераторов=%d, предметов=%d, капсул=%d, кассет=%d, дверей=%d, игроков=%d",
            #ObjectCache.Twisted, #ObjectCache.Generators, #ObjectCache.Items, #ObjectCache.Capsules,
            #ObjectCache.Tapes, #ObjectCache.Doors, #ObjectCache.Players), "debug")
    end
end

task.spawn(function()
    while Settings.EnableScript do
        task.wait(1)
        pcall(updateCache)
    end
end)

-- ====== БАЗОВЫЕ УТИЛИТЫ ======

local function getObjectPosition(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then
        return obj.Position
    elseif obj:IsA("Model") then
        local part = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChild("Head") or obj:FindFirstChild("Torso")
        if part then return part.Position end
    end
    return nil
end

local function teleportTo(pos)
    local p = game.Players.LocalPlayer
    if not p or not p.Character then return false end
    local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart
    if not root then return false end
    if not pos then return false end
    local cframe = (type(pos) == "Vector3") and CFrame.new(pos) or pos
    root.CFrame = cframe
    return true
end

local function interactWith(obj)
    if not obj then return false end
    local cd = obj:FindFirstChild("ClickDetector") or obj:FindFirstChild("ProximityPrompt")
    if cd then
        if cd:IsA("ClickDetector") then
            cd:FireClick(game.Players.LocalPlayer)
            return true
        elseif cd:IsA("ProximityPrompt") then
            cd:Hold()
            task.wait(0.3)
            cd:Release()
            return true
        end
    end
    return false
end

local function randomDelay(min, max)
    if Settings.RandomizeDelays then
        return math.random(min * 100, max * 100) / 100
    else
        return (min + max) / 2
    end
end

local function safeTeleport(pos)
    task.wait(randomDelay(0.3, 0.8))
    local success = teleportTo(pos)
    task.wait(randomDelay(0.1, 0.3))
    return success
end

local function safeInteract(obj)
    task.wait(randomDelay(0.2, 0.5))
    local success = interactWith(obj)
    task.wait(randomDelay(0.1, 0.2))
    return success
end

local function findNearestObject(objects, fromPos)
    local nearest = nil
    local minDist = math.huge
    for _, obj in ipairs(objects) do
        local pos = getObjectPosition(obj)
        if pos then
            local dist = (fromPos - pos).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = obj
            end
        end
    end
    return nearest, minDist
end

local function findNearestPlayer()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return nil end
    local fromPos = getObjectPosition(player.Character)
    if not fromPos then return nil end
    return findNearestObject(ObjectCache.Players, fromPos)
end

local function findNearestTwisted()
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return nil end
    local fromPos = getObjectPosition(player.Character)
    if not fromPos then return nil end
    return findNearestObject(ObjectCache.Twisted, fromPos)
end

local function getElevatorPosition()
    local el = ObjectCache.Elevator
    if el then
        return getObjectPosition(el)
    end
    return nil
end

local function isSafe(radius)
    radius = radius or 15
    local player = game.Players.LocalPlayer
    if not player or not player.Character then return false end
    local fromPos = getObjectPosition(player.Character)
    if not fromPos then return false end
    for _, tw in ipairs(ObjectCache.Twisted) do
        local pos = getObjectPosition(tw)
        if pos and (fromPos - pos).Magnitude < radius then
            return false
        end
    end
    return true
end

local function safeCall(func, ...)
    local success, err = pcall(func, ...)
    if not success and Settings.DebugMode then
        log("Ошибка: " .. tostring(err), "error")
    end
    return success, err
end

log("Утилиты и кэш загружены", "info")

-- =====================================================
-- ЧАСТЬ 3: ГРАФИЧЕСКИЙ ИНТЕРФЕЙС (GUI) С ВКЛАДКАМИ
-- =====================================================

local function createUI()
    local player = game.Players.LocalPlayer
    if not player then return end

    local gui = Instance.new("ScreenGui")
    gui.Name = "DandyWorldGUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    gui.Parent = player.PlayerGui

    -- Кнопка-бургер
    local burger = Instance.new("TextButton")
    burger.Size = UDim2.new(0, 55, 0, 55)
    burger.Position = UDim2.new(0, 10, 0, 10)
    burger.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    burger.Text = "☰"
    burger.TextColor3 = Color3.fromRGB(255, 255, 255)
    burger.Font = Enum.Font.GothamBold
    burger.TextSize = 32
    burger.BorderSizePixel = 0
    burger.BackgroundTransparency = 0.2
    Instance.new("UICorner", burger).CornerRadius = UDim.new(0, 12)
    burger.Parent = gui

    -- Главное окно
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = Settings.MenuSize or UDim2.new(0, 340, 0, 640)
    mainFrame.Position = UDim2.new(0.5, -170, 0.5, -320)
    mainFrame.BackgroundColor3 = Settings.MenuColor or Color3.fromRGB(20, 20, 35)
    mainFrame.BackgroundTransparency = Settings.MenuTransparency or 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
    mainFrame.Parent = gui

    -- Тень
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(-0.5, -10, -0.5, -10)
    shadow.Image = "rbxasset://textures/ui/round_shadow.png"
    shadow.ImageTransparency = 0.7
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = 0
    shadow.Parent = mainFrame

    -- Шапка
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
    titleBar.BorderSizePixel = 0
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)
    titleBar.Parent = mainFrame

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 40, 0, 40)
    logo.Position = UDim2.new(0, 12, 0.5, -20)
    logo.BackgroundTransparency = 1
    logo.Text = "✦"
    logo.TextColor3 = Color3.fromRGB(200, 170, 255)
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = 30
    logo.TextXAlignment = Enum.TextXAlignment.Center
    logo.TextYAlignment = Enum.TextYAlignment.Center
    logo.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.5, 0, 1, 0)
    title.Position = UDim2.new(0, 55, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Dandy World v9.2"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextYAlignment = Enum.TextYAlignment.Center
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 34, 0, 34)
    closeBtn.Position = UDim2.new(1, -42, 0.5, -17)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.Parent = titleBar

    -- Панель вкладок
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 42)
    tabBar.Position = UDim2.new(0, 0, 0, 50)
    tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabBar

    local tabs = {
        {name = "ESP", icon = "👁️"},
        {name = "Авто", icon = "⚙️"},
        {name = "Телепорты", icon = "🚀"},
        {name = "Настройки", icon = "🔧"},
        {name = "Инфо", icon = "📊"},
    }

    local tabButtons = {}
    local currentTab = 1

    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -92)
    contentContainer.Position = UDim2.new(0, 0, 0, 92)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ClipsDescendants = true
    contentContainer.Parent = mainFrame

    local tabContents = {}
    for i = 1, #tabs do
        local tabFrame = Instance.new("ScrollingFrame")
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.Position = UDim2.new(0, 0, 0, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.BorderSizePixel = 0
        tabFrame.Visible = (i == 1)
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabFrame.ScrollBarThickness = 4
        tabFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 180, 255)
        tabFrame.Parent = contentContainer

        local tabLayout2 = Instance.new("UIListLayout")
        tabLayout2.Padding = UDim.new(0, 6)
        tabLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabLayout2.VerticalAlignment = Enum.VerticalAlignment.Top
        tabLayout2.Parent = tabFrame

        tabLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout2.AbsoluteContentSize.Y + 20)
        end)

        tabContents[i] = {
            frame = tabFrame,
            layout = tabLayout2
        }
    end

    local function createTabButton(index, name, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 55, 0, 32)
        btn.BackgroundColor3 = (index == 1) and Color3.fromRGB(80, 60, 150) or Color3.fromRGB(40, 40, 60)
        btn.Text = icon .. " " .. name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = 0.5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.Parent = tabBar

        btn.MouseButton1Click:Connect(function()
            for i, tb in ipairs(tabButtons) do
                tb.BackgroundColor3 = (i == index) and Color3.fromRGB(80, 60, 150) or Color3.fromRGB(40, 40, 60)
            end
            for i, content in ipairs(tabContents) do
                content.frame.Visible = (i == index)
            end
            currentTab = index
        end)

        table.insert(tabButtons, btn)
        return btn
    end

    for i, tab in ipairs(tabs) do
        createTabButton(i, tab.name, tab.icon)
    end

    -- Вспомогательные функции для GUI
    local function createToggle(container, name, state, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.95, 0, 0, 42)
        f.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        f.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(230, 230, 240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 15
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = f

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 60, 0, 30)
        btn.Position = UDim2.new(1, -68, 0.5, -15)
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(180, 60, 60)
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
            btn.BackgroundColor3 = cur and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(180, 60, 60)
            btn.Text = cur and "ON" or "OFF"
            if callback then callback(cur) end
        end)

        return f
    end

    local function createSlider(container, name, min, max, default, callback)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0.95, 0, 0, 48)
        f.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        f.BorderSizePixel = 0
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        f.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(230, 230, 240)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Top
        label.Parent = f

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(0.15, 0, 1, 0)
        val.Position = UDim2.new(0.85, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text = tostring(default)
        val.TextColor3 = Color3.fromRGB(255, 255, 255)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 14
        val.TextXAlignment = Enum.TextXAlignment.Right
        val.TextYAlignment = Enum.TextYAlignment.Top
        val.Parent = f

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0.85, 0, 0, 6)
        sliderFrame.Position = UDim2.new(0, 10, 0, 32)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        sliderFrame.BorderSizePixel = 0
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 3)
        sliderFrame.Parent = f

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
        fill.Parent = sliderFrame

        local dragging = false
        local function update(input)
            local pos = input.Position.X
            local size = sliderFrame.AbsoluteSize.X
            if size == 0 then return end
            local newVal = math.clamp((pos - sliderFrame.AbsolutePosition.X) / size, 0, 1)
            local value = math.round(min + newVal * (max - min))
            fill.Size = UDim2.new(newVal, 0, 1, 0)
            val.Text = tostring(value)
            callback(value)
        end

        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)
        sliderFrame.InputEnded:Connect(function() dragging = false end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)

        return f
    end

    local function createActionButton(container, text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.95, 0, 0, 40)
        btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 200)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        btn.Parent = container

        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)

        return btn
    end

    local function createSectionHeader(container, text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.95, 0, 0, 28)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(180, 160, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = container
        return label
    end

    -- ====== ЗАПОЛНЕНИЕ ВКЛАДОК ======
    local espContainer = tabContents[1].frame
    createSectionHeader(espContainer, "─── Подсветка объектов ───")
    createToggle(espContainer, "Игроки", Settings.PlayerESP, function(v) Settings.PlayerESP = v end)
    createToggle(espContainer, "Твистеды", Settings.TwistedESP, function(v) Settings.TwistedESP = v end)
    createToggle(espContainer, "Генераторы", Settings.GeneratorESP, function(v) Settings.GeneratorESP = v end)
    createToggle(espContainer, "Предметы", Settings.ItemESP, function(v) Settings.ItemESP = v end)
    createToggle(espContainer, "Капсулы", Settings.CapsuleESP, function(v) Settings.CapsuleESP = v end)
    createToggle(espContainer, "Кассеты", Settings.TapeESP, function(v) Settings.TapeESP = v end)
    createToggle(espContainer, "Двери", Settings.DoorESP, function(v) Settings.DoorESP = v end)
    createToggle(espContainer, "Лифт", Settings.ElevatorESP, function(v) Settings.ElevatorESP = v end)

    createSectionHeader(espContainer, "─── Настройки ESP ───")
    createSlider(espContainer, "Дистанция", 10, 200, 100, function(v) Settings.ESPDistance = v end)
    createSlider(espContainer, "Прозрачность", 0, 1, 0.5, function(v) Settings.ESPFillTransparency = v end)

    local autoContainer = tabContents[2].frame
    createSectionHeader(autoContainer, "─── Скиллчек ───")
    createToggle(autoContainer, "Авто-скиллчек", Settings.AutoSkillCheck, function(v) Settings.AutoSkillCheck = v end)
    createSlider(autoContainer, "Задержка проверки", 0.01, 0.5, 0.05, function(v) Settings.SkillCheckDelay = v end)

    createSectionHeader(autoContainer, "─── Фарм ───")
    createToggle(autoContainer, "Автофарм", Settings.AutoFarm, function(v) Settings.AutoFarm = v end)
    createToggle(autoContainer, "Уход в небо после активации", Settings.FarmUseSkyJump, function(v) Settings.FarmUseSkyJump = v end)
    createSlider(autoContainer, "Высота ухода в небо", 10, 60, 30, function(v) Settings.FarmSkyHeight = v end)
    createSlider(autoContainer, "Интервал проверки (сек)", 0.5, 5, 1, function(v) Settings.FarmCheckInterval = v end)

    createSectionHeader(autoContainer, "─── Сбор ───")
    createToggle(autoContainer, "Авто-сбор предметов", Settings.AutoCollect, function(v) Settings.AutoCollect = v end)
    createToggle(autoContainer, "Собирать капсулы", Settings.AutoCollectCapsules, function(v) Settings.AutoCollectCapsules = v end)
    createToggle(autoContainer, "Собирать кассеты", Settings.AutoCollectTapes, function(v) Settings.AutoCollectTapes = v end)
    createSlider(autoContainer, "Радиус сбора", 5, 30, 15, function(v) Settings.CollectRadius = v end)

    local teleportContainer = tabContents[3].frame
    createSectionHeader(teleportContainer, "─── Быстрая телепортация ───")
    createActionButton(teleportContainer, "📌 К ближайшему игроку", Color3.fromRGB(60, 60, 200), function()
        local target = findNearestPlayer()
        if target then
            local pos = getObjectPosition(target)
            if pos then
                safeTeleport(pos + Vector3.new(0, 3, 0))
                log("Телепорт к игроку: " .. target.Name, "info")
            end
        else
            log("Игроков рядом нет", "info")
        end
    end)

    createActionButton(teleportContainer, "👹 К ближайшему твистеду (высота)", Color3.fromRGB(200, 60, 60), function()
        local target = findNearestTwisted()
        if target then
            local pos = getObjectPosition(target)
            if pos then
                safeTeleport(pos + Vector3.new(0, 15, 0))
                log("Телепорт к твистеду на высоте", "info")
            end
        else
            log("Твистедов рядом нет", "info")
        end
    end)

    createActionButton(teleportContainer, "🔧 К ближайшему генератору", Color3.fromRGB(200, 180, 0), function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local fromPos = getObjectPosition(player.Character)
            if fromPos then
                local gen, dist = findNearestObject(ObjectCache.Generators, fromPos)
                if gen then
                    local pos = getObjectPosition(gen)
                    if pos then
                        safeTeleport(pos + Vector3.new(0, 2, 0))
                        log("Телепорт к генератору", "info")
                    end
                else
                    log("Генераторов рядом нет", "info")
                end
            end
        end
    end)

    createActionButton(teleportContainer, "🛗 В лифт", Color3.fromRGB(0, 180, 180), function()
        local elPos = getElevatorPosition()
        if elPos then
            safeTeleport(elPos + Vector3.new(0, 2, 0))
            log("Телепорт в лифт", "info")
        else
            log("Лифт не найден", "info")
        end
    end)

    createActionButton(teleportContainer, "🏠 В безопасное место (от твистедов)", Color3.fromRGB(0, 200, 100), function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local fromPos = getObjectPosition(player.Character)
            if fromPos then
                local safePos = fromPos + Vector3.new(0, 30, 0)
                safeTeleport(safePos)
                log("Телепорт в безопасное место", "info")
            end
        end
    end)

    local settingsContainer = tabContents[4].frame
    createSectionHeader(settingsContainer, "─── Движение ───")
    createSlider(settingsContainer, "Скорость", 0, 100, 16, function(v) Settings.SpeedValue = v end)
    createSlider(settingsContainer, "Прыжок", 0, 100, 50, function(v) Settings.JumpValue = v end)
    createToggle(settingsContainer, "Режим полёта", Settings.Fly, function(v) Settings.Fly = v end)
    createSlider(settingsContainer, "Скорость полёта", 10, 200, 50, function(v) Settings.FlySpeed = v end)

    createSectionHeader(settingsContainer, "─── Защита ───")
    createToggle(settingsContainer, "Ноклип", Settings.Noclip, function(v) Settings.Noclip = v end)
    createToggle(settingsContainer, "Полная яркость", Settings.FullBright, function(v) Settings.FullBright = v end)
    createToggle(settingsContainer, "Анти-АФК", Settings.AntiAFK, function(v) Settings.AntiAFK = v end)
    createToggle(settingsContainer, "Обход твистедов", Settings.AvoidTwisted, function(v) Settings.AvoidTwisted = v end)
    createSlider(settingsContainer, "Радиус обхода", 5, 30, 15, function(v) Settings.AvoidRadius = v end)

    createSectionHeader(settingsContainer, "─── Интерфейс ───")
    createToggle(settingsContainer, "Отладка (консоль)", Settings.DebugMode, function(v) Settings.DebugMode = v end)
    createToggle(settingsContainer, "Случайные задержки", Settings.RandomizeDelays, function(v) Settings.RandomizeDelays = v end)
    createSlider(settingsContainer, "Прозрачность меню", 0, 1, 0.2, function(v) Settings.MenuTransparency = v end)

    local infoContainer = tabContents[5].frame
    createSectionHeader(infoContainer, "─── Информация ───")
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.95, 0, 0, 80)
    infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    infoLabel.BackgroundTransparency = 0.5
    Instance.new("UICorner", infoLabel).CornerRadius = UDim.new(0, 8)
    infoLabel.Text = "Версия: 9.2\nАвтор: gdfdfgd43w2\nИгра: Dandy's World\nСкрипт оптимизирован для телефона\n\n👁️ ESP через Highlight\n🚀 Полёт через BodyVelocity"
    infoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.TextWrapped = true
    infoLabel.Parent = infoContainer

    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(0.95, 0, 0, 60)
    statsLabel.Position = UDim2.new(0, 0, 0, 90)
    statsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    statsLabel.BackgroundTransparency = 0.5
    Instance.new("UICorner", statsLabel).CornerRadius = UDim.new(0, 8)
    statsLabel.Text = "Объектов в кэше:\nТвистедов: 0\nГенераторов: 0\nПредметов: 0\nКапсул: 0"
    statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.TextSize = 13
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.TextYAlignment = Enum.TextYAlignment.Top
    statsLabel.TextWrapped = true
    statsLabel.Parent = infoContainer

    task.spawn(function()
        while true do
            task.wait(2)
            statsLabel.Text = string.format(
                "Объектов в кэше:\nТвистедов: %d\nГенераторов: %d\nПредметов: %d\nКапсул: %d\nКассет: %d\nДверей: %d\nИгроков: %d",
                #ObjectCache.Twisted, #ObjectCache.Generators, #ObjectCache.Items,
                #ObjectCache.Capsules, #ObjectCache.Tapes, #ObjectCache.Doors, #ObjectCache.Players
            )
        end
    end)

    -- Управление окном
    burger.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Settings.MenuKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Перетаскивание окна
    local drag = false
    local dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    drag = false
                end
            end)
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    log("GUI создан успешно", "info")
    return gui
end

-- =====================================================
-- ЧАСТЬ 4: РАБОЧИЕ ФУНКЦИИ (ESP, СКИЛЛЧЕК, АВТОФАРМ, АВТО-СБОР, НОКЛИП, FULLBRIGHT, СКОРОСТЬ/ПРЫЖОК, ЗАЩИТА ОТ ТВИСТЕДОВ)
-- =====================================================

local function setupESP()
    local player = game.Players.LocalPlayer
    if not player then return end

    local function createHighlight(color, name, distance)
        distance = distance or Settings.ESPDistance or 100
        local h = Instance.new("Highlight")
        h.Name = name
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.FillColor = color
        h.FillTransparency = Settings.ESPFillTransparency or 0.5
        h.OutlineTransparency = 1
        return h
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Highlight") and v.Name:match("ESP$") then
                v:Destroy()
            end
        end

        if not player or not player.Character then return end
        local fromPos = getObjectPosition(player.Character)
        if not fromPos then return end
        local maxDist = Settings.ESPDistance or 100

        if Settings.PlayerESP then
            for _, p in ipairs(ObjectCache.Players) do
                if p and p.Character then
                    local pos = getObjectPosition(p.Character)
                    if pos and (fromPos - pos).Magnitude <= maxDist then
                        local h = createHighlight(Settings.ESPColorPlayer or Color3.fromRGB(0,255,0), "PlayerESP")
                        h.Adornee = p.Character
                        h.Parent = p.Character
                    end
                end
            end
        end

        if Settings.TwistedESP then
            for _, tw in ipairs(ObjectCache.Twisted) do
                if tw then
                    local pos = getObjectPosition(tw)
                    if pos and (fromPos - pos).Magnitude <= maxDist then
                        local h = createHighlight(Settings.ESPColorTwisted or Color3.fromRGB(255,0,0), "TwistedESP")
                        h.Adornee = tw
                        h.Parent = tw
                    end
                end
            end
        end

        if Settings.GeneratorESP then
            for _, gen in ipairs(ObjectCache.Generators) do
                if gen then
                    local pos = getObjectPosition(gen)
                    if pos and (fromPos - pos).Magnitude <= maxDist then
                        local h = createHighlight(Settings.ESPColorGenerator or Color3.fromRGB(255,255,0), "GeneratorESP")
                        h.Adornee = gen
                        h.Parent = gen
                    end
                end
            end
        end

        if Settings.ItemESP then
            for _, item in ipairs(ObjectCache.Items) do
                if item then
                    local pos = getObjectPosition(item)
                    if pos and (fromPos - pos).Magnitude <= maxDist then
                        local h = createHighlight(Settings.ESPColorItem or Color3.fromRGB(0,255,255), "ItemESP")
                        h.Adornee = item
                        h.Parent = item
                    end
                end
            end
        end

        if Settings.CapsuleESP then
            for _, cap in ipairs(ObjectCache.Capsules) do
                if cap then
                    local pos = getObjectPosition(cap)
                    if pos and (fromPos - pos).Magnitude <= maxDist then
                        local h = createHighlight(Settings.ESPColorCapsule or Color3.fromRGB(255,0,255), "CapsuleESP")
                        h.Adornee = cap
                        h.Parent = cap
                    end
                end
            end
        end

        if Settings.ElevatorESP then
            local el = ObjectCache.Elevator
            if el then
                local pos = getObjectPosition(el)
                if pos and (fromPos - pos).Magnitude <= maxDist then
                    local h = createHighlight(Settings.ESPColorElevator or Color3.fromRGB(0,200,200), "ElevatorESP")
                    h.Adornee = el
                    h.Parent = el
                end
            end
        end

        if Settings.DoorESP then
            for _, door in ipairs(ObjectCache.Doors) do
                if door then
                    local pos = getObjectPosition(door)
                    if pos and (fromPos - pos).Magnitude <= maxDist then
                        local h = createHighlight(Settings.ESPColorDoor or Color3.fromRGB(200,200,0), "DoorESP")
                        h.Adornee = door
                        h.Parent = door
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    while task.wait(Settings.SkillCheckDelay or 0.05) do
        if not Settings.AutoSkillCheck then continue end
        local player = game.Players.LocalPlayer
        if not player then continue end
        local gui = player.PlayerGui
        if not gui then continue end

        local activeSkillChecks = {}
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("Frame") or child:IsA("ScreenGui") or child:IsA("ImageLabel") then
                local sc = child:FindFirstChild("SkillCheck", true) or
                           child:FindFirstChild("MiniGame", true) or
                           child:FindFirstChild("SkillCheckFrame", true) or
                           child:FindFirstChild("QuickTimeEvent", true)
                if sc and sc.Visible then
                    table.insert(activeSkillChecks, sc)
                end
            end
        end

        for _, sc in ipairs(activeSkillChecks) do
            local btn = sc:FindFirstChild("Button") or sc:FindFirstChild("Click") or sc:FindFirstChild("SkillCheckButton") or sc:FindFirstChild("ActionButton")
            if btn and btn:IsA("TextButton") then
                pcall(function()
                    btn:FireServer()
                    btn:Click()
                    log("Скиллчек (кнопка) пройден", "debug")
                end)
            end

            local circle = sc:FindFirstChild("Circle") or sc:FindFirstChild("SkillCheckCircle") or sc:FindFirstChild("Zone") or sc:FindFirstChild("TargetZone")
            if circle and circle:IsA("Frame") then
                pcall(function()
                    local rs = game:GetService("ReplicatedStorage")
                    local ev = rs:FindFirstChild("SkillCheckPass") or rs:FindFirstChild("PassSkillCheck") or rs:FindFirstChild("CompleteSkillCheck") or rs:FindFirstChild("CompleteMiniGame")
                    if ev then
                        ev:FireServer()
                        log("Скиллчек (круг) пройден", "debug")
                    end
                end)
            end

            local slider = sc:FindFirstChild("Slider") or sc:FindFirstChild("ProgressBar") or sc:FindFirstChild("HoldBar")
            if slider and slider:IsA("Frame") then
                pcall(function()
                    local rs = game:GetService("ReplicatedStorage")
                    local ev = rs:FindFirstChild("SkillCheckHold") or rs:FindFirstChild("HoldSkillCheck") or rs:FindFirstChild("HoldComplete")
                    if ev then
                        ev:FireServer()
                        log("Скиллчек (ползунок) пройден", "debug")
                    end
                end)
            end

            local anyButton = sc:FindFirstChildWhichIsA("TextButton")
            if anyButton and anyButton ~= btn then
                pcall(function()
                    anyButton:FireServer()
                    anyButton:Click()
                    log("Скиллчек (альтернативная кнопка) пройден", "debug")
                end)
            end
        end
    end
end)

local farm = {
    active = false,
    step = 0,
    idx = 1,
    isRepairing = false,
    timer = 0
}

local function isGeneratorRepairing(gen)
    if not gen then return false end
    for _, child in ipairs(gen:GetDescendants()) do
        if child:IsA("Sound") and child.IsPlaying then
            return true
        end
        if child:IsA("AnimationTrack") and child.IsPlaying then
            return true
        end
        if child:IsA("BasePart") and child.Material == Enum.Material.Neon then
            return true
        end
    end
    return false
end

local function getGeneratorState(gen)
    if not gen then return "unknown" end
    for _, child in ipairs(gen:GetDescendants()) do
        if child:IsA("BasePart") and child.Material == Enum.Material.Neon then
            return "completed"
        end
    end
    return "pending"
end

task.spawn(function()
    while true do
        task.wait(Settings.FarmCheckInterval or 1)

        if not Settings.AutoFarm then
            if farm.active then
                farm.active = false
                log("Автофарм остановлен", "info")
            end
            continue
        end

        if farm.active then
            local player = game.Players.LocalPlayer
            if not player or not player.Character then
                task.wait(1)
                continue
            end

            local root = player.Character:FindFirstChild("HumanoidRootPart") or player.Character.PrimaryPart
            if not root then
                task.wait(1)
                continue
            end

            local gens = ObjectCache.Generators
            if #gens == 0 then
                log("Генераторы не найдены", "warning")
                farm.active = false
                continue
            end

            local gen = gens[farm.idx]
            if not gen then
                if Settings.FarmAutoElevator then
                    local elPos = getElevatorPosition()
                    if elPos then
                        if (root.Position - elPos).Magnitude > 5 then
                            safeTeleport(elPos)
                            task.wait(Settings.FarmElevatorWait or 2)
                        end
                        local el = ObjectCache.Elevator
                        if el then
                            safeInteract(el)
                            log("Лифт активирован", "info")
                        end
                    end
                end
                farm.active = false
                log("Все генераторы починены", "info")
                continue
            end

            local genPos = getObjectPosition(gen)
            if not genPos then
                task.wait(1)
                continue
            end

            local state = getGeneratorState(gen)
            if state == "completed" then
                farm.idx = farm.idx + 1
                farm.step = 0
                continue
            end

            if farm.step == 0 then
                if (root.Position - genPos).Magnitude > 5 then
                    safeTeleport(genPos + Vector3.new(0, 2, 0))
                else
                    farm.step = 1
                end
            elseif farm.step == 1 then
                safeInteract(gen)
                farm.isRepairing = true
                farm.step = 2
                log("Начало ремонта генератора #" .. farm.idx, "debug")
            elseif farm.step == 2 then
                if isGeneratorRepairing(gen) then
                    farm.step = 3
                else
                    safeInteract(gen)
                    task.wait(0.5)
                end
            elseif farm.step == 3 then
                if getGeneratorState(gen) == "completed" then
                    farm.step = 4
                    log("Генератор #" .. farm.idx .. " починен", "info")
                else
                    if not isGeneratorRepairing(gen) then
                        farm.step = 1
                    end
                    task.wait(0.3)
                end
            elseif farm.step == 4 then
                if Settings.FarmUseSkyJump then
                    safeTeleport(genPos + Vector3.new(0, Settings.FarmSkyHeight or 30, 0))
                    task.wait(1)
                    safeTeleport(genPos + Vector3.new(0, 2, 0))
                    task.wait(0.5)
                end
                farm.idx = farm.idx + 1
                farm.step = 0
                farm.isRepairing = false
            end
            task.wait(Settings.FarmTeleportDelay or 0.3)
        else
            if Settings.AutoFarm and not farm.active then
                local gens = ObjectCache.Generators
                if #gens > 0 then
                    farm.active = true
                    farm.idx = 1
                    farm.step = 0
                    farm.isRepairing = false
                    log("Автофарм запущен. Найдено генераторов: " .. #gens, "info")
                else
                    log("Нет генераторов для фарма", "warning")
                end
            end
        end
    end
end)

task.spawn(function()
    local noclipEnabled = false
    while task.wait(0.05) do
        local currentState = Settings.Noclip
        if currentState and not noclipEnabled then
            noclipEnabled = true
            log("Ноклип активирован", "info")
        elseif not currentState and noclipEnabled then
            noclipEnabled = false
            log("Ноклип деактивирован", "info")
        end

        if noclipEnabled then
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

task.spawn(function()
    local lighting = game:GetService("Lighting")
    while task.wait(0.5) do
        if Settings.FullBright then
            lighting.Brightness = Settings.FullBrightBrightness or 2
            lighting.ClockTime = Settings.FullBrightTime or 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Settings.FullBrightAmbient or Color3.fromRGB(128, 128, 128)
        else
            lighting.Brightness = 0.5
            lighting.ClockTime = 0
            lighting.FogEnd = 1000
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                if Settings.SpeedEnabled then
                    local speed = math.clamp(Settings.SpeedValue or 16, 0, Settings.MaxSpeed or 100)
                    if hum.WalkSpeed ~= speed then
                        hum.WalkSpeed = speed
                    end
                end
                if Settings.JumpEnabled then
                    local jump = math.clamp(Settings.JumpValue or 50, 0, Settings.MaxJump or 100)
                    if hum.JumpPower ~= jump then
                        hum.JumpPower = jump
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if not Settings.AutoCollect then continue end

        local player = game.Players.LocalPlayer
        if not player or not player.Character then continue end

        local root = player.Character:FindFirstChild("HumanoidRootPart") or player.Character.PrimaryPart
        if not root then continue end

        local fromPos = root.Position
        local radius = Settings.CollectRadius or 15

        if Settings.AutoCollectItems then
            for _, item in ipairs(ObjectCache.Items) do
                local pos = getObjectPosition(item)
                if pos and (fromPos - pos).Magnitude <= radius then
                    safeTeleport(pos + Vector3.new(0, 2, 0))
                    task.wait(Settings.CollectTeleportDelay or 0.1)
                    safeInteract(item)
                    log("Предмет собран", "debug")
                    break
                end
            end
        end

        if Settings.AutoCollectCapsules then
            for _, cap in ipairs(ObjectCache.Capsules) do
                local pos = getObjectPosition(cap)
                if pos and (fromPos - pos).Magnitude <= radius then
                    safeTeleport(pos + Vector3.new(0, 2, 0))
                    task.wait(Settings.CollectTeleportDelay or 0.1)
                    safeInteract(cap)
                    log("Капсула собрана", "debug")
                    break
                end
            end
        end

        if Settings.AutoCollectTapes then
            for _, tape in ipairs(ObjectCache.Tapes) do
                local pos = getObjectPosition(tape)
                if pos and (fromPos - pos).Magnitude <= radius then
                    safeTeleport(pos + Vector3.new(0, 2, 0))
                    task.wait(Settings.CollectTeleportDelay or 0.1)
                    safeInteract(tape)
                    log("Кассета собрана", "debug")
                    break
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(Settings.AvoidCheckInterval or 0.5) do
        if not Settings.AvoidTwisted then continue end

        local player = game.Players.LocalPlayer
        if not player or not player.Character then continue end

        local root = player.Character:FindFirstChild("HumanoidRootPart") or player.Character.PrimaryPart
        if not root then continue end

        local fromPos = root.Position
        local radius = Settings.AvoidRadius or 15
        local nearest, dist = findNearestObject(ObjectCache.Twisted, fromPos)

        if nearest and dist and dist < radius then
            local pos = getObjectPosition(nearest)
            if pos then
                local direction = (fromPos - pos).Unit
                local safePos = fromPos + direction * (radius + 5)

                if Settings.AvoidMode == "teleport" then
                    safeTeleport(safePos + Vector3.new(0, 2, 0))
                    log("Уход от твистеда (телепорт)", "debug")
                elseif Settings.AvoidMode == "fly_up" then
                    safeTeleport(fromPos + Vector3.new(0, 20, 0))
                    log("Уход от твистеда (вверх)", "debug")
                elseif Settings.AvoidMode == "walk_away" then
                    task.spawn(function()
                        for i = 1, 5 do
                            if not Settings.AvoidTwisted then break end
                            local currentPos = getObjectPosition(player.Character)
                            if currentPos then
                                local dir = (currentPos - pos).Unit
                                teleportTo(currentPos + dir * 2)
                                task.wait(0.1)
                            end
                        end
                    end)
                    log("Уход от твистеда (пешком)", "debug")
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(Settings.AntiAFKInterval or 60) do
        if not Settings.AntiAFK then continue end

        local interval = Settings.AntiAFKInterval or 60
        if Settings.AntiAFKRandomize then
            interval = math.random(interval - 10, interval + 10)
        end

        pcall(function()
            local vim = game:GetService("VirtualInputManager")
            if vim then
                vim:SendKeyEvent(true, Enum.KeyCode.Space, false, nil)
                task.wait(0.1)
                vim:SendKeyEvent(false, Enum.KeyCode.Space, false, nil)
                log("Анти-АФК: отправлен сигнал", "debug")
            else
                local player = game.Players.LocalPlayer
                if player and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local pos = root.Position
                        teleportTo(pos + Vector3.new(0, 0.5, 0))
                        task.wait(0.1)
                        teleportTo(pos)
                        log("Анти-АФК: движение", "debug")
                    end
                end
            end
        end)
    end
end)

local fly = {
    active = false,
    speed = 50,
    bodyVelocity = nil,
    bodyGyro = nil
}

task.spawn(function()
    while task.wait(0.1) do
        if Settings.Fly and not fly.active then
            local char = game.Players.LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    fly.active = true
                    fly.speed = Settings.FlySpeed or 50

                    fly.bodyVelocity = Instance.new("BodyVelocity")
                    fly.bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    fly.bodyVelocity.Parent = root

                    fly.bodyGyro = Instance.new("BodyGyro")
                    fly.bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                    fly.bodyGyro.CFrame = root.CFrame
                    fly.bodyGyro.Parent = root

                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.PlatformStand = true
                    end
                    log("Режим полёта активирован", "info")
                end
            end
        elseif not Settings.Fly and fly.active then
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
            log("Режим полёта деактивирован", "info")
        end

        if fly.active and fly.bodyVelocity then
            local char = game.Players.LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local moveDir = Vector3.new(0, 0, 0)
                    local speed = fly.speed
                    local camera = workspace.CurrentCamera

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

                    fly.bodyGyro.CFrame = CFrame.new(root.Position, root.Position + camera.CFrame.LookVector)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if Settings.DebugMode then
            log(string.format(
                "Статус: ESP=%s, Скиллчек=%s, Фарм=%s, Сбор=%s, Ноклип=%s, Полёт=%s",
                tostring(Settings.PlayerESP or Settings.TwistedESP or Settings.GeneratorESP or Settings.ItemESP or Settings.CapsuleESP),
                tostring(Settings.AutoSkillCheck),
                tostring(Settings.AutoFarm and farm.active),
                tostring(Settings.AutoCollect),
                tostring(Settings.Noclip),
                tostring(Settings.Fly and fly.active)
            ), "debug")
        end
    end
end)

log("Все рабочие функции загружены", "info")

-- =====================================================
-- ЧАСТЬ 5: ФИНАЛЬНАЯ СБОРКА (ЗАПУСК, ГОРЯЧИЕ КЛАВИШИ, ИНИЦИАЛИЗАЦИЯ)
-- =====================================================

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Settings.TeleportKeyPlayer or input.KeyCode == Enum.KeyCode.F then
        if Settings.TeleportToPlayers then
            local target = findNearestPlayer()
            if target then
                local pos = getObjectPosition(target)
                if pos then
                    safeTeleport(pos + Vector3.new(0, 3, 0))
                    log("Телепорт к игроку: " .. target.Name, "info")
                end
            else
                log("Игроков рядом нет", "info")
            end
        end
    end

    if input.KeyCode == Settings.TeleportKeyTwisted or input.KeyCode == Enum.KeyCode.G then
        if Settings.TeleportToTwisted then
            local target = findNearestTwisted()
            if target then
                local pos = getObjectPosition(target)
                if pos then
                    safeTeleport(pos + Vector3.new(0, 15, 0))
                    log("Телепорт к твистеду на высоте", "info")
                end
            else
                log("Твистедов рядом нет", "info")
            end
        end
    end

    if input.KeyCode == Settings.TeleportKeyGenerator or input.KeyCode == Enum.KeyCode.H then
        if Settings.TeleportToGenerator then
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local fromPos = getObjectPosition(player.Character)
                if fromPos then
                    local gen, dist = findNearestObject(ObjectCache.Generators, fromPos)
                    if gen then
                        local pos = getObjectPosition(gen)
                        if pos then
                            safeTeleport(pos + Vector3.new(0, 2, 0))
                            log("Телепорт к генератору", "info")
                        end
                    else
                        log("Генераторов рядом нет", "info")
                    end
                end
            end
        end
    end

    if input.KeyCode == Settings.TeleportKeyElevator or input.KeyCode == Enum.KeyCode.T then
        if Settings.TeleportToElevator then
            local elPos = getElevatorPosition()
            if elPos then
                safeTeleport(elPos + Vector3.new(0, 2, 0))
                log("Телепорт в лифт", "info")
            else
                log("Лифт не найден", "info")
            end
        end
    end

    if input.KeyCode == Settings.TeleportKeyItem or input.KeyCode == Enum.KeyCode.Y then
        if Settings.TeleportToItem then
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local fromPos = getObjectPosition(player.Character)
                if fromPos then
                    local item, dist = findNearestObject(ObjectCache.Items, fromPos)
                    if item then
                        local pos = getObjectPosition(item)
                        if pos then
                            safeTeleport(pos + Vector3.new(0, 2, 0))
                            log("Телепорт к предмету", "info")
                        end
                    else
                        log("Предметов рядом нет", "info")
                    end
                end
            end
        end
    end

    if input.KeyCode == Settings.TeleportKeyCapsule or input.KeyCode == Enum.KeyCode.U then
        if Settings.TeleportToCapsule then
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local fromPos = getObjectPosition(player.Character)
                if fromPos then
                    local cap, dist = findNearestObject(ObjectCache.Capsules, fromPos)
                    if cap then
                        local pos = getObjectPosition(cap)
                        if pos then
                            safeTeleport(pos + Vector3.new(0, 2, 0))
                            log("Телепорт к капсуле", "info")
                        end
                    else
                        log("Капсул рядом нет", "info")
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(10)
        if Settings.EnableScript then
            local gui = game.Players.LocalPlayer:FindFirstChild("DandyWorldGUI")
            if not gui then
                log("GUI потерян, пересоздаём...", "warning")
                createUI()
            end
        end
    end
end)

local function initialize()
    log("Инициализация скрипта v9.2...", "info")
    createUI()
    setupESP()
    log("Скрипт полностью загружен!", "info")
    log("Управление: ☰ - меню, F - телепорт к игроку, G - телепорт к твистеду", "info")
    log("Полёт: WASD + Пробел/Shift (включите в меню)", "info")
end

local success, err = pcall(initialize)
if not success then
    log("Ошибка при инициализации: " .. tostring(err), "error")
    task.wait(5)
    pcall(initialize)
end

_G.RestartScript = function()
    log("Перезапуск скрипта...", "info")
    local gui = game.Players.LocalPlayer:FindFirstChild("DandyWorldGUI")
    if gui then gui:Destroy() end
    task.wait(1)
    initialize()
end

log("✅ Dandy World v9.2 полностью загружен! Используйте _G.RestartScript() для перезапуска.", "info")
