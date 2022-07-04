struct valor	//Tipo de dato que servira para almacenar el valor de las variables//
{
	int entero;			//Parte entera del posible valor de las variables//
	float flotante;		//Parte flotante del posible valor de las variables//
	char *cadena;		//Parte que representara cadenas del posible valor de las variables//
}typedef valor;

struct elem		//Tipo de dato que servira para representar los tokens en la Tabla de simbolos//
{
	char *nombre;		//Atributo nombre del token//
	char *tipo;			//Atributo tipo del token//
	valor dato;			//Atributo dato del token//
}typedef elem;