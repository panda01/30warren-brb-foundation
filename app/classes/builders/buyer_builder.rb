class Builders::BuyerBuilder < Builders::Base

  def run(params, env)
    buyer_attributes = extract_buyer_attributes params
    attributes = buyer_attributes.reverse_merge slug: env.slug
    Buyer.create attributes
  end

end
