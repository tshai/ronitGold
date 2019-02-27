<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" ValidateRequest="false" %>

<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">
	bool isPageActive = false;

	protected void Page_Load(object sender, EventArgs e)
	{
		if (Request["page"] != null)
		{
			isPageActive = true;
		}
		if (Request["id"] != null)
		{
			var id = int.Parse(Request["id"].ToString());
			using (var db = new Entities())
			{
				var isPicExistInArticle = from a in db.ArticleToArticlePics where a.articlePicsID == id select a;
				if (isPicExistInArticle.Any() == false)
				{
					var articlePic = (from a in db.ArticlesPics where a.ID == id select a).FirstOrDefault();
					var oldFilePathL = "\\media\\paints\\large\\" + articlePic.fileName;
					var oldFilePathT = "\\media\\paints\\thumbs\\" + articlePic.fileName;
					System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathL);
					System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathT);
					db.ArticlesPics.Remove(articlePic);
					db.SaveChanges();
					Response.Write("finish");
					Response.End();
				}
				else
				{
					Response.Write("cannot delete");
					Response.End();
				}
			}
		}
		if (Request["action"] != null)
		{
			if (Request["action"].ToString() == "edit")
			{
				var articleID = int.Parse(Request["articleID"].ToString());
				using (var db = new Entities())
				{
					var article = (from a in db.Articles where a.ID == articleID select a).FirstOrDefault();
					content.InnerHtml = Server.HtmlDecode(article.content);
				}
			}
			if (Request["action"].ToString() == "add")
			{
				var picsID = int.Parse(Request["picsID"].ToString());
				var articleToPics = new ArticleToArticlePics();
				articleToPics.articleID = 0;
				articleToPics.articlePicsID = picsID;
				articleToPics.dateIn = DateTime.Now;
				using (var db = new Entities())
				{
					db.ArticleToArticlePics.Add(articleToPics);
					db.SaveChanges();
					Response.Write("finish");
					Response.End();
				}
			}
			if (Request["action"].ToString() == "delete")
			{
				var articleID = int.Parse(Request["articleID"].ToString());
				using (var db = new Entities())
				{
					var isPicsExistInArticle = from a in db.ArticleToArticlePics where a.articleID == articleID select a;
					if (isPicsExistInArticle.Any())
					{
						db.ArticleToArticlePics.RemoveRange(db.ArticleToArticlePics.Where(x => x.articleID == articleID));
						db.SaveChanges();
					}
					db.Articles.Remove(db.Articles.Where(a => a.ID == articleID).FirstOrDefault());
					db.SaveChanges();
					Response.Redirect("/80sadmin/articles.aspx");
				}
			}
		}
	}

	protected void ButtonAddArticle_Click(object sender, EventArgs e)
	{
		var article = new Articles();
		var content = Server.HtmlEncode(ArtContent.Text.Trim());
		using (var db = new Entities())
		{
			if (Request["articleID"] != null)
			{
				var articleID = int.Parse(Request["articleID"].ToString());
				if (Request["action"].ToString() == "edit")
				{
					article = (from a in db.Articles where a.ID == articleID select a).FirstOrDefault();
					article.content = content;
					db.Entry<Articles>(article).State = EntityState.Modified;
					db.SaveChanges();
				}
				var isPicsExist = (from a in db.ArticleToArticlePics where a.articleID == 0 select a);
				if (isPicsExist.Any())
				{
					var articleToPics = isPicsExist.ToList();
					articleToPics.ForEach(x => x.articleID = articleID);
					db.SaveChanges();
				}
			}
			else
			{
				var domainListID = int.Parse(Session["domainListID"].ToString());
				article.content = content;
				article.domainListID = domainListID;
				article.dateIn = DateTime.Now;
				db.Articles.Add(article);
				db.SaveChanges();
				var articleID = article.ID;
				var isPicsExist = (from a in db.ArticleToArticlePics where a.articleID == 0 select a);
				if (isPicsExist.Any())
				{
					var articleToPics = isPicsExist.ToList();
					articleToPics.ForEach(x => x.articleID = articleID);
					db.SaveChanges();
				}
				LabelMessege.Text = "המאמר נוסף בהצלחה!";
				Response.Redirect("/80sadmin/articles.aspx");
			}
		}
	}

	protected void Button1_Click(object sender, EventArgs e)
	{
		var articlePic = new ArticlesPics();
		articlePic.dateIn = DateTime.Now;
		articlePic.fileName = PaintsClass.addPaintImage(FileUploadImage);
		articlePic.domainListID = int.Parse(Session["domainListID"].ToString());
		using (var db = new Entities())
		{
			db.ArticlesPics.Add(articlePic);
			db.SaveChanges();
		}
		if (isPageActive)
		{
			var pageID = Request["page"].ToString();
			Response.Redirect(Request.RawUrl);
		}
		Response.Redirect(Request.RawUrl + "?page=1");
	}

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<style type="text/css">
		.gallery {
			width: 85%;
			direction: rtl;
			margin: 0 auto;
			height: 700px;
		}

		.fileUpload {
			display: grid;
			margin-bottom: 20px;
		}

		#ContentPlaceHolder1_FileUploadImage {
			margin-bottom: 10px;
			margin-top: 10px;
		}

		#blackScreen {
			width: 5000px;
			height: 100vh;
			background-color: rgb(17, 17, 17);
			position: fixed;
			z-index: 1;
			left: 0;
			top: 0;
			opacity: 0.7;
			display: none;
		}

		.frontClass {
			z-index: 100;
			position: relative;
			background-color: white;
			padding: 5px;
		}

		.images {
			width: 200px;
			height: 200px;
			border: 1px solid grey;
			margin: 2px;
			cursor: pointer;
		}

		#buttonSave {
			width: 200px;
			padding: 5px;
			border-radius: 3px;
			border: 1px solid #999;
			text-align: center;
			background-color: #dddddd;
			cursor: pointer;
		}

		.fa {
			display: inline-flex !important;
			cursor: pointer;
			margin-top: 2px;
		}

		.imagesDiv {
			width: 200px;
			display: -webkit-inline-box;
		}

		.formSection {
			width: 70%;
		}

		#ContentPlaceHolder1_ArtContent {
			display: none;
		}

		#ContentPlaceHolder1_content {
			-webkit-appearance: textarea;
			border: 1px solid gray;
			font: medium -moz-fixed;
			font: -webkit-small-control;
			height: 400px;
			overflow: auto;
			padding: 2px;
			resize: both;
			width: 1000px;
			background-color: white;
			padding: 20px;
			font-size: 14px;
		}

		.textButtons {
			border: 1px black solid;
			text-align: center;
			padding: 3px;
			width: 18px;
			height: 18px;
			margin-left: 2px;
			margin-right: 2px;
		}

		.buttonsGroup {
			display: -webkit-box;
			float: left;
			width: 88%;
			margin-bottom: 20px;
		}

		.borders {
			border: 1px solid dimgray;
			margin-left: 2px;
			margin-right: 2px;
		}

		#decrease .fa {
			font-size: 12px;
			margin-top: 4px;
		}

		input[type=color] {
			margin-top: -3px;
			margin-right: -3px;
			width: 12px;
			height: 12px;
		}

		.ui-wrapper {
			width: 0px !important;
			height: 0px !important;
		}

		.resize {
			resize: both;
			overflow: auto;
			width: 210px;
			height: 210px;
		}
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.2/css/all.css" integrity="sha384-/rXc/GQVaYpyDdyxK+ecHPVYJSN9bmVFBvjA/9eOB+pb3F2w2N6fc5qB9Ew5yIns" crossorigin="anonymous">
	<%--<script src="js/jquery-ui-1.12.1.custom/jquery-ui.js"></script>--%>
	<script src="js/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
	<%--<link href="js/jquery-ui-1.12.1.custom/jquery-ui.css" rel="stylesheet" />--%>
	<link href="js/jquery-ui-1.12.1.custom/jquery-ui.min.css" rel="stylesheet" />
	<h1>Add article</h1>
	<div class="gallery" style="display: none">
		<div class="fileUpload">
			<asp:Label ID="LabelImage" runat="server" Text="להעלות תמונה"></asp:Label>
			<asp:FileUpload ID="FileUploadImage" runat="server" class="uploadPhoto" onclick="uploadPhoto()" />
			<%--			<img src="#" id="logoView" class="logoView" runat="server" style="display: none" />--%>
			<asp:Button ID="Button1" runat="server" Text="Save picture" OnClick="Button1_Click" />
		</div>
		<asp:ListView ID="ListView1" runat="server" AllowPaging="True" AllowSorting="True"
			AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSource2">
			<LayoutTemplate>
				<div class="eventContainer">
					<div id="itemPlaceHolder" runat="server">
					</div>
				</div>
				<div class="ItemsPaginationEng">
					<asp:DataPager ID="subItemsPager" runat="server" PagedControlID="ListView1" QueryStringField="page"
						PageSize="10">
						<Fields>
							<asp:NumericPagerField ButtonType="Link" ButtonCount="10" NextPreviousButtonCssClass="ItemPaginationLinkEng"
								NumericButtonCssClass="ItemPaginationLinkEng" CurrentPageLabelCssClass="ItemPaginationActiveEng"
								RenderNonBreakingSpacesBetweenControls="false" />
						</Fields>
					</asp:DataPager>
				</div>
			</LayoutTemplate>
			<ItemTemplate>
				<div class="imagesDiv">
					<i class="fa fa-trash-alt" onclick="deletePic('<%#Eval("ID") %>')"></i>
					<img id="<%#Eval("ID") %>" class="images" src="/media/paints/large/<%# Eval("fileName") %>" alt="<%# Eval("fileName") %>" />
				</div>
			</ItemTemplate>
			<%--	<ItemTemplate>
				<p style="word-break: break-all;">/media/paints/large/<%# Eval("fileName") %></p>
			</ItemTemplate>--%>
		</asp:ListView>
		<asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
			SelectCommand="SELECT * FROM [ArticlesPics] where domainListID=@domainListID">
			<SelectParameters>
				<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
			</SelectParameters>
		</asp:SqlDataSource>
		<div id="buttonSave" onclick="insertImg()">Add picture</div>
	</div>
	<div class="formSection">
		<asp:Label ID="LabelMessege" runat="server" Text=""></asp:Label>
		<br />
		<div>
			<div class="buttonsGroup">
				<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
				<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
				<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
				<div class="borders"></div>
				<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
				<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
				<div class="textButtons" title="text color">
					<input type="color" value="#000000" onchange="changeColor(this)" style="background-color: #000000" />
				</div>
				<div class="borders"></div>
				<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
				<div class="textButtons" title="image" onclick="doBlack('gallery')" onmousedown="event.preventDefault();"><i class="fa fa-images"></i></div>
			</div>
		</div>
		<br />
		<div class="form1">
			<label>תוכן:</label>
			<%--<textarea name="content" id="editor" rows="8" cols="20"></textarea>--%>
			<div id="content" contenteditable="true" runat="server" rows="20" cols="100"></div>
			<asp:TextBox ID="ArtContent" runat="server"></asp:TextBox>
		</div>
		<div class="form1">
			<asp:Button ID="ButtonAddArticle" runat="server" Text="הוספה" OnClick="ButtonAddArticle_Click" OnClientClick="copyText();" />
		</div>
	</div>
	<br />

	<div class="grid">
		<h1>מאמרים</h1>
		<asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
			AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
			BorderWidth="1px" CellPadding="3" DataKeyNames="ID" DataSourceID="SqlDataSource1"
			ForeColor="Black" GridLines="Vertical" EnableModelValidation="True">
			<AlternatingRowStyle BackColor="#CCCCCC" />
			<Columns>
				<asp:TemplateField>
					<ItemTemplate>
						<%#Server.HtmlDecode(Eval("content").ToString()) %>
					</ItemTemplate>
				</asp:TemplateField>

				<asp:TemplateField>
					<ItemTemplate>
						<a href='articles.aspx?action=edit&articleID=<%# Eval("ID")%>'>ערוך</a>
					</ItemTemplate>
				</asp:TemplateField>

				<asp:TemplateField>
					<ItemTemplate>
						<a href='articles.aspx?action=delete&articleID=<%#Eval("ID")%>'>למחוק</a>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<FooterStyle BackColor="#CCCCCC" />
			<HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
			<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
			<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
		</asp:GridView>
		<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
			DeleteCommand="DELETE FROM [Articles] WHERE [ID] = @ID"
			SelectCommand="SELECT * FROM [Articles] where domainListID=@domainListID"
			UpdateCommand="UPDATE [Articles] SET [content] = @content WHERE [ID] = @ID">
			<DeleteParameters>
				<asp:Parameter Name="ID" Type="Int32" />
			</DeleteParameters>
			<UpdateParameters>
				<asp:Parameter Name="content" Type="String" />
				<asp:Parameter Name="ID" Type="Int32" />
			</UpdateParameters>
			<SelectParameters>
				<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
			</SelectParameters>
		</asp:SqlDataSource>
	</div>
	<div id="blackScreen"></div>
	<script>

		function changeColor(element) {
			document.execCommand("ForeColor", false, $(element).val());
		}

		function addLink() {
			var linkURL = prompt('הזן כתובת אתר:', 'http://');
			var sText = document.getSelection();

			document.execCommand('insertHTML', false, '<a href="' + linkURL + '" target="_blank" class="editorLink">' + sText + '</a>');
		}

		function uploadPhoto() {
			$("#ContentPlaceHolder1_FileUploadImage").click();
		}

		function copyText() {
			$("#<%=ArtContent.ClientID%>").val($('#<%=content.ClientID%>').html());
		}

		function insertImg() {
			$("#blackScreen").hide();
			$("*").removeClass("frontClass");
			$(".gallery").css("display", "none");
			var src = $('.selected')[0].src;
			var id = $('.selected')[0].id;
			$('#ContentPlaceHolder1_content').html($('#ContentPlaceHolder1_content').html() + "<p class='resize'><img src='" + src + "' id='img" + id + "' width='200px' height='200px'/></p>")
			$('.resize').on('mouseup', function () {
				this.children[0].width = this.offsetWidth - 5;
				this.children[0].height = this.offsetHeight - 10;
				this.style.border = 'none';
			});
			$('.resize').on('mousedown', function () {
				this.style.border = '1px dotted black';
			});
			$.ajax({
				type: "GET",
				async: false,
				url: "articles.aspx?action=add&picsID=" + id, success: function (result) {
				}
			});
		}

		function deletePic(id) {
			$.ajax({
				type: "GET",
				async: false,
				url: "articles.aspx?id=" + id, success: function (result) {
					if (result == "finish") {
						window.location.href = "/80sadmin/articles.aspx?page=1";
					}
					else if (result == "cannot delete") {
						alert("לא ניתן למחוק תמונה כי קיים במאמר");
					}
				}
			});
		}

		$(document).ready(function () {
			$("#blackScreen").click(function () {
				$("#blackScreen").hide();
				$("*").removeClass("frontClass");
				$(".gallery").css("display", "none");
			})
			if ("<%=isPageActive%>" == "True") {
				doBlack("gallery");
			}

			$('.images').click(function () {
				$('.images').css({
					"border-color": "grey",
					"border-width": "1px",
					"border-style": "solid"
				})
				$('.images').removeClass("selected");
				$(this).css({
					"border-color": "green",
					"border-width": "3px",
					"border-style": "solid"
				})
				$(this).addClass("selected");
			})
			var fontSize = 0;

			$('#decrease').click(function () {
				fontSize = document.queryCommandValue("FontSize");
				if (fontSize > 1)
					fontSize--;
				document.execCommand("fontSize", false, fontSize);
			});

			$('#increase').click(function () {
				fontSize = document.queryCommandValue("FontSize");
				if (fontSize < 7)
					fontSize++;
				document.execCommand("fontSize", false, fontSize);
			});

			$(document).keypress(function (e) {
				if (e.which == 13) {
					e.preventDefault();
					document.execCommand('insertHTML', false, '<br><br>');
					// prevent the default behaviour of return key pressed
					return false;
				}
			});

			document.getElementById('ContentPlaceHolder1_content').onkeyup = function () {
				var key = event.keyCode || event.charCode;
				if (key == 8 || key == 46) {
					$('.resize').each(function () {
						$(this.children).each(function () {
							if (this.id == undefined || this.id == "") {
								this.parentElement.remove();
							}
						})
					})
				}
			};
		});


		function doBlack(item) {
			$("#blackScreen").show();
			$("." + item + "").addClass("frontClass");
			$(".gallery").css("display", "block");
		}
	</script>
</asp:Content>

