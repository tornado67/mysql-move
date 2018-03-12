#Файл содержит SQL запросы которые исполняются программой

def create_db
<<-END_SQL.gsub(/\s+/, " ").strip
	CREATE DATABASE IF NOX EXISRS reports
	CHARACTER SET utf8 COLLATE utf8_bin;
END_SQL
end


def create_reports_table 
<<-END_SQL.gsub(/\s+/, " ").strip

   CREATE TBLE IF NOT EXISTS `reports` (
	`date`  char (11) ,
    `index` char (30),
    `start` char (20),
    `end`   char (20)

    );
END_SQL
end


def move_data
<<-END_SQL.gsub(/\s+/, " ").strip
INSERT INTO `reports`.`r_ops_uptime` (`report_date`,`ops_index`,`time_start`,`time_end`)
		SELECT 
			`zabbix`.`history_uint`.`clock`,
			`zabbix`.`hosts`.`name` , 
		     	 from_unixtime(min(`zabbix`.`history_uint`.`clock`)),    
			 from_unixtime(max(`zabbix`.`history_uint`.`clock`)) 
		FROM  `zabbix`.`history_uint` join  `zabbix`.`items`      join  `zabbix`.`hosts`      

		WHERE ((`zabbix`.`items`.`hostid` = `zabbix`.`hosts`.`hostid`)  
		and (`zabbix`.`items`.`key_` = 'agent.ping')  
		and (`zabbix`.`history_uint`.`itemid` = `zabbix`.`items`.`itemid`) 
		and (year(from_unixtime(`zabbix`.`history_uint`.`clock`)) = #{$year} )  
		and (month(from_unixtime(`zabbix`.`history_uint`.`clock`)) =  #{$month} )  
		and (month(from_unixtime(`zabbix`.`history_uint`.`clock`)) between 01 and 12  
		and ( `zabbix`.`hosts`.`name` regexp "R.*-N") ))  
		GROUP BY `zabbix`.`hosts`.`name` ;

END_SQL
end


def set_transaction_lock
<<-END_SQL.gsub(/\s+/, " ").strip
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
END_SQL
end

