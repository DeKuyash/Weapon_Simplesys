


-----Добавление звуков-----
sound.Add({ name = "weapon_up", channel = CHAN_STATIC, volume = 0, level = 80, pitch = {70, 71}, sound = "weapon_up.wav"})

sound.Add( { name = "weapon_drop", channel = CHAN_STATIC, volume = 0, level = 80, pitch = {85, 90}, sound = "weapon_drop.wav"})



-----Создание шрифта-----
surface.CreateFont('HUDFont', {font = 'Default', size = 24, weight = 54 } ) 




-----Функции-----

local function WeaponUpProgressBar() --- Функция отрисовки прогресс-бара и текста

    draw.SimpleText('Поднятие оружия...', 'HUDFont', 990, 528, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.RoundedBox(4, 990, 553, 183, 10, Color (255, 255, 255, 200)) --- Строка прогресс-бара
    draw.RoundedBox(4, 990, 553, math.Clamp(progressbar, 1, 183), 10, Color (0, 161, 255, 200))  --- Заполнение строки прогресс-бара

    hook.Add("Think", "UpdateValueHook", function() --- Каждый кадр /продвигает/ прогресс-бар
    if progressbar < 183 then progressbar = progressbar + 1.25  

        end       
    end) 
end





net.Receive('WeaponUp', function() --- Работает после получения со стороны сервера (энтити) boolean переменной
    local Pick = net.ReadBool() --- Переменная-ключ
    local ply = LocalPlayer()

    if Pick == true then --- Если игрок использует энтити — воспроизведение звука, отображение худа
        ply:EmitSound('weapon_up')
        progressbar = 0
        hook.Add('HUDPaint', 'WeaponUpProgressBar', WeaponUpProgressBar)
        timer.Simple(1.5, function() hook.Remove('HUDPaint', 'WeaponUpProgressBar') end)

    end
end)




