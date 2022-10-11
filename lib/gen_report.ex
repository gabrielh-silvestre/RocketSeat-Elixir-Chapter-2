# GenReport.build("gen_report.csv")
defmodule GenReport do
  alias GenReport.Parser

  @report_fields ["all_hours", "hours_per_month", "hours_per_year"]
  @report_build Enum.reduce(@report_fields, %{}, &Map.put(&2, &1, %{}))

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(file_name) do
    Parser.parse_file(file_name)
    |> Enum.reduce(@report_build, &proccess_report/2)
  end

  defp proccess_report([name, work_time, _, month, year], report) do
    report
    |> update_all_hours(name, work_time)
    |> update_hours_per_month(name, work_time, month)
    |> update_hours_per_year(name, work_time, year)
  end

  defp update_all_hours(report, name, work_time) do
    report
    |> Map.update("all_hours", %{}, fn person ->
      person |> Map.update(name, work_time, &(&1 + work_time))
    end)
  end

  defp update_hours_per_month(report, name, work_time, month) do
    report
    |> Map.update!("hours_per_month", fn person ->
      Map.update(
        person,
        name,
        %{month => work_time},
        fn hours_per_month ->
          Map.update(hours_per_month, month, work_time, &(&1 + work_time))
        end
      )
    end)
  end

  defp update_hours_per_year(report, name, work_time, year) do
    report
    |> Map.update!("hours_per_year", fn hours ->
      Map.update(
        hours,
        name,
        %{year => work_time},
        fn hours_per_year ->
          Map.update(hours_per_year, year, work_time, &(&1 + work_time))
        end
      )
    end)
  end
end
