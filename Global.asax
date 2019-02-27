<%@ Application Language="VB" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    Dim connection = ConfigurationManager.ConnectionStrings("errorReports").ConnectionString
    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs on application startup
        'Application("domin_name") = Request.ServerVariables("SERVER_NAME")
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs on application shutdown
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when an unhandled error occurs

        'error report
        Dim erorr1 As Exception = Server.GetLastError.GetBaseException.GetBaseException


        ' does 
        Dim website = Request.Url.ToString().Replace("http://", String.Empty)

        Using con As New SqlConnection(connection)
            con.Open()
            Dim cmd As New SqlCommand("insertError", con)
            cmd.CommandType = CommandType.StoredProcedure
            'If Right(erorr1.Message, 15).Trim = "does not exist." Then
            '    Server.ClearError()
            '    Response.Redirect("~/")
            '    Exit Sub
            'End If

            cmd.Parameters.Add("shortName", SqlDbType.NVarChar).Value = erorr1.Message
            cmd.Parameters.Add("longName", SqlDbType.NVarChar).Value = "Global.asax" & erorr1.StackTrace & Request.ServerVariables("all_http") & Request.ServerVariables("HTTP_REFERER")
            cmd.Parameters.Add("userIP", SqlDbType.NVarChar).Value = Request.UserHostAddress
            cmd.Parameters.Add("website", SqlDbType.NVarChar).Value = website.Remove(website.IndexOf("/"))
            cmd.Parameters.Add("webpage", SqlDbType.NVarChar).Value = Request.Url.ToString()

            Try
                cmd.ExecuteNonQuery()
                Server.ClearError()
                Response.Redirect("~/")
                'Response.Redirect("http://www.google.com")
            Catch ex As Exception

                'Using sw As StreamWriter = File.AppendText(HttpContext.Current.Server.MapPath(".\\log.txt"))

                '    sw.Write(ex.StackTrace & ex.Message & Request.ServerVariables("all_http") & Request.ServerVariables("HTTP_REFERER"))
                '    sw.Write("------------------------------------------------------------------------------------------------------")
                'End Using

                'Response.Redirect("http://www.yahoo.com")
                Response.Redirect("~/?f=" & ex.ToString())
            End Try
        End Using

    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)

    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Code that runs when a session ends. 
        ' Note: The Session_End event is raised only when the sessionstate mode
        ' is set to InProc in the Web.config file. If session mode is set to StateServer 
        ' or SQLServer, the event is not raised.
    End Sub


</script>