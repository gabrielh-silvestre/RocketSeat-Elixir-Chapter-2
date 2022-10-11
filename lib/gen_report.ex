defmodule GenReport do
  alias GenReport.Parser

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(file_name) do
    Parser.parse_file(file_name)
    |> Enum.reduce(build_report(), fn data, acc ->
      acc
      |> update_all_hours(data)
      |> update_hours_per_month(data)
      |> update_hours_per_year(data)
    end)
  end

  defp update_all_hours(acc, [name, work_time, _, _, _]) do
    acc
    |> Map.update!("all_hours", fn hours ->
      Map.update(hours, name, work_time, &(&1 + work_time))
    end)
  end

  defp update_hours_per_month(acc, [name, work_time, _, month, _]) do
    acc
    |> Map.update!("hours_per_month", fn hours ->
      Map.update(hours, name, %{month => work_time}, fn hours_per_month ->
        Map.update(hours_per_month, month, work_time, &(&1 + work_time))
      end)
    end)
  end

  defp update_hours_per_year(acc, [name, work_time, _, _, year]) do
    acc
    |> Map.update!("hours_per_year", fn hours ->
      Map.update(hours, name, %{year => work_time}, fn hours_per_year ->
        Map.update(hours_per_year, year, work_time, &(&1 + work_time))
      end)
    end)
  end

  defp build_report do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end
end
