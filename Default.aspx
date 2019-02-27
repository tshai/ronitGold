<%@ Page Title="רונית גולד עיצוב פנים" Language="C#" MasterPageFile="~/masters/Default.master" Inherits="Culture" %>
<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Linq" %>


<script runat="server">

	protected void Page_Load(object sender, EventArgs e)
	{
		var domain = Request.Url.Host.Replace("www.", "");
		var domainDefaultPageID = populateClassFromDB.getDomainByUrl(domain).defaultPageID;
		var defaultPage = new Pages();
		using (var db = new Entities())
		{
			defaultPage = (from a in db.Pages where a.ID == domainDefaultPageID select a).FirstOrDefault();
		}
		Response.Redirect(defaultPage.pageLink);

	}
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
	<div class="mainFrame"> 
     <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1" 
         EnableModelValidation="True">
      <LayoutTemplate>
       <div id="itemPlaceHolder" runat="server"></div>
      </LayoutTemplate>
      <ItemTemplate>
      <img src="paints/large/<%#Eval("paintImage") %>" alt="<%# Eval("engName")%>" />
      <p><%# Eval("engName")%></p>
    
      </ItemTemplate>
     </asp:ListView>
     <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
         ConnectionString="<%$ ConnectionStrings:paint %>" 
         SelectCommand="SELECT [engName],[paintImage] FROM [Paints] WHERE ([isMain] = @isMain)">
         <SelectParameters>
             <asp:Parameter DefaultValue="True" Name="isMain" Type="Boolean" />
         </SelectParameters>
     </asp:SqlDataSource>
 </div> 

</asp:Content>

