local PairedPositionsModule = {}
local BottleSpawner = require(game.ReplicatedStorage.BottleSpawner)
local NozzleSpawner = require(game.ReplicatedStorage.NozzleSpawner)

-- Define paired positions
local pairedPositions = {
	["s1"] = "ns1",
	["s2"] = "ns2",
	["s3"] = "ns3",
	["s4"] = "ns4",
	["s5"] = "ns5",
	["s6"] = "ns6",
	["s7"] = "ns7",
	["s8"] = "ns8",
	["s9"] = "ns9",
	["s10"] = "ns10",
}

-- Function to check paired positions
local function checkPairedPositions()
	for bottlePart, nozzlePart in pairs(pairedPositions) do
		if BottleSpawner.getOccupiedParts and NozzleSpawner.getOccupiedParts then
			local bottleModel = BottleSpawner.getOccupiedParts()[bottlePart]
			local nozzleModel = NozzleSpawner.getOccupiedParts()[nozzlePart]

			if bottleModel and nozzleModel then
				print("Paired match found: " .. bottlePart .. " (" .. bottleModel.Name .. ") and " .. nozzlePart .. " (" .. nozzleModel.Name .. ")")
			end
		end
	end
end

-- Expose functions
PairedPositionsModule.checkPairedPositions = checkPairedPositions

return PairedPositionsModule