// import modules
require("dotenv").config();
const express = require("express");
const cors = require("cors");
const session = require("express-session");

// import routes
const authentication = require("./routes/authentication");
const taskRoutes = require("./routes/taskRoutes");

const app = express();

// use required modules
app.use(cors());
app.use(express.json());

// session middleware
app.use(session({
    secret: process.env.SESSION_SECRET || "secret",
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

// use routes
app.use("/authentication", authentication);
app.use("/users", taskRoutes);

// set port server will listen on
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
