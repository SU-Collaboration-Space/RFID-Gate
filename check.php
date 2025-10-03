<?php
// Set the content type to JSON for the API response
header('Content-Type: application/json');

// --- DATABASE CREDENTIALS ---
$db_host = 'localhost';
$db_user = 'username'; // Change this to your database username
$db_pass = 'password'; // Change this to your database password
$db_name = 'your-rf-db'; // Change this to your database name

// Initialize the response array
$response = ['access_granted' => false, 'message' => 'Invalid request.', 'equipment_name' => null];

// 1. Check if the 'rfid' parameter was provided in the URL
if (isset($_GET['rfid']) && !empty($_GET['rfid'])) {
    $received_rfid = $_GET['rfid'];

    // 2. Connect to the database
    $conn = new mysqli($db_host, $db_user, $db_pass, $db_name);

    // Check connection
    if ($conn->connect_error) {
        $response['message'] = 'Database connection failed.';
    } else {
        // 3. Prepare a secure SQL statement to check for permission
        $stmt = $conn->prepare("SELECT allowed_to_leave, equipment_name FROM cs_equipment WHERE assigned_rfid = ?");
        $stmt->bind_param("s", $received_rfid);

        // 4. Execute the query
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows > 0) {
            // This block runs if the RFID was found in the cs_equipment table.

            // 5. Fetch the data FIRST to determine access status
            $row = $result->fetch_assoc();
            $can_leave = (bool)$row['allowed_to_leave']; // This will be true or false

            // --- 🔧 LOGGING LOGIC UPDATED AND MOVED HERE ---
            // Now we log the RFID and whether access was granted.
            $log_stmt = $conn->prepare("INSERT INTO rfid_logs (rfid_tag, is_allowed) VALUES (?, ?)");
            // "s" for string (rfid_tag), "i" for integer (the boolean can_leave becomes 1 or 0)
            $log_stmt->bind_param("si", $received_rfid, $can_leave);
            $log_stmt->execute();
            $log_stmt->close();
            // ----------------------------------------------

            // Set the response based on the now-determined database value
            $response['access_granted'] = $can_leave;
            $response['message'] = $can_leave ? 'Leave granted.' : 'Leave denied.';
            $response['equipment_name'] = $row['equipment_name'];

        } else {
            // This block runs if the RFID was NOT found.
            $response['access_granted'] = true;
            $response['message'] = 'Unknown RFID, access granted.';
            // No log is created for unknown tags.
        }

        // Close the statement and connection
        $stmt->close();
        $conn->close();
    }
} else {
    $response['message'] = 'RFID parameter is missing.';
}

// 6. Echo the final response as a JSON string
echo json_encode($response);
?>
