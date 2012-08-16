class Employee

  attr_accessor :myIdNum
  attr_accessor :myLastName
  attr_accessor :myFirstName
  attr_accessor :myMiddleInitial
  attr_accessor :myDeptCode

  def initialize( aID, aLastName, aFirstName, aMiddleInit, aDeptCode )
    @myIdNum = aID
	@myLastName = aLastName
	@myFirstName = aFirstName
	@myMiddleInitial = aMiddleInit
	@myDeptCode = aDeptCode
  end
  
  def myIdNum
    return @myIdNum
  end
  
  def myLastName
    return @myLastName
  end
  
  def myFirstName
    return @myFirstName
  end
  
  def myMiddleInitial
    return @myMiddleInitial
  end
  
  def myDeptCode
    return @myDeptCode
  end
  
  def printEmployee
    puts "Employee ID Number: #{myIdNum}"
	puts "Name: #{myLastName}, #{myFirstName} #{myMiddleInitial}."
	puts "Dept Code: #{myDeptCode}"
	print "\n"
  end 
end
class HourlyEmployee < Employee

  attr_accessor :hourSalary
  attr_accessor :hoursWorked
  attr_accessor :overtimeHours

  def initialize( aID, aLastName, aFirstName, aMiddleInit, aDeptCode, ahourSal, ahourWork, aOTH )
    super( aID, aLastName, aFirstName, aMiddleInit, aDeptCode )
	@hourSalary = ahourSal
	@hoursWorked = ahourWork
	@overtimeHours = aOTH
  end
  
  def hourSalary
    return @hourSalary
  end
  
  def hoursWorked
    return @hoursWorked
  end
  
  def overtimeHours
    return @overtimeHours
  end
  
  def calcSalary
    return ((hoursWorked*hourSalary)+(overtimeHours*1.5*hourSalary))
  end
  
  def printHourlyEmployee
    puts "Employee ID Number: #{myIdNum}"
	puts "Name: #{myLastName}, #{myFirstName} #{myMiddleInitial}."
	puts "Dept Code: #{myDeptCode}"
	puts "Hourly Salary: $#{hourSalary}"
	puts "Hours Worked: #{hoursWorked} hours"
	if overtimeHours !=0 then
	  puts "Overtime Hours Worked: #{overtimeHours} hours"
	end
	puts "Monthly Salary: $#{calcSalary}"
	print "\n"
  end
end
  
class SalariedEmployee < Employee

  attr_accessor :baseSalary
  attr_accessor :fracTime

  def initialize( aID, aLastName, aFirstName, aMiddleInit, aDeptCode, abaseSalary, afracTime )
    super( aID, aLastName, aFirstName, aMiddleInit, aDeptCode )
	@baseSalary = abaseSalary
	@fracTime = afracTime
  end
  
  def baseSalary
    return @baseSalary
  end
  
  def fracTime
    return @fracTime
  end
  
  def calcSalary
    return (baseSalary*fracTime)
  end
  
  def printSalariedEmployee
    puts "Employee ID Number: #{myIdNum}"
	print "Name: #{myLastName}, #{myFirstName} #{myMiddleInitial}." + (fracTime!=1 ? "(Part Time)\n" : "\n")
	puts "Dept Code: #{myDeptCode}"
	puts "Base Salary: $#{baseSalary}"
	puts "Monthly Salary: $#{calcSalary}"
	print "\n"
  end
end

e1 = Employee.new(001, "Jones", "Booker", "T", 22)
e2 = Employee.new(002, "Hendrix", "Jimi", "NMI ", 14)
e3 = Employee.new(003, "Morrison", "Jim", "D", 03)

e1.printEmployee
e2.printEmployee
e3.printEmployee

e4 = SalariedEmployee.new(004, "Shaw", "Phil", "J", 69, 1000.5, 1)
e5 = SalariedEmployee.new(005, "Magee", "Dennis", "M", 70, 1200, 0.75)

e4.printSalariedEmployee
e5.printSalariedEmployee

e6 = HourlyEmployee.new(006, "Kouhestani", "Camron", "Z", 71, 11, 160, 0)
e7 = HourlyEmployee.new(007, "Cortez", "Paul", "", 72, 7.50, 160, 5)

e6.printHourlyEmployee
e7.printHourlyEmployee

puts e1.inspect
puts e2.inspect
puts e3.inspect
puts e4.inspect
puts e5.inspect
puts e6.inspect
puts e7.inspect