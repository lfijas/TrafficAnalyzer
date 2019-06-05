<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$id = $_GET['id'];

$servername = "localhost";
$username = "root";
$password = "admin";
$dbname = "yanosik";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT Id, Date, Latitude, Longitude FROM Traffic_without_parking WHERE Id = " . $id;
$result = $conn->query($sql);

$outp = '{"Traffic":[';
$row = 1;
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    if ($row != 1) {$outp .= ",";}
    $outp .= '{"Id":"' . $rs["Id"] . '",'; 
    $outp .= '"Date":"'  . $rs["Date"] . '",';
    $outp .= '"Latitude":"'   . $rs["Latitude"] . '",';
    $outp .= '"Longitude":"'. $rs["Longitude"] . '"}';
    $row++;
}
$outp .='], "Optimal_routes":[';

$sql = "SELECT Id, Latitude, Longitude FROM Optimal_routes WHERE Id = " . $id;
$result = $conn->query($sql);

$row = 1;
while($rs = $result->fetch_array(MYSQLI_ASSOC)) {
    if ($row != 1) {$outp .= ",";}
    $outp .= '{"Id":"' . $rs["Id"] . '",'; 
    $outp .= '"Latitude":"'   . $rs["Latitude"] . '",';
    $outp .= '"Longitude":"'. $rs["Longitude"] . '"}';
    $row++;
}
$outp .= ']}';

$conn->close();
echo($outp)
?> 