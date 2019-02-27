using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Contents
/// </summary>
public class Contents
{
    public static DataView getContentByContentID(int contentID)
    {
        DataTable productsDataTable = new DataTable();
        try
        {
            using (SqlConnection cn = Cms.connectToPainter())
            {
                SqlDataAdapter adp = new SqlDataAdapter("SELECT content FROM Contents WHERE contentID=@contentID", cn);
                adp.SelectCommand.CommandType = CommandType.Text;
                adp.SelectCommand.Parameters.Add("@contentID", SqlDbType.Int).Value = contentID;
                adp.Fill(productsDataTable);
            }
        }
        catch (Exception ex)
        {

        }
        return productsDataTable.DefaultView;
    }
    public static string getContentByContentName(string name)
    {
        string result = "";
        try
        {
            using (SqlConnection cn = Cms.connectToPainter())
            {
                SqlCommand com = new SqlCommand("SELECT content FROM Contents WHERE contentName=@name", cn);
                com.CommandType = CommandType.Text;
                com.Parameters.Add("@name", SqlDbType.NVarChar).Value = name;
                using (SqlDataReader reader = com.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            result = reader["content"].ToString();
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {

        }
        return result;
    }

    public static string getContentByContentNameEng(string name)
    {
        string result = "";

        using (SqlConnection cn = Cms.connectToPainter())
        {
            SqlCommand com = new SqlCommand("SELECT contentEng FROM Contents WHERE contentNameEng=@name", cn);
            com.CommandType = CommandType.Text;
            com.Parameters.Add("@name", SqlDbType.NVarChar).Value = name;
            using (SqlDataReader reader = com.ExecuteReader())
            {
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        result = reader["contentEng"].ToString();
                    }
                }
            }
        }
        return result;
    }

    public static string setContent(int contentID, string content)
    {
        string result = "לא עודכן";

        using (SqlConnection con = Cms.connectToPainter())
        {
            SqlCommand cmd = new SqlCommand("SetContent", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@contentID", System.Data.SqlDbType.Int).Value = contentID;
            cmd.Parameters.Add("@content", System.Data.SqlDbType.NVarChar).Value = content;
            cmd.ExecuteNonQuery();
            result = "עודכן בהצלחה";
        }

        return result;

    }
    public static string addEvent(string eventName, string eventPlace)
    {
        string result = "לא נוסף";

        using (SqlConnection con = Cms.connectToPainter())
        {
            SqlCommand cmd = new SqlCommand("INSERT INTO Events(eventName,eventPlace,domainListID) VALUES(@eventName,@eventPlace,@domainListID)", con);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.Parameters.Add("@eventName", System.Data.SqlDbType.NVarChar,1000).Value = HttpContext.Current.Server.HtmlEncode(eventName);
            cmd.Parameters.Add("@eventPlace", System.Data.SqlDbType.NVarChar,1000).Value = HttpContext.Current.Server.HtmlEncode(eventPlace);
			cmd.Parameters.Add("@domainListID", System.Data.SqlDbType.Int).Value = HttpContext.Current.Session["domainListID"];
			cmd.ExecuteNonQuery();
            result = "נוסף בהצלחה";
        }

        return result;

    }
    public static string addInProcess(string inProcessName, string inProcessPlace)
    {
        string result = "לא נוסף";

        using (SqlConnection con = Cms.connectToPainter())
        {
            SqlCommand cmd = new SqlCommand("INSERT INTO inProcess(inProcessName,inProcessPlace,domainListID) VALUES(@inProcessName,@inProcessPlace,@domainListID)", con);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.Parameters.Add("@inProcessName", System.Data.SqlDbType.NVarChar,1000).Value = HttpContext.Current.Server.HtmlEncode(inProcessName);
            cmd.Parameters.Add("@inProcessPlace", System.Data.SqlDbType.NVarChar,1000).Value = HttpContext.Current.Server.HtmlEncode(inProcessPlace);
			cmd.Parameters.Add("@domainListID", System.Data.SqlDbType.Int).Value = HttpContext.Current.Session["domainListID"];
			cmd.ExecuteNonQuery();
            result = "נוסף בהצלחה";
        }

        return result;

    }
    public static string addProjects(string projectsName, string projectsPlace)
    {
        string result = "לא נוסף";

        using (SqlConnection con = Cms.connectToPainter())
        {
            SqlCommand cmd = new SqlCommand("INSERT INTO projects(projectsName,projectsPlace,domainListID) VALUES(@projectsName,@projectsPlace,@domainListID)", con);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.Parameters.Add("@projectsName", System.Data.SqlDbType.NVarChar,100).Value = HttpContext.Current.Server.HtmlEncode(projectsName);
            cmd.Parameters.Add("@projectsPlace", System.Data.SqlDbType.NVarChar, 1000).Value = HttpContext.Current.Server.HtmlEncode(projectsPlace);
			cmd.Parameters.Add("@domainListID", System.Data.SqlDbType.Int).Value = HttpContext.Current.Session["domainListID"];
			cmd.ExecuteNonQuery();
            result = "נוסף בהצלחה";
        }

        return result;

    }
    public static string addEventEnglish(string eventContent)
    {
        string result = "לא נוסף";

        using (SqlConnection con = Cms.connectToPainter())
        {
            SqlCommand cmd = new SqlCommand("INSERT INTO Events(eventDescriptionEng) VALUES(@event)", con);
            cmd.CommandType = System.Data.CommandType.Text;
            cmd.Parameters.Add("@event", System.Data.SqlDbType.NVarChar, 500).Value = eventContent;
            cmd.ExecuteNonQuery();
            result = "נוסף בהצלחה";

        }

        return result;

    }
    public static string addUserMessage(string name, string email, string message)
    {
        string result = "לא נשלח";

        using (SqlConnection con = Cms.connectToPainter())
        {
            SqlCommand cmd = new SqlCommand("AddUserMessage", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            cmd.Parameters.Add("@name", System.Data.SqlDbType.NVarChar, 50).Value = name;
            cmd.Parameters.Add("@email", System.Data.SqlDbType.VarChar, 50).Value = email;
            cmd.Parameters.Add("@message", System.Data.SqlDbType.NVarChar,1200).Value = message;
            cmd.Parameters.Add("@domainListID", System.Data.SqlDbType.Int).Value = HttpContext.Current.Session["domainListID"];
            cmd.ExecuteNonQuery();
            result = "נשלח בהצלחה";

        }

        return result;

    }
    public static DataView getMessageByContactID(int contactID)
    {
        DataTable productsDataTable = new DataTable();
        try
        {
            using (SqlConnection cn = Cms.connectToPainter())
            {
                SqlDataAdapter adp = new SqlDataAdapter("SELECT message FROM Contacts WHERE contactID=@contactID", cn);
                adp.SelectCommand.CommandType = CommandType.Text;
                adp.SelectCommand.Parameters.Add("@contactID", SqlDbType.Int).Value = contactID;
                adp.Fill(productsDataTable);
            }
        }
        catch (Exception ex)
        {

        }
        return productsDataTable.DefaultView;
    }
}