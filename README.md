![ORACLE PL/SQL](/ORACLE.svg?raw=true)



## Índice de contenido

*   [¿Qué es PL/SQL?](#qué-es-plsql)

*   [Estructura](#Estructura)

*   [Estructura Bloques Anónimos](#Estructura-Bloques-Anónimos)

*   [Secuencias](#Secuencias)

*   [Estructura de Procedimiento](#Estructura-de-Procedimiento)

*   [Triggers o Disparadores](#Triggers-o-Disparadores)
    *   [TRIGGERS :NEW :OLD](#TRIGGERS-NEW-OLD)
    *   [Elevar Excepciones en el cuerpo del Disparados](#Elevar-Excepciones-en-el-cuerpo-del-Disparados)

*   [Funciones](#Funciones)

*   [Reglas y Convenciones del Lenguaje](#Reglas-y-Convenciones-del-Lenguaje)

*   [Delimitadores](#Delimitadores)

*   [Variables](#Variables)

*   [Constantes](#Constantes)

*   [Atributos %TYPE y %ROWTYPE](#Atributos-TYPE-y-ROWTYPE)

*   [REGISTROS](#REGISTROS)

*   [Transacción Savepoint, Rollback y Commit](#transacción-savepoint-rollback-y-commit)

*   [Tablas PL/SQL](#tablas-plsql)

*   [Operadores lógicos pl/sql](#operadores-lógicos-plsql)

*   [Condicionales](#Condicionales)

*   [Bucles (LOOPS)](#bucles-loops)

*   [Expresiones CASE](#Expresiones-CASE)

*   [GOTO y etiquetas](#GOTO-y-etiquetas)

*   [Cursores](#Cursores)

*   [Variables compuestas](#Variables-compuestas)

*   [Paquetes](#Paquetes)

*   [Excepciones](#Excepciones)

*   [Conceptos importantes de SQL](#Conceptos-importantes-de-SQL)
   *  [*CARDINALIDAD DE LAS RELACIONES*](#CARDINALIDAD-DE-LAS-RELACIONES)

*   [Otros](#Otros)


### **¿Qué es PL/SQL?**

Lenguaje de procesamiento procedimental, su objetivo es interactuar con la Base de Datos.

*   La unidad básica en PL/SQL es el bloque.
*   Todos los programas PL/SQL están compuestos por bloques, que pueden definirse de forma secuencial o estar anidados.
*   Normalmente cada bloque realiza una unidad lógica de trabajo en el programa, separando así unas tareas de otras.

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Estructura**

Hay diferentes tipos de bloques:

*   **Anónimos (Anonymous blocks)**: Es aquel que se construye de forma dinámica y se ejecuta una sola vez y no se almacena en la base de datos.
*   **Con nombre (Named blocks)**: Son bloques con nombre (Incluyen una cabecera) se compilan y almacena en la base de datos para su posterior ejecución.
    *   **Subprogramas**: Procedimientos, funciones o paquetes almacenados en la BD. No suelen cambiar después de su construcción y se ejecutan múltiples veces mediante una llamada al mismo.
    *   **Disparadores (Triggers)**: Son bloques con nombre que también se almacenan en la BD. Se ejecutan ante algún suceso  de disparo, que será una orden del lenguaje de manipulación de datos (CRUD) que se ejecuta sobre una tabla de BD.

## **Todos los bloques tienen tres secciones diferenciadas**
*   **Sección Declarativa**: Donde se localizan las variables, cursores, tipos usados por el bloque. Declaran las funciones y procedimientos locales.
*   **Sección Ejecutable**: Donde se lleva a cabo el trabajo del bloque. En esta sección pueden aparecer órdenes SQL, DDL, DML como órdenes procedimentales.
*   **Sección Errores**: El código de esta sección no se ejecutará a menos que ocurra un error.

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Estructura Bloques Anónimos**

```sql
DECLARE
    'Define objetos PL/SQL o variables que serán utilizados dentro del mismo bloque'
BEGIN
    'Sentencias Ejecutables'
EXCEPTION
    'Qué hacer si la acción ejecutada causa error'
END;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Secuencias**
Una secuencia sirve para generar automáticamente números distintos. Se utilizan para generar valores para campos que se utilizan como clave forzada (claves cuyo valor no interesa, sólo sirven para identificar los registros de una tabla).

Sintaxis:
```sql
CREATE SEQUENCE nombre_secuencia
[INCREMENT BY n]
[START WITH n]
[{MAXVALUE n|NOMAXVALUE}]
[{MINVALUE n|NOMINVALUE}]
[{CYCLE|NOCYCLE}]
```
Donde
| PARAMETRO | DESCRIPCIÓN |
|:---------:|:-----------:|
|`INCREMENT BY`|Indica cuánto se incrementa la secuencia cada vez que se usa. `Por defecto se incrementa de uno en uno`|
|`START WITH`|Indica el valor inicial de la secuencia `por defecto 1`|
|`MAXVALUE`|Máximo valor que puede tomar la secuencia. Si no se toma NOMAXVALUE que permite llegar hasta el 10^27|
|`MINVALUE`|Mínimo valor que puede tomar la secuencia. Por defecto -10^26|
|`CYCLE`|Hace que la secuencia vuelva a empezar si se ha llegado al máximo valor.|
#
Uso de la secuencia
Los métodos `NEXTVAL` y `CURRVAL` se utilizan para obtener el siguiente número y el valor actual de la secuencia respectivamente.

Ejemplo de uso
```sql
SELECT numeroPlanta.NEXTVAL FROM DUAL;
```
MODIFICAR SECUENCIAS
Se pueden modificar las secuencias, pero la modificación sólo puede afectar a los futuros valores de la secuencia, no a los ya utilizados. Sintaxis:
```sql
ALTER SEQUENCE secuencia
[INCREMENT BY n]
[START WITH n]
[{MAXVALUE n|NOMAXVALUE}]
[{MINVALUE n|NOMINVALUE}]
[{CYCLE|NOCYCLE}]
```

BORRAR SECUENCIA
```sql
DROP SEQUENCE nombre_secuencia;
```
-Ejemplo
```sql
CREATE SEQUENCE s_cliente
INCREMENT BY 1
START WITH 1
MAXVALUE 99999999999
```
```sql
INSERT INTO clientes(cliente, nombre_corto, fecha_creacion, usuario) VALUES(s_cliente.NEXTVAL, 'Daniel', sysdate, f_usuario);
```


#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Estructura-de-Procedimiento**
Un procedimiento PL/SQL es similar a los procedimientos de otros lenguajes de programación. Es un bloque con nombre que tiene la misma estructura que los bloques anónimos.

Sintaxis:
```sql
CREATE [OR REPLACE] PROCEDURE nombre_procedimiento
       [ (argumento [ { IN | OUT| IN OUT}]tipo,
      argumento [ { IN | OUT| IN OUT}] tipo)]{ IS | AS}
[SECCIÓN DE DECLARACIÓN DE VARIABLES SIN palabra clave DECLARE]
BEGIN
      cuerpo_procedimiento
[EXCEPTION]
END [nombre_procedimiento];
```
Para borrar un procedimiento:
```sql
DROP PROCEDURE nombre_procedimiento;
```

Los parámetros formales: `IN`, `OUT` o `IN OUT`.
*   Por defecto, el modo `IN`

Diferencias:
*   `IN`: El valor del parámetro se pasa al procedimiento cuando éste es invocado. Dentro del procedimiento el parámetro formal se considera como de solo lectura, y `no` puede ser cambiado. Cuando termina el procedimiento, y se devuelve el control al entorno que realizó la invocación, el parámetro no sufre cambios.
*   `OUT`: Se ignora cualquier valor que tenga el parámetro cuando se llama al procedimiento. Dentro del procedimiento, el parámetro formal se considera como de solo escritura, `no` puede ser leído, sino que tan solo pueden asignársele valores. Cuando termina el procedimiento y se devuelve el control al entorno que realizó la llamada, los contenidos del procedimiento formal se asignan al parámetro OUT.
*   `IN OUT`: Este modo es una combinación de IN y OUT. El valor del parámetro se pasa al procedimiento cuando éste es invocado: Dentro del procedimiento, el parámetro puede ser tanto leído como escrito. Cuando termina el procedimiento y se devuelve el control al entorno que realizó la llamada, los contenidos del parámetro se asignan al parámetro IN OUT.

### ***Script BD Libros***

```sql
DROP TABLE libros;
DROP TABLE tabla1; 
DROP TABLE control; 
DROP TABLE auditoria_libros; 
DROP TABLE ofertas; 
```

```sql
CREATE TABLE libros (
    idlibro NUMBER(12) NOT NULL,
    codigo number(6),
    titulo  VARCHAR2(20) NOT NULL,
    autor   VARCHAR2(20) NOT NULL,
    precio  NUMBER(20) NOT NULL,
    fecha   DATE NOT NULL,
    CONSTRAINT pklibros PRIMARY KEY ( idlibro )
);
CREATE TABLE tabla1 (
    titulo VARCHAR2(40),
    precio NUMBER(6, 2)
);
CREATE TABLE control (
    usuario VARCHAR2(40),
    fecha DATE
);
create table auditoria_libros( 
  usuario varchar2(30), 
  fecha date 
);
 create table ofertas(
  codigo number(6),
  precio number(6,2),
  usuario varchar2(20),
  fecha date
 );
```

```sql
CREATE SEQUENCE AUMENTARLIBRO; 
```

```sql
INSERT INTO libros (idlibro,codigo,titulo,autor,precio,fecha)
    SELECT aumentarlibro.NEXTVAL,
        round(dbms_random.value(0, 9999)),
        'Titulo ' || to_char(aumentarlibro.CURRVAL),           
        'Autor ' || to_char(aumentarlibro.CURRVAL),
        round(dbms_random.value(0, 3000000)),
        to_date('2021/'
                || round(dbms_random.value(1, 12))
                || '/'
                || round(dbms_random.value(1, 27))
                || ' 21:02:44', 'yyyy/mm/dd hh24:mi:ss')
    FROM dual
    CONNECT BY level <= 100;
```

##### -Ejemplo - APLICAR UN 5% DE DCTO A TODOS LOS LIBROS CON UN PROCEDIMIENTO ALMACENADO 
```sql
CREATE OR REPLACE PROCEDURE aumenta_precio AS
BEGIN
    UPDATE libros
    SET
        precio = precio + ( precio *.01 );

END aumenta_precio;
```
Probamos
```sql
execute aumenta_precio;
```

##### -Ejemplo (AUDITORÍA) - SELECCIONA UN AUTOR Y GUARDA ESE CAMPO EN LA TABLA1 CON EL TITULO Y EL PRECIO 
```sql
CREATE OR REPLACE PROCEDURE autorlibro (atitulo IN VARCHAR2) AS
    v_autor VARCHAR2(255);
BEGIN
    SELECT autor INTO v_autor
    FROM libros
    WHERE titulo = atitulo;

    INSERT INTO tabla1
        SELECT titulo, precio
        FROM libros
        WHERE autor = v_autor;

END autorlibro;
```
Probamos
```sql
execute autorlibro('Titulo 7'); 
```
Miramos la tabla1
```sql
select * from tabla1;
```

##### -Ejemplo - ACTUALIZAR SUELDO DE LOS EMPLEADOS QUE TENGAS MÁS DE 10 AÑOS EN LA EMPRESA UN 100% POR PARÁMETROS DE ENTRADA ([Script empleados,productos](#Script-empleados,productos))

```sql
CREATE OR REPLACE PROCEDURE aumentasueldo (anio IN NUMBER, porcentaje IN NUMBER ) AS
BEGIN
    UPDATE empleados
    SET
        sueldo = sueldo + ( sueldo * porcentaje / 100 )
    WHERE ( EXTRACT(YEAR FROM current_date) - EXTRACT(YEAR FROM fechaingreso) ) > anio;

END aumentasueldo;
```

```sql
execute aumentasueldo(10,100); 
```
Probamos
```sql
select * from empleados;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Triggers o Disparadores**

*   Tipos de Disparadores:
    *   DML sobre tablas (Insert, Delete, Update)
    *   Disparadores INSTEAD OF sobre vistas
    *   Disparadores del sistema sobre la BD o el Esquema.
*   Se ejecuta de manera implícita ante eventos:
    *   DML sobre tablas (Insert, Delete, Update)
    *   DDL (Create, Alter, Drop) (Actualizado con Oracle 9i)
    *   Operaciones de la BD (ServerError, Logon, Logoff, Startup, Shutdown)

Aplicaciones
*   Restricciones de Integridad complejas.
    *   IMPORTANTE: No se deben usar para garantizar el cumplimiento de las restricciones de integridad a nivel de esquema !!! (el esquema ha de contener toda la semántica que permita sin utilizar disparadores)
*   Auditoría: Registro de los cambios realizados y quién los realizó
*   Aviso automático a otros programas de llevar a cabo una determinada acción
*   Actualización en cascada

Utilización
*   Identificador único para cada elemento.
*   Tamaño del disparador: no superar los 32K (si es necesario crear objetos para llamar dentro del trigger)
*   Operaciones en el cuerpo del disparador: DML. (Insert, Delete, Update)
*   No disparadores recursivos: Agotan memoria.
*   Compilación cada vez que se ejecutan: más lentos.

Sintaxis

`Creación: (se activan al crearlos)`
```sql
CREATE [OR REPLACE] TRIGGER <nombre_disparador>
    {BEFORE | AFTER} evento ON referencia_tabla
    [ FOR EACH ROW [WHEN condición_evento]]
cuerpo_disparador;
```

`Eliminación:`
```sql
DROP TRIGGER nombre_disparador;
```

`Activación/Desactivación:`
```sql
ALTER TRIGGER nombre_disparador {DISABLE | ENABLE};

ALTER TABLE nombre_tabla
{ENABLE | DISABLE} ALL TRIGGERS;
```

*   `Evento:`
    *   Tipo de orden DML sobre una tabla que provoca la activación del disparador {`INSERT` | `DELETE` | `UPDATE` [OF <lista de columnas>]}. La lista de columnas sólo tiene sentido en el evento UPDATE
*   `Nivel`:
    *   FOR EACH ROW: disparadores con nivel de fila. Se activan una vez por cada fila afectada por el evento
    *   FOR EACH STATEMENT: disparadores con nivel de orden. Se activan sólo una vez (antes o después de la orden).
*   When:
    *   Sólo tiene sentido a nivel de fila. La condición se evalúa (true o false). No se pueden utilizar consultas anidadas.
* CONSTRAINS O RESTRICCIONES:
    *   Un disparador no puede emitir ninguna orden de control de transacciones (`COMMIT`, `ROLLBACK` o `SAVEPOINT`)
    *   Ningún procedimiento o función llamada por el disparador puede emitir órdenes de control de transacciones.
    *   No puede contener ninguna declaración de variables `LONG` o `LONG RAW`
    *   Restricciones en tablas a las que se puede acceder (Tablas Mutantes)
    *   No puede modificar las columnas de clave primaria

Temporalidad del evento : `AFTER/BEFORE`
*   BEFORE: `Ejecutan la acción asociada antes de que la sentencia sea ejecutada`
    *   Decidir si la acción debe realizarse o no
    *   Utilizar valores alternativos para la sentencia
Sintaxis:
```sql
CREATE TRIGGER NombreTrigger
    BEFORE Insert ON NombreTabla ….
```
*   AFTER: `Ejecutan la acción asociada después de que se haya ejecutado la sentencia`
Sintaxis:
```sql
CREATE TRIGGER NombreTrigger
    AFTER Insert ON NombreTabla ….
```

Scrip incial*

```sql
--borrar tablas (si existen)
 drop table libros;
 drop table control;

 --crear tablas
 create table libros(
  codigo number(6),
  titulo varchar2(40),
  autor varchar2(30),
  editorial varchar2(20),
  precio number(6,2)
 );
 create table control(
  usuario varchar2(30),
  fecha date
 );
```

-Ejemplo
```sql
create or replace trigger tr_ingresolibros
before insert
on libros
begin
 insert into control values(user, sysdate);
  end tr_ingresolibros;
```
ingresamos datos y provamos
```sql
insert into libros values(100, 'Uno','Richard Bach','Planeta',25);
insert into libros values(102, 'Matematica estas ahi','Paenza','Nuevo siglo',12);
select * from control;
```

-Ejemplo 1 `FOR EACH ROW / BEFORE INSERT` [Script empleados,productos](#Script-empleados,productos)*
```sql
create or replace trigger ingresaempleados
before insert
on empleados
for each row
  begin
    insert into control values( user, sysdate);
end ingresaempleados;
```
Ingresamos un dato y miramos la tabla de control
```sql
INSERT INTO empleados VALUES('12345678','Rios','Juan','San luis','Cobros',5000,to_date('16/02/2022','dd/mm/yyyy'));

SELECT * FROM control;
```
-Ejemplo 2 `FOR EACH ROW / BEFORE INSERT` ([Script BD Libros](#Script-BD-Libros))

```sql
create or replace trigger auditoria_libros 
before insert 
on libros 
for each row  --por cada linea 
  begin 
    insert into auditoria_libros values (user, sysdate); 
end auditoria_libros; 
```
Ingresamos un dato y miramos la tabla de control
```sql
INSERT INTO libros (idlibro,codigo,titulo,autor,precio,fecha)
    SELECT aumentarlibro.NEXTVAL,
        round(dbms_random.value(0, 9999)),
        'Titulo ' || to_char(aumentarlibro.CURRVAL),           
        'Autor ' || to_char(aumentarlibro.CURRVAL),
        round(dbms_random.value(0, 3000000)),
        to_date('2021/'
                || round(dbms_random.value(1, 12))
                || '/'
                || round(dbms_random.value(1, 27))
                || ' 21:02:44', 'yyyy/mm/dd hh24:mi:ss')
    FROM dual
    CONNECT BY level <= 100;



SELECT * FROM auditoria_libros;
```

-Ejemplo  `MÚLTIPLES EVENTOS` [Script empleados,productos](#Script-empleados,productos)*
```sql
CREATE OR REPLACE TRIGGER tr_control_empleados BEFORE
    INSERT OR UPDATE OR DELETE ON empleados
BEGIN
    IF inserting THEN
        INSERT INTO control_empleados VALUES (
            user,
            sysdate,
            'ingreso'
        );

    END IF;
    IF deleting THEN
        INSERT INTO control_empleados VALUES (
            user,
            sysdate,
            'borrado'
        );

    END IF;
    IF updating THEN
        INSERT INTO control_empleados VALUES (
            user,
            sysdate,
            'actualizacion'
        );

    END IF;
END tr_control_empleados;
```
Ingresamos datos y probamos
```sql
INSERT INTO empleados VALUES('12345678','Rios','Juan','San luis','Cobros',5000,to_date('16/02/2022','dd/mm/yyyy'));

UPDATE empleados set sueldo=2000 WHERE documento=12345678;

DELETE FROM empleados WHERE documento=12345678;

SELECT * FROM control_empleados;
```

### TRIGGERS `:NEW :OLD`
*   Con OLD.nombre_columna referenciamos:
    *   al valor que tenía la columna antes del cambio debido a una modificación
(UPDATE)
    *   al valor de una columna antes de una operación de borrado sobre la misma
(DELETE)
    *   al valor NULL para operaciones de inserción (INSERT)

*   Con NEW.nombre_columna referenciamos:
    *   Al valor de una nueva columna después de una operación de inserción
(INSERT)
    *   Al valor de una columna después de modificarla mediante una sentencia de
modificación (UPDATE)
    *   Al valor NULL para una operación de borrado (DELETE)


-Ejemplo  ` :NEW ` ([Script BD Libros](#Script-BD-Libros))
```sql
CREATE OR REPLACE TRIGGER tr_ingresalibros
BEFORE INSERT
ON libros
FOR EACH ROW
BEGIN
 IF(:new.precio<=30) THEN
   INSERT INTO ofertas VALUES(:NEW.codigo, :NEW.precio, user, sysdate);
   END IF;
   END tr_ingresalibros;
```
Lenamos datos para que se active el trigger y miramos la tabla ofertas
```sql
INSERT INTO libros VALUES(aumentarlibro.NEXTVAL,'1','Planeta','Richard Bach',35,to_date('2021/2/20 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO libros VALUES(aumentarlibro.NEXTVAL,'120','Rusia','Ataque a Ucrania',25,to_date('2011/2/20 21:02:44', 'yyyy/mm/dd hh24:mi:ss'));

SELECT * FROM ofertas;
```

-Ejemplo  ` :OLD`
```sql
CREATE OR REPLACE TRIGGER tr_actualizalibros
BEFORE UPDATE OF precio
ON libros
FOR EACH ROW
BEGIN
IF(:OLD.precio<=30) AND (:NEW.precio>30) THEN
DELETE FROM ofertas WHERE codigo=:OLD.codigo;
END IF;
 IF(:OLD.precio>30) AND (:NEW.precio<=30) THEN
 INSERT INTO ofertas VALUES(:NEW.codigo, :NEW.precio, user, sysdate);
 END IF;
END tr_actualizalibros;
```
Actualizamos datos para que se active el trigger y miramos la tabla ofertas
```sql
UPDATE libros SET precio = 29 WHERE codigo =1; --El precio anterior era de 35

SELECT * ofertas;
```

### Elevar `Excepciones` en el cuerpo del Disparados
```sql
RAISE_APPLICATION_ERROR (número_error, mensaje);
```
Número error en el rango: [-20000 y -20999]
```sql
CREATE OR REPLACE TRIGGER Ejemplo
    BEFORE DELETE ON tabla
    FOR EACH ROW
BEGIN
    IF :OLD.columna= valor_no_borrable THEN
    RAISE_APPLICATION_ERROR(-20000,‘La fila no se puede borrar’);
    END IF;
    ...
END ejemplo;
/
```


#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Funciones**

```sql
FUNCTION nombre 
RETURN tipo_dato IS
  Sección Declarativa
BEGIN
 Sección Ejecutable
 Return variable;
[EXCEPTION]
 Sección de Excepciones
END;
```

##### -Ejemplo 1
```sql
create or replace function f_prueba(valor number)
return number
is
 begin
   return valor*2;
end;
```
Prueba de la función
```sql
select f_prueba(2) as total from dual;
```

##### -Ejemplo 2
```sql
create or replace function f_costo(valor number)
return varchar
is
  costo varchar(20);
  begin
    costo:='';
    if valor<=500 then
    costo:='economico';
    else costo:='costoso';
    end if;
    return costo;
end;
```
Prueba de la función ([Script BD Libros](#Script-BD-Libros))
```sql
select titulo, autor, precio, f_costoso(precio) from libros;
```



#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Reglas y Convenciones del Lenguaje**
## Unidades Léxicas:

*   Conjunto de caracteres permitido en PL/SQL:
    *   Letras mayúsculas y minúsculas: A – Z y a – z
    *   Dígitos: 0 – 9
    *   Espacios en blanco: tabuladores, caracteres de espaciado y retorno de carro
    *   Símbolos matemáticos: + - * / < > =
    *   Símbolos de puntuación: ( ) { } [ ] ¿ ¡ ; : . ‘ “ @ # % ~ & _

## Identificadores
*   Se emplean para dar nombre a los objetos PL/SQL, tales como variables, cursores, tipos y subprogramas.
*   Los identificadores constan de una letra, seguida por una secuencia opcional de caracteres, que pueden incluir letras, números, signos de dólar **($)**, caracteres de subrayado **(_)** y símbolos de numero **(#)**. Los demás caracteres no pueden emplearse.
*   La longitud máxima de un identificador es de 30 caracteres y todos los caracteres son significativos.
#
#### Ejemplos Validos

`X, V_ENAME, CodEmp, V1, V2_, ES_UNA_VARIABLE_#, V_$_Cod
– Variables`

#### Ejemplos **MAL** declaradas

`X+Y , _ENAME, Cod Emp, 1V, ESTA ES …. VARIABLE (+ de 30 caracteres)`


#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Delimitadores**

| SIMBOLO | DESCRIPCIÓN | SIMBOLO |DESCRIPCIÓN |
|:-------:|:-----------:|:-------:|:----------:|
|+|Operador de suma|-|Operador de resta|
|*|Operador de multiplicación|/|Operador de división|
|=|Operador de igualdad|<|Operador "menor que"|
|>|Operador "mayor que"|(|Delimitador inicial de expresión|
|)|Delimitador final de expresión|;|Terminador de orden|
|%|Indicador de atributo|,|Separador de elementos|
|.|Selector de componente|@|Delimitador de enalce a BD|
|'|Delimitador cadena caracteres|"|Delimitador cadena entrecomillada|
|:|Indicador variable asignación|**|Operador de exponenciación|
|<>|Operador "distinto de"|!=|Operador "distinto de"|
|<=|Operador "menor o igual que"|>=|Operador "mayor o igual que"|
|:=|Operador de asignación|=>|Operador de asociación|
|\|\||Operador de concatenación|--|Comentario, una sola línea|
|<<|Comienzo de etiqueta|>>|Fin de etiqueta|
|*/|Cierre de comentario multilinea|\<space>|Espacio|
|\<tab>|Carácter de tabulación|\<cr>|Retorno de carro|


#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Variables**

*   Dos variables pueden tener el mismo nombre, si están en bloques diferentes.
*   El nombre de la variable (identificador) no debería ser el mismo que el de una columna de una tabla utilizada en el bloque.
*   Por defecto, todas las variables se inicializan a NULL.



### Asignación e Inicialización de Variables

*   Asignación:

```sql
identificador := expresión;
```

*   Inicialización:

```sql
identificador tipo_dato := expresión;
identificador tipo_dato DEFAULT valor;
identificador tipo_dato NOT NULL:= valor;
```

### Tipos de variables
*   **Numéricos**
    *   **NUMBER(P, S)**  Puede contener un valor numérico entero o de punto flotante, donde P es la precisión y S la escala. La precisión es el número de dígitos del valor, y la escala es la cantidad de dígitos a la derecha del punto decimal. La precisión máxima es 38 y la escala 127.
    *   **BINARY_INTEGER** Debido al formato interno de las variables de tipo NUMBER, las operaciones entre ellas requieren más tiempo de CPU que si utilizamos variables de tipo BINARY_INTEGER. Es recomendable su uso en contadores de bucles. Permite almacenar valores entre el rango -2147482647 y +2147482647.
*   **Carácter**
    *   **VARCHAR2(L)** Guarda una cadena de longitud variable de tamaño máximo L. En PL/SQL el valor máximo del tamaño de una variable de este tipo es 32.767 bytes, sin embargo las bases de datos Oracle sólo permiten campos de hasta 4.000 bytes.
    *   **CHAR(L)**  Análogo al VARCHAR2 pero guarda cadenas de longitud fija. Si no se especifica L, su valor por defecto es 1. El espacio sobrante de una variable CHAR se rellena con caracteres en blanco. En PLSQL el valor máximo del tamaño de una variable de este tipo es 32.767 bytes, sin embargo las bases de datos Oracle sólo permiten columnas de hasta 2.000 bytes.
    *   **LONG**  Este tipo, muy similar al VARCHAR2, se trata de una cadena de longitud variable de hasta 32.760 bytes. Los tipos de datos LONG de una base de datos Oracle son capaces almacenar hasta dos gigabytes.
*   **Fecha e Intervalo**
    *   **DATE** Guardar información sobre la fecha, hora, día, mes, año, hora, minuto y segundo. Las variables de este tipo no son capaces de almacenar milisegundos. Su tamaño es de 7 bytes.
    *   **TIMESTAMP[P]:** Con las características del tipo DATE pero además permite almacenar fracciones de segundo. El parámetro P es la precisión que por defecto es 6.
*   **Raw**
    *   **RAW** Almacena datos binarios de longitud fija. Los datos de tipo RAW no implican conversiones de carácter. La longitud máxima de una variable de este tipo es 32.767 bytes, sin embargo un campo de una tabla de tipo RAW sólo admite 2.000 bytes.
    *   **LONG RAW** Análogo al tipo de dato LONG, pero como el anterior no implican conversiones de carácter.
*   **Booleanos**
    *   **BOOLEAN** Sólo es capaz de guardar los valores TRUE (1) y FALSE (0). Las bases de datos Oracle no utilizan este tipo de dato pero si que se puede emplear dentro del código PL/SQL.
*   **Rowid**
    *   **ROWID** Este tipo de dato sirve para almacenar identificadores únicos de registros. Este identificador es con el que trabaja internamente la base de datos Oracle para identificar dichos registros.

##### -Ejemplo

```sql
DECLARE
identificador integer := 50;
nombre varchar2(25):= 'Jose Feliciano';
apodo char(10):= 'joselo';
sueldo number(5):=30000;
comision decimal(4,2):=50.20;
fecha_actual date :=(sysdate);
fecha date:=to_date('2020/07/09','yyyy/mm/dd');
saludo varchar2(50) default 'Buenos dias a todos';
BEGIN
dbms_output.put__line('El valor de la variable es: ' || identificador);
dbms_output.put_line('El nombre del usuario es: ' || nombre);
END;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Constantes**

Una constante en PL/SQL hace la misma función de una variable solo que se le coloca una palabra clave **constant** frente a cada delcaración de variable, la particularidad de una constante es que su valor no cambia a medida que se ejecuta el programa en PL/SQL por lo que no permiten que su valor sea cambiado.

#### -Ejemplo

```sql
declare
   mensaje constant varchar2(30):='buenos dias a todos';
   numero constant number(6):=30000;
begin
   dbms_output.put_line(mensaje);
   dbms_output.put_line(numero);
end;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Atributos %TYPE y %ROWTYPE**

##  **Atributo \%TYPE**

Permite declarar una variable basada en:

*   Otras variables previamente declaradas
*   La definición de una columna de la base de datos

*   **Preceder de %TYPE por:**
    *   La tabla y la columna de la base de datos
    *   El nombre de la variable definida con anterioridad

#### -Ejemplo

```sql
v_cliente clientes.cliente%TYPE;
```

##  **Atributo \%ROWTYPE**

Se utiliza para declarar un Record que contenga toda la fila de una tabla o vista.

*   Define un registro con la estructura de la tabla o vista de la BD
*   Los campos del registro toman sus nombres y tipos de datos de las columnas de la vista o tabla.

*   **Preceder de %TYPE por:**
    *   La tabla y la columna de la base de datos
    *   El nombre de la variable definida con anterioridad

#### -Ejemplo

```sql
DECLARE
    v_clientes cliente%ROWTYPE;
BEGIN
    -- Inicialización de campos de la variable
    v_clientes.cliente:='9999999999';
    v_clientes.nombre_corto:='Pedro Perez';
    v_clientes.clase_cliente:='B';
    DBMS_OUTPUT.PUT_LINE(v_clientes.cliente||' '|| v_clientes.nombre_corto||' '|| v_clientes.clase_cliente);
END;
/
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **REGISTROS**

También se pueden asignar valores de un registro completo mediante un SELECT que extraería los datos de la BD y los almacena en el registro.

Sintaxis:

```sql
TYPE nombre_registro IS RECORD (declaración_campo [, declaración_campo] ...);
```
#### -Ejemplo

```sql
TYPE R_registro IS RECORD (
cliente clientes.cliente%TYPE,
nombre clientes.nombre_corto%TYPE,
clase clientes.clase_cliente%TYPE);
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Transacción Savepoint, Rollback y Commit**

Una transacción es un grupo de declaraciones de cálculo de datos SQL que funcionan como una unidad atómica. Todas las transacciones son de naturaleza atómica, que se comprometen o se restituyen.

*   **COMMIT** finaliza la transacción actual realizando todos los cambios pendientes en la BD
SINTAXIS:
```sql
COMMIT [WORK] [COMMENT 'comment_text']
COMMIT [WORK] [FORCE 'force_text' [,int] ]
```
*   **ROLLBACK** finaliza la transacción actual desechando todos los cambios pendientes
SINTAXIS:
```sql
ROLLBACK [WORK] [TO [SAVEPOINT]'savepoint_text_identifier'];
ROLLBACK [WORK] [FORCE 'force_text'];
```
*   **SAVEPOINT** Guarda el estado actual de la BD y lo guarda en un punto de guardado
SINTAXIS:
```sql
SAVEPOINT identificador;
```

#### -Ejemplo:
```sql
UPDATE T_PEDIDOS
SET NOMBRE='jorge'
WHERE CODPEDIDO=125; 

SAVEPOINT solouno; 

UPDATE T_PEDIDOS
SET NOMBRE = 'jorge'; 

SAVEPOINT todos; 

SELECT * FROM T_PEDIDOS; 

ROLLBACK TO SAVEPOINT todos; 

COMMIT;
```
Solo guardamos la primera modificación.

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Tablas PL/SQL**

*   Cuentan con 2 elementos
    *   TIPO DE DATOS DE CLAVE PRIMARIA BINARY_INTEGER
    *   COLUMNA DE TIPO DE DATOS ESCALARES O DE REGISTRO.
*   Aumentan dinámicamente porque no tienen restricciones.
*   Se almacenan en memoria.

#### -Ejemplo 1

```sql
DECLARE
TYPE tipo_tabla_nombre IS TABLE OF emp.ename%TYPE
     INDEX BY BINARY_INTEGER;
TYPE tipo_tabla_fecha IS TABLE OF DATE
     INDEX BY BINARY_INTEGER;
tabla_nombre tipo_tabla_nombre;
tabla_fecha
BEGIN
            tipo_tabla_fecha;
      tabla_nombre(1):= 'CAMERON';
      tabla_fecha(8) := SYSDATE + 7;
      IF tabla_nombre.EXIST(1) THEN
            INSERT INTO .."
END;
```
##  ATRIBUTOS DE LA TABLA

| Atributo | DESCRIPCIÓN |
|:---------|:-----------:|
|`COUNT`|Devuelve el número de elementos de la tabla V_Tabla.Count -> 10|
|`DELETE(I)`|Borra fila de la tabla V_Tabla.Delete(2) -> borra elemento de la posición 2 de la tabla V_Tabla (no se redistribuyen)|
|`DELETE(I,S)`|Borra filas de la tabla V_Tabla.Delete(2,4) -> borra de la posición 2 a la 4 de la tabla V_Tabla|
|`EXISTS BOOLEAN`|Devuelve TRUE si existe en la tabla el elemento especificado. V_Tabla.Exists(1) -> TRUE|
|`FIRST BINARY_INTEGER`|Devuelve el índice de la primera fila de la tabla. V_Tabla.First -> 1|
|`LAST BINARY_INTEGER`|Devuelve el índice de la primera fila de la tabla. V_Tabla.Last -> 10|
|`NEXT BINARY_INTEGER`|Devuelve el índice de la fila de la tabla que sigue a la fila especificada. V_Tabla.Next -> índice siguiente|
|`PRIOR BINARY_INTEGER`|Devuelve el índice de la fila de la tabla que antecede a la fila especificada, V_Tabla.Prior -> índice anterior|

#### -Ejemplo 2

```sql
DECLARE
    TYPE tipo_tabla IS TABLE OF INTEGER;
    V_tabla tipo_tabla := tipo_tabla (0,1,2,3,4,5,6,7,8,9);
    I number;
BEGIN
    DBMS_OUTPUT.PUT_LINE(V_tabla(5));
    DBMS_OUTPUT.PUT_LINE(V_tabla(10));
    DBMS_OUTPUT.PUT_LINE(V_tabla.count);
    DBMS_OUTPUT.PUT_LINE(V_tabla.last);
    DBMS_OUTPUT.PUT_LINE(V_tabla.first);
    I := V_tabla.next(v_tabla(5));
    DBMS_OUTPUT.PUT_LINE(i);
    I := V_tabla.prior(v_tabla(5));
    DBMS_OUTPUT.PUT_LINE(i);
    If v_tabla.exists(11) then
    DBMS_OUTPUT.PUT_LINE(‘Si existe el once’);
    Else
    DBMS_OUTPUT.PUT_LINE(‘No existe el once’);
    End if;
    V_tabla.delete(2);
    DBMS_OUTPUT.PUT_LINE(V_tabla(2));
END;
/
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Operadores lógicos pl/sql**

| Operador | DESCRIPCIÓN |
|:--------:|:-----------:|
|`**, NOT`|Exponenciación, negación lógica|
|`*, /`|Multiplicación, división|
|`+, -, \|\|`|Suma, resta, concatenación|
|`=, !=, <, >, <=, >=, IS NULL, LIKE, BETWEEN, IN`|Comparación|
|`AND`|AND|
|`OR`|Inclusión|


#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Condicionales**

Son estructuras de toma de decisiones requieren que el
programador especifique una o más condiciones para ser
evaluadas o probadas por el programa, junto con una
declaración o declaraciones que se ejecutarán si se
determina que la condición es verdadera y, opcionalmente,
otras declaraciones que se ejecutarán si el se determina
que la condición es falsa.

### Sentencias IF Condicionales

*   IF-THEN
*   IF-THEN-ELSE
*   IF-THEN-ELSIF

#### -Ejemplo 1
```SQL
DECLARE
  a number(2):=10;
  b number (2):=20;
BEGIN
  if a > b then
     dbms_output.put_line(a || ' es mayor que:' || b);
   else
     dbms_output.put_line(b || ' es mayor que' || a);
   end if;
END;
```
#### -Ejemplo 2
```SQL
DECLARE
  numero number(3):=100;
BEGIN
  if (numero = 10) then
     dbms_output.put_line(' valor de numero es 10');
  elsif (numero = 20) then
      dbms_output.put_line(' valor de numero es 20');
  elsif (numero = 30) then
      dbms_output.put_line(' valor de numero es 30');
  else
      dbms_output.put_line(' ninguno de los valores fué encontrado');
  end if;
     dbms_output.put_line(' El valor exacto de la variable es: ' || numero);
END;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Bucles (LOOPS)**

### Control de bucles

*   Bucle básico LOOP
*   Bucle FOR
*   Bucle WHILE

    *   LOOP BASICO
    ```sql
    LOOP
    secuencia de instrucciones;
    EXIT [WHEN condición];
    END LOOP;
    ```    
    *   WHILE LOOP
    ```sql
    WHILE condición LOOP
    secuencia de instrucciones;
    END LOOP;
    ```
    *   FOR
    ```sql
    FOR contador IN valor1..valor2 LOOP
    secuencia de instrucciones;
    END LOOP;
    ```
    *   LOOP ANIDADOS
    ```sql
    LOOP
        secuencia de instrucciones;
        LOOP
            secuencia de instrucciones;
        END LOOP;
    END LOOP;
    ```
##### -Ejemplo 1 LOOP

```SQL
begin
    LOOP
        dbms_output.put_line(valor);
        valor:=valor + 10;
    IF valor> 50 THEN
        exit;
        END IF;
    END LOOP;
    dbms_output.put_line('Valor final =' || valor);
END;
```
##### -Ejemplo 2 LOOP-EXIT

```SQL
DECLARE
    vl_contador PLS_INTEGER := 1;
BEGIN
    LOOP
        INSERT INTO Tabla (Valor)
        VALUES (vl_contador);
        vl_contador := vl_contador + 1;
        EXIT WHEN vl_contador = 10;
    END LOOP;
END;
```
##### -Ejemplo 3 WHILE

```SQL
DECLARE
    valor NUMBER (2):=1;
 BEGIN
    WHILE valor <= 20 LOOP
     dbms_output.put_line('El valor es: ' || valor);
      valor := valor + 1;
    END LOOP;
 END;
```
##### -Ejemplo 4 FOR

```SQL
DECLARE
  numero NUMBER (2);
BEGIN
 FOR numero IN 10..20 LOOP
   dbms_output.put_line('valor de numero: ' || numero);
  END LOOP;
END;
```
##### -Ejemplo 5 BUCLES ANIDADOS

```SQL
DECLARE
  buclel number:=0;
  bucle2 number;
BEGIN
     LOOP
     dbms_output.put_line('-----');
     dbms_output.put_line('Valor de bucle externo =' || bucle1);
       dbms_output.put_line(' --------');
       bucle2 :=0:
        LOOP
        dbms_output.put_line('Valor de bucle anidado =' || bucle2);
            bucle2:=bucle2+1;
        EXIT WHEN bucle2=5;
        END LOOP;
       buclel:-buclel+1;
     EXIT WHEN buclel=3;
    END LOOP;
END;
```


#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Expresiones CASE**

La instrucción `CASE` es una evolución en el control lógico.
Se diferencia de las estructuras `IF-THEN-ELSE` en que se puede utilizar una estructura simple para realizar selecciones lógicas en una lista de valores

Puede utilizarse también para establecer el valor de una variable.

Su sintaxis es:

```sql
CASE [variable]
    WHEN expresión1 THEN valor1;
    WHEN expresión2 THEN valor2;
    WHEN expresión3 THEN valor3;
    WHEN expresión4 THEN valor4;
    ELSE valor5;
END CASE;
```
No existe límite para el número de expresiones que se pueden definir en una expresión CASE.

##### -Ejemplo 1

```SQL
DECLARE
    vl_equipo varchar2(100);
    vl_ciudad varchar2(50) := ‘BUCARAMANGA’;
BEGIN
    CASE ciudad
        WHEN ‘BUCARAMANGA’ THEN
            vl_equipo := ‘Atlético Bucaramanga’;
        WHEN ‘MEDELLIN’ THEN
            vl_equipo :=‘Atlético Nacional’;
        WHEN ‘CALI’ THEN
            vl_equipo := ‘Deportivo Cali’;
        ELSE
            vl_equipo := ‘SIN EQUIPO’;
    END CASE;
    DBMS_OUTPUT.PUT_LINE(vl_equipo);
END;
/
```
##### -Ejemplo 2

```SQL
CASE
    WHEN vl_precio < 11 THEN
        vl_descuento := 2;
    WHEN vl_precio > 10 AND vl_precio < 25 THEN
        vl_descuento := 5;
    WHEN vl_precio > 24 THEN
        vl_descuento := 10;
    ELSE
        vl_descuento := 15;
END CASE;
/
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **GOTO y etiquetas**

GOTO es como la abreviatura de "ir a", es un punto donde en un momendo dado llegue el programa

Su sintaxis es:
```SQL
GOTO <Etiqueta>;
```
donde <Etiqueta> es una etiqueta definida en el bloque PL/SQL.
##### -Ejemplo

```SQL
BEGIN
    DBMS_OUTPUT.PUT_LINE(‘Esto es un ejemplo.’);
    GOTO Etiqueta_1;
    DBMS_OUTPUT.PUT_LINE(‘No hace el GOTO.’);
    <<Etiqueta_1>>
    DBMS_OUTPUT.PUT_LINE(‘Entra en el GOTO.’);
END;
```
Para hacer más legible el bloque de ejecución con manejadores de excepciones complejos en bloques anidados.

### **Restricciones de GOTO**
*   No se puede saltar al interior de un bloque anidado
*   No se puede saltar al interior de un bucle
*   No se puede saltar al interior de una orden IF

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Cursores**

*   Útiles para las consultas que devuelven más de una fila.
*   Son declarados y nombrados por el programador, y manipulados por medio de sentencias específicas en las acciones ejecutables del bloque.
*   Son una gran herramienta para generar reportes.

### Control de Cursores
1. Crear un área SQL especifica **DECLARE**
2. Identificar el juego activo **OPEN**
3. Cargar la fila actual en variables **FETCH**
4. Si todavía existen filas sin leer, volver a 3°.
5. Si no existen más filas a leer **CLOSE**

### Tipos de cursores
*   Cursores implícitos
*   Cursores explícitos
    *   Se utiliza cuando una consulta devuelve un conjunto de registros y ocasionalmente se utilizan tambien en consultas que devuelven un único registro.

Sintaxis:
```sql
CURSOR nombre_cursor IS sentencia_select;
```

### Atributos de cursores
*   **%ISOPEN** Devuelve **"true"** si el cursor está abierto.
*   **%FOUND** Devuelve **"true"** si el registro fue satisfactoriamente procesado
*   **%NOTFOUND** Devuelve **"true"** si el registro no pudo ser procesado. Normalmente esto ocurre cuando ya se han procesado todos los registros devueltos por el cursor.
*   **%ROWCOUNT** Devuelve el número de registros que han sido procesados hasta ese momento.

#
*   No incluya la cláusula INTO en la declaración del cursor.
*   Si es necesario procesar filas en algún orden, incluya la cláusula ORDER BY.
*   El nombre del cursor es un identificador PL/SQL, y ha de ser declarado en la sección declarativa del bloque antes de poder hacer referencia a él.

##### -Ejemplo de delcaración
```sql
DECLARE

CURSOR C_clientes IS
SELECT
FROM clientes;

BEGIN
...  
END;
```
Apertura del Cursor:
```sql
OPEN nombre_cursor;
```

### ***Script empleados,productos***
Codigo incial para el ejemplo*
```sql
DROP TABLE empleados;
DROP TABLE productos;
DROP TABLE control_empleados;
```
```sql
 CREATE TABLE empleados(
  documento CHAR(10),
  apellido VARCHAR2(30),
  nombre VARCHAR2(30),
  domicilio VARCHAR2(30),
  seccion VARCHAR2(20),
  sueldo NUMBER(8,2),
  fechaingreso DATE
 );
 CREATE TABLE productos (
codigo INT NOT NULL PRIMARY KEY,
nombre VARCHAR2(100) NOT NULL,
precio NUMBER(6,2) NOT NULL,
codigo_fabricante INT NOT NULL);

CREATE TABLE control_empleados(
usuario VARCHAR2(20),
fecha DATE,
accion VARCHAR(20));
```
```sql
 INSERT INTO empleados VALUES('22222222','Acosta','Ana','Avellaneda 11','Secretaria',1800,to_date('18/10/1980','dd/mm/yyyy'));
 INSERT INTO empleados VALUES('23333333','Bustos','Betina','Bulnes 22','Gerencia',5000, to_date('12/05/1998','dd/mm/yyyy'));
 INSERT INTO empleados VALUES('24444444','Caseres','Carlos','Colon 333','Contabilidad',3000, to_date('25/08/1990','dd/mm/yyyy'));
 INSERT INTO empleados VALUES('32323255','Gonzales','Miguel','Calle 4ta No.90','Contabilidad',8000,to_date('05/05/2000','dd/mm/yyyy'));
 INSERT INTO empleados VALUES('56565555','Suarez','Tomas','Atarazana 78','Cobros',1500,to_date('24/10/2005','dd/mm/yyyy'));
 
INSERT INTO productos VALUES(1, 'Disco duro SATA· 1TB', 86.99, 5);
INSERT INTO productos VALUES(2 , 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO productos VALUES(3, 'DISCO SSD 1 TB', 150.99, 4);
INSERT INTO productos VALUES(4, 'GEFORCE GTX 1050Ti', 185, 7);
INSERT INTO productos VALUES(5, 'GEFORCE GTX 1080TI', 755, 6);
INSERT INTO productos VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO productos VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO productos VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO productos VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO productos VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO productos VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);
```
##### -Ejemplo `CURSORES IMPLICITOS`
Cursor
```sql
DECLARE
  filas NUMBER(2);
BEGIN
  UPDATE empleados
  SET sueldo = sueldo + 500 WHERE sueldo>=9000;
  IF SQL%notfound THEN
    dbms_output.put_line('==NO HAY EMPLEADOS DISPONIBLES==');
    elsif SQL%found THEN
    filas:=SQL%rowcount;
    dbms_output.put_line(filas || ': EMPLEADOS ACTUALIZADOS');
  END IF;
END;
```

#

##### -Ejemplo `CURSORES EXPLICITOS`
```sql
DECLARE
    v_docu empleados.documento%TYPE;
    v_nom empleados.nombre%TYPE;
    v_ape emleados.apellido%TYPE;
    v_suel empleados.sueldo%TYPE;
  CURSOR c_cursor2 is
     SELECT documento, nombre,apellido, sueldo I
     FROM empleados
     WHERE documento=22222222;
BEGIN
 OPEN c_cursor2;
  FETCH c_cursor2 into v_docu,v_nom,v_ape,v_suel;
  CLOSE c_cursor2;
  dbms_output.put_line('Documento: ' || v_docu);
  dbms_output.put_line('Nombre:' ||v_nom);
  dbms_output.put_line('Apellido: ' ||v_ape);
  dbms_output.put_line('Sueldo: '||v_suel);
END;
```
##### -Ejemplo `CURSORES EXPLICITOS` 2
A medida que vaya recorriendo toda la tabal de empleados, va a ir tomando 
cada campo de la tabla y a través de unasalida de datos, va a tomar nuestra variable de `%ROWTYPE`.campo_tabla que se visualice en la salida de datos.

```sql
DECLARE
    v_docu empleados.documento%TYPE;
    v_nom empleados.nombre%TYPE;
    v_ape emleados.apellido%TYPE;
    v_suel empleados.sueldo%TYPE;
  CURSOR c_cursor2 is
     SELECT documento, nombre,apellido, sueldo I
     FROM empleados
     WHERE documento=22222222;
BEGIN
 OPEN c_cursor2;
  FETCH c_cursor2 INTO v_docu,v_nom,v_ape,v_suel;
  CLOSE c_cursor2;
  DBMS_OUTPUT.PUT_LINE('Documento: ' || v_docu);
  DBMS_OUTPUT.PUT_LINE('Nombre:' ||v_nom);
  DBMS_OUTPUT.PUT_LINE('Apellido: ' ||v_ape);
  DBMS_OUTPUT.PUT_LINE('Sueldo: '||v_suel);
END;
```

##### -Ejemplo `CURSORES EXPLICITOS` ACTUALIZANDO DATOS DE UNA TABLA SQL
*   Cursor que nos permita recorrer todos los registros de una tabla y que nos muestre los datos por consola

```sql
BEGIN
 UPDATE empleados set sueldo = 10000
 WHERE documento = '23333333';
 IF SQL%notfound then
  DBMS_OUTPUT.PUT_LINE('NO EXISTE REGISTRO PARA MODIFICAR');
 END IF;
END;
```
##### -Ejemplo `FOR UPDATE Y WHERE CURRENT OF`
### FOR UPDATE
*   El bloqueo explícito le permite denegar el acceso mientras dura una transacción.
*   Bloquee las filas antes de la actualización o supresión.
*   La cláusula FOR UPDATE es la última cláusula de una sentencia SELECT, incluso después del ORDER BY.
*   NOWAIT devuelve un error de Oracle si las filas han sido bloqueadas por otra sesión, de lo contrario se espera.
*   Donde nombre_columna es una columna o lista de columnas de la tabla sobre la que se realiza la consulta (la/s que se va/n a modificar).
#
### WHERE CURRENT OF
*   Incluya la cláusula FOR UPDATE en la definición del cursor para bloquear las filas.
*   Especifique WHERE CURRENT OF en la sentencia UPDATE o DELETE para referirse a la fila actual del cursor.
```sql
DECLARE
-- Variable para añadir estos créditos al total de cada estudiante
V_Creditos Clases.num_creditos%TYPE;

-- Cursor que selecciona los estudiantes matriculados en 3º de Informática
CURSOR c_EstudiantesRegistrados IS
    SELECT *
        FROM Estudiantes
    WHERE Id_Estudiante IN (SELECT Id_Estudiante
                            FROM Estudiante_Registrado
                            WHERE Departamento=‘INF’AND Curso=‘3’)
FOR UPDATE OF Creditos_Actuales;

BEGIN
    FOR V_Estudiantes IN C_EstudiantesRegistrados LOOP
    -- Selecciona los créditos de 3º de Informática
        SELECT num_creditos
            INTO V_Creditos
        FROM Clases
        WHERE Departamento=‘INF’
        AND Curso='3';
    -- Actualiza la fila que acaba de recuperar con el cursor
        UPDATE Estudiantes
            Set Creditos_Actuales=Creditos_Actuales+V_Creditos
            WHERE CURRENT OF C_EstudiantesRegistrados;
    END LOOP;
COMMIT;
END;
/
```
##### -Ejemplo `CURSORES EXPLICITOS CON PARAMETROS`
```sql
DECLARE
    v_nom empleados.nombre%TYPE;
    v_sec empleados.seccion%TYPE;
    CURSOR c_empleados ( doc empleados.documento%TYPE )
        IS
        SELECT
            nombre, seccion
        FROM empleados
        WHERE documento = doc;
BEGIN
    OPEN c_empleados(56565555);
    LOOP
        FETCH c_empleados INTO
            v_nom, v_sec;
        EXIT WHEN c_empleados%notfound;
        dbms_output.put_line('Empleado: '|| v_nom|| ', Sección: '|| v_sec);
    END LOOP;
    CLOSE c_empleados;
END;
```
##### -Ejemplo `REF CURSORS`
*   Puede apuntar o hacer refrencia a un resultado de un cursor normal
```sql
create or replace function f_datoemepleados (v_valor1 in number, v_valor2 in number)
return sys_refcursor
is
 v_ref sys_refcursor;
begin
  open v_ref for select * from empleados
 where documento in (v_valor1,v_valor2);
  return v_ref;
end;
```
Probamos la función
```sql
SELECT f_datoemepleados(22222222,24444444) from dual;
```
Ver la infromación en forma de tabla
```sql
var rc1 refcursor
exec :rc1:=f_datoemepleados(22222222,23333333);
print rc1;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Variables compuestas**
Guardan una fila de una tabla
```sql
DECLARE
  reg_productos productos%rowtype;
BEGIN
  SELECT * INTO REG_PRODUCTOS FROM PRODUCTOS
  WHERE codigo = 3;
  dbms_output.put_line('CARACTERISTICA DEL PRODUCTO');
  dbms_output.put_line('Codigo de producto: '|| reg_productos.codigo);
  dbms_output.put_line('Articulo: ' || reg_productos.nombre);
  dbms_output.put_line('Precio: ' || reg_productos.precio);
  dbms_output.put_line('Serial: '|| reg_productos.codigo_fabricante);
END;
```

##### -Ejemplo `VARIABLE COMPUESTA CON CURSOR`
*   Puede apuntar o hacer refrencia a un resultado de un cursor normal
```sql
declare
  cursor cu_productos is
  select * from productos;
  var_productos cu_productos%rowtype;
begin
  open cu_productos;
  loop
    fetch cu_productos into var_productos;
    exit when cu_productos%notfound;
    dbms_output.put_line(var_productos.codigo ||' '|| var_productos.nombre);
  end loop;
end;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Paquetes**
Son un grupo lógico de objetos de la base de datos tales como:
*   Registros de datos PL/SQL
*   Variables
*   Estructura de datos
*   Excepciones
*   Subprogramas
*   Procedimientos
*   Funciones

Estos objetos se relacionan entre sí, encapsulados y convertidos en una unidad dentro de la base de datos.

Ámbito para los paquetes
*   Cualquier objeto declarado en la cabecera de un paquete está dentro de ámbito y es visible fuera del paquete, sin más que cualificar el objeto con el nombre del paquete.
*   La llamada al procedimiento es igual que si fuera un procedimiento independiente. La única diferencia es que hay que incluir como prefijo el nombre del paquete.
•Los procedimientos empaquetados pueden tener parámetros predeterminados, y pueden ser llamados utilizando notación posicional o nominal (indicando el valor para cada parámetro parametro1=>Variable1), al igual que los procedimientos almacenados independientes.
*   Dentro del cuerpo del paquete se puede hacer referencia a los objetos definidos en la cabecera sin necesidad de utilizar el nombre del paquete.

-Ejemplo
```sql
CREATE OR REPLACE PACKAGE los_productos AS
PROCEDURE caracteristicas(v_codigo productos.codigo%TYPE);
END los_productos;
```
```sql
CREATE OR REPLACE PACKAGE BODY los_productos AS
PROCEDURE caracteristicas(v_codigo productos.codigo%TYPE) IS
  v_producto productos.nombre%TYPE;
  v_precio productos.precio%TYPE;
BEGIN
  SELECT nombre, precio INTO v_producto, v_precio
  FROM productos WHERE codigo = v_codigo;
  dbms_output.put_line('Articulo: ' || v_producto);
  dbms_output.put_line('Precio: ' ||v_precio);
  END caracteristicas;
END los_productos;
```
```sql
BEGIN
 los_productos.caracteristicas(3);
END;
```

#### Sobrecarga de los subprogramas de un paquete
Dentro de un paquete pueden sobrecargarse los procedimientos y funciones, es decir, puede haber más de un procedimiento o función con el mismo nombre, pero con distintos parámetros.

Esta característica es muy útil, dado que permite aplicar la misma operación a objetos de tipos diferentes.

Ejemplo:

Supongamos que queremos añadir un estudiante a una clase, bien especificando el número de identificación del estudiante, bien especificando el nombre y apellidos:
```sql
CREATE OR REPLACE PACKAGE PaqueteCurso AS
PROCEDURE EstudianteNuevo (P_ID_Estudiante IN Estudiantes.ID%TYPE,
                            P_Departamento IN CLASES.DEPARTMENTO%TYPE,
                            P_Curso IN CLASES.Curso%TYPE);
PROCEDURE EstudianteNuevo (P_Nombre IN Estudiantes.Nombre%TYPE,
                            P_Apellidos IN Estudiantes.Apellidos%TYPE,
                            P_Departamento IN CLASES.DEPARTMENTO%TYPE,
                            P_Curso IN CLASES.Curso%TYPE);
END PaqueteCurso;
```
```sql
CREATE OR REPLACE PACKAGE PaqueteCurso BODY AS
PROCEDURE EstudianteNuevo (P_ID_Estudiante IN Estudiantes.ID%TYPE,
P_Departamento IN Clases.Departamento%TYPE,
P_Curso IN Clases.Curso%TYPE) IS
BEGIN
INSERT INTO Estudiantes_Matriculados (Id_Estudiante, Departamento, Curso)
VALUES ( P_ID_Estudiante, P_Departamento, P_Curso);
COMMIT;
END;
PROCEDURE EstudianteNuevo (P_Nombre IN Estudiantes.Nombre% TYPE,
P_Apellidos IN Estudiantes.Apellidos%TYPE,
P_Departamento IN Clases.Departamento%TYPE,
P_Curso IN Clases.Curso%TYPE) IS DECLARE
    v_id_estudiante estudiantes.id%TYPE;
BEGIN
    SELECT ID INTO v_id_estudiante
    FROM estudiantes
    WHERE nombre = p_nombre AND apellidos = p_apellidos;

    INSERT INTO estudiantes_matriculados (id_estudiante,
                                          departamento,
                                          curso)
        VALUES (v_id_estudiante,p_departamento,p_curso);
    COMMIT;
END estudiantenuevo;
END PaqueteCurso;
```
Con esto podremos añadir un estudiante a la clase de dos formas:

Primera opción:
```sql
BEGIN
    PaqueteCurso.EstudianteNuevo (10000, ‘ORA’,150);
END;
```
Segunda opción:
```sql
BEGIN
    PaqueteCurso.EstudianteNuevo (‘JAVIER’, ‘LOPEZ’ ,‘ORA’ ,150);
END;
```

La sobrecarga puede ser muy útil cuando se pueda hacer la misma operación con argumentos de tipos diferentes. Sin embargo, la sobrecarga está sujeta a diversas restricciones.
*   No se puede sobrecargar dos subprogramas si sus parámetros sólo difieren
en el nombre o en el modo.
*   No pueden sobrecargarse dos funciones basándose sólo en su tipo de retorno.
*   Finalmente, los parámetros de las funciones sobrecargadas deben diferir también en cuanto a familia de tipos, no pudiendo realizarse sobrecargas dentro de la misma familia. Por ejemplo, CHAR y VARCHAR2, que pertenecen a la misma familia de tipos.

#
[🔝 Volver al índice](#índice-de-contenido)
#


### **Excepciones**
*   Es un identificador PL/SQL que surge durante la ejecución.
*   Se produce por un error Oracle o bien puede ser provocada explícitamente.
*   Se gestiona interrumpiendo con un manejador de excepciones o propagándola al entorno de llamadas

### Las excepciones
*   Son declaradas en la sección de declaración.
*    Son lanzadas en la seccion de ejecución y resueltas en la sección de excepciones.

Sintaxis:

```sql
EXCEPTION
   WHEN excepcióni [OR excepción2 ..] THEN
         sentencias;
  [WHEN excepción3 [OR excepción4 ..] THEN
         sentencias; ]
  [WHEN OTHERS THEN
         sentencias; ]
```
| NOMBRE DE LA EXCEPCIÓN | NÚMERO DE ERROR ORACLE | DESCRIPCIÓN |
|:----------------------:|:----------------------:|:-----------:|
|**NO_DATA_FOUND**|ORA-01403|La sentencia `SELECT` no devolvió datos.|
|**TOO_MANY_ROWS**|ORA-01422|La sentencia `SELECT` devolvió más de una fila.|
|**INVALID_CURSOR**|ORA-01001|Se produjo una operación de cursor ilegal.|
|**ZERO_DIVIDE**|ORA-01476|Se intentó dividir entre cero.|
|**DUP_VAL_ON_INDEX**|ORA-00001|Se intentó insertar un valor duplicado.|
|**INVALID_NUMBER**|ORA-01722|Falla la conversión de una cadena de caracteres a números.|

##### -Ejemplo SINTAXIS `WHEN OTHERS THEN`
```sql
BEGIN
  SELECT ......
EXCEPTΠΟΝ
  WHEN NO_DATA_FOUND THEN
      sentencias;
      DBMS OUTPUT.PUT LINE ('Excepción NO_DATA_FOUND');
  WHEN TOO_MANY_ROWS THEN
      sentencias;
  WHEN OTHERS THEN
      sentencias para las demás excepciones no tratadas;
END;
```

#### Excepciones de usuario
*   Se declaran en la sección declarativa `DECLARE`.
*   Se provocan explícitamente en la sección ejecutable utilizando la sentencia `RAISE`.
*   Se gestiona la excepción dentro del bloque de excepciones `EXCEPTION`.
##### -Ejemplo `EXCEPCIONES DE USUARIO`
```sql
DECLARE
      mi_excepción EXCEPTION;
BEGIN
      RAISE mi_excepción;
ΕXCEPTION
    WHEN mi_excepción THEN
        sentencias;
    END;tencias para las demás excepciones no tratadas;
END;
```

#### Identificar Excepciones
*   `SQLCODE`: Devuelve el valor numérico del código de error SQL. No se puede referenciar directamente, hay que asignarlo a una variable PL/SQL de tipo NUMBER.
*   `SQLERRM`: Devuelve el mensaje asociado con el número de error. Tipo VARCHAR2.

| VALOR DE `SQLCODE` | DESCRIPCIÓN |
|:------------------:|:-----------:|
|`0`|No se encontró ninguna excepción|
|`1`|Excepción definida por el usuario|
|`+100`|Excepción NO_DATA_FOUND|
|`Negativo`|Otro número de error del Servidor Oracle|

##### -Ejemplo `FUNCIONES PARA IDENTIFICAR EXCEPCIONES`
```sql
WHEN OTHERS THEN
    v_codigo_error:=SQLCODE;
    v_texto_error:=SUBSTR(SQLERRM,1,200);
    INSERT INTO Tabla_Log
        VALUES (v_codigo_error, v_texto_error);
```
#### RAISE_APPLICATION_ERROR
*   Utilice el procedimiento RAISE_APPLICATION_ERROR para comunicar de forma interactiva una excepción predefinida, devolviendo un código y un mensaje de error no estándar.

Sintaxis:
```sql
RAISE_APPLICATION_ERROR (número_de_error,
        mensaje [, {TRUE | FALSE}]);
```

*   Se utiliza en dos lugares distintos:
    *   SECCIÓN EJECUTABLE
    *   SECCIÓN DE EXCEPCIONES
##### -Ejemplo `FUNCIONES PARA IDENTIFICAR EXCEPCIONES`
```sql
EXCEPTION
  WHEN NO DATA_FOUND THEN
      RAISE_APPLICATION_ERROR (-20201, 'No existen registros');
END;
BEGIN
  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR (-20201, 'No existen registros');
  END IF;
END;
```


#
[🔝 Volver al índice](#índice-de-contenido)
#

### **Conceptos importantes de SQL**
*  ###*CARDINALIDAD DE LAS RELACIONES*
   1. Relación uno a uno.
   2. Relación uno a varios (n).
   3. Relación varios (n) a uno.
   4. Relación varios a varios (n) - (n).
   
   
#
[🔝 Volver al índice](#índice-de-contenido)
#  
   
   
### **Otros**

## Para poder ver la ejecucion en la pantalla
```sql
set serveroutput on;
```
## Ejecutar el siguiente script para poder ejecutar scripts
```sql
alter session set "_ORACLE_SCRIPT"=true;
```
## Cómo arrancar el listener de Oracle

```sql
lsnrctl 
```
Comprobar su estado: 
```sql
status
```
Parar el listener: 
```sql
stop
```
Levantar el listener: 
```sql
start
```

## Creación de usuario y permisos
```CMD
SQLPLUS
```
```sql
CONN /AS SYSDBA
```
```sql
CREATE USER usuario IDENTIFIED BY clave;
```
```sql
GRANT CONNECT,DBA TO usuario;
```
## ora - 12514 and ora - 12505 tns listener error fixed ✅
```CMD
SQLPLUS
```
```sql
CONN /AS SYSDBA
```
```sql
alter system set LOCAL_LISTENER='(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))' scope=both;
```
```sql
alter system register;
```

#
[🔝 Volver al índice](#índice-de-contenido)
#
