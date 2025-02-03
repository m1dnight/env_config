# EnvConfig

EnvConfig is a library that makes it easier to write `runtime.exs` files that take in parameters
from the environment.

The idea is that `EnvConfig` allows you to define which environment variables an application needs,
what their type is expected to be, and whether they are optional for the application to start.

The api ensures that the values are read from the environment and are cast into their proper Elixir types.

**Before**
```elixir
import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  if System.get_env("PHX_SERVER") do
    config :my_app, MyAppWeb.Endpoint, server: true
  end
end
```

**After**

```elixir
import Config
require EnvConfig.Macros
import EnvConfig.Macros

if config_env() == :prod do
  secret_key_base = required("SECRET_KEY_BASE", :string, min_length: 64)

  phx_server = optional("PHX_SERVER", :boolean, false)
  config :my_app, MyAppWeb.Endpoint, server: phx_server
end
```

If the environment variable is not defined, you will see the same error.

```text
** (RuntimeError) Environment variable SECRET_KEY_BASE is not set
    /Users/christophe/Documents/Code/loomy/data-api/config/runtime.exs:5: (file)
    (stdlib 6.2) erl_eval.erl:919: :erl_eval.do_apply/7
    (stdlib 6.2) erl_eval.erl:663: :erl_eval.expr/6
    (stdlib 6.2) erl_eval.erl:271: :erl_eval.exprs/6
    (elixir 1.18.1) lib/code.ex:572: Code.validated_eval_string/3
```

Or, when the type or constraints are not met, an error explaining whats wrong.

```text
** (RuntimeError) Environment variable SECRET_KEY_BASE does not meet constraints. string is shorter than 64 characters
    /Users/christophe/Documents/Code/loomy/data-api/config/runtime.exs:5: (file)
    (stdlib 6.2) erl_eval.erl:919: :erl_eval.do_apply/7
    (stdlib 6.2) erl_eval.erl:663: :erl_eval.expr/6
    (stdlib 6.2) erl_eval.erl:271: :erl_eval.exprs/6
    (elixir 1.18.1) lib/code.ex:572: Code.validated_eval_string/3
```


## Installation

The package can be installed
by adding `env_config` to your list of dependencies in `mix.exs`:

The package will be published on hex as soon as it is stable enough.

```elixir
def deps do
  [
    {:env_config, git: "https://github.com/m1dnight/env_config"}
  ]
end
```

## Types

EnvConfig supports basic types out of the box, and lists of these types.

| Type                | Values                                                                       | Elixir Type  |
|---------------------|------------------------------------------------------------------------------|--------------|
| `:boolean`          | `true`, `TRUE`, `1`, `false`, `FALSE`, `0`                                   | `boolean()`  |
| `:string`           | any value                                                                    | `String.t()` |
| `:atom`             | any value                                                                    | `atom()`     |
| `:charlist`         | any value                                                                    | `charlist()` |
| `:integer`          | any integral value that's parsable as an integer using `&Integer.parse/1`    | `integer()`  |
| `:float`            | any value that's parsable as a float using `&Float.parse/1`                  | `float()`    |
| `{:list, type}`     | a comma-separated list of values for any given type in the above table.      | `[type]`     |
| `{:enum, [binary]}` | any value that is a member of the values given in the list of the enum type. | `String.t()` |

## Constraints

| Constraint                   | Applicaple types | Description                                                                      |
|------------------------------|------------------|----------------------------------------------------------------------------------|
| `{:length, n}`               | `{:list, type}`  | Exact length the list should be.                                                 |
| `{:min_length n}`            | `{:list, type}`  | Minimal length the list should be.                                               |
| `{:max_length, n}`           | `{:list, type}`  | Maximal length the list should be.                                               |
| `{:min, n}`                  | `:integer`       | Minimal value for the integer.                                                   |
| `{:max, n}`                  | `:integer`       | Maximum value for the integer.                                                   |
| `{:allow_empty?, boolean()}` | `:string`        | Is the env value allowed to be empty? Strings are trimmed before getting length. |
| `{:max_length, n}`           | `:string`        | Maximum length of the string. Strings are trimmed before getting length.         |
| `{:min_length, n}`           | `:string`        | Minimal length of the string. Strings are trimmed before getting length.         |