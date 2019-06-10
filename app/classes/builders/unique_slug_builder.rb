require 'foundation/builder'

class Builders::UniqueSlugBuilder < Foundation::Builder

  def run(params, env)
    env.slug = first_unique_permutation_of env.slug
  end

  protected

  def first_unique_permutation_of slug
    available_slugs = available_permutations_of slug
    if available_slugs.any?
      available_slugs.first
    else
      append_available_number slug
    end
  end

  def available_permutations_of slug
    permutations = slug_permutations_for slug
    existing_permutations = find_existing_permutations permutations
    permutations - existing_permutations
  end

  def find_existing_permutations permutations
    Buyer.where(slug: permutations).pluck :slug
  end

  def slug_permutations_for slug
    Permutations.new(slug) do
      add { slug }                         # foo-bar
      add { [parts[0][0], parts[1]].join } # fbar
      add { [parts[0], parts[1][0]].join } # foob
      add { [parts[0], parts[1]].join }    # foobar
      add { [parts[1], parts[0]].join }    # barfoo
    end
  end

  def similar_slugs_for slug
    Buyer.where('slug LIKE ?', "#{slug}%").pluck :slug
  end

  def append_available_number slug
    similar_slugs = similar_slugs_for slug

    index = 1
    numeric_slug = "#{slug}-#{index}"

    while similar_slugs.include? numeric_slug
      index += 1
      numeric_slug = "#{slug}-#{index}"
    end

    numeric_slug
  end

  class Permutations < Array

    attr_accessor :slug

    def initialize(slug, &block)
      @slug = slug

      self.instance_eval(&block) if block_given?
    end

    def add(*args)
      if block_given?
        begin
          self.<< yield
        rescue
        end
      else
        self.<< *args
      end
    end

    def parts
      slug.split '-'
    end

  end

end
