defmodule EnvConfig.ConstraintsTest do
  use ExUnit.Case
  doctest EnvConfig
  import EnvConfig.Constraints

  describe "list length" do
    test "list length equals" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:length, 3}]

      assert check(value, type, constraints) == {:ok, value}
    end
  end

  describe "minimum list length" do
    test "list length equal" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:min_length, 3}]

      assert check(value, type, constraints) == {:ok, value}
    end

    test "list length larger" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:min_length, 2}]

      assert check(value, type, constraints) == {:ok, value}
    end
  end

  describe "maximum list length" do
    test "list length equal" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:max_length, 3}]

      assert check(value, type, constraints) == {:ok, value}
    end

    test "list length smaller" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:max_length, 4}]

      assert check(value, type, constraints) == {:ok, value}
    end
  end
end
