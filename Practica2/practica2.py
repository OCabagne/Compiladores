# Oscar Eduardo López Cabagné - 3CV7
# PRACTICA 2

lineas = 0
cadena = ""
estados = []
alfabeto = []
eIniciales = []
eFinales = []
relaciones = {}

def renglones(path):
    # Obtener número de renglones.
    file = open(path, "r")
    Counter = 0
    
    # Leyendo Archivo
    Content = file.read() 
    CoList = Content.split("\n") 
    
    for i in CoList: 
        if i: 
            Counter += 1
            
    return Counter # Número de renglones leídos.

def leer(path):
    global estados
    global alfabeto             # Ahora el alfabeto contendrá a E : Epsilon (Cadena Vacía)
    global eIniciales
    global eFinales
    global relaciones
    global lineas
    i = 0
    count = 0
    file = open(path, "r")
    while True:
        count += 1
        line = file.readline().rstrip()
        if count < 5:
            if count == 1:
                estados = line.split(",")
            if count == 2:
                alfabeto = line.split(",")
            if count == 3:
                eIniciales = line.split(",")
            if count == 4:
                eFinales = line.split(",")
        else:
            relaciones[i] = line.split(",")
            i += 1
            lineas += 1
        if not line:
            lineas -= 1
            break

def obtenerCadena():
    global cadena
    print("Introduzca la cadena: ")
    cadena = input()
    print(f">: {cadena}")
        # Verificar que cada caracter de la cadena se encuentra dentro del alfabeto

def verificar(cadena, posicion):
    global alfabeto
    try:
        alfabeto.index(cadena[posicion])
        return True
    except:
        print(f">: {cadena[posicion]} No se encuentra en el alfabeto.")
        return False

def analisis(estado, posicion, cuenta, camino):
    while posicion < len(cadena):
        if(verificar(cadena, posicion)):
            break
        else:
            posicion += 1
            cuenta += 1
            print(f"Letra:  {cadena[posicion-1]} indice: {posicion}")
            
    camino += " " + estado                                                                    #Actualizmos la cadena del camino con el estado actual
    if cuenta <= len(cadena):                                                           # Si la cuenta de caracteres es menor al total de caracteres en la cadena...
        transicion = cadena[posicion]                                                   # Obtenemos el caracter siguiente de la cadena
        i = 0
        while i <= lineas:                                                              # Mientras estemos dentro de la relación Estado-Transición-Estado...
            if relaciones[i][0] == estado:                                              # Si el elemento en la posición [i][0] (Primer columna) es igual al estado actual...
                if relaciones[i][1] == transicion:                                          # Si el elemento [i][1] (Segunda columna) es igual al siguiente caracter en la cadena...
                    analisis(relaciones[i][2], posicion + 1, cuenta + 1, camino)            # Realizamos de nuevo este análisis, ahora con el estado destino (Tercera columna).
                
                if relaciones[i][1] == 'E':                                                 # Si el elemento [i][1] (Segunda columna) es igual a la cadena vacía...
                    analisis(relaciones[i][2], posicion, cuenta, camino)                    # Realizamos de nuevo este análisis, ahora con el estado destino (Tercera columna), 
                                                                                                # en este caso la cuenta y la posición se quedan igual pues la cadena vacía no consume ningún caracter.
            i += 1                                                                      # Incrementamos el contador del arreglo.

    else:                                                                               # Si nuestra cuenta de caracteres es mayor al total de la cadena...
        for final in eFinales:                                                          # Se buscará un camino para cada uno de los estados finales
            if estado != final:                                                         # unicamente considerando transiciones Epsilon
                i = 0
                while i <= lineas:                                                           # Mientras estemos dentro de la relación Estado-Transición-Estado...
                    if relaciones[i][0] == estado:                                           # Si el elemento en la posición [i][0] (Primer columna) es igual al estado actual...
                        if relaciones[i][1] == 'E':                                                # Si el elemento [i][1] (Segunda columna) es igual a la cadena vacía...
                            analisis(relaciones[i][2], posicion, cuenta, camino)                   # Realizamos de nuevo este análisis, ahora con el estado destino (Tercera columna), 
                                                                                                   # en este caso la cuenta y la posición se quedan igual pues la cadena vacía no consume ningún caracter.
                    i += 1   
            else:
                print("Camino Exitoso: " + camino)  
    return 0

def inicio():
    print(">: Introduzca el path: ")
    #path1 = input()
    path1 = "C:/Users/Oscar/Desktop/ESCOM/7mo/Compiladores/Practica2/T1.txt"
    camino = ""
    try:
        file = open(path1, "r")
        print(">: El path es correcto")
        file.close()
        rows = renglones(path1)
        if rows < 5:
            print(">: Hay un problema con el archivo. Informacion Insuficiente.")
        else:
            print(">: Cargando archivo.")
            leer(path1)
            print(">: Archivo cargado correctamente.")
            obtenerCadena()
            for estado in eIniciales:
                analisis(estado, 0, 1, camino)
    except:
        print(">: Ha ocurrido un error.")

inicio()