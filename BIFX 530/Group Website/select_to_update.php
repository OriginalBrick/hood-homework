<?php 

# Initial update landing page.

 include_once 'db.php'; 
 include 'display.php'; 
 echo "<h2> Update Account </h2>"; 
 display("SELECT * FROM account;"); 
?> 

<br/> 
<form action="fill_to_update.php" method="post"> 
<title>Update Account Form</title> 
<h2>Choose an Account</h2> 
<p>Enter the Student ID of the account you wish to update. You will then be promoted to modify their information.</p> 
Student ID: <input type="text" name="Student_ID"/><br>
<input type="Submit" value= "Select"/><input type="Reset"/> 
</form>