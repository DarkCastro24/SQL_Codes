/* CREACION DE TABLAS */

-- Creacion de la tabla Estado_denuncia
CREATE TABLE Estado_denuncia (
    id NUMBER PRIMARY KEY,
    estado VARCHAR2(50) NOT NULL
);

-- Creacion de la tabla Vecino
CREATE TABLE Vecino (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    fotografia VARCHAR2(50),
    telefono_local VARCHAR2(15)
);

-- Creacion de la tabla Comite
CREATE TABLE Comite (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    lema VARCHAR2(100),
    responsabilidad VARCHAR2(100),
    correo VARCHAR2(25)
);

-- Creacion de la tabla Denuncia
CREATE TABLE Denuncia (
    id NUMBER PRIMARY KEY,
    descripcion VARCHAR2(50),
    fecha DATE NOT NULL,
    hora TIMESTAMP NOT NULL,
    id_estado NUMBER,
    id_vecino NUMBER,
    id_comite NUMBER,
    FOREIGN KEY (id_estado) REFERENCES Estado_denuncia(id),
    FOREIGN KEY (id_vecino) REFERENCES Vecino(id),
    FOREIGN KEY (id_comite) REFERENCES Comite(id)
);

-- Creacion de la tabla Evento
CREATE TABLE Evento (
    id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(50),
    tipo VARCHAR2(50),
    id_comite NUMBER,
    FOREIGN KEY (id_comite) REFERENCES Comite(id)
);

-- Creacion de la tabla Miembro
CREATE TABLE Miembro (
    id NUMBER PRIMARY KEY,
    id_vecino NUMBER,
    id_comite NUMBER,
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE,
    id_representante NUMBER NULL,
    FOREIGN KEY (id_vecino) REFERENCES Vecino(id),
    FOREIGN KEY (id_comite) REFERENCES Comite(id),
    FOREIGN KEY (id_representante) REFERENCES Miembro(id)
);


-- Creacion de la tabla Voluntario
CREATE TABLE Voluntario (
    id_vecino NUMBER,
    id_evento NUMBER,
    tarea VARCHAR2(255),
    PRIMARY KEY (id_vecino, id_evento),
    FOREIGN KEY (id_vecino) REFERENCES Vecino(id),
    FOREIGN KEY (id_evento) REFERENCES Evento(id)
);

/* INSERSION DE DATOS */

--Insertando datos vecino 
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('1', 'Dr. Maggie Ondricka', '501-178-709', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('2', 'Whitney Marquardt', '501-414-671', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('3', 'Dorothy Frami', '501-542-524', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('4', 'Candace Murray', '501-454-527', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('5', 'Mr. Wallace McCullough', '501-079-861', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('6', 'Mrs. Enrique Quigley', '501-351-622', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('7', 'Sharon Rice', '501-225-274', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('8', 'Theodore Murazik', '501-576-641', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('9', 'Tracy Weber', '501-541-081', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('10', 'Pablo Cummerata', '501-751-694', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('11', 'Alonzo Harber', '501-891-410', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('12', 'Nancy Bechtelar', '501-966-701', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('13', 'Herman West', '501-691-419', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('14', 'Raquel Yundt', '501-980-144', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('15', 'Joan Morissette', '501-500-106', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('16', 'Ida Borer', '501-615-584', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('17', 'Franklin Bruen', '501-952-728', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('18', 'Pearl Kuvalis DDS', '501-504-974', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('19', 'Jan Russel', '501-984-415', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('20', 'Jake Stiedemann Jr.', '501-124-896', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('21', 'Lee Macejkovic', '501-878-850', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('22', 'Leland Berge', '501-101-467', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('23', 'Ms. Teri Rosenbaum', '501-117-402', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('24', 'Ms. Dan Bruen', '501-756-740', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('25', 'Guy Lesch', '501-714-195', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('26', 'Spencer Hoppe', '501-865-597', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('27', 'Johnathan Rippin', '501-656-890', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('28', 'Dustin Howell II', '501-940-609', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('29', 'Miss Marjorie Haag', '501-152-781', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('30', 'Miriam Gottlieb', '501-340-157', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('31', 'Cecelia Boehm', '501-743-679', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('32', 'Ms. Jim McKenzie', '501-413-610', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('33', 'Jan Balistreri', '501-891-066', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('34', 'Dwayne Wyman', '501-568-817', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('35', 'Sadie Wunsch', '501-464-900', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('36', 'James Skiles', '501-156-791', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('37', 'Miss Gregory Vandervort', '501-389-891', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('38', 'Jo Beatty', '501-129-758', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('39', 'Heidi Ziemann', '501-251-697', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('40', 'Debbie Bruen', '501-012-522', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('41', 'Sue Kunde', '501-939-226', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('42', 'Lorene Homenick', '501-816-366', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('43', 'Sharon Hammes PhD', '501-911-242', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('44', 'Ms. Billie Grady', '501-577-362', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('45', 'Natasha Kling', '501-673-120', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('46', 'Sylvia Rosenbaum', '501-963-945', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('47', 'Bernadette Kreiger', '501-753-968', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('48', 'Vivian Cole', '501-899-804', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('49', 'Alice Durgan', '501-375-260', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('50', 'Alice Schiller', '501-320-111', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('51', 'Mr. Elias Fahey', '501-622-928', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('52', 'Cary Hahn', '501-447-022', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('53', 'Doris Franey', '501-213-263', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('54', 'Rogelio Grimes III', '501-443-938', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('55', 'Dr. Lorraine O''Reilly', '501-379-351', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('56', 'Beatrice Kassulke', '501-797-921', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('57', 'Timothy D''Amore', '501-183-541', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('58', 'Santiago Toy', '501-284-136', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('59', 'Daryl Hyatt', '501-052-809', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('60', 'Mitchell Lakin V', '501-316-515', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('61', 'Anita Rutherford', '501-672-066', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('62', 'Candice Berge', '501-771-987', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('63', 'Sherry Runolfsdottir', '501-547-794', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('64', 'Patricia Pfannerstill', '501-648-583', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('65', 'Jason Runolfsdottir', '501-899-828', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('66', 'Julio Mitchell', '501-722-262', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('67', 'Bradford Ondricka', '501-919-988', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('68', 'Steve Schulist', '501-319-950', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('69', 'Mr. Janice Rodriguez', '501-385-996', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('70', 'Victoria VonRueden', '501-602-830', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('71', 'Celia Bashirian', '501-731-692', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('72', 'Erick Kohler', '501-709-513', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('73', 'Tomas Wilkinson', '501-786-434', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('74', 'Ms. Shawn Pouros', '501-741-080', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('75', 'Ms. Jasmine Heidenreich', '501-753-428', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('76', 'Antonio Ankunding', '501-274-937', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('77', 'Tim Wisoky', '501-073-774', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('78', 'Juana Kuhn', '501-393-971', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('79', 'Brandi Schneider', '501-044-817', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('80', 'Johnnie Ryan', '501-935-243', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('81', 'Irving Kihn', '501-590-275', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('82', 'Jordan Abernathy', '501-163-144', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('86', 'Homer West', '501-980-245', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('87', 'Karl Schimmel', '501-139-880', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('88', 'Dr. Marco Abshire', '501-547-548', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('89', 'Claire Veum', '501-545-065', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('90', 'Gregg Hagenes Sr.', '501-838-681', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('91', 'Orlando Grant', '501-563-925', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('92', 'Leo Medhurst', '501-952-493', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('93', 'Jeremiah Bode PhD', '501-983-759', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('94', 'Elsa Cormier', '501-273-588', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('95', 'Dolores Heller', '501-586-903', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('96', 'Sonja Senger', '501-742-127', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('97', 'Gerard Botsford', '501-725-086', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('98', 'Dr. Debra Donnelly', '501-650-487', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('99', 'Steve Lind', '501-348-660', 'https://loremflickr.com/640/480');
INSERT INTO vecino (id, nombre, telefono_local, fotografia) VALUES ('100', 'Drew Pollich', '501-258-759', 'https://loremflickr.com/640/480');


--Insertando datos estado_denuncia
INSERT INTO estado_denuncia (id, estado) VALUES ('1', 'aprobado');
INSERT INTO estado_denuncia (id, estado) VALUES ('2', 'en proceso');
INSERT INTO estado_denuncia (id, estado) VALUES ('3', 'finalizado');

--Insertando datos comite
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('1', 'Finanzas', 'Cum corrupti iste nemo facere temporibus.', 'Internal', 'Peggie45@hotmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('2', 'Seguridad', 'Tenetur corporis quae ex pariatur a nobis laudantium. ', 'Direct', 'Baron.Pacocha@hotmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('3', 'Cultura', 'Expedita dignissimos sequi doloremque commodi. ', 'Legacy', 'Adella90@hotmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('4', 'Diversion', 'Expedita modi et eum blanditiis quae praesentium.', 'Investor', 'Krystal25@hotmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('5', 'Deportes', 'Animi quis ad eveniet debitis vitae laborum quod. ', 'Human', 'Virgil3@gmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('6', 'Salud', 'Aliquid quaerat quos adipisci tempore', 'District', 'Alfredo@gmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('7', 'Medioambiente', 'Similique atque facilis consequuntur voluptatum amet neque ut repellendus. ', 'Internal', 'Tabitha5@hotmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('8', 'Planificacion', 'Quibusdam vitae aliquam distinctio cupiditate ratione quibusdam. Eligendi ducimus ratione. ', 'Direct', 'Roberta85@hotmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('9', 'Capacitacion', 'Et numquam asperiores ', 'Internal', 'Lourdes@gmail.com');
INSERT INTO comite (id, nombre, lema, responsabilidad, correo) VALUES ('10', 'Voluntariado', 'Repellendus possimus occaecati dolorum quisquam officia. Enim quisquam corrupti. ', 'Future', 'Matt88@gmail.com');


--Datos Eventos
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (1, 'Fiesta', 'tortor. Nunc commodo auctor velit. Aliquam', 'Quisque', 7);
INSERT INTO evento (id, nombre,descripcion,tipo,id_comite)
VALUES (2, 'Reunion', 'tincidunt, nunc ac mattis ornar', 'ipsum.', 7);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (3, 'Feria de salud', 'quis,', 'bibendum.', 5);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (4, 'Torneo deportivo', 'iaculis odio. Nam interdum enim non nisi', 'quis', 5);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (5, 'Cine', 'accumsan convallis, ante lectus', 'Donec', 3);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (6, 'Concurso de talento', 'vitae purus gravida sagittis', 'Cum', 5);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (7, 'Jornada de limpieza', 'hendrerit. Donec porttitor tellus non magna', 'ante', 2);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (8, 'Clase de baile', 'nisl elementum purus', 'gravida.', 8);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (9, 'Taller de reciclaje', 'at augue id ante dictum', 'egestas', 8);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (10, 'Competencia de decoraci?n de casas', 'ornare sagittis felis.', 'elit,', 1);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (11, 'Paseo en bicicleta', 'Nulla interdum. Curabitur', 'iaculis', 4);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (12, 'Campa?a de reforestaci?n', 'nunc id enim', 'et', 2);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (13, 'Noche de poes?a', 'vitae risus.', 'adipiscing.', 4);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (14, 'Noche de baile', 'Duis cursus, diam', 'Duis', 4);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (15, 'Clases de pintura', 'libero est, congue a, aliquet vel,', 'neque', 3);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (16, 'Clases de m?sica', 'ligula.', 'erat', 5);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (17, 'Noche de lectura', 'urna. Vivamus molestie dapibus ligula', 'consequat', 7);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (18, 'Fiesta de disfraces', 'ut dolor', 'lacus.', 7);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (19, 'Taller de manualidades', 'auctor velit. Aliquam nisl. Nulla', 'gravida', 5);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (20, 'Competencia de fotograf?a', 'lectus. Nullam suscipit,', 'massa', 4);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (21, 'Tarde de picnic', 'Mauris vestibulum, neque sed dictum eleifend,', 'scelerisque', 5);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (22, 'Feria de empleos', 'dui lectus rutrum urna, nec', 'volutpat.', 4);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (23, 'Emprendimientos', 'quam dignissim pharetra.', 'Nunc', 2);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (24, 'Exposici?n de carros', 'mauris sagittis placerat', 'pretium', 4);
INSERT INTO evento (id, nombre, descripcion, tipo, id_comite)
VALUES (25, 'Charla internacional', 'Nullam velit duI', 'Donec', 5);

--Insertando denucia
INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (1, 'non', TO_DATE('2024-11-23', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-11-23 19:07:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 81, 9);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (2, 'Cras dictum ultricies', TO_DATE('2024-08-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-08-10 21:53:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 92, 1);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (3, 'sit amet, consectetuer adipiscing elit.', TO_DATE('2025-04-04', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-04-04 16:17:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 76, 8);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (4, 'in, hendrerit consectetuer,', TO_DATE('2024-01-14', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-01-14 12:20:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 53, 7);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (5, 'dictum sapien. Aenean massa. Integer vitae', TO_DATE('2023-11-19', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-11-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 27, 8);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (6, 'quam', TO_DATE('2024-04-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-04-02 01:03:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 62, 7);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (7, 'Vivamus nisi. Mauris nulla. Integer', TO_DATE('2024-12-04', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-12-04 15:54:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 49, 2);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (8, 'metus vitae velit egestas', TO_DATE('2025-04-04', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-04-04 17:09:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 75, 8);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (9, 'cubilia Curae Phasellus ornare', TO_DATE('2024-11-26', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-11-26 06:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 3, 8);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (10, 'accumsan laoreet', TO_DATE('2025-06-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-06-25 08:39:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 99, 7);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (11, 'luctus aliquet odio', TO_DATE('2025-03-18', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-18 07:20:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 3, 4);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (12, 'ipsum. Donec sollicitudin adipiscing ligula.', TO_DATE('2024-11-26', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-11-26 18:44:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 19, 8);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (13, 'imperdiet ornare. In faucibus. Morbi', TO_DATE('2025-02-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-02-07 13:19:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 79, 2);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (14, 'sem elit', TO_DATE('2024-08-27', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-08-27 04:51:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 49, 4);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (15, 'luctus lobortis.', TO_DATE('2024-06-17', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-06-17 00:23:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 69, 8);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (16, 'ridiculus mus. Proin', TO_DATE('2024-05-07', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-05-07 05:39:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 4, 10);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (17, 'ut, pellentesque eget, dictum placerat, augue. Sed', TO_DATE('2023-11-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-11-25 08:33:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 45, 8);


INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (18, 'fringilla euismod enim', TO_DATE('2024-10-18', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-10-18 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 4, 2);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (19, 'mollis non, cursus non', TO_DATE('2025-03-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-10 02:17:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 81, 3);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (20, 'varius ultrices', TO_DATE('2023-12-08', 'YYYY-MM-DD'), TO_TIMESTAMP('2023-12-08 21:50:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 45, 6);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (21, 'tempor diam dictum', TO_DATE('2024-07-09', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-07-09 07:40:00', 'YYYY-MM-DD HH24:MI:SS'), 1, 97, 1);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (22, 'sociis natoque penatibus et magnis dis parturient', TO_DATE('2025-03-22', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-03-22 22:18:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 43, 4);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (23, 'lectus sit amet', TO_DATE('2024-11-02', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-11-02 00:12:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 39, 7);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (24, 'vulputate, lacuS', TO_DATE('2024-09-25', 'YYYY-MM-DD'), TO_TIMESTAMP('2024-09-25 06:31:00', 'YYYY-MM-DD HH24:MI:SS'), 3, 79, 8);

INSERT INTO denuncia (id, descripcion, fecha, hora, id_estado, id_vecino, id_comite)
VALUES (25, 'eros. Nam consequat dolor vitae dolor.', TO_DATE('2025-05-10', 'YYYY-MM-DD'), TO_TIMESTAMP('2025-05-10 08:11:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 4, 7);

--Insertando miembro
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(1,61,1,TO_DATE('20/7/2022', 'DD/MM/YYYY'),TO_DATE('20/7/2025', 'DD/MM/YYYY'),NULL);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(4,86,2,TO_DATE('21/6/2022', 'DD/MM/YYYY'),TO_DATE('21/6/2025', 'DD/MM/YYYY'),NULL);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(7,19,3,TO_DATE('6/5/2022', 'DD/MM/YYYY'),TO_DATE('6/5/2025', 'DD/MM/YYYY'),NULL);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(10,59,4,TO_DATE('6/4/2022', 'DD/MM/YYYY'),TO_DATE('6/4/2025', 'DD/MM/YYYY'),NULL);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(13,48,5,TO_DATE('4/12/2022', 'DD/MM/YYYY'),TO_DATE('4/12/2025', 'DD/MM/YYYY'),NULL);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(19,40,7,TO_DATE('14/9/2022', 'DD/MM/YYYY'),TO_DATE('14/9/2025', 'DD/MM/YYYY'),NULL);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(22,90,8,TO_DATE('4/2/2023', 'DD/MM/YYYY'),TO_DATE('4/2/2026', 'DD/MM/YYYY'),NULL);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(25,49,9,TO_DATE('27/1/2022', 'DD/MM/YYYY'),TO_DATE('27/1/2025', 'DD/MM/YYYY'),NULL);

INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES (2, 69, 1, TO_DATE('25/07/2022', 'DD/MM/YYYY'), TO_DATE('25/07/2025', 'DD/MM/YYYY'), 1);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(3,6,1,TO_DATE('26/5/2023', 'DD/MM/YYYY'),TO_DATE('26/5/2026', 'DD/MM/YYYY'),1);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(5,45,2,TO_DATE('27/6/2022', 'DD/MM/YYYY'),TO_DATE('27/6/2025', 'DD/MM/YYYY'),4);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(6,99,2,TO_DATE('13/2/2022', 'DD/MM/YYYY'),TO_DATE('13/2/2025', 'DD/MM/YYYY'),4);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(8,28,3,TO_DATE('9/12/2023', 'DD/MM/YYYY'),TO_DATE('9/12/2026', 'DD/MM/YYYY'),7);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(9,74,3,TO_DATE('11/7/2023', 'DD/MM/YYYY'),TO_DATE('11/7/2026', 'DD/MM/YYYY'),7);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(11,63,4,TO_DATE('11/4/2023', 'DD/MM/YYYY'),TO_DATE('11/4/2026', 'DD/MM/YYYY'),10);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(12,91,4,TO_DATE('11/3/2022', 'DD/MM/YYYY'),TO_DATE('11/3/2025', 'DD/MM/YYYY'),10);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(14,50,5,TO_DATE('11/10/2023', 'DD/MM/YYYY'),TO_DATE('11/10/2026', 'DD/MM/YYYY'),13);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(15,78,5,TO_DATE('24/6/2022', 'DD/MM/YYYY'),TO_DATE('24/6/2025', 'DD/MM/YYYY'),13);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(20,22,7,TO_DATE('2/5/2023', 'DD/MM/YYYY'),TO_DATE('2/5/2026', 'DD/MM/YYYY'),19);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(21,67,7,TO_DATE('15/5/2022', 'DD/MM/YYYY'),TO_DATE('15/5/2025', 'DD/MM/YYYY'),19);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(23,3,8,TO_DATE('7/4/2022', 'DD/MM/YYYY'),TO_DATE('7/4/2025', 'DD/MM/YYYY'),22);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(24,90,8,TO_DATE('14/10/2023', 'DD/MM/YYYY'),TO_DATE('14/10/2026', 'DD/MM/YYYY'),22);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(26,1,9,TO_DATE('25/7/2022', 'DD/MM/YYYY'),TO_DATE('25/7/2025', 'DD/MM/YYYY'),25);
INSERT INTO miembro (id, id_vecino, id_comite, periodo_inicio, periodo_fin, id_representante) VALUES(27,32,9,TO_DATE('11/12/2022', 'DD/MM/YYYY'),TO_DATE('11/12/2025', 'DD/MM/YYYY'),25);

--Insertando voluntario
INSERT INTO voluntario (id_vecino, id_evento, tarea)
VALUES (82, 23, 'eleifendras sed leo');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (90, 14, 'ut nisi a odio semper cursus. Integer mollis. Integer tincidunt');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (27, 3, 'Cras vehicula aliquet libero. Integer in magna. Phasellus dolor elit,');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (31, 19, 'velit. Quisque varius. Nam porttitor scelerisque neque. Nullam nisl. Maecenas');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (88, 1, 'id risus quis diam luctus lobortis. Class aptent taciti sociosqu');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (38, 5, 'eu, accumsan sed, facilisis vitae, orci. Phasellus dapibus quam quis');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (23, 16, 'eros turpis non enim. Mauris quis turpis vitae purus gravida');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (71, 23, 'blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (67, 16, 'gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (28, 13, 'mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus.');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (87, 6, 'ornare, facilisis eget, ipsum. Donec sollicitudin adipiscing ligula. Aenean gravida');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (91, 16, 'feugiat nec, diam. Duis mi enim, condimentum eget, volutpat ornare,');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (81, 11, 'Quisque varius. Nam porttitor scelerisque neque. Nullam nisl. Maecenas malesuada');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (72, 20, 'lacinia at, iaculis quis, pede. Praesent eu dui. Cum sociis');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (56, 12, 'iaculis aliquet diam. Sed diam lorem, auctor quis, tristique ac,');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (16, 11, 'suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum primis');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (11, 13, 'Proin ultrices. Duis volutpat nunc sit amet metus. Aliquam erat');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (50, 9, 'In ornare sagittis felis. Donec tempor, est ac mattis semper,');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (25, 9, 'sem mollis dui, in sodales elit erat vitae risus. Duis');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (52, 2, 'pellentesque eget, dictum placerat, augue. Sed molestie. Sed id risus');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (37, 18, 'id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer, cursus');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (40, 19, 'tincidunt nibh. Phasellus nulla. Integer vulputate, risus a ultricies adipiscing,');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (100, 19, 'eu turpis. Nulla aliquet. Proin velit. Sed malesuada augue ut');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (34, 18, 'feugiat placerat velit. Quisque varius. Nam porttitor scelerisque neque. Nullam');

INSERT INTO voluntario (id_vecino, id_evento, tarea) 
VALUES (72, 3, 'orci luctus et ultrices posuere cubilia Curae Phasellus ornare. Fusce');


/* EJERCICIOS PROPUESTOS PARA PRACTICA 1 */

--Mostrar la lista de miembros del comité de finanzas
SELECT v.id AS id_vecino, v.nombre AS nombre_vecino, m.periodo_inicio, m.periodo_fin
FROM Miembro m
JOIN Vecino v ON m.id_vecino = v.id
WHERE m.id_comite = 1;

--¿Qué vecinos han participado en el evento de concurso de talentos como voluntarios?
SELECT v.id AS id_vecino, v.nombre AS nombre_vecino
FROM Voluntario vol
JOIN Vecino v ON vol.id_vecino = v.id
WHERE vol.id_evento = 9;

--Muestra cuántas denuncias existen por cada estado de la tabla "estado_denuncia”
SELECT e.estado AS estado_denuncia, COUNT(d.id) AS total_denuncias
FROM Estado_denuncia e
LEFT JOIN Denuncia d ON e.id = d.id_estado
GROUP BY e.estado;

--Mostrar la lista de comités ordenadas por cantidad de miembros participantes
SELECT c.id AS id_comite, c.nombre AS nombre_comite, COUNT(m.id) AS cantidad_miembros
FROM Comite c
LEFT JOIN Miembro m ON c.id = m.id_comite
GROUP BY c.id, c.nombre
ORDER BY cantidad_miembros DESC;

--Extra: Mostrar la lista de miembros de los comités ordenados en base al nombre del comité, cada registro debe mostrar toda la información del vecino, además, cada registro debe mostrar quien es el coordinador del comité respetivo.
SELECT 
    c.nombre AS nombre_comite,
    v.id AS id_vecino,
    v.nombre AS nombre_vecino,
    v.fotografia,
    v.telefono_local,
    m.periodo_inicio,
    m.periodo_fin,
    coord.id AS id_coordinador,
    coord.nombre AS nombre_coordinador
FROM Miembro m
JOIN Vecino v ON m.id_vecino = v.id
JOIN Comite c ON m.id_comite = c.id
LEFT JOIN Miembro coord_m ON c.id = coord_m.id_comite AND coord_m.id_representante IS NULL
LEFT JOIN Vecino coord ON coord_m.id_vecino = coord.id
ORDER BY c.nombre, v.nombre;
