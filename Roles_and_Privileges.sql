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

--Dostêp do wszystkich danych systemowych, wiêc do wszystkich tabel w systemie.

--Dostêp do widoków: FinancialReport, DebtorsList, FutureEventsAttendance, PastEventsAttendance, AttendanceList, Webinars_Income, Courses_Income, Studies_Revenue_List.


-- Utworzenie roli Admin
CREATE ROLE Admin;

-- Nadanie uprawnieñ dla roli Admin
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO Admin;
GRANT ALL ON ALL TABLES IN SCHEMA public TO Admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO Admin;
GRANT ALL ON ALL VIEWS IN SCHEMA public TO Admin;


--Administrator Biurowy:
--Brak bezpoœrednich uprawnieñ do funkcji. 

procAddEmployee

procAddEmployeeType

procChangeCourseLimit

procChangeStudyLimit

funcMostlyOrdered

procChangeStudyMeetingLimit

procAddClassToStudy

procChangeWebinarMeetings

--Dostêp do widoków: FinancialReport, FutureEventsAttendance, PastEventsAttendance, AttendanceList.
--Dostêp do informacji o salach
--Prawo do rezerwacji sal.
--Generowanie dyplomów, wiêc dostêp do Courses_Users_Diplomas.
--Dodawanie pracowników biurowych, co oznacza dostêp do tabeli Employees.
--Zmiana limitów kursów i studiów, wiêc dostêp do Courses_Limits i Studies_Limits.

-- Utworzenie roli AdministratorBiurowy
CREATE ROLE AdministratorBiurowy;

-- Nadanie uprawnieñ dla roli AdministratorBiurowy
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

-- Dodanie roli AdministratorBiurowy do u¿ytkownika (np. 'user_name')
GRANT AdministratorBiurowy TO user_name


--Ksiêgowoœæ:
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

--Dostêp do widoków: FinancialReport, DebtorsList, PastEventsAttendance, AttendanceList, Webinars_Income, Courses_Income, Studies_Revenue_List.
--Monitorowanie p³atnoœci i raporty, co oznacza dostêp do tabeli Payments_Details, Courses_Payments, Studies_Fee_Exceptions.
--Tworzenie listy d³u¿ników, co oznacza dostêp do Courses_Users, Studies_Fee_Exceptions.
--Rozliczanie dochodów, wiêc dostêp do Courses_Users, Studies_Users.

-- Utworzenie roli Ksiegowosc
CREATE ROLE Ksiegowosc;

-- Nadanie uprawnieñ dla roli Ksiegowosc
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

-- Dostêp do widoków
GRANT SELECT ON TABLE FinancialReport TO Ksiegowosc;
GRANT SELECT ON TABLE DebtorsList TO Ksiegowosc;
GRANT SELECT ON TABLE PastEventsAttendance TO Ksiegowosc;
GRANT SELECT ON TABLE AttendanceList TO Ksiegowosc;
GRANT SELECT ON TABLE Webinars_Income TO Ksiegowosc;
GRANT SELECT ON TABLE Courses_Income TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Revenue_List TO Ksiegowosc;

-- Monitorowanie p³atnoœci i raporty
GRANT SELECT ON TABLE Payments_Details TO Ksiegowosc;
GRANT SELECT ON TABLE Courses_Payments TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Fee_Exceptions TO Ksiegowosc;

-- Tworzenie listy d³u¿ników
GRANT SELECT ON TABLE Courses_Users TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Fee_Exceptions TO Ksiegowosc;

-- Rozliczanie dochodów
GRANT SELECT ON TABLE Courses_Users TO Ksiegowosc;
GRANT SELECT ON TABLE Studies_Users TO Ksiegowosc;

-- Dodanie roli Ksiegowosc do u¿ytkownika (np. 'ksiegowy')
GRANT Ksiegowosc TO ksiegowy;


--Wyk³adowca:

funcUsersActivities

funcEventsOnDay

funcCountEventsOnDay

funcModulesAndDescriptionsForCourses

funcLecturersClassesAndWebinars

funcLecturersClassesAndWebinarsNumber

--Dostêp do widoków: PastEventsAttendance, AttendanceList.
--Przypisany do prowadzenia zajêæ, wiêc dostêp do odpowiednich tabel Webinars_Meetings, Courses_Users, Studies_Users + wszystkie FK
--Edytowanie informacji o swoich zajêciach, wiêc dostêp do odpowiednich tabel Webinars_Meetings, Courses_Users, Studies_Users  + wszystkie FK

-- Utworzenie roli Wykladowca
CREATE ROLE Wykladowca;

-- Nadanie uprawnieñ dla roli Wykladowca
GRANT EXECUTE ON FUNCTION funcUsersActivities() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcEventsOnDay() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcCountEventsOnDay() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcModulesAndDescriptionsForCourses() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcLecturersClassesAndWebinars() TO Wykladowca;
GRANT EXECUTE ON FUNCTION funcLecturersClassesAndWebinarsNumber() TO Wykladowca

-- Dostêp do widoków
GRANT SELECT ON TABLE PastEventsAttendance TO Wykladowca;
GRANT SELECT ON TABLE AttendanceList TO Wykladowca;

-- Przypisanie do prowadzenia zajêæ
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Webinars_Meetings TO Wykladowca;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Courses_Users TO Wykladowca;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Studies_Users TO Wykladowca;

-- Edytowanie informacji o swoich zajêciach
GRANT UPDATE, INSERT ON TABLE Webinars_Meetings TO Wykladowca;
GRANT UPDATE, INSERT ON TABLE Courses_Users TO Wykladowca;
GRANT UPDATE, INSERT ON TABLE Studies_Users TO Wykladowca;



--Uczestnik:

funcUsersActivities

funcEventsOnDay

funcCountEventsOnDay

funcGetOrderDetailsByOrderID

funcAttendanceAndPassForUsersInternships

--Dostêp do widoków: FutureEventsAttendance, PastEventsAttendance, AttendanceList.
--Zalogowany uczestnik powinien mieæ dostêp do swojego konta, co oznacza dostêp do tabel Users, Courses_Users, Studies_Users.
--Niezalogowany uczestnik mo¿e mieæ dostêp do tabel Courses, Studies, Webinars do przegl¹dania informacji.

-- Utworzenie roli Uczestnik
CREATE ROLE Uczestnik;

-- Nadanie uprawnieñ dla roli Uczestnik
GRANT EXECUTE ON FUNCTION funcUsersActivities() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcEventsOnDay() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcCountEventsOnDay() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcGetOrderDetailsByOrderID() TO Uczestnik;
GRANT EXECUTE ON FUNCTION funcAttendanceAndPassForUsersInternships() TO Uczestnik;

-- Dostêp do widoków
GRANT SELECT ON TABLE FutureEventsAttendance TO Uczestnik;
GRANT SELECT ON TABLE PastEventsAttendance TO Uczestnik;
GRANT SELECT ON TABLE AttendanceList TO Uczestnik;

-- Dostêp do informacji o u¿ytkowniku
GRANT SELECT ON TABLE Users TO Uczestnik;
GRANT SELECT ON TABLE Courses_Users TO Uczestnik;
GRANT SELECT ON TABLE Studies_Users TO Uczestnik;

-- Dostêp do informacji o kursach, studiach i webinarach (dla niezalogowanych uczestników)
GRANT SELECT ON TABLE Courses TO Uczestnik;
GRANT SELECT ON TABLE Studies TO Uczestnik;
GRANT SELECT ON TABLE Webinars TO Uczestnik;

-- Dodanie roli Uczestnik do u¿ytkownika (np. 'uczestnik')
GRANT Uczestnik TO uczestnik;



--T³umacz:

funcUsersActivities

funcEventsOnDay

funcCountEventsOnDay

--Dostêp do widoków: PastEventsAttendance, AttendanceList.
--T³umaczenie, wiêc dostêp do tabel Webinars_Meeting_Translators, Courses_Users, Studies_Users.

-- Utworzenie roli Tlumacz
CREATE ROLE Tlumacz;

-- Nadanie uprawnieñ dla roli Tlumacz
GRANT EXECUTE ON FUNCTION funcUsersActivities() TO Tlumacz;
GRANT EXECUTE ON FUNCTION funcEventsOnDay() TO Tlumacz;
GRANT EXECUTE ON FUNCTION funcCountEventsOnDay() TO Tlumacz;

-- Dostêp do widoków
GRANT SELECT ON TABLE PastEventsAttendance TO Tlumacz;
GRANT SELECT ON TABLE AttendanceList TO Tlumacz;

-- T³umaczenie
GRANT SELECT ON TABLE Webinars_Meeting_Translators TO Tlumacz;
GRANT SELECT ON TABLE Courses_Users TO Tlumacz;
GRANT SELECT ON TABLE Studies_Users TO Tlumacz;

-- Dodanie roli Tlumacz do u¿ytkownika (np. 'tlumacz')
GRANT Tlumacz TO tlumacz;



--P³atnik:

funcGetOrderValue

funcGetOrderDetailsByOrderID

funcExceptionsForUser

procAddOrder

--Dostêp do widoków: FinancialReport, PastEventsAttendance, AttendanceList, Webinars_Income, Courses_Income, Studies_Revenue_List.
--Dokonywanie p³atnoœci, co oznacza dostêp do tabel Payments_Details, Courses_Payments, Studies_Fee_Exceptions.

-- Utworzenie roli Platnik
CREATE ROLE Platnik;

-- Nadanie uprawnieñ dla roli Platnik
GRANT EXECUTE ON FUNCTION funcGetOrderValue() TO Platnik;
GRANT EXECUTE ON FUNCTION funcGetOrderDetailsByOrderID() TO Platnik;
GRANT EXECUTE ON FUNCTION funcExceptionsForUser() TO Platnik;
GRANT EXECUTE ON FUNCTION procAddOrder() TO Platnik;

-- Dostêp do widoków
GRANT SELECT ON TABLE FinancialReport TO Platnik;
GRANT SELECT ON TABLE PastEventsAttendance TO Platnik;
GRANT SELECT ON TABLE AttendanceList TO Platnik;
GRANT SELECT ON TABLE Webinars_Income TO Platnik;
GRANT SELECT ON TABLE Courses_Income TO Platnik;
GRANT SELECT ON TABLE Studies_Revenue_List TO Platnik;

-- Dokonywanie p³atnoœci
GRANT SELECT, INSERT ON TABLE Payments_Details TO Platnik;
GRANT SELECT, INSERT ON TABLE Courses_Payments TO Platnik;
GRANT SELECT, INSERT ON TABLE Studies_Fee_Exceptions TO Platnik;

-- Dodanie roli Platnik do u¿ytkownika (np. 'platnik')
GRANT Platnik TO platnik;



--Dyrektor Szko³y:
--Wszystkie funkcje systemowe oraz 

procChangeStudyLimit

procChangeCourseLimit

procChangeStudyMeetingLimit

procAddClassToStudy

--Dostêp do widoków: FinancialReport, PastEventsAttendance, AttendanceList.
--Decydowanie o wyj¹tkach od zasad p³atnoœci, co oznacza dostêp do Courses_Advanced_Payment_Exceptions, Studies_Fee_Exceptions.
--Monitorowanie sytuacji finansowej, wiêc dostêp do tabel Payments_Details, Courses_Users, Studies_Users.

-- Utworzenie roli DyrektorSzkoly
CREATE ROLE DyrektorSzkoly;

-- Nadanie uprawnieñ dla roli DyrektorSzkoly
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO DyrektorSzkoly;
GRANT ALL ON ALL TABLES IN SCHEMA public TO DyrektorSzkoly;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO DyrektorSzkoly;
GRANT ALL ON ALL VIEWS IN SCHEMA public TO DyrektorSzkoly;

-- Dodanie roli DyrektorSzkoly do u¿ytkownika (np. 'dyrektor')
GRANT DyrektorSzkoly TO dyrektor;



--Opiekun Studiów:

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

--Dostêp do widoków: FutureEventsAttendance, PastEventsAttendance, AttendanceList.
--Koordynacja przebiegu spotkañ, wiêc dostêp do tabel Study_Meetings, Study_Meetings_Calendar, Study_Meetings_Classes.
--Zmiana limitów kursów, studiów, i spotkañ, wiêc dostêp do Courses_Limits, Studies_Limits, Study_Meetings.

-- Utworzenie roli OpiekunStudiow
CREATE ROLE OpiekunStudiow;

-- Nadanie uprawnieñ dla roli OpiekunStudiow
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

-- Dostêp do widoków
GRANT SELECT ON TABLE FutureEventsAttendance TO OpiekunStudiow;
GRANT SELECT ON TABLE PastEventsAttendance TO OpiekunStudiow;
GRANT SELECT ON TABLE AttendanceList TO OpiekunStudiow;

-- Koordynacja przebiegu spotkañ
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Study_Meetings TO OpiekunStudiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Study_Meetings_Calendar TO OpiekunStudiow;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Study_Meetings_Classes TO OpiekunStudiow;

-- Zmiana limitów kursów, studiów i spotkañ
GRANT EXECUTE ON FUNCTION procChangeCourseLimit() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procChangeStudyLimit() TO OpiekunStudiow;
GRANT EXECUTE ON FUNCTION procChangeStudyMeetingLimit() TO OpiekunStudiow;

-- Dodanie roli OpiekunStudiow do u¿ytkownika (np. 'opiekun_studiow')
GRANT OpiekunStudiow TO opiekun_studiow;
