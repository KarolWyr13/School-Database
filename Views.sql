--Raport finansowy
-- CREATE VIEW FinancialReport AS
SELECT 'Course' AS type, c.course_id, c.title, COALESCE(SUM(cu.amount_paid), 0) AS total_revenue
FROM Courses c
LEFT JOIN Courses_Users cu ON c.course_id = cu.course_id
GROUP BY c.course_id, c.title

UNION

SELECT 'Study' AS type, s.study_id, s.title, COALESCE(SUM(us.amount_paid), 0) AS total_revenue
FROM Studies s
LEFT JOIN User_Studies us ON s.study_id = us.study_id
GROUP BY s.study_id, s.title

UNION

SELECT 'Webinar' AS type, w.webinar_id, w.title, COALESCE(SUM(Prices.price), 0) AS total_revenue
FROM Webinars w
LEFT JOIN Webinars_Prices AS Prices ON w.webinar_id = Prices.webinar_id
GROUP BY w.webinar_id, w.title;


-- Zapisy na przysz³e wydarzenia 
-- CREATE VIEW FutureEventsAttendance AS
SELECT 'Course' AS type, c.course_id, c.title, COUNT(ucl.user_id) AS attendees_count, cl.is_online
FROM Courses c
LEFT JOIN Classes cl ON c.course_id = cl.class_id
LEFT JOIN User_Classes ucl ON cl.class_id = ucl.class_id
WHERE cl.start_time > convert(time, getdate())
GROUP BY c.course_id, c.title, cl.is_online

UNION

SELECT 'Study' AS type, s.study_id, s.title, COUNT(us.user_id) AS attendees_count, 0 AS is_online
FROM Studies s
LEFT JOIN User_Studies us ON s.study_id = us.study_id
JOIN Study_Meetings on s.study_id = Study_Meetings.study_id
JOIN Study_Meetings_Calendar as SMC on Study_Meetings.study_meeting_id = SMC.study_meeting_id
WHERE SMC.start_date > getdate()
GROUP BY s.study_id, s.title

UNION

SELECT 'Webinar' AS type, w.webinar_id, w.title, COUNT(wu.user_id) AS attendees_count, 1 AS is_online
FROM Webinars w
LEFT JOIN Webinars_Users wu ON w.webinar_id = wu.webinar_id
JOIN Webinars_Meetings as wm on w.webinar_id = wm.webinar_id
JOIN Webinars_Meetings_Calendar as WMC on wm.meeting_id = WMC.meeting_id
WHERE WMC.live_start > getdate()
GROUP BY w.webinar_id, w.title;


--Zapisy na przysz³e kursy
-- CREATE VIEW FutureCoursesAttendance AS
SELECT 'Course' AS type, c.course_id, c.title, COUNT(ucl.user_id) AS attendees_count, cl.is_online
FROM Courses c
LEFT JOIN Classes cl ON c.course_id = cl.class_id
LEFT JOIN User_Classes ucl ON cl.class_id = ucl.class_id
WHERE cl.start_time > convert(time, getdate())
GROUP BY c.course_id, c.title, cl.is_online




--Zapisy na przysz³e Studia
-- CREATE VIEW FutureStudiesAttendance AS
SELECT 'Study' AS type, s.study_id, s.title, COUNT(us.user_id) AS attendees_count, 0 AS is_online
FROM Studies s
LEFT JOIN User_Studies us ON s.study_id = us.study_id
GROUP BY s.study_id, s.title


--Zapisy na przysz³e webinary
-- CREATE VIEW FutureWebinarsAttendance AS
SELECT 'Webinar' AS type, w.webinar_id, w.title, COUNT(wu.user_id) AS attendees_count, 1 AS is_online
FROM Webinars w
LEFT JOIN Webinars_Users wu ON w.webinar_id = wu.webinar_id
JOIN Webinars_Meetings as wm on w.webinar_id = wm.webinar_id
JOIN Webinars_Meetings_Calendar as WMC on wm.meeting_id = WMC.meeting_id
WHERE WMC.live_start > getdate()
GROUP BY w.webinar_id, w.title;




--Zapisy na poprzednie wydarzenia
-- CREATE VIEW PastEventsAttendance AS
SELECT 'Course' AS type, c.course_id, c.title, COUNT(ucl.user_id) AS attendees_count, cl.is_online
FROM Courses c
LEFT JOIN Classes cl ON c.course_id = cl.class_id
LEFT JOIN User_Classes ucl ON cl.class_id = ucl.class_id
WHERE cl.end_time < convert(time, getdate())
GROUP BY c.course_id, c.title, cl.is_online

UNION

SELECT 'Study' AS type, s.study_id, s.title, COUNT(us.user_id) AS attendees_count, 0 AS is_online
FROM Studies s
LEFT JOIN User_Studies us ON s.study_id = us.study_id
GROUP BY s.study_id, s.title

UNION

SELECT 'Webinar' AS type, w.webinar_id, w.title, COUNT(wu.user_id) AS attendees_count, 1 AS is_online
FROM Webinars w
LEFT JOIN Webinars_Users wu ON w.webinar_id = wu.webinar_id
GROUP BY w.webinar_id, w.title;


--Obecnoœæ na poszczególnych klasach
-- CREATE VIEW AttendanceList AS
SELECT cl.class_id, u.user_id, u.first_name, u.last_name, COALESCE(uc.attendance, 0) AS attendance_status
FROM Classes cl
JOIN User_Classes uc ON cl.class_id = uc.class_id
JOIN Users u ON uc.user_id = u.user_id
order by cl.class_id;



--Bilokacja dla usera
-- CREATE VIEW OverlappingUsersWebinars AS
SELECT
   WUA1.user_id,
   WUA1.webinar_id AS webinar_id_1,
   WUA2.webinar_id AS webinar_id_2
FROM Webinars_Users WUA1
JOIN Webinars_Users WUA2 ON WUA1.user_id = WUA2.user_id
   AND WUA1.webinar_id < WUA2.webinar_id
JOIN Webinars_Meetings_Calendar WMC1 ON WUA1.webinar_id = WMC1.meeting_id
JOIN Webinars_Meetings_Calendar WMC2 ON WUA2.webinar_id = WMC2.meeting_id
WHERE WMC1.live_end > WMC2.live_start
   AND WMC1.live_start < WMC2.live_end;


--Bilokacja ogólnie - jakie zajêcia s¹ ogólnie w tym samym czasie, nie dal usera tylko w kalendarzu
-- CREATE VIEW OverlappingWebinars AS
SELECT
   W1.webinar_id AS webinar1_id,
   Web1.title AS webinar1_title,
   W2.webinar_id AS webinar2_id,
   Web2.title AS webinar2_title
FROM Webinars_Meetings_Calendar W1C
JOIN Webinars_Meetings_Calendar W2C ON W1C.meeting_id < W2C.meeting_id -- Unikamy powtórzeñ
JOIN Webinars_Meetings W1 ON W1C.meeting_id = W1.meeting_id
JOIN Webinars_Meetings W2 ON W2C.meeting_id = W2.meeting_id
join Webinars as web1 on W1.webinar_id = web1.webinar_id
join Webinars as web2 on W2.webinar_id = web2.webinar_id
WHERE NOT (W1C.live_end < W2C.live_start OR W1C.live_start > W2C.live_end);



--Przychody z kursów
-- CREATE VIEW Courses_Revenue_List AS
SELECT 'Course' AS type, c.course_id, c.title, COALESCE(SUM(cu.amount_paid), 0) AS total_revenue
FROM Courses c
JOIN Courses_Users cu ON c.course_id = cu.course_id
GROUP BY c.course_id, c.title



--Przychody ze studiów
-- CREATE VIEW Studies_Revenue_List AS
SELECT 'Study' AS type, s.study_id, s.title, COALESCE(SUM(us.amount_paid), 0) AS total_revenue
FROM Studies s
LEFT JOIN User_Studies us ON s.study_id = us.study_id
GROUP BY s.study_id, s.title




--Przychody z poszczególnych webinarów
-- CREATE VIEW Webinars_Revenue_List AS
SELECT 'Webinar' AS type, w.webinar_id, w.title, COALESCE(SUM(Prices.price), 0) AS total_revenue
FROM Webinars w
LEFT JOIN Webinars_Prices AS Prices ON w.webinar_id = Prices.webinar_id
join Users_Webinars_Exceptions UWE on w.webinar_id = UWE.webinar_id
GROUP BY w.webinar_id, w.title;




-- CREATE VIEW WebinarsIncome AS
SELECT
   SUM(WOD.unit_price) AS Income,
   Orders.order_id,
   w.title AS WebinarName
FROM Orders
INNER JOIN Webinars_Order_Details as WOD on Orders.order_id = WOD.order_id
INNER JOIN Webinars as W on WOD.webinar_id = W.webinar_id
INNER JOIN Payments_Details AS PD ON PD.order_id = Orders.order_id
WHERE PD.payment_succeed = 1
GROUP BY Orders.order_id, w.title
order by Orders.order_id


--Lista d³u¿ników dla webinarów
-- CREATE VIEW WebinarDebtors AS
SELECT O.user_id, u.first_name, u.last_name, w.title, wmc.live_end
FROM Orders as O
JOIN Users as u on u.user_id = O.user_id
JOIN Webinars_Order_Details as WOD on O.order_id = WOD.order_id
JOIN Webinars w on w.webinar_id = WOD.webinar_id
JOIN Webinars_Meetings as WM on w.webinar_id = WM.webinar_id
JOIN Webinars_Meetings_Calendar as WMC on WM.meeting_id = WMC.meeting_id
WHERE wmc.live_end < getDate()
GROUP BY O.user_id, u.first_name, u.last_name, w.title, wmc.live_end


--Lista d³u¿ników dla kursów
-- CREATE VIEW CourseDebtors AS
SELECT U.user_id,
      U.first_name,
      U.last_name,
      C.course_id,
      C.title AS COURSE
FROM Users U
        JOIN Orders O ON U.user_id = O.user_id
        JOIN Courses_Order_Details CO ON O.order_id = CO.order_id
        JOIN Courses C ON CO.course_id = C.course_id
        JOIN Courses_Payments AS CP on cp.course_id = c.course_id
        Join Payments_Details AS PD on O.order_id = PD.order_id
        LEFT JOIN Courses_Users CU ON CO.course_id = CU.course_id AND U.user_id = CU.user_id
        JOIN Courses_Calendar CC on C.course_id = CC.course_id
WHERE PD.payment_date<GETDATE() AND CC.end_date < getDate()
GROUP BY U.user_id, U.first_name, U.last_name, C.course_id, C.title


--Lista d³u¿ników dla studiów
-- CREATE VIEW StudiesDebtors AS
SELECT U.user_id,
      U.first_name,
      U.last_name,
      S.study_id,
      s.title AS Faculty
FROM Users U
        JOIN Orders O ON U.user_id = O.user_id
        JOIN Studies_Order_Details AS SOD ON O.order_id = SOD.order_id
        JOIN Studies S on SOD.study_id = S.study_id
        JOIN Studies_Fee_Exceptions AS SFE ON S.study_id = SFE.study_id
        Join Payments_Details AS PD on O.order_id = PD.order_id
        LEFT JOIN User_Studies US ON S.study_id = US.study_id
        JOIN Study_Meetings_Calendar SC ON SC.study_id = S.study_id
WHERE PD.payment_date<GETDATE() AND SFE.pay_due<GETDATE()
GROUP BY U.user_id, U.first_name, U.last_name, S.study_id, S.title



--Lista kierunków studiów wraz z list¹ przedmiotów
-- CREATE VIEW StudySubjects AS
SELECT
   s.title as Faculty,
   STRING_AGG(cl.name, ', ') AS Subjects
FROM Studies s
INNER JOIN Classes cl ON s.study_id = cl.study_id
GROUP BY s.title;


--Lista kursów wraz z rozpisk¹ modu³ów i datami kiedy siê odbywaj¹
-- CREATE VIEW CoursesModules AS
select c.course_id, c.title, m.module_id, m.module_name, cc.start_date as CourseStartDate, cc.end_date as CourseEndDate
from Courses C
join Modules as m on C.course_id = m.course_id
join Courses_Calendar CC on C.course_id = CC.course_id
JOIN Modules_Classes as MC on m.module_id = MC.module_id
JOIN Classes as cl on MC.class_id = cl.class_id



--Lista prowadz¹cych webinary
-- CREATE VIEW WebinarsLecturers AS
SELECT wm.lecturer_id, e.first_name, e.last_name, w.title
from Webinars_Meetings wm
JOIN Webinars_Meetings_Calendar as WMC on wm.meeting_id = WMC.meeting_id
inner join Webinars as w on wm.webinar_id = w.webinar_id
inner join Employees as e on wm.lecturer_id = e.employee_id
group by wm.lecturer_id, e.first_name, e.last_name, w.title


--Lista prowadz¹cych modu³y
-- CREATE VIEW ModulesLecturers AS
SELECT cl.lecturer_id, e.first_name, e.last_name, c.title
from Modules_Classes mc
JOIN Modules as m on mc.module_id = m.module_id
join Classes Cl on Cl.class_id = mc.class_id
join Courses C on C.course_id = m.course_id
inner join Employees as e on cl.lecturer_id = e.employee_id
group by cl.lecturer_id, e.first_name, e.last_name, c.title


--Lista prowadz¹cych spotkania studyjne
-- CREATE VIEW StudyMeetingLecturers AS
SELECT cl.lecturer_id, e.first_name, e.last_name, s.title as Faculty
from Classes as cl
inner join Studies as s on s.study_id = cl.study_id
inner join Employees as e on cl.lecturer_id = e.employee_id
group by cl.lecturer_id, e.first_name, e.last_name, s.title


--Webinary na jakie zapisana jest konkretna osoba
-- CREATE VIEW WebinarsPaxPayments AS
SELECT
   u.user_id,
   u.first_name,
   u.last_name,
   w.webinar_id,
   w.title,
   wmc.live_start,
   p.payment_succeed,
   wp.price AS WebinarPrice
FROM Webinars_Users wu
INNER JOIN Webinars w ON wu.webinar_id = w.webinar_id
INNER JOIN Webinars_Meetings wm ON w.webinar_id = wm.webinar_id
JOIN Webinars_Meetings_Calendar as WMC on wm.meeting_id = WMC.meeting_id
LEFT JOIN Users u ON wu.user_id = u.user_id
INNER JOIN Orders o ON u.user_id = o.user_id
INNER JOIN Payments_Details p ON o.order_id = p.order_id
JOIN Webinars_Prices as wp on w.webinar_id = wp.webinar_id



--Certyfikaty za studia - adresy
--CREATE VIEW CertificatesToSend AS
SELECT us.user_id AS ParticipantID, u.first_name + ' ' + u.last_name AS ParticipantName,
      ad.street + ' ' + ad.house_number + ' ' + c.city_name + ',' + co.country_name AS Address,
       s.title AS CourseOrStudyName, 'Student' AS ParticipantType
FROM User_Studies us
INNER JOIN Studies s ON us.study_id = s.study_id
INNER JOIN Users u ON u.user_id = us.user_id
join Users_Address as UA on u.user_id = UA.user_id
join Addresses as ad on UA.address_id = ad.address_id
INNER JOIN Cities c ON ad.city_id = c.city_id
INNER JOIN Countries co ON c.country_id = co.country_id
join User_Studies_Diplomas USD on u.user_id = USD.user_id
WHERE USD.diploma_ready = 1 and final_exam_passed = 1




--Daty praktyk i zaliczenia
-- CREATE VIEW StudentsInternships AS
SELECT US.user_id, u.first_name + ' ' + u.last_name AS StudentName, s.title, UI.start_date AS InternshipBeginning, UI.end_date AS InternshipFinished, UI.is_passed
FROM User_Studies US
INNER JOIN Users_Internships AS UI ON UI.user_id=us.user_id
inner join Studies AS s ON s.study_id=US.study_id
inner join Users AS u ON u.user_id=us.user_id


--Lokalizacja praktyk i zaliczenie
-- CREATE VIEW StudentsInternshipsInfo AS
SELECT US.user_id, u.first_name + ' ' + u.last_name AS StudentName, s.title, UI.is_passed, Addr.street + ' ' + addr.house_number + ' ' + city.city_name as InternshipAddress
FROM User_Studies US
INNER JOIN Users_Internships AS UI ON UI.user_id=us.user_id
inner join Studies AS s ON s.study_id=US.study_id
inner join Users AS u ON u.user_id=us.user_id
join Internship_Location as IL on IL.institution_id=UI.institution_id
join Addresses as addr on IL.address_id = addr.address_id
join Cities as city on addr.city_id = city.city_id


--Studenci i kierunki
-- CREATE VIEW StudentsFaculties AS
SELECT US.user_id, u.first_name + ' ' + u.last_name AS StudentName, s.title
FROM User_Studies as US
inner join Studies AS s ON US.study_id = s.study_id
inner join Users AS u ON US.user_id = u.user_id
group by s.title, US.user_id, u.first_name, u.last_name


--Zapisani na kursy i zaliczenia
-- CREATE VIEW CoursePassingStatus AS
SELECT
   cu.user_id, u.first_name + ' ' + u.last_name AS Name, c.title,
   COUNT(DISTINCT m.module_id) AS AllModules,
   SUM(CASE WHEN User_Classes.attendance = 1 THEN 1 ELSE 0 END) AS PassedModules,
   CASE WHEN COUNT(DISTINCT m.module_id) > 0 AND
             SUM(CASE WHEN User_Classes.attendance = 1 THEN 1 ELSE 0 END) / COUNT(DISTINCT m.module_id) >= 0.8
        THEN 'Passed'
        ELSE 'Not Passed'
   END AS CourseStatus
FROM Courses_Users AS CU
INNER JOIN Users u ON u.user_id = cu.user_id
INNER JOIN Courses c ON c.course_id = cu.course_id
INNER JOIN Modules m ON m.course_id = c.course_id
JOIN Modules_Classes AS MC ON m.module_id = MC.module_id
JOIN User_Classes ON u.user_id = User_Classes.user_id
GROUP BY cu.user_id, u.first_name + ' ' + u.last_name, c.title




--Loginy i has³a
-- CREATE VIEW LoginANDPassword AS
SELECT u.user_id, u.first_name + ' ' + u.last_name as Name, u.Email, u.Login, u.Password, ET.type_name
FROM Users U
INNER JOIN Employees as E ON U.user_id = E.employee_id
INNER JOIN Employees_Roles AS ER ON E.employee_id = ER.employee_id
INNER JOIN Employees_Types AS ET ON ER.employee_type_id = ET.employee_type_id


--Sylabus
--CREATE VIEW SyllabusINFO
select studies.study_id, title, syllabus,
Studies_Fee_Exceptions.required_entry_fee as required_entry_fee,
Studies_Fee_Exceptions.pay_due as pay_due_date from studies
left join Studies_Fee_Exceptions on Studies_Fee_Exceptions.study_id = studies.study_id
