<!DOCTYPE html>
<html>
    <head>
	<title>Display 1</title>
    </head>
    <body>
    <?php
	$host = "pluto.hood.edu";
	$dbname = "jjs14db";
	$user = "jjs14";
	$pass = "password";
	// Always use try-catch block
	try {
	    // create the connection
	    $conn = new PDO("mysql:host=$host;dbname=$dbname", $user, $pass);
	    // set the PDO error mode to exception
	    $conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
	    // execute the query
	    $stmt = $conn->query("SELECT * FROM employees");
	    // set the fetch mode to associate array
	    $stmt->setFetchMode(PDO::FETCH_ASSOC);
	    // fetch one record/row
	    $row = $stmt->fetch();
	    // print the row content.
	    printf("First Name: %s<br>\n", $row['f_name']);
	    printf("Last Name: %s<br>\n", $row['l_name']);
	    printf("Title: %s<br>\n", $row['title']);
	    printf("Salary: %s<br>\n", $row['salary']);

	    // disconnect from the database
	    $stmt = null;
	    $conn = null;
	}
	catch(PDOException $e) {
	    die("Could not connect to the database $dbname :" . $e->getMessage());
	}
    ?>
    </body>
</html>