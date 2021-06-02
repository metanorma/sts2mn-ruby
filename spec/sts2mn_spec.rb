require 'tmpdir'

RSpec.describe Sts2mn do


  it 'matches the version number of JAR' do
    expect(Sts2mn::VERSION.split('.')[0..1].join('.')).to eq(Sts2mn.version)
    expect(Sts2mn::STS2MN_JAR_VERSION).to eq(Sts2mn.version)
  end

  %w(adoc xml).each do |format|
    it "converts STS to MN #{format} in specified location" do
      convert_to_format(format)
    end
  end

  def convert_to_format(format)
    Dir.mktmpdir do |dir|
      sts_path = -> (format) { File.join(dir, "sts.#{format}") }
      mn_path = -> (format) { File.join(dir, "mn.#{format}") }

      source = sts_path.('xml')
      mn_dest = mn_path.(format)
      FileUtils.cp(sts_xml, source)

      begin
        Sts2mn.convert(input: source,
                       output: mn_dest,
                       format: format)
      rescue RuntimeError => e
        puts e.message
        puts e.backtrace.inspect
        raise e
      end

      expect(File.exist?(mn_dest)).to be true
    end
  end

  it "converts STS to MN adoc by default" do
    Dir.mktmpdir do |dir|
      sts_path = -> (format) { File.join(dir, "sts.#{format}") }

      source = sts_path.('xml')
      mn_adoc = sts_path.('adoc')
      FileUtils.cp(sts_xml, source)
      Sts2mn.convert(input: source)

      expect(File.exist?(mn_adoc)).to be true
    end
  end

  it "splits bibdata and generates adoc output" do
    mn_path = -> (dir, format) { File.join(dir, "sts.#{format}") }
    Dir.mktmpdir do |dir|
      FileUtils.cp(sts_xml, mn_path.(dir, 'xml'))
      Sts2mn.split_bibdata(mn_path.(dir, 'xml'))

      expect(File.exist?(mn_path.(dir, 'adoc'))).to be true
      expect(File.exist?(mn_path.(dir, 'rxl'))).to be true
    end
  end

  let(:sts_xml) do
    Pathname.new(File.dirname(__dir__)).
    join('spec', 'fixtures', 'rice-en.final.sts.xml').to_s
  end

end
