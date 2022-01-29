QBCore = nil 
QBCore = exports['qb-core']:GetCoreObject() 
local minpayout = 500
local maxpayout = 600
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent("qb-mushroomfarmer:sell")
AddEventHandler("qb-mushroomfarmer:sell", function()
    local xPlayer  = QBCore.Functions.GetPlayer(source)
    local payout = math.random(minpayout,maxpayout)
      xPlayer.Functions.AddMoney("cash", payout, "sold-mushrooms")
      TriggerClientEvent('QBCore:Notify', source, 'You earnd ' ..payout.. '$ from selling mushrooms.', "success")
end)