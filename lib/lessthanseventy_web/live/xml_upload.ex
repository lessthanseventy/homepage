defmodule LessthanseventyWeb.XmlUploadLive do
  use LessthanseventyWeb, :live_view

  alias Lessthanseventy.XML

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      <%= if @live_action == :index do %>
        <.table id="users" rows={@xml_uploads}>
          <:col :let={xml_upload} label="id"><%= xml_upload.id %></:col>
          <:col :let={xml_upload} label="plaintiff"><%= xml_upload.plaintiff %></:col>
          <:col :let={xml_upload} label="defendants"><%= xml_upload.defendants %></:col>
          <:action :let={xml_upload}>
            <div class="flex flex-row items-center justify-center">
              <.link
                class="bg-retroYellow text-black mx-4 px-4 py-2 rounded-full self-stretch flex items-center justify-center"
                href={~p"/xml_uploads/#{xml_upload.id}"}
              >
                View
              </.link>
              <.button
                class="bg-red-500 text-white mx-4 px-4 py-2 rounded-full self-stretch flex items-center justify-center"
                phx-click="delete"
                phx-value-id={xml_upload.id}
              >
                Delete
              </.button>
            </div>
          </:action>
        </.table>
      <% end %>
      <%= if @live_action == :show do %>
        <div class="flex flex-col items-left justify-center">
          <%= Phoenix.HTML.raw(XML.format_xml(@xml_upload.content)) %>
        </div>
      <% end %>
      <%= if @live_action == :upload do %>
        <div
          class="h-96 w-1/2 bg-slate-800 my-5 flex flex-col items-center justify-center"
          phx-drop-target={@uploads.xml_upload.ref}
        >
          Drop XML file here.
        </div>
        <form
          id="upload-form"
          class="h-3/4"
          phx-change="validate"
          phx-submit="save"
          phx-hook="UploadHook"
        >
          <.live_file_input
            class="bg-brand text-black px-4 py-2 rounded-full"
            upload={@uploads.xml_upload}
          />
          <button class="bg-retroYellow text-black px-4 py-2 rounded-full" type="submit">
            Upload
          </button>
        </form>
        <%= if @error do %>
          <p><%= @error %></p>
        <% end %>
        <div :if={@plaintiff && @defendants} class="my-5">
          <div>
            Plaintiff: <%= @plaintiff %>
          </div>
          <div>
            Defendants: <%= @defendants %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> allow_upload(:xml_upload, accept: ~w(.xml), max_entries: 1)
      |> assign(:error, nil)
      |> assign(:plaintiff, nil)
      |> assign(:defendants, nil)
      |> assign(:xml_upload, nil)
      |> assign(:xml_uploads, nil)
      |> assign(:uploaded_files, [])

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _url, %{assigns: %{live_action: :index}} = socket) do
    xml_uploads = XML.list_xml_uploads()
    {:noreply, assign(socket, xml_uploads: xml_uploads)}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    id = String.to_integer(id)

    case XML.get_xml_upload(id) do
      nil ->
        {:noreply, assign(socket, error: "XML not found")}

      xml_upload ->
        {:noreply, assign(socket, xml_upload: xml_upload)}
    end
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "validate",
        %{"xml_file" => xml_upload},
        socket
      ) do
    {plaintiff, defendants} =
      xml_upload["content"]
      |> XML.parse()

    {:noreply,
     assign(socket,
       xml_upload: xml_upload,
       error: nil,
       plaintiff: plaintiff,
       defendants: defendants
     )}
  end

  def handle_event("validate", %{"_target" => ["xml_upload"]}, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, assign(socket, error: "Please upload a valid XML file.")}
  end

  def handle_event("save", _params, socket) do
    %{assigns: %{xml_upload: xml_upload, plaintiff: plaintiff, defendants: defendants}} = socket

    uploaded_files =
      consume_uploaded_entries(
        socket,
        :xml_upload,
        fn _path, _entry ->
          attrs = %{
            content: xml_upload["content"],
            plaintiff: plaintiff,
            defendants: defendants
          }

          case XML.create_xml_upload(attrs) do
            {:ok, xml_upload} -> {:ok, xml_upload}
            {:error, _reason} -> {:error, "Failed to upload XML"}
          end
        end
      )

    socket =
      socket
      |> put_flash(:info, "XML uploaded successfully")
      |> assign(%{plaintiff: nil, defendants: nil})

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    id
    |> String.to_integer()
    |> XML.get_xml_upload()
    |> XML.delete_xml_upload()

    {:noreply, assign(socket, :xml_uploads, XML.list_xml_uploads())}
  end
end
