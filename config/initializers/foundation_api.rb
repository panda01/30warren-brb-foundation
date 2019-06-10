Foundation.config do |f|
  f.unit_class = 'Unit'
  f.builders = [
    Builders::UniqueSlugBuilder,
    Builders::BuyerBuilder
  ]
  f.updaters = [
    Builders::BuyerUpdater
  ]
end
