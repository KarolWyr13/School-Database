-- Tabela Countries
CREATE TABLE Countries (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(50)
);

ALTER TABLE Countries
ADD CONSTRAINT unique_countries
UNIQUE (country_name)

-- Tabela Cities
CREATE TABLE Cities (
    city_id INT PRIMARY KEY,
    country_id INT,
    city_name VARCHAR(50),
    FOREIGN KEY (country_id) REFERENCES Countries(country_id)
);


ALTER TABLE Cities
ADD CONSTRAINT unique_cities
UNIQUE (city_name)


-- Tabela Addresses
CREATE TABLE Addresses (
    address_id INT PRIMARY KEY,
    city_id INT,
    street VARCHAR(256),
    house_number VARCHAR(16),
    postal_code VARCHAR(256),
	buiding_name VARCHAR(256)
    FOREIGN KEY (city_id) REFERENCES Cities(city_id)
);


-- Tabela Users_Address
CREATE TABLE Users_Address (
    user_id INT PRIMARY KEY,
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

--Tabela Lecture_Classrooms
CREATE TABLE Lecture_Classrooms (
    classroom_id INT PRIMARY KEY,
    building_id INT,
    classroom_number VARCHAR(16),
    attendance_limit INT,
    FOREIGN KEY (building_id) REFERENCES Addresses(address_id)
);

alter table Lecture_Classrooms
add constraint lecture_classrooms_check check (attendance_limit>20 and attendance_limit<100);

ALTER TABLE Lecture_Classrooms
ADD CONSTRAINT lecture_classrooms_unique
UNIQUE (building_id,classroom_number)


-- Tabela Classrooms
CREATE TABLE Classrooms (
    class_id INT PRIMARY KEY,
    classroom_id INT,
	FOREIGN KEY (classroom_id) REFERENCES Lecture_Classrooms(classroom_id)
);

-- Tabela Users
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(256),
    last_name VARCHAR(256),
	email VARCHAR(256),
    login VARCHAR(50),
    password VARCHAR(100),
	FOREIGN KEY (user_id) REFERENCES Users_Address(user_id)
);


ALTER TABLE Users
ADD CONSTRAINT users_unique_1
UNIQUE (email)

ALTER TABLE Users
ADD CONSTRAINT users_unique_2
UNIQUE (login)

ALTER TABLE Users
ADD CONSTRAINT users_check check (email like '%@%')

-- Tabela Users_Phone_Number
CREATE TABLE Users_Phone_Number (
    user_id INT PRIMARY KEY,
    phone VARCHAR(16),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

alter table Users_Phone_Number
add constraint users_phone_number_check check (phone like '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
or phone like '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
or phone like '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
or phone like '+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');


-- Tabela Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
	course_mode_id INT,
    title VARCHAR(255),
    description TEXT,
    price MONEY,
    advance_pay MONEY
);

CREATE TABLE Courses_Modes (
	course_id INT,
	course_mode_id INT,
	PRIMARY KEY (course_id, course_mode_id),
	FOREIGN KEY (course_id) REFERENCES courses(course_id),
	FOREIGN KEY (course_mode_id) REFERENCES courses_modes_names(course_mode_id)
);

--Tabela Courses_Types
CREATE TABLE Courses_Modes_Names (
	course_mode_id INT PRIMARY KEY,
	course_name VARCHAR(255)
);

alter table Courses
add constraint courses_check check (price>50 and advance_pay>10)


ALTER TABLE Courses ADD CONSTRAINT courses_default DEFAULT 'No description' FOR description

ALTER TABLE Courses
ADD CONSTRAINT courses_unique
UNIQUE (title)

-- Tabela Studies
CREATE TABLE Studies (
    study_id INT PRIMARY KEY,
    title VARCHAR(255),
    syllabus TEXT,
	entry_fee MONEY,
    attendance_limit INT
);

alter table Studies
add constraint studies_check check (entry_fee>1000 and attendance_limit>=15 and attendance_limit<100 )


ALTER TABLE Studies
ADD CONSTRAINT studies_unique
UNIQUE (title)

-- Tabela Modules
CREATE TABLE Modules (
    module_id INT PRIMARY KEY,
    course_id INT,
	is_online BIT,
	module_name VARCHAR(50),
    description TEXT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);



ALTER TABLE Modules ADD CONSTRAINT modules_default DEFAULT 'No description' FOR description


-- Tabela Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    order_date DATETIME,
    order_succeed BIT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

alter table Orders
add constraint orders_check check (YEAR(order_date)>=2020);


-- Tabela Courses_Users
CREATE TABLE Courses_Users (
    user_id INT,
    course_id INT,
	PRIMARY KEY (user_id, course_id),
    amount_paid MONEY,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


-- Tabela Courses_Advanced_Payment_Exceptions
CREATE TABLE Courses_Advanced_Payment_Exceptions (
    exception_id INT PRIMARY KEY,
	user_id INT,
    course_id INT,
    required_advance_pay MONEY,
    pay_due DATE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

alter table Courses_Advanced_Payment_Exceptions
add constraint courses_advanced_payment_exceptions_check check (required_advance_pay>0)

alter table Courses_Advanced_Payment_Exceptions
add constraint courses_advanced_payment_exceptions_check_2 check (YEAR(pay_due)>=2020);


-- Tabela Courses_Limits
CREATE TABLE Courses_Limits (
    course_id INT PRIMARY KEY,
    attendance_limit INT,
	FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

alter table Courses_Limits
add constraint courses_limits_check check (attendance_limit>20 and attendance_limit<150)

-- Tabela Classes
CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
	name VARCHAR(255),
	study_id INT,
    lecturer_id INT,
    is_online BIT,
    start_time TIME,
    end_time TIME,
	FOREIGN KEY (study_id) REFERENCES Studies(study_id)
);

alter table classes
add constraint classes_unique unique (name)

alter table Classes
add constraint classes_check check (start_time<end_time)

alter table Classes
add constraint classes_check_2 check ( start_time>='07:00:00');

alter table Classes
add constraint classes_check_3 check ( end_time<='20:00:00');


ALTER TABLE Studies
ADD CONSTRAINT studies_unique
UNIQUE (title)

-- Tabela Employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(13),
    email VARCHAR(50),
    login VARCHAR(50),
    password VARCHAR(100),
	FOREIGN KEY (employee_id) REFERENCES Users(user_id)
);


alter table Employees
add constraint employees_check check (phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

ALTER TABLE Employees
ADD CONSTRAINT employees_check_2 check (email like '%@%')

ALTER TABLE Employees
ADD CONSTRAINT employees_unique_1
UNIQUE (phone)

ALTER TABLE Employees
ADD CONSTRAINT employees_unique_2
UNIQUE (email)

ALTER TABLE Employees
ADD CONSTRAINT employees_unique_3
UNIQUE (login)

-- Tabela Study_Meetings
CREATE TABLE Study_Meetings (
    study_meeting_id INT PRIMARY KEY,
    study_id INT,
    description TEXT,
    student_price MONEY,
    external_price MONEY,
    attendance_limit INT,
    FOREIGN KEY (study_id) REFERENCES Studies(study_id)
);

alter table Study_Meetings
add constraint study_meetings_check check (student_price>=9.99 and external_price>=24.99 and attendance_limit>=20 and attendance_limit<100);

ALTER TABLE Study_Meetings ADD CONSTRAINT study_meetings_default DEFAULT 'No description' FOR description


-- Tabela Studies_Fee_Exceptions
CREATE TABLE Studies_Fee_Exceptions (
	exception_id INT PRIMARY KEY,
    user_id INT,
    study_id INT,
    required_entry_fee MONEY,
    pay_due DATE,
    FOREIGN KEY (study_id) REFERENCES Studies(study_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

alter table Studies_Fee_Exceptions
add constraint studies_fee_exceptions_check check (required_entry_fee>0);

alter table Studies_Fee_Exceptions
add constraint studies_fee_exceptions_check_2 check (YEAR(pay_due)>=2020);

-- Tabela Users_Study_Meetings_Payment_Exceptions
CREATE TABLE Users_Study_Meetings_Payment_Exceptions (
	exception_id INT PRIMARY KEY,
    user_id INT,
    study_meeting_id INT,
    required_starting_payment MONEY,
    payment_due DATE,
    FOREIGN KEY (study_meeting_id) REFERENCES Study_Meetings(study_meeting_id)
);


alter table Users_Study_Meetings_Payment_Exceptions
add constraint users_study_meetings_payment_exceptions_check check (required_starting_payment>0);

alter table Users_Study_Meetings_Payment_Exceptions
add constraint users_study_meetings_payment_exceptions_check_2 check (YEAR(payment_due)>=2020);


-- Tabela Users_Study_Meetings_Accesses
CREATE TABLE Users_Study_Meetings_Accesses (
    user_id INT PRIMARY KEY,
    study_meeting_id INT,
    commentary TEXT,
    FOREIGN KEY (study_meeting_id) REFERENCES Study_Meetings(study_meeting_id)
);

ALTER TABLE Users_Study_Meetings_Accesses ADD CONSTRAINT users_study_meetings_accesses_default DEFAULT 'No commentary' FOR commentary


-- Tabela Study_Meetings_Calendar
CREATE TABLE Study_Meetings_Calendar (
    study_meeting_id INT PRIMARY KEY,
	study_id INT,
    start_date DATE,
    end_date DATE,
	FOREIGN KEY (study_meeting_id) REFERENCES Study_Meetings(study_meeting_id)
);

alter table Study_Meetings_Calendar
add constraint study_meetings_calendar_check_1 check (start_date<end_date);

alter table Study_Meetings_Calendar
add constraint study_meetings_calendar_check_2 check (YEAR(start_date)>=2020);


-- Tabela Studies_Order_Details
CREATE TABLE Studies_Order_Details (
    order_id INT,
    study_id INT,
	PRIMARY KEY (order_id, study_id),
    unit_price MONEY,
    FOREIGN KEY (study_id) REFERENCES Studies(study_id),
	FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

select * from Studies_Order_Details

alter table Studies_Order_Details
add constraint studies_order_details_check check (unit_price>1000);

-- Tabela Payments_Details
CREATE TABLE Payments_Details (
    order_id INT PRIMARY KEY,
    payment_url VARCHAR(256),
    payment_date DATETIME,
	payment_succeed BIT
	FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

ALTER TABLE Payments_Details
ADD CONSTRAINT payments_details_unique
UNIQUE (payment_url)

-- Tabela Courses_Order_Details
CREATE TABLE Courses_Order_Details (
    order_id INT,
    course_id INT,
	PRIMARY KEY(order_id,course_id),
    unit_price MONEY,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
	FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

alter table Courses_Order_Details
add constraint courses_order_details_check check (unit_price>=99.99);

-- Tabela Study_Meetings_Order_Details
CREATE TABLE Study_Meetings_Order_Details (
    order_id INT,
    study_meeting_id INT,
	PRIMARY KEY(order_id, study_meeting_id),
    unit_price MONEY,
    FOREIGN KEY (study_meeting_id) REFERENCES Study_Meetings(study_meeting_id),
	FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

alter table Study_Meetings_Order_Details
add constraint study_meetings_order_details_check check (unit_price>1000);

-- Tabela Study_Meetings_Classess
CREATE TABLE Study_Meetings_Classes (
    study_meeting_id INT PRIMARY KEY,
    class_id INT,
    FOREIGN KEY (study_meeting_id) REFERENCES Study_Meetings(study_meeting_id)
);

-- Tabela User_Classes
CREATE TABLE User_Classes (
    user_id INT,
    class_id INT,
	 PRIMARY KEY (user_id,class_id),
    attendance INT,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

alter table User_Classes
add constraint user_classes_check check (attendance between 0 and 100);

-- Tabela Modules_Classes
CREATE TABLE Modules_Classes (
    module_id INT PRIMARY KEY,
    class_id INT,
    FOREIGN KEY (module_id) REFERENCES Modules(module_id),
	FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Tabela Class_Changes
CREATE TABLE Class_Changes (
    original_class_id INT PRIMARY KEY,
    new_class_id INT,
    FOREIGN KEY (new_class_id) REFERENCES Classes(class_id)
);

-- Tabela Languages
CREATE TABLE Languages (
    language_id INT PRIMARY KEY,
    language_name VARCHAR(256)
);

ALTER TABLE Languages
ADD CONSTRAINT languages_unique
UNIQUE (language_name)

-- Tabela Classes_Languages
CREATE TABLE Classes_Languages (
    class_id INT PRIMARY KEY,
    language_id INT,
    FOREIGN KEY (language_id) REFERENCES Languages(language_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Tabela Webinars_Meeting_Languages
CREATE TABLE Webinars_Meeting_Languages (
    meeting_id INT PRIMARY KEY,
    language_id INT,
    FOREIGN KEY (language_id) REFERENCES Languages(language_id)
);

-- Tabela Users_Study_Meetings
CREATE TABLE Users_Study_Meetings (
    user_id INT,
    study_meeting_id INT,
	PRIMARY KEY(user_id,study_meeting_id),
    amount_paid MONEY,
    FOREIGN KEY (study_meeting_id) REFERENCES Study_Meetings(study_meeting_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Tabela Employees_Types
CREATE TABLE Employees_Types (
    employee_type_id INT PRIMARY KEY,
    type_name VARCHAR(256)
);


ALTER TABLE Employees_Types
ADD CONSTRAINT employees_types_unique
UNIQUE (type_name)

-- Tabela Employees_Roles
CREATE TABLE Employees_Roles (
    employee_id INT PRIMARY KEY,
    employee_type_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (employee_type_id) REFERENCES Employees_types(employee_type_id),
	FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

alter table Employees_Roles
add constraint employees_roles_check check (start_date<end_date or end_date is null);

alter table Employees_Roles
add constraint employees_roles_check_2 check (YEAR(start_date)>=2020);



-- Tabela Courses_Payments
CREATE TABLE Courses_Payments (
    user_id INT,
    course_id INT,
	PRIMARY KEY (user_id,course_id),
    required_starting_payment MONEY,
    pay_due DATE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

alter table Courses_Payments
add constraint courses_payments_check check (required_starting_payment>=99.00);

alter table Courses_Payments
add constraint courses_payments_check_2 check (YEAR(pay_due)>=2020);


-- Tabela Webinars
CREATE TABLE Webinars (
    webinar_id INT PRIMARY KEY,
    title VARCHAR(256),
    description TEXT,
    is_free BIT
);

ALTER TABLE Webinars ADD CONSTRAINT webinars_default DEFAULT 'No description' FOR description

ALTER TABLE Webinars
ADD CONSTRAINT webinars_unique
UNIQUE (title)

-- Tabela Webinars_Users
CREATE TABLE Webinars_Users (
    user_id INT,
    webinar_id INT,
	shared_from DATETIME,
	shared_to DATETIME,
	PRIMARY KEY (user_id,webinar_id),
    FOREIGN KEY (webinar_id) REFERENCES Webinars(webinar_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
);

alter table Webinars_Users
add constraint webinars_users_check check (shared_to=DATEADD(DAY,30,shared_from));

alter table Webinars_Users
add constraint webinars_users_check_2 check (YEAR(shared_from)>=2020);


-- Tabela Webinars_Prices
CREATE TABLE Webinars_Prices (
    webinar_id INT PRIMARY KEY,
    price MONEY,
	FOREIGN KEY (webinar_id) REFERENCES Webinars(webinar_id)
);

alter table Webinars_Prices
add constraint webinars_prices_check check (price>=0);

ALTER TABLE Webinars_Prices ADD CONSTRAINT webinars_prices_default DEFAULT 0 FOR price

-- Tabela Users_Webinars_Exceptions
CREATE TABLE Users_Webinars_Exceptions (
	exception_id INT PRIMARY KEY,
    user_id INT,
    webinar_id INT,
    required_starting_payment MONEY,
    pay_due DATE,
    FOREIGN KEY (webinar_id) REFERENCES Webinars(webinar_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


alter table Users_Webinars_Exceptions
add constraint users_webinars_exceptions_check check (YEAR(pay_due)>=2020);


-- Tabela Webinars_Order_Details
CREATE TABLE Webinars_Order_Details (
    order_id INT,
    webinar_id INT,
	PRIMARY KEY (order_id,webinar_id),
    unit_price MONEY,
    FOREIGN KEY (webinar_id) REFERENCES Webinars(webinar_id),
	FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

select * from Webinars_Order_Details


alter table Webinars_Order_Details
add constraint webinars_order_details_check check (unit_price>=0);

-- Tabela Webinars_Meetings
CREATE TABLE Webinars_Meetings (
    meeting_id INT PRIMARY KEY,
    webinar_id INT,
    lecturer_id INT,
    hosted_material VARCHAR(512),
    description TEXT,
	FOREIGN KEY (webinar_id) REFERENCES Webinars(webinar_id)
);

ALTER TABLE Webinars_Meetings ADD CONSTRAINT webinars_meetings_default DEFAULT 'No description' FOR description

-- Tabela Webinars_Meetings_Calendar
CREATE TABLE Webinars_Meetings_Calendar (
    meeting_id INT PRIMARY KEY,
    live_start DATETIME,
    live_end DATETIME,
	shared_due DATETIME,
	FOREIGN KEY (meeting_id) REFERENCES Webinars_Meetings(meeting_id)
);

alter table Webinars_Meetings_Calendar
add constraint webinars_meetings_calendar_check check (live_start<live_end);

alter table Webinars_Meetings_Calendar
add constraint webinars_meetings_calendar_check_2 check (shared_due=DATEADD(DAY, 30, live_end));

alter table Webinars_Meetings_Calendar
add constraint users_webinars_exceptions_check_3 check (YEAR(live_start)>=2020);


-- Tabela Users_Internships
CREATE TABLE Users_Internships (
	user_id INT PRIMARY KEY,
    institution_id INT,
    study_id INT,
    start_date DATE,
    end_date DATE,
	attendance int,
	is_passed bit,
	FOREIGN KEY (institution_id) REFERENCES Internship_Institutions(institution_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (study_id) REFERENCES Studies(study_id)
);

alter table Users_Internships
add constraint users_internships_check check (end_date = DATEADD(DAY, 13, start_date));

alter table Users_Internships
add constraint users_internships_check_2 check (attendance between 0 and 100);

alter table Users_Internships
add constraint users_internships_check_3 check ((attendance >=80 and is_passed=1) or (attendance<80 and is_passed=0));

alter table Users_Internships
add constraint users_internships_check_4 check (YEAR(start_date)>=2020);


-- Tabela Internship_Location
CREATE TABLE Internship_Location (
    institution_id INT PRIMARY KEY,
	address_id INT,
    FOREIGN KEY (address_id) REFERENCES Addresses(address_id),
	FOREIGN KEY (institution_id) REFERENCES Internship_Institutions(institution_id)
);

--Tabela Internship_Institutions
CREATE TABLE Internship_Institutions (
	institution_id INT PRIMARY KEY,
	institution_name VARCHAR(255)
);

-- Tabela Translators
CREATE TABLE Translators (
	translator_id INT PRIMARY KEY,
	user_id INT,
	FOREIGN KEY (translator_id) REFERENCES Employees(employee_id)
);

-- Tabela Classes_Translators
CREATE TABLE Classes_Translators (
    class_id INT PRIMARY KEY,
    translator_id INT,
	FOREIGN KEY (translator_id) REFERENCES Translators(translator_id),
	FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);


-- Tabela Translators_Languages
CREATE TABLE Translators_Languages (
    translator_id INT,
    language_id INT,
	PRIMARY KEY (translator_id,language_id),
    FOREIGN KEY (language_id) REFERENCES Languages(language_id),
	FOREIGN KEY (translator_id) REFERENCES Translators(translator_id)
);


-- Tabela Webinars_Meeting_Translators
CREATE TABLE Webinars_Meeting_Translators (
    meeting_id INT PRIMARY KEY,
    translator_id INT,
    FOREIGN KEY (translator_id) REFERENCES Translators(translator_id)
);


-- Tabela User_Studies_Diplomas
CREATE TABLE User_Studies_Diplomas (
    user_id INT PRIMARY KEY,
    diploma_ready BIT,
    diploma_sent BIT
);

ALTER TABLE User_Studies_Diplomas
ADD study_id INT;

ALTER TABLE User_Studies_Diplomas
ADD CONSTRAINT FK_User_Studies_Diplomas_2
FOREIGN KEY (study_id) 
REFERENCES Studies(study_id);

ALTER TABLE User_Studies_Diplomas
ADD CONSTRAINT FK_User_Studies_Diplomas
FOREIGN KEY (user_id) 
REFERENCES Users(user_id);

alter table User_Studies_Diplomas
add constraint user_studies_diplomas_check check (diploma_ready=diploma_sent or (diploma_ready=1 and diploma_sent=0));

ALTER TABLE User_Studies_Diplomas ADD CONSTRAINT user_studies_diplomas_default_1 DEFAULT 0 FOR diploma_ready
ALTER TABLE User_Studies_Diplomas ADD CONSTRAINT user_studies_diplomas_default_2 DEFAULT 0 FOR diploma_sent

-- Tabela User_Studies
CREATE TABLE User_Studies (
    user_id INT,
    study_id INT,
	PRIMARY KEY (user_id,study_id),
    amount_paid MONEY,
    final_exam_passed BIT,
    FOREIGN KEY (study_id) REFERENCES Studies(study_id),
	FOREIGN KEY (user_id) REFERENCES Users(user_id),
	FOREIGN KEY (user_id) REFERENCES User_Studies_Diplomas(user_id)
);

alter table User_Studies
add constraint user_studies_check check (amount_paid>=99.99);


ALTER TABLE User_Studies ADD CONSTRAINT user_studies_default DEFAULT 0 FOR final_exam_passed

-- Tabela Courses_Users_Diplomas
CREATE TABLE Courses_Users_Diplomas (
    user_id INT PRIMARY KEY,
    diploma_ready BIT,
    diploma_sent BIT,
);

ALTER TABLE Courses_Users_Diplomas
ADD course_id INT;

ALTER TABLE Courses_Users_Diplomas
ADD CONSTRAINT FK_Courses_Users_Diplomas_2
FOREIGN KEY (course_id) 
REFERENCES Courses(course_id);

ALTER TABLE Courses_Users_Diplomas
ADD CONSTRAINT FK_Courses_Users_Diplomas
FOREIGN KEY (user_id) 
REFERENCES Users(user_id);

alter table Courses_Users_Diplomas
add constraint courses_users_diplomas_check check (diploma_ready=diploma_sent or (diploma_ready=1 and diploma_sent=0));

ALTER TABLE Courses_Users_Diplomas ADD CONSTRAINT courses_users_diplomas_default_1 DEFAULT 0 FOR diploma_ready
ALTER TABLE Courses_Users_Diplomas ADD CONSTRAINT courses_users_diplomas_default_2 DEFAULT 0 FOR diploma_sent

CREATE TABLE Courses_Calendar (
	course_id INT PRIMARY KEY,
	start_date DATE,
	end_date DATE,
	FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

alter table Courses_Calendar
add constraint courses_calendar_check check(start_date<end_date)

alter table Courses_Calendar
add constraint courses_calendar_check_1 check(YEAR(start_date)>=2020)

































