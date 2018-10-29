$str = $ARGV[0]; print("Found:"); if ($str =~/$ARGV[1]/) {     print($&); print("
");  }  else   {       print("There is no found coincidence
") }; 
