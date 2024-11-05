defmodule EnvConfig do
  @moduledoc """
  Documentation for `EnvConfig`.
  """

  # ----------------------------------------------------------------------------
  # Defined

  def check_env(env_var, default \\ nil)

  def check_env(env_var, nil) do
    case System.get_env(env_var) do
      nil -> {:error, :env_var_not_set}
      value -> {:ok, value}
    end
  end

  def check_env(env_var, default) when is_binary(default) do
    {:ok, System.get_env(env_var, default)}
  end

  def check_env(_env_var, _default) do
    {:error, :default_not_string}
  end

  # ----------------------------------------------------------------------------
  # Type

  def check_type(value, type, constraints) do
    with {:ok, value} <- check_type(value, type),
         {:ok, value} <- check_constraints(value, type, constraints) do
      {:ok, value}
    else
      e -> e
    end
  end

  def check_type(value, :boolean) do
    cond do
      value in ["true", "TRUE"] -> {:ok, true}
      value in ["false", "FALSE"] -> {:ok, false}
      true -> {:error, :type_mismatch, "boolean expected, got '#{value}'"}
    end
  end

  def check_type(value, :string) do
    if is_binary(value) do
      {:ok, value}
    else
      {:error, :type_mismatch, "string expected, got #{value}"}
    end
  end

  def check_type(value, :integer) do
    case Integer.parse(value) do
      {int, ""} -> {:ok, int}
      _ -> {:error, :type_mismatch, "integer expected, got '#{value}'"}
    end
  end

  def check_type(value, :string_list) do
    if is_binary(value) do
      case String.split(value, ",") do
        [] -> {:ok, []}
        list -> {:ok, list}
      end
    else
      {:error, :type_mismatch, "string list expected, got '#{value}'"}
    end
  end

  def check_type(value, :atom_list) do
    if is_binary(value) do
      case String.split(value, ",") do
        [] -> {:ok, []}
        list -> {:ok, Enum.map(list, &String.to_atom/1)}
      end
    else
      {:error, :type_mismatch, "string list expected, got '#{value}'"}
    end
  end

  # ----------------------------------------------------------------------------
  # Constraints

  def check_constraints(value, _type, []) do
    {:ok, value}
  end

  def check_constraints(value, type, [constraint | constraints]) do
    case check_constraint(value, type, constraint) do
      {:ok, value} ->
        check_constraints(value, type, constraints)

      {:error, :constraint_violation, error} ->
        {:error, :constraint_violation, error}
    end
  end

  def check_constraint(value, :string, {:length, length}) do
    if String.length(value) != length do
      {:error, :constraint_violation,
       "string of length #{length} expected, got #{value} (#{String.length(value)})"}
    else
      {:ok, value}
    end
  end

  def check_constraint(value, :string, {:min_length, length}) do
    if String.length(value) < length do
      {:error, :constraint_violation,
       "string of minimum length #{length} expected, got #{value} (#{String.length(value)})"}
    else
      {:ok, value}
    end
  end

  def check_constraint(value, :string_list, {:min_length, length}) do
    if Enum.count(value) < length do
      {:error, :constraint_violation,
       "string list of minimum length #{length} expected, got #{value} (#{Enum.count(value)})"}
    else
      {:ok, value}
    end
  end

  def check_constraint(value, :atom_list, {:min_length, length}) do
    if Enum.count(value) < length do
      {:error, :constraint_violation,
       "string list of minimum length #{length} expected, got #{value} (#{Enum.count(value)})"}
    else
      {:ok, value}
    end
  end

  # ----------------------------------------------------------------------------
  # Macro

  def check_optional_env_var(env_var, type, constraints, default \\ nil) do
    case check_env(env_var) do
      {:ok, _value} -> check_env_var(env_var, type, constraints)
      {:error, _} -> {:ok, default}
    end
  end

  def check_env_var(env_var, type, constraints, default \\ nil) do
    with {:ok, value} <- check_env(env_var, default),
         {:ok, value} <- check_type(value, type, constraints) do
      {:ok, value}
    else
      {:error, :default_not_string} ->
        raise "#{env_var}: default value must be a string"

      {:error, :env_var_not_set} ->
        raise "#{env_var}: env var '#{env_var}' not set"

      {:error, :type_mismatch, message} ->
        raise "#{env_var}: type mismatch: #{message}"

      {:error, :constraint_violation, message} ->
        raise "#{env_var}: constraint violation: #{message}"
    end
  end

  defmacro env_var(varname, name, type, constraints, default) do
    quote do
      {:ok, value} =
        check_env_var(unquote(name), unquote(type), unquote(constraints), unquote(default))

      var!(unquote(varname)) = value
    end
  end

  defmacro env_var(varname, name, type, constraints \\ []) do
    quote do
      {:ok, value} = check_env_var(unquote(name), unquote(type), unquote(constraints))
      var!(unquote(varname)) = value
    end
  end

  defmacro optional(varname, name, type, constraints \\ []) do
    quote do
      {:ok, value} = check_optional_env_var(unquote(name), unquote(type), unquote(constraints))
      var!(unquote(varname)) = value
    end
  end
end
