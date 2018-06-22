#Файл содержит SQL запросы которые исполняются программой
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
		and (dayofmonth(from_unixtime(`zabbix`.`history_uint`.`clock`)) = #{$day} )
		and ( `zabbix`.`hosts`.`name` regexp "R.*-N") )
		GROUP BY `zabbix`.`hosts`.`name` ;

END_SQL
end


def set_transaction_lock
<<-END_SQL.gsub(/\s+/, " ").strip
	SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
END_SQL
end

def network_discovery
<<-END_SQL.gsub(/\s+/, " ").strip
	
	INSERT INTO `reports`.`r_network_discovery` (`ReportDate`,`RuleName`, `PCcount` )
		select '#{$dmy}',T1.rulename, T2.pccount
			from
				(select drules.name as 'rulename', drules.druleid as 'rulenum' from zabbix.drules group by drules.druleid) T1,
				(select count(dhosts.dhostid) as 'pccount', dhosts.druleid as 'rulenum' from zabbix.dhosts group by dhosts.druleid) T2
			where T2.rulenum = T1.rulenum;        

END_SQL
end

def rvpn
<<-END_SQL.gsub(/\s+/, " ").strip
     INSERT INTO  `reports`.`r_network_discovery` (`ReportDate`,`RuleName`, `PCcount` )
	select '#{$dmy}',T1.rulename, T2.pccount
		from
			(select drules.name as 'rulename', drules.druleid as 'rulenum' from zabbix.drules group by drules.druleid) T1,
			(select count(dhosts.dhostid) as 'pccount', dhosts.druleid as 'rulenum' from zabbix.dhosts group by dhosts.druleid) T2
		where T2.rulenum = T1.rulenum and T1.rulename like '%_RVPN' and T2.pccount > 0;        
END_SQL
end
