<%@ Page Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" %>

<%@ Import Namespace="System.Linq" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["companyID"] != null)
        {
            Response.Write(Session["companyID"].ToString());
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .fullscreen-bg {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            overflow: hidden;
            z-index: -100;
        }

        .fullscreen-bg__video {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .video-area1 {
            height: 600px;
            width: 100%;
            overflow: hidden;
        }

        .coverDiv {
            height: 600px;
            z-index: 3;
            position: absolute;
            opacity: 0.7;
            background-color: #333;
            width: 100%;

        }

        #slogenMainPage {
            text-align: center;
            border-radius: 10px;
            opacity: 0.95;
            color: #ffffff;
            font-weight: 900;
            font-size: 6em;
            line-height: 1.2em;
            margin-bottom: 15px;
            text-shadow: 2px 2px 3px rgba(0, 0, 0, 1);
            font-family: 'Open Sans Hebrew';
            position: absolute;
            top: 300px;
            position: absolute;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index:4;
        }
         #slogenMainPage h3,  #slogenMainPage h2{

            color: #ffffff;
           
        }
         #slogenMainPage h2{
            font-size:0.8em;
         }
                  #slogenMainPage h3{
            font-size:1.5em;
         }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>
        function saveImgToDb(id) {
            console.log($('#' + id).val());
            var name = $('#' + id).val().split("\\")[$('#' + id).val().split("\\").length - 1];
        }
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
    </script>
    <!-- Video START -->
    <div class="video-area1" id="video-area1" style="height: 600px">
        <%--<div class="player" id="video-play" data-property="{videoURL:'/media/video/ronitGoldMainVideo.mp4', containment:'#video-area', showControls:false, autoPlay:true, zoom:0, loop:true, mute:true, startAt:1, opacity:1, quality:'low',}"></div>--%>
        <div class="coverDiv"></div>
        <video autoplay muted loop id="myVideo">
            <source src="/media/video/ronitGoldMainVideo.mp4" type="video/mp4">
            Your browser does not support HTML5 video.
        </video>
        <div id="slogenMainPage">
            <h3><%=populateClassFromDB.getReadySentencesFromDomain(8, "ArchitectureAgency") %></h3>
            <h2><%=populateClassFromDB.getReadySentencesFromDomain(8, "ModernDesignAndArchitecture") %></h2>
            <%--<div class="video-table-button mt-40">
                <a href="#"><%=populateClassFromDB.getReadySentencesFromDomain(8, "DiscoverMore") %></a>
            </div>--%>
        </div>

        <%--  <div class="video-table">
            <div class="video-table-cell">
                <div class="container center-holder">
                    <div class="video-effect">
                        <div class="video-effect-box">
                            <div class="video-effect-content">
                                <h3><%=populateClassFromDB.getReadySentencesFromDomain(8, "ArchitectureAgency") %></h3>
                                <h2><%=populateClassFromDB.getReadySentencesFromDomain(8, "ModernDesignAndArchitecture") %></h2>
                                <div class="video-table-button mt-40">
                                    <a href="#"><%=populateClassFromDB.getReadySentencesFromDomain(8, "DiscoverMore") %></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>--%>
    </div>
    <!-- Video END -->

    <!-- About Section START -->
    <div class="section-block-bg" style="background-image: url(img/bg/bg1.jpg);">
        <div class="container">
            <div class="row">
                <div class="col-md-6 col-sm-7 col-xs-12">
                    <div class="section-heading">
                        <h2 class="wow animated fadeInLeft"><%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUs") %></h2>
                        <%--<h3><%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUsTitle1") %>
								<br>
							<%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUsTitle2") %>
								<br>
							<%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUsTitle3") %>
						</h3>--%>
                    </div>

                    <div class="text-content">
                        <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUsDescription1") %></p>
                    </div>

                    <div class="text-content">
                        <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUsDescription2") %></p>
                    </div>

                    <div class="text-content">
                        <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "AboutUsDescription3") %></p>
                    </div>

                    <div class="row">
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <div class="top-article clearfix">
                                <div class="top-article-icon">
                                    <i class="icon-my-house"></i>
                                </div>
                                <div class="top-article-content">
                                    <h5><%=populateClassFromDB.getReadySentencesFromDomain(8, "DreamHouse") %></h5>
                                    <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "DreamHouseDesc") %></p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <div class="top-article clearfix">
                                <div class="top-article-icon">
                                    <i class="icon-pen-and-set-square"></i>
                                </div>
                                <div class="top-article-content">
                                    <h5><%=populateClassFromDB.getReadySentencesFromDomain(8, "CreativePlans") %></h5>
                                    <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "CreativePlansDesc") %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-30 mb-15">
                        <a href="#" class="dark-button button-md"><%=populateClassFromDB.getReadySentencesFromDomain(8, "ReadMore") %></a>
                    </div>
                </div>
                <div class="col-md-5 col-sm-5 col-xs-12 col-md-offset-1">
                    <div class="editBox">
                        <div onclick="fileUpload('uploadImgFile1')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
                        <input id="uploadImgFile1" type="file" style="display: none" onchange="readURL(this, 'img1');" />
                        <input type="submit" onclick="saveImgToDb('uploadImgFile2')" />
                    </div>
                    <div class="outline-bordered-right">
                        <img src="http://via.placeholder.com/458x610" id="img1" alt="img">
                    </div>
                </div>
            </div>

            <div class="row" style="margin-top: 50px">
                <div class="col-md-6 col-sm-7 col-xs-12">
                    <div class="section-heading">
                        <h2 class="wow animated fadeInLeft"><%=populateClassFromDB.getReadySentencesFromDomain(8, "OurProjects") %></h2>
                        <%--	<h3><%=populateClassFromDB.getReadySentencesFromDomain(8, "OurProjectsTitle1") %>
								<br>
							<%=populateClassFromDB.getReadySentencesFromDomain(8, "OurProjectsTitle2") %>
								<br>
							<%=populateClassFromDB.getReadySentencesFromDomain(8, "OurProjectsTitle3") %>
						</h3>--%>
                    </div>

                    <div class="text-content">
                        <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "OurProjectsTitle1") %></p>
                    </div>

                    <div class="text-content">
                        <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "OurProjectsTitle2") %></p>
                    </div>

                    <div class="text-content">
                        <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "OurProjectsTitle3") %></p>
                    </div>

                    <div class="row">
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <div class="top-article clearfix">
                                <div class="top-article-icon">
                                    <i class="icon-my-house"></i>
                                </div>
                                <div class="top-article-content">
                                    <h5><%=populateClassFromDB.getReadySentencesFromDomain(8, "TopOffice") %></h5>
                                    <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "TopOfficeDesc") %></p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <div class="top-article clearfix">
                                <div class="top-article-icon">
                                    <i class="icon-pen-and-set-square"></i>
                                </div>
                                <div class="top-article-content">
                                    <h5><%=populateClassFromDB.getReadySentencesFromDomain(8, "TopDesigner") %></h5>
                                    <p><%=populateClassFromDB.getReadySentencesFromDomain(8, "TopDesignerDesc") %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-30 mb-15">
                        <a href="#" class="dark-button button-md"><%=populateClassFromDB.getReadySentencesFromDomain(8, "ReadMore") %></a>
                    </div>
                </div>

            </div>
        </div>
    </div>
    <!-- About Section START -->

    <!-- Latest Projects START -->
    <div class="section-block">
        <!-- Particles START -->
        <div id="particles-js" style="height: 1500px;"></div>
        <!-- Particles END -->
        <div class="container">
            <div class="row project-row" data-scrollax-parent="true">
                <div class="col-md-7 col-sm-7 col-xs-12" data-scrollax="properties: { 'translateY': '-50px', 'opacity': 0.1 }">
                    <div class="editBox">
                        <div onclick="fileUpload('uploadImgFile2')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
                        <input id="uploadImgFile2" type="file" style="display: none" onchange="readURL(this, 'img2');" />
                        <input type="submit" onclick="saveImgToDb('uploadImgFile2')" />
                    </div>
                    <div class="outline-bordered-left">
                        <img id="img2" src="http://via.placeholder.com/653x436" alt="img">
                    </div>
                </div>
                <div class="col-md-4 col-sm-5 col-xs-12 col-md-offset-1" data-scrollax="properties: { 'translateY': '100px', 'opacity': 0 }">
                    <div class="project-title">
                        <h3>01</h3>
                        <h2>Luxury Summer House</h2>
                    </div>
                    <div class="text-content mt-30">
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus. Donec auctor et urnaLorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus.</p>
                    </div>
                </div>
            </div>

            <div class="row project-row mt-100" data-scrollax-parent="true">
                <div class="col-md-6 col-sm-6 col-xs-12" data-scrollax="properties: { 'translateY': '100px', 'opacity': 0.2 }">
                    <div class="project-title">
                        <h3>02</h3>
                        <h2>Flinders Street Station</h2>
                    </div>
                    <div class="text-content mt-30">
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus. Donec auctor et urnaLorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus.</p>
                    </div>
                </div>
                <div class="col-md-6 col-sm-6 col-xs-12" data-scrollax="properties: { 'translateY': '-50px', 'opacity': 0 }">
                    <div class="editBox">
                        <div onclick="fileUpload('uploadImgFile3')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
                        <input id="uploadImgFile3" type="file" style="display: none" onchange="readURL(this, 'img3');" />
                        <input type="submit" onclick="saveImgToDb('uploadImgFile2')" />
                    </div>
                    <div class="outline-bordered-right">
                        <img id="img3" src="http://via.placeholder.com/555x370" alt="img">
                    </div>
                </div>
            </div>

            <div class="row project-row mt-100" data-scrollax-parent="true">
                <div class="col-md-7 col-sm-7 col-xs-12" data-scrollax="properties: { 'translateY': '-50px', 'opacity': 0 }">
                    <div class="editBox">
                        <div onclick="fileUpload('uploadImgFile4')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
                        <input id="uploadImgFile4" type="file" style="display: none" onchange="readURL(this, 'img4');" />
                        <input type="submit" onclick="saveImgToDb('uploadImgFile2')" />
                    </div>
                    <div class="outline-bordered-left">
                        <img id="img4" src="http://via.placeholder.com/653x435" alt="img">
                    </div>
                </div>
                <div class="col-md-4 col-sm-5 col-xs-12 col-md-offset-1" data-scrollax="properties: { 'translateY': '100px', 'opacity': 0.2 }">
                    <div class="project-title">
                        <h3>03</h3>
                        <h2>Milwaukee Summer House</h2>
                    </div>
                    <div class="text-content mt-30">
                        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus. Donec auctor et urnaLorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Latest Projects END -->

    <!-- Blog Modern START -->
    <%--	<div class="section-block container">
		<div class="">
			<div class="col-md-3 col-sm-6 col-xs-12">
				<div class="section-heading">
					<h2 class="wow animated fadeInLeft">Latest News</h2>
					<h3>Fresh updates for you, read with detail.</h3>
				</div>
			</div>
			<div class="col-md-3 col-sm-6 col-xs-12 no-padding">
				<div class="blog-modern wow animated fadeInLeft" data-wow-delay="0.1s">
					<h3>Plant Trees While Searching The Web</h3>
					<strong>Dec 04, 2017</strong>
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus.</p>
					<div class="blog-moder-button">
						<a href="#">Read More</a>
					</div>
				</div>
			</div>
			<div class="col-md-3 col-sm-6 col-xs-12 no-padding">
				<div class="blog-modern wow animated fadeInLeft" data-wow-delay="0.2s">
					<h3>Plant Trees While Searching The Web</h3>
					<strong>Dec 04, 2017</strong>
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus.</p>
					<div class="blog-moder-button">
						<a href="#">Read More</a>
					</div>
				</div>
			</div>
			<div class="col-md-3 col-sm-6 col-xs-12 no-padding">
				<div class="blog-modern wow animated fadeInLeft" data-wow-delay="0.3s">
					<h3>Plant Trees While Searching The Web</h3>
					<strong>Dec 04, 2017</strong>
					<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus.</p>
					<div class="blog-moder-button">
						<a href="#">Read More</a>
					</div>
				</div>
			</div>
		</div>
	</div>--%>
    <!-- Blog Modern END -->

    <!-- Countup Section START -->
    <%--	<div class="section-block-parallax" style="background-image: url('http://via.placeholder.com/4528x426');">
		<div class="container">
			<div class="row">
				<div class="col-md-4 col-sm-4 col-xs-12">
					<div class="section-heading white-color outline-bordered-text-right mt-70">
						<h3>We are creative<br>
							arhitecture
								<br>
							Design agency</h3>
					</div>
				</div>
				<div class="col-md-7 col-sm-7 col-xs-12 col-md-offset-1">
					<div class="text-content white-color">
						<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus. Donec auctor et urnaLorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus. Cras lacinia magna vel molestie faucibus.</p>
					</div>
					<div class="row">
						<div class="col-md-4 col-sm-4 col-xs-12">
							<div class="countup-box">
								<h4 class="countup">150</h4>
								<strong>Happy Customers</strong>
							</div>
						</div>
						<div class="col-md-4 col-sm-4 col-xs-12">
							<div class="countup-box">
								<h4 class="countup">270</h4>
								<strong>Finished Projects</strong>
							</div>
						</div>
						<div class="col-md-4 col-sm-4 col-xs-12">
							<div class="countup-box">
								<h4 class="countup">490</h4>
								<strong>Days of Work</strong>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>--%>
    <!-- Countup Section END -->

    <!-- Pricing START -->
    <%--<div class="section-block">
		<div class="container">
			<div class="row">
				<div class="col-md-3 col-sm-3 col-xs-12">
					<div class="section-heading">
						<h2 class="wow animated fadeInLeft">Special Prices</h2>
						<h3>Our Pricing List</h3>
					</div>
					<div class="text-content">
						<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras lacinia magna vel molestie faucibus. Donec auctor et urnaLorem ipsum dolor sit amet, consectetur adipiscing elit</p>
					</div>
				</div>
				<div class="col-md-3 col-sm-6 col-xs-12">
					<div class="pricing-box">
						<h4>2 Room Apartment</h4>
						<h5>$49,000</h5>
						<ul>
							<li>77<sup>2</sup></li>
							<li>30m<sup>2</sup></li>
							<li><i class="fa fa-window-close-o" aria-hidden="true"></i></li>
							<li>15m<sup>2</sup></li>
						</ul>
						<div class="pricing-button">
							<a href="#">Contact Us</a>
						</div>
					</div>
				</div>

				<div class="col-md-3 col-sm-6 col-xs-12">
					<div class="pricing-box pricing-best-center">
						<div class="pricing-center">
							<h6>Best value</h6>
						</div>

						<h4>3 Room Apartment</h4>
						<h5>$89,000</h5>
						<ul>
							<li>140m<sup>2</sup></li>
							<li>80m<sup>2</sup></li>
							<li><i class="fa fa-check-square-o"></i></li>
							<li>50m<sup>2</sup></li>
						</ul>
						<div class="pricing-button">
							<a href="#">Contact Us</a>
						</div>
					</div>
				</div>

				<div class="col-md-3 col-sm-6 col-xs-12">
					<div class="pricing-box">
						<h4>4 Room Apartment</h4>
						<h5>$159,000</h5>
						<ul>
							<li>220m<sup>2</sup></li>
							<li>150m<sup>2</sup></li>
							<li><i class="fa fa-check-square-o"></i></li>
							<li>90m<sup>2</sup></li>
						</ul>
						<div class="pricing-button">
							<a href="#">Contact Us</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>--%>
    <!-- Pricing END -->

    <!-- Clients START -->
    <%--	<div class="section-block container">
		<div class="">
			<div class="col-md-3 col-sm-3 col-xs-12">
				<div class="section-heading">
					<h2 class="wow animated fadeInLeft">Our Clients</h2>
					<h3>Great Clients</h3>
				</div>
			</div>
			<div class="col-md-9 col-sm-9 col-xs-12">
				<div class="owl-carousel owl-theme" id="our-clients">
					<div class="client-item">
						<img src="http://via.placeholder.com/130x96" alt="client">
					</div>
					<div class="client-item">
						<img src="http://via.placeholder.com/130x96" alt="client">
					</div>
					<div class="client-item">
						<img src="http://via.placeholder.com/130x96" alt="client">
					</div>
					<div class="client-item">
						<img src="http://via.placeholder.com/130x96" alt="client">
					</div>
					<div class="client-item">
						<img src="http://via.placeholder.com/130x96" alt="client">
					</div>
				</div>
			</div>
		</div>
	</div>--%>
    <!-- Clients END -->
</asp:Content>

