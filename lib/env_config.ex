defmodule EnvConfig do
  @moduledoc """
  Documentation for `EnvConfig`.
  """
  alias EnvConfig.Cast
  alias EnvConfig.Constraints
  alias EnvConfig.Env

  @type constraint :: {:length, integer()} | {:min_length, integer()} | {:max_length, integer()}
  @type type :: :integer | :boolean | {:list, :string | :integer}

  @spec test_var(String.t(), type, [constraint]) ::
          {:ok, any()} | {:error, atom()} | {:error, atom(), String.t()}
  def test_var(name, type, constraints) do
    with {:ok, value} <- Env.defined?(name),
         {:ok, value} <- Cast.cast(value, type),
         {:ok, value} <- Constraints.check_constraints(value, type, constraints) do
      {:ok, value}
    else
      {:error, :constraint_violation, err} ->
        {:error, :constraint_violation, err}

      {:error, :cast_fail, err} ->
        {:error, :invalid_type, err}

      {:error, :env_var_not_set} ->
        {:error, :env_var_not_set}
    end
  end
end
