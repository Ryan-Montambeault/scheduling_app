// import modules
const express = require("express");
const cors = require("cors");
require("dotenv").config();

// import routes
const loginRoutes = require("./routes/loginRoutes");
const userRoutes = require("./routes/userRoutes");

const app = express();

// use required modules
app.use(cors());
app.use(express.json());

// use routes
app.use("/login", loginRoutes);
app.use("/users", userRoutes);

// set port server will listen on
const PORT = process.env.PORT;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
