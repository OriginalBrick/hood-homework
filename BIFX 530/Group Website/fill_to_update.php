<form action="update.php" method="post">

<h2>Update Account</h2> 
<p>Modify the values of the account you selected.</p> 

<?php

# Creates an auto-filled form the user can edit.

include_once 'db.php'; 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$Student_ID=$_POST['Student_ID']; 

# prepared statement with Unnamed Placeholders
$query = "select * from account where Student_ID = ?;";
$stmt = $conn->prepare($query);
$stmt->bindValue(1, $Student_ID); # bind by value and assign variables to each place holder
$stmt->execute();
$stmt->setFetchMode(PDO::FETCH_NUM);
$row = $stmt->fetch();  

printf("<input type=\"hidden\" name=\"Student_ID\" value=\"%s\"/><br>\n",$row[0]); 
printf("Name: <input type=\"text\" name=\"Name\" value=\"%s\"/><br>",$row[1]); 
printf("Major: <input type=\"text\" name=\"Major\" value=\"%s\"/><br>\n",$row[2]); 
printf("Class: <input type=\"text\" name=\"Class\" value=\"%s\"/><br>\n",$row[3]); 
?> 
<br/> 
<input type="Submit" value= "Update"/><input type="Reset"/> 
</form>