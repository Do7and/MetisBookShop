<?PHP
        $psw = $_POST["password"]; 
        $psw_confirm = $_POST["confirm"]; 
        $name = $_POST["name"]; 
        $address = $_POST["address"]; 
        $tele = $_POST["tele"]; 
        $email = $_POST["email"]; 
        
        if ($psw == "" || $psw_confirm == "" || $name == "" || $tele == "" || $email == "") 
        { 
            echo "<script>alert('Please check your info！');location.reload();</script>"; 
        } 
        else
        {
            if ($psw == $psw_confirm) 
            { 
				$conn=mysqli_connect("localhost:3306","root","root","Metis"); 
				if (mysqli_connect_errno($conn)) 
					{ 
						echo "Fail to connect MySQL: " . mysqli_connect_error(); 
					} 

                mysqli_select_db($conn,"Metis");
                mysqli_query($conn,"set names 'utf8'"); 
                $sql_insert = "insert into `user` (state,Name,Address,Telephone,email,password) values('初级','$_POST[name]','$_POST[address]','$_POST[tele]','$_POST[email]','$_POST[password]')"; 
                $res_insert = mysqli_query($conn,$sql_insert); 
                    if ($res_insert) 
                    {   
                        $check = "select ID from user where name = '$_POST[name]' and password = '$_POST[password]'";
                        $result = mysqli_query($conn,$check);
                        if ($result)
                        {
                            $id_array = mysqli_fetch_array($result);
                            echo "<script>alert('Register OK！Your ID is $id_array[0]');history.go(-1);</script>";
                        }
                    }    
                    else 
                    { 
						echo $res_insert;
                        echo "<script>alert('Error！Please contact the admin');</script>"; 
                    } 

            }  
            else
            {
                echo "<script>alert('The password is inconsistent!Please check.');location.reload();</script>"; 
            }
		}
?>
