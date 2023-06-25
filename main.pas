program tpObligatorio;

uses
    sysutils,Crt;

const
     ARCHIVO_BASE = 'C:\Dev-Pas\practicas\tpObligatorio\INSCRIPCIONES.CSV';
     ARCHIVO_ORDENADO = 'C:\Dev-Pas\practicas\tpObligatorio\ORDENADO.DAT';
     MAX_ALUMNO = 50;
type
    tFecha = array[1..3] of integer;

    tAlumno = record
            legajo: string;
            dni: integer;
            apellido:string;
            nombre:string;
            fechaDeNacimiento:tFecha;
            carrera:string;
        end;
    tListado = array[1..MAX_ALUMNO] of tAlumno;
    tArchRegistro = file of tAlumno;
var
   i:integer;
   dim:integer;
   listado: tListado;
   salir:boolean;


procedure corteControl(i:integer);
(*
que hace: limita la cantidad de registros que se muestran en pantalla y muestra el numero de hoja
pre: i=I; i > 0
*)
var
   c:char;
begin
     if i <> 0 then
        writeln('hoja nro: ',i div 3);
     writeln('presione enter para continuar');
     writeln();
     readln(c);
end;

function separarCampos(cad:string; p:integer):integer;
(*
que hace: encuentra la coma en una cadena de campos separados por coma.
pre: cad=C,p=P; p enRango(longitud(C))
pos: P= lugar donde se encuentra la coma
*)
begin
     while (',' <> cad[p]) and (p < length(cad)) do
           p := p + 1;
     separarCampos := p
end;


procedure ingresoFechaDeNacimiento(cad:string;var fecha:tFecha);
(*
que hace: dada una cadena conteniendo una fecha la transforma en entero y la ingresa
en un arreglo para luego poder ser prosesada
pre:cad=C; C es una cadena con una fecha en formato dia/mes/año
pos: fecha=F y F[1]= dia,F[2]=mes,F[3]=año
*)
var
   i,p,j:integer;
begin          
     p:= 1;
     i:= 1;
     j:= 1;
     while i <= length(cad) do
           begin
                if (cad[i] = '/') or (i = length(cad)) then
                begin
                   fecha[j]:= StrToInt(copy(cad,p,i-p));
                   if j = 3 then
                      fecha[j]:= StrToInt(copy(cad,p,i-p+1));
                   j:=j+1;
                   p:=i+1;
                end;
           i:= i + 1;
           end;
end;

procedure mostrarFechaDeNacimiento(fecha:tFecha);
(*
que hace: muestra una fecha de nacimiento ingresada en un arreglo
pre: fecha=F;F[1]= dia,F[2]=mes,F[3]=año
*)
var
   i:integer;
begin
     for i := 1 to 2 do
         write(fecha[i],'/');
     i:=i+1;
     write(fecha[i]);
end;

procedure llenarRegistro(var registro:tAlumno; cad:string);
(*
que hace: completa los campos de un registro a partir de una cadena separada por comas
pre: cad=C;C una cadena separada por comas
pos: alumno=A y A conteniendo los datos de C
*)
var
   j:integer;
   p:integer;
   campo:integer;

begin
     j := 1;
     p :=1;
     campo := 1;
     while campo <= 6 do
           begin
                j := separarCampos(cad,p);
                case campo of
                     1:registro.legajo := copy(cad,p,j -p);
                     2:registro.dni := StrToInt(copy(cad,p,j - p));
                     3:registro.apellido := copy(cad,p,j - p);
                     4:registro.nombre := copy(cad,p,j - p);
                     5:ingresoFechaDeNacimiento(copy(cad,p,j -p),registro.fechaDeNacimiento);
                     6:registro.carrera := copy(cad,p,j-p+1);
                end;
                campo := campo +1;
                p := j + 1;
            end;
end;

procedure llenarArreglo(ruta:string;var listado:tListado;var dim:integer);
(*
que hace: llena el arreglo de manera secuencial leyendo del archivo de texto especificado en la ruta
pre: ruta=R y R es la ruta del archivo de texto a leer
pos: listado=L,dim=D; listado[1..D]
*)


var
   i:integer;
   aux:string;
   archBase:text;

begin
     i:= 1;
     assign(archBase,ruta);
     reset(archBase);
     while not eof(archBase) do
           begin
                readln(archBase,aux);
                llenarRegistro(listado[i],aux);
                i := i+1;
           end;
     dim:= i -1;
     close(archBase);
end;

procedure mostrarRegistro(registro:tAlumno);
(*
que hace:muestra los datos de los alumnos.
pre: A=alumno Y [1..A] con rango de tAlumno.
*)
begin
     writeln();
     writeln('aplellido: ',registro.apellido);
     writeln('nombre: ',registro.nombre);
     write('fecha de nacimiento: ');
     mostrarFechaDeNacimiento(registro.fechaDeNacimiento);
     writeln();
     writeln('legajo nro: ',registro.legajo);
     writeln('dni nro: ',registro.dni);
     writeln('carrera: ',registro.carrera);
     writeln();
end;

function compararNombres(nuevo:string;actual:string):integer;
(*
que hace:compara dos nombres
pre: N1=nuevo,N2=actual
pos:compararNombres=C; C=-1 SI N1<N2; C=0 si N1=N2; C=1 si N1>N2.
*)
begin
	if nuevo < actual then
		compararNombres := -1
    else
        begin
		      if nuevo > actual then
			     compararNombres := 1
              else
                  compararNombres := 0
              end;
end;

procedure intercambio(var alumn1,alumn2:tAlumno);
(*
que hace:intercambia dos valores
pre: alumno1=A; alumno2=B  
pos: alumno1=B; alumno2=A
*)

var
    aux:tAlumno;

begin
     aux:=alumn1;
     alumn1:=alumn2;
     alumn2:=aux;
end;

function fechaEnNumero(fecha:tfecha):integer;
(*
que hace:compara dos fechas
pre: F=fecha;
pos: fechaEnNumero=N y N > 0 representa la fecha N.
*)

begin
    FechaEnNumero:=fecha[3]*10000+fecha[2]*100+fecha[1];
end;



function CompararFechas(alum1,alum2:talumno):integer;
(*
que hace:compara dos fechas de nacimiento
pre:  A1=alumn1 , A2=alumn2
pos: compararFechas=F ;F=-1 si A1<A2; F=0 si A1=A2 ; F=1 si A1>A2.
*)
var
   a1,a2:integer;

begin
     a1:=FechaEnNumero (alum1.FechaDeNacimiento);
     a2:=FechaEnNumero (alum2.FechaDeNacimiento);
             if   a1=a2     then
                  CompararFechas:=0
             else
                  CompararFechas:=(a1-a2) div abs(a1-a2);
end;



procedure ordenarFechaNac(var listado:tListado;principio,final:integer);
(*
que hace: ordena los elmentos del arreglo de menor a mayor por fecha de nacimiento
pre: listado=L,Principio=P,final=F; [P..F] en rango(tListado)
pos: L=L', L' Esta ordenada en [P..F];
*)
var
   tope,max:integer;
   ordenado:boolean;


begin

      max:=final;
      repeat
            ordenado:=true;
            tope:=max-1;
            i:=principio;
            while i <= tope do
            begin
                  if CompararFechas(listado[i],listado[i+1]) < 0 then
                  begin
                     intercambio (listado[i],listado[i+1]);
                     max:=i;
                     ordenado:=false;
                  end;
                  i:= i + 1;
             end;
      until ordenado;
end;

procedure listarFecha(listado:tListado;dim:integer);
(*
que hace: muestra un listado de los registros del arreglo de a 3 personas por orden de edad de menor a mayor
pre: listado=L,dim=D; L[1..D]
*)
var
   i:integer;
begin
     ordenarFechaNac(listado,1,dim);
     i:=1;
     while i <= dim do
     begin
          MostrarRegistro(listado[i]);
          if (i mod 3 = 0) then
             corteControl(i);
          i:=i+1;
     end;
end;

procedure insertarAlumnoAlfabetico(var archRegistro:tArchRegistro;nuevo:tAlumno);
(*
que hace: agrega un nuevo registro al archivo respetando el orden
pre: archRegistro=f, nuevo=N; F esta abierto y ordenado.
pos: F=F' y F' esta ordenado y F' = F U {N}
*)
var
	pos: integer;
	aux: tAlumno;
	encontroLugar: boolean;

begin
     pos := filesize(archRegistro) -1;
     encontroLugar := false;
     while (pos >= 0) and (not encontroLugar) do
     begin
           seek(archRegistro,pos);
           read(archRegistro,aux);
           if compararNombres(nuevo.apellido+nuevo.nombre,aux.apellido+aux.nombre) < 0 then
           begin
                write(archRegistro,aux);
			    pos := pos - 1;
           end
           else
           begin
                encontroLugar := true;
           end;
     end;
	 seek(archRegistro,pos + 1);
	 write(archRegistro,nuevo);
end;
(*
que hace: genera un archivo .DAT conteniendo los registros del arreglo por orden Alfabetico
pre: listado=L,dim=D; L es un arreglo conteniendo los registros de alumnos y L[1..D]
*)
procedure crearAlfabetico(listado:tListado;dim:integer);

var
   archRegistro:tArchRegistro;
   i: integer;
begin
     assign(archRegistro,ARCHIVO_ORDENADO);
     rewrite(archRegistro);
     for i :=1 to dim do
         insertarAlumnoAlfabetico(archRegistro,listado[i]);
     close(archRegistro);
end;



procedure listarAlfabetico(ruta:string);
(*
que hace: muestra un listado de los registros del archivo ordenado alfabeticamente de a 3 personas
pre: ruta=R; R es la ruta a donde esta el archivo .DAT
*)
var
	alumno:tAlumno;
	i:integer;
	archRegistro:tArchRegistro;
begin
    crearAlfabetico(listado,dim);
    writeln('Archivo Creado');
    corteControl(0);
    assign(archRegistro,ruta);
    reset(archRegistro);
	i := 0;
	while not eof(archRegistro) do
    begin
		read(archRegistro,alumno);
		mostrarRegistro(alumno);
		i := i + 1;
        if i mod 3 = 0 then
			corteControl(i)
    end;
    close(archRegistro);
end;

function seleccion(msg:string;error:string):integer;
(*
que hace: muestra un menu para que el usuario elija que operacion desea realizar
pre: msg=M,error=E; M es el mensaje para el usuario, E es el mensaje de error que se muestra
si el usuario no elige una opcion adecuada
pos: seleccion=S; S es la opcion elegida por el usuario y S enRango[1..4]
*)
var
	op:integer;
	
begin
	repeat
    begin
		writeln(msg);
        writeln();
		writeln('1: listar alumnos por fecha de nacimiento');
		writeln('2: listar alumnos por carrera');
		writeln('3: generar y listar archivo con alumnos ordenados alfabeticamente');
		writeln('4: salir');
		readln(op);
		if (op < 1) or (op > 4) then
			writeln(error);
    end;
	until op in [1..4];
	seleccion := op;
end;

procedure ListarCarrera(listado:tListado;dim:integer);
(*
que hace: muestra un listado de los registros del arreglo segun carrera de a 3 personas
pre: listado=L,dim=D; L[1..D]
*)
var
   op,j,i:integer;
   c:char;

begin
     repeat
     begin
          writeln('Elija carrera a listar:');
          writeln();
          writeln('1: Analista Programador Universitario');
          writeln('2: Licenciatura en sistemas');
          readln(op);
     end;
     until op in [1..2];
     case op of
            1:c:='A';
            2:c:='L';
     end;
     i:=1;
     j:=0;
     while i<= dim do
     begin
          if c=listado[i].carrera[1] then
          begin
              j:=j+1;
              mostrarRegistro(listado[i]);
              if j mod 3 = 0 then
                 corteControl(j);
          end;
          i:=i+1;
     end;
     readLN();
end;

begin
     llenarArreglo(ARCHIVO_BASE,listado,dim);
     repeat
     begin
          case seleccion('Elija una opcion','opcion incorrecta') of
               1:listarFecha(listado,dim);
               2:ListarCarrera(listado,dim);
               3:listarAlfabetico(ARCHIVO_ORDENADO);
               4:salir:=true;
          end;
          ClrScr();
     end;
     until salir;

end.
