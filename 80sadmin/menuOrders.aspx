<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
	StringBuilder sb = new StringBuilder();
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Request["action"] != null)
		{
			if (Request["action"].ToString() == "drag")
			{
				var lastDragID = int.Parse(Request["lastDragID"].ToString());
				var dragOn = int.Parse(Request["DragOn"].ToString());
				using (var db = new Entities())
				{
					var firstRowFromMenu = (from a in db.MenuToDomain where a.ID == lastDragID select a).FirstOrDefault();
					var secondRowFromMenu = (from a in db.MenuToDomain where a.ID == dragOn select a).FirstOrDefault();
					var firstRowOrderId = firstRowFromMenu.apperOrder;
					firstRowFromMenu.apperOrder = secondRowFromMenu.apperOrder;
					secondRowFromMenu.apperOrder = firstRowOrderId;
					db.Entry(firstRowFromMenu).State = EntityState.Modified;
					db.Entry(secondRowFromMenu).State = EntityState.Modified;
					db.SaveChanges();
					Response.Write("saved");
					Response.End();
				}
			}
			else if (Request["action"].ToString() == "update")
			{
				var id = int.Parse(Request["id"].ToString());
				var title = Request["title"].ToString();
				var link = Request["link"].ToString();
				var check = Request["check"].ToString();
				using (var db = new Entities())
				{
					var menuRow = (from a in db.MenuToDomain where a.ID == id select a).FirstOrDefault();
					menuRow.PageTitle = title;
					menuRow.linkName = link;
					if (check.ToLower() == "true")
					{
						menuRow.visibility = 1;
					}
					else
					{
						menuRow.visibility = 0;
					}
					db.Entry(menuRow).State = EntityState.Modified;
					db.SaveChanges();
					Response.Write("success");
					Response.End();
				}
			}
		}
		var domainID = int.Parse(Session["domainListID"].ToString());
		using (var db = new Entities())
		{
			var menuToDomain = (from a in db.MenuToDomain where a.domainListID == domainID select a).ToList().OrderBy(x => x.apperOrder);
			sb.Append("<li><ul class='rowMenu'>");
			sb.Append("<li>Button name</li>");
			sb.Append("<li>Page title</li>");
			sb.Append("<li class='visibility'>Visible</li>");
			sb.Append("<li class='visibility'>Edit</li>");
			sb.Append("</ul></li>");
			foreach (var item in menuToDomain)
			{
				sb.Append("<li><ul class='rowMenu' id='" + item.ID + "' draggable = 'true' ondragstart = 'drag(event)' ondrop = 'drop(event)' ondragover = 'allowDrop(event)'>");
				sb.Append("<li id='link" + item.ID + "'>" + item.linkName + "</li>");
				sb.Append("<li id='title" + item.ID + "'>" + item.PageTitle + "</li>");
				sb.Append("<li id='check" + item.ID + "' class='visibility'><input id='check" + item.ID + "' type='checkbox' disabled value='0' " + showVisibility(item.visibility) + "></li>");
				sb.Append("<li class='visibility'><div class='edit' onclick='showEditableBoxes(" + item.ID + ")'>Edit</div></li>");
				sb.Append("</ul></li>");
			}
		}
	}

	protected string showVisibility(int visibility)
	{
		if (visibility == 0)
		{
			return "";
		}
		else if (visibility == 1)
		{
			return "checked";
		}
		return "";
	}
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<style>
		#menu {
			list-style: none;
		}

		.rowMenu {
			list-style: none;
			display: flex;
			width: 400px;
		}

			.rowMenu li {
				border: 1px solid gray;
				padding: 5px;
				min-width: 200px;
			}

		.visibility {
			min-width: 50px !important;
		}

		input[type=checkbox] {
			width: 50px;
		}

		input {
			width: 180px;
		}

		.edit {
			cursor: pointer;
		}
	</style>
	<script src="js/jquery-1.8.3.min.js"></script>
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
	<h1>תפריט כותרת יופיע</h1>
	<div style="width: 1000px">
		<asp:GridView ID="GridView1" Visible="false" runat="server" DataSourceID="SqlDataSource1" AutoGenerateColumns="false"
			DataKeyNames="ID">
			<Columns>
				<asp:CommandField ShowEditButton="True" />
				<asp:BoundField DataField="linkName" HeaderText="Link name" SortExpression="linkName" />
				<asp:BoundField DataField="apperOrder" HeaderText="Appear order" SortExpression="apperOrder" />
				<asp:BoundField DataField="PageTitle" HeaderText="Page title" SortExpression="PageTitle" />
				<asp:TemplateField>
					<ItemTemplate>
						<asp:CheckBox ID="CheckBox1" runat="server" />
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
	</div>

	<asp:SqlDataSource ID="SqlDataSource1" runat="server"
		ConnectionString="<%$ ConnectionStrings:paint %>"
		SelectCommand="SELECT * FROM [MenuToDomain] where domainListID=@domainListID order by apperOrder">
		<SelectParameters>
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</SelectParameters>
	</asp:SqlDataSource>

	<div>
		<ul id="menu">
			<%=sb.ToString() %>
		</ul>
	</div>

	<script>


		var lastDragID;
		var DragOn;

		function allowDrop(ev) {
			ev.preventDefault();
		}

		function drag(ev) {
			ev.dataTransfer.setData("text", ev.target.id);
			lastDragID = ev.target.id
		}

		function drop(ev) {
			DragOn = ev.target.id;
			if (DragOn == "") {
				DragOn = ev.target.parentElement.id;
			}


			$.ajax({
				url: "menuOrders.aspx?action=drag&lastDragID=" + lastDragID + "&DragOn=" + DragOn, success: function (result) {
					if (result == "saved") {
						window.location.href = "menuOrders.aspx";
					}
				}
			});
		}

		function showEditableBoxes(id) {
			var element = $("#" + id);
			var childrens = element[0].children;
			for (var i = 0; i < childrens.length; i++) {
				var el = childrens[i];
				if (el.id.toString().includes("link") || el.id.toString().includes("title")) {
					var text = $(el).text();
					$(el).text("");
					$(el).append("<input type='text' value='" + text + "'/>");
				}
				else if (el.id.toString().includes("check")) {
					el.children[0].disabled = false;
				}
				else {
					$(el).text("");
					$(el).append("<div class='edit' onclick='updateRow(" + id + ")'>Update</div>");
				}
			}
		}

		function updateRow(id) {
			var formData = new FormData();
			formData.append('link', $('#link' + id)[0].children[0].value);
			formData.append('title', $('#title' + id)[0].children[0].value);
			formData.append('check', $('#check7')[0].children[0].checked);
			makeXMLHttpRequest("menuOrders.aspx?action=update&id=" + id, formData, function (callback) {
			});
		}

		function makeXMLHttpRequest(url, data, callback) {
			var request = new XMLHttpRequest();
			request.onreadystatechange = function () {
				if (request.readyState == 4 && request.status == 200) {
					if (request.responseText === 'success') {
						window.location.href = "menuOrders.aspx";
						return;
					}
				}
			};

			request.open('POST', url);
			request.send(data);
		}
	</script>
</asp:Content>
