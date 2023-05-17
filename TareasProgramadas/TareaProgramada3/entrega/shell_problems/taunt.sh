#!/bin/bash

# Ajustar PATH para incluir el directorio cowsay
PATH=$PATH:/usr/games/cowsay

# Función para mensaje gracioso
gracioso() {
  cowsay -f cower "¡Nah! Lo que sea. Me iré a dormir Zzzz"
}

# Función para mensaje especial
especial() {
  cowsay -f flaming-sheep "¡Hey! ¿Quién me interrumpió?!"
}

# Función para mensaje de choteo
choteo() {
  cowsay -f dragon-and-cow "Jaja, te gané, humano."
}

# Función para manejar la señal SIGINT y SIGTERM
terminar() {
  choteo
  exit
}

# Mensaje inicial
cowsay "¡Hola! Estoy aquí para molestarte."

# Se prepara para capturar las señales
trap terminar INT TERM
trap especial HUP

# Bucle para esperar 10 segundos o una señal
while sleep 1; do
  # Verifica si se han recibido señales
  if [ -f ".hup_received" ]; then
    especial
    exit 
  fi
  
  if [ -f ".int_term_received" ]; then
    terminar
  fi
  
  # Verifica si han pasado los 10 segundos
  if [ "$SECONDS" -ge 10 ]; then
    gracioso
    exit 
  fi
done
