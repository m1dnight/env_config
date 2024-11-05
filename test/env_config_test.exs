defmodule EnvConfigTest do
  use ExUnit.Case
  doctest EnvConfig

  test "greets the world" do
    assert EnvConfig.hello() == :world
  end
end
