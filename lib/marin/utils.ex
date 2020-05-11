defmodule Marin.Utils do
  @moduledoc """
    Utility module for often-used functions
  """
  import Ecto.Changeset
  alias Marin.Repo

  def ecto_utc_now do
    utc_datetime = DateTime.utc_now()

    DateTime.truncate(utc_datetime, :second)
  end

  def epoch do
    utc_datetime = DateTime.from_unix!(0)

    DateTime.truncate(utc_datetime, :second)
  end

  def traverse_changeset_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  def model_fields(model) do
    model.__schema__(:fields)
  end

  def stringify_model_fields(model, opts \\ [])

  def stringify_model_fields(model, opts) do
    excluded = Keyword.get(opts, :exclude, [])

    :fields
    |> model.__schema__()
    |> Enum.filter(&(!Enum.member?(excluded, &1)))
    |> Enum.map(&Atom.to_string/1)
    |> Enum.join(", ")
  end

  def all_changesets_valid?(changesets) do
    Enum.all?(changesets, & &1.valid?)
  end

  def apply_all_changes(changesets) do
    Enum.map(changesets, &apply_changes(&1))
  end

  def random_token(token_length) do
    token_length
    |> :crypto.strong_rand_bytes()
    |> Base.encode64()
    |> binary_part(0, token_length)
  end

  def base64_encode(data) do
    data
    |> Jason.encode!()
    |> Base.encode64()
  end

  def base64_decode(string) do
    string
    |> Base.decode64!()
    |> Jason.decode!()
  end

  def struct_to_map(struct, opts \\ []) do
    drop = Keyword.get(opts, :drop, [])

    fields =
      struct
      |> Map.get(:__struct__)
      |> model_fields()

    struct
    |> Map.take(fields)
    |> Map.drop(drop)
  end

  def structs_to_map(list, opts \\ []) do
    Enum.map(list, fn struct ->
      struct_to_map(struct, opts)
    end)
  end

  def to_int(string) do
    {integer, _} = Integer.parse(string)
    integer
  end

  def full_name(first_name, last_name) do
    String.trim("#{first_name} #{last_name}")
  end

  def fetch_association(model, association) do
    case Ecto.assoc_loaded?(Map.get(model, association)) do
      true ->
        Map.get(model, association)

      false ->
        model
        |> Repo.preload(association)
        |> Map.get(association)
    end
  end
end
