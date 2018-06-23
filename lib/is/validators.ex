defmodule Is.Validators do
  @moduledoc """
  Validators namespace.
  """

  alias Is.Validators

  @doc """
  Returns list of default validators.
  """
  @spec get_default() :: [atom]
  def get_default() do
    [
      Validators.And,
      Validators.Atom,
      Validators.Binary,
      Validators.Boolean,
      Validators.Equals,
      Validators.Fn,
      Validators.If,
      Validators.Inclusion,
      Validators.InRange,
      Validators.Integer,
      Validators.Length,
      Validators.List,
      Validators.Map,
      Validators.MapKeys,
      Validators.Number,
      Validators.Optional,
      Validators.Or,
      Validators.Tuple,
      Validators.Validator,
      Validators.With,
    ]
  end
end
