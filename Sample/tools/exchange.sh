/usr/bin/mogenerator -m "TableViewAgent/Model/CoreData/Model.xcdatamodeld/Model.xcdatamodel" -O TableViewAgent/Model/CoreData/Entity/ --template-var arc=true
ruby tools/extractingId.rb TableViewAgent/en.lproj/MainStoryboard.storyboard TableViewAgent/en.lproj/
