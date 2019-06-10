class Builders::BuyerUpdater < Builders::Base

  def run(params, env)
    attributes = extract_buyer_attributes params
    slug = attributes.delete 'slug'
    Buyer.where(slug: slug).first.try(:update, attributes)
  end

end
