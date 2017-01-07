defmodule Ueberauth.Strategy.Pocket do
  @moduledoc false
  use Ueberauth.Strategy, uid_field: :username

  alias Ueberauth.Auth.Info
  alias Ueberauth.Auth.Credentials
  alias Ueberauth.Auth.Extra

  @request_token_endpoint "https://getpocket.com/v3/oauth/request"
  @authorize_endpoint "https://getpocket.com/auth/authorize"
  @access_token_endpoint "https://getpocket.com/v3/oauth/authorize"
  @headers [
    {"Content-Type", "application/json; charset=UTF8"},
    {"X-Accept", "application/json"}
  ]

  def handle_request!(conn) do
    %{"code" => req_token} = post!(
      @request_token_endpoint,
      %{redirect_uri: callback_url(conn)}
    )
    put_session(conn, :pocket_request_token, req_token)
    |> auth_redirect(req_token)
  end

  def auth_redirect(conn, req_token) do
    params = %{
      request_token: req_token,
      redirect_uri: callback_url(conn)
    }
    redirect!(conn, authorize_url(params))
  end

  defp authorize_url(params) do
   "#{@authorize_endpoint}?#{URI.encode_query(params)}"
  end

  def handle_callback!(conn) do
    token = get_session(conn, :pocket_request_token)
    handle_callback_token(conn, token)
  end

  def handle_callback_token(conn, nil) do
    set_errors!(conn, [error("missing_request_token", "Can't find request token")])
  end

  def handle_callback_token(conn, req_token) do
    %{
      "access_token" => access_token,
      "username" => username
    } = post!(@access_token_endpoint, %{code: req_token})

    conn
    |> put_private(:pocket_user, username)
    |> put_private(:pocket_token, access_token)
  end

  defp consumer_key do
    env = Application.get_env(:ueberauth, Ueberauth.Strategy.Pocket)
    env || raise("""
      Missing configuration for Ueberauth pocket strategy!
      Make sure the :ueberauth_pocket has been added to the application list in mix.exs
    """
    env[:consumer_key] || raise("Missing consumer_key in Ueberauth pocket strategy configuration")
  end

  defp post!(url, extra_params) do
    post_body = %{consumer_key: consumer_key()}
      |> Map.merge(extra_params)
      |> Poison.encode!
    %{
      status_code: 200,
      body: body
    } = HTTPoison.post!(url, post_body, @headers)
    Poison.decode!(body)
  end

  @doc false
  def handle_cleanup!(conn) do
    conn
    |> put_private(:pocket_user, nil)
    |> put_private(:pocket_token, nil)
  end

  @doc false
  def uid(conn), do: conn.private.pocket_user

  @doc false
  def credentials(conn) do
    %Credentials{token: conn.private.pocket_token, expires: false}
  end

  @doc false
  def info(conn), do: %Info{nickname: conn.private.pocket_user}

  @doc false
  def extra(conn) do
    %Extra{raw_info: %{
      access_token: conn.private.pocket_token,
      username: conn.private.pocket_user}
    }
  end
end
