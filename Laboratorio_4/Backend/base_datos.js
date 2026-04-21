const sqlite3 = require("sqlite3").verbose();

// Esta conexion abre (o crea) el archivo local donde se guardan los usuarios.
const baseDatos = new sqlite3.Database("usuarios.db");

// Al iniciar, nos aseguramos de tener la tabla principal lista para usar.
baseDatos.serialize(() => {
  baseDatos.run(
    // Guardamos usuario unico y su contrasena en hash para no exponer texto plano.
    "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, password_hash TEXT NOT NULL, biometria_habilitada INTEGER NOT NULL DEFAULT 0)"
  );

  // Si la tabla ya existia sin biometria_habilitada, agregamos la columna.
  baseDatos.all("PRAGMA table_info(users)", (err, columnas) => {
    if (err || !Array.isArray(columnas)) {
      return;
    }

    const existeColumna = columnas.some(
      (columna) => columna.name === "biometria_habilitada"
    );

    if (!existeColumna) {
      baseDatos.run(
        "ALTER TABLE users ADD COLUMN biometria_habilitada INTEGER NOT NULL DEFAULT 0"
      );
    }
  });
});

// Exportamos la conexion para reutilizarla en rutas y operaciones del servidor.
module.exports = baseDatos;
