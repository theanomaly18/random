#----- classes.rb -----#
## Creating the classes for program
## Store super class, with Grocery and Hardware subclasses
## Setting of values will happen in main.rb

## Store class is as abstract as possible. Could change it so products
## and hash are in the super class, but having them in the derived classes
## forces the users to choice hardware or grocery
class Store
  attr_accessor :name
  attr_accessor :storenum
  attr_accessor :loc
  attr_accessor :lat
  attr_accessor :long
  attr_accessor :output

  def initialize(aname="", astorenum=0, aloc ="", alat=0, along=0)
    @name = aname
    @storenum = astorenum
    @loc = aloc
    @lat = alat
    @long = along
    @output = "" # used for printing out info
  end

  def name
    return @name
  end

  def storenum
    return @storenum
  end

  def loc
    return @loc
  end

  def lat
    return @lat
  end

  def long
    return @long
  end
  
  def output
    return @output
  end

  # because of how writing to a file is done, instead of just putting the info
  # out on the screen, save the info in a string and put the string out to the
  # screen. then, when outputing to a file, output the string to the file.
  def printstore
    @output = ""
    @output << "Store Name: #{name}\n"
    @output << "Store Number: #{storenum}\n"
    @output << "Store Location: #{loc}\n"
    @output << "\t Latitude: #{lat}\n"
    @output << "\t Longitude: #{long}\n"
  end
end

#----- Grocery Class -----#
class Grocery < Store
  attr_accessor :visits
  attr_accessor :products
  attr_accessor :hash
  
  def initialize(aname="", astorenum=0, aloc ="", alat=0, along=0)
    super(aname, astorenum, aloc, alat, along)
    @visits = 0
    @products = [] # empty array
    @hash = {} # empty hash
  end
    
  def visits
    return @visits
  end
  
  def products
    return @products
  end
  
  def hash
    return @hash
  end
  
  def printstore
    tmp = ""
    super
    @output << "The store should be visited #{visits} every 8 weeks\n"
    @output << "\nPRODUCT=>NUMBER OF UNITS SOLD IN 8 WEEKS\n"
    tmp = hash.inspect.to_s
    tmp.gsub!("{","");tmp.gsub!("}","");tmp.gsub!(", ","\n");
    @output << tmp
  end
end

#----- Hardware Class -----#
class Hardware < Store
  attr_accessor :visits
  attr_accessor :products
  attr_accessor :hash
    
  def initialize(aname="", astorenum=0, aloc ="", alat=0, along=0)
    super(aname, astorenum, aloc, alat, along)
    @visits = 0
    @products = [] # empty array
    @hash = {} # empty hash
  end
    
  def visits
    return @visits
  end
  
  def products
    return @products
  end
  
  def hash
    return @hash
  end
  
  def printstore
    tmp = ""
    super
    @output << "The store should be visited #{visits} every 8 weeks\n"
    @output << "\nPRODUCT=>NUMBER OF UNITS SOLD IN 8 WEEKS\n"
    tmp = hash.inspect.to_s
    tmp.gsub!("{","");tmp.gsub!("}","");tmp.gsub!(", ","\n")
    @output << tmp
  end      
end
#----- END OF FILE -----#
