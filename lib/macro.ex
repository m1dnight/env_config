defmodule EnvConfig.Macros do
  @moduledoc """
  Defines macros to create assertions.
  """

  defmacro required(env_name, type, constraints \\ []) do
    quote do
      case EnvConfig.test_var(unquote(env_name), unquote(type), unquote(constraints)) do
        {:ok, value} ->
          value

        {:error, :env_var_not_set} ->
          raise "Environment variable #{unquote(env_name)} is not set"

        {:error, :invalid_type, err} ->
          raise "Environment variable #{unquote(env_name)} is not of type #{unquote(type)}. #{err}"

        {:error, :constraint_violation, err} ->
          raise "Environment variable #{unquote(env_name)} does not meet constraints. #{err}"
      end
    end
  end

  defmacro optional(env_name, type, constraints \\ []) do
    quote do
      case EnvConfig.test_var(unquote(env_name), unquote(type), unquote(constraints)) do
        {:ok, value} ->
          value

        _ ->
          nil
      end
    end
  end

  # defmacro env_var(varname, name, type, constraints, default) do
  #   quote do
  #     {:ok, value} =
  #       check_env_var(unquote(name), unquote(type), unquote(constraints), unquote(default))

  #     var!(unquote(varname)) = value
  #   end
  # end

  # defmacro env_var(varname, name, type, constraints \\ []) do
  #   quote do
  #     {:ok, value} = check_env_var(unquote(name), unquote(type), unquote(constraints))
  #     var!(unquote(varname)) = value
  #   end
  # end

  # defmacro optional(varname, name, type, constraints \\ []) do
  #   quote do
  #     {:ok, value} = check_optional_env_var(unquote(name), unquote(type), unquote(constraints))
  #     var!(unquote(varname)) = value
  #   end
  # end
end
