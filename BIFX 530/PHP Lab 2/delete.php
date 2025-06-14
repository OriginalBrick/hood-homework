<?php 
include_once 'db.php';
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

#form data 
$name=$_POST['name']; 
$sql = "delete from customer where customer_name = :name;"; 
$stmt = $conn->prepare($sql);

# data stored in an associative array 
$data = array( 'name' => $name); 

if($stmt->execute($data)){ 
	$rows_affected = $stmt->rowCount(); 
	echo "<h2>".$rows_affected." row deleted sucessfully!</h2>"; 
	$stmt = $conn->query("SELECT * FROM customer"); 

	//PDO::FETCH_NUM: returns an array indexed by column number as returned in your result set, starting at column 0 
	$stmt->setFetchMode(PDO::FETCH_NUM); 
	echo "<table border=\"1\">\n"; 
	echo "<tr><td>customer_name</td><td>customer_street</td><td>customer_city</td></tr>\n"; 
	while ($row = $stmt->fetch()) { 
		printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $row[0], $row[1], $row[2]); 
	} 
	echo "</table>\n"; 
}
else 
{ 
	echo "\nPDOStatement::errorInfo():\n"; 
	print_r($stmt->errorInfo()); 
}
$stmt = null; 
$conn = null; 
?>
