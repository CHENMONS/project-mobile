<?php
header('Content-Type: application/json');

// Koneksi ke database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "sewa_mobil"; // Ganti dengan nama database Anda

$conn = new mysqli($servername, $username, $password, $dbname);

// Periksa koneksi
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Mendapatkan metode HTTP
$request = $_SERVER['REQUEST_METHOD'];

switch ($request) {
    case "GET":
        // GET mobil berdasarkan id
        if (isset($_GET['id'])) {
            $sql = "SELECT * FROM cars WHERE id=" . $_GET['id'];
            $result = $conn->query($sql);
            $row = $result->fetch_assoc();
            echo json_encode(["success" => true, "message" => "Car fetched", "data" => $row]);
        }
        // GET mobil berdasarkan pencarian
        else if (isset($_GET['search'])) {
            $search = "%" . $_GET['search'] . "%";
            $sql = "SELECT * FROM cars WHERE name LIKE '$search'";
            $result = $conn->query($sql);
            $cars = [];
            while ($row = $result->fetch_assoc()) {
                $cars[] = $row;
            }
            echo json_encode(["success" => true, "message" => "Cars fetched", "data" => $cars]);
        }
        // GET semua mobil
        else {
            $sql = "SELECT * FROM cars";
            $result = $conn->query($sql);
            $cars = [];
            while ($row = $result->fetch_assoc()) {
                $cars[] = $row;
            }
            echo json_encode(["success" => true, "message" => "Cars fetched", "data" => $cars]);
        }
        break;

    case "POST":
        // POST mobil baru
        $data = json_decode(file_get_contents('php://input'), true);
        $sql = "INSERT INTO cars (name, description, price_per_day, status) 
                VALUES ('" . $data['name'] . "', '" . $data['description'] . "', " . $data['price_per_day'] . ", '" . $data['status'] . "')";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["success" => true, "message" => "Car added successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
        }
        break;

    case "PUT":
        // UPDATE mobil berdasarkan id
        $data = json_decode(file_get_contents('php://input'), true);
        $sql = "UPDATE cars 
                SET name='" . $data['name'] . "', 
                    description='" . $data['description'] . "', 
                    price_per_day=" . $data['price_per_day'] . ", 
                    status='" . $data['status'] . "' 
                WHERE id=" . $data['id'];
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["success" => true, "message" => "Car updated successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
        }
        break;

    case "DELETE":
        // DELETE mobil berdasarkan id
        $id = $_GET['id'];
        $sql = "DELETE FROM cars WHERE id=$id";
        if ($conn->query($sql) === TRUE) {
            echo json_encode(["success" => true, "message" => "Car deleted successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
        }
        break;

    default:
        echo json_encode(["success" => false, "message" => "Invalid request method"]);
        break;
}

$conn->close();
