const baseDatos = require('../config/base_datos');

exports.obtenerProductos = (req, res) => {
    const pagina = parseInt(req.query.page) || 1;
    const limite = 10;
    const desplazamiento = (pagina - 1) * limite;

    baseDatos.all(
        'SELECT * FROM productos LIMIT ? OFFSET ?',
        [limite, desplazamiento],
        (err, rows) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(rows);
        },
    );
};

exports.actualizarStock = (req, res) => {
    const { id, stockNuevo } = req.body;

    if (stockNuevo < 5) {
        console.log(`ALERTA PUSH: El producto ${id} tiene stock bajo (${stockNuevo})`);
    }

    baseDatos.run(
        'UPDATE productos SET stok = ? WHERE id = ?',
        [stockNuevo, id],
        function (err) {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ mensaje: 'Stock actualizado' });
        },
    );
};
