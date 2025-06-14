<!DOCTYPE html>
<html>
<body>

<?php
//form data
$first=$_POST['first'];
$last=$_POST['last'];
$title=$_POST['title'];
$age=$_POST['age'];
$yos=$_POST['yos'];
$salary=$_POST['salary'];
$email=$_POST['email'];

//connection DSN
$host = "pluto.hood.edu";
$dbname = "jjs14db";
$user = "jjs14";
$pass = "password";

try {
	$conn = new PDO("mysql:host=$host;dbname=$dbname", $user, $pass);
	$conn->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );

	#use prepared statment with named placeholders :first, :last, :title, :age, :yos, :salary, :email.
	$sql = "insert into employees (f_name, l_name, title, age, yos, salary, email) values(:first, :last,
:title, :age, :yos, :salary, :email)";
	$stmt = $conn->prepare($sql);

	$stmt->bindParam(':first', $first);
	$stmt->bindParam(':last', $last);
	$stmt->bindParam(':title', $title);
	$stmt->bindParam(':age', $age, PDO::PARAM_INT);
	$stmt->bindParam(':yos', $yos);
	$stmt->bindParam(':salary', $salary);
	$stmt->bindParam(':email', $email);

	if($stmt->execute()){
		$rows_affected = $stmt->rowCount();
		echo "<h2>".$rows_affected." row added sucessfully!</h2>";
		$stmt = $conn->query("SELECT * FROM employees");

		//PDO::FETCH_NUM: returns an array indexed by column number as returned in your result set, starting at column 0
		$stmt->setFetchMode(PDO::FETCH_NUM);

		echo "<table border=\"1\">\n";
		echo "<tr><td>Name</td><td>Position</tr>\n";
		while ($row = $stmt->fetch()) {
			printf("<tr><td>%s %s</td><td>%s</td></tr>\n", $row[1], $row[2], $row[3]);
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