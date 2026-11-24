package util;

import java.sql.*;

public class DBConnection {
    private static final String URL =
         "jdbc:mysql://localhost:3306/ukm_genshin?serverTimezone=Asia/Jakarta&useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASS = "";

    public static Connection get() throws SQLException {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { throw new SQLException(e); }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}