script Datasoft.txt
Quién tiene acceso

u
C
Propiedades del sistema
Tipo
Texto
Tamaño
27 kB
Almacenamiento usado
52 kB
Ubicación
Proyecto Integrado 4L
Propietario
yo
Modificado
4 jun 2019 por mí
Abierto
27 feb 2021 por mí
Creado
3 jun 2019 con Google Drive Web (Unverified)
Añadir descripción
Los usuarios con acceso de lectura pueden descargar este elemento
CREATE TABLE DEPARTAMENTO
(
IdDep number(2) NOT NULL,
NomDep varchar2(30) NOT NULL,
CONSTRAINT pkDEPARTAMENTO PRIMARY KEY (IdDep)
);

CREATE TABLE MUNICIPIO
(
IdMun number(10) NOT NULL,
NomMun varchar2(100) NOT NULL,
IdDep number(2) NOT NULL,
CONSTRAINT pkMUNICIPIO PRIMARY KEY (IdMun),
CONSTRAINT fkmunicipioDEPARTAMENTO FOREIGN KEY (IdDep) REFERENCES DEPARTAMENTO(IdDep)
);

CREATE TABLE ZONA
(
IdZona number(10) NOT NULL,
NomZona varchar2(100) NOT NULL,
IdMun number(10) NOT NULL,
CONSTRAINT pkZONA PRIMARY KEY (IdZona),
CONSTRAINT fkZONAMUNICIPIO FOREIGN KEY (IdMun) REFERENCES MUNICIPIO(IdMun)
);

CREATE TABLE TIPODOCUMENTO
(
IdTipDoc number(3) NOT NULL,
NomTipDoc varchar2(30) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkTIPODOCUMENTO PRIMARY KEY (IdTipDoc)
);

CREATE TABLE PROVEEDOR
(
IdPro number(38) NOT NULL,
NomPro varchar2(60) NOT NULL,
Nit number(30) NOT NULL,
CorPro varchar2(50) NOT NULL,
TelPro number(20) NOT NULL,
UrlPro  varchar2(300),
Estado number(1) NOT NULL,
CONSTRAINT pkPROVEEDOR PRIMARY KEY (IdPro),
CONSTRAINT fkPROVEEDORTIPODOCUMENTO FOREIGN KEY (IdTipDoc) REFERENCES TIPODOCUMENTO(IdTipDoc)
);

CREATE TABLE MARCA
(
IdMar number(4) NOT NULL,
NomMar varchar2(30) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkMARCA PRIMARY KEY (IdMar)
);


CREATE TABLE COLOR
(
IdCol number(4) NOT NULL,
NomCol varchar2(30) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkCOLOR PRIMARY KEY (IdCol)
);

CREATE TABLE CATEGORIA
(
IdCat number(4) NOT NULL,
NomCat varchar2(30) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkCATEGORIA PRIMARY KEY (IdCat)
);

CREATE TABLE ROLES
(
IdRol number(3) NOT NULL,
NomRol varchar2(30) NOT NULL,
CONSTRAINT pkROLES PRIMARY KEY (IdRol)
);

CREATE TABLE SEXO
(
IdSex number(2) NOT NULL,
NomSex varchar2(60) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkSEXO PRIMARY KEY (IdSex)
);

CREATE TABLE PRODUCTO
(
IdProd number(38) NOT NULL,
NomProd varchar2(60) NOT NULL,
IdMar number(4) NOT NULL,
IdCat number(4) NOT NULL,
IdCol number(4) NOT NULL,
CodBarraProd number(38),
ModeloProd varchar2(60),
DetalleProd varchar2(2000),
AlmaceProd varchar2(20),
CostProd float NOT NULL,
Utilidad float,
Iva float,
ImageProd BLOB,
Estado number(1) NOT NULL,
CONSTRAINT pkPRODUCTO PRIMARY KEY (IdProd),
CONSTRAINT uKPRODUCTOMODELO UNIQUE (ModeloProd),
CONSTRAINT uKPRODUCTOBARRA UNIQUE (CodBarraProd),
CONSTRAINT fkPRODUCTOMARCA FOREIGN KEY (IdMar) REFERENCES MARCA(IdMar),
CONSTRAINT fkPRODUCTOCATEGORIA FOREIGN KEY (IdCat) REFERENCES CATEGORIA(IdCat),
CONSTRAINT fkPRODUCTOCOLOR FOREIGN KEY (IdCol) REFERENCES COLOR(IdCol)
);

CREATE TABLE SUCURSAL
(
IdSuc number(3) NOT NULL,
nombre varchar2(60),
ConSuc varchar2(20) NOT NULL,
DirSuc varchar2(40) NOT NULL,
IdZona number(10) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkSUCURSAL PRIMARY KEY (IdSuc),
CONSTRAINT fkSUCURSALZONA FOREIGN KEY (IdZona) REFERENCES ZONA(IdZona)
);

CREATE TABLE USUARIO
(
IdUsu number(38) NOT NULL,
NomUsu varchar2(30) NOT NULL,
ApeUsu varchar2(30) NOT NULL,
IdSuc number(3) NOT NULL,
PassUsu varchar2(60) NOT NULL,
IdTipDoc number(3) NOT NULL,
DocUsu number(12) NOT NULL,
TelUsu varchar2(30) NOT NULL,
IdRol number(3) NOT NULL,
CorUsu varchar2(60) NOT NULL,
IdSex number(2) NOT NULL,
DirUsu varchar2(60) NOT NULL,
IdZona number(10) NOT NULL,
FotoUsu BLOB,
Estado number(1) NOT NULL,
CONSTRAINT pkUSUARIO PRIMARY KEY (IdUsu),
CONSTRAINT uKUSUARIO UNIQUE (DocUsu),
CONSTRAINT fkUSUARIOSUCURSAL FOREIGN KEY (IdSuc) REFERENCES SUCURSAL(IdSuc),
CONSTRAINT fkUSUARIOTIPODOCUMENTO FOREIGN KEY (IdTipDoc) REFERENCES TIPODOCUMENTO(IdTipDoc),
CONSTRAINT fkUSUARIOROLES FOREIGN KEY (IdRol) REFERENCES ROLES(IdRol),
CONSTRAINT fkUSUARIOSEXO FOREIGN KEY (IdSex) REFERENCES SEXO(IdSex),
CONSTRAINT fkUSUARIOZONA FOREIGN KEY (IdZona) REFERENCES ZONA(IdZona)
);



CREATE TABLE REPORTES
(
IdRep number(38) NOT NULL,
IdUsu NUMBER(12) NOT NULL,
Rol VARCHAR2(50) NOT NULL,
FecIni date NOT NULL,
FecSal date,
CONSTRAINT pkREPORTES PRIMARY KEY (IdRep)
);

CREATE TABLE FACTURACOMPRA
(
IdFacCom number(38) NOT NULL,
IdPro number(38) NOT NULL,
IdUsu number(12) NOT NULL,
FecFacCom date NOT NULL,
CONSTRAINT pkFACTURACOMPRA PRIMARY KEY (IdFacCom),
CONSTRAINT fkFACTURACOMPRAPROVEEDOR FOREIGN KEY (IdPro) REFERENCES PROVEEDOR(IdPro),
CONSTRAINT fkFACTURACOMPRAUSUARIO FOREIGN KEY (IdUsu) REFERENCES USUARIO(IdUsu)
);


CREATE TABLE DETALLECOMPRA
(
IdFacCom number(38) NOT NULL,
Idprod number(10) NOT NULL,
cantidad number(8) NOT NULL,
valor float NOT NULL,
Iva float,
Descuento float(20),
CONSTRAINT fkDETALLECOMPRAFACTURACOMPRA FOREIGN KEY (IdFacCom) REFERENCES FACTURACOMPRA(IdFacCom),
CONSTRAINT fkDETALLECOMPRAPRODUCTO FOREIGN KEY (Idprod) REFERENCES PRODUCTO(IdProd)
);

CREATE TABLE DETALLECDEVOLUCION
(
IdFacCom number(38) NOT NULL,
Idprod number(10) NOT NULL,
cantidad number(8) NOT NULL,
CONSTRAINT fkDETALLECDFACTURACOMPRA FOREIGN KEY (IdFacCom) REFERENCES FACTURACOMPRA(IdFacCom),
CONSTRAINT fkDETALLECDPRODUCTO FOREIGN KEY (Idprod) REFERENCES PRODUCTO(IdProd)
);

CREATE TABLE CLIENTE
(
IdCli number(12) NOT NULL,
NomCli varchar2(30) NOT NULL,
ApeCli varchar2(30) NOT NULL,
IdTipDoc number(20) NOT NULL,
DocCli number(12) NOT NULL,
TelCli number(20) NOT NULL,
CorCli varchar2(30),
IdSex number(2) NOT NULL,
DirCli varchar2(40) NOT NULL,
IdZona number(10),
Estado number(1) NOT NULL,
CONSTRAINT pkCLIENTE PRIMARY KEY (IdCli),
CONSTRAINT uKCLIENTE UNIQUE (DocCli),
CONSTRAINT fkCLIENTETIPODOCUMENTO FOREIGN KEY (IdTipDoc) REFERENCES TIPODOCUMENTO(IdTipDoc),
CONSTRAINT fkCLIENTESEXO FOREIGN KEY (IdSex) REFERENCES SEXO(IdSex),
CONSTRAINT fkCLIENTEZONA FOREIGN KEY (IdZona) REFERENCES ZONA(IdZona)
);



CREATE TABLE FACTURAVENTA
(
IdFacVen number(38) NOT NULL,
IdCli number(12) NOT NULL,
IdUsu number(12) NOT NULL,
Fecha date NOT NULL,
CONSTRAINT pkFACTURAVENTA PRIMARY KEY (IdFacVen),
CONSTRAINT fkFACTURAVENTACLIENTE FOREIGN KEY (IdCli) REFERENCES CLIENTE(IdCli),
CONSTRAINT fkFACTURAVENTAUSUARIO FOREIGN KEY (IdUsu) REFERENCES USUARIO(IdUsu)
);


CREATE TABLE PRODUCTOCLIENTE
(
IdProCli number(38) NOT NULL,
IdCli number(12) NOT NULL,
DetalleProCli varchar2(2000),
FecProCli date,
Direccion varchar2(50),
CONSTRAINT pkPRODUCTOCLIENTE PRIMARY KEY (IdProCli),
CONSTRAINT fkPRODUCTOCLIENTECLIENTE FOREIGN KEY (IdCli) REFERENCES CLIENTE(IdCli)
);

CREATE TABLE DETALLEVENTA
(
IdFacVen number(38) NOT NULL,
IdProd number(10) NOT NULL,
CanDetVen number(8) NOT NULL,
Valor float(50) NOT NULL,
CONSTRAINT fkDETALLEVENTAFACTURAVENTA FOREIGN KEY (IdFacVen) REFERENCES FACTURAVENTA(IdFacVen),
CONSTRAINT fkDETALLEVENTAFACTURA FOREIGN KEY (IdProd) REFERENCES PRODUCTO(IdProd)
);

CREATE TABLE DETALLEVDEVOLUCION
(
IdFacVen number(38) NOT NULL,
IdProd number(10) NOT NULL,
CanDetVen number(8) NOT NULL,
CONSTRAINT fkDETALLEVENTAFACTURAVD FOREIGN KEY (IdFacVen) REFERENCES FACTURAVENTA(IdFacVen),
CONSTRAINT fkDETALLEVENTAFACTURAPRODUCTO FOREIGN KEY (IdProd) REFERENCES PRODUCTO(IdProd)
);

CREATE TABLE CATEGORIASERVICIOS
(
IdCatSer number(14) NOT NULL,
NomCat varchar2(50) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkCATEGORIASERVICIOS PRIMARY KEY (IdCatSer)
);

CREATE TABLE SERVICIOS
(
IdSer number(38) NOT NULL,
NomSer varchar2(100) NOT NULL,
CostSer float NOT NULL,
IdCatSer number(14) NOT NULL,
Estado number(1) NOT NULL,
CONSTRAINT pkSERVICOIOS PRIMARY KEY (IdSer),
CONSTRAINT fkPRODUCTOCLIENTECATEGORIAS FOREIGN KEY (IdCatSer) REFERENCES CATEGORIASERVICIOS(IdCatSer)
);


CREATE TABLE DETALLEVENTASERVICIO
(
IdFacVen number(38) NOT NULL,
IdSer number(38) NOT NULL,
DetVenSer varchar2(2000) NOT NULL,
Costo float NOT NULL,
IdProCli number(38),
CONSTRAINT fkFACTURAVENTADETALLESERVICIOS FOREIGN KEY (IdFacVen) REFERENCES FACTURAVENTA(IdFacVen),
CONSTRAINT fkSERVICIOSDETALLESERVICIOS FOREIGN KEY (IdSer) REFERENCES SERVICIOS(IdSer),
CONSTRAINT fkPROCLIDETALLESERVICIOS FOREIGN KEY (IdProCli) REFERENCES PRODUCTOCLIENTE(IdProCli)
);

--auditoria

CREATE TABLE RESOLUCION
(
FechaInicio date NOT NULL,
FechaFinal date NOT NULL,
Inicio number(38) NOT NULL,
Alcance number(38) NOT NULL
);
--

--auditoria

CREATE TABLE AUDITORIA
(
IdAud number(38) NOT NULL,
IdUsu number(20) NOT NULL,
Rol varchar2(50) NOT NULL,
Fecha date NOT NULL,
descripcion varchar2(100) NOT NULL,
CONSTRAINT pkAUDITORIA PRIMARY KEY (IdAud)
);
--

--Temporal

CREATE TABLE TEMP
(
IdTemp number(38) NOT NULL,
IdUsu number(38) NOT NULL,
Rol varchar2(50) NOT NULL,
Onli number(1) NOT NULL,
CONSTRAINT pkTEMP PRIMARY KEY (IdTemp)
);

--Vistas
CREATE VIEW MOSTRARSUCURSAL AS
SELECT IDSUC AS "ID",nombre, DIRSUC AS DIRECCION, IDZONA AS "ID ZONA" FROM SUCURSAL WHERE estado = 1;

CREATE VIEW MOSTRARMARCA AS
SELECT IDMAR AS "ID", NOMMAR AS "NOMBRE DE MARCA" FROM MARCA WHERE ESTADO=1;

CREATE OR REPLACE VIEW MOSTRARCATEGORIA AS
SELECT IDCAT AS "ID", NOMCAT AS "NOMBRE DE CATEGORIA" FROM CATEGORIA WHERE ESTADO =1;

CREATE OR REPLACE VIEW MOSTRARSTOCK AS
select dt.idprod as "ID del producto",pro.nomprod as "Nombre del producto", sum(dt.cantidad)as "Cantidad",dt.valor as "Valor", dt.IVA as "IVA incluido",dt.descuento as "Descuento por aplicar" from detallecompra dt
join producto pro on dt.idprod = pro.idprod
group by dt.idprod,dt.valor,pro.nomprod,dt.iva,dt.descuento;

CREATE OR REPLACE VIEW MOSTRARUSUARIOS AS
SELECT IDUSU AS "ID", NOMUSU AS NOMBRE, APEUSU AS APELLIDO, IDSUC AS "ID SUCURSAL", PASSUSU AS "CONTRASEÑA", IDTIPDOC AS "ID TIPO DOCUMENTO", DOCUSU AS "DOCUMENTO", TELUSU AS CONTACTO,IDROL AS "ID ROL", CORUSU AS CORREO, IDSEX AS "ID GENERO",DIRUSU AS DIRECCION, IDZONA AS ZONA, FOTOUSU AS FOTO FROM USUARIO WHERE ESTADO =1;

CREATE VIEW  MOSTRARPRODUCTOS AS  SELECT idprod AS "ID", NOMPROD AS "NOMBRE DEL PRODUCTO", IDMAR AS "ID MARCA", IDCAT AS "ID CATEGORIA", IDCOL AS "ID COLOR",MODELOPROD as "MODELO",DETALLEPROD AS "DETALLE DEL PRODUCTO",ALMACEPROD AS ALMACENAMIENTO, CODBARRAPROD AS "CODIGO DE BARRA", COSTPROD AS "COSTO",UTILIDAD,IMAGEPROD AS "IMAGEN" FROM PRODUCTO WHERE ESTADO =1;

CREATE VIEW MOSTRARCLIENTES AS 
SELECT IDCLI AS "ID CLIENTE", NOMCLI AS NOMBRE, APECLI AS APELLIDO, IDTIPDOC "ID TIPO DOCUMENTO", DOCCLI AS "N° DOCUMENTO", TELCLI AS TELEFONO, CORCLI AS CORREO, IDSEX AS GENERO, DIRCLI AS DIRECCION, IDZONA AS "ID ZONA"
FROM CLIENTE WHERE ESTADO = 1;

 CREATE VIEW MOSTRARGENERO AS 
 SELECT IDSEX AS "ID", NOMSEX AS "NOMBRE DEL GENERO" FROM SEXO WHERE ESTADO = 1;

CREATE VIEW MOSTRARPROVEEDOR AS 
SELECT IDPRO AS "ID", NOMPRO AS "NOMBRE DEL PROVEEDOR",nit AS "IDENTIFICACION", CORPRO AS CORREO, TELPRO AS "NUMERO DE CONTACTO", URLPRO AS "DIRECCION WEB(URL)" FROM PROVEEDOR WHERE ESTADO = 1;

CREATE VIEW MOSTRARTIPODOCUMENTO AS 
SELECT IDTIPDOC AS "ID", NOMTIPDOC AS "NOMBRE TIPO DOCUMENTO" FROM TIPODOCUMENTO WHERE ESTADO= 1;

create view MOSTRARCOLOR as
select idcol as ID, nomcol as Nombre from color where estado =1;

CREATE OR REPLACE VIEW MOSTRARAUDITORIA as
select rol, idusu as DocUsuario, to_char(fecha, 'DD/MM/YYYY-HH24:MI:SS') as Fecha, descripcion from auditoria ORDER BY FECHA DESC;

create view MOSTRARCATEGORIASERVICIO as
select idcatser as "ID", nomcat as "Categoria de Servicio" from categoriaservicios where estado=1; 

CREATE OR REPLACE VIEW MOSTRARSERVICIO as
select idser as "ID", nomser as "Nombre Servicio",COSTSER AS "Costo", idcatser as "Id Categoria" from servicios where estado=1; 

CREATE OR REPLACE VIEW MOSTRARREPORTES as
SELECT IDUSU AS DOCUMENTO, to_char(fecini, 'DD/MM/YYYY-HH24:MI:SS') as "Fecha Inicio", to_char(fecsal, 'DD/MM/YYYY-HH24:MI:SS') as "Fecha Final",
'[Dias: '||TRUNC((fecsal-fecini))||'] - [Hs: '|| TRUNC((fecsal-fecini) * (24))||'] - [Min: '|| TRUNC((fecsal-fecini) * (60 * 24))||'] - [Seg: '||
TRUNC((fecsal-fecini) * (60 * 60 * 24))||']' as " Tiempo Activo" from reportes ORDER BY FECINI DESC;



--BUSCAR POR FECHA REPORTES
SELECT IDUSU AS DOCUMENTO, to_char(fecini, 'DD/MM/YYYY-HH24:MI:SS') as FechaInicio, to_char(fecsal, 'DD/MM/YYYY-HH24:MI:SS') as FechaFinal,
'Dias: '||TRUNC((fecsal-fecini))||' - Hs: '|| TRUNC((fecsal-fecini) * (24))||' Seg: '|| TRUNC((fecsal-fecini) * (60 * 24))||' ms: '|| TRUNC((fecsal-fecini) * (60 * 60 * 24)) as "Tiempo Activo" from reportes 
WHERE TRUNC (FECINI) = TO_DATE ('29/05/2019', 'DD/MM/RRRR');
--

--SECUENCIAS
CREATE SEQUENCE AUMENTARCLIENTE;
CREATE SEQUENCE AUMENTARMARCA;
CREATE SEQUENCE AUMENTARSEXO;
CREATE SEQUENCE AUMENTARSUCURSAL;
CREATE SEQUENCE AUMENTARTIPODOCUMENTO;
CREATE SEQUENCE AUMENTARUSUARIO;
CREATE SEQUENCE AUMENTARCOLOR;
CREATE SEQUENCE AUMENTARPROVEEDOR;
CREATE SEQUENCE AUMENTARPRODUCTO;
CREATE SEQUENCE AUMENTARCATEGORIA;
CREATE SEQUENCE AUMENTARCATEGORIASERVICIOS;
CREATE SEQUENCE AUMENTARAUDITORIA;
CREATE SEQUENCE AUMENTARPRODCLI;
CREATE SEQUENCE AUMENTARTEMP;
CREATE SEQUENCE AUMENTARREPORTE;
CREATE SEQUENCE AUMENTARFACCOM;
CREATE SEQUENCE AUMENTARCATEGORIASERVICIO;
CREATE SEQUENCE AUMENTARSERVICIO;
CREATE SEQUENCE AUMENTARPRODUCTOCLIENTE;

--insertar datos
INSERT INTO SEXO VALUES(AUMENTARSEXO.nextval,'MASCULINO',1);
INSERT INTO TIPODOCUMENTO VALUES(AUMENTARTIPODOCUMENTO.NEXTVAL,'cédula de ciudadanía (CC)',1);
INSERT INTO ROLES VALUES(1,'ADMINISTRADOR');
INSERT INTO ROLES VALUES(2,'GERENTE');
INSERT INTO ROLES VALUES(3,'OPERADOR');
INSERT INTO SUCURSAL VALUES(AUMENTARSUCURSAL.NEXTVAL,'3117059347','CRA 23',686800110,1);
INSERT INTO USUARIO VALUES(AUMENTARUSUARIO.NEXTVAL,'Daniel','Rondon',1,'.',1,1098809048,'3024218105',1,'.',1,'CRA 24',686800110,NULL,1);

--lOGIN TEMP
INSERT INTO TEMP VALUES(AUMENTARTEMP.NEXTVAL,1098809038,'IDROL',1);

DELETE FROM TEMP;
--

--Reporte de asistencias

INSERT INTO REPORTES VALUES(AUMENTARREPORTE.NEXTVAL,1098809038,'Rol', sysdate, NULL,1);


UPDATE REPORTES SET FECSAL=SYSDATE, onli=0 WHERE onli=1;

--
--Procedimientos

CREATE OR REPLACE PROCEDURE INC_AUDITORIA
(i_auditoria auditoria%ROWTYPE)
IS
BEGIN
INSERT INTO auditoria (IDAUD, IDUSU, ROL, FECHA, DESCRIPCION)
VALUES (i_auditoria.IDAUD, i_auditoria.IDUSU, i_auditoria.ROL, i_auditoria.FECHA, i_auditoria.DESCRIPCION);
END;
/

CREATE OR REPLACE PROCEDURE UPD_DETALLECOMPRA
(i_dventa detallecompra%ROWTYPE)
IS
BEGIN
update DETALLECOMPRA set cantidad=(cantidad-i_dventa.cantidad) where idprod=i_dventa.idprod and i_dventa.valor like (valor-(valor*(descuento/100)));
END;
/




--triggers
--Hora
--select to_char(fecha, 'DD/MM/YYYY-HH24:MI:SS') from auditoria;
--


--Usuario
CREATE OR REPLACE TRIGGER AUDITORIA_USUARIO
AFTER INSERT OR UPDATE OR DELETE 
ON USUARIO 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT NOMROL INTO r_auditoria.rol from roles where idrol=r_auditoria.rol;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó el Usuario '||:new.nomusu||' identificado por: '||:new.docusu;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico el Usuario '||:old.nomusu||' a '||:new.nomusu||' identificado por: '||:old.docusu;
ELSE
r_auditoria.descripcion:= ' Eliminó el Usuario '||:old.nomusu||' identificado por: '||:old.docusu;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el Usuario '||:old.nomusu||' identificado por: '||:old.docusu;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--Categoria
CREATE OR REPLACE TRIGGER AUDITORIA_CATEGORIA
AFTER INSERT OR UPDATE OR DELETE 
ON CATEGORIA 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó la Categoria '||:new.nomcat;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico la Categoria '||:old.nomcat||' a '||:new.nomcat;
ELSE
r_auditoria.descripcion:= ' Eliminó la Categoria '||:old.nomcat;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos la Categoria '||:old.nomcat;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--CategoriaServicio
CREATE OR REPLACE TRIGGER AUDITORIA_CATEGORIASERVICIOS
AFTER INSERT OR UPDATE OR DELETE 
ON CATEGORIASERVICIOS 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó la Categoria de Servicio '||:new.nomcat;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico la Categoria de Servicio '||:old.nomcat||' a '||:new.nomcat;
ELSE
r_auditoria.descripcion:= ' Eliminó la Categoria de Servicio '||:old.nomcat;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos la Categoria de Servicio'||:old.nomcat;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--Cliente
CREATE OR REPLACE TRIGGER AUDITORIA_CLIENTE
AFTER INSERT OR UPDATE OR DELETE 
ON CLIENTE 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó el Cliente '||:new.nomcli||' identificado por: '||:new.doccli;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico el Cliente '||:old.nomcli||' a '||:new.nomcli||' identificado por: '||:old.doccli;
ELSE
r_auditoria.descripcion:= ' Eliminó el Cliente '||:old.nomcli||' identificado por: '||:old.doccli;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el Cliente'||:old.nomcli||' identificado por: '||:old.doccli;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--PRODUCTO
CREATE OR REPLACE TRIGGER AUDITORIA_PRODUCTO
AFTER INSERT OR UPDATE OR DELETE 
ON PRODUCTO 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó el Producto '||:new.nomprod||' con Codigo: '||:new.codbarraprod;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico el Producto '||:old.nomprod||' a '||:new.nomprod||' con Codigo: '||:new.codbarraprod;
ELSE
r_auditoria.descripcion:= ' Eliminó el Producto '||:old.nomprod||' con Codigo: '||:new.codbarraprod;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el Producto'||:old.nomprod||' con Codigo: '||:new.codbarraprod;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--PROVEEDOR
CREATE OR REPLACE TRIGGER AUDITORIA_PROVEEDOR
AFTER INSERT OR UPDATE OR DELETE 
ON PROVEEDOR 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó el Proveedor '||:new.nompro||' identificado por: '||:new.nit||' con correo: '||:new.corpro;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico el Proveedor '||:old.nompro||' a '||:new.nompro||' identificado por: '||:new.nit||' con correo: '||:new.corpro;
ELSE
r_auditoria.descripcion:= ' Eliminó el Proveedor '||:old.nompro||' identificado por: '||:new.nit;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el Proveedor'||:old.nompro||' identificado por: '||:new.nit;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--SERVICIO
CREATE OR REPLACE TRIGGER AUDITORIA_SERVICIOS
AFTER INSERT OR UPDATE OR DELETE 
ON SERVICIOS 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó el Servicio '||:new.nomser||' con un costo de: '||:new.costser;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico el Servicio '||:old.nomser||' a '||:new.nomser||' con un costo de: '||:new.costser;
ELSE
r_auditoria.descripcion:= ' Eliminó el Servicio '||:old.nomser;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el Servicio'||:old.nomser;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--TIPODOCUMENTO
CREATE OR REPLACE TRIGGER AUDITORIA_TIPODOCUMENTO
AFTER INSERT OR UPDATE OR DELETE 
ON TIPODOCUMENTO 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó el Tipo de Documento # '||:new.idtipdoc||' llamado: '||:new.nomtipdoc;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico el Tipo de Documento '||:old.nomtipdoc;
ELSE
r_auditoria.descripcion:= ' Eliminó el Tipo de Documento '||:old.nomtipdoc;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el Tipo de Documento '||:old.nomtipdoc;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--STOCK_QUIEN
CREATE OR REPLACE TRIGGER AUDITORIA_QUIEN
AFTER UPDATE OF descuento
ON DETALLECOMPRA 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
r_auditoria.descripcion:= ' Modificó el Dcto: '||:old.descuento||'% a '||:new.descuento||'% al producto: '||:old.idprod;
INC_AUDITORIA(r_auditoria);
END;
/
--

--PRODUCTO
CREATE OR REPLACE TRIGGER AUDITORIA_PRODUCTO
AFTER INSERT OR UPDATE OR DELETE
ON PRODUCTO 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó el Producto '||:new.nomprod||' Con un costo: '||:new.costprod;
ELSIF UPDATING THEN
IF :new.ESTADO = :old.ESTADO THEN
r_auditoria.descripcion:= ' Modifico el Producto '||:old.nomprod;
ELSE
r_auditoria.descripcion:= ' Eliminó el producto '||:old.nomprod;
END IF;
END IF;
IF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el producto '||:old.nomprod;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--Generar Venta
CREATE OR REPLACE TRIGGER AUDITORIA_DVENTA
AFTER INSERT OR UPDATE OR DELETE
ON DETALLEVENTA 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
suma number;
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
SELECT COUNT(*) into suma from detalleventa where idfacven=:new.idfacven;
IF INSERTING THEN
r_auditoria.descripcion:= ' incluyó la factura de venta N°: '||:new.idfacven||' Cantidad de producto: '||suma;
ELSIF UPDATING THEN
r_auditoria.descripcion:= ' Modifico directamente de la Base de Dato la factura de venta N° '||:old.idfacven;
ELSIF DELETING THEN
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos el Detalle De Venta N° '||:old.idfacven;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--

--Generar Compra
CREATE OR REPLACE TRIGGER AUDITORIA_COMPRA
AFTER INSERT OR UPDATE OR DELETE 
ON FACTURACOMPRA 
FOR EACH ROW
DECLARE
r_auditoria auditoria%ROWTYPE;
suma VARCHAR2(100);
get number;
pro VARCHAR2(100);
BEGIN
SELECT AUMENTARAUDITORIA.NEXTVAL INTO r_auditoria.idaud FROM dual;
SELECT idusu INTO r_auditoria.idusu FROM temp WHERE onli = 1;
SELECT rol INTO r_auditoria.rol FROM temp WHERE onli = 1;
SELECT sysdate INTO r_auditoria.fecha FROM dual;
SELECT nompro into pro from proveedor where idpro=:new.idpro;
IF INSERTING THEN
r_auditoria.descripcion:= ' Se generó el N° de Factura: '||:new.idfaccom||'  al proveedor: '||pro;
ELSIF UPDATING THEN
r_auditoria.descripcion:= ' Modifico directamente de la Base de Datos la Factura N°: '||:old.idfaccom;
ELSE
r_auditoria.descripcion:=' Elimino directamente de la Base de Datos la Factura N°: '||:old.idfaccom;
END IF;
INC_AUDITORIA(r_auditoria);
END;
/
--


--descontar
CREATE OR REPLACE TRIGGER AUDITORIA_DESCONT
AFTER INSERT
ON DETALLEVENTA 
FOR EACH ROW
DECLARE
BEGIN
update DETALLECOMPRA set cantidad=(cantidad-:new.CANDETVEN) where distinct (idprod=:new.idprod) and round(:new.valor)=round(valor-(valor*(descuento/100)));
END;
/
--


--Usuario
CREATE OR REPLACE TRIGGER AUDITORIA_NODEL
BEFORE UPDATE OR DELETE
ON USUARIO 
FOR EACH ROW
DECLARE
r_docu temp.idusu%TYPE;
BEGIN
select idusu into r_docu from temp where onli=1;
IF UPDATING('ESTADO') THEN
IF :old.DOCUSU=r_docu then
RAISE_APPLICATION_ERROR(-20023, 'Este operación no es permitida, contacte el
Administrador!.');
END IF;
END IF;
IF DELETING THEN
IF :old.DOCUSU=r_docu then
RAISE_APPLICATION_ERROR(-20023, 'Este operación no es permitida, contacte el
Administrador!.');
END IF;
END IF;
END;
/
--

--REACTIVAR
--CREATE OR REPLACE TRIGGER AUDITORIA_REACTIVAR
--BEFORE INSERT
--ON USUARIO 
--FOR EACH ROW
--DECLARE
--r_docu temp.idusu%TYPE;
--BEGIN
--select idusu into r_docu from temp where onli=1;
--IF INSERTING THEN
-IF :old.DOCUSU=:new.docusu then
--IF :old.ESTADO=0 THEN
--UPDATE USUARIO SET ESTADO=1 WHERE :old.docusu=:new.docusu;
--END IF;
--END IF;
--END IF;
--END;
--/
--
