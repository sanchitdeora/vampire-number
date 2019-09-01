defmodule Demo do
  num = 123050
  digit_list = Integer.digits(num)
  len = length(digit_list)

  if(rem(len,2) == 0) do

    #    Enum.each(digit_list, fn(s) -> IO.puts(s) end)
    fac_list = Vampire.splitFactors(digit_list, len/2)
#        IO.puts("Im here")
#        Enum.each(fac_list, fn(s) -> IO.puts(s) end)
#    Vampire.try()
    Enum.each((fac_list), fn(s) -> IO.puts(s) end)
    IO.inspect((fac_list))
    IO.inspect(length(fac_list))











  else
    IO.puts("Not a Vampire Number")
  end

end


