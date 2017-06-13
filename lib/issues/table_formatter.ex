defmodule Issues.TableFormatter do
  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1]

  def print_table_for_columns(rows, headers) do
    data_by_columns = split_into_columns(rows, headers)
    column_widths = widths_of(data_by_columns)
    format = format_for(column_widths)

    puts_one_line_in_columns(headers, format)
    IO.puts separator(column_widths)
    puts_in_columns(data_by_columns, format)
  end


end