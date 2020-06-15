#/bin/bash

sql_path=$1;
if [ ! -n "$sql_path" ];
then

	echo "请输入sql所在目录: ";
	read sql_path;
fi;

if [ ! -d "$sql_path" ];
then
	echo "目录不存在";
	exit 1;
else
	echo "目录存在";
fi;

#cmd(find $sql_path -name "*.sql" > "batch.sql")

#eval "find $sql_path -name '*.sql' > batch.sql"

echo "请输入需要导入的数据库名: "
read db;

eval " echo 'use $db;' >  batch.sql"

for file in $(find $sql_path -name "*.sql" | sort)
do
	eval "echo 'source $file;' >> batch.sql";
done;

echo "批量导入sql文件已生成，是否需要自动导入至mysql: (yes/no) 默认no"
read status;

if [ $status == "yes" ]
then
	read -p "请输入数据库账号: " username;
	if [ -z "$username" ];
	then
		exit 1;	
	fi;
	read -p "请输入数据库密码: " pwd;
	if [ -z "$pwd" ];then
		exit 1;
	fi;
	read -p "请输入数据库IP:(默认 127.0.0.1) " ip;
	if [ -z "$ip" ];then
		ip=127.0.0.1;
	fi;	
	read -p "请输入端口:（默认: 3306) " port;
	if [ -z "$port" ];then
		port=3306;
	fi;
else
	echo "退出";
	exit 1;
fi

eval "mysql -u $username -p$pwd -h $ip -P $port  --max_allowed_packet=1048576 --net_buffer_length=16384 < batch.sql"




