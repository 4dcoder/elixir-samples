defmodule GettingStartedElixir.Book do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "Books" do
    field :title
    field :author
    field :published_date, :date
    field :image_url
    field :description
  end

  def changeset(book, params \\ %{}) do
    book
    |> cast(params, [:title, :author, :published_date, :description])
    |> validate_required([:title, :author, :published_date, :description])
  end

end
