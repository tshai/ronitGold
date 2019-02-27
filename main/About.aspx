<%@ Page Title="" Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" %>

<script runat="server">

	protected void Page_Load(object sender, EventArgs e)
	{
		Page.Title = populateClassFromDB.GetSiteMessagesByKey("about");
		logo.Src = "\\media\\paints\\large\\" + populateClassFromDB.getAboutFromDomain(int.Parse(Session["domainListID"].ToString())).imageFile;
	}
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script>

		$(document).ready(function () {
			$(".saveButton").css("display", "none");
		});

		function doBlack(item) {
			$("#blackScreen").show();
			$("#" + item + "").addClass("frontClass");
			var idOfButton = item[item.length - 1];
			document.getElementsByClassName('saveButton')[idOfButton - 1].style.display = "block";
		}

		function saveImgAboutToDb(id) {
			$("#blackScreen").hide();
			$("*").removeClass("frontClass");
			var imageID = id[id.length - 1];
			document.getElementsByClassName('fa-pencil-square-o')[imageID - 1].style.color = "gray";
			document.getElementsByClassName('saveButton')[imageID - 1].style.display = "none";
			var formData = new FormData();
			formData.append('pageID', '1');
			formData.append('imageID', imageID);
			formData.append('file', $("#" + id)["0"].files["0"]);

			makeXMLHttpRequest('/80sadmin/Api.aspx?qType=4', formData, function (callback) {
			});
		}

	</script>
	<div class="page-title">
		<div id="particles-js-pagetitle"></div>
		<div class="container">
			<h1><%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUs") %></h1>
		</div>
	</div>
	<div id="main">
		<div id="aboutContainer">
			<div id="divImage1">
				<div class="editBox">
					<div onclick="fileUpload('uploadImgFile1'); doBlack('divImage1')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
					<input id="uploadImgFile1" type="file" style="display: none" onchange="readURL(this, '<%=logo.ClientID %>');" />
					<div class="saveButton" onclick="saveImgAboutToDb('uploadImgFile1')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
				</div>
				<div class="aboutPic">
					<img src="" id="logo" runat="server" />
				</div>
			</div>
			<div class="aboutText">
				<asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1"
					EnableModelValidation="True">
					<LayoutTemplate>
						<div id="itemPlaceholder" runat="server"></div>
					</LayoutTemplate>
					<ItemTemplate>
						<%#Eval("text") %>
					</ItemTemplate>
				</asp:ListView>
				<asp:SqlDataSource ID="SqlDataSource1" runat="server"
					ConnectionString="<%$ ConnectionStrings:paint %>"
					SelectCommand="SELECT [text] FROM [Texts] WHERE ([textName] = @textName) and domainListID=@domainListID">
					<SelectParameters>
						<asp:Parameter DefaultValue="about" Name="textName" Type="String" />
						<asp:Parameter DefaultValue="8" Name="domainListID" Type="Int32" />
					</SelectParameters>
				</asp:SqlDataSource>
			</div>
		</div>
	</div>
</asp:Content>

