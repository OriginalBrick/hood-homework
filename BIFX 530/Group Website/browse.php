<h2>Browse Accounts</h2> 

<?php 

// Connection DSN
include_once 'db.php';

// Display accounts
include 'display.php'; 
display("SELECT * FROM account;");

?>