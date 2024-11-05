defmodule EnvConfigTest do
  use ExUnit.Case
  doctest EnvConfig

  describe "test_var" do
    test "integer value" do
      value = "123"
      name = "ENV_VAR"
      type = :integer
      constraints = []
      expected = 123

      System.put_env(name, value)
      assert EnvConfig.test_var(name, type, constraints) == {:ok, expected}
    end

    test "boolean value, true" do
      value = "true"
      name = "ENV_VAR"
      type = :boolean
      constraints = []
      expected = true

      System.put_env(name, value)
      assert EnvConfig.test_var(name, type, constraints) == {:ok, expected}
    end

    test "boolen value; false" do
      value = "false"
      name = "ENV_VAR"
      type = :boolean
      constraints = []
      expected = false

      System.put_env(name, value)
      assert EnvConfig.test_var(name, type, constraints) == {:ok, expected}
    end

    test "boolean list" do
      value = "true,false,true"
      name = "ENV_VAR"
      type = {:list, :boolean}
      constraints = []
      expected = [true, false, true]

      System.put_env(name, value)
      assert EnvConfig.test_var(name, type, constraints) == {:ok, expected}
    end

    test "string list" do
      value = "true,false,true"
      name = "ENV_VAR"
      type = {:list, :string}
      constraints = []
      expected = ["true", "false", "true"]

      System.put_env(name, value)
      assert EnvConfig.test_var(name, type, constraints) == {:ok, expected}
    end

    test "integer list" do
      value = "1,2,3"
      name = "ENV_VAR"
      type = {:list, :integer}
      constraints = []
      expected = [1, 2, 3]

      System.put_env(name, value)
      assert EnvConfig.test_var(name, type, constraints) == {:ok, expected}
    end
  end
end
