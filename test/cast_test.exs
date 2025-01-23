defmodule EnvConfig.CastTest do
  use ExUnit.Case
  doctest EnvConfig
  import EnvConfig.Cast

  describe "atom" do
    test "values cast to atoms" do
      assert cast("Foo", :atom) == {:ok, :Foo}
    end

    test "Elxir.Atom casts to Atom" do
      assert cast("Elixir.Foo", :atom) == {:ok, Foo}
    end
  end

  describe "boolean" do
    test "truthy values cast to true" do
      truthy = ["true", "TRUE", "1"]

      for value <- truthy do
        assert cast(value, :boolean) == {:ok, true}, "Expected '#{value}' to cast to true"
      end
    end

    test "falsy values cast to false" do
      truthy = ["false", "FALSE", "0"]

      for value <- truthy do
        assert cast(value, :boolean) == {:ok, false}, "Expected '#{value}' to cast to false"
      end
    end

    test "invalid inputs return an error" do
      assert cast("foo", :boolean) == {:error, :cast_fail, "boolean expected, got 'foo'."}
    end
  end

  describe "integer" do
    test "integer values cast to integers" do
      assert cast("42", :integer) == {:ok, 42}
    end

    test "invalid inputs return an error" do
      assert cast("foo", :integer) == {:error, :cast_fail, "integer expected, got 'foo'"}
    end
  end

  describe "string" do
    test "string values cast to strings" do
      assert cast("foo", :string) == {:ok, "foo"}
    end

    test "empty string is allowed" do
      assert cast("", :string) == {:ok, ""}
    end
  end

  describe "list" do
    test "list of booleans" do
      assert cast("true,false,true", {:list, :boolean}) == {:ok, [true, false, true]}
    end

    test "list of integers" do
      assert cast("1,2,3,4,5", {:list, :integer}) == {:ok, [1, 2, 3, 4, 5]}
    end

    test "list of strings" do
      assert cast("1,2,3,4,5", {:list, :string}) == {:ok, ["1", "2", "3", "4", "5"]}
    end
  end

  describe "enum" do
    test "enum value" do
      assert cast("foo", {:enum, ["foo", "bar"]}) == {:ok, "foo"}
    end

    test "invalid enum value" do
      assert cast("food", {:enum, ["foo", "bar"]}) ==
               {:error, :cast_fail, "'food' not in enum [\"foo\", \"bar\"]"}
    end
  end
end
