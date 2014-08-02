require 'iconv'


# Ugly !!
# Monkey patching String to enhance String#encode with iconv, when standard mechanism can't handle the conversion.
class String
  alias_method :original_string_class_encode, :encode

  def encode(*several_variants)
    res = nil
    err = nil

    # Use original method first
    begin
      res = original_string_class_encode *several_variants
    rescue => e
      err = e
    end

    if res.nil?
      begin
        target = several_variants[0]
        res = Iconv.conv target.to_s, self.encoding.to_s, self
      rescue => e
        err = e
      end
    end

    raise err if res.nil?

    res
  end

end

module RegexpM17N
  def self.non_empty?(str)
    # Comparison is done in utf-8 to work-around issue with Regex internal encoding
    str.encode('utf-8') =~ /^.+$/
  end
end