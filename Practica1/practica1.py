
class automata(object):
    lineas = 0
    cadena = ""
    estados = []
    alfabeto = []
    eIniciales = []
    eFinales = []
    relaciones = {}

    def renglones(self, path):
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

    def leer(self, path):
        global estados
        global alfabeto
        global eIniciales
        global eFinales
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
                self.relaciones[i] = line.split(",")
                i += 1
                self.lineas += 1
            if not line:
                self.lineas -= 1
                break

    def obtenerCadena(self):
        global cadena
        i = 0
        print("Introduzca la cadena: ")
        cadena = input()
        print(f">: {cadena}")
            # Verificar que cada caracter de la cadena se encuentra dentro del alfabeto
        for letra in cadena:
            try:
                alfabeto.index(letra)
                i += 1
                if i == len(cadena):
                    print("Cadena valida.")
            except:
                print(f"{letra} NO se encuentra en el alfabeto")
                break

    def analisis(self, estado, posicion, cuenta, camino):
        camino += estado                                                                    #Actualizamos la cadena del camino con el estado actual
        if cuenta <= len(cadena):                                                           # Si la cuenta de caracteres es menor al total de caracteres en la cadena...
            transicion = cadena[posicion]                                                   # Obtenemos el caracter siguiente de la cadena
            i = 0
            while i <= self.lineas:                                                              # Mientras estemos dentro de la relación Estado-Transición-Estado...
                if self.relaciones[i][0] == estado:                                              # Si el elemento en la posición [i][0] (Primer columna) es igual al estado actual...
                    if self.relaciones[i][1] == transicion:                                          # Si el elemento [i][1] (Segunda columna) es igual al siguiente caracter en la cadena...
                        self.analisis(self.relaciones[i][2], posicion + 1, cuenta + 1, camino)            # Realizamos de nuevo este análisis, ahora con el estado destino (Tercera columna), 
                                                                                                # incrementamos la posición y la cuenta, y enviamos la cadena del camino actualizada.
                i += 1                                                                      # Incrementamos el contador del arreglo.

        else:                                                                               # Si nuestra cuenta de caracteres es mayor al total de la cadena...
            try:                                                                            # Verificamos que el último estado obtenido pertenezca a los estados finales (Renglón 4).
                eFinales.index(estado)
                print(f">: Camino exitoso: {camino}")                                       # Imprimimos el camino obtenido

            except:                                                                         # Si el último estado no es final, entonces el camino es incorrecto.
                print("")
                #print(f"Camino fallido: {camino}")                                         # Podemos imprimir también los caminos fallidos que se encuentren.
        
        return 0

def inicio():
    print(">: Introduzca el path: ")
    path = input()
    #path = "C:/Users/Oscar/Desktop/ESCOM/7mo/Compiladores/Practica1/AF1.txt"
    camino = ""
    try:
        file = open(path, "r")
        print(">: El path es correcto")
        file.close()
        analizar = automata()       # Instancia
        rows = analizar.renglones(path)
        if rows < 5:
            print(">: Hay un problema con el archivo. Informacion Insuficiente.")
        else:
            print(">: Cargando archivo.")
            analizar.leer(path)
            print(">: Archivo cargado correctamente.")
            analizar.obtenerCadena()
            for estado in eIniciales:
                analizar.analisis(estado, 0, 1, camino)
    except:
        print(">: Ha ocurrido un error. Verifique el path. ")

inicio()