require 'kconv'
require 'fileutils'

$shorthand = false
$register = true
$help = false
$fileName = "UDManager"
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
    "k" + self.capitalize
  end
  def nsString
    '@"' + @name + '"'
  end
  def typeName
    "Type"
  end
  def getter
    "- (#{self.typeName})#{self.name}"
  end
  def interfaceGetter
    self.getter + ";\n"
  end
  def setter
    "- (void)set#{self.capitalize}:(#{self.typeName})#{self.name}"
  end 
  def interfaceSetter
    self.setter + ";\n"
  end
  def interface
    self.interfaceGetter + interfaceSetter
  end
  def impDefine
    "\#define #{self.define} #{self.nsString}\n"
  end
  def defaultValue
	""
  end
  def registerDefault
    "#{self.define} : #{self.defaultValue}"
  end
  def impSetMessage
    ""
  end
  def typeExchange(obj)
    obj
  end
  def objectExchange(obj)
    obj
  end
  def inImpGetter
  if ($shorthand)
    "    return " + typeExchange("defaults[#{self.define}]") + ";\n"
  else
    "    return [defaults #{self.impGetMessage}:#{self.define}];\n"
  end
  end
  def impGetter
    "#{self.getter} \{\n#{self.inImpGetter}\}\n"
  end
  def inImpSetter
    if ($shorthand)
      "    defaults[#{self.define}] = " + objectExchange(self.name) + ";\n    [defaults synchronize];\n"
    else
      "    [defaults #{self.impSetMessage}:#{self.name} forKey:#{self.define}];\n    [defaults synchronize];\n"
    end
  end
  def impSetter
    "#{self.setter} \{\n#{self.inImpSetter}\}\n"
  end
  def property
    "@property #{self.typeName} #{self.name};\n"
  end
end
class NSObject < Type
  def == (type)
    NSObject === type && super(type)
  end
  def typeName
    "id"
  end
  def impGetMessage
    "objectForKey"
  end
  def impSetMessage
    "setObject"
  end
end
class NSString < NSObject
  def == (type)
    NSString === type && super(type)
  end
  def typeName
    "NSString *"
  end
  def defaultValue
	"@\"\""
  end
end
class NSNumber < NSObject
  def == (type)
    NSNumber === type && super(type)
  end
  def typeName
    "NSNumber *"
  end
  def defaultValue
	"\@0"
  end
end
class NSArray < NSObject
  def == (type)
    NSArray === type && super(type)
  end
  def typeName
    "NSArray *"
  end
  def defaultValue
	"@[]"
  end
end
class NSDictionary < NSObject
  def == (type)
    NSODictionary === type && super(type)
  end
  def typeName
    "NSDictionary *"
  end
  def defaultValue
	"@{}"
  end
end
class NSData < NSObject
  def == (type)
    NSData === type && super(type)
  end
  def typeName
    "NSData *"
  end
  def registerDefault
    ""
  end
end
class NSDate < NSObject
  def == (type)
    NSData === type && super(type)
  end
  def typeName
    "NSDate *"
  end
  def defaultValue
	"[NSDate date]"
  end
end
class NSValue < Type
  def == (type)
    NSValue === type && super(type)
  end
  def typeName
    "NSValue"
  end
  def defaultValue
	"@0"
  end
  def typeExchange(obj)
    "[#{obj} integerValue]"
  end
  def objectExchange(value)
    "@(#{value})"
  end
end
class NSInteger < NSValue
  def == (type)
    NSInteger === type && super(type)
  end
  def typeName
    "NSInteger"
  end
  def impGetMessage
    "integerForKey"
  end
  def impSetMessage
    "setInteger"
  end
  def typeExchange(obj)
    "[#{obj} integerValue]"
  end
end
class NSBOOL < NSValue
  def == (type)
    NSBOOL === type && super(type)
  end
  def typeName
    "BOOL"
  end
  def impGetMessage
    "boolForKey"
  end
  def impSetMessage
    "setBool"
  end
  def typeExchange(obj)
    "[#{obj} boolValue]"
  end
end
class NSFloat < NSValue
  def == (type)
    NSFloat === type && super(type)
  end
  def typeName
    "float"
  end
  def impGetMessage
    "floatForKey"
  end
  def impSetMessage
    "setFloat"
  end
  def typeExchange(obj)
    "[#{obj} floatValue]"
  end
end
class NSDouble < NSValue
  def == (type)
    NSDouble === type && super(type)
  end
  def typeName
    "double"
  end
  def impGetMessage
    "doubleForKey"
  end
  def impSetMessage
    "setDouble"
  end
  def typeExchange(obj)
    "[#{obj} doubleValue]"
  end
end
  
class UserDefualts
  def initialize
  end
  def fileRead(fileName)
    data = nil
    File.open(fileName, "r:UTF-16") {|f|
      transText = f.read.toutf8
      data = transText.scan(/(.*)\n/).flatten
    }
    data
  end
  def exchange(arrStr)
    arrStr.map{|s|
      if /\s*(\w+) *\* *(\w+)\s*;\s*/ =~ s then
        self.object($1, $2)
      elsif /\s*(\w+)\s+(\w+)\s*;\s*/ =~ s then
        self.value($1, $2)
      elsif /- \((\w+) \*\)(\w+);/ =~ s then
          self.object($1, $2)
      elsif /- \((\w+)\)(\w+);/ =~ s then
          self.value($1, $2)
      else
        []
      end
    }.flatten
  end
  def object(type, name)
    if "NSString" == type
      [NSString.new(name)]
    elsif "NSNumber" == type
      [NSNumber.new(name)]
    elsif "NSArray" == type
      [NSArray.new(name)]
    elsif "NSDictionary" == type
      [NSDictionary.new(name)]
    elsif "NSData" == type
      [NSData.new(name)]
    elsif "NSDate" == type
      [NSDate.new(name)]
    else
      [NSObject.new(name)]
    end
  end
  def value(type, name)
    if "NSInteger" == type then
      [NSInteger.new(name)]
    elsif "BOOL" == type then
      [NSBOOL.new(name)]
    elsif "float" == type then
      [NSFloat.new(name)]
    elsif "double" == type then
      [NSDouble.new(name)]
    else
      [NSObject.new(name)]
    end
  end
  def registHeader 
    if ($register)
      ""
    else
      "- (void)registerDefaults:(NSDictionary *)dict;\n"
    end
  end
  def header(arrType, fileName)
    "\n\#import <Foundation/Foundation.h>\n\n" +
    self.define(arrType) +
    "\n\@interface #{fileName} : NSObject\n\n+ (instancetype)sharedManager;\n#{self.registHeader}\n" + 
    arrType.map{|s| s.interface + "\n"}.inject(""){|s, i| s + i} + 
    "\@end\n"
  end
  def registerDefaults(arrType)
    "        [defaults registerDefaults:@{\n" +
    arrType.map{|s| s.registerDefault}.select{|s| s != ""}.map{|s| " "*12 + s + ",\n"}.inject(""){|s, i| s + i} +
    "        }];\n"
  end
  def init(arrType)
    if ($register) 
      "- (id)init {\n    self = [super init];\n    if (self != nil) {\n        defaults = [NSUserDefaults standardUserDefaults];\n#{self.registerDefaults(arrType)}    }\n\n    return self;\n}\n"
    else
      "- (id)init {\n    self = [super init];\n    if (self != nil) {\n        defaults = [NSUserDefaults standardUserDefaults];\n    }\n\n    return self;\n}\n- (void)registerDefaults:(NSDictionary *)dict {\n    [defaults registerDefaults:dict];\n}\n"
    end
  end
  def define(arrType)
    arrType.map{|s| s.impDefine}.inject(""){|s, i| s + i}
  end
  def implementation(arrType)
    arrType.map{|s| s.impGetter + s.impSetter + "\n"}.inject(""){|s, i| s + i}
  end
  def method(arrType, fileName)
    "\#import \"#{fileName}.h\"\n\n" +
    "\@implementation #{fileName} {\n    NSUserDefaults *defaults;\n}\n\n+ (instancetype)sharedManager {\n    static #{fileName} *sharedManager_ = nil;\n    static dispatch_once_t onceToken;\n    dispatch_once(&onceToken, ^{\n        sharedManager_ = #{fileName}.new;\n    });\n\n    return sharedManager_;\n}\n\n" +
    self.init(arrType) + "\n" +
    self.implementation(arrType) +
    "@end\n"
  end
  def main(file, dir)
    arrType = self.exchange(self.fileRead(file))
    
    head = "#{dir}#{$fileName}.h"
    FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)
    File.open(head, "w:UTF-16"){|f|
      f.write self.header(arrType, $fileName)
    }
    File.open("#{dir}#{$fileName}.m", "w:UTF-16"){|f|
      f.write self.method(arrType, $fileName)
    }
  end
end
if $non
elsif ARGV.count < 2 || $help
  puts "UserDefaultsCreator: Usage [Option] <argumrnt> [...]"
  puts "need more than 2 argv"
  puts ""
  puts "-s, --shorthand Use the shorthand"
  puts "-i, --no_init Do not insert the initialization"
  puts "-h, --help Display this help and exit"
  puts "-f FILENAME, --file_name FILENAME Specify a file name"
elsif ARGV.count >= 2
  UserDefualts.new.main(ARGV[0], ARGV[1])
  puts "Generate"
end
