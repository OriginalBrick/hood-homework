<?php

# Insert new accounts and display results

//connection DSN
include_once 'db.php'; 

//form data
$Student_ID=$_POST['Student_ID'];
$Name=$_POST['Name'];
$Major=$_POST['Major'];
$Class=$_POST['Class'];
$Institute_ID=$_POST['Institute_ID'];

$query = "insert into account (Student_ID, Name, Major, Class, Institute_ID) values(:Student_ID, :Name, :Major, :Class, :Institute_ID)";
$data = array('Student_ID' => $Student_ID, 'Name' => $Name, 'Major' => $Major, 'Class' => $Class, 'Institute_ID' => $Institute_ID); 
$stmt = $conn->prepare($query);

if($stmt -> execute($data)) 
{ 
	$rows_affected = $stmt->rowCount(); 
	echo "<h2>".$rows_affected." row added sucessfully!</h2>";
	include 'display.php'; 
	display("SELECT * FROM account;"); 
}
else 
{ 
	echo "update failed: (" . $conn->errno . ") " . $conn->error; 
}
$conn->close(); 

?>