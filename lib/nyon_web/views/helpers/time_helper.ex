defmodule NyonWeb.TimeHelper do
  def datetime(time) do
    {{year, month, day}, {hour, minute, _second}} = NaiveDateTime.to_erl(time)
    "#{year}/#{month}/#{day} #{hour}:#{minute}"
  end
end
