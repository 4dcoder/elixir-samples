defmodule GettingStartedElixir.Repo.Migrations.AddBooksTable do
  use Ecto.Migration

  def change do
    create table(:Books, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :author, :string
      add :published_date, :date
      add :image_url, :string
      add :description, :string
    end
  end
end
