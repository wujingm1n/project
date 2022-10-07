

### hive的DQL语法

#### 单表查询

```sql
select [all | distinct] col1, col2, ...
from db_name.table_name 
[连接方式 join db_name.table_name on 连接条件]
[where 分组前筛选]
[group by 分组字段 [having 分组后筛选]]
[[cluster by 分区及局部排序字段] |
	distribute by 分区字段 [sort by 局部排序 | order by 全局排序]]
[limit 限制行数]

-- cluster by 和 distribute by 二选一
-- sort by 和 order by 二选一
-- order by 按某字段全局排序，asc升序，desc降序
-- distribute by + sort by，以某字段分区并按某字段局部排序，可为同一字段

-- cluster by，具有distribute by分区功能，也具有sort by局部排序功能
-- 如果 distribute by + sort by 为同一字段
-- 那么 cluster by 等价于 distribute by + sort by

-- sort by 和 order by 可以指定排序规则，asc升序，desc降序
-- cluster by 不能指定排序规则，只能升序（正序排序）
```

- where 筛选

```sql
select * 
from sm.sm_customer_info 
where age <> 18; -- 该语句不含null
-- null 不能做比较

select * 
from sm.sm_customer_info 
where age <> 18 or age is null;
```

- group by 分组

```sql
-- 如果使用group by，那么select后面只能写分组字段或聚合函数
-- where：分组前筛选，写在group by前面，不能写聚合函数
-- having：分组后筛选，写在group by后面，只能写分组字段或聚合函数
select t.region, count(t.id) as cnt
from sm.sm_order_total t
where t.region <> '东北'
group by t.region
having count(t.id) > 1000 and t.region in ('华东', '华北');
```

#### 多表查询
- join 连接

```sql
-- 关闭自动mapjoin，数据集很少可能抛出异常
-- set hive.auto.convert.join=false

-- inner join 内连接，inner可省略
select * 
from edu.teacher t
inner join edu.course c on c.t_id = t.t_id;

-- left join 左连接
select * 
from edu.teacher t
left join edu.course c on c.t_id = t.t_id;

-- right join 右连接
select * 
from edu.teacher t
right join edu.course c on c.t_id = t.t_id;

-- full join 全连接
select * 
from edu.teacher t
full join edu.course c on c.t_id = t.t_id;

-- left semi join 左半连接，与以下in子查询结果一致
select t.* -- 只能是t表的字段
from edu.teacher t
left semi join edu.course c on c.t_id = t.t_id;

select t.*, c.c_name -- 如有c表的字段则抛出异常
from edu.teacher t
left semi join edu.course c on c.t_id = t.t_id;

-- in子查询
select t.* 
from edu.teacher t
where t.t_id (
	select c.t_id
    from edu.course c);

-- 逗号连接
select * 
from edu.teacher t, edu.course c
where c.t_id = t.t_id;
```

- order by 全局排序

```sql
-- asc升序，desc降序
select * 
from edu.student t1 
left join edu.score t2 on t1.s_id = t2.s_id 
order by t2.s_score desc;
```

- sort by 局部排序

```sql
-- set mapreduce.job.reduces=3; -- 参数设置错误的话不会抛出异常
-- set mapreduce.job.reduces;
-- 生产环境一般需要设置，提高效率
-- 如果表没有分区或分桶,局部排序和全局排序结果一致
select * 
from edu.score 
sort by s_score desc;
select * 
from edu.score 
order by s_score desc;

-- 设定随机分区，再局部排序
-- 设置分区后仅支持升序排序（正序）
select * 
from edu.score 
distribute by rand()
sort by s_score;
```

- distribute by  + sort by 分区排序

```sql
-- 以下两种写法是等价的
select * 
from edu.score 
distribute by c_id
sort by c_id;

select * 
from edu.score 
cluster by c_id;

-- cluster by，具有distribute by分区功能，也具有sort by局部排序功能
-- 如果 distribute by + sort by 为同一字段
-- 那么 cluster by 等价于 distribute by + sort by

-- sort by 和 order by 可以指定排序规则，asc升序，desc降序
-- cluster by 不能指定排序规则，只能升序（正序排序）
```

- cluster by 分区排序

```sql
-- sort by 和 order by 可以指定排序规则，asc升序，desc降序
-- cluster by 不能指定排序规则，只能升序（正序排序）
```

## Hive性能调优

### 1.SQL语句优化

#### 1.union all

```sql
-- 创建分区表，最高分插入max分区，最低分插入到min分区
create table test.course_max_min (
	c_id int comment '课程id',
	s_score int comment '分数')
comment '每个课程的最高分和最低分'
partitioned by (tp string comment '分数类型');

-- 开启动态分区
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;


-- 优化前，同一张表，分组两次(运行前开启动态分区)
insert into table test.course_max_min partition(tp)
select sc.c_id, max(sc.s_score) as s_score, 'max' as tp 
from edu.score sc
group by sc.c_id
union all
select sc.c_id, min(sc.s_score) as s_score, 'min' as tp 
from edu.score sc
group by sc.c_id;


-- 优化前，同一张表，分组一次(运行前开启动态分区)
from edu.score sc

insert into test.course_max_min partition(tp)
select sc.c_id, max(sc.s_score) as s_score, 'max' as tp 
group by sc.c_id

insert into test.course_max_min partition(tp)
select sc.c_id, min(sc.s_score) as s_score, 'min' as tp 
group by sc.c_id;
```

#### 2.distinct

```sql
-- 优化前
explain
select count(1) 
from ( 
	select s_id 
	from edu.student 
	group by s_id
	) tb;

-- 优化后
explain
select count(distinct s_id)
from edu.student;
```

#### 3.left semi join

```sql
-- 优化前，通过退货表的订单编号去筛选订单详情表的数据

-- in子查询
explain
select count(a.order_id)
from sm.sm_order_detail_np a
where order_id in (
	select b.order_id
	from sm.sm_return_info b);

-- exists子查询
explain
select count(a.order_id)
from sm.sm_order_detail_np a
where exists (
	select * 
	from sm.sm_return_info b 
	where a.order_id = b.order_id 
	);

-- 优化后
-- left semi join左半连接，相当于按on条件筛选左表的数据
-- select子句只能选取左表的字段，如选右表的字段则报错
-- on子句的过滤条件只能是等于号
-- 右表的过滤条件只能在on子句设置
select count(a.order_id)
from sm.sm_order_detail_np a
left semi join sm.sm_return_info b on b.order_id = a.order_id;

-- in子查询与exists子查询的执行计划完全一致，所以是等价的
```

### 2.并行执行优化

```sql
-- 启动并行执行
set hive.exec.parallel=true;
-- 设置并行执行的线程数量，默认为8
set hive.exec.parallel.thread.number=16;
```

