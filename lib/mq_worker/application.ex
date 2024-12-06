defmodule MqWorker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
alias MqWorker.MessageConsumer
alias MqWorker.RabbitMq

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MqWorker.Repo,
      {Finch, name: MqWorker.Finch},
      MqWorker.RabbitMq,
      MqWorker.MessageConsumer

      # Starts a worker by calling: MwWorker.Worker.start_link(arg)
      # {MwWorker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one,
    max_restarts: 5, 
    max_seconds: 10,
    name: MqWorker.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
