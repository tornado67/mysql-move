#!/usr/bin/ruby
require 'mysql'
require 'date'
load './sql.rb' #файл с SQL запросами
require './sql.rb'
$host='10.124.3.201'
$user='root'
$pass='password'
$db = 'zabbix'


begin
    #получаем текущее время
    $date   =  DateTime.now 

    $year   =  $date.strftime("%Y") #извлекаем год

    $month  =  $date.strftime("%m") # месяц

    $day    =  $date.strftime("%d") # день

    $dmy    =  $date.strftime("%Y-%m-%d") # а так же строку вида год-месяц-день
      
    con = Mysql.new $host, $user, $pass, $db #получаем объект представляющий подключение согласно заданнмы параметрам
    con.query(set_transaction_lock);
    con.query(move_data) #исполняем запрос... ну или просто исполняем :)
    
rescue Mysql::Error => e
    puts e.errno
    puts e.error

ensure
    con.close if con
end



