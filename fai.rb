#!/usr/bin/env ruby
require 'yaml'
@ip_regex = /^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/
$config_yaml = YAML.load_file("config.yaml")


#function that colo of of the hostname from @ARGV[1]
def get_colo( hostname )
  $config_yaml.keys.each do |colo|
    if  ARGV[1].include?colo
      return colo
      #found colo name of hostname
      end
    end
    return nil
  end


#function to generate subnet address
def ip_gen(subnet,colo)
  subnet1=subnet.split(".").collect{|i| i.to_i }
  subnet1[3]+=1
  subnet1[3]=rand(255)
  subnet1 = subnet1.join(".")
  counter =0
  subnet_ip = []
  #for checking all available ip
  $config_yaml["#{colo}"]['subnet']["#{subnet}"]['hosts'].keys.each do |hostname|
    subnet_ip[counter] =$config_yaml["#{colo}"]['subnet']["#{subnet}"]['hosts']["#{hostname}"]['ip']
    counter+=1
  end
  
  subnet_ip[counter] =$config_yaml["#{colo}"]['admin']
  counter+=1
  subnet_ip[counter] =$config_yaml["#{colo}"]['subnet']["#{subnet}"]['gateway']
  counter+=1
  subnet_ip[counter]=subnet
  #puts subnet_ip.sort!
  valid_ip = false
  while !valid_ip && counter < 255 do
    if subnet_ip.include?subnet1
      subnet1=subnet1.split(".").collect{|i| i.to_i }
      subnet1[3]= subnet1[3]+1
      subnet1[3]%=255
      subnet1 = subnet1.join(".")
      counter+=1
      else
      valid_ip = true
      return subnet1
    end
  end
  end
  
#check if argument are given
if ARGV.length == 0
      puts "no argument"
  #check for valid hostname and subnet id
elsif  ARGV[0] == "--host" && ARGV[2] == "--subnet"
   if /.inmobi.com/.match(ARGV[1])
     colo = get_colo(ARGV[1])
     if colo == nil
       puts " no colo"
       exit
       end
   else
     puts "do not contain inmobi.com"
     end
  #checking for valid ip address
  if $config_yaml["#{colo}"]['subnet'].keys.include?ARGV[3]
    host_ip=ip_gen(ARGV[3],colo)
    puts host_ip
    else
    exit
  end
end

