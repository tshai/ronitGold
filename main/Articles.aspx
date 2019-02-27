<%@ Page Title="" Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" ValidateRequest="true" EnableEventValidation="true" %>

<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">
	Articles singleArticle;
	protected void Page_Load(object sender, EventArgs e)
	{
		Page.Title = populateClassFromDB.GetSiteMessagesByKey("Articles");
		GridView1.EmptyDataText = populateClassFromDB.GetSiteMessagesByKey("noArticles");
		if (Request["articleID"] != null)
		{
			GridView1.Visible = false;
			Panel1.Visible = true;
			var articleID = int.Parse(Request["articleID"].ToString());
			using (var db = new Entities())
			{
				singleArticle = (from a in db.Articles where a.ID == articleID select a).FirstOrDefault();
			}
		}
	}
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<style>
		.blog-list1 {
			overflow: hidden;
			position: relative;
			border-radius: 10px;
			font-size: 15px;
			background: #fff;
			overflow: hidden;
			margin: 20px 0px 40px 0px;
			-webkit-transition-duration: .3s;
			transition-duration: .3s;
			float: left;
			margin: 20px;
			margin-right: 20px;
			border: 2px solid #eee;
			width: 100%;
			height: 400px;
			max-height: 400px;
		}

		#ContentPlaceHolder1_GridView1 {
			border-collapse: collapse;
			clear: both;
			overflow: hidden;
			width: 100%;
			text-align: right;
		}

			#ContentPlaceHolder1_GridView1 tbody tr {
				float: right;
				font-size: .9em;
				margin-left: 5.5%;
				padding: 1px;
				width: 40%;
				float: left;
				margin-bottom: 20px;
			}

				#ContentPlaceHolder1_GridView1 tbody tr td {
					width: 800px;
				}

		.row1 {
			height: 400px;
			margin-right: 80px;
			margin-left: 5px;
			margin-bottom: 5px;
		}

		.blog-content {
			width: 100% !important;
			height: 100%;
			margin-right: 20px;
			padding: 20px;
		}

		.read-more {
			position: absolute;
			bottom: 0px;
			margin-bottom: 10px;
			margin-right: 5px;
		}

		.editorLink {
			color: black !important;
		}

		.gridview {
			width: 90% !important;
			font-size: 14px !important;
			color: black;
		}

			.gridview a {
				color: black !important;
			}

			.gridview table td {
				width: 30px !important;
			}

		#ContentPlaceHolder1_Panel1 {
			padding: 20px;
			border: 2px solid #eee;
			border-radius: 10px;
			margin: 40px;
			font-size: 14px;
		}

		.back {
			bottom: 0;
			position: inherit;
		}

		img {
			height: inherit !important;
		}
	</style>
	<script>
		$(document).ready(function () {
			$("#ContentPlaceHolder1_GridView1 > tbody > tr:first-child").remove();
		});
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<div class="page-title">
		<div id="particles-js-pagetitle"></div>
		<div class="container">
			<h1><%=populateClassFromDB.GetSiteMessagesByKey("Articles") %></h1>
		</div>
	</div>
	<asp:GridView ID="GridView1" runat="server" GridLines="None" DataSourceID="SqlDataSource1" DataKeyNames="ID" AutoGenerateColumns="false"
		AllowPaging="true" PageSize="6">
		<Columns>
			<asp:TemplateField>
				<ItemTemplate>
					<div class="blog-list1">
						<div class="row1">
							<div class="blog-content">
								<div class="blog-list-text1">
									<p><%# Server.HtmlDecode(Eval("content").ToString()) %></p>
								</div>
							</div>
						</div>
						<div class="read-more right-holder">
							<a href="articles.aspx?articleID=<%#Eval("ID") %>" class="primary-button button-md">Read More</a>
						</div>
					</div>
				</ItemTemplate>

			</asp:TemplateField>
			</Columns>
		<PagerStyle CssClass="gridview"></PagerStyle>
	</asp:GridView>
	<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
		SelectCommand="SELECT * FROM [Articles] where domainListID=@domainListID">
		<SelectParameters>
			<asp:SessionParameter SessionField="domainListID" Name="domainListID" Type="Int32" />
		</SelectParameters>
	</asp:SqlDataSource>
	<asp:Panel ID="Panel1" runat="server" Visible="false">
		<div>
			<%=Server.HtmlDecode(singleArticle.content) %>
		</div>
		<div class="read-more right-holder back">
			<a href="articles.aspx" class="primary-button button-md">Back</a>
		</div>
	</asp:Panel>
	<!-- Scroll to top button Start -->
	<a href="#" class="scroll-to-top"><i class="fa fa-angle-up" aria-hidden="true"></i></a>
	<!-- Scroll to top button End -->
</asp:Content>

