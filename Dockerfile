# Usar imagen base oficial de Node.js
FROM node:18-alpine

# Crear directorio de trabajo en el contenedor
WORKDIR /app

# Copiar package.json y package-lock.json
COPY package*.json ./

# Instalar dependencias
RUN npm install --production

# Copiar el código de la aplicación
COPY . .

# Exponer el puerto que usa la aplicación
EXPOSE 3000

# Definir el usuario no-root para seguridad
USER node

# Comando para ejecutar la aplicación
CMD ["npm", "start"]
