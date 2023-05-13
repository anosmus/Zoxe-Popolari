ESX = exports.es_extended:getSharedObject()


RegisterServerEvent('CasePopolari:acquista')
AddEventHandler('CasePopolari:acquista', function(value)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Prezzo = 100 -- Prezzo chiave casaa popolare

    if value == 'chiave' then
        if xPlayer.getMoney() >= Prezzo then
            xPlayer.removeMoney(Prezzo)
            xPlayer.addInventoryItem('casa', 1)
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'success', description = 'Hai Comprato Un Mazzo Di Chiavi Per: ' .. Prezzo .. '$'})
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, {type = 'error', description = 'Non Hai Abbastanza Soldi!'})
        end
    end
end)

for k, v in pairs(Popolari.Case) do 
    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
            Wait(0)
            exports.ox_inventory:RegisterStash(k, 'Deposito', v.MaxSlots, v.MaxWeight)
        end
    end)
end

RegisterServerEvent('entraincasa')
AddEventHandler('entraincasa', function()
    SetPlayerRoutingBucket(source, source)
end)

RegisterServerEvent('escidallacasa')
AddEventHandler('escidallacasa', function()
    SetPlayerRoutingBucket(source, 0)
end)
