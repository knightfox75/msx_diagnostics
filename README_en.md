# MSX Diagnostics

![MSX Diagnostics Screenshot](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_01.png)

<div align="center">

[![Website](https://img.shields.io/badge/Website-msx--diagnostics.nightfoxandco.com-blue?style=for-the-badge&logo=)](https://msx-diagnostics.nightfoxandco.com/msxdiag_en.html)
[![Latest Release](https://img.shields.io/github/v/release/knightfox75/msx_diagnostics?style=for-the-badge&logo=github)](https://github.com/knightfox75/msx_diagnostics/releases/latest)
[![License: CC BY-NC 4.0](https://img.shields.io/badge/License-CC_BY--NC_4.0-orange.svg?style=for-the-badge)](https://creativecommons.org/licenses/by-nc/4.0/)

</div>

**[Versión en Español disponible aquí](README.md)**

---

**MSX Diagnostics** is a program for basic hardware diagnosis of the MSX family of computers. Programmed entirely in Z80 assembly language, this project aims to help the community dedicated to repairing and restoring classic systems.

Verifying the functionality of components such as joysticks, sound, or every single keyboard key is often a difficult and cumbersome process. This tool simplifies those tasks.

## ✨ Features

*   **SCREEN 0**
    > Verifies the VDP's operation in mode 0, displaying all available characters. Allows changing text and background colors.

*   **SCREEN 1**
    > Same as the SCREEN 0 test, but using mode 1. This test also allows changing the border color.

*   **SCREEN 2**
    > Uses VDP mode 2 to display tile-based images, useful for adjusting monitor geometry and color.

*   **SCREEN 3**
    > Utilizes mode 3 to show various patterns in different colors, also allowing the border color to be changed.

*   **SPRITES**
    > Displays the maximum number of sprites allowed in MSX1 (16×16) and allows enabling or disabling their automatic movement.

*   **MONITOR COLOR**
    > Shows the basic colors and the full MSX1 palette to verify color purity and adjust the video output (composite or RGB).

*   **KEYBOARD**
    > Allows testing all basic keyboard keys. It changes the background color and emits distinct sounds to facilitate diagnosis without looking at the screen.

*   **JOYSTICK**
    > Verifies the operation of both joystick ports, displaying on-screen the presses of the 4 directions and 2 buttons.

*   **PSG (Programmable Sound Generator)**
    > Verifies the PSG's functionality, allowing you to specify the tone, volume, and noise on each of the 3 available channels.

*   **MIXED MODE**
    > Tests the VDP's compatibility with the [undocumented mixed mode (text + graphics) by Texas Instruments](https://en.wikipedia.org/wiki/Texas_Instruments_TMS9918#Undocumented).

*   **SYSTEM INFO**
    > Displays a technical summary of the system: MSX model (1, 2, 2+, or Turbo-R), installed RAM and VRAM, VDP, refresh rate, and RTC in later models.

*   **RAM LAYOUT**
    > Shows a summary of the detected RAM and its distribution across the system's slots, subslots, and mappers.

## 💾 Distribution Formats

The program is distributed in the following formats:
*   **ROM:** 32KB and 64KB files for cartridges.
*   **DISK:** 720KB disk image.
*   **CAS:** Tape file.
*   **WAVE:** Audio files at 1200 and 2400 baud.
*   **Binaries:** Ready to be written to PROM, EPROM memories, etc.

## 📥 Download

You can download the latest version of the program, including all formats, from the **[Releases page](https://github.com/knightfox75/msx_diagnostics/releases/latest)**.

## 📸 Screenshots

| Main Menu | Joystick Test |
| :---: | :---: |
| ![Screenshot 1](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_02.png) | ![Screenshot 2](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_04.png) |
| Sound Test (PSG) | System Information |
| ![Screenshot 3](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_05.png) | ![Screenshot 4](https://msx-diagnostics.nightfoxandco.com/images/scr_shot_06.png) |

## 📜 License

This project is distributed under the Creative Commons license: **[Attribution-NonCommercial 4.0 International](https://creativecommons.org/licenses/by-nc/4.0/)**.

## 📧 Contact

For any questions or suggestions, you can get in touch at **contact@nightfoxandco.com**.
