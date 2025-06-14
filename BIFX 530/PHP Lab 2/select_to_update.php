<?php 
 include_once 'db.php'; 
 include 'display.php'; 
 echo "<h2> Customer Information </h2>"; 
 display("SELECT * FROM customer;"); 
?> 

<br/> 
<form action="fill_to_update.php" method="post"> 
<title>Update Address Form</title> 
<h2>Choose a Customer</h2> 
<p>Enter a customer name. You will then be promoted to modify their new address.</p> 
Customer Name: <input type="text" name="name"/><br>
<input type="Submit" value= "Select"/><input type="Reset"/> 
</form>