// import modules
const express = require("express");
const cors = require("cors");
require("dotenv").config();

// import routes
const userRoutes = require("./routes/userRoutes");
const taskRoutes = require("./routes/taskRoutes");

const app = express();

// use required modules
app.use(cors());
app.use(express.json());

// use routes
app.use("/users", userRoutes);
app.use("/tasks", taskRoutes);

// set port server will listen on
const PORT = process.env.PORT;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
