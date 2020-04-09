--------------------------------------------------------------------------------

	MSX Diagnostics
	
	https://nightfoxandco.com/
	contact@nightfoxandco.com

--------------------------------------------------------------------------------

MSX Diagnostics es un programa para el diagnóstico básico del hardware de los
ordenadores de la familia MSX.
Programado por completo en lenguaje ensamblador, es el primer proyecto «serio»
que he realizado usando este lenguaje.

El objetivo de este proyecto es ayudar a las personas que como yo, nos
dedicamos a la reparación y restauración de ordenadores y videoconsolas
clásicas y que en muchos casos es difícil o engorroso verificar el
funcionamiento de ciertas partes del hardware, como los joysticks, el sonido o
todas las teclas del teclado.

La versión actual del programa está provista de las siguientes funcionalidades:

- SCREEN 0
	Verifica el funcionamiento de la VDP en modo 0, mostrando todos los
	caracteres disponibles llenando la pantalla. Se puede cambiar el color
	de texto y del fondo entre los 15 disponibles.
- SCREEN 1
	Igual al test de SCREEN 0, pero usando el modo 1. En este test además es
	posible cambiar el color del borde.
- SCREEN 2
	Usa el modo 2 de la VDP para mostrar diversas imágenes a base de tiles.
	Algunas de las imágenes incorporadas se pueden usar además para el ajuste
	de geometría y del color del monitor o de la salida de video. También es
	posible cambiar el color del borde de la imagen en cualquier momento.
- SCREEN 3
	Usa el modo 3 para mostrar varios patrones diferentes diversos colores.
	En este caso también se puede cambiar el color del borde.
- SPRITES
	Usando el modo 2, muestra en pantalla el número máximo de sprites
	permitido en MSX1 a un tamaño de 16×16. Este test además permite activar
	o detener el movimiento automático de estos sprites.
- KEYBOARD
	Permite comprobar el funcionamiento de todas las teclas básicas del
	teclado. A parte de mostrar un mensaje en pantalla al pulsar y soltar la
	tecla, cambia el color del fondo de la pantalla y emite dos sonidos
	diferenciados, facilitando el diagnóstico del teclado sin tener que
	mirar la pantalla.
- JOYSTICK
	Verifica el funcionamiento de los dos puertos o de los joysticks o
	gamepads conectados al MSX, mostrando en pantalla la pulsación de las
	4 direcciones y los dos botones de los mandos.
- PSG
	Verifica el funcionamiento del PSG (Programmable Sound Generator) del
	ordenador, pudiendo especificar el tono y el volumen en cualquiera de
	los 3 canales disponibles, además de poder asignar el generador de
	ruido (noise) a cualquiera de estos canales. También es posible escoger
	la frecuencia del generador de ruido.
	
El programa se distribuye en formato ROM, DISK, CAS y archivo de audio WAVE, a 1200 y 2400 baudios.