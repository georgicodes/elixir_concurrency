defmodule Talker do
  # infinite actor loop waiting for message to arrive.
  # each message is processed in the order they were added to the 'mailbox'
  def loop do
    receive do
      {:greet, name} -> IO.puts("Hello #{name}")
      {:praise, name} -> IO.puts("#{name}, you're amazing!")
      {:celebrate, name, age} -> IO.puts("Here's to another #{age} years, #{name}")
      {:shutdown} -> exit(:normal)
    end
    loop # tail recursive call
  end
end

Process.flag(:trap_exit, true)
pid = spawn_link(&Talker.loop/0)

send(pid, {:greet, "Huey"})
send(pid, {:praise, "Dewey"})
send(pid, {:celebrate, "Louie", 16})
send(pid, {:shutdown})

receive do
  {:EXIT, ^pid, reason} -> IO.puts("Talker has exited #{reason}")
end
