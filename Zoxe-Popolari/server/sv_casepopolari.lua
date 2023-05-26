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

------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
local resourceName = "Zoxe-Popolari"

CreateThread(function()
    if GetCurrentResourceName() ~= resourceName then
        resourceName = "Zoxe-Popolari (" .. GetCurrentResourceName() .. ")"
    end
end)

CreateThread(function()
    while true do
        PerformHttpRequest("https://api.github.com/repos/anosmus/"..resourceName.."/releases/latest", versionCheck, "GET")
        Wait(3600000)
    end
end)

function versionCheck(err, responseText, headers)
    local latestVersion, URL, body = getLatestInformations()
    CreateThread(function()
        if currentVersion ~= latestVersion then
            Wait(1000)
            print("^0[^6ALERT^0] ^1AN UPDATE IS AVAILABLE")
            print("^0[^6ALERT^0] Your Version: ^6" .. currentVersion .. "^0")
            print("^0[^6ALERT^0] Latest Version: ^6" .. latestVersion .. "^0")
            print("^0[^6ALERT^0] Get the latest Version from: ^3" .. URL .. "^0")
        else
            Wait(4000)
            print("^0[^6INFO^0] " .. resourceName .. " is up to date! (^6" .. currentVersion .. "^0)")
        end
    end)
end

function getLatestInformations()
    local latestVersion, URL, body = nil, nil, nil
    PerformHttpRequest("https://api.github.com/repos/anosmus/"..resourceName.."/releases/latest", function(err, response, headers)
        if err == 200 then
            local data = json.decode(response)
            latestVersion = data.tag_name
            URL = data.html_url
            body = data.body
        else
            latestVersion = currentVersion
            URL = "https://github.com/anosmus/"..resourceName
        end
    end, "GET")
    repeat
        Wait(50)
    until (latestVersion and URL and body)
    return latestVersion, URL, body
end