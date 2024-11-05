defmodule EnvConfig.Env do
  @moduledoc """
  Defines functions that can be used to check environment variables.
  """

  @spec defined?(String.t()) :: {:ok, String.t()} | {:error, :env_var_not_set}
  def defined?(env_var) do
    case System.get_env(env_var) do
      nil -> {:error, :env_var_not_set}
      value -> {:ok, value}
    end
  end
end
