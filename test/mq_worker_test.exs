defmodule MwWorkerTest do
  use ExUnit.Case
  doctest MqWorker

  test "greets the world" do
    assert MqWorker.hello() == :world
  end
end
