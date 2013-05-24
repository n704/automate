require 'yaml'
$config_yaml = YAML.load_file('config.yaml')



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

  
def mac_gen(colo)
  mac_id = []
  counter=0
  $config_yaml["#{colo}"]['subnet'].keys.each do |subnet_id|
    $config_yaml["#{colo}"]['subnet']["#{subnet_id}"]['hosts'].keys.each do |hostname|
      mac_id[counter]=$config_yaml["{colo}"]['subnet']["#{subnet_id}"]['hosts']["#{hostname}"]['mac']
      counter+=1
      end
    end
  puts mac_id
end

mac_gen("ua2")
