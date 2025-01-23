defmodule EnvConfig.Cast do
  @moduledoc """
  Defines functions that cast values to a specific type.
  """

  @type type :: :boolean | :string | :integer

  @doc """
  Takes in a string value and casts it to the specified type.

  Returns an error if the cast is not possible.
  """
  @spec cast(any(), type) :: {:ok, any()} | {:error, :cast_fail, String.t()}
  def cast(value, :boolean) do
    cond do
      value in ["true", "TRUE", "1"] -> {:ok, true}
      value in ["false", "FALSE", "0"] -> {:ok, false}
      true -> {:error, :cast_fail, "boolean expected, got '#{value}'."}
    end
  end

  def cast(value, :string) do
    if is_binary(value) do
      {:ok, value}
    else
      {:error, :cast_fail, "string expected, got '#{value}'."}
    end
  end

  def cast(value, :atom) do
    if is_binary(value) do
      {:ok, String.to_atom(value)}
    else
      {:error, :cast_fail, "atom expected, got '#{value}'."}
    end
  end

  def cast(value, :charlist) do
    if is_binary(value) do
      charlist = to_charlist(value)
      {:ok, charlist}
    else
      {:error, :cast_fail, "charlist expected, got '#{value}'."}
    end
  end

  def cast(value, :integer) do
    case Integer.parse(value) do
      {int, ""} -> {:ok, int}
      _ -> {:error, :cast_fail, "integer expected, got '#{value}'"}
    end
  end

  def cast(value, :float) do
    case Float.parse(value) do
      {float, _} -> {:ok, float}
      _ -> {:error, :cast_fail, "float expected, got '#{value}'"}
    end
  end

  def cast(value, {:list, type}) do
    if is_binary(value) do
      value
      |> String.trim()
      |> String.split(",")
      |> case do
        [""] -> {:ok, []}
        list -> cast_list(list, type)
      end
    end
  end

  def cast(value, {:enum, options}) do
    if is_binary(value) and value in options do
      {:ok, value}
    else
      {:error, :cast_fail, "'#{value}' not in enum #{inspect(options)}"}
    end
  end

  @spec cast_list([String.t()], type) :: {:ok, [any()]} | {:error, :cast_fail, String.t()}
  defp cast_list(values, type) do
    values
    |> Enum.reduce({:ok, []}, fn value, {:ok, acc} ->
      case cast(value, type) do
        {:ok, casted} -> {:ok, [casted | acc]}
        error -> error
      end
    end)
    |> case do
      {:ok, list} -> {:ok, Enum.reverse(list)}
      error -> error
    end
  end
end
