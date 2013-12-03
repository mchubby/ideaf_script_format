require 'ideaf_script_format/base_types'

module IdeafScriptFormat

  class Stcm2Opcode < BinData::Record
    endian :little
    count_bytes_remaining :bytes_remaining

    uint32 :block_size, :assert => lambda { value <= bytes_remaining }
    string :data, :length => lambda { block_size - 4 }
  end

  class Stcm2Export < BinData::Record
    EXPORT_SIZE = 40
    endian :little
  end


  class Stcm2File < BinData::Record
    alias :super_do_read :do_read
    def do_read(io) #:nodoc:
      @io = io
      super_do_read(io)
    end

    def io_offset
      @io.offset
    end
    GENERATOR_SIZE = 32
    STATIC_HEADER_SIZE = GENERATOR_SIZE + 12 * 4
    GLOBAL_SECTION_IDENTIFIER = 'GLOBAL_DATA'
    EXPORT_SECTION_IDENTIFIER = 'EXPORT_DATA'
    CODE_SECTION_WORD1 = 0x45444F43 # 'CODE'
    CODE_SECTION_WORD2 = 0x4154535F # '_STA'
    CODE_SECTION_WORD3 = 0x005F5452 # 'RT_<NUL>'
    CODE_SECTION_IDENTIFIER = 'CODE_START_'
    COLLECTION_LINK_SECTION_IDENTIFIER = 'COLLECTION_LINK'
    endian :little

    string :generator, :length => GENERATOR_SIZE #, :trim_padding => true
    uint32 :exports_offset
    uint32 :exports_count
    uint32 :header_unk_28
    uint32 :coll_link_offset
    
    array :reserved_params, :type => :uint32, :initial_length => 8
    string :globals_section_id, :length => 12 #, :trim_padding => true
    array :globals_section, :type => :uint32, :assert => lambda { value <= bytes_remaining }, :read_until => lambda {
      # give up (return truthy) after 2000 tries
      (index > 2000) || ((index > 2) &&
        (array[index-2].eql?(Stcm2File::CODE_SECTION_WORD1)) &&
        (array[index-1].eql?(Stcm2File::CODE_SECTION_WORD2)) &&
        (array[index].eql?(Stcm2File::CODE_SECTION_WORD3)))
    }
    # virtual :check_globals_size, :assert => lambda { globals_section.length < 1990 }
    skip :length => -12
    string :code_section_id, :length => 12 #, :trim_padding => true
    uint32 :code_section_word1
    uint32 :code_section_word2
    uint32 :code_section_word3
    array :code_section, :type => :Stcm2Opcode, :read_until => lambda { io_offset >= exports_offset - 16 }
    uint32 :export_section_opcode_word
    string :export_section_id, :length => 12 #, :trim_padding => true
    
    SkipTo :offset => lambda { coll_link_offset }
    uint32 :coll_link_section_word1
    uint32 :coll_link_max_offset
  end


end