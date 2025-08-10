local RSGCore = exports['rsg-core']:GetCoreObject()

-----------------------------------------------------
-- add item (item / amount)
-----------------------------------------------------
RegisterNetEvent('rex-woodcutter:server:additem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.AddItem(item, amount)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'add', amount)
end)

-----------------------------------------------------
-- remove item (item / amount)
-----------------------------------------------------
RegisterNetEvent('rex-woodcutter:server:removeitem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove', amount)
end)
