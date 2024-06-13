


-----База энтити-----
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
    self:SetModel('models/weapons/w_shotgun.mdl');
    self:PhysicsInit(SOLID_VPHYSICS);

    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetSolid(SOLID_VPHYSICS);
    self:SetUseType(SIMPLE_USE)

    self:GetPhysicsObject():SetMass(10);
    self:SetAngles(Angle(0, 180, 90))


    if self:GetPhysicsObject():IsValid() then self:GetPhysicsObject():Wake() end

end


function ENT:AcceptInput(name, ply, caller)
    print('')
end






-----Функции-----

util.AddNetworkString('WeaponUp')


function ENT:Use(activator, caller)
    
    if activator:IsPlayer() then --- Поднимает оружие с задержкой 1.5 сек

        local Pick = true --- Отправка ключа-переменной на клиентскую часть
        net.Start('WeaponUp')
            net.WriteBool(Pick)
        net.Broadcast()

        timer.Simple(1.5, function() --- Спустя 1.5 секунды выдает оружие, боеприпасы и удаляется
        activator:Give('weapon_shotgun')
        activator:SetAmmo(24, 7)
        self:Remove() 

        end)
    end    
end

function ENT:Think()
end


local function DropWeapons(ply, text) --- Выкидывание оружия перед игроком при команде !drop в чат

    if string.lower(text) == '!drop' then
        local ActiveWeapon = ply:GetActiveWeapon():GetClass()
        ply:StripWeapon(ActiveWeapon)
        
        if ActiveWeapon == 'weapon_shotgun' then  
            local m3 = ents.Create('m3')

            m3:EmitSound('weapon_drop')

            local pos = ply:GetShootPos()
            local ang = ply:EyeAngles()
            local forward = ang:Forward() --- Берет вектор впереди направления взгляда
            local distance = 50 --- Настраиваемая дистанция спавна от лица игрока
            
            m3:SetPos(pos + forward * distance)
            m3:Spawn()

        end
    end
end

hook.Add('PlayerSay', 'DropWeapon', DropWeapons)