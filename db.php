<?php
define("HOST", "nomedohost");    #Para o host com o qual você quer se conectar.
define("USER", "nomedousuario");          #O nome de usuário para o banco de dados. 
define("PASSWORD", "senha");           #A senha do banco de dados. 
define("DATABASE", "bancodedados");       #O nome do banco de dados. 
$mysqli = new mysqli(HOST, USER, PASSWORD, DATABASE);
?>