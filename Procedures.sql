create procedure procMarkStudyExamAsPassed
@user_id int, @study_id int
		as
		begin
			set nocount on 
			begin try
		if not exists (select user_id, study_id from 
		User_Studies where user_id=@user_id and study_id=@study_id)
			begin;
				throw 77777, 'Taki u¿ytkownik nie jest przpisany
				do tych studiów', 1
			end
		begin;
			update User_Studies
				set final_exam_passed=1
				where user_id=@user_id and study_id=@study_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy wprowadzaniu 
		informacji o zaliczeniu egzaminu: ' + ERROR_MESSAGE();
		throw 77777, @error, 1
	end catch
end


create procedure procConfirmCourseDiplomaSent
@user_id int
		as
		begin
			set nocount on 
			begin try
		if not exists (select user_id from User_Courses_Diplomas where 
		user_id=@user_id)
			begin;
				throw 77777, 'Nie ma takiego u¿ytkownika', 1
			end
		if not exists (select diploma_ready from User_Courses_Diplomas where
		user_id=@user_id and diploma_ready=1)
			begin;
				throw 77777, 'Dyplom dla danego u¿ytkownika kursu nie
				zosta³ jeszcze przygotowany', 1
			end
		if exists (select diploma_ready from User_Courses_Diplomas where
		user_id=@user_id and diploma_sent=1)
			begin;
				throw 77777, 'Dyplom dla danego u¿ytkownika kursów zosta³
				ju¿ wys³any', 1
			end
		begin;
			update User_Courses_Diplomas
				set diploma_sent=1
				where user_id=@user_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy potwierdzaniu wys³ania
		dyplomu za kurs:' + ERROR_MESSAGE();
		throw 77777, @error, 1
	end catch
end


create procedure procConfirmOrdersSuccess
@order_id int
		as
		begin
			set nocount on 
			begin try
		if not exists (select order_id from Orders where 
		order_id=@order_id)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zamówienia', 1
			end
		if exists (select order_succeed from Orders where
		order_id=@order_id and order_succeed=1)
			begin;
				throw 77777, 'Podane zamówienie zosta³o ju¿ zrealizowane', 1
			end
		begin;
			update Orders
				set order_succeed=1
				where order_id=@order_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy potwierdzaniu zrealizowania zamówienia'
		+ ERROR_MESSAGE(); 
		throw 77777, @error, 1
	end catch
end


create procedure procChangeCourseLimit (
@course_id int, @attendance_limit int)
		as
		begin
			set nocount on 
			begin try
		if not exists (select course_id from Courses where 
		course_id=@course_id)
			begin;
				throw 77777, 'Podano nieprawid³owe ID kursu', 1
			end
		if exists (select attendance_limit from Courses_Limits where
		course_id=@course_id and attendance_limit=@attendance_limit)
			begin;
				throw 77777, 'Podany limit jest ju¿ wprowadzony dla tego kursu', 1
			end
			if @attendance_limit<=20 or @attendance_limit>=150
			begin;
				throw 77777, 'Podany nieprawid³owy limit dla tego kursu', 1
			end
		begin;
			update Courses_Limits
				set attendance_limit=@attendance_limit
				where course_id=@course_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy zmianie limitu kursu: '
		+ ERROR_MESSAGE(); 
		throw 77777, @error, 1
	end catch
end


create procedure procChangeStudyLimit (
@study_id int, @attendance_limit int)
		as
		begin
			set nocount on 
			begin try
		if not exists (select study_id from Studies where 
		study_id=@study_id)
			begin;
				throw 77777, 'Podano nieprawid³owe ID studiów', 1
			end
		if exists (select attendance_limit from Studies where
		study_id=@study_id and attendance_limit=@attendance_limit)
			begin;
				throw 77777, 'Podany limit jest ju¿ wprowadzony dla tego studium', 1
			end
			if @attendance_limit<=15 or @attendance_limit>=100
			begin;
				throw 77777, 'Podany nieprawid³owy limit dla tego studium', 1
			end
		begin;
			update Studies
				set attendance_limit=@attendance_limit
				where study_id=@study_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy zmianie limitu studium'
		+ ERROR_MESSAGE(); 
		throw 77777, @error, 1
	end catch
end


create procedure procChangeStudyMeetingLimit (
@study_meeting_id int, @attendance_limit int)
		as
		begin
			set nocount on 
			begin try
		if not exists (select study_meeting_id from Study_Meetings where 
		study_meeting_id=@study_meeting_id)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zjazdu', 1
			end
		if exists (select attendance_limit from Study_Meetings where
		study_meeting_id=@study_meeting_id and attendance_limit=@attendance_limit)
			begin;
				throw 77777, 'Podany limit jest ju¿ wprowadzony dla tego zjazdu', 1
			end
			if @attendance_limit<=20 or @attendance_limit>=100
			begin;
				throw 77777, 'Podany nieprawid³owy limit dla tego zjazdu', 1
			end
		begin;
			update Study_Meetings
				set attendance_limit=@attendance_limit
				where study_meeting_id=@study_meeting_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy zmianie limitu zjazdu'
		+ ERROR_MESSAGE(); 
		throw 77777, @error, 1
	end catch
end


create procedure procAddWebinarToOrder (
	@order_id INT, @webinar_id INT
	)
		as
		declare @unit_price money
		select @unit_price = price from Webianrs_Prices where
		webinar_id = @webinar_id
			set nocount on 
		if @order_id not in (select order_id from  orders)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zamówienia', 1
			end
		if @webinar_id not in (select webinar_id from  webinars)
			begin;
				throw 77777, 'Podano nieprawid³owe ID webinaru', 1
			end
		if exists(select order_id,webinar_id from webinars_order_details where
		order_id=@order_id and webinar_id=@webinar_id)
			begin;
				throw 77777, 'Podany webinar jest ju¿ w tym zamówieniu', 1
			end
		insert into Webinars_Order_Details(order_id, webinar_id, unit_price)
		values(@order_id, @webinar_id, @unit_price);


create procedure procAddCourseToOrder (
	@order_id INT, @course_id INT
	)
		as
		declare @unit_price money
		select @unit_price = price from Courses where
		course_id = @course_id
			set nocount on 
		if @order_id not in (select order_id from  orders)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zamówienia', 1
			end
		if @course_id not in (select course_id from  courses)
			begin;
				throw 77777, 'Podano nieprawid³owe ID kursu', 1
			end
		if exists(select order_id, course_id from courses_order_details where
		order_id=@order_id and course_id=@course_id)
			begin;
				throw 77777, 'Podany kurs jest ju¿ w tym zamówieniu', 1
			end
		insert into Courses_Order_Details(order_id, course_id, unit_price)
		values(@order_id, @course_id, @unit_price);


create procedure procAddStudyToOrder (
	@order_id INT, @study_id INT
	)
		as
		declare @unit_price money
		select @unit_price = entry_fee from Studies where
		study_id = @study_id
			set nocount on 
		if @order_id not in (select order_id from 
		orders)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zamówienia', 1
			end
		if @study_id not in (select study_id from 
		studies)
			begin;
				throw 77777, 'Podano nieprawid³owe ID webinaru', 1
			end
		if exists(select order_id, study_id from studies_order_details where
		order_id=@order_id and study_id=@study_id)
			begin;
				throw 77777, 'Podane studium jest ju¿ w tym zamówieniu', 1
			end
		insert into Studies_Order_Details(order_id, study_id, unit_price)
		values(@order_id, @study_id, @unit_price);


create procedure procAddStudyMeetingToOrder (
	@order_id INT, @study_meeting_id INT
	)
		as

		declare @unit_price money
		select @unit_price = student_price from Study_Meetings where
		study_meeting_id = @study_meeting_id
			set nocount on 
		if @order_id not in (select order_id from 
		orders)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zamówienia', 1
			end
		if @study_meeting_id not in (select study_meeting_id from 
		Study_Meetings)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zjazdu', 1
			end
		if exists(select order_id,study_meeting_id from study_meetings_order_details 
		where order_id=@order_id and study_meeting_id=@study_meeting_id)
			begin;
				throw 77777, 'Podany zjazd jest ju¿ w tym zamówieniu', 1
			end
		insert into Study_Meetings_Order_Details(order_id, study_meeting_id, unit_price)
		values(@order_id, @study_meeting_id, @unit_price);


create procedure procAddModuleToCourse (
	@course_id INT,@is_online BIT,@module_name VARCHAR(50),
	@description TEXT
)
		as
			set nocount on 
			declare @module_id int
		select @module_id = isnull(max(module_id), 0) + 1 from
	Modules
		if @course_id not in (select course_id from courses)
			begin;
				throw 77777, 'Podano nieprawid³owe ID kursu', 1
			end
		if exists (select module_name, is_online from modules where 
		module_name=@module_name and is_online=@is_online)
			begin;
				throw 77777, 'Podany modu³ w tej formie jest ju¿ dodany', 1
			end
		insert into Modules(module_id,course_id,is_online,
		module_name,description)
		values(@module_id,@course_id,@is_online,
		@module_name,@description);


create procedure procAddClassToStudy (
	@name VARCHAR(255),@study_id INT,@lecturer_id INT,@is_online BIT
	,@start_time TIME, @end_time TIME
)
		as
			set nocount on 
			declare @class_id int
		select @class_id = isnull(max(class_id), 0) + 1 from
	classes
		if @study_id not in (select study_id from studies)
			begin;
				throw 77777, 'Podano nieprawid³owe ID studium', 1
			end
		if @lecturer_id not in (select lecturer_id from lecturers)
			begin;
				throw 77777, 'Podano nieprawid³owe ID wyk³adowcy', 1
			end
		if exists (select name, is_online from classes where 
		name=@name and is_online=@is_online)
			begin;
				throw 77777, 'Podany przedmiot w tej formie jest ju¿ dodany', 1
			end
		if @start_time<'07:00:00'
			begin;
				throw 77777, 'Podano zbyt wczesn¹ godzinê rozpoczêcia', 1
			end
		if @end_time>'20:00:00'
			begin;
				throw 77777, 'Podano zbyt póŸn¹ godzinê zakoñczenia', 1
			end
		insert into Classes(class_id,name,study_id,lecturer_id,is_online,
		start_time, end_time)
		values(@class_id,@name,@study_id,@lecturer_id,@is_online,
		@start_time, @end_time);


create procedure procAddAddress (@city_id int, @street varchar(256),
@house_number varchar(16), @postal_code varchar(256), @buiding_name varchar(256))
	as
		set nocount on
		declare @address_id int
			select @address_id = isnull(max(address_id), 0) + 1 from 
			addresses
		if exists (
			select *
			from Addresses
			where city_id = @city_id and
			street = @street and
			house_number = @house_number and
			postal_code = @postal_code and
			buiding_name = @buiding_name
			)
			begin
				throw 77777, 'Podany adres zosta³ ju¿ wprowadzony', 1
			end
		if @city_id not in (select city_id from Cities)
			begin;
				throw 77777, 'Podano nieprawid³owe ID miasta', 1
			end
		insert into addresses(address_id, city_id, street ,house_number, postal_code, 
		buiding_name)
		values(@address_id, @city_id, @street ,@house_number, @postal_code, 
		@buiding_name);
		

create procedure procAddUser (@first_name varchar(256), @last_name VARCHAR(256),
@email VARCHAR(256), @login VARCHAR(50), @password VARCHAR(100),@phone varchar(16), 
@address_id int)
	as
		set nocount on
		declare @user_id int
			select @user_id = isnull(max(user_id), 0) + 1 from
			users
		if exists (
			select *
			from Users
			where first_name = @first_name and
			last_name = @last_name and
			email = @email and
			login = @login and
			password = @password
			)
			begin
				throw 77777, 'Podany u¿ytkownik zosta³ ju¿ wprowadzony', 1
			end
		if @phone in (select phone from Users_phone_number)
			begin;
				throw 77777, 'Podany numer telefonu jest ju¿ zajêty', 1
			end
		if @email in (select email from Users)
			begin;
				throw 77777, 'Podany adres email jest ju¿ zajêty', 1
			end
		if @login not in (select login from Users)
			begin;
				throw 77777, 'Podany login jest ju¿ zajêty', 1
			end
		if @address_id not in (select address_id from Addresses)
			begin;
				throw 77777, 'Podano nieprawid³owe ID miasta', 1
			end
		insert into users(user_id, first_name,last_name,email,login,password)
		values(@user_id, @first_name,@last_name,@email,@login,@password);
		insert into Users_Phone_Number(user_id, phone)
		values(@user_id, @phone);
		insert into Users_Address(user_id, address_id)
		values(@user_id, @address_id);


create procedure procAddEmployee (
    @first_name VARCHAR(50), @last_name VARCHAR(50), @phone VARCHAR(13),
	@email VARCHAR(50), @login VARCHAR(50), @password VARCHAR(100),
	@employee_type_id INT, @start_date DATE, @end_date DATE
)
	as
		set nocount on
		declare @employee_id int
			select @employee_id = isnull(max(employee_id), 0) + 1 from
	employees
	if exists (
			select *
			from Employees
			where first_name = @first_name and
			last_name = @last_name and
			phone = @phone and
			email = @email and
			login = @login and
			password = @password
			)
			begin
				throw 77777, 'Podany pracownik zosta³ ju¿ dodany', 1
			end
	if @employee_type_id not in (select employee_type_id from employees_types)
		begin;
			throw 77777, 'Podano nieprawid³owe ID typu pracownika', 1
		end
	if @phone in (select phone from employees)
		begin;
			throw 77777, 'Podany numer telefonu jest ju¿ zajêty', 1
		end
	if @login in (select login from employees)
		begin;
			throw 77777, 'Podany login jest ju¿ zajêty', 1
		end
	if YEAR(@start_date)<2020
		begin;
			throw 77777, 'Podano nieprawid³ow¹ datê', 1
		end
		insert into employees(employee_id,first_name,last_name,phone,email,login,
		password)
		values(@employee_id,@first_name,@last_name,@phone,@email,@login,
		@password);
		insert into Employees_Roles(employee_id,employee_type_id,start_date,end_date)
		values(@employee_id,@employee_type_id,@start_date,@end_date);


create procedure procAddEmployeeType (
    @type_name VARCHAR(256)
)
	as
		set nocount on
		declare @employee_type_id int
		select @employee_type_id = isnull(max(employee_type_id), 0) + 1 from
	Employees_Types
		if @type_name in (select type_name from employees_types)
			begin;
				throw 77777, 'Podany typ u¿ytkownika zosta³ ju¿ wprowadzony', 1
			end
		insert into Employees_Types(employee_type_id,type_name)
		values(@employee_type_id,@type_name);


create procedure procAddCountry (
    @country_name VARCHAR(50)
)
	as
		set nocount on
		declare @country_id int
		select @country_id = isnull(max(country_id), 0) + 1 from
	countries
		if @country_name in (select country_name from countries)
			begin;
				throw 77777, 'Podane pañstwo zosta³o ju¿ wprowadzone', 1
			end
		insert into countries(country_id, country_name)
		values(@country_id,@country_name);


create procedure procAddCity (
    @country_id INT, @city_name VARCHAR(50)
)
	as
		set nocount on
		declare @city_id int
		select @city_id = isnull(max(city_id), 0) + 1 from
	cities
		if @city_name in (select city_name from cities where country_id=@country_id)
			begin;
				throw 77777, 'Podane miasto zosta³o ju¿ wprowadzone', 1
			end
		if @country_id not in (select country_id from countries)
			begin;
				throw 77777, 'Podano nieprawid³owe ID pañstwa', 1
			end
		insert into cities(city_id, country_id, city_name)
		values(@city_id,@country_id,@city_name);


create procedure procAddLanguage (
    @language_name VARCHAR(256)
)
	as
		set nocount on
		declare @language_id int
		select @language_id = isnull(max(language_id), 0) + 1 from
	languages
		if @language_name in (select language_name from languages)
			begin;
				throw 77777, 'Podany jêzyk zosta³ ju¿ wprowadzony', 1
			end
		insert into languages(language_id, language_name)
		values(@language_id,@language_name);


create procedure procAddWebinar (
	@title VARCHAR(256), @description TEXT, @is_free BIT, @price MONEY
	)
		as
			set nocount on 
			declare @webinar_id int
		select @webinar_id = isnull(max(webinar_id), 0) + 1 from
	webinars
		if @title in (select title from webinars)
			begin;
				throw 77777, 'Webinar o podanym tytule zosta³ ju¿ wprowadzony', 1
			end
		if @price <0
			begin;
				throw 77777, 'Cena webinaru musi byæ wiêksza b¹dŸ równa 0', 1
			end
		insert into webinars(webinar_id, title, description, is_free)
		values(@webinar_id, @title, @description, @is_free);
		insert into Webinars_Prices(webinar_id,price)
		values(@webinar_id, @price);


create procedure procAddWebinarMeetingToCalendar (
	@webinar_id INT, @lecturer_id INT, @hosted_material VARCHAR(512),
	@description TEXT, @live_start DATETIME, @live_end DATETIME, 
	@shared_due DATETIME
 )
		as
			set nocount on 
			declare @meeting_id int
		select @meeting_id = isnull(max(meeting_id), 0) + 1 from
	webinars_meetings
		if @webinar_id not in (select webinar_id from webinars)
			begin;
				throw 77777, 'Wprowadzono nieprawid³owe ID webinaru', 1
			end
		if @live_start<GETDATE()
			begin;
				throw 77777, 'Podano nieprawid³ow¹ datê rozpoczêcia webinaru', 1
			end
		if @live_start>@live_end
			begin;
				throw 77777, 'Data rozpoczêcia musi byæ przed dat¹ zakoñczenia', 1
			end
		if DATEADD(DAY,30,@live_end)!=@shared_due
			begin;
				throw 77777, 'Webinar musi byæ udostêpniany na okres 30 dni', 1
			end
		insert into Webinars_Meetings(meeting_id,webinar_id, lecturer_id,
		hosted_material, description)
		values(@meeting_id,@webinar_id, @lecturer_id, @hosted_material, 
		@description);
		insert into Webinars_Meetings_Calendar(meeting_id,live_start,
		live_end, shared_due)
		values(@meeting_id,@live_start, @live_end, @shared_due)


create procedure procAddStudy (
	@title VARCHAR(255), @syllabus TEXT, @entry_fee MONEY, 
	@attendance_limit INT
	)
		as
			set nocount on 
			declare @study_id int
		select @study_id = isnull(max(study_id), 0) + 1 from
	studies
		if @title in (select title from studies)
			begin;
				throw 77777, 'Podany kierunek studiów zosta³ ju¿ wprowadzony', 1
			end
		if @entry_fee <=1000
			begin;
				throw 77777, 'Podano nieprawid³ow¹ op³atê za studia', 1
			end
		if @attendance_limit <15 or @attendance_limit>100
			begin;
				throw 77777, 'Podano nieprawid³owy limit uczestników', 1
			end
		insert into studies(study_id, title, syllabus, entry_fee,
		attendance_limit)
		values(@study_id, @title, @syllabus, @entry_fee, @attendance_limit);
	

create procedure procAddCourse (
	@title VARCHAR(255), @description TEXT, @price MONEY, 
	@advance_pay INT, @attendance_limit INT, @start_date DATE, 
	@end_date DATE
	)
		as
			set nocount on 
			declare @course_id int
		select @course_id = isnull(max(course_id), 0) + 1 from
	courses
		if @title in (select title from courses)
			begin;
				throw 77777, 'Kurs o podanym tytule zosta³ ju¿ wprowadzony', 1
			end
		if @price <50
			begin;
				throw 77777, 'Podano nieprawid³ow¹ op³atê za kurs', 1
			end
		if @advance_pay <10
			begin;
				throw 77777, 'Podano nieprawid³ow¹ wartoœc zaliczki za kurs', 1
			end
		if @start_date<GETDATE()
			begin;
				throw 77777, 'Podano nieprawid³ow¹ datê rozpoczêcia kursu', 1
			end
		if @start_date>@end_date
			begin;
				throw 77777, 'Data rozpoczêcia musi byæ przed dat¹ zakoñczenia', 1
			end
		insert into courses(course_id, title, description, price, 
		advance_pay)
		values(@course_id, @title, @description,@price, @advance_pay);
		insert into courses_limits(course_id, attendance_limit)
		values(@course_id, @attendance_limit);
		insert into courses_calendar(course_id, start_date, end_date)
		values(@course_id, @start_date, @end_date);


create procedure procAddStudyMeeting (
	@study_id INT, @description TEXT, @student_price MONEY,
	@external_price MONEY, @attendance_limit INT, @start_date DATE, 
	@end_date DATE
	)
		as
			set nocount on 
			declare @study_meeting_id int
		select @study_meeting_id = isnull(max(study_meeting_id), 0) + 1 from
	study_meetings
		if @study_id not in (select study_id from studies)
			begin;
				throw 77777, 'Studium o podanym ID nie istnieje', 1
			end
		if @student_price <9.99
			begin;
				throw 77777, 'Podano nieprawid³ow¹ op³atê za zjazd dla studenta', 1
			end
		if @external_price <24.99
			begin;
				throw 77777, 'Podano nieprawid³ow¹ op³atê za zjazd dla osoby z zewn¹trz', 1
			end
		if @attendance_limit <20 or @attendance_limit>=100
			begin;
				throw 77777, 'Podano nieprawid³owy limit uczestników', 1
			end
		if @start_date<GETDATE()
			begin;
				throw 77777, 'Podano nieprawid³ow¹ datê zjazdu', 1
			end;
		if @start_date>@end_date
			begin;
				throw 77777, 'Data rozpoczêcia musi byæ przed dat¹ zakoñczenia', 1
			end;
		insert into Study_Meetings(study_meeting_id,study_id, 
		description, student_price, external_price, attendance_limit)
		values(@study_meeting_id,@study_id, 
		@description, @student_price, @external_price, @attendance_limit);
		insert into Study_Meetings_Calendar(study_meeting_id,study_id,
		start_date,end_date)
		values(@study_meeting_id, @study_id, @start_date, @end_date)


create procedure procAddOrder (
	@user_id INT
	)
		as
			set nocount on 
			declare @order_id int
		select @order_id = isnull(max(order_id), 0) + 1 from
	orders
			declare @order_date datetime
		set @order_date=GETDATE()
			declare @order_succeed bit
		set @order_succeed=0
		if @user_id not in (select user_id from users)
			begin;
				throw 77777, 'Podano nieprawid³owe ID u¿ytkownika', 1
			end
		insert into orders(order_id, user_id, order_date, order_succeed)
		values(@order_id, @user_id, @order_date, @order_succeed);


create procedure procAddPayment ( 
	@order_id INT, @payment_url VARCHAR(256), @payment_succeed BIT
	)
	as
			set nocount on 
			declare @payment_date datetime
		set @payment_date=GETDATE()
		if @order_id not in (select order_id from orders)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zamówienia', 1
			end
		insert into Payments_Details(order_id,payment_url, payment_date, 
		payment_succeed)
		values(@order_id,@payment_url, @payment_date, @payment_succeed)


create procedure procAddUserToStudy (
	@user_id INT, @study_id INT, @amount_paid MONEY, @final_exam_passed BIT
	)
		as
			set nocount on 
		if @user_id not in (select user_id from users)
			begin;
				throw 77777, 'Podano nieprawid³owe ID u¿ytkownika', 1
			end
		if @study_id not in (select study_id from studies)
			begin;
				throw 77777, 'Podano nieprawid³owe ID studiów', 1
			end
		if exists(select user_id, study_id from user_studies where user_id=@user_id
		and study_id=@study_id)
			begin;
				throw 77777, 'Podany u¿ytkownik jest ju¿ dodany do tych studiów', 1
			end
		if @amount_paid <99.99
			begin;
				throw 77777, 'Podano nieprawid³ow¹ kwotê', 1
			end
		insert into User_Studies(user_id, study_id, amount_paid, final_exam_passed)
		values(@user_id, @study_id, @amount_paid, @final_exam_passed)
	

create procedure procAddUserToCourse (
	@user_id INT, @course_id INT
	)
		as
			set nocount on 
		if @user_id not in (select user_id from users)
			begin;
				throw 77777, 'Podano nieprawid³owe ID u¿ytkownika', 1
			end
		if @course_id not in (select course_id from courses)
			begin;
				throw 77777, 'Podano nieprawid³owe ID studiów', 1
			end
		if exists(select user_id, course_id from courses_users where user_id=@user_id
		and course_id=@course_id)
			begin;
				throw 77777, 'Podany u¿ytkownik jest ju¿ dodany do tego kursu', 1
			end
		insert into courses_users(user_id, course_id)
		values(@user_id, @course_id)


create procedure procAddUserToStudyMeeting (
	@user_id INT, @study_meeting_id INT
	)
		as
			set nocount on 
		if @user_id not in (select user_id from users)
			begin;
				throw 77777, 'Podano nieprawid³owe ID u¿ytkownika', 1
			end
		if @study_meeting_id not in (select study_meeting_id from study_meetings)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zjazdu', 1
			end
		if exists(select user_id, study_meeting_id from users_study_meetings 
		where user_id=@user_id and study_meeting_id=@study_meeting_id)
			begin;
				throw 77777, 'Podany u¿ytkownik jest ju¿ dodany do tego zjazdu', 1
			end
		insert into Users_Study_Meetings(user_id, study_meeting_id)
		values(@user_id, @study_meeting_id)


drop proc procAddCourseAdvancedPaymentException
create procedure procAddCourseAdvancedPaymentException (
	@user_id INT, @course_id INT, @required_advance_pay MONEY, 
	@pay_due DATE
	)
		as
			set nocount on 
			declare @exception_id int
		select @exception_id = isnull(max(exception_id), 0) + 1 from
	Courses_Advanced_Payment_Exceptions
		if @user_id not in (select user_id from users)
			begin;
				throw 77777, 'Podano nieprawid³owe ID u¿ytkownika', 1
			end
		if @course_id not in (select course_id from courses)
			begin;
				throw 77777, 'Podano nieprawid³owe ID kursu', 1
			end
		if @required_advance_pay <0
			begin;
				throw 77777, 'Podano nieprawid³ow¹ kwotê wyj¹tku', 1
			end
		if @pay_due<GETDATE()
			begin;
				throw 77777, 'Podano nieprawid³ow¹ datê przelewu', 1
			end
		insert into Courses_Advanced_Payment_Exceptions(exception_id,
		user_id, course_id, required_advance_pay, pay_due)
		values(@exception_id, @user_id, @course_id, @required_advance_pay,
		@pay_due);


create procedure procAddStudiesFeetException (
	@user_id INT, @study_id INT, @required_entry_fee MONEY, @pay_due DATE
	)
		as
			set nocount on 
			declare @exception_id int
		select @exception_id = isnull(max(exception_id), 0) + 1 from
	Studies_Fee_Exceptions
		if @user_id not in (select user_id from users)
			begin;
				throw 77777, 'Podano nieprawid³owe ID u¿ytkownika', 1
			end
		if @study_id not in (select course_id from courses)
			begin;
				throw 77777, 'Podano nieprawid³owe ID studium', 1
			end
		if @required_entry_fee <0
			begin;
				throw 77777, 'Podano nieprawid³ow¹ kwotê wyj¹tku', 1
			end
		if @pay_due<GETDATE()
			begin;
				throw 77777, 'Podano nieprawid³ow¹ datê przelewu', 1
			end
		insert into Studies_Fee_Exceptions(exception_id, user_id,
		study_id, required_entry_fee, pay_due)
		values(@exception_id, @user_id, @study_id, @required_entry_fee, 
		@pay_due);


create procedure procAddUsersStudyMeetingsPaymentExceptions (
	@user_id INT,@study_meeting_id INT, @required_starting_payment MONEY,
	@payment_due DATE
	)
		as
			set nocount on 
			declare @exception_id int
		select @exception_id = isnull(max(exception_id), 0) + 1 from
	Users_Study_Meetings_Payment_Exceptions
		if @user_id not in (select user_id from users)
			begin;
				throw 77777, 'Podano nieprawid³owe ID u¿ytkownika', 1
			end
		if @study_meeting_id not in (select study_meeting_id from 
		study_meetings)
			begin;
				throw 77777, 'Podano nieprawid³owe ID zjazdu', 1
			end
		if @required_starting_payment<0
			begin;
				throw 77777, 'Podano nieprawid³ow¹ kwotê wyj¹tku', 1
			end
		if @payment_due<GETDATE()
			begin;
				throw 77777, 'Podano nieprawid³ow¹ datê przelewu', 1
			end
		insert into Users_Study_Meetings_Payment_Exceptions(exception_id,
		user_id, study_meeting_id, required_starting_payment, payment_due)
		values(@exception_id,@user_id, @study_meeting_id, 
		@required_starting_payment, @payment_due);


create procedure procConfirmStudyDiplomaReady
@user_id int
		as
		begin
			set nocount on 
			begin try
		if not exists (select user_id from User_Studies_Diplomas where 
		user_id=@user_id)
			begin;
				throw 77777, 'Nie ma takiego u¿ytkownika', 1
			end
		if exists (select diploma_ready from User_Studies_Diplomas where
		user_id=@user_id and diploma_ready=1)
			begin;
				throw 77777, 'Dyplom dla danego u¿ytkownika studiów 
				zosta³ ju¿ przygotowany', 1
			end
		begin;
			update User_Studies_Diplomas
				set diploma_ready=1
				where user_id=@user_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy potwierdzaniu 
		przygotowania dyplomu za studia:' + ERROR_MESSAGE();
		throw 77777, @error, 1
	end catch
end


create procedure procConfirmStudyDiplomaSent
@user_id int
		as
		begin
			set nocount on 
			begin try
		if not exists (select user_id from User_Studies_Diplomas where 
		user_id=@user_id)
			begin;
				throw 77777, 'Nie ma takiego u¿ytkownika', 1
			end
		if not exists (select diploma_ready from User_Studies_Diplomas where
		user_id=@user_id and diploma_ready=1)
			begin;
				throw 77777, 'Dyplom dla danego u¿ytkownika studiów nie
				zosta³ jeszcze przygotowany', 1
			end
		if exists (select diploma_ready from User_Studies_Diplomas where
		user_id=@user_id and diploma_sent=1)
			begin;
				throw 77777, 'Dyplom dla danego u¿ytkownika studiów zosta³
				ju¿ wys³any', 1
			end
		begin;
			update User_Studies_Diplomas
				set diploma_sent=1
				where user_id=@user_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy potwierdzaniu wys³ania
		dyplomu za studia:' + ERROR_MESSAGE();
		throw 77777, @error, 1
	end catch
end


create procedure procConfirmCourseDiplomaReady
@user_id int
		as
		begin
			set nocount on 
			begin try
		if not exists (select user_id from Courses_Users_Diplomas where 
		user_id=@user_id)
			begin;
				throw 77777, 'Nie ma takiego u¿ytkownika', 1
			end
		if exists (select diploma_ready from Courses_Users_Diplomas where
		user_id=@user_id and diploma_ready=1)
			begin;
				throw 77777, 'Dyplom dla danego u¿ytkownika kursu 
				zosta³ ju¿ przygotowany', 1
			end
		begin;
			update Courses_Users_Diplomas
				set diploma_ready=1
				where user_id=@user_id
		end
	end try
	begin catch
		declare @error varchar(1000)='B³¹d przy potwierdzaniu 
		przygotowania dyplomu za kurs:' + ERROR_MESSAGE();
		throw 77777, @error, 1
	end catch
end
