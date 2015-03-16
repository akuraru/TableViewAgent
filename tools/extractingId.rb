require 'kconv'
require 'fileutils'

$shorthand = false
$register = true
$help = false
$fileName = "ExtactedID"
$non = false
$/

require 'optparse'
opt = OptionParser.new
opt.on('-s', '--shorthand') {|v| $shorthand = true }
opt.on('-i', '--no_init') {|v| $register = false }
opt.on('-h', '--help') {|v| $help = true }
opt.on('--none') {|v| $non = true }
opt.on("-f [file]", "--file_name [file]") {|v| $fileName = v}

opt.permute!(ARGV)

class Type
  def initialize(name)
    @name = name
  end
  def == (type)
    @name == type.name
  end
  def name
    @name
  end
  def capitalize
    c = @name
    c[0,1].capitalize + c[1..-1]
  end
  def define
    "k" + self.class.name + self.capitalize
  end
  def nsString
    '@"' + @name + '"'
  end
  def impDefine
    "\#define #{self.define} #{self.nsString}\n"
  end
end
class Segue < Type
    def == (type)
    Segue === type && super(type)
end
end
class Restore < Type
    def == (type)
    Restore === type && super(type)
end
end
class Storyboard < Type
    def == (type)
    Storyboard === type && super(type)
end
end

class Reuse < Type
  def == (type)
    Reuse === type && super(type)
  end
end
  
class UserDefualts
  def initialize
  end
  def fileRead(fileName)
    data = nil
    File.open(fileName, :encoding => Encoding::UTF_8) {|f|
      transText = f.read.toutf8
      data = transText.scan(/(.*)\n/).flatten
    }
    data
  end
  def exchange(arrStr)
    arrStr.map{|s| to_class(s) }.flatten.inject([]){|a, s|
      if a.index(s) == nil then
          a.push(s)
      end
      a
    }
  end
  def to_class(s)
  if / identifier="(\w+)" / =~ s then
    [Segue.new($1)]
  elsif / restorationIdentifier="(\w+)" / =~ s then
    [Restore.new($1)]
  elsif /storyboardIdentifier="(\w+)"/ =~ s then
    [Storyboard.new($1)]
  elsif /reuseIdentifier="(\w+)"/ =~ s then
    [Reuse.new($1)]
  else
    []
  end
  end
  def header(arrType, fileName)
    self.define(arrType)
  end
  def define(arrType)
    arrType.map{|s| s.impDefine}.inject(""){|s, i| s + i}
  end
  def main(file, dir)
    arrType = self.exchange(self.fileRead(file))
    
    head = "#{dir}#{$fileName}.h"
    FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)
    File.open(head, "w:UTF-8"){|f|
      f.write self.header(arrType, $fileName)
    }
  end
end

if $non
elsif ARGV.count < 2 || $help
  puts "UserDefaultsCreator: Usage [Option] <argumrnt> [...]"
  puts "need more than 2 argv"
  puts ""
  puts "-h, --help Display this help and exit"
  puts "-f FILENAME, --file_name FILENAME Specify a file name"
elsif ARGV.count >= 2
  UserDefualts.new.main(ARGV[0], ARGV[1])
  puts "Generate"
end
