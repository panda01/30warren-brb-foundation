class Gender

  def initialize(data)
    @data = data
  end

  def male?
    data.try(:downcase) == 'male'
  end

  def female?
    data.try(:downcase) == 'female'
  end

  private

  attr_reader :data

end
