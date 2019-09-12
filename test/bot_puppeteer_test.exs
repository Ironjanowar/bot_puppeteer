defmodule BotPuppeteerTest do
  use ExUnit.Case
  doctest BotPuppeteer

  test "greets the world" do
    assert BotPuppeteer.hello() == :world
  end
end
