defmodule EnvConfig.Envtest do
  use ExUnit.Case
  doctest EnvConfig
  import EnvConfig.Env

  describe "env" do
    test "env var is defined" do
      System.put_env("some_var", "some value")

      assert defined?("some_var") == {:ok, "some value"}
    end

    test "env var is undefined" do
      System.delete_env("some_var")
      assert defined?("some_var") == {:error, :env_var_not_set}
    end

    test "env var is defined but empty" do
      System.put_env("some_var", "")
      assert defined?("some_var") == {:ok, ""}
    end
  end
end
