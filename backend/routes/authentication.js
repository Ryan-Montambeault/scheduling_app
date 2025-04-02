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
        const query = "SELECT id, full_name, email, password FROM users WHERE email = ?";
        const [users] = await db.promise().execute(query, [email]);

        if (users.length === 0) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        const user = users[0];

        // Compare passwords directly
        if (password !== user.password) {
            return res.status(401).json({ message: "Invalid email or password" });
        }

        res.status(200).json({ message: "Login successful", userId: user.id, userName: user.full_name });
    } catch (err) {
        res.status(500).json({ message: "Login failed", error: err.message });
    }
});

module.exports = router;
