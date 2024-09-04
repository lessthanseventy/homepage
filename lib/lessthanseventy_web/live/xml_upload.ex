defmodule LessthanseventyWeb.XmlUploadLive do
  use LessthanseventyWeb, :live_view

  alias Lessthanseventy.XML

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center">
      <%= if @live_action == :index do %>
        <div class="w-full px-6 py-4">
          <table class="min-w-full leading-normal">
            <thead>
              <tr>
                <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  ID
                </th>
                <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Plaintiff
                </th>
                <th class="px-5 py-3 border-b-2 border-gray-200 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                  Defendants
                </th>
              </tr>
            </thead>
            <tbody>
              <%= for xml_upload <- @xml_uploads do %>
                <tr>
                  <td class="px-5 py-5 border-b border-gray-200 text-sm">
                    <%= xml_upload.id %>
                  </td>
                  <td class="px-5 py-5 border-b border-gray-200 text-sm">
                    <%= xml_upload.plaintiff %>
                  </td>
                  <td class="px-5 py-5 border-b border-gray-200 text-sm">
                    <%= xml_upload.defendants %>
                  </td>
                  <td class="px-5 py-5 border-b border-gray-200 text-sm">
                    <.link
                      class="bg-retroYellow text-black px-4 py-2 rounded-full"
                      href={~p"/xml_uploads/#{xml_upload.id}"}
                    >
                      View
                    </.link>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
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
end
