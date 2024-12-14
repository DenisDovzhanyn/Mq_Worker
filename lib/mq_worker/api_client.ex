defmodule ApiClient do
  require Logger
  def post_request_message(message) do
    #please god remember to remove this hard coding
    url = "http://localhost:4001/api/send_to_client"
    headers = [{"Content-Type", "Application/json"}]
    body = %{"message" => message} |> Jason.encode!()
    req = Finch.build(:post, url, headers, body)

    case Finch.request(req, MqWorker.Finch) do
      {:ok, %Finch.Response{status: 200, body: _response_body}} ->
        {:ok}
      _ ->
        Logger.error("error posting message to websocket service")
    end
  end

  def post_request_key(request) do
    url = "http://localhost:4001/api/request_chat_key"
    headers = [{"Content-Type", "Application/json"}]
    body = %{"request" => request} |> Jason.encode!()

    req = Finch.build(:post, url, headers, body)

    case Finch.request(req, MqWorker.Finch) do
      {:ok, %Finch.Response{status: 200, body: _response_body}} ->
        {:ok}
      _ ->
        Logger.error("error posting message to websocket service")
    end
  end
end
