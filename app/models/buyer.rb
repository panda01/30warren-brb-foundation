class Buyer < ActiveRecord::Base
  include Brb::Model::Full

  has_and_belongs_to_many :units_of_interest, class_name: 'Unit'

  has_heading 'First Name', link: 'first_name'
  has_heading 'Last Name',  link: 'last_name'
  has_heading 'Email',      link: 'email'
  has_heading 'Subdomain',  link: 'slug', default: true

  serialize :data

  def self.from_param(param)
    find_by_slug!(param)
  end

  def full_name
    [first_name, last_name].join ' '
  end

  def archetype
    Archetype.new(self)
  end

end
