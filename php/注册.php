<?PHP
        $psw = $_POST["password"]; 
        $psw_confirm = $_POST["confirm"]; 
        $name = $_POST["name"]; 
        $address = $_POST["address"]; 
        $tele = $_POST["tele"]; 
        $email = $_POST["email"]; 
        
        if ($psw == "" || $psw_confirm == "" || $name == "" || $tele == "" || $email == "") 
        { 
            echo "<script>alert('请确认信息完整！');history.go(-1);</script>"; 
        } 
        else
        {
            if ($psw == $psw_confirm) 
            { 
                mysql_connect("localhost:3306","root","密码");
                mysql_select_db("Metis");
                mysql_query("set names 'gdk'"); 
                $sql_insert = "insert into user (state,Name,Address,Telephone,email,password) values('初级','$_POST[name]','$_POST[address]','$_POST[tele]','$_POST[email]','$_POST[password]')"; 
                $res_insert = mysql_query($sql_insert); 
                    if ($res_insert) 
                    {   
                        echo "<script>alert('注册成功！');history.go(-1);</script>"; 
                        $check = "select ID from user where name = '$_POST[name]' and password = '$_POST[password]'";
                        $result = mysql_query($check);
                        if ($result)
                        {
                            $array = mysql_fetch_array($result,MYSQLI_NUM);
                            echo "您的id为;".$array[0];
                        }
                    }    
                    else 
                    { 
                        echo "<script>alert('系统繁忙，请稍候！'); history.go(-1);</script>"; 
                    } 
                } 
            } 
            else
            {
                echo "<script>alert('密码不一致！'); history.go(-1);</script>"; 
            }

        }   
?>
