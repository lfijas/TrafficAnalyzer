<?php
//header("Access-Control-Allow-Origin: *");
//header("Content-Type: application/json; charset=UTF-8");
header("Content-Type: text/html; charset=UTF-8");

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

$sql = "SELECT Id, Date, Latitude, Longitude FROM Traffic WHERE Id = " . $id;
$result = $conn->query($sql);

$x = new XMLWriter();
$x->openMemory();
$x->startDocument('1.0', 'UTF-8');

$x->startElement('osm');
$x->writeAttribute('version', '0.6');

$db_id=1;

while ($rs = $result->fetch_array(MYSQLI_ASSOC)) {
  $x->startElement('node');
  $x->writeAttribute('id', $db_id);
  $x->writeAttribute('lat', number_format((float) $rs["Latitude"], 7, '.', ''));
  $x->writeAttribute('lon', number_format((float) $rs["Longitude"], 7, '.', ''));
  $x->startElement('tag');
  $x->writeAttribute('k', 'highway');
  $x->writeAttribute('v', 'path');
  $x->endElement(); //tag
  $x->endElement(); //node
  $db_id++;
}

$conn->close();

if ($db_id == 1) {
  echo '<script type="text/javascript">';
  echo 'alert("Brak przejazdu o id równym' . $id . '.");';
  echo 'window.location = "/selectRoute.html"';
  echo '</script>';
} else {

  $x->endElement(); //osm

  $x->endDocument();

  $xml = $x->outputMemory();

  $myfile = fopen("route_id_" . $id . ".osm", "w") or die("Unable to open file!");
  fwrite($myfile, $xml);
  fclose($myfile);

  echo '<script type="text/javascript">';
  echo 'alert("Trasa przejazdu o id ' . $id . ' wyeksportowana do pliku w formacie .osm.");';
  echo 'window.location = "/selectRoute.html"';
  echo '</script>';
}
?> 
