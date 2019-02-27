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
        }
    }

    protected void ButtonAddArticle_Click(object sender, EventArgs e)
    {
        var article = new Articles();
        using (var db = new Entities())
        {
            var content = Server.HtmlEncode(ArtContent.Text.Trim());
            var domainListID = int.Parse(Session["domainListID"].ToString());
            article.content = content;
            article.domainListID = domainListID;
            article.dateIn = DateTime.Now;
            db.Articles.Add(article);
            db.SaveChanges();
            LabelMessege.Text = "המאמר נוסף בהצלחה!";
            Response.Redirect("/80sadmin/articles.aspx");
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
        #ContentPlaceHolder1_ArtContent {
            display: none;
        }

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
        }

        .imagesDiv {
            width: 200px;
            display: -webkit-inline-box;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="js/ckeditor/ckeditor.js"></script>
    <script src="js/ckeditor/adapters/jquery.js"></script>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.4.2/css/all.css" integrity="sha384-/rXc/GQVaYpyDdyxK+ecHPVYJSN9bmVFBvjA/9eOB+pb3F2w2N6fc5qB9Ew5yIns" crossorigin="anonymous">
    <script>
        $(document).ready(function () {
            setTimeout(function () {
                var x = document.getElementsByClassName('cke_editable cke_editable_themed cke_contents_rtl cke_show_borders')[0].innerHTML;
                alert(x);
                //var onclickFn = function () {
                //    alert("image in iframe was clicked");
                //},
                //  textAreaEdit = document.getElementsByTagName('iframe').contentWindow.document.getElementsByClassName('cke_editable cke_editable_themed cke_contents_rtl cke_show_borders');

                //for (var i = 0; i < images.length; i++) {
                //    images[i].onclick = onclickFn;
                //}
            }, 5000);

        });

//focus();
//        var listener = addEventListener('blur', function () {
//            var iframe1 = document.getElementsByTagName('iframe');
//    if (document.activeElement === document.getElementsByTagName('iframe')) {
//        //var da = document.activeElement;
//$('img').click(function() {
//     alert( "blabla" );
//});
//	}
//    //removeEventListener(listener);
//}); 
    </script>
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
        <div class="form1">
            <label>תוכן:</label>
            <textarea name="content" id="editor" rows="8" cols="20"></textarea>
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
                <asp:CommandField ShowEditButton="True" ShowDeleteButton="true" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <%#Server.HtmlDecode(Eval("content").ToString()) %>
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

        function uploadPhoto() {
            $("#ContentPlaceHolder1_FileUploadImage").click();
        }

        function insertImg() {
            $("#blackScreen").hide();
            $("*").removeClass("frontClass");
            $(".gallery").css("display", "none");
            $("#cke_33").click();
            var src = $('.selected')[0].src;
            var id = $('.selected')[0].id;
            var text = $('.cke_enable_context_menu').val();
            text += "<img id='insert" + id + "' src='" + src + "' width='200px' height='200px'/>";
            $('.cke_enable_context_menu').val(text);
            setTimeout(function () {
                $("#cke_33").click();
            }, 500);
        }

        function deletePic(id) {
            $.ajax({
                type: "GET",
                async: false,
                url: "articles.aspx?id=" + id, success: function (result) {
                    if (result == "finish") {
                        window.location.href = "/80sadmin/articles.aspx?page=1";
                    }
                }
            });
        }

        CKEDITOR.editorConfig = function (config) {
            config.language = 'he';
            config.uiColor = '#F7B42C';
            config.height = 300;
            config.toolbarCanCollapse = true;
            config.allowedContent = "*(*)[id]";
        };
        CKEDITOR.replace('editor');

        $(document).ready(function () {
            CKEDITOR.instances['editor'].setData($("#<%=ArtContent.ClientID%>").val());
            $("body").css("direction", "rtl");
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
        });

        function doBlack(item) {
            $("#blackScreen").show();
            $("." + item + "").addClass("frontClass");
            $(".gallery").css("display", "block");
        }

        function copyText() {
            $("#<%=ArtContent.ClientID%>").val(CKEDITOR.instances['editor'].getData());
        }

        $(document).ready(function () {
            setTimeout(function () {
                $("#cke_26").hide();
                $("#cke_25 .cke_toolgroup").append("<a id='custom_cke_26' class='cke_button cke_button__image cke_button_off' title='Image' tabindex='-1' hidefocus='true' role='button' aria-labelledby='cke_26_label' aria-describedby='cke_26_description' aria-haspopup='false'><span class='cke_button_icon cke_button__image_icon' style='background-image:url('http://www.ronitgold.co.il/80sadmin/js/ckeditor/plugins/icons.png?t=I2QI'); background-position:0 -360px;background-size:auto;'>&nbsp;</span><span id='cke_26_label' class='cke_button_label cke_button__image_label' aria-hidden='false'>Image</span><span id='cke_26_description' class='cke_button_label' aria-hidden='false'></span></a>");
                $('#custom_cke_26').click(function () {
                    doBlack('gallery');
                });
                $('.cke_editable').addClass('someClass');
            }, 1000);
        });
    </script>
</asp:Content>

