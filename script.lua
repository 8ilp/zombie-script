-- استخدام مكتبة واجهات Fluent
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- إنشاء النافذة الرئيسية
local Window = Fluent:CreateWindow({
    Title = "Zombie Arena Hack 🧟‍♂️",
    SubTitle = "بواسطة الأسطورة",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 420), -- زيادة الحجم لتناسب الخيارات الجديدة
    Acrylic = true,
    Theme = "Dark"
})

-- إضافة قسم الميزات
local Tabs = {
    Main = Window:AddTab({ Title = "الميزات الرئيسية", Icon = "home" })
}

-- المتغيرات الأساسية للتحكم بالسكربت
getgenv().KillAll = false
getgenv().SafePlace = false
getgenv().AutoBuy = false
getgenv().AutoUpgrade = false

-- 1. زر منع الطرد للخمول (Anti-AFK) - يتم تفعيله تلقائياً أو عبر الزر
Tabs.Main:AddToggle("AntiAFKToggle", {
    Title = "منع الطرد للخمول (Anti-AFK)",
    Default = true,
    Callback = function(Value)
        getgenv().AntiAFK = Value
        if Value then
            Fluent:Notify({ Title = "Zombie Script", Text = "ميزة الحماية من الطرد تعمل الآن", Duration = 3 })
        end
    end
})

-- 2. زر الانتقال لمكان آمن (Safe Place / Float)
Tabs.Main:AddToggle("SafePlaceToggle", {
    Title = "مكان آمن فوق السماء (Safe Mode)",
    Default = false,
    Callback = function(Value)
        getgenv().SafePlace = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if rootPart then
            if Value then
                -- رفع اللاعب مسافة 500 مسمار في الهواء فوق مكانه الحالي
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 500, 0)
                task.wait(0.1)
                -- تثبيت الحركة لعدم السقوط بفعل الجاذبية
                rootPart.Anchored = true
                Fluent:Notify({ Title = "Zombie Script", Text = "أنت في مكان آمن الآن! ☁️", Duration = 3 })
            else
                -- إلغاء التثبيت لإعادة اللاعب للأرض
                rootPart.Anchored = false
                Fluent:Notify({ Title = "Zombie Script", Text = "تمت العودة للأرض", Duration = 3 })
            end
        end
    end
})

-- 3. زر قتل جميع الزومبي تلقائياً
Tabs.Main:AddToggle("KillAllToggle", {
    Title = "قتل جميع الزومبي (Kill All)",
    Default = false,
    Callback = function(Value)
        getgenv().KillAll = Value
        if Value then
            Fluent:Notify({ Title = "Zombie Script", Text = "تم تفعيل إبادة الزومبي! 🔥", Duration = 3 })
        end
    end
})

-- 4. زر تشغيل وإيقاف الشراء التلقائي
Tabs.Main:AddToggle("AutoBuyToggle", {
    Title = "شراء تلقائي (Auto Buy)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBuy = Value
    end
})

-- 5. زر تشغيل وإيقاف الترقية التلقائية
Tabs.Main:AddToggle("AutoUpgradeToggle", {
    Title = "ترقية تلقائية (Auto Upgrade)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoUpgrade = Value
    end
})

-- ==================== الأكواد البرمجية الخلفية (Loops) ====================

-- كود الحماية من الـ AFK (Anti-AFK)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        if getgenv().AntiAFK ~= false then
            vu:Button2Down(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), game.Workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- كود قتل الزومبي التلقائي (Kill All)
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().KillAll then
            pcall(function()
                for _, enemy in pairs(game:GetService("Workspace"):GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Name ~= game.Players.LocalPlayer.Name then
                        enemy.Humanoid.Health = 0
                    end
                end
            end)
        end
    end
end)

-- كود الشراء الافتراضي
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoBuy then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.BuyItem:FireServer("Pistol")
            end)
        end
    end
end)

-- كود الترقية الافتراضي
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoUpgrade then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Upgrade:FireServer()
            end)
        end
    end
end)

-- إشعار الترحيب
Fluent:Notify({
    Title = "مرحباً بك!",
    Text = "تمت إضافة ميزات الـ Anti-AFK والمكان الآمن بنجاح.",
    Duration = 5
})
