defmodule BotPuppeteer do
  import System, only: [cmd: 3]
  import IO.ANSI

  defp execute_command(args, bots) do
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

  def main(args) do
    bot_file = "bots.puppet"

    if File.exists?(bot_file) do
      bots =
        bot_file
        |> File.read()
        |> elem(1)
        |> String.split("\n", trim: true)

      execute_command(args, bots)
    else
      IO.puts("""
      #{red()}Error: File 'bots.puppet' does not exist.
      The format should be a bot directory in each line, for example:
        bot_1
        bot_2
        bot_3#{default_color()}
      """)
    end
  end
end
