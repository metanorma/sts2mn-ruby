require 'open3'
require 'sts2mn/version'

module Sts2mn
  STS2MN_JAR_PATH = File.join(File.dirname(__FILE__), '../bin/sts2mn.jar')

  def self.help
    cmd = ['java', '-jar', STS2MN_JAR_PATH].join(' ')
    message, error_str, status = Open3.capture3(cmd)
    message
  end

  def self.version
    cmd = ['java', '-jar', STS2MN_JAR_PATH, '-v'].join(' ')
    message, error_str, status = Open3.capture3(cmd)
    message.strip
  end

  def self.split_bibdata(input_path)
    return if input_path.nil?

    cmd = ['java', '-Xss5m', '-Xmx1024m', '-jar', STS2MN_JAR_PATH,
           '--split-bibdata', input_path].join(' ')
    # puts cmd
    _, error_str, status = Open3.capture3(cmd)

    unless status.success?
      warn error_str
      raise error_str
    end
  end

  def self.convert(input:, output: nil, format: nil)
    return if input.nil?

    cmd = ['java', '-Xss5m', '-Xmx1024m', '-jar', STS2MN_JAR_PATH]

    case format.to_s
    when 'xml', 'adoc'
      cmd << ['--format', format.to_s]
    else
      raise 'Unknown format option provided to Sts2mn.convert'
    end unless format.nil?

    unless output.nil?
      cmd << ['--output', output.to_s]
    end

    cmd << [input.to_s]

    cmd = cmd.join(' ')
    # puts cmd
    _, error_str, status = Open3.capture3(cmd)

    unless status.success?
      warn error_str
      raise error_str
    end
  end

end
