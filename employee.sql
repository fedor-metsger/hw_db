
CREATE TABLE department (
	department_id SERIAL NOT NULL,
	title VARCHAR(40) UNIQUE NOT NULL,
	CONSTRAINT department_pk PRIMARY KEY (department_id)
);

CREATE TABLE employee (
	employee_id SERIAL NOT NULL,
	department_id INTEGER NOT NULL,
	"name" VARCHAR(40) NOT NULL,
	CONSTRAINT employee_pk PRIMARY KEY (employee_id)
);

ALTER TABLE employee ADD CONSTRAINT employee_fk FOREIGN KEY (department_id) REFERENCES department(department_id);

CREATE TABLE boss (
	department_id INTEGER NOT NULL,
	employee_id INTEGER NOT NULL,
	CONSTRAINT boss_pk PRIMARY KEY (department_id, employee_id)
);

ALTER TABLE boss ADD CONSTRAINT boss_department_fk FOREIGN KEY (department_id) REFERENCES department(department_id);
ALTER TABLE boss ADD CONSTRAINT boss_employee_id_fk FOREIGN KEY (employee_id) REFERENCES employee(employee_id);
