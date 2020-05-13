defmodule Planatlas.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias Planatlas.Repo
  alias Planatlas.Accounts

  alias Planatlas.Accounts.UserDocument
  alias Planatlas.Documents.Document
  alias Planatlas.Documents.Annotation
  alias Planatlas.Documents.Permalink, as: P

  def annotate_document(%Accounts.User{id: user_id}, document_id, attrs) do
    %Annotation{document_id: document_id, user_id: user_id}
    |> Annotation.changeset(attrs)
    |> Repo.insert()
  end

  def list_annotations(%Document{} = document, since_id \\ 0) do
    Repo.all(
      from a in Ecto.assoc(document, :annotations),
        where: a.id > ^since_id,
        order_by: [asc: a.at, asc: a.id],
        limit: 500,
        preload: [:user]
    )
  end

  def list_user_documents(%Accounts.User{} = user) do
    UserDocument
    |> user_documents_query(user)
    |> Repo.all()
    # |> Repo.preload(:document) does this make another call to the db?
    |> Enum.map(&(&1.document))
  end

  defp user_documents_query(query, %Accounts.User{id: user_id}) do
    from(v in query, 
         where: v.user_id == ^user_id,
         preload: [:document]
         )
  end

  defp user_document_query(query, %Accounts.User{id: user_id}, document_id) do
    from(v in query, 
         where: v.user_id == ^user_id,
         where: v.document_id == ^document_id,
         preload: [:document]
         )
  end

  def get_user_document!(%Accounts.User{} = user, id) do
    {:ok, cast_id} = P.cast(id)

    %UserDocument{ user_role: user_role, document: document} = UserDocument
      |> user_document_query(user, cast_id)
      |> Repo.one

      document
  end

  @doc """
  Returns the list of documents.

  ## Examples

      iex> list_documents()
      [%Document{}, ...]

  """
  def list_documents() do
    Repo.all(Document)
  end

  @doc """
  Gets a single document.

  Raises `Ecto.NoResultsError` if the Document does not exist.

  ## Examples

      iex> get_document!(123)
      %Document{}

      iex> get_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_document!(id), do: Repo.get!(Document, id)

  @doc """
  Creates a document.

  ## Examples

      iex> create_document(%{field: value})
      {:ok, %Document{}}

      iex> create_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def insert_single_user_document(user, document) do
    %UserDocument{}
    |> UserDocument.changeset(%{user_role: "admin"})
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:document, document)
    |> Repo.insert()
  end

  def create_user_document({:ok, document}, %Accounts.User{} = user) do

    allusers = Repo.all(Planatlas.Accounts.User)

    result =
    allusers
    |> Enum.map(fn x -> insert_single_user_document(x, document) end)
    |> IO.inspect
    
    # note: error check? 

    # case result do
    #   {:ok, user_document} ->
        {:ok, document}

    #   _ ->
    #     result
    # end
  end

  def create_user_document({:error, changeset}, _user) do
    {:error, changeset}
  end

  def create_document(attrs \\ %{}, %Accounts.User{} = user) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a document.

  ## Examples

      iex> update_document(document, %{field: new_value})
      {:ok, %Document{}}

      iex> update_document(document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_document(%Document{} = document, attrs) do
    document
    |> Document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a document.

  ## Examples

      iex> delete_document(document)
      {:ok, %Document{}}

      iex> delete_document(document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_document(%Document{} = document) do
    Repo.delete(document)
  end

  def delete_annotations(%Document{} = document) do
    from(d in Annotation, where: d.document_id == ^document.id)
    |> Repo.delete_all
  end

  def delete_user_documents(%Document{} = document) do
    from(d in UserDocument, where: d.document_id == ^document.id)
    |> Repo.delete_all
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking document changes.

  ## Examples

      iex> change_document(document)
      %Ecto.Changeset{source: %Document{}}

  """
  def change_document(%Document{} = document) do
    Document.changeset(document, %{})
  end
end
