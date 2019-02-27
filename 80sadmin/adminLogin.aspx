<%@ Page Title="" Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<script runat="server">

	protected void Page_Load(object sender, EventArgs e)
	{
		Page.Title = populateClassFromDB.GetSiteMessagesByKey("login");
		email.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("Email"));
		password.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("Password"));
		RequiredFieldValidator2.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("checkForPassword");
		RequiredFieldValidator1.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("invalidEmail");
		password.Attributes.Add("Text", populateClassFromDB.GetSiteMessagesByKey("checkForPassword"));
		RegularExpressionValidator1.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("invalidEmail");
		Button1.Text = populateClassFromDB.GetSiteMessagesByKey("Enter");
	}

	protected void Button1_Click(object sender, EventArgs e)
	{
		if (Page.IsValid == false)
		{
			Response.Write("errors in details");
			Response.End();
		}
		string passwordHashed = Tools.GetHash(password.Text.Trim().ToString());
		using (var db = new Entities())
		{
			var q = (from a in db.Companies where a.email.ToLower() == email.Text.Trim().ToLower() & a.password.ToLower() == passwordHashed.ToLower() select a).FirstOrDefault();
			if (q != null)
			{
				Session["companyID"] = q.ID;
				Response.Redirect("/80sadmin/Default.aspx");
			}
			else
			{
				Response.Write("wrong");
				Response.End();
			}
		}
	}
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
		<div id="topCompanySignIn">
			<div class="workplace">
				<div class="alert alert-success" id="AddMessage" runat="server" visible="false">
					<h4><%=populateClassFromDB.GetSiteMessagesByKey("SystemMessage") %></h4>
					<%=populateClassFromDB.GetSiteMessagesByKey("wrongDetails") %>
				</div>
				<div class="row-fluid">
					<div class="span6">
						<div class="head">
							<div class="isw-ok">
							</div>
							<h1><%=populateClassFromDB.GetSiteMessagesByKey("companyLogin")%></h1>
							<div class="clear">
							</div>
						</div>
						<div class="block-fluid">
							<div class="row-form">
								<div class="span9">
									<asp:TextBox ID="email" runat="server" autocomplete="off"></asp:TextBox><span>
										<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="email"
											Display="Dynamic" SetFocusOnError="true" />
										<asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="email"
											Display="Dynamic" SetFocusOnError="true" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
									</span>
								</div>
								<div class="clear">
								</div>
							</div>
							<div class="row-form">
								<div class="span9">
									<asp:TextBox ID="password" runat="server" MaxLength="10" TextMode="Password"></asp:TextBox>
									<span>
										<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="password"
											Display="Dynamic" SetFocusOnError="true" /></span>
								</div>
								<div class="clear">
								</div>
							</div>
							<div class="row-form">
								<asp:Button class="bigButton" ID="Button1" runat="server" OnClick="Button1_Click"/>
							</div>
							<%--<div class="row-form">
							<a href="ForgotPassword.aspx" style="color: #999"><%=populateClassFromDB.GetSiteMessagesByKey("forgotPassword")%></a>
						</div>--%>
						</div>
					</div>
				</div>
				<div>
				</div>
			</div>
		</div>
</asp:Content>

