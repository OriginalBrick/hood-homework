<?php 
include_once 'db.php';
# ini_set('display_errors', 1);
# ini_set('display_startup_errors', 1);
# error_reporting(E_ALL);

#form data 
$Student_ID=$_POST['Student_ID']; 
$sql = "delete from account where Student_ID = :Student_ID;"; 
$stmt = $conn->prepare($sql);

# data stored in an associative array 
$data = array( 'Student_ID' => $Student_ID); 

if($stmt -> execute($data)) 
{ 
	$rows_affected = $stmt->rowCount(); 
	echo "<h2>".$rows_affected." row removed sucessfully!</h2>";
	include 'display.php'; 
	display("SELECT * FROM account;"); 
}
else 
{ 
	echo "update failed: (" . $conn->errno . ") " . $conn->error; 
}

$conn->close(); 
?>