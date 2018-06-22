#!/usr/bin/ruby
require 'mysql'
require 'date'
require 'active_support/all'
load './sql.rb' #файл с SQL запросами
require './sql.rb'
$host='address'
$user='user'
$pass='pass'
$db = 'zabbix'

begin
  # опяими передаем за какой день переливать данные. (день за который переливаются данны  = сеголня - d )
    options = OpenStruct.new
    OptionParser.new do |opt|
        opt.on('-d','--days DAYS', "set date current-date - n") { |o| options.days = o }
    end.parse!
 
        # если опция отсутствует то значение по-умолчанпю - 1
    unless  options.days.nil?
        $date   =  DateTime.now - options.days.to_i.day
    else 
        $date   =  DateTime.now - 1.day
    end
   
    $year   =  $date.strftime("%Y") #извлекаем год

    $month  =  $date.strftime("%m") # месяц

    $day    =  $date.strftime("%d") # день

    $dmy    =  $date.strftime("%Y-%m-%d") # а так же строку вида год-месяц-день
      
    con = Mysql.new $host, $user, $pass, $db #получаем объект представляющий подключение согласно заданнмы параметрам
    # исполняем запросы... ну или просто исполняем :)
    con.query(set_transaction_lock);
    con.query (network_discovery)
    con.query (rvpn)
    
rescue Mysql::Error => e
    puts e.errno
    puts e.error

ensure
    con.close if con
end
