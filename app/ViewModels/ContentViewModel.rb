
class ContentViewModel
  attr_accessor :title, :description
  def initialize(
    title: nil,
    description: nil)
    @title = title
    @description = description
    @errors = {}
  end
end
