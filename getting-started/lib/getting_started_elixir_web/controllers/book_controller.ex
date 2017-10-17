defmodule GettingStartedElixirWeb.BookController do
  use GettingStartedElixirWeb, :controller

  alias GettingStartedElixir.Book

  @repo Application.fetch_env!(:getting_started_elixir, :storage_engine)

  import Ecto.Query

  def index(conn, _params) do
    books =
      Book
      |> order_by(:title)
      |> limit(10)
      |> offset(0)
      |> @repo.all

    conn
    |> assign(:books, books)
    |> assign(:next_page_token, nil)
    |> render("index.html")
  end

  def new(conn, _params) do
    changeset = Book.changeset(%Book{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"book" => book_params}) do
    %Book{id: UUID.uuid4()}
    |> Book.changeset(book_params)
    |> @repo.insert()
    |> case do
      {:ok, book} ->
        conn
        |> redirect(to: book_path(conn, :show, book.id))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    book = @repo.get(Book, id)

    conn
    |> assign(:book, book)
    |> render("show.html")
  end

  def delete(conn, %{"id" => id}) do
    @repo.get(Book, id)
    |> @repo.delete()

    conn
    |> redirect(to: book_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    changeset = @repo.get(Book, id)
    |> Book.changeset()

    conn
    |> render("edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "book" => book_params}) do
    Book
    |> @repo.get(id)
    |> Book.changeset(book_params)
    |> @repo.update()
    |> case do
      {:ok, book} ->
        conn
        |> redirect(to: book_path(conn, :show, book.id))
      {:error, changeset} ->
        conn
        |> render("edit.html", changeset: changeset)
    end
  end
end
