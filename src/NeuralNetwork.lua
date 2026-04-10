local Matrix = require("src.Matrix")
local Activations = require("src.Activations")

local NeuralNetwork = {}
NeuralNetwork.__index = NeuralNetwork

function NeuralNetwork.new(config)
    local self = setmetatable({}, NeuralNetwork)
    self.layers = {}
    self.biases = {}
    self.lr = 0.1
    self.activation = Activations.sigmoid

    local sizes = config.layers
    for i = 1, #sizes - 1 do
        local w = Matrix.new(sizes[i+1], sizes[i])
        w:randomize()
        table.insert(self.layers, w)
        
        local b = Matrix.new(sizes[i+1], 1)
        b:randomize()
        table.insert(self.biases, b)
    end
    return self
end

function NeuralNetwork:predict(inputs)
    local curr = Matrix.fromArray(inputs)
    for i = 1, #self.layers do
        curr = Matrix.multiply(self.layers[i], curr)
        curr:add(self.biases[i])
        curr = Matrix.map(curr, self.activation.f)
    end
    return curr:toArray()
end

function NeuralNetwork:train(inputs, targets)
    local nodes = {Matrix.fromArray(inputs)}
    for i = 1, #self.layers do
        local nextNodes = Matrix.multiply(self.layers[i], nodes[i])
        nextNodes:add(self.biases[i])
        nextNodes = Matrix.map(nextNodes, self.activation.f)
        table.insert(nodes, nextNodes)
    end

    local targetMat = Matrix.fromArray(targets)
    local errors = Matrix.new(targetMat.rows, 1)
    for i = 1, targetMat.rows do
        errors.data[i][1] = targetMat.data[i][1] - nodes[#nodes].data[i][1]
    end

    for i = #self.layers, 1, -1 do
        local gradients = Matrix.map(nodes[i+1], self.activation.df)
        for r = 1, gradients.rows do
            gradients.data[r][1] = gradients.data[r][1] * errors.data[r][1] * self.lr
        end

        local prevT = Matrix.transpose(nodes[i])
        local deltas = Matrix.multiply(gradients, prevT)

        self.layers[i]:add(deltas)
        self.biases[i]:add(gradients)

        errors = Matrix.multiply(Matrix.transpose(self.layers[i]), errors)
    end
end

return NeuralNetwork