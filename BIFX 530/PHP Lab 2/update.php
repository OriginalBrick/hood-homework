<?php 

include_once 'db.php'; 

# form data 
$name=$_POST['name']; 
$street=$_POST['street'];
$city=$_POST['city']; 

$query = "update customer set customer_street = :street, customer_city = :city where customer_name = :name;"; 
$data = array( 'name' => $name, 'street' => $street, 'city' => $city); 
$stmt = $conn->prepare($query);

if($stmt -> execute($data)) 
{ 
	$rows_affected = $stmt->rowCount(); 
	echo "<h2>".$rows_affected." row updated sucessfully!</h2>";
	include 'display.php'; 
	display("SELECT * FROM customer;"); 
}
else 
{ 
	echo "update failed: (" . $conn->errno . ") " . $conn->error; 
}
$conn->close(); 
?>
