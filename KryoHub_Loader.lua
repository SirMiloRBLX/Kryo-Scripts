if _G.Debug then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

local Supported = {
    [4623386862] = "https://raw.githubusercontent.com/SirMiloRBLX/Kryo-Scripts/refs/heads/main/KyroHub_Piggy.lua", -- Piggy
    [5661005779] = "https://raw.githubusercontent.com/SirMiloRBLX/Kryo-Scripts/refs/heads/main/KyroHub_Piggy.lua"  -- Piggy: Book 2
}

pcall(function()
    local scriptUrl = Supported[game.PlaceId]

    if scriptUrl then  
        local success, result = pcall(function()  
            return loadstring(game:HttpGet(scriptUrl))()  
        end)  

        if success then  
            print("[Kyro Hub] Script loaded successfully for PlaceId:", game.PlaceId)  
        else  
            warn("[Kyro Hub] Failed to execute script:", result)  
        end  
    else  
        warn("[Kyro Hub] This game is not supported. PlaceId:", game.PlaceId)  
    end
end)
