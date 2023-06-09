---------------------------------------------------------------------------------------------------------------------------
Mek91_ML = {}
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.Core = exports['qb-core']:GetCoreObject()
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.Language = TR -- | TR | EN | Select Language.
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.DiscordColor = 2303786 -- You can reach Discord Colour Codes from here: https://gist.github.com/thomasbnt/b6f455e2c7d743b796917fa3c205f812
Mek91_ML.DiscordWebhook = "YOUR_WEBHOOK" -- Write Discord Webhook Address! (Optional)
Mek91_ML.DiscordWebhookName = "YOUR_WEBHOOK_NAME" -- Just Type Server Name! (Optional)
Mek91_ML.DiscordWebhookAvatarUrl = "YOUR_WEBHOOK_AVATAR_URL" -- Just Write Your Server's Logo Link Extension (Optional)
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.AddItem = true -- Should it be added as an item ? true = on
Mek91_ML.BlackMoneyItemName = "black_money" -- You will write the name of the black money item here and add it to the inventory.
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.Fields = {
    ['ExampleLaundering'] = { -- You can give any name you wish. ||| EXAMPLE |||
        Job = "examplelaundering", -- You can also open it to everyone with "any" OR Write your occupation name here!
        JobName = "Example Laundering", -- Name of Profession.
        JobLabel = "Example Laundering", -- Profession Description.
        Payment = 80, -- How much salary should he get?
        Percent = 0.5, -- If you enter the share you want to give in the conversion 0.8, it will give 80%. If you want to give the share as it is, it is enough to write 1 directly.
        AddJob = true, -- Should it be added as a profession? /setjob "id" "stockbroker" "0"

        TargetLabel = "Example Laundering",
        Icon = "far fa-credit-card",
        TargetLocation = vector3(-72.02, -814.4, 243.39), -- If you want it to be triggered from where, write the coordinate as Vector3 here!
        TargetMinZ = 243, -- Enter the Minimum Z Height so that it can trigger This is usually the option with vector3(none, none, 34) "34" and it varies.
        TargetMaxZ = 244, -- Enter the Maximum Z Height so that it can trigger This is usually the option with vector3(none, none, 35) "35" and it varies.

        Blip = true, -- Do you want it on the map?
        BlipName = "Example Laundering", -- Write Blip Name!
        BlipId = 826, -- Select the Icon Id to be displayed on the map. https://docs.fivem.net/docs/game-references/blips
        BlipColorId = 2, -- Select Icon Colour. https://docs.fivem.net/docs/game-references/blips
        BlipDisplay = 4, -- Determines how the blip will appear on the map.
        BlipScale = 0.6, -- Adjusting the size of the blip.
        BlipLocation = vector2(-72.02, -814.4), -- Write as vector2() or vector3() at which location you want it to appear on the map.
    },

    ['MoneyLaundering'] = { -- You can give any name you wish.
        Job = "stockbroker", -- You can also open it to everyone with "any" OR Write your occupation name here!
        JobName = "Stock Broker", -- Name of Profession.
        JobLabel = "Stock Broker", -- Profession Description.
        Payment = 80, -- How much salary should he get?
        Percent = 0.8, -- If you enter the share you want to give in the conversion 0.8, it will give 80%. If you want to give the share as it is, it is enough to write 1 directly.
        AddJob = true, -- Should it be added as a profession? /setjob "id" "stockbroker" "0"

        TargetLabel = "Money Laundering",
        Icon = "far fa-credit-card",
        TargetLocation = vector3(-80.55, -802.07, 243.4), -- If you want it to be triggered from where, write the coordinate as Vector3 here!
        TargetMinZ = 243, -- Enter the Minimum Z Height so that it can trigger This is usually the option with vector3(none, none, 34) "34" and it varies.
        TargetMaxZ = 244, -- Enter the Maximum Z Height so that it can trigger This is usually the option with vector3(none, none, 35) "35" and it varies.

        Blip = true, -- Do you want it on the map?
        BlipName = "Money Laundering", -- Write Blip Name!
        BlipId = 826, -- Select the Icon Id to be displayed on the map. https://docs.fivem.net/docs/game-references/blips
        BlipColorId = 2, -- Select Icon Colour. https://docs.fivem.net/docs/game-references/blips
        BlipDisplay = 4, -- Determines how the blip will appear on the map.
        BlipScale = 0.6, -- Adjusting the size of the blip.
        BlipLocation = vector2(-80.55, -802.07), -- Write as vector2() or vector3() at which location you want it to appear on the map.
    },
}
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.AddItem = function()
    exports['qb-core']:AddItem(Mek91_ML.BlackMoneyItemName, {
        name = Mek91_ML.BlackMoneyItemName,
        label = Mek91_ML.Language.Label,
        weight = 0,
        type = 'item',
        image = Mek91_ML.BlackMoneyItemName .. '.png',
        unique = false,
        useable = false,
        shouldClose = true,
        combinable = nil,
        description = Mek91_ML.Language.Descrptn
    })
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.AddJob = function(Job, JobName, JobLabel, Payment)
    exports['qb-core']:AddJob(Job, 
    {
        label = JobLabel,
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            ['0'] = {
                name = JobName,
                payment = JobLabel
            }
        }
    })
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.SetTarget = function(Job, TargetLocation, TargetLabel, Event, Type, Icon, TargetMinZ, TargetMaxZ)
    exports['qb-target']:AddBoxZone(Job, TargetLocation, 5.3, 4.0, {
        name = Job,
        debugPoly = false,
        minZ = TargetMinZ,
        maxZ = TargetMaxZ
    }, {
        options = {
            {
                type = Type, -- "client" or "server"
				event = Event, -- Trigger Event
                icon = Icon,
                label = TargetLabel,
                job = Job,
            },
        },
        distance = 2,
    })
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.OpenMenu = function(MoneytoReceive)
    Mek91_ML.MenuHide()

    exports['qb-menu']:openMenu({
		{
            header = Mek91_ML.Language.TitleMenu,
            icon = "fas fa-question-circle",
            isMenuHeader = true
        },
        {
            header = Mek91_ML.Language.AllMoneyWashMenu,
            icon = "fas fa-money-bill-wave-alt",
            txt = Mek91_ML.Language.MoneyYouWillReceive .. " " .. MoneytoReceive .. "$",
			isServer = false,
            params = {
                event = "Mek91ML:Client:AllBlackMoney"
            }
        },
        {
            header = Mek91_ML.Language.OpenBlackMoneySelector,
            icon = "fas fa-money-check-alt",
            txt = Mek91_ML.Language.SwitchtoSelector,
			isServer = false,
            params = {
                event = "Mek91ML:Client:OpenBlackMoneySelectorMenu"
            }
        },
        {
            header = Mek91_ML.Language.CloseMenu,
            icon = "fas fa-times",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end

Mek91_ML.MenuHide = function()
    exports['qb-menu']:closeMenu()
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.OpenInput = function(PlayerId, PlayerBlackMoney, Core)
    Mek91_ML.MenuHide()

    local dialog = exports['qb-input']:ShowInput({
        header = Mek91_ML.Language.Title,
        submitText = Mek91_ML.Language.SubmitTextInput,
        inputs = {
            {
                text = Mek91_ML.Language.AvailableBlackMoney .. ': ' ..PlayerBlackMoney.. '',
                name = "SelectBlackMoney",
                type = "number",
                isRequired = true
            }
        }
    })

    local BlackMoneyCount = tonumber(dialog['SelectBlackMoney'])

    if BlackMoneyCount > 0 then
        if PlayerBlackMoney >= BlackMoneyCount then
            TriggerEvent("Mek91ML:Client:SelectBlackMoney", BlackMoneyCount)
        else
            Mek91_ML.SendNotification(PlayerId, Mek91_ML.Language.MoneyNotFoundInput, "CL", Core)
        end
    else
        Mek91_ML.SendNotification(PlayerId, Mek91_ML.Language.MinMoney, "CL", Core)
    end
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.GetPlayerJob = function(PlayerId, Core)
    local Player = Core.Functions.GetPlayerData()

    return Player.job.name
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.GetPlayerBlackMoney = function(PlayerId, Core)
    local BlackMoneyCount = 0
        
    for _, item in pairs(Core.Functions.GetPlayerData().items) do
        if item.name == Mek91_ML.BlackMoneyItemName then
            BlackMoneyCount = item.amount
            break
        end
    end

    return BlackMoneyCount
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.DeletePlayerBlackMoney = function(PlayerId, LaunderedMoney, Core)
    local Player = Core.Functions.GetPlayer(PlayerId)
    Player.Functions.RemoveItem(Mek91_ML.BlackMoneyItemName, LaunderedMoney)
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.GiveMoney = function(PlayerId, Money, Core)
    local Player = Core.Functions.GetPlayer(PlayerId)
    local GiveMoney = tonumber(Money)

    Player.Functions.AddMoney('bank', GiveMoney) -- Money is deposited to the person's bank.
end
---------------------------------------------------------------------------------------------------------------------------
Mek91_ML.SendNotification = function(PlayerId, Msg, SendLocation, Core)
    if SendLocation == "SV" then
        TriggerClientEvent('QBCore:Notify', PlayerId, Msg) -- To send incoming messages from the server to the client side.
        return
    end

    Core.Functions.Notify(Msg) -- To send the messages received by the client to the client side.
end
---------------------------------------------------------------------------------------------------------------------------
-- VERSION: 1.0.0
-- Discord: mek91
-- Github:  https://github.com/Mek91
-- YouTube: https://www.youtube.com/@mek91
---------------------------------------------------------------------------------------------------------------------------
-- LIBS: qb-core | qb-target | qb-menu | qb-input
---------------------------------------------------------------------------------------------------------------------------