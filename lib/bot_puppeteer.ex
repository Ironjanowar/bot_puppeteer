defmodule BotPuppeteer do
  import System, only: [cmd: 3]
  import IO.ANSI

  def main(args) do
    bots =
      "bots.puppet"
      |> File.read()
      |> elem(1)
      |> String.split("\n", trim: true)

    case args do
      ["reset", "all"] ->
        Enum.each(bots, fn bot ->
          IO.puts("#{green()}Resetting #{bot}...#{default_color()}")
          cmd("make", ["stop"], cd: bot)
          cmd("make", ["start"], cd: bot)
        end)

      ["reset", bot] ->
        IO.puts("#{green()}Resetting #{bot}...#{default_color()}")
        cmd("make", ["stop"], cd: bot, into: IO.stream(:stdio, :line))
        cmd("make", ["start"], cd: bot, into: IO.stream(:stdio, :line))

      ["start", "all"] ->
        Enum.each(bots, fn bot ->
          IO.puts("#{green()}Starting #{bot}...#{default_color()}")
          cmd("make", ["start"], cd: bot)
        end)

      ["start", bot] ->
        IO.puts("#{green()}Starting #{bot}...#{default_color()}")
        cmd("make", ["start"], cd: bot)

      ["stop", "all"] ->
        Enum.each(bots, fn bot ->
          IO.puts("#{green()}Stopping #{bot}...#{default_color()}")
          cmd("make", ["stop"], cd: bot)
        end)

      ["stop", bot] ->
        IO.puts("#{green()}Stopping #{bot}...#{default_color()}")
        cmd("make", ["stop"], cd: bot)

      _ ->
        help_message = """
        #{cyan()}Usage: bot_puppeteer <Options>
        Options:#{default_color()}#{bright()}
          reset all - Stops and starts all the bots in the directory
          reset <bot> - Stops and starts a given bot from the directory
          start <bot> - Starts a bot from the directory
          stop all - Stops all the bots in the directory
          stop <bot> - Stops a bot from the directory#{normal()}
        """

        IO.puts(help_message)
    end
  end
end
