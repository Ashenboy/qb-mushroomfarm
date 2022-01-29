QBCore = nil 
QBCore = exports['qb-core']:GetCoreObject() 

local hasjob = false
local mushrooms = 0
local coordonate = Config.coordonate
local sleep = 2000
local CollectingTime = Config.CollectingTime


Citizen.CreateThread(function()
	while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(0)
    end
end)

function DrawText3D(x,y,z, text, scl) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

CreateThread(function()
	local blip = AddBlipForCoord(Config.MushroomShoplocation["x"],Config.MushroomShoplocation["y"],Config.MushroomShoplocation["z"])
	SetBlipSprite(blip, 124)
	SetBlipAsShortRange(blip, true)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 49)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Mushroom Shop")
	EndTextCommandSetBlipName(blip)
end)
CreateThread(function()
    local blip = AddBlipForCoord(Config.MushroomFarmlocation["x"],Config.MushroomFarmlocation["y"],Config.MushroomFarmlocation["z"])
    SetBlipSprite(blip, 124)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 49)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mushroom Farm")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(sleep)
        perform = false
        local pos = GetEntityCoords(PlayerPedId())
        local metrii = math.floor(GetDistanceBetweenCoords(Config.MushroomShoplocation["x"],Config.MushroomShoplocation["y"],Config.MushroomShoplocation["z"], GetEntityCoords(PlayerPedId())))
        if mushrooms == 6 then
            perform = true
            DrawText3D(pos.x,pos.y,pos.z, "~y~Go and Sell Mushrooms", 1)
        end
        if hasjob == true then
            for i,v in pairs(coordonate) do
                local metrii2 = math.floor(GetDistanceBetweenCoords(v[1],v[2],v[3], GetEntityCoords(PlayerPedId())))
                if mushrooms == 1 or mushrooms == 2 or mushrooms == 3 or mushrooms == 4 or mushrooms == 5 then
                    perform = true
                    DrawText3D(pos.x,pos.y,pos.z, "Mushrooms ~r~"..mushrooms.."~w~/~g~6", 1)
                end
                if coordonate[i] ~= nil then
                    if metrii2 <=1 then
                        perform = true
                        DrawText3D(v[1],v[2],v[3]+0.7, "Press ~y~[E]~w~ to collect mushrooms.", 1)
                        if IsControlJustPressed(1,51) then
                            table.remove(coordonate,i)
                            local playerPed = PlayerPedId()
                            TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_PARKING_METER', 0, false)
                            SetTimeout(CollectingTime, function()
                            ClearPedTasks(playerPed)
                            QBCore.Functions.Notify("You have collected a mushroom.", "success")
                            mushrooms = mushrooms + 1
                                if mushrooms == 6 then
                                    SetNewWaypoint(Config.MushroomShoplocation["x"],Config.MushroomShoplocation["y"],Config.MushroomShoplocation["z"])
                                end
                            end)
                        end
                    end
                else
                    perform = true
                    DrawText3D(coordonate[i]+0.7, "The mushroom has already been collected.", 1)
                end
            end
        end
        if metrii <= 2 then
            perform = true 
            DrawText3D(pos.x,pos.y,pos.z+0.6, "Press ~y~[E]~w~ to get mushroom basket.\n Press ~y~[Y]~w~ to sell mushrooms.", 1)
            if IsControlJustPressed(1,51) then
                if hasjob == false then
                cosdeoua = CreateObject(GetHashKey("prop_fruit_basket"), pos.x, pos.y, pos.z,  true,  true, true)
                AttachEntityToEntity(cosdeoua, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.22, -0.3+0.25, 0.0+0.16, 160.0, 90.0, 125.0, true, true, false, true, 1, true)
                QBCore.Functions.Notify("You're hired!", "success")

                hasjob = true
                SetNewWaypoint(Config.MushroomFarmlocation["x"],Config.MushroomFarmlocation["y"],Config.MushroomFarmlocation["z"])
                for i,v in pairs(coordonate) do
                    cvprop = CreateObject(GetHashKey('prop_stoneshroom1'), v[1],v[2],v[3], false)
                end
                elseif hasjob == true then
                    QBCore.Functions.Notify("You have already been hired as a Mushroom Farmer.", "success")
                end
            elseif IsControlJustPressed(1,246) then
                if mushrooms == 6 then
                TriggerServerEvent("qb-mushroomfarmer:sell")
                mushrooms = 0
                hasjob = false
                DeleteEntity(cosdeoua)
                DeleteEntity(cosdeoua)
                else
                    QBCore.Functions.Notify("Do not be silly.", "success")
                end
            end
        end
        if perform then
            sleep = 7
        elseif not perform then
            sleep = 2000
        end
    end
end)