defmodule GenReport.Parser do
  @months %{
    1 => "janeiro",
    2 => "fevereiro",
    3 => "março",
    4 => "abril",
    5 => "maio",
    6 => "junho",
    7 => "julho",
    8 => "agosto",
    9 => "setembro",
    10 => "outubro",
    11 => "novembro",
    12 => "dezembro"
  }

  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&parse_line/1)
    |> Stream.map(&serialize/1)
  end

  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
  end

  defp serialize(data) do
    data
    |> List.update_at(0, &String.downcase/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> List.update_at(3, &String.to_integer/1)
    |> List.update_at(4, &String.to_integer/1)
    |> List.update_at(3, &Map.get(@months, &1))
  end
end
