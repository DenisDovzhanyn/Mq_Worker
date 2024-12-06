defmodule MqWorker.Repo do
  use Ecto.Repo,
    otp_app: :mq_worker,
    adapter: Ecto.Adapters.Postgres
end
