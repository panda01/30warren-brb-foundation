require 'forwardable'

class Archetype < SimpleDelegator
  extend Forwardable

  def_delegator :gender, :male?
  def_delegator :gender, :female?

  def gender
    Gender.new(self['gender'])
  end

  def single?
    ['Single'].include?(self['marital_status'])
  end

  def interests
    RadioSubset.new(data, 'neigboorhood_interest').matching('1').keys
  end

  def interested_in?(subject)
    interests.include?(subject)
  end

  def purchase_intentions
    RadioSubset.new(data, 'type_of_purchase').matching('1').keys
  end

  def has_purchase_intention?(subject)
    purchase_intentions.include?(subject)
  end

  def referral_sources
    RadioSubset.new(data, 'referral_source').matching('1').keys
  end

  def referred_by?(subject)
    referral_sources.include?(subject)
  end

  def marital_status
    status = self['marital_status']
    status.blank? ? :unknown : status.downcase.to_sym
  end

  def previous_residence
    status = self['previous_residence']
    status.blank? ? :unknown : status.downcase.to_sym
  end

  def [](key) # :nodoc:
    data.key?(key) ? data[key] : super(key)
  end

  def data
    super || {}
  end

  private

end
