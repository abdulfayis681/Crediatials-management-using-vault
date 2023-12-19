const express = require("express");

const mongoose = require("mongoose");
require("dotenv").config();

const routes = require("./routes/TaskRoute");

const cors = require("cors");

const app = express();
const PORT = process.env.PORT | 5000;

app.use(express.json());
app.use(cors());

mongoose
  .connect("mongodb://root:password@mongodb-0.mongodb-headless.default.svc.cluster.local:27017")
  .then(() => console.log("MongoDB Connected..."))
  .catch((err) => console.log(err));

app.use("/api", routes);

app.listen(PORT, () => console.log(`Listening at ${PORT}`));
