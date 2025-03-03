defmodule MqWorker.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias MqWorker.UserChat
  alias MqWorker.Chats
  alias Expo.Message
  alias MqWorker.Repo

  alias MqWorker.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message_by(type_of_id, id) do
    case type_of_id do

      %{"chat_id" => chat_id, "last_x_messages" => last_x_messages} ->

        case Chats.get_userchat_by_user_and_chat_id(%{"user_id" => id, "chat_id" => chat_id}) do

         %UserChat{} ->
            messages = Repo.all(
            from x in Message,
            where: x.chat_id == ^chat_id,
            order_by: [desc: x.inserted_at],
            limit: ^String.to_integer(last_x_messages)
            )
            {:ok, messages}

          nil -> {:unauthorized}
       end

      _ ->
        []
    end
  end





  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    case Chats.get_userchat_by_user_and_chat_id(%{"user_id" => attrs["user_id"], "chat_id" => attrs["chat_id"]}) do
    %UserChat{} ->
      if attrs["content"] == "" do
        IO.puts("bozo why")
      else
        message = %Message{}
          |> Message.changeset(attrs)
          |> Repo.insert()


        chat = Chats.get_chat_by_chat_id(attrs["chat_id"])

        Chats.update_chat(chat, %{"last_msg_time" => elem(message, 1).inserted_at})

        message
      end
    nil -> {:unauthorized}

    _ -> IO.puts('wtf')
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
