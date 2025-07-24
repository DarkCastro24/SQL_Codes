create database taller2;
use taller2;
go 

create table Municipio(
id int not null primary key,
nombre varchar(36) not null
);

create table Categoria(
id int not null primary key,
nombre varchar(36) not null,
descripcion varchar(108) null
);

create table Empleado(
codigo int not null primary key,
nombre varchar(36) not null,
correo_electronico varchar(64) not null unique, 
numero_isss char(7) null check  (numero_isss LIKE '[1-9][1-9][0-9][0-9][0-9][0-9][0-9]'),
id_categoria int not null references Categoria(id)
);

create table Telefono(
id int not null primary key,
numero char(12) not null, -- Incluyendo el codigo de pais +50379854565
codigo_empleado int not null references Empleado(codigo)
);

create table Proyecto(
codigo int not null primary key,
nombre varchar(64) not null,
presupuesto money not null default 0,
id_coordinador int not null references Empleado(codigo)
);

create table Objetivo(
id int not null primary key,
titulo varchar(64) not null,
descripcion varchar(108) null,
id_proyecto int not null references Proyecto(codigo)
);

create table Metrica(
id int not null primary key,
titulo varchar(48) not null,
tipo_metrica bit not null,
fecha_cumplimiento date null,
id_objetivo int not null references Objetivo(id),
id_empleado int not null references Empleado(codigo)
);

create table Ejecucion(
id int not null primary key,
codigo_proyecto int not null references Proyecto(codigo),
id_municipio int not null references Municipio(id) check (id_municipio BETWEEN 1 AND 262),
fecha_inicio date not null check (fecha_inicio > '14/05/2023'), -- Funciona para el 15 de Mayo
fecha_fin date null
);

create table Asignacion(
codigo_empleado int not null,
codigo_proyecto int not null
);

ALTER TABLE Asignacion ADD CONSTRAINT pk_asignacion PRIMARY KEY(codigo_empleado, codigo_proyecto);
ALTER TABLE Asignacion ADD CONSTRAINT fk_codigo_empleado
FOREIGN KEY (codigo_empleado) REFERENCES Empleado (codigo);
ALTER TABLE Asignacion ADD CONSTRAINT fk_codigo_proyecto
FOREIGN KEY (codigo_proyecto) REFERENCES Proyecto (codigo);