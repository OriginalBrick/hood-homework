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
	    // create result table headers
	    echo "<table border=1>\n";
	    echo "<tr><th>Name</th><th>Salary</th></tr>\n";
	    // print all rows using a loop
	    while ($row = $stmt->fetch()) {
		printf("<tr><td>%s %s</td><td>%s</td></tr>\n", $row['f_name'], $row['l_name'],
		$row['salary']);
	    }
	    echo "</table>\n";

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