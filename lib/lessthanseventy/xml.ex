defmodule Lessthanseventy.XML do
  import Meeseeks.XPath

  @moduledoc """
  The XML context.
  """

  import Ecto.Query, warn: false
  alias Lessthanseventy.Repo

  alias Lessthanseventy.XML.XMLUpload

  @doc """
  Returns the list of xml_uploads.

  ## Examples

      iex> list_xml_uploads()
      [%XMLUpload{}, ...]

  """
  def list_xml_uploads do
    Repo.all(XMLUpload)
  end

  @doc """
  Gets a single xml_upload.

  Raises `Ecto.NoResultsError` if the Xml upload does not exist.

  ## Examples

      iex> get_xml_upload(123)
      {:ok %XMLUpload{}}

      iex> get_xml_upload(456)
      ** (Ecto.NoResultsError)

  """
  def get_xml_upload(id), do: Repo.get(XMLUpload, id)

  @doc """
  Creates a xml_upload.

  ## Examples

      iex> create_xml_upload(%{field: value})
      {:ok, %XMLUpload{}}

      iex> create_xml_upload(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_xml_upload(attrs \\ %{}) do
    %XMLUpload{}
    |> XMLUpload.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a xml_upload.

  ## Examples

      iex> update_xml_upload(xml_upload, %{field: new_value})
      {:ok, %XMLUpload{}}

      iex> update_xml_upload(xml_upload, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_xml_upload(%XMLUpload{} = xml_upload, attrs) do
    xml_upload
    |> XMLUpload.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a xml_upload.

  ## Examples

      iex> delete_xml_upload(xml_upload)
      {:ok, %XMLUpload{}}

      iex> delete_xml_upload(xml_upload)
      {:error, %Ecto.Changeset{}}

  """
  def delete_xml_upload(%XMLUpload{} = xml_upload) do
    Repo.delete(xml_upload)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking xml_upload changes.

  ## Examples

      iex> change_xml_upload(xml_upload)
      %Ecto.Changeset{data: %XMLUpload{}}

  """
  def change_xml_upload(%XMLUpload{} = xml_upload, attrs \\ %{}) do
    XMLUpload.changeset(xml_upload, attrs)
  end

  def parse(xml) do
    # Select the text nodes
    text_nodes =
      xml
      |> Meeseeks.parse(:xml)
      |> Meeseeks.all(xpath("//line"))

    # Convert the text nodes to a list of strings
    texts =
      text_nodes
      |> Enum.map(&Meeseeks.text/1)
      # Filter out nodes without all caps sequence
      |> Enum.filter(&String.match?(&1, ~r/[A-Z]+/))

    # Find the start and end indices for the plaintiff and defendant
    plaintiff_index =
      Enum.find_index(texts, &String.starts_with?(String.trim(&1), "Plaintiff,"))

    plaintiff =
      texts
      # Get all strings before "Plaintiff,"
      |> Enum.slice(0..(plaintiff_index - 1))
      # Reverse the order
      |> Enum.reverse()
      # Find the first string that matches the pattern
      |> Enum.find(&String.match?(&1, ~r/\b[A-Z]+\s[A-Z]+\b/))
      |> clean_parsed_string()

    defendants_index =
      Enum.find_index(texts, &String.contains?(String.trim(&1), "Defendants."))

    defendants =
      texts
      # Get all strings before "Defendants,"
      |> Enum.slice((plaintiff_index + 1)..(defendants_index - 1))

    defendant_index =
      defendants
      |> Enum.find_index(&String.match?(&1, ~r/^[A-Z]{2,}.*/))

    defendants_string =
      defendants
      |> Enum.slice(defendant_index..-1//1)
      |> Enum.join(" ")
      |> clean_parsed_string()

    {plaintiff, defendants_string}
  end

  defp clean_parsed_string(str) do
    str =
      str
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.trim()

    if String.ends_with?(str, ",") do
      String.slice(str, 0..-2//-1)
    else
      str
    end
  end

  def format_xml(xml, tab \\ "\t") do
    xml
    |> String.split(~r/>\s*</)
    |> Enum.reduce({"", ""}, fn node, {formatted, indent} ->
      indent =
        if Regex.match?(~r/^\/\w/, node),
          do: String.slice(indent, 0, byte_size(indent) - byte_size(tab)),
          else: indent

      formatted = formatted <> indent <> "<" <> node <> ">\n"
      indent = if Regex.match?(~r/^<?\w[^>]*[^\/]$/, node), do: indent <> tab, else: indent
      {formatted, indent}
    end)
    |> elem(0)
    |> (&String.slice(&1, 1, byte_size(&1) - 3)).()
  end
end
