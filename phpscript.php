     <?php
/*

PHP script


*/

try{
echo "Inside php ";
$argument1 = $argv[1];
$argument2 = $argv[2];

echo "filename: " .$argument1. " filesize: ".$argument2."bytes";

} catch(Exception $e){
    exit(1);
}
exit(0);

?>
