#!/bin/python
try:
  from selenium.webdriver.common.keys import Keys
  from termcolor import colored
  from selenium import webdriver
  from selenium.webdriver.firefox.firefox_binary import FirefoxBinary
  import sys
  import time
  import re
  import os
except:
   print ("[-] please install modules in requirements file first")
   print ("[+] execute 'sudo pip install -r requirements.txt'")
   exit()

try:
  em =  sys.argv[1]
except:
  print(colored("[+] python " + sys.argv[0] + " emails_list.txt 'TARGET'" , 'red'))
  exit()

class Yahoo():
  def __init__(self, email):
    self.binary   = FirefoxBinary("/usr/bin/firefox")
    self.browser  = webdriver.Firefox(firefox_binary = self.binary)
    self.browser.get("https://login.yahoo.com/beta/config/login?.src=fpctx&.intl=uk&.lang=en-GB&.done=https%3A%2F%2Fuk.yahoo.com")
    self.username = self.browser.find_element_by_id('login-username')
    self.form     = self.browser.find_element_by_id('login-signin')
    self.file = open(email , "r" )

  def login(self):
    for i in self.file.readlines():
      try:
        self.username.send_keys( i )
        self.form.click()
        self.src = self.browser.page_source
        self.text_found = re.search("login-username" , self.src)
        if self.text_found != None :
          print(colored("[+] Email is available : "  + i  , 'green'))
          self.username.clear()
        else:
          print(colored("[!] Email isn't available : " + i  ,  "red" ))
          os.system('kill -9 $(pgrep firefox)')
          self.binary   = FirefoxBinary("/usr/bin/firefox")
          self.browser  = webdriver.Firefox(firefox_binary = self.binary)
          self.browser.get("https://login.yahoo.com/beta/config/login?.src=fpctx&.intl=uk&.lang=en-GB&.done=https%3A%2F%2Fuk.yahoo.com")
          self.username = self.browser.find_element_by_id('login-username')
          self.form     = self.browser.find_element_by_id('login-signin')
      except:
        print(colored("[!] Email isn't available : " + i  ,  "red" ))
        os.system('kill -9 $(pgrep firefox)')
        self.binary   = FirefoxBinary("/usr/bin/firefox")
        self.browser  = webdriver.Firefox(firefox_binary = self.binary)
        self.browser.get("https://login.yahoo.com/beta/config/login?.src=fpctx&.intl=uk&.lang=en-GB&.done=https%3A%2F%2Fuk.yahoo.com")
        self.username = self.browser.find_element_by_id('login-username')
        self.form     = self.browser.find_element_by_id('login-signin')

  def kill(self):
    os.system('kill -9 $(pgrep firefox)')

yahoo = Yahoo(em)
yahoo.login()
yahoo.kill()
