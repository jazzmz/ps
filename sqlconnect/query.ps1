$connectionstring = "server=localwww2;uid=root;pwd=zN28#r;database=localwww2;"


[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$connection.ConnectionString = $connectionString
$connection.Open()

$sql = "select id, author ,pid from doc where opdate='2015-01-16' and pid is not null order by pid desc"

$command = New-Object MySql.Data.MySqlClient.MySqlCommand($sql, $connection)
$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)

$table = New-Object System.Data.DataTable
$recordCount = $dataAdapter.Fill($table)



if ( "$table" -eq "" )
    {
        echo "all right"
    } 
    else
    {
        echo "ERRORS!"
        echo $table | ogv
    }



$myreader = $command.ExecuteReader()

while($myreader.Read())
    { 
        echo $myreader.GetString(0) $myreader.GetString(1) $myreader.GetString(2)
    }
