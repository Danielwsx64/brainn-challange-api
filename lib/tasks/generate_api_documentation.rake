desc(
  'Generate an API Documentation according apiblueprint.org. The doc is ' \
  'generated using request specs tagged as :dox. This task use Dox gem and ' \
  'Aglio to generate doc files.'
)
task generate_api_docs: :environment do
  `rspec spec/requests/ -f Dox::Formatter --tag dox --out doc/api_spec.md`
  `aglio -i doc/api_spec.md -o doc/api_spec.html`
end
