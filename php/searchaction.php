<?php
    include("config.php");// the config file is used for connecting with the mysql database.
    //for more detail information,read csdn https://www.php.cn/php-ask-429654.html
    $keywords=$_POST['searchrequire'];
    $area=$_POST['area'];
    if($area=='bookname'){
        $sql="select * from book where Name like '%$keywords%'";
    }//you may change the sql code here.this is for searching by the bookname.
    if($area=='writer'){
        $sql="select * from book where Author like (select ID from creator where Name like '%$keywords%')";
    }
    if($area=='press'){
        $sql="select * from book where Press like (select ID from press where Name like '%$keywords%')";//not found the name of the press in the mysql data base.you may check the data.
    }
    if($area=='category'){
        $sql="select * from book where Subclass like '%$keywords%'";
    }
    //all the search above is to get the information about the matched books.
    $result=mysqli_query($conn,$sql);
    //$authorid=$result['Author'];
    //$pressid=$result['Press'];
    //$bid=$result['ISBN'];
    //$sql="select Name from creator where ID=$authorid";
    //$author_result=mysqli_query($conn,$sql);
    //$sql="select Name from press where ID=$pressid";//also,the metis.sql file does not contaion the press name in the table press.you may check the code for mysql.
    //$press_result=mysqli_query($conn,$sql);

//the page that shows the searching result.
<!DOCTYPE html>
<html>
    <head>
        <title>mbookstore search</title>
    </head>

    <body>
        <div name="title">
            <h1>欢迎来到智慧女神网上书店</h1>
        </div>

        <div name="searchresult">
            <h2>您的搜索结果如下</h2>
            <table border='1'>
                <tr>
                    <?php
                        while ($row=mysqli_fetch_assoc($result))
                        {
                    ?>
                    <tr>
                        <td>
                        //load the picture.still need to learn how to load blob pics.
                        </td>
                        <td>
                            <tr><?=$row['Name'];?></tr>
                            <tr><?=$row['Author'];?></tr>
                            <tr><?=$row['Press'];?></tr>
                        </td>
                        <td>
                            <input type="button" onclick="detailpage.php?id="+$row['ISBN']>详细内容</button>
                        </td>
                    </tr>
                    <?php
                        }
                    ?>
                </tr>
            </table>
    </body>
</html>
            
$row['ISBN']