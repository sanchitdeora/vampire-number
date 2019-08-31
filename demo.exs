defmodule Demo do
  num = 12345678
  digit_list = Integer.digits(num)
  len = length(digit_list)

  if(rem(len,2) == 0) do

    #    Enum.each(digit_list, fn(s) -> IO.puts(s) end)
    fac_list = Vampire.splitFactors(digit_list, len/2)
        IO.puts("Im here")
        Enum.each(Enum.uniq(fac_list), fn(s) -> IO.puts(s) end)










  else
    IO.puts("Not a Vampire Number")
  end

end


