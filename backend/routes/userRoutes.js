const express = require("express");
const db = require("../dbConnection");
const router = express.Router();

// get all tasks for a particular user, unfiltered and ordered by most recent
router.get('/:userId/tasks/', (req, res) => {
    const id = req.params.userId;

    
});

module.exports = router;
