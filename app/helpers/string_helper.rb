module StringHelper
  def substring_between(start, stop, string)
    string[/#{start}(.*?)#{stop}/m, 1]
  end
end
