local NeuralNetwork = require("src.NeuralNetwork")
local Lumina = {}

function Lumina.new(...)
    local args = {...}
    local config = {}
    if type(args[1]) == "table" then
        config.layers = args[1]
    else
        config.layers = args
    end
    return NeuralNetwork.new(config)
end

return Lumina