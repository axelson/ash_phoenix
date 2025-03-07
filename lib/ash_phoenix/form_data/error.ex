defprotocol AshPhoenix.FormData.Error do
  def to_form_error(exception)
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Query.InvalidQuery do
  def to_form_error(error) do
    {error.field, error.message, error.vars}
  end
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Query.InvalidArgument do
  def to_form_error(error) do
    {error.field, error.message, error.vars}
  end
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Changes.InvalidAttribute do
  def to_form_error(error) do
    {error.field, error.message, error.vars}
  end
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Changes.InvalidArgument do
  def to_form_error(error) do
    {error.field, error.message, error.vars}
  end
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Changes.InvalidChanges do
  def to_form_error(error) do
    fields = Enum.join(error.fields || [], ",")

    for field <- error.fields || [] do
      vars =
        error.vars
        |> Keyword.put(:fields, fields)
        |> Keyword.put(:field, field)

      {field, error.message, vars}
    end
  end
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Changes.Required do
  def to_form_error(error) do
    {error.field, "is required", error.vars}
  end
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Query.NotFound do
  def to_form_error(error) do
    pkey = error.primary_key || %{}

    Enum.map(pkey, fn {key, value} ->
      {key, "could not be found", Keyword.put(error.vars, :value, value)}
    end)
  end
end

defimpl AshPhoenix.FormData.Error, for: Ash.Error.Query.Required do
  def to_form_error(error) do
    {error.field, "is required", error.vars}
  end
end
