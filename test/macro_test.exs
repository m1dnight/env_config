defmodule EnvConfig.MacrosTest do
  use ExUnit.Case
  doctest EnvConfig
  import EnvConfig.Macros

  describe "failed required" do
    test "missing value" do
      name = "ENV_VAR"
      type = :string
      constraints = []
      System.delete_env(name)

      assert_raise RuntimeError, "Environment variable ENV_VAR is not set", fn ->
        required(name, type, constraints)
      end
    end

    test "wrong type" do
      name = "ENV_VAR"
      type = :boolean
      value = "notboolean"
      constraints = []

      System.put_env(name, value)

      assert_raise RuntimeError,
                   "Environment variable ENV_VAR is not of type boolean. boolean expected, got 'notboolean'.",
                   fn ->
                     required(name, type, constraints)
                   end
    end

    test "invalid constraints" do
      name = "ENV_VAR"
      type = {:list, :boolean}
      value = "1,1,1"
      constraints = [{:length, 12}]

      System.put_env(name, value)

      assert_raise RuntimeError,
                   "Environment variable ENV_VAR does not meet constraints. List length is not equal to 12",
                   fn ->
                     required(name, type, constraints)
                   end
    end
  end

  describe "required" do
    test "string value" do
      name = "ENV_VAR"
      value = "string"
      type = :string
      expected = "string"
      constraints = []

      System.put_env(name, value)
      obtained = required(name, type, constraints)

      assert obtained == expected
    end

    test "string value list" do
      name = "ENV_VAR"
      value = "string,string"
      type = {:list, :string}
      expected = ["string", "string"]
      constraints = []

      System.put_env(name, value)
      obtained = required(name, type, constraints)

      assert obtained == expected
    end

    test "boolean value" do
      name = "ENV_VAR"
      value = "true"
      type = :boolean
      expected = true
      constraints = []

      System.put_env(name, value)
      obtained = required(name, type, constraints)

      assert obtained == expected
    end

    test "boolean value list" do
      name = "ENV_VAR"
      value = "1,true"
      type = {:list, :boolean}
      expected = [true, true]
      constraints = []

      System.put_env(name, value)
      obtained = required(name, type, constraints)

      assert obtained == expected
    end

    test "integer value" do
      name = "ENV_VAR"
      value = "1234"
      type = :integer
      expected = 1234
      constraints = []

      System.put_env(name, value)
      obtained = required(name, type, constraints)

      assert obtained == expected
    end

    test "integer value list" do
      name = "ENV_VAR"
      value = "1,2"
      type = {:list, :integer}
      expected = [1, 2]
      constraints = []

      System.put_env(name, value)
      obtained = required(name, type, constraints)

      assert obtained == expected
    end
  end
end
