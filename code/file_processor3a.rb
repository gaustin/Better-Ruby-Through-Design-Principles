class FileProcessor

  def process_file(file_name, reporter)
    parser = FileParsers.find(file_name)
    status = parser.parse

    reporter.report(status)
  end

end

class FileParsers
  class CsvParser
    def initialize(file_name)
      @file_name = file_name
    end

    def parse
      # Do that parsing stuff you doa
      puts "Processing file #{@file_name}"
      "success"

    end
  end

  class TsvParser
    def initialize(file_name)
      @file_name = file_name
    end

    def parse
      # Do that parsing stuff you do
      puts "Processing file #{@file_name}"
      "success"
    end
  end

  def self.find(file_name)
    file_extension = File.extname(file_name)
    parser_constant_name = "#{file_extension.slice(1..file_extension.length).capitalize}Parser"
    begin
      FileParsers.const_get(parser_constant_name).new(file_name)
    rescue NameError
      raise "File extension not supported"
    end
  end

end

class EmailReporter
  def initialize(smtp_server)
    @smtp_server = smtp_server
  end
  def report(status)
    puts "Emailing status: #{status} via #{@smtp_server}"
  end
end

class SmsReporter
  def report(status)
    puts "Sms reporting status: #{status}"
  end
end

processor = FileProcessor.new
processor.process_file('my_file.csv', EmailReporter.new("MySmtpServer"))
processor.process_file('my_file.tsv', SmsReporter.new)
