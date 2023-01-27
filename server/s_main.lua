local RSGCore = exports['rsg-core']:GetCoreObject()

BathingSessions = {}

Citizen.CreateThread(function()
    
    RegisterServerCallback("rsg-bath:canEnterBath", function(source, cb, town)
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        if not BathingSessions[town] then
            if player.getAccountMoney("money") >= Globals.Price then -- CHANGE THIS
                Player.Functions.RemoveMoney('cash', Globals.Price, 'Bath House - Default Service')
                BathingSessions[town] = source
                cb(true)
                return
            else
                TriggerClientEvent('RSGCore:Notify', src, 'You cant afford a Bath', 'error')
            end
        else 
            TriggerClientEvent('RSGCore:Notify', src, 'The bath is already occupied! Come back later!', 'error')
        end
        cb(false)
    end)

    RegisterServerCallback("rsg-bath:canBuyDeluxeBath", function(source, cb, town)
        if BathingSessions[town] == source then
            local src = source
            local Player = RSGCore.Functions.GetPlayer(src)
            if player.getAccountMoney("money") >= Globals.Deluxe then -- CHANGE THIS
                Player.Functions.RemoveMoney('cash', Globals.Deluxe, 'Bath House - Premium Service')
                cb(true)
                return
            else
                TriggerClientEvent('RSGCore:Notify', src, 'You cant afford a Luxury Bath', 'error')
            end
        end
        cb(false)
    end)

    RegisterServerEvent("rsg-bath:setBathAsFree")
    AddEventHandler("rsg-bath:setBathAsFree", function(town)
        if BathingSessions[town] == source then
            BathingSessions[town] = nil
        end
    end)

    AddEventHandler('playerDropped', function()
        for town,player in pairs(BathingSessions) do
            if player == source then
                BathingSessions[town] = nil
            end
        end	 
    end)    
end)

