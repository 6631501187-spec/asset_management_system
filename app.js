const express = require('express');
const argon2 = require('@node-rs/argon2');
const con = require('./db');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// Test database connection on startup
con.query("SELECT 1", function(err) {
    if (err) {
        console.error('❌ Database connection failed!');
        console.error('Error:', err.message);
        console.error('\nPlease ensure:');
        console.error('1. MySQL server is running');
        console.error('2. Database "assets_borrowing" exists');
        console.error('3. Credentials in db.js are correct');
    } else {
        console.log('✓ Database connected successfully');
    }
});


//-------------------------- login ------------------------
app.post('/api/login', (req, res) => {
    const {user_id, password} = req.body;
    const sql = "SELECT user_id, username, password, role FROM users WHERE user_id = ?";
    con.query(sql, [user_id], function(err, results) {
        if(err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        if(results.length != 1) {
            return res.status(401).json({ error: "Invalid credentials" });
        }
        
        const user = results[0];
        
        // compare passwords using argon2id
        const same = argon2.verifySync(user.password, password);
        if(same) {
            // Generate a simple token (in production, use JWT)
            const token = 'simple_token_' + user.user_id + '_' + Date.now();
            
            return res.json({
                token: token,
                user: {
                    user_id: user.user_id,
                    username: user.username,
                    role: user.role
                }
            });
        }
        return res.status(401).json({ error: "Invalid credentials" });
    })
});

//-------------------------- register ------------------------
app.post('/api/register', (req, res) => {
    const { user_id, username, password, role = 'Student' } = req.body;

    // Check if user_id or username already exists
    const checkUserSql = "SELECT * FROM users WHERE user_id = ? OR username = ?";
    con.query(checkUserSql, [user_id, username], function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }

        if (results.length > 0) {
            const existingUser = results[0];
            if (existingUser.user_id == user_id) {
                return res.status(400).json({ error: "User ID already exists" });
            }
            if (existingUser.username === username) {
                return res.status(400).json({ error: "Username already exists" });
            }
        }

        // Hash password
        const hashedPassword = argon2.hashSync(password);

        // Insert new user with specified user_id
        const insertUserSql = "INSERT INTO users (user_id, username, password, role) VALUES (?, ?, ?, ?)";
        con.query(insertUserSql, [user_id, username, hashedPassword, role], function (err, result) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: "Database server error" });
            }

            res.status(201).json({ 
                message: 'User created successfully',
                user_id: user_id,
                username: username,
                role: role
            });
        });
    });
});

//-------------------------- Get user profile ------------------------
app.get('/api/user/:userId', (req, res) => {
    const userId = req.params.userId;
    const sql = "SELECT user_id, username, role, profile_image FROM users WHERE user_id = ?";
    
    con.query(sql, [userId], function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        
        if (results.length === 0) {
            return res.status(404).json({ error: "User not found" });
        }
        
        res.json(results[0]);
    });
});

//-------------------------- Update user profile ------------------------
app.put('/api/user/:userId', (req, res) => {
    const userId = req.params.userId;
    const { username, profile_image } = req.body;
    
    // Check if username is provided
    if (!username) {
        return res.status(400).json({ error: "Username is required" });
    }
    
    // Check if username is already taken by another user
    const checkUsernameSql = "SELECT user_id FROM users WHERE username = ? AND user_id != ?";
    con.query(checkUsernameSql, [username, userId], function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        
        if (results.length > 0) {
            return res.status(400).json({ error: "Username already taken" });
        }
        
        // Update user profile
        const updateSql = "UPDATE users SET username = ?, profile_image = ? WHERE user_id = ?";
        con.query(updateSql, [username, profile_image, userId], function (err, result) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: "Database server error" });
            }
            
            if (result.affectedRows === 0) {
                return res.status(404).json({ error: "User not found" });
            }
            
            res.json({ 
                message: 'Profile updated successfully',
                user_id: userId,
                username: username,
                profile_image: profile_image
            });
        });
    });
});

// Helper endpoint to generate hashed passwords for testing
app.get('/api/password/:plainPassword', async (req, res) => {
    try {
        const { plainPassword } = req.params;
        const hashedPassword = await argon2.hash(plainPassword);
        res.json({ 
            plainPassword, 
            hashedPassword,
            message: 'Use this hashed password in your database'
        });
    } catch (error) {
        res.status(500).json({ error: 'Error hashing password' });
    }
});

// Test page for emulator connectivity
app.get('/test', (req, res) => {
    res.sendFile(__dirname + '/test-connection.html');
});

// Server info endpoint
app.get('/api/info', (req, res) => {
    res.json({
        status: 'running',
        serverIP: '192.168.1.168',
        port: 3000,
        endpoints: [
            'POST /api/login',
            'POST /api/register',
            'GET /api/user/:userId',
            'PUT /api/user/:userId',
            'GET /api/password/:plainPassword',
            'GET /api/assets',
            'GET /api/requests/:userId',
            'POST /api/requests',
            'PUT /api/requests/:requestId',
            'GET /api/history/:userId',
            'GET /api/info',
            'GET /test'
        ],
        message: 'Backend API is running successfully',
        timestamp: new Date().toISOString()
    });
});

//========================== Assets API ======================================
//-------------------------- Get available assets ------------------------
app.get('/api/assets', (req, res) => {
    const sql = "SELECT asset_id, asset_name, asset_type, status, description, image_src FROM assets WHERE status = 'Available'";
    con.query(sql, function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

//-------------------------- Get all assets (for staff management) ------------------------
app.get('/api/assets/all', (req, res) => {
    const sql = "SELECT asset_id, asset_name, asset_type, status, description, image_src FROM assets ORDER BY asset_id DESC";
    con.query(sql, function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

//-------------------------- Get borrowed assets (for staff return page) ------------------------
app.get('/api/assets/borrowed', (req, res) => {
    const sql = `SELECT h.his_id, h.request_id, h.asset_id, h.user_id, h.borrowed_date, h.return_date,
                        a.asset_name, a.asset_type, a.description, a.image_src,
                        u.username as borrower_name
                 FROM history h
                 JOIN assets a ON h.asset_id = a.asset_id
                 JOIN users u ON h.user_id = u.user_id
                 WHERE h.status = 'Approved' AND a.status = 'Borrowed'
                 ORDER BY h.borrowed_date DESC`;
    con.query(sql, function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

//-------------------------- Disable asset (staff only) ------------------------
app.put('/api/assets/:assetId/disable', (req, res) => {
    const assetId = req.params.assetId;
    
    // Check if asset exists and is Available
    const checkAssetSql = "SELECT status FROM assets WHERE asset_id = ?";
    con.query(checkAssetSql, [assetId], function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        
        if (results.length === 0) {
            return res.status(404).json({ error: "Asset not found" });
        }
        
        if (results[0].status !== 'Available') {
            return res.status(400).json({ error: "Only available assets can be disabled" });
        }
        
        // Update asset status to Disabled
        const updateSql = "UPDATE assets SET status = 'Disabled' WHERE asset_id = ?";
        con.query(updateSql, [assetId], function (err) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: "Database server error" });
            }
            
            res.json({ message: 'Asset disabled successfully' });
        });
    });
});

//-------------------------- Enable asset (staff only) ------------------------
app.put('/api/assets/:assetId/enable', (req, res) => {
    const assetId = req.params.assetId;
    
    // Update asset status to Available
    const updateSql = "UPDATE assets SET status = 'Available' WHERE asset_id = ? AND status = 'Disabled'";
    con.query(updateSql, [assetId], function (err, result) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: "Asset not found or not disabled" });
        }
        
        res.json({ message: 'Asset enabled successfully' });
    });
});

//-------------------------- Update asset (staff only) ------------------------
app.put('/api/assets/:assetId', (req, res) => {
    const assetId = req.params.assetId;
    const { asset_name, asset_type, status, description, image_src } = req.body;

    if (!asset_name || !asset_type || !status || !description) {
        return res.status(400).json({ error: "asset_name, asset_type, status, and description are required" });
    }

    const updateSql = "UPDATE assets SET asset_name = ?, asset_type = ?, status = ?, description = ?, image_src = ? WHERE asset_id = ?";
    con.query(updateSql, [asset_name, asset_type, status, description, image_src, assetId], function (err, result) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: "Asset not found" });
        }

        res.json({ message: 'Asset updated successfully' });
    });
});

//-------------------------- Add new asset (staff only) ------------------------
app.post('/api/assets', (req, res) => {
    const { asset_name, asset_type, status, description, image_src } = req.body;

    // Validation
    if (!asset_name || !asset_type || !status || !description) {
        return res.status(400).json({ error: "Missing required fields: asset name, type, status, and description are required" });
    }

    // Only allow Available or Disabled status for new assets
    if (status !== 'Available' && status !== 'Disabled') {
        return res.status(400).json({ error: "Status must be Available or Disabled" });
    }

    const sql = `INSERT INTO assets (asset_name, asset_type, status, description, image_src) 
                 VALUES (?, ?, ?, ?, ?)`;
    
    con.query(sql, [asset_name, asset_type, status, description, image_src || null], function(err, result) {
        if (err) {
            console.error('Error adding asset:', err.message);
            return res.status(500).json({ error: "Database server error" });
        }

        res.json({ 
            message: 'Asset added successfully',
            asset_id: result.insertId
        });
    });
});

//========================== Requests API ====================================
//-------------------------- Get ALL pending requests (for lecturers/staff) ------------------------
app.get('/api/requests', (req, res) => {
    const sql = `SELECT r.req_id, r.asset_id, r.user_id, r.borrow_date, r.return_date, r.status,
                        a.asset_name, a.asset_type, a.description, a.image_src, a.status as asset_status,
                        u.username as borrower_name
                 FROM requests r 
                 JOIN assets a ON r.asset_id = a.asset_id 
                 JOIN users u ON r.user_id = u.user_id
                 WHERE r.status = 'Pending'
                 ORDER BY r.borrow_date DESC`;
    con.query(sql, function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

//-------------------------- Get returned requests (for staff return page) ------------------------
app.get('/api/requests/returned/all', (req, res) => {
    const sql = `SELECT r.req_id, r.asset_id, r.user_id, r.borrow_date, r.return_date, r.status,
                        a.asset_name, a.asset_type, a.description, a.image_src, a.status as asset_status,
                        u.username as borrower_name
                 FROM requests r 
                 JOIN assets a ON r.asset_id = a.asset_id 
                 JOIN users u ON r.user_id = u.user_id
                 LEFT JOIN history h ON r.req_id = h.request_id
                 WHERE r.status = 'Returned' AND (h.status IS NULL OR h.status != 'Returned')
                 ORDER BY r.borrow_date DESC`;
    con.query(sql, function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

//-------------------------- Get user's requests ------------------------
app.get('/api/requests/:userId', (req, res) => {
    const userId = req.params.userId;
    const sql = `SELECT r.req_id, r.asset_id, r.user_id, r.borrow_date, r.return_date, r.status,
                        a.asset_name, a.asset_type, a.description, a.image_src, a.status as asset_status
                 FROM requests r 
                 JOIN assets a ON r.asset_id = a.asset_id 
                 WHERE r.user_id = ?
                 ORDER BY r.req_id DESC`;
    con.query(sql, [userId], function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

//-------------------------- Create new request ------------------------
app.post('/api/requests', (req, res) => {
    const { asset_id, user_id } = req.body;
    
    // Check if user has an active (non-rejected) request today
    // Students can make a new request if their previous request was rejected
    const now = new Date();
    const today = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
    const checkTodayRequestSql = `SELECT COUNT(*) as count FROM requests r 
                                  WHERE r.user_id = ? 
                                  AND DATE(r.borrow_date) = ? 
                                  AND r.status IN ('Pending', 'Approved', 'Returned')`;
    
    con.query(checkTodayRequestSql, [user_id, today], function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        
        if (results[0].count > 0) {
            return res.status(400).json({ error: "You already have an active request for today. You can only have one active request per day." });
        }
        
        // Check if asset is available
        const checkAssetSql = "SELECT status FROM assets WHERE asset_id = ?";
        con.query(checkAssetSql, [asset_id], function (err, assetResults) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: "Database server error" });
            }
            
            if (assetResults.length === 0) {
                return res.status(404).json({ error: "Asset not found" });
            }
            
            if (assetResults[0].status !== 'Available') {
                return res.status(400).json({ error: "Asset is not available" });
            }
            
            // Create request and update asset status
            // Use date-only strings to avoid timezone issues
            const now = new Date();
            const borrowDate = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;
            const tomorrow = new Date(now);
            tomorrow.setDate(tomorrow.getDate() + 1);
            const returnDate = `${tomorrow.getFullYear()}-${String(tomorrow.getMonth() + 1).padStart(2, '0')}-${String(tomorrow.getDate()).padStart(2, '0')}`;
            
            const insertRequestSql = "INSERT INTO requests (asset_id, user_id, borrow_date, return_date, status) VALUES (?, ?, ?, ?, 'Pending')";
            con.query(insertRequestSql, [asset_id, user_id, borrowDate, returnDate], function (err, result) {
                if (err) {
                    console.error(err.message);
                    return res.status(500).json({ error: "Database server error" });
                }
                
                // Update asset status to Pending
                const updateAssetSql = "UPDATE assets SET status = 'Pending' WHERE asset_id = ?";
                con.query(updateAssetSql, [asset_id], function (err) {
                    if (err) {
                        console.error(err.message);
                        return res.status(500).json({ error: "Database server error" });
                    }
                    
                    res.status(201).json({ 
                        message: 'Request submitted successfully',
                        request_id: result.insertId 
                    });
                });
            });
        });
    });
});

//-------------------------- Update request status (approve/return) ------------------------
app.put('/api/requests/:requestId', (req, res) => {
    const requestId = req.params.requestId;
    const { action, approver_id, reject_reason } = req.body; // action: 'approve', 'reject', 'return'
    
    if (action === 'approve') {
        // Get request details first
        const getRequestSql = "SELECT * FROM requests WHERE req_id = ?";
        con.query(getRequestSql, [requestId], function (err, results) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: "Database server error" });
            }
            
            if (results.length === 0) {
                return res.status(404).json({ error: "Request not found" });
            }
            
            const request = results[0];
            
            // Update asset status to Borrowed
            const updateAssetSql = "UPDATE assets SET status = 'Borrowed' WHERE asset_id = ?";
            con.query(updateAssetSql, [request.asset_id], function (err) {
                if (err) {
                    console.error(err.message);
                    return res.status(500).json({ error: "Database server error" });
                }
                
                // Add to history with Approved status
                const insertHistorySql = `INSERT INTO history (request_id, asset_id, user_id, borrowed_date, approver_id, return_date, reject_reason, status) 
                                          VALUES (?, ?, ?, ?, ?, NULL, NULL, 'Approved')`;
                con.query(insertHistorySql, [requestId, request.asset_id, request.user_id, request.borrow_date, approver_id], function (err) {
                    if (err) {
                        console.error(err.message);
                        return res.status(500).json({ error: "Database server error" });
                    }
                    
                    // Update request status to Approved (keep in requests table)
                    const updateRequestSql = "UPDATE requests SET status = 'Approved' WHERE req_id = ?";
                    con.query(updateRequestSql, [requestId], function (err) {
                        if (err) {
                            console.error(err.message);
                            return res.status(500).json({ error: "Database server error" });
                        }
                        
                        res.json({ message: 'Request approved successfully' });
                    });
                });
            });
        });
    } else if (action === 'reject') {
        // Get request details first
        const getRequestSql = "SELECT * FROM requests WHERE req_id = ?";
        con.query(getRequestSql, [requestId], function (err, results) {
            if (err) {
                console.error(err.message);
                return res.status(500).json({ error: "Database server error" });
            }
            
            if (results.length === 0) {
                return res.status(404).json({ error: "Request not found" });
            }
            
            const request = results[0];
            
            // Update asset status back to Available
            const updateAssetSql = "UPDATE assets SET status = 'Available' WHERE asset_id = ?";
            con.query(updateAssetSql, [request.asset_id], function (err) {
                if (err) {
                    console.error(err.message);
                    return res.status(500).json({ error: "Database server error" });
                }
                
                // Add to history with Rejected status (return_date should be NULL for rejected requests)
                const insertHistorySql = `INSERT INTO history (request_id, asset_id, user_id, borrowed_date, approver_id, return_date, reject_reason, status) 
                                          VALUES (?, ?, ?, ?, ?, NULL, ?, 'Rejected')`;
                con.query(insertHistorySql, [requestId, request.asset_id, request.user_id, request.borrow_date, approver_id, reject_reason || ''], function (err) {
                    if (err) {
                        console.error(err.message);
                        return res.status(500).json({ error: "Database server error" });
                    }
                    
                    // Update request status to Rejected
                    const updateRequestSql = "UPDATE requests SET status = 'Rejected' WHERE req_id = ?";
                    con.query(updateRequestSql, [requestId], function (err) {
                        if (err) {
                            console.error(err.message);
                            return res.status(500).json({ error: "Database server error" });
                        }

                        res.json({ message: 'Request rejected successfully' });
                    });
                });
            });
        });
    } else if (action === 'return') {
        // Student-initiated return: Mark Approved request as Returned
        console.log(`[STUDENT_RETURN] Request ID: ${requestId}, User ID: ${req.body.user_id}`);
        // The request must be in 'Approved' status
        const getRequestSql = "SELECT * FROM requests WHERE req_id = ? AND status = 'Approved'";
        con.query(getRequestSql, [requestId], function (err, results) {
            if (err) {
                console.error('[STUDENT_RETURN ERROR] Get request:', err.message);
                return res.status(500).json({ error: "Database server error" });
            }
            
            if (results.length === 0) {
                console.log('[STUDENT_RETURN] No approved request found for ID:', requestId);
                return res.status(404).json({ error: "Approved request not found" });
            }
            
            console.log('[STUDENT_RETURN] Found approved request, updating to Returned');
            // Update request status to Returned
            const updateRequestSql = "UPDATE requests SET status = 'Returned' WHERE req_id = ?";
            con.query(updateRequestSql, [requestId], function (err, result) {
                if (err) {
                    console.error('[STUDENT_RETURN ERROR] Update request:', err.message);
                    return res.status(500).json({ error: "Database server error" });
                }
                console.log(`[STUDENT_RETURN] ✓ Request updated to Returned. Rows affected: ${result.affectedRows}`);
                
                res.json({ message: 'Return request submitted successfully' });
            });
        });
    } else if (action === 'confirm_return') {
        // Staff-initiated return confirmation: Update history status and return_date
        console.log(`[CONFIRM_RETURN] Request ID: ${requestId}, Staff ID: ${req.body.staff_id}`);
        const getRequestSql = "SELECT * FROM requests WHERE req_id = ? AND status = 'Returned'";
        con.query(getRequestSql, [requestId], function (err, results) {
            if (err) {
                console.error('[CONFIRM_RETURN ERROR] Get request:', err.message);
                return res.status(500).json({ error: "Database server error" });
            }
            
            if (results.length === 0) {
                console.log('[CONFIRM_RETURN] No returned request found for ID:', requestId);
                return res.status(404).json({ error: "Returned request not found" });
            }
            
            const request = results[0];
            const staff_id = req.body.staff_id; // Staff member who confirmed the return
            // Use local date string to avoid timezone issues
            const now = new Date();
            const today = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`;

            console.log(`[CONFIRM_RETURN] Found request. Asset ID: ${request.asset_id}, Date: ${today}`);
            
            // Update asset status to Available
            const updateAssetSql = "UPDATE assets SET status = 'Available' WHERE asset_id = ?";
            con.query(updateAssetSql, [request.asset_id], function (err, result) {
                if (err) {
                    console.error('[CONFIRM_RETURN ERROR] Update asset:', err.message);
                    return res.status(500).json({ error: "Database server error" });
                }
                console.log(`[CONFIRM_RETURN] Asset updated. Rows affected: ${result.affectedRows}`);
                
                // Update existing history record: set status to 'Returned', update return_date and staff_id
                const updateHistorySql = `UPDATE history 
                                         SET status = 'Returned', return_date = ?, staff_id = ? 
                                         WHERE request_id = ?`;
                con.query(updateHistorySql, [today, staff_id, requestId], function (err, result) {
                    if (err) {
                        console.error('[CONFIRM_RETURN ERROR] Update history:', err.message);
                        return res.status(500).json({ error: "Database server error" });
                    }
                    console.log(`[CONFIRM_RETURN] History updated. Rows affected: ${result.affectedRows}`);
                    
                    // Update request status to 'Confirmed' to mark as completed
                    const updateRequestSql = "UPDATE requests SET status = 'Confirmed' WHERE req_id = ?";
                    con.query(updateRequestSql, [requestId], function (err, result) {
                        if (err) {
                            console.error('[CONFIRM_RETURN ERROR] Update request:', err.message);
                            return res.status(500).json({ error: "Database server error" });
                        }
                        console.log(`[CONFIRM_RETURN] Request updated. Rows affected: ${result.affectedRows}`);
                        console.log('[CONFIRM_RETURN] ✓ All updates completed successfully');
                        
                        res.json({ message: 'Asset return confirmed successfully' });
                    });
                });
            });
        });
    } else {
        res.status(400).json({ error: "Invalid action" });
    }
});

//========================== History API =====================================
// Get all history (for lecturers and staff)
app.get('/api/history', (req, res) => {
    const sql = `SELECT h.his_id, h.request_id, h.asset_id, h.user_id, h.status, 
                        h.approver_id, h.reject_reason, h.staff_id, h.borrowed_date, h.return_date,
                        a.asset_name, a.asset_type, a.description, a.image_src,
                        u.username as borrower_name,
                        approver.username as approver_name,
                        staff.username as staff_name
                 FROM history h 
                 LEFT JOIN assets a ON h.asset_id = a.asset_id 
                 LEFT JOIN users u ON h.user_id = u.user_id
                 LEFT JOIN users approver ON h.approver_id = approver.user_id
                 LEFT JOIN users staff ON h.staff_id = staff.user_id
                 ORDER BY h.his_id DESC`;
    con.query(sql, function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

// Get user history by userId
app.get('/api/history/:userId', (req, res) => {
    const userId = req.params.userId;
    const sql = `SELECT h.his_id, h.request_id, h.asset_id, h.user_id, h.status, 
                        h.approver_id, h.reject_reason, h.staff_id, h.borrowed_date, h.return_date,
                        a.asset_name, a.asset_type, a.description, a.image_src,
                        approver.username as approver_name,
                        staff.username as staff_name
                 FROM history h 
                 LEFT JOIN assets a ON h.asset_id = a.asset_id 
                 LEFT JOIN users approver ON h.approver_id = approver.user_id
                 LEFT JOIN users staff ON h.staff_id = staff.user_id
                 WHERE h.user_id = ?
                 ORDER BY h.his_id DESC`;
    
    console.log(`[GET /api/history/:userId] Fetching history for user: ${userId}`);
    
    con.query(sql, [userId], function (err, results) {
        if (err) {
            console.error('[GET /api/history/:userId] Database error:', err);
            console.error('SQL State:', err.sqlState);
            console.error('SQL Message:', err.sqlMessage);
            return res.status(500).json({ 
                error: "Database server error",
                details: err.sqlMessage 
            });
        }
        console.log(`[GET /api/history/:userId] Found ${results.length} records for user ${userId}`);
        res.json(results);
    });
});


// Get history filtered by approver_id (for lecturers)
app.get('/api/history/approver/:approverId', (req, res) => {
    const approverId = req.params.approverId;
    const sql = `SELECT h.his_id, h.request_id, h.asset_id, h.user_id, h.status, 
                        h.approver_id, h.reject_reason, h.staff_id, h.borrowed_date, h.return_date,
                        a.asset_name, a.asset_type, a.description, a.image_src,
                        u.username as borrower_name,
                        approver.username as approver_name
                 FROM history h 
                 LEFT JOIN assets a ON h.asset_id = a.asset_id 
                 LEFT JOIN users u ON h.user_id = u.user_id
                 LEFT JOIN users approver ON h.approver_id = approver.user_id
                 WHERE h.approver_id = ?
                 ORDER BY h.his_id DESC`;
    con.query(sql, [approverId], function (err, results) {
        if (err) {
            console.error(err.message);
            return res.status(500).json({ error: "Database server error" });
        }
        res.json(results);
    });
});

//=================== Starting server =======================
const port = 3000;
app.listen(port, '0.0.0.0', () => {
    console.log('Server is running at ' + port);
    console.log('Available at:');
    console.log('  - http://localhost:3000');
    console.log('  - http://10.0.2.2:3000 (Android emulator)');
    console.log('  - http://192.168.1.168:3000 (Network IP)');
});

