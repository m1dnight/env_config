defmodule EnvConfig.Constraints do
  @moduledoc """
  Defines functions that can be used to check constraints on environment variables.
  """
  @type constraint :: {:length, integer()} | {:min_length, integer()} | {:max_length, integer()}
  @type type :: :integer | :boolean | {:list, :string | :integer}

  @spec check_constraints(any(), type, [constraint]) ::
          {:ok, any()} | {:error, :constraint_violation, String.t()}
  def check_constraints(value, type, constraints) do
    Enum.reduce_while(constraints, {:ok, value}, fn constraint, {:ok, value} ->
      # ...>   if x < 5 do
      #   ...>     {:cont, acc + x}
      #   ...>   else
      #   ...>     {:halt, acc}
      #   ...>   end
      case check(value, type, constraint) do
        {:ok, value} ->
          {:cont, {:ok, value}}

        err ->
          {:halt, err}
      end
    end)
  end

  @spec check(any(), type, constraint) ::
          {:ok, any()} | {:error, :constraint_violation, String.t()}

  def check(value, {:list, _type}, {:length, length}) do
    if Enum.count(value) == length do
      {:ok, value}
    else
      {:error, :constraint_violation, "List length is not equal to #{length}"}
    end
  end

  def check(value, {:list, _type}, {:min_length, length}) do
    if Enum.count(value) >= length do
      {:ok, value}
    else
      {:error, :constraint_violation, "List length is less than #{length}"}
    end
  end

  def check(value, {:list, _type}, {:max_length, length}) do
    if Enum.count(value) <= length do
      {:ok, value}
    else
      {:error, :constraint_violation, "List length is greater than #{length}"}
    end
  end

  def check(value, :integer, {:min, minimum}) do
    if value >= minimum do
      {:ok, value}
    else
      {:error, :constraint_violation, "integer is less than than #{minimum}"}
    end
  end

  def check(value, :integer, {:max, maximum}) do
    if value <= maximum do
      {:ok, value}
    else
      {:error, :constraint_violation, "integer is larger than than #{maximum}"}
    end
  end

  def check(value, :string, {:allow_empty?, allow_empty?}) do
    trimmed = String.trim(value)

    if String.length(trimmed) == 0 and not allow_empty? do
      {:error, :constraint_violation, "string is empty"}
    else
      {:ok, value}
    end
  end

  def check(value, :string, {:max_length, max}) do
    trimmed = String.trim(value)

    if String.length(trimmed) > max do
      {:error, :constraint_violation, "string is longer than #{max} characters"}
    else
      {:ok, value}
    end
  end

  def check(value, :string, {:min_length, min}) do
    trimmed = String.trim(value)

    if String.length(trimmed) < min do
      {:error, :constraint_violation, "string is shorter than #{min} characters"}
    else
      {:ok, value}
    end
  end

  def check(value, _type, _constraint) do
    {:ok, value}
  end
end
