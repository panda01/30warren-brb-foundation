require 'foundation/builder'

class Builders::Base < Foundation::Builder

  def extract_buyer_attributes params
    params.clone.to_h.tap do |attributes|
      transfer_param! attributes, from: :sales_agent, to: :helped_by
      transfer_param! attributes, from: :unit_ids, to: :units_of_interest do |unit_ids|
        Unit.where(id: unit_ids).all
      end
    end
  end

  def transfer_param! attributes, from:, to:
    attribute = attributes.delete(from.to_s) || attributes.delete(from)
    return if attribute.nil?
    attributes[to.to_sym] = block_given? ? yield(attribute) : attribute
  end

end
