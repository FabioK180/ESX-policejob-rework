-- ox_target implementatie voor esx_policejob
-- Alle F6 menu opties zijn nu beschikbaar via ox_target

CreateThread(function()
    -- Wacht tot ox_target beschikbaar is
    while not exports.ox_target then
        Wait(100)
    end

    -- Voeg ox_target opties toe voor alle spelers
    exports.ox_target:addGlobalPlayer({
        {
            name = 'police_id_card',
            icon = 'fas fa-id-card',
            label = TranslateCap('id_card'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    OpenIdentityCardMenu(player)
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        },
        {
            name = 'police_search',
            icon = 'fas fa-search',
            label = TranslateCap('search'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    OpenBodySearchMenu(player)
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        },
        {
            name = 'police_handcuff',
            icon = 'fas fa-lock',
            label = TranslateCap('handcuff'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(player))
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        },
        {
            name = 'police_drag',
            icon = 'fas fa-people-arrows',
            label = TranslateCap('drag'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        },
        {
            name = 'police_put_in_vehicle',
            icon = 'fas fa-car-side',
            label = TranslateCap('put_in_vehicle'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        },
        {
            name = 'police_out_vehicle',
            icon = 'fas fa-door-open',
            label = TranslateCap('out_the_vehicle'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        },
        {
            name = 'police_fine',
            icon = 'fas fa-file-invoice-dollar',
            label = TranslateCap('fine'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    OpenFineMenu(player)
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        },
        {
            name = 'police_unpaid_bills',
            icon = 'fas fa-scroll',
            label = TranslateCap('unpaid_bills'),
            groups = 'police',
            distance = 2.5,
            onSelect = function(data)
                local player, distance = ESX.Game.GetClosestPlayer()
                if player ~= -1 and distance <= 3.0 then
                    OpenUnpaidBillsMenu(player)
                else
                    ESX.ShowNotification(TranslateCap('no_players_nearby'))
                end
            end
        }
    })

    -- Voeg licentie check optie toe als het is ingeschakeld
    if Config.EnableLicenses then
        exports.ox_target:addGlobalPlayer({
            {
                name = 'police_license_check',
                icon = 'fas fa-id-card-alt',
                label = TranslateCap('license_check'),
                groups = 'police',
                distance = 2.5,
                onSelect = function(data)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if player ~= -1 and distance <= 3.0 then
                        ShowPlayerLicense(player)
                    else
                        ESX.ShowNotification(TranslateCap('no_players_nearby'))
                    end
                end
            }
        })
    end

    -- Voeg voertuig interacties toe
    exports.ox_target:addGlobalVehicle({
        {
            name = 'police_vehicle_info',
            icon = 'fas fa-info-circle',
            label = TranslateCap('vehicle_info'),
            groups = 'police',
            distance = 3.0,
            onSelect = function(data)
                local vehicle = data.entity
                if DoesEntityExist(vehicle) then
                    local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
                    OpenVehicleInfosMenu(vehicleData)
                else
                    ESX.ShowNotification(TranslateCap('no_vehicles_nearby'))
                end
            end
        },
        {
            name = 'police_pick_lock',
            icon = 'fas fa-unlock',
            label = TranslateCap('pick_lock'),
            groups = 'police',
            distance = 3.0,
            onSelect = function(data)
                local vehicle = data.entity
                if DoesEntityExist(vehicle) then
                    local playerPed = PlayerPedId()
                    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                    Wait(20000)
                    ClearPedTasksImmediately(playerPed)

                    SetVehicleDoorsLocked(vehicle, 1)
                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                    ESX.ShowNotification(TranslateCap('vehicle_unlocked'))
                else
                    ESX.ShowNotification(TranslateCap('no_vehicles_nearby'))
                end
            end
        },
        {
            name = 'police_impound',
            icon = 'fas fa-warehouse',
            label = TranslateCap('impound'),
            groups = 'police',
            distance = 3.0,
            onSelect = function(data)
                local vehicle = data.entity
                if DoesEntityExist(vehicle) then
                    if currentTask.busy then
                        return
                    end

                    local playerPed = PlayerPedId()
                    ESX.ShowHelpNotification(TranslateCap('impound_prompt'))
                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

                    currentTask.busy = true
                    currentTask.task = ESX.SetTimeout(10000, function()
                        ClearPedTasks(playerPed)
                        ImpoundVehicle(vehicle)
                        Wait(100)
                    end)

                    CreateThread(function()
                        local coords = GetEntityCoords(playerPed)
                        while currentTask.busy do
                            Wait(1000)

                            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
                            if not DoesEntityExist(vehicle) and currentTask.busy then
                                ESX.ShowNotification(TranslateCap('impound_canceled_moved'))
                                ESX.ClearTimeout(currentTask.task)
                                ClearPedTasks(playerPed)
                                currentTask.busy = false
                                break
                            end
                        end
                    end)
                else
                    ESX.ShowNotification(TranslateCap('no_vehicles_nearby'))
                end
            end
        }
    })

    print('[esx_policejob] ox_target integratie succesvol geladen!')
end)
