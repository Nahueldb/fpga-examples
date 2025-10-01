# PWM

1/10/2025

---

Con

- RC = 1000E-6
- fPWM de 12 Mhz
- fSIN = 12 Hz

Se obtiene la siguiente señal de salida del filtro RC que pareceria estar sobresampleada:

![pwm_signal](pwm_rc_filter1.png)

---
Cambiando la resolucion del dac de 12 a 16 bits y un RC = 2000E-6, se obtiene la siguiente señal:

![pwm_signal](pwm_rc_filter.png)