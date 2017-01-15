# Überauth Pocket

> [Pocket](https://getpocket.com) OAuth2 strategy for Überauth.

## Installation

1. Get a consumer_key from [Pocket Developer site](https://getpocket.com/developer).

1. Add `:ueberauth_pocket` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ueberauth_pocket, "~> 1.0"}]
    end
    ```

1. Add the strategy to your applications:

    ```elixir
    def application do
      [applications: [:ueberauth_pocket]]
    end
    ```

1. Add Pocket to your Überauth configuration:

    ```elixir
    config :ueberauth, Ueberauth,
      providers: [
        pocket: {Ueberauth.Strategy.Pocket, []}
      ]
    ```

1.  Update your provider configuration:

    ```elixir
    config :ueberauth, Ueberauth.Strategy.Pocket,
      consumer_key: System.get_env("POCKET_CONSUMER_KEY")
    ```

1.  Include the Überauth plug in your controller:

    ```elixir
    defmodule MyApp.AuthController do
      use MyApp.Web, :controller

      pipeline :browser do
        plug Ueberauth
        ...
       end
    end
    ```

1.  Create the request and callback routes if you haven't already:

    ```elixir
    scope "/auth", MyApp do
      pipe_through :browser

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end
    ```

1. You controller needs to implement callbacks to deal with `Ueberauth.Auth` and `Ueberauth.Failure` responses.

For an example implementation see the [Überauth Example](https://github.com/ueberauth/ueberauth_example) application.

## Calling

Depending on the configured url you can initiate the request through:

    /auth/pocket

## License

Please see [LICENSE](blob/master/LICENSE) for licensing details.
