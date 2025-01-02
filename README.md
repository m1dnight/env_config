# EnvConfig

EnvConfig is a library that makes it easier to write `runtime.exs` files that take in parameters
from the environment.

The idea is that EnvConfig allows you to define which environment variables an application needs,
what their type is expected to be, and whether they are optional for the application to start.

## Installation

The package can be installed
by adding `env_config` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:env_config, "~> 0.1.0"}
  ]
end
```

## Types

  - `:boolean`
  - `:integer`
    - Constraints
      - `{:min, integer}`: minimal required value
      - `{:max, integer}`: maximal required value
  - `:string`
    - Constraints
      - `{:allow_empty?, boolean}`: allow the (trimmed) string to be empty
      - `{:min_length, integer}`: minimal length of the string
      - `{:max_length, integer}`: maximum length of the string

## Example
