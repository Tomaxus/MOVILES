const express = require('express');
const router = express.Router();
const controladorProducto = require('../controllers/controlador_producto');

router.get('/', controladorProducto.obtenerProductos);
router.put('/stock', controladorProducto.actualizarStock);

module.exports = router;
