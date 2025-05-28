CREATE DATABASE LIBRARY;
USE LIBRARY;

-- ====================================
-- SECTION 1: SCHEMA 
-- ====================================

CREATE TABLE AUTHORS(
AUTHORS_NAME VARCHAR (100) NOT NULL,
AUTHOR_ID INT AUTO_INCREMENT PRIMARY KEY,
BIO TEXT
);
CREATE TABLE CATEGORIES (
    CATEGORY_ID INT AUTO_INCREMENT PRIMARY KEY,
    CATEGORY_NAME VARCHAR(100) NOT NULL
);
CREATE TABLE BOOKS (
    BOOK_ID INT AUTO_INCREMENT PRIMARY KEY,
    TITLE VARCHAR(200) NOT NULL,
    AUTHOR_ID INT,
    CATEGORY_ID INT,
    ISBN VARCHAR(20),
    PUBLISHED_YEAR DATE,
    AVAILABLE_COPIES INT DEFAULT 1,
    FOREIGN KEY (AUTHOR_ID) REFERENCES AUTHORS(AUTHOR_ID),
    FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORIES(CATEGORY_ID)
);

CREATE TABLE MEMBERS (
    MEMBER_ID INT AUTO_INCREMENT PRIMARY KEY,
    FNAME VARCHAR(20) NOT NULL,
    LNAME VARCHAR(20) NOT NULL,
    PHONE VARCHAR(10),
    EMAIL VARCHAR(100),
    JOIN_DATE DATE DEFAULT (CURRENT_DATE)
);
CREATE TABLE LOANS (
    LOAN_ID INT AUTO_INCREMENT PRIMARY KEY,
    BOOK_ID INT,
    MEMBER_ID INT,
    LOAN_DATE DATE DEFAULT (CURRENT_DATE),
    DUE_DATE DATE,
    RETURN_DATE DATE,
    FOREIGN KEY (BOOK_ID) REFERENCES BOOKS(BOOK_ID),
    FOREIGN KEY (MEMBER_ID) REFERENCES MEMBERS(MEMBER_ID) );
    
-- ====================================
-- SECTION 2: DATA (Insert Records)
-- ====================================

INSERT INTO AUTHORS (AUTHORS_NAME , BIO) VALUES
('نجيب محفوظ', 'روائي مصري حائز على جائزة نوبل'),
('غابرييل غارسيا ماركيز', 'كاتب كولومبي، مؤلف "مئة عام من العزلة"'),
('جورج أورويل', 'مؤلف رواية 1984 ومزرعة الحيوان'),
('توفيق الحكيم', 'كاتب ومفكر مصري رائد في المسرح العربي'),
('أجاثا كريستي', 'كاتبة بريطانية متخصصة في روايات الغموض'),
('دوستويفسكي', 'روائي روسي مؤلف "الجريمة والعقاب"'),
('دان براون', 'كاتب أمريكي متخصص في الإثارة والرموز الدينية');

INSERT INTO CATEGORIES ( CATEGORY_NAME) VALUES
('رواية'),
('خيال علمي'),
('أدب عالمي'),
('سيرة ذاتية'),
('مسرحية'),
('رواية بوليسية'),
('فلسفة'),
('إثارة وتشويق');
INSERT INTO BOOKS (TITLE, AUTHOR_ID, CATEGORY_ID, ISBN, PUBLISHED_YEAR, AVAILABLE_COPIES) VALUES
('عودة الروح', 4, 5, '978-977-09-2234-0', '1933-01-01', 2),
('جريمة في قطار الشرق', 5, 6, '978-0-00-711931-8', '1934-01-01', 4),
('الجريمة والعقاب', 6, 7, '978-0-14-044913-6', '1866-01-01', 1),
('شفرة دافنشي', 7, 8, '978-0-385-50420-8', '2003-01-01', 5),
('المجهول', 1, 1, '978-977-09-4567-2', '1960-01-01', 3),
('اللص والكلاب', 1, 1, '978-977-09-1234-5', '1961-01-01', 3),
('مئة عام من العزلة', 2, 3, '978-0-06-088328-7', '1967-01-01', 2),
('1984', 3, 2, '978-0-452-28423-4', '1949-01-01', 1);

INSERT INTO MEMBERS (FNAME, LNAME, EMAIL, PHONE) VALUES
('محمد', 'مصطفى', 'mohammad@example.com', '056781234'),
('خالد', 'ياسر', 'khaled@example.com', '034560000'),
('نورهان', 'مجدي', 'nour@example.com', '011222333'),
('سامي', 'عبد الله', 'sami@example.com', '05555123'),
('ليلى', 'سمير', 'leila@example.com', '01445566'),
('أحمد', 'زكي', 'ahmedz@example.com', '0334455'),
('منى', 'سعيد', 'mona.said@example.com', '099887766'),
('جمال', 'الدين', 'jamal@example.com', '01778899');

INSERT INTO Loans (book_id, member_id, loan_date, due_date, return_date) VALUES
(1, 1, '2025-05-01', '2025-05-10', '2025-05-09'), 
(2, 2, '2025-05-15', '2025-05-25', NULL),          
(3, 3, '2025-05-10', '2025-05-20', NULL),      
(4, 2, '2025-05-10', '2025-05-17', NULL),
(5, 1, '2025-05-12', '2025-05-19', '2025-05-18'),
(2, 3, '2025-05-15', '2025-05-22', NULL),
(1, 4, '2025-05-01', '2025-05-10', '2025-05-09'),
(3, 1, '2025-05-18', '2025-05-25', NULL);
-- ====================================
--  SECTION 3: QUERIES 
-- ====================================
SELECT 
    b.BOOK_ID,
    b.TITLE,
    a.AUTHORS_NAME AS AUTHOR_NAME,
    c.CATEGORY_NAME,
    b.ISBN,
    b.PUBLISHED_YEAR,
    b.AVAILABLE_COPIES
FROM 
    BOOKS b
JOIN 
    AUTHORS a ON b.AUTHOR_ID = a.AUTHOR_ID
JOIN 
    CATEGORIES c ON b.CATEGORY_ID = c.CATEGORY_ID
ORDER BY 
    b.PUBLISHED_YEAR DESC;
-- --------------------------------------------------
SELECT 
    m.MEMBER_ID,
    m.FNAME,
    m.LNAME,
    m.EMAIL,
    l.BOOK_ID,
    b.TITLE,
    l.LOAN_DATE,
    l.DUE_DATE
FROM 
    MEMBERS m
JOIN 
    LOANS l ON m.MEMBER_ID = l.MEMBER_ID
JOIN
    BOOKS b ON l.BOOK_ID = b.BOOK_ID
WHERE 
    l.RETURN_DATE IS NULL
ORDER BY 
    l.DUE_DATE ASC;
-- ------------------------------
UPDATE BOOKS
SET AVAILABLE_COPIES = AVAILABLE_COPIES - 1
WHERE BOOK_ID = 3
AND AVAILABLE_COPIES > 0;
-- --------------------------------
DELETE FROM MEMBERS
WHERE MEMBER_ID = 10
AND MEMBER_ID NOT IN (
    SELECT MEMBER_ID FROM LOANS WHERE RETURN_DATE IS NULL
);
-- ------------------------------------------------
SELECT 
    c.CATEGORY_NAME,
    COUNT(b.BOOK_ID) AS TOTAL_BOOKS,
    SUM(b.AVAILABLE_COPIES) AS TOTAL_AVAILABLE
FROM 
    CATEGORIES c
LEFT JOIN 
    BOOKS b ON c.CATEGORY_ID = b.CATEGORY_ID
GROUP BY 
    c.CATEGORY_NAME
ORDER BY 
    TOTAL_AVAILABLE DESC;
-- -----------------------------------
SELECT 
    l.LOAN_ID,
    m.FNAME,
    m.LNAME,
    b.TITLE,
    l.LOAN_DATE,
    l.RETURN_DATE
FROM 
    LOANS l
JOIN 
    MEMBERS m ON l.MEMBER_ID = m.MEMBER_ID
JOIN 
    BOOKS b ON l.BOOK_ID = b.BOOK_ID
ORDER BY 
    l.LOAN_DATE DESC
LIMIT 5;
-- -------------------------------
UPDATE LOANS
SET RETURN_DATE = CURDATE()
WHERE LOAN_ID = 15
AND RETURN_DATE IS NULL;

