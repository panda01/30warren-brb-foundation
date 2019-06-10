class RadioSubset

  attr_reader :data, :prefix

  def initialize(data, prefix)
    @data = data
    @prefix = prefix
  end

  def matching(value)
    radio_options.select do |k, v|
      v == value
    end
  end

  private

  def radio_options
    subset.each_with_object({}) do |(k, v), memo|
      memo[k.gsub(prefix_with_separator, '').to_sym] = v
    end
  end

  def subset
    data.select do |k, v|
      k =~ prefix_matcher
    end
  end

  def prefix_matcher
    @matcher ||= Regexp.new("^#{prefix_with_separator}")
  end

  def prefix_with_separator
    "#{prefix}_"
  end

end
