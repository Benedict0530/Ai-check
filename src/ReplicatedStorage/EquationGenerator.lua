local EquationGenerator = {}

function EquationGenerator:GenerateValues()
	-- Reset the variables
	local number1 = 0
	local number2 = 0

	-- Generate new values
	number1 = math.random(1, 3)  -- Lower range for numerator
	number2 = math.random(number1 + 1, 5)  -- Higher range for denominator to ensure it's always greater than number1

	return number1, number2
end

return EquationGenerator
