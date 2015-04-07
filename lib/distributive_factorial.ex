defmodule DistributiveFactorial do

  def calculate_factorial  n do
    do_calculate_factorial n, items_per_chunk(n), number_of_distributive_chunks		
    collect_the_results([],number_of_distributive_chunks) |> Enum.reduce &(&1*&2)
  end   

  defp do_calculate_factorial  n, _items_per_chunk, 1 do    	
    main_pid = self
    spawn fn-> send main_pid, {:factorial_chunk, factorial(n, n)} end
  end

  defp do_calculate_factorial  n, items_per_chunk, counter do
    main_pid = self
    spawn fn-> send main_pid, {:factorial_chunk, factorial(n, items_per_chunk)} end
    do_calculate_factorial n - items_per_chunk , items_per_chunk , counter - 1		
  end

  defp factorial(n   , 1), do: n

  defp factorial(n, counter), do: n * factorial(n - 1, counter - 1)

  defp collect_the_results(list, 0), do: list	

  defp collect_the_results(list, counter) do
    receive do 
    {:factorial_chunk,value} -> collect_the_results([value|list], counter - 1) 
    end
  end

  defp items_per_chunk(n), do: div(n, number_of_distributive_chunks)

  defp number_of_distributive_chunks, do: :erlang.system_info(:logical_processors)

  def calculate_factorial_50 do
    parent = self
    spawn fn-> send parent, {:factorial_chunk,factorial(10,10)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(20,10)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(30,10)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(40,10)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(50,10)} end

    collect_the_results([],5) |> Enum.reduce &(&1*&2)
  end

  def calculate_factorial_50_000 do
    parent = self
    spawn fn-> send parent, {:factorial_chunk,factorial(10_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(20_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(30_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(40_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(50_000,10_000)} end

    collect_the_results([],5) |> Enum.reduce &(&1*&2)
  end

  def calculate_factorial_100_000 do
    parent = self
    spawn fn-> send parent, {:factorial_chunk,factorial(10_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(20_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(30_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(40_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(50_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(60_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(70_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(80_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(90_000,10_000)} end
    spawn fn-> send parent, {:factorial_chunk,factorial(100_000,10_000)} end

    collect_the_results([],10) |> Enum.reduce &(&1*&2)
  end
end
