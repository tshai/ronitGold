<%@ Page Language="C#" MasterPageFile="~/masters/demo.master" Theme="1" %>

<%@ Import Namespace="System.Linq" %>

<script runat="server">

	protected void Page_Load(object sender, EventArgs e)
	{
		var themeID = populateClassFromDB.getDomainByUrl(Request.Url.Host.Replace("www.", "")).themeID;
		using (var db = new Entities())
		{
			img1.Src = checkIfHasImg(1, themeID, "1", "http://via.placeholder.com/458x610");
			img2.Src = checkIfHasImg(1, themeID, "2", "http://via.placeholder.com/653x436");
			img3.Src = checkIfHasImg(1, themeID, "3", "http://via.placeholder.com/555x370");
			img4.Src = checkIfHasImg(1, themeID, "4", "http://via.placeholder.com/653x435");
		}
	}

	protected string checkIfHasImg(int pageID, int themeID, string imgID, string fakeImage)
	{
		using (var db = new Entities())
		{
			var hasImage = from a in db.ThemePics where a.pageID == 1 && a.themeID == themeID && a.imgID == imgID select a;
			if (hasImage.Any())
			{
				return "/media/paints/large/" + hasImage.FirstOrDefault().fileName;
			}
		}
		return fakeImage;
	}

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<style>
		.content {
			-webkit-appearance: textarea;
			border: 1px solid gray;
			font: medium -moz-fixed;
			font: -webkit-small-control;
			overflow: auto;
			padding: 2px;
			resize: both;
			background-color: white;
			padding: 20px;
			font-size: 14px;
			width: 500px;
			min-height: 100px;
			margin: 10px;
		}

		.textButtons {
			border: 1px black solid;
			text-align: center;
			padding: 3px;
			width: 22px;
			height: 22px;
			margin-left: 2px;
			margin-right: 2px;
			background-color: gray;
			cursor: pointer;
		}
        .navbar-logo img {

    margin-left: 15px;
    height: 100px;
    max-height:100px;
}
		.buttonsGroup {
			display: -webkit-box;
			float: left;
			width: 88%;
			margin-bottom: 20px;
		}

		.borders {
			border: 2px solid dimgray;
			margin-left: 2px;
			margin-right: 2px;
		}

		#decrease .fa {
			font-size: 12px !important;
			margin-top: 2px !important;
		}

		input[type=color] {
			margin-top: -3px;
			width: 12px;
			height: 12px;
			box-shadow: none;
			background-color: white;
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

		.fa {
			font-size: 14px !important;
			color: white !important;
		}

		.fa-pencil-square-o {
			font-size: 18px !important;
			color: #bda87f !important;
		}
        .navbar-custom .navbar-links-custom li a {
    font-size: 16px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    color: #900571;
    -webkit-transition-duration: .3s;
    transition-duration: .3s;
}
	</style>
	<script>
		function saveImgToDb(id) {
			$("#blackScreen").hide();
			$("*").removeClass("frontClass");
			var imageID = id[id.length - 1];
			document.getElementsByClassName('fa-pencil-square-o')[imageID - 1].style.color = "gray";
			document.getElementsByClassName('saveButton')[imageID - 1].style.display = "none";
			var formData = new FormData();
			formData.append('pageID', '1');
			formData.append('imageID', imageID);
			formData.append('file', $("#" + id)["0"].files["0"]);
			formData.append('width', $('#img' + imageID).width());
			formData.append('height', $('#img' + imageID).height());

			makeXMLHttpRequest('/80sadmin/Api.aspx?qType=1', formData, function (callback) {
			});
		}

		function saveTextToDb(id) {
			if ($('#' + id).text() != "") {
				$("#blackScreen").hide();
				$("*").removeClass("frontClass");
				$(".inputText").css("display", "none");
				$(".buttonsGroup").css("display", "none");
				$(".saveButtonText").css("display", "none");
				$(".leftText").css("margin-right", "0px");
				var array = id.split('_');
				var textID = array[array.length - 1];
				var formData = new FormData();
				formData.append('textKey', textID);
				formData.append('newText', $('#' + id).text());

				makeXMLHttpRequest('/80sadmin/Api.aspx?qType=2', formData, function (callback) {
				});
			}
			else {
				alert("<%=populateClassFromDB.GetSiteMessagesByKey("cannotSaveEmpty")%>");
			}
		}

		$(document).ready(function () {
			$(".saveButton").css("display", "none");
			$(".saveButtonText").css("display", "none");
			$(".inputText").css("display", "none");
			$(".buttonsGroup").css("display", "none");
		});

		$(document).ready(function () {

			var vid = document.getElementById("myVideo");
			vid.onloadedmetadata = function () {

				var windowsWidth = window.innerWidth;
				var ratio = parseInt(windowsWidth) / parseInt(vid.videoWidth)
				//alert(ratio);
				$("#myVideo").css("zoom", ratio);
				vid.currentTime = 5;
			};

		});

		function doBlack(item) {
			$("#blackScreen").show();
			$("#" + item + "").addClass("frontClass");
			var idOfButton = item[item.length - 1];
			document.getElementsByClassName('saveButton')[idOfButton - 1].style.display = "block";
		}

		function doBlackText(item, index, textItem) {
			$("#blackScreen").show();
			$("#" + item + "").addClass("frontClass");
			document.getElementsByClassName('saveButtonText')[index].style.display = "block";
			document.getElementsByClassName('inputText')[index].style.display = "block";
			document.getElementsByClassName('buttonsGroup')[index].style.display = "-webkit-box";
			$(".leftText").css("margin-right", "-150px");
			document.getElementsByClassName('inputText')[index].textContent = $('#' + textItem).text();
		}

		function changeColor(element) {
			document.execCommand("ForeColor", false, $(element).val());
		}

		function addLink() {
			var linkURL = prompt('הזן כתובת אתר:', 'http://');
			var sText = document.getSelection();

			document.execCommand('insertHTML', false, '<a href="' + linkURL + '" target="_blank" class="editorLink">' + sText + '</a>');
		}


	</script>
	<!-- Video START -->
	<div class="video-area1" id="video-area1" style="height: 600px">
		<%--<div class="player" id="video-play" data-property="{videoURL:'/media/video/ronitGoldMainVideo.mp4', containment:'#video-area', showControls:false, autoPlay:true, zoom:0, loop:true, mute:true, startAt:1, opacity:1, quality:'low',}"></div>--%>
		<div class="coverDiv" style="opacity:0.5"></div>
		<video autoplay muted loop id="myVideo">
			<source src="/media/video/video_preview_h264.mp4" type="video/mp4">
			Your browser does not support HTML5 video.
		</video>
		<div id="slogenMainPage">
			<h3>נלי מעצבת אירועים</h3>
			<h2>זרים לראש לימי הולדת </h2>
		</div>
	</div>
	<!-- Video END -->

	<!-- About Section START -->
	<div class="section-block-bg" style="background-image: url(img/bg/bg1.jpg);">
		<div class="container">
			<div class="row">
				<div class="col-md-6 col-sm-7 col-xs-12">
					<div class="editBox editText" id="divText1">
						<div onclick="doBlackText('divText1', 0, 'title1')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<div class="saveButtonText" onclick="saveTextToDb('<%=AboutUs.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
						<%--<input type="text" onkeyup="showTextInDiv(this.id, 'title1')" id="AboutUs" class="inputText" runat="server" />--%>
						<div>
							<div class="buttonsGroup">
								<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
								<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
								<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
								<div class="borders"></div>
								<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="text color" style="padding-top: 0px;">
									<input type="color" value="#000000" onchange="changeColor(this)" />
								</div>
								<div class="borders"></div>
								<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
							</div>
							<div id="AboutUs" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'title1')"></div>
						</div>
					</div>
					<div class="section-heading">
						<h2 id="title1" class="wow animated fadeInLeft"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "AboutUs") %>
						</h2>
					</div>
					<div class="editBox editText" id="divText2">
						<div onclick="doBlackText('divText2', 1, 'p1')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<div class="saveButtonText" onclick="saveTextToDb('<%=AboutUsDescription1.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
						<%--<input type="text" onkeyup="showTextInDiv(this.id, 'p1')" id="AboutUsDescription1" class="inputText" runat="server" />--%>
						<div>
							<div class="buttonsGroup">
								<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
								<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
								<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
								<div class="borders"></div>
								<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="text color" style="padding-top: 0px;">
									<input type="color" value="#000000" onchange="changeColor(this)" />
								</div>
								<div class="borders"></div>
								<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
							</div>
							<div id="AboutUsDescription1" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'p1')"></div>
						</div>
					</div>
					<div class="text-content">
						<p id="p1"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "AboutUsDescription1") %></p>
					</div>

					<div class="row">
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="top-article clearfix">
								<div class="top-article-icon">
									<i class="icon-my-house"></i>
								</div>
								<div class="top-article-content">
									<div class="editBox editText" id="divText3">
										<div onclick="doBlackText('divText3', 2, 'title2')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
										<div class="saveButtonText" onclick="saveTextToDb('<%=DreamHouse.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
										<%--<input type="text" id="DreamHouse" onkeyup="showTextInDiv(this.id, 'title2')" class="inputText" runat="server" />--%>
										<div>
											<div class="buttonsGroup">
												<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
												<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
												<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
												<div class="borders"></div>
												<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="text color" style="padding-top: 0px;">
													<input type="color" value="#000000" onchange="changeColor(this)" />
												</div>
												<div class="borders"></div>
												<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
											</div>
											<div id="DreamHouse" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'title2')"></div>
										</div>
									</div>
									<h5 id="title2"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "DreamHouse") %></h5>
									<div class="editBox editText" id="divText4">
										<div onclick="doBlackText('divText4', 3, 'p4')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
										<div class="saveButtonText" onclick="saveTextToDb('<%=DreamHouseDesc.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
										<%--<input type="text" id="DreamHouseDesc" onkeyup="showTextInDiv(this.id, 'p4')" class="inputText" runat="server" />--%>
										<div>
											<div class="buttonsGroup">
												<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
												<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
												<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
												<div class="borders"></div>
												<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="text color" style="padding-top: 0px;">
													<input type="color" value="#000000" onchange="changeColor(this)" />
												</div>
												<div class="borders"></div>
												<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
											</div>
											<div id="DreamHouseDesc" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'p4')"></div>
										</div>
									</div>
									<p id="p4"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "DreamHouseDesc") %></p>
								</div>
							</div>
						</div>
						<div class="col-md-6 col-sm-6 col-xs-12">
							<div class="top-article clearfix">
								<div class="top-article-icon">
									<i class="icon-pen-and-set-square"></i>
								</div>
								<div class="top-article-content">
									<div class="editBox editText" id="divText5">
										<div onclick="doBlackText('divText5', 4, 'title3')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
										<div class="saveButtonText" onclick="saveTextToDb('<%=CreativePlans.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
										<%--<input type="text" id="CreativePlans" onkeyup="showTextInDiv(this.id, 'title3')" class="inputText" runat="server" />--%>
										<div>
											<div class="buttonsGroup">
												<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
												<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
												<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
												<div class="borders"></div>
												<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="text color" style="padding-top: 0px;">
													<input type="color" value="#000000" onchange="changeColor(this)" />
												</div>
												<div class="borders"></div>
												<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
											</div>
											<div id="CreativePlans" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'title3')"></div>
										</div>
									</div>
									<h5 id="title3"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "CreativePlans") %></h5>
									<div class="editBox editText" id="divText6">
										<div onclick="doBlackText('divText6', 5, 'p5')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
										<div class="saveButtonText" onclick="saveTextToDb('<%=CreativePlansDesc.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
										<%--<input type="text" id="CreativePlansDesc" onkeyup="showTextInDiv(this.id, 'p5')" class="inputText" runat="server" />--%>
										<div>
											<div class="buttonsGroup">
												<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
												<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
												<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
												<div class="borders"></div>
												<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
												<div class="textButtons" title="text color" style="padding-top: 0px;">
													<input type="color" value="#000000" onchange="changeColor(this)" />
												</div>
												<div class="borders"></div>
												<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
											</div>
											<div id="CreativePlansDesc" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'p5')"></div>
										</div>
									</div>
									<p id="p5"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "CreativePlansDesc") %></p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-5 col-sm-5 col-xs-12 col-md-offset-1" id="divImage1">
					<div class="editBox">
						<div onclick="fileUpload('uploadImgFile1'); doBlack('divImage1')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<input id="uploadImgFile1" type="file" style="display: none" onchange="readURL(this, '<%=img1.ClientID %>');" />
						<div class="saveButton" onclick="saveImgToDb('uploadImgFile1')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
					</div>
					<div class="outline-bordered-right">
						<img src="" id="img1" runat="server" alt="img">
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- About Section START -->

	<!-- Latest Projects START -->
	<div class="section-block">
		<div class="container">
			<div class="row project-row" data-scrollax-parent="true">
				<div class="col-md-7 col-sm-7 col-xs-12" id="divImage2" data-scrollax="properties: { 'translateY': '-50px', 'opacity': 0.1 }">
					<div class="editBox">
						<div onclick="fileUpload('uploadImgFile2'); doBlack('divImage2')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<input id="uploadImgFile2" type="file" style="display: none" onchange="readURL(this, '<%=img2.ClientID %>');" />
						<div class="saveButton" onclick="saveImgToDb('uploadImgFile2')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
					</div>
					<div class="outline-bordered-left">
						<img id="img2" src="" runat="server" alt="img">
					</div>
				</div>
				<div class="col-md-4 col-sm-5 col-xs-12 col-md-offset-1" data-scrollax="properties: { 'translateY': '100px', 'opacity': 0 }">
					<div class="project-title">
						<div class="editBox editText leftText" id="divText7">
							<div onclick="doBlackText('divText7', 6, 'title4')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
							<div class="saveButtonText" onclick="saveTextToDb('<%=firstProjectTitle.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
							<%--<input type="text" id="firstProjectTitle" onkeyup="showTextInDiv(this.id, 'title4')" class="inputText" runat="server" />--%>
							<div>
								<div class="buttonsGroup">
									<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
									<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
									<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
									<div class="borders"></div>
									<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
									<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
									<div class="textButtons" title="text color" style="padding-top: 0px;">
										<input type="color" value="#000000" onchange="changeColor(this)" />
									</div>
									<div class="borders"></div>
									<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
								</div>
								<div id="firstProjectTitle" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'title4')"></div>
							</div>
						</div>
						<h2 id="title4"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "firstProjectTitle") %></h2>
					</div>
					<div class="editBox editText leftText" id="divText8">
						<div onclick="doBlackText('divText8', 7, 'p6')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<div class="saveButtonText" onclick="saveTextToDb('<%=firstProjectDescription.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
						<%--<input type="text" id="firstProjectDescription" onkeyup="showTextInDiv(this.id, 'p6')" class="inputText" runat="server" />--%>
						<div>
							<div class="buttonsGroup">
								<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
								<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
								<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
								<div class="borders"></div>
								<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="text color" style="padding-top: 0px;">
									<input type="color" value="#000000" onchange="changeColor(this)" />
								</div>
								<div class="borders"></div>
								<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
							</div>
							<div id="firstProjectDescription" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'p6')"></div>
						</div>
					</div>
					<div class="text-content mt-30">
						<p id="p6"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "firstProjectDescription") %></p>
					</div>
				</div>
			</div>

			<div class="row project-row mt-100" data-scrollax-parent="true">
				<div class="col-md-6 col-sm-6 col-xs-12" data-scrollax="properties: { 'translateY': '100px', 'opacity': 0.2 }">
					<div class="project-title">
						<div class="editBox editText" id="divText9">
							<div onclick="doBlackText('divText9', 8, 'title5')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
							<div class="saveButtonText" onclick="saveTextToDb('<%=secondProjectTitle.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
							<%--<input type="text" id="secondProjectTitle" onkeyup="showTextInDiv(this.id, 'title5')" class="inputText" runat="server" />--%>
							<div>
								<div class="buttonsGroup">
									<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
									<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
									<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
									<div class="borders"></div>
									<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
									<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
									<div class="textButtons" title="text color" style="padding-top: 0px;">
										<input type="color" value="#000000" onchange="changeColor(this)" />
									</div>
									<div class="borders"></div>
									<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
								</div>
								<div id="secondProjectTitle" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'title5')"></div>
							</div>
						</div>
						<h2 id="title5"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "secondProjectTitle") %></h2>
					</div>
					<div class="editBox editText" id="divText11">
						<div onclick="doBlackText('divText11', 9, 'p7')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<div class="saveButtonText" onclick="saveTextToDb('<%=secondProjectDescription.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
						<%--<input type="text" id="secondProjectDescription" onkeyup="showTextInDiv(this.id, 'p7')" class="inputText" runat="server" />--%>
						<div>
							<div class="buttonsGroup">
								<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
								<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
								<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
								<div class="borders"></div>
								<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="text color" style="padding-top: 0px;">
									<input type="color" value="#000000" onchange="changeColor(this)" />
								</div>
								<div class="borders"></div>
								<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
							</div>
							<div id="secondProjectDescription" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'p7')"></div>
						</div>
					</div>
					<div class="text-content mt-30">
						<p id="p7"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "secondProjectDescription") %></p>
					</div>
				</div>
				<div class="col-md-6 col-sm-6 col-xs-12" id="divImage3" data-scrollax="properties: { 'translateY': '-50px', 'opacity': 0 }">
					<div class="editBox">
						<div onclick="fileUpload('uploadImgFile3'); doBlack('divImage3')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<input id="uploadImgFile3" type="file" style="display: none" onchange="readURL(this, '<%=img3.ClientID %>');" />
						<div class="saveButton" onclick="saveImgToDb('uploadImgFile3')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
					</div>
					<div class="outline-bordered-right">
						<img id="img3" src="" runat="server" alt="img">
					</div>
				</div>
			</div>

			<div class="row project-row mt-100" data-scrollax-parent="true">
				<div class="col-md-7 col-sm-7 col-xs-12" id="divImage4" data-scrollax="properties: { 'translateY': '-50px', 'opacity': 0 }">
					<div class="editBox">
						<div onclick="fileUpload('uploadImgFile4'); doBlack('divImage4')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<input id="uploadImgFile4" type="file" style="display: none" onchange="readURL(this, '<%=img4.ClientID %>');" />
						<div class="saveButton" onclick="saveImgToDb('uploadImgFile4')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
					</div>
					<div class="outline-bordered-left">
						<img id="img4" src="" runat="server" alt="img">
					</div>
				</div>
				<div class="col-md-4 col-sm-5 col-xs-12 col-md-offset-1" data-scrollax="properties: { 'translateY': '100px', 'opacity': 0.2 }">
					<div class="project-title">
						<div class="editBox editText leftText" id="divText10">
							<div onclick="doBlackText('divText10', 10, 'title6')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
							<div class="saveButtonText" onclick="saveTextToDb('<%=thirdProjectTitle.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
							<%--<input type="text" id="thirdProjectTitle" onkeyup="showTextInDiv(this.id, 'title6')" class="inputText" runat="server" />--%>
							<div>
								<div class="buttonsGroup">
									<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
									<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
									<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
									<div class="borders"></div>
									<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
									<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
									<div class="textButtons" title="text color" style="padding-top: 0px;">
										<input type="color" value="#000000" onchange="changeColor(this)" />
									</div>
									<div class="borders"></div>
									<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
								</div>
								<div id="thirdProjectTitle" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'title6')"></div>
							</div>
						</div>
						<h2 id="title6"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "thirdProjectTitle") %></h2>
					</div>
					<div class="editBox editText leftText" id="divText12">
						<div onclick="doBlackText('divText12', 11, 'p8')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
						<div class="saveButtonText" onclick="saveTextToDb('<%=thirdProjectDescription.ClientID %>')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
						<%--<input type="text" id="thirdProjectDescription" onkeyup="showTextInDiv(this.id, 'p8')" class="inputText" runat="server" />--%>
						<div>
							<div class="buttonsGroup">
								<div class="textButtons" title="bold" onclick="document.execCommand('bold');" onmousedown="event.preventDefault();"><i class="fa fa-bold"></i></div>
								<div class="textButtons" title="italic" onclick="document.execCommand('italic')" onmousedown="event.preventDefault();"><i class="fa fa-italic"></i></div>
								<div class="textButtons" title="underline" onclick="document.execCommand('underline')" onmousedown="event.preventDefault();"><i class="fa fa-underline"></i></div>
								<div class="borders"></div>
								<div class="textButtons" title="increase text" id="increase" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="decrease text" id="decrease" onmousedown="event.preventDefault();"><i class="fa fa-font"></i></div>
								<div class="textButtons" title="text color" style="padding-top: 0px;">
									<input type="color" value="#000000" onchange="changeColor(this)" />
								</div>
								<div class="borders"></div>
								<div class="textButtons" title="link" onclick="addLink()" onmousedown="event.preventDefault();"><i class="fa fa-paperclip"></i></div>
							</div>
							<div id="thirdProjectDescription" class="content inputText" contenteditable="true" runat="server" onkeyup="showTextInDiv(this.id, 'p8')"></div>
						</div>
					</div>
					<div class="text-content mt-30">
						<p id="p8"><%=populateClassFromDB.getReadySentencesFromDomain(int.Parse(Session["domainListID"].ToString()), "thirdProjectDescription") %></p>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- Latest Projects END -->
	<!-- Clients END -->

	<script>
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
	</script>
</asp:Content>

