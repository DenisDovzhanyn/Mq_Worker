defmodule MwWorkerTest do
  use ExUnit.Case
  doctest MwWorker

  test "greets the world" do
    assert MwWorker.hello() == :world
  end
end
