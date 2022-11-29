# 增加eex之后，报了一个警告：

```
warning: EEx.eval_file/2 defined in application :eex is used by the current application but the current application does not depend on :eex. To fix this, you must do one of:

  1. If :eex is part of Erlang/Elixir, you must include it under :extra_applications inside "def application" in your mix.exs

  2. If :eex is a dependency, make sure it is listed under "def deps" in your mix.exs

  3. In case you don't want to add a requirement to :eex, you may optionally skip this warning by adding [xref: [exclude: [EEx]]] to your "def project" in mix.exs
```

