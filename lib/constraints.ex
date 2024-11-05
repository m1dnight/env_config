defmodule EnvConfig.Constraints do
  @moduledoc """
  Defines functions that can be used to check constraints on environment variables.
  """

  @type constraint :: {:length, integer()} | {:min_length, integer()} | {:max_length, integer()}
  @type type :: :integer | :boolean | {:list, :string | :integer}

  @spec check(any(), type, [constraint]) ::
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

  def check(value, _type, _constraint) do
    {:ok, value}
  end
end
