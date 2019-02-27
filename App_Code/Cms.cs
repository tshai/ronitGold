using System;
using System.Collections.Generic;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;

/// <summary>
/// Summary description for Cms
/// </summary>
public class Cms
{
    public static SqlConnection connectToPainter()
    {
        return connectToDb("paint");
    }

    public static SqlConnection connectToDb(string dbName)
    {
        SqlConnection cn = new SqlConnection(ConfigurationManager.ConnectionStrings[dbName].ConnectionString);
        cn.Open();
        return cn;
    }
    public static string convertDateObjectToEuroDateString(object dateObject)
    {
        DateTime d = DateTime.Now;
        DateTime.TryParse(dateObject.ToString(), out d);
        return d.ToString("dd/MM/yyyy");
    }
//    public static Boolean checkForSQLInjection(string userInput)

//    {

//        bool isSQLInjection = false;

//        string[] sqlCheckList = { "--",

//                                       ";--",

//                                       ";",

//                                       "/*",

//                                       "*/",

//                                        "@@",

//                                        "@",

//                                        "char",

//                                       "nchar",

//                                       "varchar",

//                                       "nvarchar",

//                                       "alter",

//                                       "begin",

//                                       "cast",

//                                       "create",

//                                       "cursor",

//                                       "declare",

//                                       "delete",

//                                       "drop",

//                                       "end",

//                                       "exec",

//                                       "execute",

//                                       "fetch",

//                                            "insert",

//                                          "kill",

//                                             "select",

//                                           "sys",

//                                            "sysobjects",

//                                            "syscolumns",

//                                           "table",

//                                           "update"

//                                       };

//        string CheckString = userInput.Replace("'", "''");

//        for (int i = 0; i <= sqlCheckList.Length - 1; i++)

//        {

//            if ((CheckString.IndexOf(sqlCheckList[i],

//StringComparison.OrdinalIgnoreCase) >= 0))

//            { isSQLInjection = true; }
//        }

//        return isSQLInjection;
//    }

}