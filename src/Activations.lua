local Activations = {}

Activations.sigmoid = {
    f = function(x) return 1 / (1 + math.exp(-x)) end,
    df = function(y) return y * (1 - y) end
}

Activations.tanh = {
    f = function(x) return math.tanh(x) end,
    df = function(y) return 1 - (y * y) end
}

return Activations