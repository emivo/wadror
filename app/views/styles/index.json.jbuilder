json.array!(@styles) do |style|
  json.extract! style, :id, :name, :string,, :description, :text
  json.url style_url(style, format: :json)
end
