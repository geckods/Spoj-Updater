require 'watir'
require 'webdrivers'

Watir.default_timeout = 180

b = Watir::Browser.new :chrome
b.goto("www.spoj.com/login")

password = File.read("../data/password.txt").chomp
oldprob = File.read("../data/problem.txt").chomp

b.text_field(id:"inputUsername").set "geckods"
b.text_field(id:"inputPassword").set "#{password}\n"

b.goto("https://www.spoj.com/problems/classical/sort=6")

name = b.spans(class: ["fa fa-minus text-danger"])[0].parent.parent.children[2].text #Name
href = b.spans(class: ["fa fa-minus text-danger"])[0].parent.parent.children[2].children[0].attribute(:href) #link
text = ""
title = ""

if (name==oldprob)
  title = "Reminder:Spoj Problem #{name}"
  text += "Your current problem is #{name}\n#{href}"
else
  File.open("../data/problem.txt","w") do |f|
    f.write name
  end
  title = "New Spoj Problem: #{name}"
  text += "Congrats on Solving problem: #{oldprob}.\nYour new problem is #{name}.\n"
  b.goto(href)
  text += b.div(class: "prob").text.split("Submit")[0] #problemText
end
puts title
puts text
`sh ./send-encrypted/send-encrypted.sh -k KGg4T5 -p asdfghjk -s gurupfba -t "#{title}" -m "#{text}"` #Phone notification 
