USE university_schema;

CREATE TABLE `university_schema`.`students` (
  `students_id` INT NOT NULL AUTO_INCREMENT,
  `students_first_name` VARCHAR(20) NOT NULL,
  `students_last_name` VARCHAR(20) NOT NULL,
  `students_courses_one` INT NULL,
  `students_courses_two` INT NULL,
  `students_courses_three` INT NULL,
  `students_courses_four` INT NULL,
  PRIMARY KEY (`students_id`),
  UNIQUE INDEX `students_id_UNIQUE` (`students_id` ASC) VISIBLE);
  
CREATE TABLE `university_schema`.`professors` (
  `professors_id` INT NOT NULL AUTO_INCREMENT,
  `professors_name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`professors_id`),
  UNIQUE INDEX `professors_id_UNIQUE` (`professors_id` ASC) VISIBLE);
  
CREATE TABLE `university_schema`.`courses` (
  `courses_id` INT NOT NULL AUTO_INCREMENT,
  `courses_subject` VARCHAR(25) NULL,
  `courses_professor_id` INT NULL,
  PRIMARY KEY (`courses_id`),
  UNIQUE INDEX `courses_id_UNIQUE` (`courses_id` ASC) VISIBLE,
  INDEX `courses_professors_id_idx` (`courses_professor_id` ASC) VISIBLE,
  CONSTRAINT `courses_professors_id`
    FOREIGN KEY (`courses_professor_id`)
    REFERENCES `university_schema`.`professors` (`professors_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION);
    
CREATE TABLE `university_schema`.`grades` (
  `grades_courses_id` INT NOT NULL,
  `grades_students_id` INT NOT NULL,
  `grades` INT NULL,
  PRIMARY KEY (`grades_courses_id`, `grades_students_id`),
  INDEX `grades_students_id_idx` (`grades_students_id` ASC) VISIBLE,
  CONSTRAINT `grades_courses_id`
    FOREIGN KEY (`grades_courses_id`)
    REFERENCES `university_schema`.`courses` (`courses_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `grades_students_id`
    FOREIGN KEY (`grades_students_id`)
    REFERENCES `university_schema`.`students` (`students_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);
    
ALTER TABLE `sql_course`.`students` 
ADD INDEX `student_courses_one_idx` (`students_courses_one` ASC) VISIBLE,
ADD INDEX `students_courses_two_idx` (`students_courses_two` ASC) VISIBLE,
ADD INDEX `students_courses_three_idx` (`students_courses_three` ASC) VISIBLE,
ADD INDEX `students_courses_four_idx` (`students_courses_four` ASC) VISIBLE;
    
ALTER TABLE `sql_course`.`students` 
ADD CONSTRAINT `students_courses_one`
  FOREIGN KEY (`students_courses_one`)
  REFERENCES `sql_course`.`courses` (`courses_id`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT,
ADD CONSTRAINT `students_courses_two`
  FOREIGN KEY (`students_courses_two`)
  REFERENCES `sql_course`.`courses` (`courses_id`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT,
ADD CONSTRAINT `students_courses_three`
  FOREIGN KEY (`students_courses_three`)
  REFERENCES `sql_course`.`courses` (`courses_id`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT,
ADD CONSTRAINT `students_courses_four`
  FOREIGN KEY (`students_courses_four`)
  REFERENCES `sql_course`.`courses` (`courses_id`)
  ON DELETE CASCADE
  ON UPDATE RESTRICT;
    


INSERT INTO professors(professors_name)
VALUES('H. Simpson'),
('W. White'),
('J. Franco'),
('D. Shephard'),
('D. Whibley'),
('S. Jocz');

INSERT INTO courses
VALUES (100, 'Biology', 2),
(101, 'Algerbra', 6),
(102, 'English', 5),
(103, 'Chemisty', 1),
(104, 'Art History', 3),
(105, 'Economics', 4),
(106, 'Ceramics', 3),
(107, 'Calculus', 6),
(108, 'Business Management', 4),
(109, 'Photography', 3),
(110, 'Graphic Design', 3),
(111, 'Medical Terminology', 2),
(112, 'Political Science', 4);

INSERT INTO students(
students_first_name, 
students_last_name, 
students_courses_one_id, 
students_courses_two_id,
students_courses_three_id,
students_courses_four_id
)
VALUES
('Deryck', 'Whibley', 105, 103, 111, 100),
('Jessica', 'Anderton', 112, 105, 109, 108),
('Frank', 'Martin', 100, 109, 102, 104),
('Amy', 'Myers', 106, 102, 109, 112),
('Tina', 'Chase', 107, 105, 106, 111),
('Sam', 'Larson', 102, 111, 103, 102),
('Damon', 'Sirois', 100, 102, 112, 108),
('George', 'Jones', 112, 103, 100, 101);

INSERT INTO grades(grades_courses_id, grades_student_id, grades)
VALUES
(112, 58, RAND()*100),
(112, 60, RAND()*100),
(112, 63, RAND()*100),
(112, 64, RAND()*100),
(112, 66, RAND()*100),
(112, 68, RAND()*100),
(112, 71, RAND()*100),
(112, 72, RAND()*100),
(112, 48, RAND()*100),
(112, 50, RAND()*100),
(112, 52, RAND()*100),
(112, 55, RAND()*100),
(112, 56, RAND()*100);


-- The average grade that is given by each professor
SELECT professors_id, professors_name, AVG(grades)
FROM professors
LEFT JOIN courses
ON professors_id = courses_professors_id
RIGHT JOIN grades
ON courses_id = grades_courses_id
GROUP BY professors_id;


-- The top grades for each student
SELECT *
FROM grades
ORDER BY grades_students_id, grades DESC;
-- OR
SELECT *
FROM grades
WHERE grades_students_id = 9
ORDER BY grades DESC;


-- Group students by the courses that they are enrolled in
SELECT grades_courses_id, courses_subject, grades_students_id, students_first_name, students_last_name
FROM students
LEFT JOIN grades
ON grades_students_id = students_id
LEFT JOIN courses
ON grades_courses_id = courses_id
ORDER BY grades_courses_id;


-- Summary report of courses and their average grades, sorted by the most challenging course to the easiest course
SELECT grades_courses_id, courses_subject, AVG(grades)
FROM courses
JOIN grades
ON courses_id = grades_courses_id
GROUP BY grades_courses_id
ORDER BY AVG(grades) DESC;


-- Which student and professor have the most courses in common
SELECT COUNT(*) occurrences, courses_professors_id, grades_students_id
FROM courses
LEFT JOIN grades
ON courses_id = grades_courses_id
GROUP BY courses_professors_id, grades_students_id
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;
