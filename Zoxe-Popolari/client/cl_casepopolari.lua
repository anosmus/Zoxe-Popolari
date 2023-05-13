ESX = exports["es_extended"]:getSharedObject()

local VenditaNpc = nil

-- BLIP GOVERNO -- 
Blip = AddBlipForCoord(470.08, -1564.24, 28.28)

SetBlipSprite(Blip, 475)
SetBlipScale(Blip, 0.8)
SetBlipColour(Blip, 56)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Case Popolari")
EndTextCommandSetBlipName(Blip)


Citizen.CreateThread(function() -- PED PER LA CREAZIONE DELLE CHIAVI
    if not HasModelLoaded('cs_mrk') then
       RequestModel('cs_mrk')
       while not HasModelLoaded('cs_mrk') do
          Citizen.Wait(5)
       end
    end

    Npc = CreatePed(4, 'cs_mrk', 470.08, -1564.24, 28.28, 196.12, false, true)
    FreezeEntityPosition(Npc, true)
    SetEntityInvincible(Npc, true)
    SetBlockingOfNonTemporaryEvents(Npc, true)

    local VenditaNpc = false
    local Opzioni = {
        
        {
            name = 'Chiave',
            event = 'CasePopolari:acquista',
            icon = 'fa-solid fa-key',
            label = 'Chiave',
            --groups = 'immobiliare',
            canInteract = function(entity)
                return not IsEntityDead(entity)
            end
        }
    }

    exports.ox_target:addLocalEntity(Npc, Opzioni)

end)

RegisterNetEvent('CasePopolari:acquista')
AddEventHandler('CasePopolari:acquista', function(value)
    VenditaNpc = value
end)

RegisterNetEvent('CasePopolari:acquista') 
AddEventHandler('CasePopolari:acquista', function()
    local Ped = PlayerPedId()
    local input = lib.inputDialog('Tecnocasa', {
        {type = 'select', label = '🏡 - Case', options = {
        {label = "🔑 - MAZZO CHIAVI, 100$", value = "chiave"},
        }},
    })
    
    if input and #input > 0 then
        TriggerServerEvent('CasePopolari:acquista', input[1])
    end
end)

for k, v in pairs(Popolari.Case) do 

    exports.ox_target:addBoxZone({
        coords = v.Join,
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'Entra',
                icon = 'fa-solid fa-house',
                label = Popolari.Traduzione["entra"],
                onSelect = function(data)

                    if HasKey("casa") then -- Item 
                        DoScreenFadeOut(800)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(0)
                        end
                        TriggerServerEvent('entraincasa')
                        SetEntityCoords(PlayerPedId(), v.Interior)
                        DoScreenFadeIn(800)
                    else
                        -- Mostra un messaggio di errore se il giocatore non ha la chiave
                        lib.notify({
                            title = 'Casa Popolare',
                            description = 'Non hai la chiave. Dirigiti al governo!',
                            type = 'error'
                        })
                        
                    end
                end,
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = v.Interior,
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'Entra',
                icon = 'fa-solid fa-house',
                label = Popolari.Traduzione["esci"],
                onSelect = function(data)

                    if HasKey("casa") then -- Item 
                        DoScreenFadeOut(800)
                        while not IsScreenFadedOut() do
                            Citizen.Wait(0)
                        end
                        TriggerServerEvent('escidallacasa')
                        SetEntityCoords(PlayerPedId(), v.Join)
                        DoScreenFadeIn(800)
                    else
                        -- Mostra un messaggio di errore se il giocatore non ha la chiave
                        lib.notify({
                            title = 'Casa Popolare',
                            description = 'Non hai la chiave. Dirigiti al governo!',
                            type = 'error'
                        })
                        
                    end
                end,
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = v.Inv,
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'Inv',
                icon = 'fa-solid fa-box-archive',
                label = Popolari.Traduzione["inventario"],
                onSelect = function(data)
                    exports.ox_inventory:openInventory('stash', {id=k})
                end,
            }
        }
    })


    exports.ox_target:addBoxZone({
        coords = v.Wardrobe,
        size = vec3(2, 2, 2),
        rotation = 45,
        debug = drawZones,
        options = {
            {
                name = 'Camerino',
                icon = 'fa-solid fa-shirt',
                label = Popolari.Traduzione["camerino"],
                onSelect = function(data)
                    -- Apre il guardaroba della casa popolare
                    exports['fivem-appearance']:openWardrobe()
                end,
            }
        }
    })
end


-- Controlla se il giocatore ha la chiave nell'inventario
function HasKey(keyName)
    local player = GetPlayerPed(-1)
    local inventory = ESX.GetPlayerData().inventory
    for i = 1, #inventory do
        local item = inventory[i]
        if item and item.name == keyName then
            return true
        end
    end
    return false
end