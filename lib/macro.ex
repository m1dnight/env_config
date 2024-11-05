defmodule EnvConfig.Macros do
  @moduledoc """
  Defines macros to create assertions.
  """
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
