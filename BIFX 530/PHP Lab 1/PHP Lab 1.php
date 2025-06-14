<!DOCTYPE html>
<html>
<body>

<?php
//form data
$name=$_POST['name'];
$street=$_POST['street'];
$city=$_POST['city'];

//connection DSN
$host = "pluto.hood.edu";
$dbname = "jjs14db";
$user = "jjs14";
$pass = "password";

try {
	$conn = new PDO("mysql:host=$host;dbname=$dbname", $user, $pass);
	$conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );

	#use prepared statment with named placeholders :first, :last, :title, :age, :yos, :salary, :email.
	$sql = "insert into customer (customer_name, customer_street, customer_city) values(:name, :street, :city)";
	$stmt = $conn->prepare($sql);

	$stmt->bindParam(':name', $name);
	$stmt->bindParam(':street', $street);
	$stmt->bindParam(':city', $city);

	if($stmt->execute()){
		$rows_affected = $stmt->rowCount();
		echo "<h2>".$rows_affected." row added sucessfully!</h2>";
		$stmt = $conn->query("SELECT * FROM customer");

		//PDO::FETCH_NUM: returns an array indexed by column number as returned in your result set, starting at column 0
		$stmt->setFetchMode(PDO::FETCH_NUM);

		echo "<table border=\"1\">\n";
		echo "<tr><td>Name</td><td>Street</td><td>City</td></tr>\n";
		while ($row = $stmt->fetch()) {
			printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $row[0], $row[1], $row[2]);
		}
		$result->close();
		echo "</table>\n";
	}
	else
	{
		echo "Insertion failed: (" . $conn->errno . ") " . $conn->error;
	}

	$conn = null;
}
catch(PDOException $e) {
	die("Could not connect to the database $dbname :" . $e->getMessage());
}

?>

</body>
</html>