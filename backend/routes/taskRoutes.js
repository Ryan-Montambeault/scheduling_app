const express = require("express");
const db = require("../dbConnection");
const router = express.Router();

// get all tasks for a particular user, unfiltered and sorted by most recent
router.get('/:userId/tasks/', async (req, res) => {
    try {
        const id = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? ORDER BY date_created DESC';

        const [results] = await db.promise().execute(query, [id]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


// get all "Not Started" tasks for a particular user, sorted by due date
router.get('/:userId/tasks-not-started/', async (req, res) => {
    try {
        const id = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? AND task_status = \'Not Started\' ORDER BY due_date DESC';

        const [results] = await db.promise().execute(query, [id]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


// get all "In Progress" tasks for a particular user, sorted by due date
router.get('/:userId/tasks-in-progress/', async (req, res) => {
    try {
        const id = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? AND task_status = \'In Progress\' ORDER BY due_date DESC';

        const [results] = await db.promise().execute(query, [id]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


// get all "Completed" tasks for a particular user, sorted by due date
router.get('/:userId/tasks-completed/', async (req, res) => {
    try {
        const id = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? AND task_status = \'Completed\' ORDER BY due_date DESC';

        const [results] = await db.promise().execute(query, [id]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
