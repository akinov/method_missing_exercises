class MyStringInquirer
  def initialize(str)
    @str = str
  end

  def respond_to_missing?(symbol, include_private)
    symbol.to_s.end_with?('?')
  end

  def method_missing(name, *args)
    if name.to_s.end_with?('?')
      @env.to_s == name.to_s.gsub(/\?\z/, '')
    else
      super
    end
  end
end
