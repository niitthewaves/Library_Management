/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package library_management;

import java.sql.*;

/**
 *
 * @author 钟雷
 */
public class DBClass {
    static private Connection con;
    public static Connection getConnection() throws Exception {
        if(con==null){
            Class.forName("com.mysql.cj.jdbc.Driver");
            con=DriverManager.getConnection("jdbc:mysql://localhost:3306/library_management","root","1234");
        }
        return con;
    }
}
