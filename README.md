![ORACLE PL/SQL](/images/ORACLE.svg?raw=true)



## Índice de contenido

*   [¿Qué es PL/SQL?](#¿Qué-es-PL/SQL?)

*   [Estructura](#Estructura)

*   [Estructura Bloques Anónimos](#Estructura-Bloques-Anónimos)

*   [Estructura de Procedimiento](#Estructura-de-Procedimiento)

*   [Funciones](#Funciones)

*   [Reglas y Convenciones del Lenguaje](#Reglas-y-Convenciones-del-Lenguaje)

*   [Delimitadores](#Delimitadores)

*   [Variables](#Variables)

*   [Constantes](#Constantes)

*   [Atributos %TYPE y %ROWTYPE](#Atributos-%TYPE-y-%ROWTYPE)

*   [REGISTROS](#REGISTROS)

*   [Transacción Savepoint, Rollback y Commit](#Transacción-Savepoint,-Rollback-y-Commit)

*   [Tablas PL/SQL](#Tablas-PL/SQL)

*   [Operadores lógicos pl/sql](#Operadores-lógicos-pl/sql)

*   [Condicionales](#Condicionales)

*   [Bucles (LOOPS)](#Bucles-(LOOPS))

*   [Expresiones CASE](#Expresiones-CASE)

*   [GOTO y etiquetas](#GOTO-y-etiquetas)

*   [Cursores](#Cursores)

*   [Variables compuestas](#Variables-compuestas)

*   [Paquetes](#Paquetes)

*   [Otros](#Otros)



### **¿Qué es PL/SQL?**

Lenguaje de procesamiento procedimental, su objetivo es interactuar con la Base de Datos.

*   La unidad básica en PL/SQL es el bloque.
*   Todos los programas PL/SQL están compuestos por bloques, que pueden definirse de forma secuencial o estar anidados.
*   Normalmente cada bloque realiza una unidad lógica de trabajo en el programa, separando así unas tareas de otras.

[🔝 Volver al índice](#índice-de-contenido)

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

[🔝 Volver al índice](#índice-de-contenido)

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

[🔝 Volver al índice](#índice-de-contenido)

### **Estructura-de-Procedimiento**

```sql
PROCEDURE 'nombre' IS
    'Sección Declarativa'
BEGIN
    'Sección Ejecutable'
EXCEPTION
    'Sección de Excepciones'
END;
```

### ***Script BD Libros***

```sql
DROP TABLE libros; 
```

```sql
CREATE TABLE libros (
    idlibro NUMBER(12) NOT NULL,
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
```

```sql
CREATE SEQUENCE AUMENTARLIBRO; 
```

```sql
INSERT INTO libros (
    idlibro,
    titulo,
    autor,
    precio,
    fecha
)
    SELECT
        aumentarlibro.NEXTVAL,
        'Titulo ' || to_char(aumentarlibro.CURRVAL),
        'Autor ' || to_char(aumentarlibro.CURRVAL),
        round(dbms_random.value(100000, 3000000)),
        to_date('2021/'
                || round(dbms_random.value(1, 12))
                || '/'
                || round(dbms_random.value(1, 27))
                || ' 21:02:44', 'yyyy/mm/dd hh24:mi:ss')
    FROM
        dual
    CONNECT BY
        level <= 100;
```

### -Ejemplo - APLICAR UN 5% DE DCTO A TODOS LOS LIBROS CON UN PROCEDIMIENTO ALMACENADO 
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

### -Ejemplo (AUDITORÍA) - SELECCIONA UN AUTOR Y GUARDA ESE CAMPO EN LA TABLA1 CON EL TITULO Y EL PRECIO 
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

### -Ejemplo - ACTUALIZAR SUELDO DE LOS EMPLEADOS QUE TENGAS MÁS DE 10 AÑOS EN LA EMPRESA UN 100% POR PARÁMETROS DE ENTRADA ([Script empleados,productos](#Script-empleados,productos))

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

[🔝 Volver al índice](#índice-de-contenido)


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

### -Ejemplo 1
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

### -Ejemplo 2
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



[🔝 Volver al índice](#índice-de-contenido)

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
### Ejemplos Validos

`X, V_ENAME, CodEmp, V1, V2_, ES_UNA_VARIABLE_#, V_$_Cod
– Variables`

### Ejemplos **MAL** declaradas

`X+Y , _ENAME, Cod Emp, 1V, ESTA ES …. VARIABLE (+ de 30 caracteres)`


[🔝 Volver al índice](#índice-de-contenido)

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


[🔝 Volver al índice](#índice-de-contenido)

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

## -Ejemplo

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

[🔝 Volver al índice](#índice-de-contenido)

### **Constantes**

Una constante en PL/SQL hace la misma función de una variable solo que se le coloca una palabra clave **constant** frente a cada delcaración de variable, la particularidad de una constante es que su valor no cambia a medida que se ejecuta el programa en PL/SQL por lo que no permiten que su valor sea cambiado.

## -Ejemplo

```sql
declare
   mensaje constant varchar2(30):='buenos dias a todos';
   numero constant number(6):=30000;
begin
   dbms_output.put_line(mensaje);
   dbms_output.put_line(numero);
end;
```

[🔝 Volver al índice](#índice-de-contenido)

### **Atributos %TYPE y %ROWTYPE**

##  **Atributo \%TYPE**

Permite declarar una variable basada en:

*   Otras variables previamente declaradas
*   La definición de una columna de la base de datos

*   **Preceder de %TYPE por:**
    *   La tabla y la columna de la base de datos
    *   El nombre de la variable definida con anterioridad

## -Ejemplo

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

## -Ejemplo

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

[🔝 Volver al índice](#índice-de-contenido)

### **REGISTROS**

También se pueden asignar valores de un registro completo mediante un SELECT que extraería los datos de la BD y los almacena en el registro.

Sintaxis:

```sql
TYPE nombre_registro IS RECORD (declaración_campo [, declaración_campo] ...);
```
## -Ejemplo

```sql
TYPE R_registro IS RECORD (
cliente clientes.cliente%TYPE,
nombre clientes.nombre_corto%TYPE,
clase clientes.clase_cliente%TYPE);
```

[🔝 Volver al índice](#índice-de-contenido)

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

## -Ejemplo:
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

[🔝 Volver al índice](#índice-de-contenido)

### **Tablas PL/SQL**

*   Cuentan con 2 elementos
    *   TIPO DE DATOS DE CLAVE PRIMARIA BINARY_INTEGER
    *   COLUMNA DE TIPO DE DATOS ESCALARES O DE REGISTRO.
*   Aumentan dinámicamente porque no tienen restricciones.
*   Se almacenan en memoria.

## -Ejemplo 1

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

## -Ejemplo 2

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

[🔝 Volver al índice](#índice-de-contenido)

### **Operadores lógicos pl/sql**

| Operador | DESCRIPCIÓN |
|:--------:|:-----------:|
|`**, NOT`|Exponenciación, negación lógica|
|`*, /`|Multiplicación, división|
|`+, -, \|\|`|Suma, resta, concatenación|
|`=, !=, <, >, <=, >=, IS NULL, LIKE, BETWEEN, IN`|Comparación|
|`AND`|AND|
|`OR`|Inclusión|


[🔝 Volver al índice](#índice-de-contenido)

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

## -Ejemplo 1
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
## -Ejemplo 2
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

[🔝 Volver al índice](#índice-de-contenido)

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
### -Ejemplo 1 LOOP

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
### -Ejemplo 2 LOOP-EXIT

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
### -Ejemplo 3 WHILE

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
### -Ejemplo 4 FOR

```SQL
DECLARE
  numero NUMBER (2);
BEGIN
 FOR numero IN 10..20 LOOP
   dbms_output.put_line('valor de numero: ' || numero);
  END LOOP;
END;
```
### -Ejemplo 5 BUCLES ANIDADOS

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


[🔝 Volver al índice](#índice-de-contenido)

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

### -Ejemplo 1

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
### -Ejemplo 2

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

[🔝 Volver al índice](#índice-de-contenido)

### **GOTO y etiquetas**

GOTO es como la abreviatura de "ir a", es un punto donde en un momendo dado llegue el programa

Su sintaxis es:
```SQL
GOTO <Etiqueta>;
```
donde <Etiqueta> es una etiqueta definida en el bloque PL/SQL.
### -Ejemplo

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

[🔝 Volver al índice](#índice-de-contenido)

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

### -Ejemplo de delcaración
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
```
```sql
 CREATE TABLE empleados(
  documento CHAR(8),
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
### -Ejemplo `CURSORES IMPLICITOS`
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

### -Ejemplo `CURSORES EXPLICITOS`
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
### -Ejemplo `CURSORES EXPLICITOS` 2
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

### -Ejemplo `CURSORES EXPLICITOS` ACTUALIZANDO DATOS DE UNA TABLA SQL
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
### -Ejemplo `FOR UPDATE Y WHERE CURRENT OF`
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
### -Ejemplo `CURSORES EXPLICITOS CON PARAMETROS`
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
### -Ejemplo `REF CURSORS`
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

[🔝 Volver al índice](#índice-de-contenido)

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

### -Ejemplo `VARIABLE COMPUESTA CON CURSOR`
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

[🔝 Volver al índice](#índice-de-contenido)

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

[🔝 Volver al índice](#índice-de-contenido)

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

[🔝 Volver al índice](#índice-de-contenido)
