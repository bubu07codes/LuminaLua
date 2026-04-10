local Matrix = {}
Matrix.__index = Matrix

function Matrix.new(rows, cols)
    local self = setmetatable({rows = rows, cols = cols, data = {}}, Matrix)
    for i = 1, rows do
        self.data[i] = {}
        for j = 1, cols do self.data[i][j] = 0 end
    end
    return self
end

function Matrix:randomize()
    for i = 1, self.rows do
        for j = 1, self.cols do
            self.data[i][j] = math.random() * 2 - 1
        end
    end
end

function Matrix.multiply(a, b)
    local res = Matrix.new(a.rows, b.cols)
    for i = 1, a.rows do
        for j = 1, b.cols do
            local sum = 0
            for k = 1, a.cols do
                sum = sum + a.data[i][k] * b.data[k][j]
            end
            res.data[i][j] = sum
        end
    end
    return res
end

function Matrix:add(other)
    for i = 1, self.rows do
        for j = 1, self.cols do
            if type(other) == "table" then
                self.data[i][j] = self.data[i][j] + other.data[i][j]
            else
                self.data[i][j] = self.data[i][j] + other
            end
        end
    end
end

function Matrix.map(m, fn)
    local res = Matrix.new(m.rows, m.cols)
    for i = 1, m.rows do
        for j = 1, m.cols do
            res.data[i][j] = fn(m.data[i][j])
        end
    end
    return res
end

function Matrix.transpose(m)
    local res = Matrix.new(m.cols, m.rows)
    for i = 1, m.rows do
        for j = 1, m.cols do res.data[j][i] = m.data[i][j] end
    end
    return res
end

function Matrix.fromArray(arr)
    local m = Matrix.new(#arr, 1)
    for i, v in ipairs(arr) do m.data[i][1] = v end
    return m
end

function Matrix:toArray()
    local res = {}
    for i = 1, self.rows do table.insert(res, self.data[i][1]) end
    return res
end

return Matrix