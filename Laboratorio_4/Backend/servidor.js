const express = require("express");
const cors = require("cors");
const bcrypt = require("bcrypt");
const baseDatos = require("./base_datos");

// Creamos la app HTTP principal del backend.
const app = express();

// Habilitamos CORS y lectura de JSON en el body de las peticiones.
app.use(cors());
app.use(express.json());

// Este helper siembra un usuario basico para pruebas cuando no existe.
const crearUsuarioInicial = () => {
  const usuario = process.env.SEED_USER || "test";
  const contrasena = process.env.SEED_PASSWORD || "test";

  // Buscamos por username para evitar duplicar el usuario seed.
  baseDatos.get(
    "SELECT id FROM users WHERE username = ?",
    [usuario],
    async (err, row) => {
      // Si hay error o ya existe, no hacemos nada y seguimos.
      if (err || row) {
        return;
      }

      try {
        // Nunca guardamos la contrasena plana; primero generamos hash.
        const hashContrasena = await bcrypt.hash(contrasena, 10);
        baseDatos.run(
          "INSERT INTO users (username, password_hash) VALUES (?, ?)",
          [usuario, hashContrasena]
        );
      } catch (_) {
        // Si falla el hash o insert, evitamos romper el arranque del servidor.
        return;
      }
    }
  );
};

// Ejecutamos el seed al levantar la app.
crearUsuarioInicial();

// Ruta de registro: crea una cuenta nueva en la base de datos.
app.post("/register", async (req, res) => {
  // Aceptamos nombres alternativos para mantener compatibilidad del cliente.
  const { usuario, contrasena, username, password, biometriaHabilitada } =
    req.body || {};
  const usuarioFinal = usuario || username;
  const contrasenaFinal = contrasena || password;
  const biometriaFinal = Boolean(biometriaHabilitada);

  // Validacion minima de campos obligatorios.
  if (!usuarioFinal || !contrasenaFinal) {
    return res
      .status(400)
      .json({ mensaje: "usuario y contrasena son requeridos" });
  }

  // Este flujo exige activar biometria al registrar la cuenta.
  if (!biometriaFinal) {
    return res
      .status(400)
      .json({ mensaje: "biometria requerida para registrar" });
  }

  try {
    // Hash seguro antes de insertar el nuevo registro.
    const hashContrasena = await bcrypt.hash(contrasenaFinal, 10);
    baseDatos.run(
      "INSERT INTO users (username, password_hash, biometria_habilitada) VALUES (?, ?, ?)",
      [usuarioFinal, hashContrasena, biometriaFinal ? 1 : 0],
      function (err) {
        // Manejamos usuario repetido y errores generales por separado.
        if (err) {
          if (err.message && err.message.includes("UNIQUE")) {
            return res.status(409).json({ mensaje: "usuario ya existe" });
          }
          return res.status(500).json({ mensaje: "error al registrar" });
        }
        // Si todo sale bien, respondemos con el id creado.
        return res
          .status(201)
          .json({ mensaje: "registro exitoso", idUsuario: this.lastID });
      }
    );
  } catch (error) {
    // Captura de errores inesperados durante el proceso de registro.
    return res.status(500).json({ mensaje: "error al registrar" });
  }
});

// Ruta de login: valida credenciales y devuelve datos basicos del usuario.
app.post("/login", (req, res) => {
  const { usuario, contrasena, username, password } = req.body || {};
  const usuarioFinal = usuario || username;
  const contrasenaFinal = contrasena || password;

  // Si faltan campos, cortamos temprano con respuesta 400.
  if (!usuarioFinal || !contrasenaFinal) {
    return res
      .status(400)
      .json({ mensaje: "usuario y contrasena son requeridos" });
  }

  // Buscamos el usuario y su hash para comparar contrasena.
  baseDatos.get(
    "SELECT id, username, password_hash, biometria_habilitada FROM users WHERE username = ?",
    [usuarioFinal],
    async (err, row) => {
      if (err) {
        return res.status(500).json({ mensaje: "error al iniciar sesion" });
      }

      // Si no existe usuario, devolvemos credenciales invalidas.
      if (!row) {
        return res.status(401).json({ mensaje: "credenciales invalidas" });
      }

      // Comparamos contrasena enviada contra el hash guardado.
      const ok = await bcrypt.compare(contrasenaFinal, row.password_hash);
      if (!ok) {
        return res.status(401).json({ mensaje: "credenciales invalidas" });
      }

      // Login correcto: devolvemos mensaje y username.
      return res
        .status(200)
        .json({
          mensaje: "login exitoso",
          usuario: row.username,
          biometriaHabilitada: row.biometria_habilitada === 1,
        });
    }
  );
});

// Puerto configurable por entorno para despliegue flexible.
const PUERTO = process.env.PORT || 3000;
app.listen(PUERTO, () => {
  console.log(`Servidor escuchando en http://localhost:${PUERTO}`);
});
