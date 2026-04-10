local Lumina = require("src.init")

-- 3 inputs (Square Feet, Beds, Age) / 8 Hidden Neurons / 1 Output (Price)
local marketAI = Lumina.new({3, 8, 1})

-- scaling factors (aka "Data Preprocessing")
local MAX_SQFT = 5000
local MAX_BEDS = 5
local MAX_AGE  = 100
local MAX_PRICE = 1000000

local function normalize(sqft, beds, age)
    return {sqft / MAX_SQFT, beds / MAX_BEDS, age / MAX_AGE}
end

-- Example:
-- Dataset: Real-world patterns:
-- {Square Feet, Beds, Age}, {Price}
local trainingData = {
    {data = normalize(1200, 2, 20), price = {250000 / MAX_PRICE}},
    {data = normalize(2500, 4, 5),  price = {600000 / MAX_PRICE}},
    {data = normalize(800, 1, 50),  price = {150000 / MAX_PRICE}},
    {data = normalize(4000, 5, 2),  price = {950000 / MAX_PRICE}},
    {data = normalize(1800, 3, 15), price = {400000 / MAX_PRICE}},
    {data = normalize(1500, 3, 40), price = {320000 / MAX_PRICE}}
}

print("-- corporate price analysis engine --")
print("training on market trends...")

for i = 1, 100000 do
    local d = trainingData[math.random(#trainingData)]
    marketAI:train(d.data, d.price)
end

print("training was completed!!\n")

local function estimate(sqft, beds, age)
    local input = normalize(sqft, beds, age)
    local prediction = marketAI:predict(input)[1]
    local finalPrice = prediction * MAX_PRICE
    
    print(string.format("house: %d square feet, %d bed, %d years old", sqft, beds, age))
    print(string.format("estimated Value: $%s", math.floor(finalPrice)))
    print("-------------------------------------")
end

--lets test it out!!
estimate(2200, 3, 10) -- should be medium
estimate(900, 1, 60)  -- should be low
estimate(3500, 4, 1)  -- should be very high!

--output should be (can vary of course):
--[[

-- corporate price analysis engine --
training on market trends...
training was completed!!

house: 2200 square feet, 3 bed, 10 years old
estimated Value: $451134
-------------------------------------
house: 900 square feet, 1 bed, 60 years old
estimated Value: $150574
-------------------------------------
house: 3500 square feet, 4 bed, 1 years old
estimated Value: $869252
--------------------------------------
---
]]