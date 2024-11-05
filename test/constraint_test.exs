defmodule EnvConfig.ConstraintsTest do
  use ExUnit.Case
  doctest EnvConfig
  import EnvConfig.Constraints

  describe "list length" do
    test "list length equals" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:length, 3}]

      assert check_constraints(value, type, constraints) == {:ok, value}
    end
  end

  describe "minimum list length" do
    test "list length equal" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:min_length, 3}]

      assert check_constraints(value, type, constraints) == {:ok, value}
    end

    test "list length larger" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:min_length, 2}]

      assert check_constraints(value, type, constraints) == {:ok, value}
    end
  end

  describe "maximum list length" do
    test "list length equal" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:max_length, 3}]

      assert check_constraints(value, type, constraints) == {:ok, value}
    end

    test "list length smaller" do
      type = {:list, :boolean}
      value = [true, false, true]
      constraints = [{:max_length, 4}]

      assert check_constraints(value, type, constraints) == {:ok, value}
    end
  end

  describe "integer lower bound" do
    test "large enough" do
      type = :integer
      value = 1
      constraints = [{:min, 0}]

      assert check_constraints(value, type, constraints) == {:ok, value}
    end

    test "too low" do
      type = :integer
      value = 1
      constraints = [{:min, 2}]

      assert check_constraints(value, type, constraints) ==
               {:error, :constraint_violation, "integer is less than than 2"}
    end
  end

  describe "integer upper bound" do
    test "low enough" do
      type = :integer
      value = 10
      constraints = [{:max, 10}]

      assert check_constraints(value, type, constraints) == {:ok, value}
    end

    test "too high" do
      type = :integer
      value = 11
      constraints = [{:max, 10}]

      assert check_constraints(value, type, constraints) ==
               {:error, :constraint_violation, "integer is larger than than 10"}
    end
  end

  describe "empty string" do
    test "string is empty string" do
      type = :string
      value = ""
      constraints = [{:allow_empty?, false}]

      assert check_constraints(value, type, constraints) ==
               {:error, :constraint_violation, "string is empty"}
    end

    test "string is empty string but allowed" do
      type = :string
      value = "   "
      constraints = [{:allow_empty?, true}]

      assert check_constraints(value, type, constraints) ==
               {:ok, value}
    end

    test "string is not empty string" do
      type = :string
      value = "not empty"
      constraints = [{:allow_empty?, false}]

      assert check_constraints(value, type, constraints) ==
               {:ok, value}
    end

    test "string is only whitespace" do
      type = :string
      value = "   "
      constraints = [{:allow_empty?, false}]

      assert check_constraints(value, type, constraints) ==
               {:error, :constraint_violation, "string is empty"}
    end

    test "string is only whitespace but allowed" do
      type = :string
      value = "   "
      constraints = [{:allow_empty?, true}]

      assert check_constraints(value, type, constraints) ==
               {:ok, value}
    end
  end
end
