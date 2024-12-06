defmodule MqWorker.MessageConsumer do
  alias MqWorker.Messages
  alias Postgrex.Messages
  alias MqWorker.Messages.Message
  use GenServer
  require Logger
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {channel, _queue} = MqWorker.RabbitMq.get_channel()

    case AMQP.Queue.declare(channel, "worker_queue", durable: true) do
      {:ok, _queue} ->
        case AMQP.Basic.consume(channel, "worker_queue", nil, no_ack: true) do
          {:ok, _binary} ->
            {:ok, %{channel: channel}}

          {:error, reason} ->
            Logger.error(reason)
            {:stop, reason}
        end

      {:error, reason} ->
        Logger.error(reason)
        {:stop, reason}
    end


  end

  @impl true
  def handle_info({:basic_deliver, payload, _meta}, state) do
    case Jason.decode(payload) do
      {:ok, message} ->
        case MqWorker.Messages.create_message(message) do
          {:ok, new_msg} ->

            ApiClient.post_request(new_msg)
            {:noreply, state}

          {:error, changeset} ->
            Logger.error("we got a problem in the messageconsumer handleinfo method, #{changeset}")
            {:noreply, state}
        end

      _ ->
        Logger.error("error in jason decode")
        {:noreply, state}
    end



  end


  @impl true
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, state) do
    Logger.info("Consumer registered with tag: #{consumer_tag}")
    {:noreply, state}
  end


end
