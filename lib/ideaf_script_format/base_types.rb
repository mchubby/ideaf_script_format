#fix https://github.com/tenderlove/psych/issues/50
Kernel.send(:undef_method, :y) if Kernel.method_defined? :y
BinData::Struct::RESERVED.delete :y

#-- /begin baseprimitive_opcodeblk.rb --#

# unused yet

module IdeafScriptFormat
  class OpcodeBlock < BinData::BasePrimitive

    #---------------
    private

    def value_to_binary_string(str)
      binary_string(str)
    end

    def read_and_return_value(io)
      base_offset = io.offset
      startchunk = io.readbytes(4)
      key = startchunk.unpack("V").first
      if key == 0 or (key & 3) != 0
        raise ValidityError, "at offset = #{base_offset} found blocklen = #{key}, not valid (must be a non-zero multiple of 4)"
      end
      if (key > 4)
        startchunk + io.readbytes(key - 4)
      else
        startchunk
      end
    end

    def sensible_default
      ""
    end

  end
end

#-- /end baseprimitive_opcodeblk.rb --#

class SkipTo < BinData::BasePrimitive

  mandatory_parameter :offset

  #---------------
  private

  def value_to_binary_string(val)
    ""
  end

  def read_and_return_value(io)
    offset = eval_parameter(:offset)
    current_position = io.offset
    io.seekbytes(offset - current_position)
    ""
  end

  def sensible_default
    ""
  end
end


