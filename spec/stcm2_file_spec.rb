require 'spec_helper'

describe IdeafScriptFormat::Stcm2File do

  let(:source) {
    if SingletonHelper.instance.get().nil?
      File.new(Dir["spec/samples/*.stcm2*"].sample, "rb").read()
    else
      File.new(SingletonHelper.instance.get(), "rb").read()
    end
  }
  let(:script) { IdeafScriptFormat::Stcm2File.read(source) }


###
  it "starts with an STCM2 or STCM2L declaration" do
    expect(script.generator).to match /\ASTCM2L? /
  end

###
  it "has known header values" do
    expect(script.reserved_params).to be_all { |n| n == 0 }
  end

###
  it "has a globals section at offset 0x50" do
    expect(BinData::Stringz.new().read(script.globals_section_id)).to eq IdeafScriptFormat::Stcm2File::GLOBAL_SECTION_IDENTIFIER
  end

###
  it "has a code section detected at some point" do
    expect(BinData::Stringz.new().read(script.code_section_id)).to eq IdeafScriptFormat::Stcm2File::CODE_SECTION_IDENTIFIER
  end

###
  it "has a special last opcode" do
    #testing expect(script.io_offset).to eq 0
    expect(BinData::Stringz.new().read(script.export_section_id)).to eq IdeafScriptFormat::Stcm2File::EXPORT_SECTION_IDENTIFIER
  end

###
  it "has a valid exports section" do
    expect(script.exports_count).to be > 0
    expect(Range.new(IdeafScriptFormat::Stcm2File::STATIC_HEADER_SIZE, source.length, exclude_end = true)).to be_cover(script.exports_offset)
    begin
      exports_zone_coverage = script.exports_offset + script.exports_count * IdeafScriptFormat::Stcm2Export::EXPORT_SIZE
      expect(exports_zone_coverage).to be <= source.length()
    end
    begin
      last_opcode = nil
      expect{last_opcode = IdeafScriptFormat::Stcm2Opcode.read(source.slice(script.exports_offset - 16, 16))}.not_to raise_error
      expect(last_opcode.block_size).to eq 16
      expect(BinData::Stringz.new().read(last_opcode.data)).to eq IdeafScriptFormat::Stcm2File::EXPORT_SECTION_IDENTIFIER
    end
  end

###
  it "may have a collection link section" do
    expect(script.header_unk_28).to eq 0
    if script.coll_link_offset > 0
      expect(Range.new(IdeafScriptFormat::Stcm2File::STATIC_HEADER_SIZE, source.length, exclude_end = true)).to be_cover(script.coll_link_offset)
      begin
        expect(BinData::Stringz.new().read(source.slice(script.coll_link_offset - 16, 16))).to eq IdeafScriptFormat::Stcm2File::COLLECTION_LINK_SECTION_IDENTIFIER
        expect(script.coll_link_section_word1).to eq 0
        expect(script.coll_link_max_offset).to eq source.length()
      end
    end
  end


end