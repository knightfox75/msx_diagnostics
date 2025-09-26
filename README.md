# MSX Diagnostics

![MSX Diagnostics Screenshot](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_01.png)

<div align="center">

[![Website](https://img.shields.io/badge/Website-msx--diagnostics.nightfoxandco.com-blue?style=for-the-badge&logo=)](https://msx-diagnostics.nightfoxandco.com)
[![Latest Release](https://img.shields.io/github/v/release/knightfox75/msx_diagnostics?style=for-the-badge&logo=github)](https://github.com/knightfox75/msx_diagnostics/releases/latest)
[![License](https://img.shields.io/github/license/knightfox75/msx_diagnostics?style=for-the-badge)](https://github.com/knightfox75/msx_diagnostics/blob/main/LICENSE)

</div>

**[English Version Available Here](README_en.md)**

---

**MSX Diagnostics** es un programa para el diagnóstico básico del hardware de los ordenadores de la familia MSX. Programado íntegramente en lenguaje ensamblador de Z80, este proyecto tiene como objetivo ayudar a la comunidad de reparación y restauración de sistemas clásicos.

Verificar el funcionamiento de componentes como los joysticks, el sonido o cada tecla del teclado a menudo es un proceso difícil y engorroso. Esta herramienta simplifica esas tareas.

## ✨ Funcionalidades

*   **SCREEN 0**
    > Verifica el funcionamiento de la VDP en modo 0, mostrando todos los caracteres disponibles. Permite cambiar el color de texto y fondo.

*   **SCREEN 1**
    > Similar al test de SCREEN 0, pero usando el modo 1. Adicionalmente, permite cambiar el color del borde.

*   **SCREEN 2**
    > Usa el modo 2 de la VDP para mostrar imágenes a base de tiles, útiles para el ajuste de geometría y color del monitor.

*   **SCREEN 3**
    > Utiliza el modo 3 para mostrar varios patrones de diferentes colores, permitiendo también cambiar el color del borde.

*   **SPRITES**
    > Muestra el número máximo de sprites permitido en MSX1 (16×16) y permite controlar su movimiento automático.

*   **MONITOR COLOR**
    > Muestra los colores básicos y la paleta completa de MSX1 para verificar la pureza del color y ajustar la salida de vídeo (compuesto o RGB).

*   **KEYBOARD**
    > Permite comprobar todas las teclas básicas del teclado. Cambia el color del fondo y emite sonidos diferenciados para facilitar el diagnóstico sin necesidad de mirar la pantalla.

*   **JOYSTICK**
    > Verifica el funcionamiento de los dos puertos de joystick, mostrando en pantalla la pulsación de las 4 direcciones y los 2 botones.

*   **PSG (Programmable Sound Generator)**
    > Verifica el funcionamiento del PSG, pudiendo especificar el tono, volumen y ruido en cada uno de los 3 canales disponibles.

*   **MIXED MODE**
    > Prueba la compatibilidad de la VDP con el [modo mixto (texto + gráficos) no documentado por Texas Instruments](https://en.wikipedia.org/wiki/Texas_Instruments_TMS9918#Undocumented).

*   **SYSTEM INFO**
    > Muestra un resumen técnico del equipo: modelo de MSX (1, 2, 2+ o Turbo-R), RAM y VRAM, VDP, frecuencia de refresco, y RTC en modelos superiores.

*   **RAM LAYOUT**
    > Muestra un resumen de la memoria RAM detectada y su distribución en el sistema de slots, subslots y mappers.

## 💾 Formatos de Distribución

El programa se distribuye en los siguientes formatos:
*   **ROM:** Ficheros de 32KB y 64KB para cartucho.
*   **DISK:** Imagen de disco de 720KB.
*   **CAS:** Fichero de cinta.
*   **WAVE:** Archivos de audio a 1200 y 2400 baudios.
*   **Binarios:** Listos para grabar en memorias PROM, EPROM, etc.

## 📥 Descargar

Puedes descargar la última versión del programa, con todos los formatos, desde la **[página de Releases](https://github.com/knightfox75/msx_diagnostics/releases/latest)**.

## 📸 Capturas de Pantalla

| Menú Principal | Test de Joystick |
| :---: | :---: |
| ![Screenshot 1](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_02.png) | ![Screenshot 2](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_04.png) |
| Test de Sonido (PSG) | Información del Sistema |
| ![Screenshot 3](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_05.png) | ![Screenshot 4](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_06.png) |

## 📜 Licencia

Este proyecto se distribuye bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## 📧 Contacto

Para cualquier duda o sugerencia, puedes contactar a través de **contact@nightfoxandco.com**.
