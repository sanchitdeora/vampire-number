defmodule Demo do
  num = 1435
  digits_list = Integer.digits(num)
  numLength = length(digits_list)

  if(rem(numLength,2) == 0) do
#    root = :math.sqrt(num)
    factors_list = Vampire.splitFactors(digits_list, div(numLength,2))
    factors_list = Enum.uniq(factors_list)
#    Enum.each((factors_list), fn(s) -> IO.puts(s) end)
    IO.inspect((factors_list))
    IO.inspect(length(factors_list))
    fang_list = Vampire.calculateVampire(num, factors_list)
    Enum.each((fang_list), fn(s) -> IO.puts(s) end)













  else
    IO.puts("Not a Vampire Number")
  end

end


