# Generador de funciones triangular, cuadrada, senoidal y diente de sierra implementada en una FPGA
Este código no contempla frecuencias variables.

Para cambiar la frecuencia a una variable por un sistema digital exterior como un oscilador simple de cristal, en el archivo .ucf en la variable la línea

net "clock" loc = "E7";

se debe de cambiar a:

NET "clock" CLOCK_DEDICATED_ROUTE = FALSE;
net "clock" loc = "*nombre del puerto al que se recibe la señal de reloj*";

Lo que se tiene implementado es una "memoria ROM" con datos guardados de 8 bits equivalentes a las 4 funciones implemetadas.
Según el selector se hace un "barrido" de datos de cada función y se van sacando en un puerto de 8 salidas, este se tiene que conectar a una DAC, respetando el orden de bits más y menos significativos, (se ocupó una de arrewglo de resistencias simples) para así obtener la señal analógica generada en un osciloscopio, o el material el que se ocupará el generador.

Igualmente para ayuda visual tiene salidas a un arreglo de 4 displays de 7 segmentos de anodo común para visualizar las palabras "tria", "cuad", "seno" y "dien" y ademas un arreglo de 8 leds para visualizar que los datos binarios están saliendo de buena manera.

Este codigo fue implementada en una amiba2 de la marca intesc que tiene una spartan 6 como FPGA de funcionamiento.
