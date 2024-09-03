defmodule LessthanseventyWeb.Router do
  use LessthanseventyWeb, :router

  pipeline :browser do
    plug LessthanseventyWeb.Plug.WWW
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LessthanseventyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LessthanseventyWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/xml_upload", XmlUploadLive, :upload
    live "/xml_upload/index", XmlUploadLive, :index
    live "/xml_upload/:id", XmlUploadLive, :show
  end

  # Other scopes may use custom stacks.
  scope "/api", LessthanseventyWeb do
    pipe_through :api
    resources "/xml_uploads", XMLUploadController, except: [:new, :edit]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:lessthanseventy, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LessthanseventyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
