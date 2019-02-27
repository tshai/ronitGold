<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">


    protected void aboutText(object sender, CommandEventArgs e)
    {

        using (SqlConnection cn = Cms.connectToPainter())
        {
            SqlCommand com = new SqlCommand("UPDATE Texts SET text=@t WHERE textID=1 and domainListID=@domainListID", cn);
            com.Parameters.Add("@t", SqlDbType.NVarChar).Value = HttpContext.Current.Server.HtmlEncode(RadEditor1.Text);
            com.Parameters.Add("@domainListID", SqlDbType.Int).Value = HttpContext.Current.Session["domainListID"];
            com.ExecuteNonQuery();
            Response.Redirect("editAbout.aspx");

        }
    }

    //protected void Button1_Click(object sender, EventArgs e)
    //{

    //}

    protected void Page_Load(object sender, EventArgs e)
    {
        using (SqlConnection cn = Cms.connectToPainter())
        {
            SqlCommand com = new SqlCommand("SELECT text FROM Texts Where textName='about'", cn);
            using (SqlDataReader reader = com.ExecuteReader())
            {
                while (reader.Read())
                {
                    if (reader.HasRows)
                    {
                        RadEditor1.Text = HttpContext.Current.Server.HtmlDecode(reader["text"].ToString());
                    }
                }
            }

        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%--	<style>
		textarea {
			width: 800px;
			min-height: 80px;
			margin: 20px;
		}
	</style>--%>
<%--	<asp:Button ID="Button1" runat="server" Text="הצג את הנוכחי"
		OnClick="Button1_Click" />
	<br />--%>

       <div class="formSection">
          <div class="form1">
	<asp:TextBox ID="RadEditor1" TextMode="MultiLine" runat="server" Height="119px" Width="506px">
	</asp:TextBox>
              </div> 
	 <div class="form1">
	<asp:Button ID="ButtonUpdateAbout" runat="server" Text="עדכון" OnCommand="aboutText" />
         </div> 
           </div> 
</asp:Content>

