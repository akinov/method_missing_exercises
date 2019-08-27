module MyDynamicFinders
  private

  def respond_to_missing?(symbol, include_private)
    symbol.to_s.start_with?('find_by_')
  end

  def method_missing(name, *args)
    name = name.to_s
    if name.start_with?('find_by_')
      attr_names = name.delete_prefix('find_by_').delete_suffix('!').split('_and_')

      conditions = attr_names.zip(args)

      select_data = $DATABASE.find do |data|
        conditions.all? do |key, value|
          data.public_send(key) == value
        end
      end

      raise if name.end_with?('!') && select_data.nil?

      select_data
    else
      super
    end
  end
end
