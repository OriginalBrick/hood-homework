<?php 

# Updates changes and displays the results.

include_once 'db.php'; 

# form data 
$Student_ID=$_POST['Student_ID']; 
$Name=$_POST['Name']; 
$Major=$_POST['Major'];
$Class=$_POST['Class']; 

$query = "update account set Name = :Name, Major = :Major, Class = :Class where Student_ID = :Student_ID;"; 
$data = array('Student_ID' => $Student_ID, 'Name' => $Name, 'Major' => $Major, 'Class' => $Class); 
$stmt = $conn->prepare($query);

if($stmt -> execute($data)) 
{ 
	$rows_affected = $stmt->rowCount(); 
	echo "<h2>".$rows_affected." row updated sucessfully!</h2>";
	include 'display.php'; 
	display("SELECT * FROM account;"); 
}
else 
{ 
	echo "update failed: (" . $conn->errno . ") " . $conn->error; 
}
$conn->close(); 
?>
