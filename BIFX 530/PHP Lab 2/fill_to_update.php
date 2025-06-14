<form action="update.php" method="post">

<h2>Update Address</h2> 
<p>Modify the address of the customer you selected.</p> 

<?php 
include_once 'db.php'; 
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$name=$_POST['name']; 

# prepared statement with Unnamed Placeholders
$query = "select * from customer where customer_name = ?;";
$stmt = $conn->prepare($query);
$stmt->bindValue(1, $name); # bind by value and assign variables to each place holder
$stmt->execute();
$stmt->setFetchMode(PDO::FETCH_NUM);
$row = $stmt->fetch();  

printf("<input type=\"hidden\" name=\"name\" value=\"%s\"/><br>\n",$row[0]); 
printf("Street: <input type=\"text\" name=\"street\" value=\"%s\"/><br>",$row[1]); 
printf("City: <input type=\"text\" name=\"city\" value=\"%s\"/><br>\n",$row[2]); 
?> 
<br/> 
<input type="Submit" value= "Update"/><input type="Reset"/> 
</form>