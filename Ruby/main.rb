#----- main.rb -----#
## Main menu will be handled here
## Also how things will be added to classes
## based on menu options

=begin
In future versions, would create functions to
handle more of the functionality.
=end

# require statement for linux
require 'classes.rb'
# require statement for Windows
#require './classes.rb'

system("clear") # clear the screen, ONLY WORKS IN LINUX TERMINAL!
## if running in Windows environment, replace "clear" to "cls"
choice = "" # default
type = "" # default
tname = "" # default temp name for store
tnum = 0 # default temp store number
tloc = "" # default temp location
tlat = 0.0 # default temp latitude
tlong = 0.0 # default temp longitude
exit = 'EXIT'
stores = [] # empty array for storing store objects
i = 0 # default for index of stores
echoice = 0 # default edit choice
tmp = "" # just a temp string

# general information
puts "Thank you for using this program!"
puts "This program will help you store information about stores, including:"
puts "Store name, location, product information, etc."
puts
puts "Currently, only information pertaining to hardware and grocery stores"
puts "can be stored. Other types will be added in future versions."
puts
print "Press the enter key to continue\n$ "
gets # just a way to get the user to continue the script
system("clear")

# menus
while choice != exit # way to make the script keep going until user types EXIT
  print "-(NEW) Store\n"
  print "-(EDIT) Store Info\n"
  print "-(PRINT) Store Info\n"
  print "-(ALL) Stores\n"
  print "-(OUT)put all to file\n"
  print "-(EXIT) the Program\n$ "
  choice = gets.upcase.chomp # ask user for choice
  system("clear")
  
  case choice
    when "EXIT"
      print "Programming Exiting\n"
      sleep 1
      system("clear")
      break # stops the script
    when "NEW"
      print "What kind of store is it?\n"
      print "(Grocery or Hardware?)\n$ "
      type = gets.capitalize.chomp
      print "What is the name of the store?\n$ "
      tname = gets.chomp.split(" ").each{|word| word.capitalize!}.join(" ").chomp
      tname << " (#{type})"
      print "What is the store number?\n$ "
      tnum = gets.chomp.to_i
      print "What is the store location? ( N or SE )\n$ "
      tloc = gets.upcase.chomp
      print "What is the store's latitude and longitude, respectively?\n$ "
      tlat = gets.chomp.to_f
      print "$ "
      tlong = gets.chomp.to_f
      stores[i] = eval(type).new(tname,tnum,tloc,tlat,tlong) # make the store
      i += 1 # increment array index
      system("clear")
      print "The store has been made!\n"
      sleep 1
      system("clear")
    when "EDIT"
      print "Which store would you like to edit?\n"
      echoice = 0 # default it to match array indices
      stores.each do |x|
        print "#{echoice} - " 
        puts x.name
        echoice += 1
      end
      print "$ "
      echoice = gets.chomp.to_i
      system("clear")
      print "What would you like to edit?\n"
      print "Change store (NAME)\n"
      print "Change store (NUMBER)\n"
      print "Change store (LOCATION), latitude and longitude\n"
      print "Change the number for (VISITS)\n"
      print "Add a (PRODUCT)\n"
      print "Change a product's (VALUE)\n"
      print "(DELETE) a product\n$ "
      tmp = gets.upcase.chomp
      system("clear")
      case tmp
        when "NAME"
          print "What would you like to change the name to?\n$ "
          stores[echoice].name = gets.chomp.split(" ").each{|word| word.capitalize!}.join(" ").chomp
          print "What type of store is it?\n$ "
          tmp = gets.capitalize.chomp
          stores[echoice].name << " (#{tmp})"
          puts "Name has been changed!"
        when "NUMBER"
          print "What would you like to change the number to?\n$ "
          stores[echoice].storenum = gets.chomp.to_i
          puts "Number has been changed!"
        when "LOCATION"
          print "What would you like to change the location to?\n$ "
          stores[echoice].loc = gets.upcase.chomp
          print "Latitude? $ "
          stores[echoice].lat = gets.chomp.to_f
          print "Longitude? $ "
          stores[echoice].long = gets.chomp.to_f
          puts "Location has been changed!"
        when "VISITS"
          print "What would you like to change the visits to?\n$ "
          stores[echoice].visits = gets.chomp.to_i
          puts "The number of visits have been changed!"
        when "PRODUCT"
          print "What product would you like to add?\n$ "
          stores[echoice].products << gets.downcase.chomp
          print "How many of this item was sold in an 8 week period?\n$ "
          stores[echoice].hash[stores[echoice].products[-1]] = gets.chomp.to_i
          puts "Product was added!"
        when "VALUE"
          print "What product would you like to edit?\n"
          puts stores[echoice].products
          print "$ "
          tmp = gets.downcase.chomp
          print "What would you like to change #{tmp} to?\n$ "
          stores[echoice].hash[tmp] = gets.chomp.to_i
          puts "The product has been changed!"
        when "DELETE"
          print "Which product would you like to delete?\n"
          puts stores[echoice].products
          print "$ "
          tmp = gets.downcase.chomp
          stores[echoice].products.delete("#{tmp}")
          stores[echoice].hash.delete("#{tmp}")
          puts "The product has been deleted!"
      end
      sleep 1
      system("clear")
    when "PRINT"
      tmp = ""
      print "Would you like to print by (NAME), (LOCATION), or (VISIT) frequency?\n$ "
      tmp = gets.upcase.chomp
      system("clear")
      case tmp
      	when "NAME"
      	  print "Which store would you like to print?\n"
      	  echoice = 0 # default to match array indices
      	  stores.each do |x|
            print "#{echoice} - " 
            puts x.name
            echoice += 1
          end
          print "$ "
          echoice = gets.chomp.to_i
          system("clear")
          stores[echoice].printstore
          puts stores[echoice].output
          puts
          print "Press enter to go back to main menu.\n$ "
          gets
          system("clear")
        when "LOCATION"
          tmp = ""
          print "Which store location would you like to print? (N or SE, etc)\n$ "
          tmp = gets.upcase.chomp
          system("clear")
          stores.each do |x|
            if x.loc == tmp
              x.printstore
              puts x.output
              puts
            elsif x.loc != tmp
              puts "No stores are in this locational area!"
              puts
            end
          end
          print "Press enter to return to the main menu.\n$ "
          gets
          system("clear")
        when "VISIT"
          tmp = 0
          print "Which visit frequency would you like to print?\n$ "
          tmp = gets.chomp.to_i
          system("clear")
          stores.each do |x|
            if x.visits == tmp
              x.printstore
              puts x.output
              puts
            elsif x.loc != tmp
              puts "No stores match this visit frequency!"
              puts
            end
          end
          print "Press enter to return to the main menu.\n$ "
          gets
          system("clear")
      end
    when "ALL"
      stores.each do |x|
        x.printstore
        puts x.output
        puts
      end
      print "Press enter to go back to main menu.\n$ "
      gets
      system("clear")
    when "OUT"
      system("clear")
      afile = File.new("stores.txt","w+") # make a new file
      tmp = ""
      stores.each do |x|
        x.printstore
        tmp << x.output
        tmp << "\n#----------------------------------#\n"
      end
      afile.puts tmp # write to the file
      afile.close # close the file
      print "All stores have been saved to stores.txt!\n"
      sleep 1
      system("clear")
  end 
end
#----- END OF FILE -----#
