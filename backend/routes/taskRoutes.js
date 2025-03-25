const express = require("express");
const db = require("../dbConnection");
const authMiddleware = require('./authMiddleware');
const router = express.Router();

// get all tasks for a particular user, unfiltered and sorted by most recent
router.get('/:userId/tasks/', authMiddleware, async (req, res) => {
    try {
        const userId = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? ORDER BY date_created DESC';
        const [results] = await db.promise().execute(query, [userId]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ message: 'Failed to fetch', error: err.message });
    }
});


// get single task for a particular user by the task id
router.get('/:userId/tasks/:taskId/', authMiddleware, async (req, res) => {
    try {
        const userId = req.params.userId;
        const taskId = req.params.taskId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? AND id = ?';
        const [result] = await db.promise().execute(query, [userId, taskId]);

        if (result.length === 0) {
            return res.status(404).json({ messge: 'Task not found' });
        }

        res.status(200).json(result);
    } catch (err) {
        res.status(500).json({ message: 'Failed to fetch', error: err });
    }
});


// get all "Not Started" tasks for a particular user, sorted by due date
router.get('/:userId/tasks-not-started/', authMiddleware, async (req, res) => {
    try {
        const userId = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? AND task_status = \'Not Started\' ORDER BY due_date DESC';
        const [results] = await db.promise().execute(query, [userId]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ message: 'Failed to fetch', error: err.message });
    }
});


// get all "In Progress" tasks for a particular user, sorted by due date
router.get('/:userId/tasks-in-progress/', authMiddleware, async (req, res) => {
    try {
        const userId = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? AND task_status = \'In Progress\' ORDER BY due_date DESC';
        const [results] = await db.promise().execute(query, [userId]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ message: 'Failed to fetch', error: err.message });
    }
});


// get all "Completed" tasks for a particular user, sorted by due date
router.get('/:userId/tasks-completed/', authMiddleware, async (req, res) => {
    try {
        const userId = req.params.userId;
        const query = 'SELECT * FROM tasks WHERE user_id = ? AND task_status = \'Completed\' ORDER BY due_date DESC';
        const [results] = await db.promise().execute(query, [userId]);

        res.status(200).json(results);
    } catch (err) {
        res.status(500).json({ message: 'Failed to fetch', error: err.message });
    }
});


// create new task
router.post('/:userId/create-task/', authMiddleware, async (req, res) => {
    const userId = req.params.userId;
    let { title, description = '', due_date } = req.body;

    if (!title) {
        return res.status(400).json({ error: 'Missing title' });
    }

    try {
        let query = 'INSERT INTO tasks (user_id, title, description, due_date) VALUES (?, ?, ?, ?)';
        let params = [userId, title, description, null];

        if (due_date) {
            // convert to date object
            const formattedDueDate = new Date(due_date);

            // validate date
            if (isNaN(formattedDueDate.getTime())) {
                return res.status(400).json({ error: 'Invalid date format' });
            }

            // convert to MySQL format (YYYY-MM-DD HH:MM:SS)
            const mysqlFormattedDate = formattedDueDate.toISOString().slice(0, 19).replace('T', ' ');

            params[3] = mysqlFormattedDate;
        }

        const [result] = await db.promise().execute(query, params);

        res.status(201).json({ message: 'Task created successfully', taskId: result.insertId });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


// edit existing task
router.put('/:userId/tasks/:taskId/edit/', authMiddleware, async (req, res) => {
    const userId = req.params.userId;
    const taskId = req.params.taskId;
    let { title, description, due_date, task_status } = req.body;

    try {
        // make sure task exists
        let checkTaskQuery = 'SELECT * FROM tasks WHERE id = ? AND user_id = ?';
        const [taskResult] = await db.promise().execute(checkTaskQuery, [taskId, userId]);

        if (taskResult.length === 0) {
            return res.status(404).json({ message: 'Task not found' });
        }

        let updateQuery = 'UPDATE tasks SET title = ?, description = ?, due_date = ?, task_status = ? WHERE id = ? AND user_id = ?';
        let params = [title, description, due_date, task_status, taskId, userId];

        // set task completion date if set complete
        if (task_status == 'Completed') {
            const completionDate = new Date(); // will be set to datetime when executed
            updateQuery = 'UPDATE tasks SET title = ?, description = ?, due_date = ?, task_status = ?, date_completed = ? WHERE id = ? AND user_id = ?'
            params = [title, description, due_date, task_status, completionDate, taskId, userId];
        }

        // convert due_date to Date object
        const formattedDueDate = new Date(due_date);

        // validate date
        if (isNaN(formattedDueDate.getTime())) {
            return res.status(400).json({ error: 'Invalid date format' });
        }

        // convert to MySQL format (YYYY-MM-DD HH:MM:SS)
        const mysqlFormattedDate = formattedDueDate.toISOString().slice(0, 19).replace('T', ' ', 'Z', '');

        // update the param
        params[2] = mysqlFormattedDate;

        await db.promise().execute(updateQuery, params);

        res.status(200).json({ message: 'Task updated successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});


// delete an existing task
router.delete('/:userId/tasks/:taskId/delete', authMiddleware, async (req, res) => {
    try {
        const userId = req.params.userId;
        const taskId = req.params.taskId;

        // make sure task exists
        let checkTaskQuery = 'SELECT * FROM tasks WHERE id = ? AND user_id = ?';
        const [taskResult] = await db.promise().execute(checkTaskQuery, [taskId, userId]);

        if (taskResult.length === 0) {
            return res.status(404).json({ message: 'Task not found' });
        }

        const deleteQuery = 'DELETE FROM tasks WHERE id = ? AND user_id = ?';
        const [result] = await db.promise().execute(deleteQuery, [taskId, userId]);

        res.status(200).json({ message: 'Task deleted successfully' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;
