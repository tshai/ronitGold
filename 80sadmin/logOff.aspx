<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Session.RemoveAll();
        Session.Clear();
        Session.Abandon();
        Response.Redirect("/");
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
</asp:Content>

