const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const rutaDb = path.resolve(__dirname, '../database.sqlite');
const db = new sqlite3.Database(rutaDb);

db.serialize(() => {
    db.run(`CREATE TABLE IF NOT EXISTS productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        calificacion REAL,
        descripcion TEXT,
        stok INTEGER,
        imagen TEXT
    )`);

    db.get('SELECT COUNT(*) as count FROM productos', (err, row) => {
        if (row && row.count === 0) {
            console.log('Insertando 50 productos iniciales...');

            const productos = require('./productos.json');
            const stmt = db.prepare(
                'INSERT INTO productos (nombre, calificacion, descripcion, stok, imagen) VALUES (?, ?, ?, ?, ?)',
            );

            productos.forEach((p) => {
                stmt.run(p.nombre, p.calificacion, p.descripcion, p.stok, p.imagen);
            });

            stmt.finalize();
            console.log('Base de datos poblada con exito');
        } else {
            console.log('La base de datos ya tiene datos.');
        }
    });
});

module.exports = db;
