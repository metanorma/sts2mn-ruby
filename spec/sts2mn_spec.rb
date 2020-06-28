require 'tmpdir'

RSpec.describe Sts2mn do

  it 'matches the version number of JAR' do
    expect(Sts2mn::VERSION.split('.')[0..1].join('.')).to eq(Sts2mn.version)
    expect(Sts2mn::STS2MN_JAR_VERSION).to eq(Sts2mn.version)
  end

  it 'converts STS to MN XML' do

    Dir.mktmpdir do |dir|
      sts_path = File.join(dir, 'rice-en.final.mn.xml')

      begin
        Sts2mn.convert(mn_xml, sts_path)
      rescue RuntimeError => e
        puts e.message
        puts e.backtrace.inspect
        raise e
      end

      expect(File.exist?(sts_path)).to be true
    end

  end

  let(:mn_xml) do
    Pathname.new(File.dirname(__dir__)).
    join('spec', 'fixtures', 'rice-en.final.sts.xml').to_s
  end

end
