const express = require("express");
const db = require("../dbConnection");
const router = express.Router();

// User login route
router.post("/login", async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: "Email and password are required" });
    }

    try {
        // Fetch user by email
        const query = "SELECT id, email, password FROM users WHERE email = ?";
        const [users] = await db.promise().execute(query, [email]);

        if (users.length === 0) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        const user = users[0];

        // Compare passwords directly
        if (password !== user.password) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        // Store user session if needed
        req.session.userId = user.id;

        res.status(200).json({ message: "Login successful", userId: user.id });
    } catch (err) {
        res.status(500).json({ message: "Login failed", error: err.message });
    }
});


// User logout route
router.post("/logout", (req, res) => {
    if (req.session.userId) {
        req.session.destroy((err) => {
            if (err) {
                return res.status(500).json({ message: "Logout failed", error: err.message });
            }
            res.clearCookie("connect.sid"); // Clear the session cookie
            return res.status(200).json({ message: "Logout successful" });
        });
    } else {
        return res.status(400).json({ message: "User is not logged in" });
    }
});

module.exports = router;
