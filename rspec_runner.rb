require 'rspec'
require_relative 'lib/singleton_helper'

files = ["E:/TnKFD-INSTALL.DNS.cpk_unpacked/script/99"]
if true
  #files = Dir["E:/TnKFD-INSTALL.DNS.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }
  #files = Dir["C:/work/_TL_/hkki/*.stcm*"].reject { |f| not File.file?(f) }
  #files = Dir["C:/work/_TL_/wof/*.stcm*"].reject { |f| not File.file?(f) }
  #files = Dir["C:/work/_TL_/wof0/*.stcm*"].reject { |f| not File.file?(f) }
  #files = Dir["E:/amnesia1-INSTALL.DNS.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }
  #files = Dir["E:/amnesia1FD-INSTALL.DNS.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }
  #files = Dir["E:/amnesia2-INSTALL.DNS.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }
  #files = Dir["E:/hiiro4-INSTALL.DNS.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }
  #files = Dir["E:/kamikimi-INSTALL.DNS.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }
  #files = Dir["E:/nise-INSTALL.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }
  files = Dir["E:/diab-INSTALL.cpk_unpacked/script/*"].reject { |f| not File.file?(f) }

end

files.each do |f|
  SingletonHelper.instance.set(f)
  print "\n" * 4 + "#{f}\n"
  RSpec::Core::Runner.run(Dir["spec/*_spec.rb"])
end


