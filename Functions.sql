create function funcOrderedAtLeastXTimes (@how_many_times int)
returns table as return
(select 'Webinar' as 'Type', AVG(w.webinar_id) as 'ID' from webinars w join
Webinars_Order_Details wod on w.webinar_id=wod.webinar_id group by
wod.webinar_id having COUNT(wod.webinar_id)>=@how_many_times)
union
(select 'Course' as 'Type', AVG(c.course_id) from courses c join
courses_Order_Details cod on c.course_id=cod.course_id group by
cod.course_id having COUNT(cod.course_id)>=@how_many_times)
union
(select 'Study' as 'Type', AVG(s.study_id) from studies s join
Studies_Order_Details sod on s.study_id=sod.study_id group by
sod.study_id having COUNT(sod.study_id)>=@how_many_times)
union
(select 'Study Meeting' as 'Type', AVG(sm.study_meeting_id) 
from Study_Meetings sm 
join Study_Meetings_Order_Details smod on 
sm.study_meeting_id= smod.study_meeting_id group by smod.study_meeting_id 
having COUNT(smod.study_meeting_id)>=@how_many_times)


create function funcUsersStats(@user_id INT)
returns table
as
return
(
    select
        (select COUNT(*) FROM orders WHERE user_id = @user_id) AS 'Number of orders',
        (select
            ISNULL(SUM(wod.unit_price), 0) +
            ISNULL(SUM(cod.unit_price), 0) +
            ISNULL(SUM(sod.unit_price), 0) +
            ISNULL(SUM(smod.unit_price), 0)
         from orders o
         left join  Webinars_Order_Details wod ON o.order_id = wod.order_id
         left join Courses_Order_Details cod ON o.order_id = cod.order_id
         left join Studies_Order_Details sod ON o.order_id = sod.order_id
         left join Study_Meetings_Order_Details smod ON o.order_id = smod.order_id
         where o.user_id = @user_id
        ) as 'Full value',
        case
            when (select COUNT(*) from orders where user_id = @user_id) > 0 
            then (select 
                    ISNULL(SUM(wod.unit_price), 0) +
                    ISNULL(SUM(cod.unit_price), 0) +
                    ISNULL(SUM(sod.unit_price), 0) +
                    ISNULL(SUM(smod.unit_price), 0)
                from orders o
                left join Webinars_Order_Details wod ON o.order_id = wod.order_id
               left join Courses_Order_Details cod ON o.order_id = cod.order_id
                left join Studies_Order_Details sod ON o.order_id = sod.order_id
           		left join Study_Meetings_Order_Details smod ON o.order_id = smod.order_id
                where o.user_id = @user_id
            ) / (select COUNT(*) FROM orders WHERE user_id = @user_id)
            else null
        end as 'Value per order'
);


create function funcLecturersClassesAndWebinars(@lecturer_id INT)
returns table as return
(select 'Class' as 'Type', c.name from classes c
where c.lecturer_id=@lecturer_id)
union
(select 'Webinar' as 'Type', w.title from webinars_meetings wm 
join webinars w on wm.webinar_id=w.webinar_id where
wm.lecturer_id=@lecturer_id)



create function funcLecturersClassesAndWebinarsNumber(@lecturer_id INT)
returns float as
begin
declare @output float
select @output= COUNT(*) 
from ((select 'Class' as 'Type', c.name from classes c
where c.lecturer_id=@lecturer_id)
union
(select 'Webinar' as 'Type', w.title from webinars_meetings wm 
join webinars w on wm.webinar_id=w.webinar_id where
wm.lecturer_id=@lecturer_id)) as subquery
return @output
end


create function funcTranslatorsActivities(@translator_id INT)
returns table as return
select c.name from classes_translators ct 
join classes c on c.class_id=ct.class_id
join translators t on t.translator_id=ct.translator_id
where ct.translator_id=@translator_id


create function funcTranslatorsActivitiesNumber(@translator_id INT)
returns float as
begin
declare @output float
select @output= COUNT(*) 
from (select c.name from classes_translators ct 
join classes c on c.class_id=ct.class_id
join translators t on t.translator_id=ct.translator_id
where ct.translator_id=@translator_id) as subquery
return @output
end


create function InternshipInstitutionStats(@institution_id INT)
returns table as return
select institution_name, (select COUNT(*) from users_internships
where institution_id=@institution_id) as 'Number of Users', 
(select COUNT(*) from users_internships 
where is_passed=1 and institution_id=@institution_id) 
as 'Passed' from Internship_Institutions where institution_id=@institution_id


create function funcMostlyOrdered ()
returns table as return
(select TOP 1 WITH TIES 'Webinar' as 'Type', AVG(wod.webinar_id) as 'ID', COUNT(*) as 
'How many times' from webinars w 
join Webinars_Order_Details wod on w.webinar_id=wod.webinar_id group by
wod.webinar_id order by 3 DESC)
union
(select TOP 1 WITH TIES 'Course' as 'Type', AVG(cod.course_id) ,COUNT(*) from courses c join
courses_Order_Details cod on c.course_id=cod.course_id group by
cod.course_id order by 3 DESC)
union
(select TOP 1 WITH TIES 'Study' as 'Type',AVG(sod.study_id), COUNT(*) from studies s join
Studies_Order_Details sod on s.study_id=sod.study_id group by
sod.study_id order by 3 DESC)
union
(select TOP 1 WITH TIES 'Study Meeting' as 'Type', AVG(smod.study_meeting_id), COUNT(*)
from Study_Meetings sm 
join Study_Meetings_Order_Details smod on 
sm.study_meeting_id= smod.study_meeting_id group by smod.study_meeting_id 
order by 3 DESC)


create function funcUsersOrdersNumber (@user_id int)
returns table as return
	select * from 
	(select count(*) as 'Orders Number' from Orders WHERE 
	user_id=@user_id) as subquery


create function funcUsersActivities (@user_id int)
returns table as return
	select 'Webinar' as 'Type', w.title from Webinars_users wu join webinars w
	on w.webinar_id=wu.webinar_id where wu.user_id=@user_id 
	union
	select 'Course' as 'Type', c.title from courses_users cu join courses c
	on c.course_id=cu.course_id where cu.user_id=@user_id 
	union
	select 'Study' as 'Type', s.title from user_studies us join studies s
	on s.study_id=us.study_id where us.user_id=@user_id 


create function funcGetOrderValue(@order_id int)
returns float as
begin
declare @output float
set @output=
(select (SUM(isnull(WOD.unit_price,0)) +SUM(isnull(COD.unit_price,0))+
SUM(isnull(SOD.unit_price,0))+SUM(isnull(SMOD.unit_price,0)))
from Orders O left join Webinars_Order_Details WOD 
on O.order_id=WOD.order_id
left join Courses_Order_Details COD on O.order_id=COD.order_id
left join Studies_Order_Details SOD on O.order_id=SOD.order_id
left join Study_Meetings_Order_Details SMOD on O.order_id=SMOD.order_id
where O.order_id = @order_id)
return @output
end


create function funcGetOrderDetailsByOrderID (@order_id int)
returns table as return
(select 'Webinar' as 'Type', w.title from webinars w join
Webinars_Order_Details wod on w.webinar_id=wod.webinar_id where
wod.order_id=@order_id)
union
(select 'Course' as 'Type', c.title from courses c join
courses_Order_Details cod on c.course_id=cod.course_id where
cod.order_id=@order_id)
union
(select 'Study' as 'Type', s.title from studies s join
Studies_Order_Details sod on s.study_id=sod.study_id where
sod.order_id=@order_id)
union
(select 'Study Meeting' as 'Type', CONVERT(VARCHAR,sm.description) from Study_Meetings sm 
join Study_Meetings_Order_Details smod on 
sm.study_meeting_id= smod.study_meeting_id where smod.order_id=@order_id)


create function  funcGetValueOfOrdersOnDay(@data date)
returns float as
begin
declare @suma float
set @suma =
(select sum(dbo.funcGetOrderValue(O.order_id)) from Orders as O
where YEAR(o.order_date)=YEAR(@data) and MONTH(o.order_date)=MONTH(@data)
and DAY(o.order_date)=DAY(@data))
return @suma 
end


create function funcEmployeesNotFired()
returns table as return
	select e.first_name,e.last_name from employees e join employees_roles
	er on e.employee_id=er.employee_id where er.end_date is null


create function funcDiplomasNotReady()
returns table as return
	select 'course_or_study' as 'course' ,c.title,u.first_name,u.last_name from users u
	join courses_users_diplomas cud on u.user_id=cud.user_id 
	join courses c on cud.course_id=c.course_id where 
	cud.diploma_ready=0
	UNION
	select 'course_or_study' as 'study',s.title,u.first_name,u.last_name from users u
	join user_studies_diplomas usd on u.user_id=usd.user_id 
	join studies s on usd.study_id=s.study_id where 
	usd.diploma_ready=0


create function funcDiplomasReadyNotSent()
returns table as return
	select 'course_or_study' as 'course' ,c.title,u.first_name,u.last_name from users u
	join courses_users_diplomas cud on u.user_id=cud.user_id 
	join courses c on cud.course_id=c.course_id where 
	cud.diploma_ready=1 and cud.diploma_sent=0
	UNION
	select 'course_or_study' as 'study',s.title,u.first_name,u.last_name from users u
	join user_studies_diplomas usd on u.user_id=usd.user_id 
	join studies s on usd.study_id=s.study_id where 
	usd.diploma_ready=1 and usd.diploma_sent=0


create function funcEmployeesHiredAs(@nazwa varchar(100))
returns table as return
	select e.first_name,e.last_name from employees e 
	join employees_roles er on e.employee_id=er.employee_id
	join employees_types et on er.employee_type_id=et.employee_type_id
	where @nazwa=et.type_name


create function funcUserAndPhoneNumber()
returns table as return
	select u.first_name,u.last_name, upn.phone
	from users u join users_phone_number upn on u.user_id=upn.user_id


create function funcUserAndEmail()
returns table as return
	select u.first_name,u.last_name, a.house_number, a.postal_code,
	a.buiding_name, ci.city_name,co.country_name from users u
	join users_address ua on u.user_id=ua.user_id
	join addresses a on a.address_id=ua.address_id
	join cities ci on ci.city_id=a.city_id
	join countries co on co.country_id=ci.city_id


create function funcAttendanceAndPassForUsersInternships(@user_id int)
returns table as return
	select u.first_name, u.last_name, il.institution_name, ui.attendance,
	ui.is_passed from Internship_Location il 
	join Users_Internships ui on il.institution_id=ui.institution_id
	join users u on u.user_id=ui.user_id
	where ui.user_id=@user_id


create function funcEventsOnDay(@data date)
returns table as return 
	select 'Webinar' as 'Event', w.webinar_id from webinars_meetings_calendar wmc
	join webinars_meetings wm on wmc.meeting_id=wm.meeting_id
	join webinars w on w.webinar_id=wm.webinar_id
	where CONVERT(DATE,live_start)=@data
	union
	select 'Study Meeting' as 'Event', sm.study_meeting_id
	from study_meetings_calendar smc
	join study_meetings sm on smc.study_meeting_id=sm.study_meeting_id
	where @data between start_date and end_date
	union
	select 'Course' as 'Event', c.course_id
	from courses_calendar cc
	join courses c on c.course_id=cc.course_id
	where @data between start_date and end_date
	union
	select 'Class' as 'Event', class_id
	from classes
	where @data between CONVERT(DATE,start_time) and CONVERT(DATE,end_time)


create function funcCountEventsOnDay(@data date)
returns int
as
begin
    declare @RowCount INT;

    select @RowCount = COUNT(*)
    from funcEventsOnDay(@data);

    return @RowCount;
end;


create function PaidWebinars()
returns table as return 
	select w.title, wp.price from webinars w join
	webinars_prices wp on w.webinar_id=wp.webinar_id
	where wp.price>0


create function funcModulesAndDescriptionsForCourses(@course_id int)
returns table as return
	select m.module_name, m.description from modules m
	join courses c on m.course_id=c.course_id where c.course_id=@course_id


create function funcExceptionsForUser(@user_id int)
returns table as return
	select 'Course Advanced Payment' as 'Exception Type', COUNT(*) as
	'Number of Exceptions' from Courses_Advanced_Payment_Exceptions 
	cape join users u on cape.user_id=u.user_id where cape.user_id=@user_id
	union
	select 'Studies Fee' as 'Exception Type', COUNT(*) as
	'Number of Exceptions' from Studies_Fee_Exceptions as 
	sfe join users u on sfe.user_id=u.user_id where sfe.user_id=@user_id
	union
	select 'Study Meeting Payment' as 'Exception Type', COUNT(*) as
	'Number of Exceptions' from Users_Study_Meetings_Payment_Exceptions 
	usmpe join users u on usmpe.user_id=u.user_id where usmpe.user_id=@user_id


create function funcSearch(@slowo_kluczowe varchar(30))
returns table as return 
	select 'Webinar' as 'Form', title from webinars
	where CHARINDEX(@slowo_kluczowe, title)>0
	union
	select 'Course' as 'Form', title from Courses
	where CHARINDEX(@slowo_kluczowe, title)>0
	union
	select 'Study' as 'Form', title from Studies
	where CHARINDEX(@slowo_kluczowe, title)>0


create function funcLanguageOfClass(@class_id INT)
returns table as return 
select l.language_name from languages l join classes_languages cl on 
l.language_id=cl.language_id where cl.class_id=@class_id



create function funcLanguagesOfWebinar(@webinar_id INT)
returns table as return 
select l.language_name from languages l 
join Webinars_Meeting_Languages wml on l.language_id=wml.language_id 
join Webinars_Meetings wm on wml.meeting_id=wm.meeting_id
where wm.webinar_id=@webinar_id
