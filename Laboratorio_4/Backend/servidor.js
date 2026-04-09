const express = require("express");
const cors = require("cors");
const bcrypt = require("bcrypt");
const baseDatos = require("./base_datos");

const app = express();

app.use(cors());
app.use(express.json());

const crearUsuarioInicial = () => {
  const usuario = process.env.SEED_USER || "test";
  const contrasena = process.env.SEED_PASSWORD || "test";

  baseDatos.get(
    "SELECT id FROM users WHERE username = ?",
    [usuario],
    async (err, row) => {
      if (err || row) {
        return;
      }

      try {
        const hashContrasena = await bcrypt.hash(contrasena, 10);
        baseDatos.run(
          "INSERT INTO users (username, password_hash) VALUES (?, ?)",
          [usuario, hashContrasena]
        );
      } catch (_) {
        return;
      }
    }
  );
};

crearUsuarioInicial();

app.post("/register", async (req, res) => {
  const { usuario, contrasena, username, password } = req.body || {};
  const usuarioFinal = usuario || username;
  const contrasenaFinal = contrasena || password;

  if (!usuarioFinal || !contrasenaFinal) {
    return res
      .status(400)
      .json({ mensaje: "usuario y contrasena son requeridos" });
  }

  try {
    const hashContrasena = await bcrypt.hash(contrasenaFinal, 10);
    baseDatos.run(
      "INSERT INTO users (username, password_hash) VALUES (?, ?)",
      [usuarioFinal, hashContrasena],
      function (err) {
        if (err) {
          if (err.message && err.message.includes("UNIQUE")) {
            return res.status(409).json({ mensaje: "usuario ya existe" });
          }
          return res.status(500).json({ mensaje: "error al registrar" });
        }
        return res
          .status(201)
          .json({ mensaje: "registro exitoso", idUsuario: this.lastID });
      }
    );
  } catch (error) {
    return res.status(500).json({ mensaje: "error al registrar" });
  }
});

app.post("/login", (req, res) => {
  const { usuario, contrasena, username, password } = req.body || {};
  const usuarioFinal = usuario || username;
  const contrasenaFinal = contrasena || password;

  if (!usuarioFinal || !contrasenaFinal) {
    return res
      .status(400)
      .json({ mensaje: "usuario y contrasena son requeridos" });
  }

  baseDatos.get(
    "SELECT id, username, password_hash FROM users WHERE username = ?",
    [usuarioFinal],
    async (err, row) => {
      if (err) {
        return res.status(500).json({ mensaje: "error al iniciar sesion" });
      }

      if (!row) {
        return res.status(401).json({ mensaje: "credenciales invalidas" });
      }

      const ok = await bcrypt.compare(contrasenaFinal, row.password_hash);
      if (!ok) {
        return res.status(401).json({ mensaje: "credenciales invalidas" });
      }

      return res
        .status(200)
        .json({ mensaje: "login exitoso", usuario: row.username });
    }
  );
});

const PUERTO = process.env.PORT || 3000;
app.listen(PUERTO, () => {
  console.log(`Servidor escuchando en http://localhost:${PUERTO}`);
});
