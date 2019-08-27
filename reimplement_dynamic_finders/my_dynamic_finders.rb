module MyDynamicFinders
  private

  def respond_to_missing?(symbol, include_private)
    symbol.to_s.start_with?('find_by_')
  end

  def method_missing(name, *args)
    name = name.to_s
    if name.start_with?('find_by_')
      attr_names = name.gsub(/\Afind_by_/, '').gsub(/!\z/, '').split('_and_')

      conditions = attr_names.map.each_with_index { |attr, index| [attr, args[index]] }.to_h

      select_data = $DATABASE.find do |data|
        attr_names.all? do |attr|
          data.public_send(attr) == conditions[attr]
        end
      end

      raise if name.end_with?('!') && select_data.nil?

      select_data
    else
      super
    end
  end
end
