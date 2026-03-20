const express = require('express');
const cors = require('cors');
const rutasProducto = require('./routes/rutas_producto');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/productos', rutasProducto);

const PUERTO = 3000;
app.listen(PUERTO, () => {
    console.log(`Servidor corriendo en http://localhost:${PUERTO}`);
});
