



### SQL语言

```
特殊目的的编程语言，是一种用于数据库设计和查询的语言，SQL语言中语句的结束标记是分号(;)
针对于对数据库的操作分成四种类型
1.数据定义语言(Data Define Language  DDL)
	用于创建/修改/删除数据库  数据表结构
2.数据操作语言(Data Manipulation Language DML)
	对数据表中的数据进行增 删 改的操作
3.数据查询语言(Data Query Language   DQL) ----------- ********重中之重
	对数据表中的数据进行查询
4.数据控制语言(Data Control Language  DCL)
	用于定义用户 并且给用户分配操作权限以及安全级别
```

### DDL数据定义语言

```
1.关于数据库的创建
	create database if not exists 数据库名称 charset=utf8;
	
		if not exitsts 可以省略 不省略的话先判断是否有这个名字的数据库  如果有的话 就不做任何操作
		如果没有就执行创建的动作。  省略的话如果这个数据库名字存在的话 会报错的
		
		charset=utf8 --- 设置创建的数据库支持utf8的编码格式 支持中文符号
		
2.切换到指定的数据库
	use 数据库名称;

3.显示所有的数据库
	show databases;

4.数据库创建出来了 没有设置编码
	alter database 数据库名 charset=utf8;

5.删除数据库
	drop database 数据库名;
```

```
1.创建数据表
create table if not exists 表名(
列名 数据类型 约束,
列名1 数据类型 约束,
...
)

教室和学生
教室：
	教室编号 --- 主键
	教室的名称 --- 唯一约束
	教室的位置 --- 不能为空约束
学生：
	学生编号 --- 主键 自增长
	学生的名称 --- 不能为空
	学生的性别 --- enum  默认是男
	学生的出生日期  
	学生的成绩 
	所在的教室编号 --- 外键


2.查询表结构
desc 表名;

3.查看表的详情
show create table 表名 \G;    \G表示以格式化形式显示

4.查看数据库中所有的表
show tables；

5.删除表
drop table 表名;

6.修改表结构
alter table 表名 add --- 增加字段或者约束的
	增加字段
		alter table 表名 add 字段名 字段类型 约束条件 first|after 字段名;
			first --- 把这个字段当做表中的第一列
			after 字段名 --- 在指定的字段名后面添加
			什么都没写的情况下 默认在末尾追加	
alter table 表名 drop --- 移除字段或者约束的
	移除字段
		alter table 表名 drop 字段名
alter table 表名 modify  --- 修改字段
	修改字段数据类型
		alter table 表名 modify 字段名 字段类型
	修改还可以使用change
		alter table 表名 change 字段名 字段名 字段类型


约束：
	主键约束
		增加主键约束
			alter table 表名 add primary key(字段名)
		删除主键约束
			alter table 表名 drop primary key
			
			注意： 主键如果是自增长格式的  需要先移除自增长 才能移除主键
			
			添加自增长
			alter table test change id id int auto_increment;
			移除自增长
			alter table test change id id int;
			
	外键约束
		添加
			alter table 表名 add constraint 约束名 foreign key(字段名) references 表名(主键)
		移除
			alter table 表名 drop foreign key 约束名
	唯一约束
		添加
			alter table 表名 add constraint 约束名 unique(字段)
		移除
			alter table 表名 drop index 约束名
	非空约束
		添加
			alter table 表名 change 字段名 字段名 字段类型 not null;
		移除
			alter table 表名 change 字段名 字段名 字段类型；
	默认值约束
		添加
			alter table 表名 change 字段名 字段名 字段类型 default 默认值;
		移除
			alter table 表名 change 字段名 字段名 字段类型；
```

### 常用的数据类型

#### 整数类型

| 类型名称  | 说明       | 存储数据开辟的字节大小 | 数值的范围(有符号)                       | 无符号的数据范围 |
| --------- | ---------- | ---------------------- | ---------------------------------------- | ---------------- |
| tinyint   | 很小的整数 | 1                      | -128到127(`-2**(8-1) 到 2**(8-1)-1`)     | 0-255            |
| smallint  | 小整数     | 2                      | -32768到32767`(-2**(16-1)到2**(16-1)-1)` | 0-65535          |
| mediumint | 中等的整数 | 3                      |                                          |                  |
| int       | 整数       | 4                      |                                          |                  |
| bigint    | 长整型     | 8                      |                                          |                  |

int(11) --- 这种格式的类型标记表示的是设置数据时 数据的宽度建议在11位以内

#### 浮点型和定点类型

```
这两种都表示的是小数
浮点型有两种类型：
	float(单精度的)  4B
	double(双精度的) 8B
定点类型
	decimal

设置的类型表示格式
	float(M, N)
		M --- 包含小数在内数据有多少位
		N --- 小数的位数有几位
		
		float(5, 2)
			数据的范围 0.00 - 999.99
```

#### 日期类型

| 类型名   | 说明                                     |
| -------- | ---------------------------------------- |
| year     | 年，日期格式是yyyy 取值范围1901-2155     |
| date     | 年月日，日期格式yyyy-mm-dd               |
| time     | 时分秒 日期格式HH:MM:SS                  |
| datetime | 年月日时分秒 日期格式yyyy-mm-dd HH:MM:SS |

#### 字符串类型【使用单引号包含】

| 类型名     | 说明             | 存储需求                                                     |
| ---------- | ---------------- | ------------------------------------------------------------ |
| char(M)    | 固定长度的字符串 | M字节  1<=M<=255                                             |
| varchar(M) | 变长的字符串     | M字节  1<=M<=255  存储的内存是有内容字节L决定的 L <=M 真实开辟的字节数L + 1 |
| tinytext   | 很小文本的字符串 | 存储内容字节数L， 也是L+1个字节   L<2**8                     |
| text       | 小文本的字符串   | 存储内容字节数L， 也是L+2个字节   L<2**16                    |
| mediumtext | 中文本的字符串   | 存储内容字节数L， 也是L+3个字节   L<2**24                    |
| longtext   | 大文本的字符串   | 存储内容字节数L， 也是L+4个字节   L<2**32                    |
| enum       | 枚举类型         | 赋值的时候 值必须是列举出来其中的一个                        |
| set        | 集合             | 赋值的时候 值可以是其中的多个                                |

```
char和varchar的区别：【面试经常问到的】
	char 固定长度的
		char(5)  存储的是abc  这个内容只需要3个字节 开辟内存的时候依然开辟的是5个字节
		存储的时候如果存储的内容小于指定的字节个数的，会在内容的末尾添加空格到达指定的字节长度然后进行保存
		取出数据的时候会把数据末尾的空格去除之后再返回数据
		
		如果数据本身末尾是带有空格的 取数据的时候会把数据本身的末尾空格给移除掉
		
	varchar 变长的
		varchar(5) 存储的是abc  这个内容只需要3个字节 开辟的时候4个字节
```

### 约束

#### 主键约束(primary key)

```
主键 --- 表中数据的唯一表示，要求主键约束的这一列的数据不能重复而且不能为空(null)

create table 表名(
列名 数据类型 primary key
)


如果这个键的类型是整型，可以设置主键自增长  插入一条数据默认+1递增的  数据是从1开始的
create table 表名(
列名 int primary key auto_increment
)
```

#### 默认值约束(default)

```
在不填充数据的时候给某个键设置默认值
create table 表名(
列名 数据类型 default 默认值
)
```

#### 唯一约束(unique)

```
某一列的数据是不允许重复的 但是可以为空值
create table 表名(
列名 数据类型 unique
)
```

#### 非空约束(not null)

```
这一列的数据不允许存在空值
create table 表名(
列名 数据类型 not null
)
```

#### 外键约束

```
联系表和表之间一对多的关系， 在多的一方中设置一个外键关联一那一方的主键
create table 表名(
列名 数据类型,
constraint 约束名 foreign key(外键字段名) references 一那一方的表名(主键名)
)

外键的出现关联的两张表一那一方的表成为主表， 多的那一方的表成为从表

从表的外键数据值要依附于主表的主键值，换句话说从表中外键赋值时 值必须在主表的主键中存在， 外键的值可以为Null

```

#### 注解约束(comment)

```
一般情况下是解释这个字段是什么含义
create table 表名(
列名 数据类型 comment '表示什么的字段'
)
```

### DML数据操作语言

```
对表中的数据进行增删改的

1.添加数据
insert into 表名 values(字段对应的数据，用逗号分开)   --- 给表中所有字段添加数据

inert into 表名(字段名1， 字段名2,..字段名n) values(值1， 值2，.. 值n)
	--- 给列出的字段添加数据 没有列出的字段添加默认值
	
一次性添加多条数据
insert into 表名 
values(字段对应的数据，用逗号分开)，
(字段对应的数据，用逗号分开)，
(字段对应的数据，用逗号分开)，
(字段对应的数据，用逗号分开)；



inert into 表名(字段名1， 字段名2,..字段名n) 
values(值1， 值2，.. 值n),
(值1， 值2，.. 值n),
(值1， 值2，.. 值n),
(值1， 值2，.. 值n);


2.修改数据
update 表名 set 字段=新值, 字段=新值..; ---- 表示把这个字段的所有值都进行修改

update 表名 set 字段名=新值,, 字段=新值.. where 筛选条件;

3.删除数据
delete from 表名; ---- 把表中所有的数据都删掉了
delete from 表名 where 筛选条件; --- 把满足条件的删掉
```

### 筛选条件

| 符号            | 说明                                    |
| --------------- | --------------------------------------- |
| =               | 判断两个数据是否相等  sname='侯林沅'    |
| >               | 判断前者是否大于后者                    |
| `>=`            | 判断前者是否大于等于后者                |
| <               | 判断前者是否小于后者                    |
| <=              | 判断前者是否小于等于后者                |
| !=              | 判断两个数据是否不相等                  |
| between A and B | 判断某个数据是否在区间[A,B]内           |
| in              | 判断数据是否在某个容器中                |
| not in          | 判断数据是否不在某个容器中              |
| is null         | 判断某个数据是否是空值                  |
| is not null     | 判断某个数据是否不是空值                |
| like            | 模块查询  _表示单个符号   %匹配多个符号 |
| regexp          | 判断是否满足某个正则表达式              |
| and    or   !   | 逻辑与  逻辑或  逻辑非                  |

### DQL数据查询语言

```
select * from 表名； --- 查询表中的所有数据

select 字段名,字段名1，.. from 表名; --- 查询指定字段的所有数据

select *|字段名 from 表名 where 筛选条件; --- 按照某些条件进行查询

子查询 --- 把查询select语句的结果当做条件 嵌套其他的筛选语句中的 这种结构叫做子查询
	all() 进行比较的时候 每一个比较都成立 结果才是成立的
	any() 进行比较的时候 只要有一个是成立的 结果就是成立的
分组查询
	根据某一个字段对数据分组
	select 分组字段, 聚合函数 from 表名 where 筛选条件 group by 分组字段 having 筛选条件;
	
	where这里的筛选条件 -- 在分组之前进行筛选
	having这里筛选条件 --- 在分组之后对分组的信息进行筛选
	
	聚合函数：
		count() --- 统计查询数据的结果有多少条
				如果有分组的话 统计的是分组之后对应的数据有多少条
			count(*) --- 统计数据的时候 会把满足要求的所有行都累计在内
			count(字段名) --- 统计数据的时候 忽略掉这个字段中为null的数据 不进行统计
		sum() --- 统计某个字段的和
		avg() --- 统计某个字段的平均值的
		max() --- 统计某个字段的最大值
		min() --- 统计某个字段的最小值
		group_concat() -- 列出分组之后某个字段的数据
对结果进行排序
	select 分组字段, 聚合函数 from 表名 where 筛选条件 
	group by 分组字段 having 筛选条件 
	order by 字段; --- 默认根据这个字段的值升序排序
    
    降序排序
    	order by  字段 desc
    根据多个字段进行排序 【如果是升序的可以写asc 或者不写   如果是降序的话在这段的后面写desc】
    	order by 字段，字段, 字段
窗口函数
	窗口函数是针对于数据自己进行计算创建出来的新的一列
	select 字段...， 窗口函数 over(
		partition by <用于分组的表达式>
		order by <用于排序的表达式>
	) as 别名 from 表名
	
	
	over -- 表示窗口函数开始的位置，使用聚合的结果作为一列添加到结果集中
	partition by 根据表达式对数据进行分组，聚合结果被执行
	order by 根据对应的表达式对数据进行排序
	
	
	窗口函数可以使用聚合函数和专门的窗口函数
	专门的窗口函数：
		rank, dense_rank,row_number 这些都是用于排名的函数
	
	计算一下每个人在当前班级中的成绩排名
	rank  --- 有并列排名的情况 但是会占用下一个名次
	dense_rank --- 有并列排名的情况 但是不会占用下一个名次
	row_number --- 没有并列的情况
	
	获取每个班级中成绩前两名的学生信息
	
	找出每个班级中高于此班级平均成绩的学生信息
分页查询
	优先级别最低 放在查询语句的最后
	对查询完成之后的数据提取指定条数的数据
	limit 行数n --- 从查询结果中提取前n行数据
	limit 起始位置，行数n --- 从指定的起始位置开始 提取n行数据  起始位置是从0开始的
多表连接查询
	select * from 表1， 表2
	这种会出现笛卡尔积的现象 --- 就是把两个表中数据数量相乘的一个结果
	解决这个问题 --- 多表连接查询的时候需要设置一下表和表连接的关系，根据这个关系进行查询
	
	连接方式有两种
	1.内连接查询
		写法有3种
		select * from 表1，表2 where 连接条件 and 筛选条件 group by 分组 having 筛选条件
		select * from 表1 join 表2 join 表3 on 连接条件 where 筛选条件 group by 分组 having 筛选条件
		select * from 表1 join 表2 inner join 表3 on 连接条件 where 筛选条件 group by 分组 having 筛选条件
		
		内连接查询的结果：获取的是两个表中满足连接条件的那些数据
		
	2.外连接查询
		左外连接left join (left outer join)
			select * from 表1 left join 表2 left join 表3 on 连接条件 where 筛选条件 group by 分组 having 筛选条件
			
			获取结果：
				显示左表中的全部数据 而右表中是满足连接条件的数据
				左表中数据多的情况下 右表中没有跟其对应的数据 会将右表中使用null进行填充
			
		右外连接right join (right outer join)
			select * from 表1 right join 表2 inner join 表3 on 连接条件 where 筛选条件 group by 分组 having 筛选条件
			
			获取结果：
				显示右表中的全部数据 而左表中是满足连接条件的数据
				右表中数据多的情况下 左表中没有跟其对应的数据 会将左表中使用null进行填充

```

#### where和having的区别

```
where 查询的时候 后面的筛选条件不能有聚合函数，不能使用别名字段（这个字段必须是表格中存在的）
having 筛选的时候 可以跟聚合函数， 如果跟的是字段的话 这个字段必须在select结果中展示出来才可以
	跟在分组后的就是用having

	跟在表名后的
		如果筛选的字段中存在别名 需要使用having 还需要注意的是 筛选的所有字段需要在select后列出来
		
		使用表中的字段进行筛选的  直接就是用where
```



### 数据库中常用的函数

```
1.判断结构
	if判断
		ifnull(字段名, 替换值)
			--- 判断这个字段名对应的值是否有空值  有的话就设置为替换值 没有的话使用原值
		if(条件判断, 表达式1, 表达式2)
			条件判断成立 执行表达式1 否则执行表达式2
	case判断
		case 表达式
		when 值1 then 表达式1
		when 值2 then 表达式2
		...
		else 表达式n+1
		end
		
		解读：
			获取表达式的值， 如果这个值是值1的话  就执行表达式1..
			如果列出的所有的值都不成立 执行else后面的表达式
	
		case 
		when 条件1 then 表达式1
		when 条件2 then 表达式2
		...
		else 表达式n+1
		end
2.数学函数
	求绝对值 abs(字段|数据)
	向上取整 ceil(字段|数据)   结果大于这个数值但是又最接近这个数值的整数
	向下取整 floor(字段|数据)  结果小于这个数值但是又最接近这个数值的整数
	四舍五入 round(字段,保留小数的位数)
	取模 - 求两个数的余数  mod(字段1|数据, 字段2|数据) --- 字段1 % 字段2
	随机数 rand()  在[0, 1) 之间随机产生一个小数
	圆周率 pi()
3.关于字符串的函数
	获取字符串的长度 char_length(字段|数据)
	字符串的拼接 concat(数据1，数据2，数据3，...) 将指定数据们拼接在一起
	字符串内容转化为大写 upper(字段)
	字符串内容转化为小写 lower(字段)
	从左边开始取字符串中指定个数的字符 left(字段,个数)
	获取字符串右边指定个数的字符 right(字段,个数)
	按照指定宽度对字符串进行格式化
		左填充格式化 lpad(字段,宽度,填充符)
		右填充格式化 rpad(字段,宽度,填充符)
	去除字符串两端的空格
		ltrim(字段) -- 只去除左边的
		rtrim(字段) --- 只去除右边的
		trim(字段) --- 去除的是两端的
		还可以去除两端指定的内容 trim(内容 from 字段)
	替换字符串的内容
		replace(字段, 旧子串, 新子串)
	字符串比较的方式
		strcmp(字段1， 字段2)
			字段1 > 字段2  结果是1
			字段1 = 字段2  结果是0
			字段1 < 字段2  结果是-1
	提取子串
		substring(字段, 起始位置(从1开始的),提取长度)
	获取某个子串在原串中的第一次出现的位置
		locate(子串, 原串)
	对字符串的内容进行反转
		reverse(字段)
	insert(字段,指定的位置,长度,新串) --- 对字符串进行增删改
4.关于时间的函数
   获取当前时间
   		curdate() 年月日
   		curtime() 时分秒
   		now() 年月日 十分秒
   时间差
   	datediff(时间1， 时间2) --- 结果是天数
   获取时间的年份
   	year(时间)
   获取时间的月份
   	month(时间)
   获取时间的日期
   	dayofmonth(时间)
   获取小时
   	hour(时间)
   获取分钟
   	minute(时间)
   获取秒
   	second(时间)
   星期
   	dayofweek(时间)  周日是1  周六是7
   获取一年中的第几天
   	dayofyear(时间)
   在指定的时间上做加减法
   	date_add(时间, interval 增加的数据 日期种类 ) 加法
   	date_sub(时间, interval 增加的数据 日期种类 )  减法
   	
   	日期种类（以add 为例）
   		year  增加的是年    interval 1 year  在原来的基础上增加1年
   		month 增加的是月    interval 1 month  在原来的基础上增加1月
   		day   增加的是天    interval 1 day  在原来的基础上增加1天
   		hour  增加的是小时
   		minute 增加的是分钟
   		second 增加的是秒
   		year_month 增加的几年几月   interval '1-1' year_month    【年月日之间的连接符是-】
   		hour_minute 增加的是几时几分     interval '1:1' hour_minute   【时分秒之间的连接符是冒号】
   		hour_second  增加的是几时几分几秒     interval '1:1:1' hour_second 
   		day_hour 增加的几天几小时  interval '1 1' day_hour  【小时和天之间是空格分割的】
        day_minute 增加的是几天几时几分  interval '1 1:1' day_minute
        day_second 增加的是几天几时几分几秒 interval '1 1:1:1' day_second
        minute_second 增加的是几分几秒     interval '1:1' minute_second
  	时间格式化
    	date_format(时间, 格式化格式)
    		%Y --- 年
    		%m --- 月
    		%d --- 日
    		%H --- 24小时制时
    		%I --- 12小时制
    		%p --- 上下午的标记 am  pm
    		%i --- 分钟
    		%S、%s -- 秒
    		%M --- 月份的英文名称
    		%j --- 一年中的第几天
    		%W --- 星期 标识
    		%w --- 星期几
   
   
   week(时间) --- 获取的这个日期是一年中的第几周  默认采用的是国外的时间
   week(时间, 1) --- 以星期一为第一天
   		周数是从0开始的
   		 
```

### DCL数据控制语言

```
mysql -- 安装的系统软件 是一个多用户的， 并且自带超级管理员用户root
工作的时候 是一个项目对应着一个数据库，一个项目对应这一个用户，这个用户只有操作这个项目的数据库的权限

创建用户
	create user 用户名@'IP地址' identified by '密码'；
			IP地址 表示这个用户只能在指定的ip地址上登录数据库
			用户@'%' --- % 就表示的是任意的ip地址

分配权限
	grant 权限1, 权限2,..权限n on 数据库名.数据表名 to 用户名@'ip地址';
		权限 --- 创建create  查询select 修改update 删除delete ...
		如果把所有的权限都给用户的话 就是用all
		
		数据库名.* --- * 这个库下面的所有的表
撤销权限
	revoke 权限1， 权限2，.. on 数据库名.数据表 from 用户名@'ip地址';

删除用户
	drop user 用户名@'ip地址';
```

### 数据库备份与恢复

```
本质上存的是数据表的创建语句和在表中插入数据的语句， 最后把这些语句都存放在sql文件中

备份
	指令 -- cmd上执行的  【不能在mysql环境下使用】
	mysqldump -u 用户名 -p -h 数据库服务所在的IP地址 数据库名 > 要存放数据的文件的路径

恢复
	恢复之前必须先手动创建一个数据库
	
	恢复的指令
		1. 不再mysql环境下  使用cmd
		mysql -u 用户名 -p -h 数据服务所在的IP地址 数据库的名字 < 存放数据的文件的路径
		
		2. 已经在mysql环境下 已经使用用户登录mysql  在cmd中登录mysql  navicat里无法使用
		mysql指令  source 存放这数据的文件的路径
		
```

### 视图View

```
视图--就是把sql的查询结果定义为了一个表， 这种表结构就成为视图

创建视图
create view 视图名字 as sql查询语句；
		视图名字 建议以v_开头
修改视图
	alter view 视图名字 as sql查询语句;

删除
	drop view 视图名字
```

### 事务

```
事务：将多个操作视为一个任务的情况，就是事务

比如要删除教室10
	1.删除这个教室中所有的学生信息
	2.删除教室10

事务的四个特征ACID
	原子性(Atomicity) - 不可分割性
		事务中的操作要么全部完成， 要么就是全部不完成， 不会卡在中间一个点
			转账  A -- 减少金额  B --- 增加金额
	一致性(Consistency ) -- 事务开启之前和事务结束之后， 数据库的完整性没有被破坏
		输出的资料和输入的资料是对等的
	隔离性(Isolation) --- 事务和事务之间是相互隔离的 互不干扰的
	持久性(Durability) --- 事务结束之后 对数据库的修改是永久的
进行多个操作形成的事务的时候 需要开启事务， 否则会默认把每个操作都当做一个事务的

事务的操作语法：
	1.开启事务
		begin  或者  start transaction
	2.提交事务 -- 操作没有问题 --- 操作的结果会被永久保存 -- 会把事务结束
		commit
	3.事务回滚 --- 把数据的状态回滚到开启事务之前 --- 结束事务
		rollback
	4.建立事务节点
		savepoint 节点名
	5.回滚到指定的事务节点
		rollback to 节点名
	6.删除事务节点
		release savepoint 节点名
```

### Python连接MySQL数据库

```
所有的编程语言都不能直接操作数据，需要一个连接池

pymysql --- Python中操作数据库的连接池
mysqlclient
mysql-connector
		这几个都是 Python中操作数据库的连接池

pip install pymysql

mac上  pip3 install pymysql

sql注入：
	就是web应用程序 对于sql语句的过滤性或者判断不严谨， 一些非法分子根据一些数据在导致sql语句恒成立，假性校验成功，非法登录网站
```

### 
