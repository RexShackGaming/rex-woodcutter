local RSGCore = exports['rsg-core']:GetCoreObject()
local chopping = false
local cooldownActive = false
local lastChopTime = 0
local cooldownTime = 60000  -- Cooldown time in milliseconds (30 seconds)
lib.locale()

-----------------------------------------------------
-- target models for interaction (trees)
-----------------------------------------------------
exports['rsg-target']:AddTargetModel(Config.Trees, {
    options = {
        {
            type = 'client',
            event = 'rsg-gatherer:client:choptree',
            icon = 'far fa-eye',
            label = locale('cl_lang_1'),
            distance = 2.0
        },
    }
})

-----------------------------------------------------
-- chop tree
-----------------------------------------------------
RegisterNetEvent('rsg-gatherer:client:choptree', function()
    local currentTime = GetGameTimer()

    -- Check if the cooldown has passed
    if cooldownActive and currentTime - lastChopTime < cooldownTime then
        local remainingCooldown = math.ceil((lastChopTime + cooldownTime - currentTime) / 1000)
        lib.notify({ title = locale('cl_lang_2'), description = locale('cl_lang_3') .. remainingCooldown .. locale('cl_lang_4'), type = 'error' })
        return
    end

    local hasItem = RSGCore.Functions.HasItem('axe', 1)

    -- check has item
    if not hasItem then
        lib.notify({ title = locale('cl_lang_5'), description = locale('cl_lang_6'), type = 'error' })
        return
    end

    if chopping then
        lib.notify({ title = locale('cl_lang_7'), description = locale('cl_lang_8'), type = 'error' })
        return
    end

    chopping = true
    LocalPlayer.state:set('inv_busy', true, true)

    if lib.progressBar({
        duration = Config.ChopTreeTime,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disableControl = true,
        label = locale('cl_lang_9'),
        anim = {
            dict = 'amb_work@world_human_tree_chop_new@working@pre_swing@male_a@trans',
            clip = 'pre_swing_trans_after_swing',
            flag = 15,
        },
        prop = {
            model = `p_axe02x`,
            bone = 7966,
            pos = vec3(0.03, 0.03, 0.02),
            rot = vec3(0.0, 0.0, -1.5)
        },
    }) then
        local axeBreakChance = 10  -- Set the chance of the axe breaking to 100% for testing purposes
        if math.random(100) <= axeBreakChance then
            lib.notify({ title = locale('cl_lang_10'), description = locale('cl_lang_11'), type = 'error' })
            TriggerServerEvent('rex-woodcutter:server:removeitem', 'axe', 1)
        else
            TriggerServerEvent('rex-woodcutter:server:additem', 'wood', 1)
            cooldownActive = true
            lastChopTime = currentTime
            Citizen.SetTimeout(cooldownTime, function()
                cooldownActive = false
            end)
        end
        chopping = false
        LocalPlayer.state:set('inv_busy', false, true)
    end
end)
