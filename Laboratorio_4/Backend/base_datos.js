const sqlite3 = require("sqlite3").verbose();

const baseDatos = new sqlite3.Database("usuarios.db");

baseDatos.serialize(() => {
  baseDatos.run(
    "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE NOT NULL, password_hash TEXT NOT NULL)"
  );
});

module.exports = baseDatos;
