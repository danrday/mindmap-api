defimpl Phoenix.Param, for: Planatlas.Documents.Document do
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end
end