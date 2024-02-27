--Administrator Systemu:
--Wszystkie funkcje systemowe, w tym:

funcUsersOrdersNumber

funcUsersActivities

funcGetOrderValue

funcGetOrderDetailsByOrderID

funcGetValueOfOrdersOnDay

funcEmployeesNotFired

funcDiplomasNotReady

funcDiplomasReadyNotSent

funcEmployeesHiredAs

funcUserAndPhoneNumber

funcUserAndEmail

funcAttendanceAndPassForUsersInternships

funcEventsOnDay

funcCountEventsOnDay

PaidWebinars

funcModulesAndDescriptionsForCourses

funcExceptionsForUser

funcSearch

procAddCountry

procAddCity

procAddLanguage

procAddWebinar

procAddStudy

procAddCourse

procAddStudyMeeting

procAddOrder

procAddUserToStudy

procAddUserToCourse

procAddUserToStudyMeeting

procAddCourseAdvancedPaymentException

procAddStudiesFeetException

procAddUsersStudyMeetingsPaymentExceptions

procChangeCourseLimit

procChangeStudyLimit

procChangeStudyMeetingLimit

procConfirmStudyDiplomaReady

procConfirmStudyDiplomaSent

procConfirmCourseDiplomaReady

procConfirmCourseDiplomaSent

procConfirmOrdersSuccess

--Dost�p do wszystkich danych systemowych, wi�c do wszystkich tabel w systemie.

--Dost�p do widok�w: FinancialReport, DebtorsList, FutureEventsAttendance, PastEventsAttendance, AttendanceList, Webinars_Income, Courses_Income, Studies_Revenue_List.


-- Utworzenie roli Admin
CREATE ROLE Admin;

-- Nadanie uprawnie� dla roli Admin
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO Admin;
GRANT ALL ON ALL TABLES IN SCHEMA public TO Admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO Admin;
GRANT ALL ON ALL VIEWS IN SCHEMA public TO Admin;


--Administrator Biurowy:
--Brak bezpo�rednich uprawnie� do funkcji. 

procAddEmployee

procAddEmployeeType

procChangeCourseLimit

procChangeStudyLimit

funcMostlyOrdered

procChangeStudyMeetingLimit

procAddClassToStudy

procChangeWebinarMeetings

--Dost�p do widok�w: FinancialReport, FutureEventsAttendance, PastEventsAttendance, AttendanceList.
--Dost�p do informacji o salach
--Prawo do rezerwacji sal.
--Generowanie dyplom�w, wi�c dost�p do Courses_Users_Diplomas.
--Dodawanie pracownik�w biurowych, co oznacza dost�p do tabeli Employees.
--Zmiana limit�w kurs�w i studi�w, wi�c dost�p do Courses_Limits i Studies_Limits.

-- Utworzenie roli AdministratorBiurowy
CREATE ROLE AdministratorBiurowy;

-- Nadanie uprawnie� dla roli AdministratorBiurowy
GRANT EXECUTE ON FUNCTION procAddEmployee() TO AdministratorBiurowy;
GRANT EXECUTE ON FUNCTION procChangeWebinarMeetingsDatetime() to AdministratorBiurowy
GRANT EXECUTE ON FUNCTION procAddClassToStudy() TO AdministratorBiurowy
GRANT EXECUTE ON FUNCTION procAddEmployeeType() TO AdministratorBiurowy;
GRANT EXECUTE ON FUNCTION procChangeCourseLimit() TO AdministratorBiurowy;
GRANT EXECUTE ON FUNCTION funcMostlyOrdered() TO AdministratorBiurowy;
GRANT EXECUTE ON FUNCTION procChangeStudyLimit() TO AdministratorBiurowy;
GRANT EXECUTE ON FUNCTION procChangeStudyMeetingLimit() TO AdministratorBiurowy;
GRANT SELECT ON TABLE FinancialReport TO AdministratorBiurowy;
GRANT SELECT ON TABLE FutureEventsAttendance TO AdministratorBiurowy;
GRANT SELECT ON TABLE PastEventsAttendance TO AdministratorBiurowy;
GRANT SELECT ON TABLE AttendanceList TO AdministratorBiurowy;
GRANT SELECT ON TABLE RoomsInformation TO AdministratorBiurowy;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Employees TO AdministratorBiurowy;

-- Dodanie roli AdministratorBiurowy do u�ytkownika (np. 'user_name')
GRANT AdministratorBiurowy TO user_name


--Ksi�gowo��:
funcUsersOrdersNumber

funcGetOrderValue

funcGetOrderDetailsByOrderID

funcGetValueOfOrdersOnDay

PaidWebinars

funcExceptionsForUser

funcUsersStats

procChangeCourseLimit

procChangeStudyLimit

procChangeStudyMeetingLimit

procConfirmOrdersSuccess

procAddCourseAdvancedPaymentException

procAddStudiesFeetException

procAddUsersStudyMeetingsPaymentExceptions

funcMostlyOrdered

--Dost�p do widok�w: FinancialReport, DebtorsList, PastEventsAttendance, AttendanceList, Webinars_Income, Courses_Income, Studies_Revenue_List.
--Monitorowanie p�atno�ci i raporty, co oznacza dost�p do tabeli Payments_Details, Courses_Payments, Studies_Fee_Exceptions.
--Tworzenie listy d�u�nik�w, co oznacza dost�p do Courses_Users, Studies_Fee_Exceptions.
--Rozliczanie dochod�w, wi�c dost�p do Courses_Users, Studies_Users.

-- Utworzenie roli Ksiegowosc
CREATE ROLE Ksiegowosc;

-- Nadanie uprawnie� dla roli Ksiegowosc
GRANT EXECUTE ON FUNCTION funcMostlyOrdered() TO Ksiegowsc;
GRANT EXECUTE ON FUNCTION funcUsersOrdersNumber() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION funcGetOrderValue() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION funcGetOrderDetailsByOrderID() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION funcGetValueOfOrdersOnDay() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION PaidWebinars() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION funcExceptionsForUser() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION funcUsersStats() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION procChangeCourseLimit() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION procChangeStudyLimit() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION procChangeStudyMeetingLimit() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION procConfirmOrdersSuccess() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION procAddCourseAdvancedPaymentException() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION procAddStudiesFeetException() TO Ksiegowosc;
GRANT EXECUTE ON FUNCTION procAddUsersStudyMeetingsPaymentExceptions() TO Ksiegowosc;

-- Dost�p do widok�w
GRANT SELECT ON TABLE FinancialReport TO Ksiegowosc;
GRANT SELECT ON TABLE DebtorsList TO Ksiegowosc;
GRANT SELECT ON TABLE PastEventsAttendance TO Ksiegowosc;
GRANT SELECT ON TABLE AttendanceList TO Ksiegowosc;
GRANT SELECT ON TABLE Webinars_Income TO Ksiegowosc;
GRANT SELECT ON TABLE Courses_Income TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Revenue_List TO Ksiegowosc;

-- Monitorowanie p�atno�ci i raporty
GRANT SELECT ON TABLE Payments_Details TO Ksiegowosc;
GRANT SELECT ON TABLE Courses_Payments TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Fee_Exceptions TO Ksiegowosc;

-- Tworzenie listy d�u�nik�w
GRANT SELECT ON TABLE Courses_Users TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Fee_Exceptions TO Ksiegowosc;

-- Rozliczanie dochod�w
GRANT SELECT ON TABLE Courses_Users TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Users TO Ksiegowosc;

-- Dodanie roli Ksiegowosc do u�ytkownika (np. 'ksiegowy')
GRANT Ksiegowosc TO ksiegowy;


--Wyk�adowca:

funcUsersActivities

funcEventsOnDay

funcCountEventsOnDay

funcModulesAndDescriptionsForCourses

funcLecturersClassesAndWebinars

funcLecturersClassesAndWebinarsNumber

--Dost�p do widok�w: PastEventsAttendance, AttendanceList.
--Przypisany do prowadzenia zaj��, wi�c dost�p do odpowiednich tabel Webinars_Meetings, Courses_Users, Studies_Users + wszystkie FK
--Edytowanie informacji o swoich zaj�ciach, wi�c dost�p do odpowiednich tabel Webinars_Meetings, Courses_Users, Studies_Users  + wszystkie FK

-- Utworzenie roli Wykladowca
CREATE ROLE Wykladowca;

-- Nadanie uprawnie� dla roli Wykladowca
GRANT EXECUTE ON FUNCTION funcUsersActivities() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcEventsOnDay() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcCountEventsOnDay() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcModulesAndDescriptionsForCourses() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcLecturersClassesAndWebinars() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcLecturersClassesAndWebinarsNumber() TO Wykladowca

-- Dost�p do widok�w
GRANT SELECT ON TABLE PastEventsAttendance TO Wykladowca;
GRANT SELECT ON TABLE AttendanceList TO Wykladowca;

-- Przypisanie do prowadzenia zaj��
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Webinars_Meetings TO Wykladowca;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Courses_Users TO Wykladowca;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Studies_Users TO Wykladowca;

-- Edytowanie informacji o swoich zaj�ciach
GRANT UPDATE, INSERT ON TABLE Webinars_Meetings TO Wykladowca;
GRANT UPDATE, INSERT ON TABLE Courses_Users TO Wykladowca;
GRANT UPDATE, INSERT ON TABLE Studies_Users TO Wykladowca;



--Uczestnik:

funcUsersActivities

funcEventsOnDay

funcCountEventsOnDay

funcGetOrderDetailsByOrderID

funcAttendanceAndPassForUsersInternships

--Dost�p do widok�w: FutureEventsAttendance, PastEventsAttendance, AttendanceList.
--Zalogowany uczestnik powinien mie� dost�p do swojego konta, co oznacza dost�p do tabel Users, Courses_Users, Studies_Users.
--Niezalogowany uczestnik mo�e mie� dost�p do tabel Courses, Studies, Webinars do przegl�dania informacji.

-- Utworzenie roli Uczestnik
CREATE ROLE Uczestnik;

-- Nadanie uprawnie� dla roli Uczestnik
GRANT EXECUTE ON FUNCTION funcUsersActivities() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcEventsOnDay() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcCountEventsOnDay() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcGetOrderDetailsByOrderID() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcAttendanceAndPassForUsersInternships() TO Uczestnik;

-- Dost�p do widok�w
GRANT SELECT ON TABLE FutureEventsAttendance TO Uczestnik;
GRANT SELECT ON TABLE PastEventsAttendance TO Uczestnik;
GRANT SELECT ON TABLE AttendanceList TO Uczestnik;

-- Dost�p do informacji o u�ytkowniku
GRANT SELECT ON TABLE Users TO Uczestnik;
GRANT SELECT ON TABLE Courses_Users TO Uczestnik;
GRANT SELECT ON TABLE Studies_Users TO Uczestnik;

-- Dost�p do informacji o kursach, studiach i webinarach (dla niezalogowanych uczestnik�w)
GRANT SELECT ON TABLE Courses TO Uczestnik;
GRANT SELECT ON TABLE Studies TO Uczestnik;
GRANT SELECT ON TABLE Webinars TO Uczestnik;

-- Dodanie roli Uczestnik do u�ytkownika (np. 'uczestnik')
GRANT Uczestnik TO uczestnik;



--T�umacz:

funcUsersActivities

funcEventsOnDay

funcCountEventsOnDay

--Dost�p do widok�w: PastEventsAttendance, AttendanceList.
--T�umaczenie, wi�c dost�p do tabel Webinars_Meeting_Translators, Courses_Users, Studies_Users.

-- Utworzenie roli Tlumacz
CREATE ROLE Tlumacz;

-- Nadanie uprawnie� dla roli Tlumacz
GRANT EXECUTE ON FUNCTION funcUsersActivities() TO Tlumacz;
GRANT EXECUTE ON FUNCTION funcEventsOnDay() TO Tlumacz;
GRANT EXECUTE ON FUNCTION funcCountEventsOnDay() TO Tlumacz;

-- Dost�p do widok�w
GRANT SELECT ON TABLE PastEventsAttendance TO Tlumacz;
GRANT SELECT ON TABLE AttendanceList TO Tlumacz;

-- T�umaczenie
GRANT SELECT ON TABLE Webinars_Meeting_Translators TO Tlumacz;
GRANT SELECT ON TABLE Courses_Users TO Tlumacz;
GRANT SELECT ON TABLE Studies_Users TO Tlumacz;

-- Dodanie roli Tlumacz do u�ytkownika (np. 'tlumacz')
GRANT Tlumacz TO tlumacz;



--P�atnik:

funcGetOrderValue

funcGetOrderDetailsByOrderID

funcExceptionsForUser

procAddOrder

--Dost�p do widok�w: FinancialReport, PastEventsAttendance, AttendanceList, Webinars_Income, Courses_Income, Studies_Revenue_List.
--Dokonywanie p�atno�ci, co oznacza dost�p do tabel Payments_Details, Courses_Payments, Studies_Fee_Exceptions.

-- Utworzenie roli Platnik
CREATE ROLE Platnik;

-- Nadanie uprawnie� dla roli Platnik
GRANT EXECUTE ON FUNCTION funcGetOrderValue() TO Platnik;
GRANT EXECUTE ON FUNCTION funcGetOrderDetailsByOrderID() TO Platnik;
GRANT EXECUTE ON FUNCTION funcExceptionsForUser() TO Platnik;
GRANT EXECUTE ON FUNCTION procAddOrder() TO Platnik;

-- Dost�p do widok�w
GRANT SELECT ON TABLE FinancialReport TO Platnik;
GRANT SELECT ON TABLE PastEventsAttendance TO Platnik;
GRANT SELECT ON TABLE AttendanceList TO Platnik;
GRANT SELECT ON TABLE Webinars_Income TO Platnik;
GRANT SELECT ON TABLE Courses_Income TO Platnik;
GRANT SELECT ON TABLE Studies_Revenue_List TO Platnik;

-- Dokonywanie p�atno�ci
GRANT SELECT, INSERT ON TABLE Payments_Details TO Platnik;
GRANT SELECT, INSERT ON TABLE Courses_Payments TO Platnik;
GRANT SELECT, INSERT ON TABLE Studies_Fee_Exceptions TO Platnik;

-- Dodanie roli Platnik do u�ytkownika (np. 'platnik')
GRANT Platnik TO platnik;



--Dyrektor Szko�y:
--Wszystkie funkcje systemowe oraz 

procChangeStudyLimit

procChangeCourseLimit

procChangeStudyMeetingLimit

procAddClassToStudy

--Dost�p do widok�w: FinancialReport, PastEventsAttendance, AttendanceList.
--Decydowanie o wyj�tkach od zasad p�atno�ci, co oznacza dost�p do Courses_Advanced_Payment_Exceptions, Studies_Fee_Exceptions.
--Monitorowanie sytuacji finansowej, wi�c dost�p do tabel Payments_Details, Courses_Users, Studies_Users.

-- Utworzenie roli DyrektorSzkoly
CREATE ROLE DyrektorSzkoly;

-- Nadanie uprawnie� dla roli DyrektorSzkoly
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO DyrektorSzkoly;
GRANT ALL ON ALL TABLES IN SCHEMA public TO DyrektorSzkoly;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO DyrektorSzkoly;
GRANT ALL ON ALL VIEWS IN SCHEMA public TO DyrektorSzkoly;

-- Dodanie roli DyrektorSzkoly do u�ytkownika (np. 'dyrektor')
GRANT DyrektorSzkoly TO dyrektor;



--Opiekun Studi�w:

funcUsersActivities

funcDiplomasNotReady

funcDiplomasReadyNotSent

procChangeStudyLimit

procChangeCourseLimit

procChangeStudyMeetingLimit

procChangeStudyMeetingLimit

procAddUserToStudy

procAddUserToCourse

procAddUserToStudyMeeting

procConfirmStudyDiplomaSent

procConfirmCourseDiplomaSent

procAddModuleToCourse

--Dost�p do widok�w: FutureEventsAttendance, PastEventsAttendance, AttendanceList.
--Koordynacja przebiegu spotka�, wi�c dost�p do tabel Study_Meetings, Study_Meetings_Calendar, Study_Meetings_Classes.
--Zmiana limit�w kurs�w, studi�w, i spotka�, wi�c dost�p do Courses_Limits, Studies_Limits, Study_Meetings.

-- Utworzenie roli OpiekunStudiow
CREATE ROLE OpiekunStudiow;

-- Nadanie uprawnie� dla roli OpiekunStudiow
GRANT EXECUTE ON FUNCTION funcUsersActivities() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION funcDiplomasNotReady() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION funcDiplomasReadyNotSent() TO OpiekunStudiow;
GRANT EXECUTE ON FUCTION procAddModuleToCourse() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procChangeStudyLimit() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procChangeCourseLimit() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procChangeStudyMeetingLimit() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procAddUserToStudy() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procAddUserToCourse() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procAddUserToStudyMeeting() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procConfirmStudyDiplomaSent() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procConfirmCourseDiplomaSent() TO OpiekunStudiow;

-- Dost�p do widok�w
GRANT SELECT ON TABLE FutureEventsAttendance TO OpiekunStudiow;
GRANT SELECT ON TABLE PastEventsAttendance TO OpiekunStudiow;
GRANT SELECT ON TABLE AttendanceList TO OpiekunStudiow;

-- Koordynacja przebiegu spotka�
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Study_Meetings TO OpiekunStudiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Study_Meetings_Calendar TO OpiekunStudiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Study_Meetings_Classes TO OpiekunStudiow;

-- Zmiana limit�w kurs�w, studi�w i spotka�
GRANT EXECUTE ON FUNCTION procChangeCourseLimit() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procChangeStudyLimit() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procChangeStudyMeetingLimit() TO OpiekunStudiow;

-- Dodanie roli OpiekunStudiow do u�ytkownika (np. 'opiekun_studiow')
GRANT OpiekunStudiow TO opiekun_studiow;
