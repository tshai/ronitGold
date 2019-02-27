using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for Tools
/// </summary>
public class Tools
{
    public static string GetHash(string input)
    {
        byte[] bytes = System.Text.Encoding.ASCII.GetBytes(input);
        var hashed = System.Security.Cryptography.SHA256.Create().ComputeHash(bytes);
        return Convert.ToBase64String(hashed);
    }

    public static Boolean checkForSQLInjection(string userInput)

    {

        bool isSQLInjection = false;

        string[] sqlCheckList = { "--",

                                       ";--",

                                       ";",

                                       "/*",

                                       "*/",

                                        "@@",

                                        "@",

                                        "char",

                                       "nchar",

                                       "varchar",

                                       "nvarchar",

                                       "alter",

                                       "begin",

                                       "cast",

                                       "create",

                                       "cursor",

                                       "declare",

                                       "delete",

                                       "drop",

                                       "end",

                                       "exec",

                                       "execute",

                                       "fetch",

                                            "insert",

                                          "kill",

                                             "select",

                                           "sys",

                                            "sysobjects",

                                            "syscolumns",

                                           "table",

                                           "update"

                                       };

        string CheckString = userInput.Replace("'", "''");
        string[] CheckStringArr = CheckString.Split(' ');
        //HttpContext.Current.Response.Write(sqlCheckList.Length + "<br>");

        foreach (string word in CheckStringArr)
        {

            foreach (string word1 in sqlCheckList)
            {
                //HttpContext.Current.Response.Write(word + "<br>");
                if (word1.ToLower() == word.ToLower())
                {
                    //HttpContext.Current.Response.Write(word1 + "<br>");

                    return true;
                }
            }
        }

        return isSQLInjection;
    }

	public static void popUp(Page p1, string message)
	{
		Label model = (Label)FindControlRecursive(p1, "modelMessage");
		model.Text = message;
		StringBuilder cstext2 = new StringBuilder();
		cstext2.Append("$(document).ready(function() {");
		cstext2.Append("$('#myModal').modal('show')");
		cstext2.Append("});");
		p1.ClientScript.RegisterStartupScript(p1.GetType(), "PopupScript", cstext2.ToString(), true);
	}

	public static Control FindControlRecursive(Control Root, string Id)
	{
		if (Root.ID == Id)
			return Root;

		foreach (Control Ctl in Root.Controls)
		{
			Control FoundCtl = FindControlRecursive(Ctl, Id);
			if (FoundCtl != null)
				return FoundCtl;
		}

		return null/* TODO Change to default(_) if this is not a reference type */;
	}

}