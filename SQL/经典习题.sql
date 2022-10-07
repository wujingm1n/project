-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数
select 
    s.*
    , s1.s_score as s_score_1
    , s2.s_score as s_score_2
from student s 
join score s1 on s.s_id=s1.s_id and s1.c_id=1
left join score s2 on s.s_id=s2.s_id and s2.c_id=2
where s1.s_score>s2.s_score;

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
select 
    s.*
    , s1.s_score as s_score_1
    , s2.s_score as s_score_2
from student s 
join score s1 on s.s_id=s1.s_id and s1.c_id=1
left join score s2 on s.s_id=s2.s_id and s2.c_id=2
where s1.s_score<s2.s_score;

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select 
    s.s_id, s.s_name
    , avg(sc.s_score) as avg_score
from student s
join score sc on s.s_id=sc.s_id
group by s.s_id , s.s_name
having avg(sc.s_score)>60;

-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩(包括有成绩的和无成绩的)
select 
    s.s_id, s.s_name
    , avg(sc.s_score) as avg_score
from student s 
join score sc on s.s_id=sc.s_id
group by s.s_id, s.s_name
having avg(sc.s_score)<60
union all
select s.s_id, s.s_name, 0 as avg_score
from student s
where s.s_id not in (
    select distinct s_id
    from score);

-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select 
    s.s_id, s.s_name
    , count(sc.c_id), sum(sc.s_score)
from student s 
left join score sc on s.s_id=sc.s_id
group by s.s_id, s.s_name;

-- 6、查询"李"姓老师的数量
select count(t_id) as cnt
from teacher 
where t_name like '李%';

-- 7、查询学过"张三"老师授课的同学的信息
select s.* 
from student s 
join score sc on s.s_id=sc.s_id
join course c on sc.c_id=c.c_id
join teacher t on t.t_id=c.t_id
where t.t_name='张三';

-- 8、查询没学过"张三"老师授课的同学的信息
select s.* 
from student s 
where s.s_id not in(
    select s.s_id 
    from student s 
    join score sc on s.s_id=sc.s_id
    join course c on sc.c_id=c.c_id
    join teacher t on t.t_id=c.t_id
    where t.t_name='张三');

-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息
select s.s_id, s.s_name, s.s_birth, s.s_sex
from student s
join (
    select s_id, c_id from score where c_id=1
    union all
    select s_id, c_id from score where c_id=2
    ) tmp on s.s_id=tmp.s_id
group by s.s_id, s.s_name, s.s_birth, s.s_sex
having count(tmp.s_id)=2;

-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息
select s.* 
from student s 
join (select s_id from score where c_id=1) sc1 on s.s_id=sc1.s_id
left join (select s_id from score where c_id=2) sc2 on s.s_id=sc2.s_id
where sc2.s_id is null;

-- 11、查询没有学全所有课程的同学的信息
select s.* 
from student s
left join (
    select s_id
    from score
    group by s_id
    having count(c_id)=5
    ) tmp on s.s_id=tmp.s_id
where tmp.s_id is null;

-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息
select s.s_id, s.s_name, s.s_birth, s.s_sex
from score sc1
join score sc2 on sc2.s_id=1 and sc2.c_id=sc1.c_id
left join student s on s.s_id=sc1.s_id
where sc1.s_id not in (1)
group by s.s_id, s.s_name, s.s_birth, s.s_sex;

-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息
select s.s_id, s.s_name, s.s_birth, s.s_sex, count(sc1.c_id) as cnt
from score sc1
join score sc2 on sc2.s_id=1 and sc2.c_id=sc1.c_id
left join student s on s.s_id=sc1.s_id
where sc1.s_id not in (1)
group by s.s_id, s.s_name, s.s_birth, s.s_sex
having count(sc1.c_id) in (select count(c_id) from score where s_id=1);

-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名
select s.s_id, s.s_name 
from student s
left join score sc on s.s_id=sc.s_id
left join course c on sc.c_id=c.c_id
left join teacher t on t.t_id=c.t_id and t.t_name='张三'
group by s.s_id, s.s_name
having count(t.t_id)=0;

-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select s.*, tmp.avg_score 
from student s 
join (
    select s_id, count(c_id) as c_cnt, avg(s_score) as avg_score 
    from score 
    where s_score < 60 
    group by s_id 
    having c_cnt >= 2
) tmp on tmp.s_id=s.s_id;

-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
select s.*, tmp.s_score 
from student s 
join (
    select s_id, s_score 
    from score 
    where c_id=1 and s_score<60
    ) tmp on s.s_id=tmp.s_id
order by tmp.s_score desc;

-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
select 
    s.s_id, s.s_name
    , sc1.s_score as c1
    , sc2.s_score as c2
    , sc3.s_score as c3
    , sc4.s_score as c4
    , sc5.s_score as c5
    , avg(sc6.s_score) as avg_score
from student s
left join score sc1 on sc1.c_id=1 and sc1.s_id=s.s_id
left join score sc2 on sc2.c_id=2 and sc2.s_id=s.s_id
left join score sc3 on sc3.c_id=3 and sc3.s_id=s.s_id
left join score sc4 on sc4.c_id=4 and sc4.s_id=s.s_id
left join score sc5 on sc5.c_id=5 and sc5.s_id=s.s_id
left join score sc6 on sc6.s_id=s.s_id
group by 
    s.s_id, s.s_name
    , sc1.s_score, sc2.s_score, sc3.s_score, sc4.s_score, sc5.s_score
order by avg_score desc;

-- 18、查询各科成绩最高分、最低分和平均分：以如下形式显示：课程id，课程name，最高分，最低分，平均分，及格率，中等率，良好率，优秀率
select 
    c.c_id, c.c_name
    ,tmp.max_score
    ,tmp.min_score
    ,tmp.avg_score
    ,tmp.pass_rate
    ,tmp.medium_rate
    ,tmp.good_rate
    ,tmp.excellent_rate 
from course c
join(
    select 
    c_id,
    max(s_score) as max_score,
    min(s_score) as min_score,
    avg(s_score) as avg_score,
    sum(case when s_score>=60 then 1 else 0 end)/count(c_id) as pass_rate,
    sum(case when s_score>=60 and s_score<70 then 1 else 0 end)/count(c_id) as medium_rate,
    sum(case when s_score>=70 and s_score<80 then 1 else 0 end)/count(c_id) as good_rate,
    sum(case when s_score>=80 and s_score<90 then 1 else 0 end)/count(c_id) as excellent_rate
    from score 
    group by c_id
    ) tmp on tmp.c_id=c.c_id;

-- 19、按各科成绩进行排序，并显示排名：row_number() over()分组排序功能
select 
    c_id, s_id, s_score
    , row_number() over(partition by c_id order by s_score desc)
from score;

-- 20、查询学生的总成绩并进行排名
select 
    s.s_id, s.s_name
    , sum(sc.s_score) as sum_score
    , row_number() over(order by sum(sc.s_score) desc) as row_number
from score sc
join student s on sc.s_id=s.s_id
group by s.s_id, s.s_name;

-- 21、查询不同老师所教不同课程平均分从高到低显示
select 
    sc.c_id, c.t_id
    , avg(sc.s_score) as avg_score
from score sc
join course c on sc.c_id=c.c_id
group by sc.c_id, c.t_id
order by avg_score desc;

-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
select tmp.c_id, s.*, tmp.s_score, tmp.row_number 
from student s 
join(
    select 
        c_id, s_id, s_score
        , row_number() over(partition by c_id order by s_score desc) as row_number
    from score
    ) tmp on s.s_id=tmp.s_id
where tmp.row_number between 2 and 3;

-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
select 
    sc.c_id, c.c_name
    , sum(case when sc.s_score>=85 and sc.s_score<=100 then 1 else 0 end)/count(sc.s_score) as 100and85
    , sum(case when sc.s_score>=70 and sc.s_score<85 then 1 else 0 end)/count(sc.s_score) as 85and70
    , sum(case when sc.s_score>=60 and sc.s_score<70 then 1 else 0 end)/count(sc.s_score) as 70and60
    , sum(case when sc.s_score>=0 and sc.s_score<60 then 1 else 0 end)/count(sc.s_score) as 60and0
from score sc
left join course c on sc.c_id=c.c_id
group by sc.c_id, c.c_name;

-- 24、查询学生平均成绩及其名次
select 
    s_id
    , avg(s_score) as avg_score
    , row_number() over(order by avg(s_score) desc)
from score
group by s_id;

-- 25、查询各科成绩前三名的记录
select tmp.c_id, s.*, tmp.s_score, tmp.row_number 
from student s 
join (
    select 
        c_id, s_id, s_score
        , row_number() over(partition by c_id order by s_score desc) as row_number
    from score
    ) tmp on s.s_id=tmp.s_id
where tmp.row_number<=3;

-- 26、查询每门课程被选修的学生数
select c_id, count(s_score) as cnt
from score
group by c_id;

-- 27、查询出只有两门课程的全部学生的学号和姓名
select s_id, count(c_id) as cnt
from score
group by s_id
having count(c_id)=2;

-- 28、查询男生、女生人数
select s_sex, count(1) as cnt
from student
group by s_sex;

-- 29、查询名字中含有"风"字的学生信息
select * 
from student 
where s_name like '%风%';

-- 30、查询同名同性学生名单，并统计同名人数
select s_name, s_sex, count(s_id) as cnt
from student
group by s_name, s_sex;

-- 31、查询1990年出生的学生名单
select * 
from student
where year(s_birth)=1990;

-- 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select 
    c_id
    , avg(s_score) as avg_score
    , row_number() over(order by avg(s_score) desc, c_id asc) as row_number
from score
group by c_id;

-- 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩
select s.s_id, s.s_name, avg(sc.s_score) as avg_score
from student s 
join score sc on s.s_id=sc.s_id
group by s.s_id, s.s_name
having avg(sc.s_score)>85;

-- 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数
select s.s_name, sc.s_score
from student s
join score sc 
join course c on s.s_id=sc.s_id and sc.c_id=c.c_id
where c.c_name='数学' and sc.s_score<60;

-- 35、查询所有学生的课程及分数情况
select s.s_id, tmp.chinese, tmp.math, tmp.english
from student s
left join (
    select sc.s_id,
        sum(case c.c_name when '语文' then sc.s_score else 0 end) as chinese, 
        sum(case c.c_name when '数学' then sc.s_score else 0 end) as math,
        sum(case c.c_name when '英语' then sc.s_score else 0 end) as english
    from score sc
    join course c on sc.c_id=c.c_id
    group by sc.s_id
    ) tmp on s.s_id=tmp.s_id;

-- 36、查询任何一门课程成绩在70分以上的学生姓名、课程名称和分数
select s.s_name, c.c_name, sc.s_score
from score sc
left join student s on sc.s_id=s.s_id
join course c on sc.c_id=c.c_id
where sc.s_score>70;

-- 37、查询课程不及格的学生
select s_id
from score
where s_score<60
group by s_id;

-- 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名
select sc.s_id, s.s_name
from score sc
join student s on sc.s_id=s.s_id
where c_id=1 and s_score>=80;

-- 39、求每门课程的学生人数
select c_id, count(s_id) as cnt
from score
group by c_id

-- 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩
select 
    sc.c_id, s.s_id, s.s_name, s.s_birth, s.s_sex
    , max(sc.s_score) as max_score
from score sc
left join student s on s.s_id=sc.s_id
join course c on sc.c_id=c.c_id
join teacher t on t.t_id=c.t_id
where t.t_name='张三'
group by sc.c_id, s.s_id, s.s_name, s.s_birth, s.s_sex
order by max_score desc
limit 1;

-- 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
select s1.s_id, s1.c_id, s1.s_score
from score s1, score s2
where s1.c_id<>s2.c_id and s1.s_score=s2.s_score;

-- 42、查询每门课程成绩最好的前三名
select tmp.c_id, s.*, tmp.s_score, tmp.row_number 
from student s 
join(
    select 
        c_id, s_id, s_score
        , row_number() over(partition by c_id order by s_score desc) as row_number
    from score
    ) tmp on s.s_id=tmp.s_id
where tmp.row_number<=3;

-- 43、统计每门课程的学生选修人数（超过5人的课程才统计）
-- 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select c_id, count(s_id) as cnt
from score
group by c_id
having cnt>=5
order by cnt desc, c_id asc;

-- 44、检索至少选修两门课程的学生学号
select s_id
from score
group by s_id
having count(c_id)>=2;

-- 45、查询选修了全部课程的学生信息
select s.*
from student s
join (
    select s_id, count(c_id) as cnt 
    from score 
    group by s_id
    ) tmp on s.s_id=tmp.s_id
where tmp.cnt=3;

-- 46、查询各学生的年龄(周岁)
-- 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
with tmp as(
    select s_id, year(current_date())-year(s_birth) as tage
    from student)
select 
    s.s_id
    , sum(case month(current_date())>month(s.s_birth) when true then tmp.tage-1 else tmp.tage end) s_age 
from student s
join tmp on s.s_id=tmp.s_id
group by s.s_id;

-- 47、查询本周过生日的学生
select *
from student
where weekofyear(concat(year(current_date()), '-', date_format(s_birth, 'mm-dd')))=
      weekofyear(current_date())

-- 48、查询下周过生日的学生
select *
from student 
where weekofyear(concat(year(current_date()), '-', date_format(s_birth, 'mm-dd')))=
      weekofyear(current_date()) + 1;

-- 49、查询本月过生日的学生
select *
from student 
where month(s_birth)=month(current_date())

-- 50、查询12月份过生日的学生
select * from student where month(s_birth)=12
