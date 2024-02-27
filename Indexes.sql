-- Users (email, login)
CREATE INDEX idx_users_email ON Users (email);
CREATE INDEX idx_users_login ON Users (login);

-- Users_Phone_Number (phone)
CREATE INDEX idx_users_phone ON Users_Phone_Number (phone);

--Employees (phone, email, login)
CREATE INDEX idx_employees_phone ON Employees (phone);
CREATE INDEX idx_employees_email ON Employees (email);
CREATE INDEX idx_employees_login ON Employees (login);

--Employees_Types (type_name)
CREATE INDEX idx_employees_types_name ON Employees_Types (type_name);

--Employees_Roles (employee_type_id, employee_id)
CREATE INDEX idx_employees_roles_employee_type_id ON Employees_Roles (employee_type_id);
CREATE INDEX idx_employees_roles_employee_id ON Employees_Roles (employee_id);

--Addresses (city_id)
CREATE INDEX idx_addresses_city_id ON Addresses (city_id);

--Users_Address (address_id)
CREATE INDEX idx_users_address_address_id ON Users_Address (address_id);

--Countries (country_name)
CREATE INDEX idx_countries_country_name ON Countries (country_name);

--Cities (country_id, city_name)
CREATE INDEX idx_cities_country_id ON Cities (country_id);
CREATE INDEX idx_cities_city_name ON Cities (city_name);

--Classrooms (classroom_id)
CREATE INDEX idx_classrooms_classroom_id ON Classrooms (classroom_id);

--Lecture_Classrooms (building_id, classroom_number)
CREATE INDEX idx_lecture_classrooms_building_id ON Lecture_Classrooms (building_id);
CREATE INDEX idx_lecture_classrooms_classroom_number ON Lecture_Classrooms (classroom_number);

--Classes (lecturer_id)
CREATE INDEX idx_classes_lecturer_id ON Classes (lecturer_id);

--Studies (title)
CREATE INDEX idx_studies_title ON Studies (title);

--Webinars (title)
CREATE INDEX idx_webinars_title ON Webinars (title);

--Webinars_Users (user_id, webinar_id)
CREATE INDEX idx_webinars_users_user_id ON Webinars_Users (user_id);
CREATE INDEX idx_webinars_users_webinar_id ON Webinars_Users (webinar_id);

--Webinars_Prices (webinar_id)
CREATE INDEX idx_webinars_prices_webinar_id ON Webinars_Prices (webinar_id);

--Webinars_Meetings (webinar_id)
CREATE INDEX idx_webinars_meetings_webinar_id ON Webinars_Meetings (webinar_id);

--Webinars_Meetings_Calendar (webinar_id)
CREATE INDEX idx_webinars_meetings_calendar_webinar_id ON Webinars_Meetings_Calendar (webinar_id);

--Courses (title)
CREATE INDEX idx_courses_title ON Courses (title);

--Courses_Users (user_id, course_id)
CREATE INDEX idx_courses_users_user_id ON Courses_Users (user_id);
CREATE INDEX idx_courses_users_course_id ON Courses_Users (course_id);

--Modules (course_id)
CREATE INDEX idx_modules_course_id ON Modules (course_id);

--Modules_Classes (module_id, class_id)
CREATE INDEX idx_modules_classes_module_id ON Modules_Classes (module_id);
CREATE INDEX idx_modules_classes_class_id ON Modules_Classes (class_id);

--Courses_Advanced_Payment_Exceptions (user_id, course_id)
CREATE INDEX idx_courses_advanced_payment_exceptions_user_id ON Courses_Advanced_Payment_Exceptions (user_id);
CREATE INDEX idx_courses_advanced_payment_exceptions_course_id ON Courses_Advanced_Payment_Exceptions (course_id);

--Courses_Limits (course_id)
CREATE INDEX idx_courses_limits_course_id ON Courses_Limits (course_id);

--Courses_Payments (user_id, course_id)
CREATE INDEX idx_courses_payments_user_id ON Courses_Payments (user_id);
CREATE INDEX idx_courses_payments_course_id ON Courses_Payments (course_id);

--Courses_Users_Diplomas (user_id)
CREATE INDEX idx_courses_users_diplomas_user_id ON Courses_Users_Diplomas (user_id);

--User_Studies (user_id, study_id)
CREATE INDEX idx_user_studies_user_id ON User_Studies (user_id);
CREATE INDEX idx_user_studies_study_id ON User_Studies (study_id);

--Studies_Fee_Exceptions (user_id, study_id)
CREATE INDEX idx_studies_fee_exceptions_user_id ON Studies_Fee_Exceptions (user_id);
CREATE INDEX idx_studies_fee_exceptions_study_id ON Studies_Fee_Exceptions (study_id);
