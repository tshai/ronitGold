<%@ Page Title="" Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" ValidateRequest="true" EnableEventValidation="true" %>

<%@ Import Namespace="System.Net.Mail" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Title = populateClassFromDB.GetSiteMessagesByKey("ContactUs");
        ButtonSubmit.Text = populateClassFromDB.GetSiteMessagesByKey("Send");
        TextBox1.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("Name"));
        TextBox2.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("Email"));
        TextBox3.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("Message"));
    }

    protected void ButtonSubmit_Click(object sender, EventArgs e)
    {
        //try
        //{
        //if(Cms.checkForSQLInjection(TextBox3.Text)==true )//|| Cms.checkForSQLInjection(TextBox3.Text)==true)
        //{
        //    Response.Write("error string");
        //    //Response.End();
        //}
        //Response.Write(Tools.checkForSQLInjection(Server.HtmlEncode(TextBox3.Text)));
        if (Tools.checkForSQLInjection(TextBox1.Text) == true || Tools.checkForSQLInjection(TextBox2.Text) == true || Tools.checkForSQLInjection(TextBox3.Text) == true)
        {
            Response.End();
        }
        Contents.addUserMessage(Server.HtmlEncode(TextBox1.Text), Server.HtmlEncode(TextBox2.Text), Server.HtmlEncode(TextBox3.Text));
        MailMessage mail = new MailMessage();
        mail.To.Add("ronit0573@gmail.com");
        mail.From = new MailAddress("contact@ronitgold.co.il");
        mail.Subject = "הודעה חדשה מגולש באתר";
        mail.Body = TextBox3.Text;
        //SmtpClient smtp = new SmtpClient("212.143.89.11");
        //Dim smtp As New SmtpClient("in-v3.mailjet.com")


        //''Dim smtp As New SmtpClient("mail@live-interview.com")
        //smtp.Port = 25
        //''smtp.EnableSsl = True
        //''smtp.DeliveryMethod = SmtpDeliveryMethod.Network
        //smtp.Port = 587
        //''Try
        //''smtp.Host = "smtp.mailgun.org"
        //''smtp.UseDefaultCredentials = False
        //''smtp.EnableSsl = True
        //''smtp.Host = "smtp-relay.gmail.com"

        //
        SmtpClient smtp = new SmtpClient("in-v3.mailjet.com");
        smtp.Credentials = new System.Net.NetworkCredential("9b222624bc43aa9bf6ca7bdfc17df47b", "1447564692a9539122c8a5be2ee3658b");
        smtp.Port = 587;
        //smtp.Send(mail);
        LabelMessage.ForeColor = System.Drawing.Color.Green;
        LabelMessage.Text = "ההודעה נשלחה בהצלחה";
        LabelMessage.Font.Size = 13;
        //    }
        //catch (Exception ex)
        //{
        //    Response.Write(ex.StackTrace);
        //    LabelMessage.ForeColor = System.Drawing.Color.Red;
        //    LabelMessage.Text = "ההודעה לא נשלחה נסה שוב מאוחר יותר";
        //}

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script>
        $(document).ready(function () {
            $(".saveButtonText").css("display", "none");
            $(".inputText").css("display", "none");
        });

        function saveTextToDb(id) {
            if ($('#' + id).val() != "") {
                $("#blackScreen").hide();
                $("*").removeClass("frontClass");
                $(".inputText").css("display", "none");
                $(".saveButtonText").css("display", "none");
                var formData = new FormData();
                formData.append('textKey', id);
                formData.append('newText', $('#' + id).val());

                makeXMLHttpRequest('/80sadmin/Api.aspx?qType=2', formData, function (callback) {
                });
            }
            else {
                alert("<%=populateClassFromDB.GetSiteMessagesByKey("cannotSaveEmpty")%>");
            }
        }

        function doBlackText(item, index, textItem) {
            $("#blackScreen").show();
            $("#" + item + "").addClass("frontClass");
            document.getElementsByClassName('saveButtonText')[index].style.display = "block";
            document.getElementsByClassName('inputText')[index].style.display = "block";
            document.getElementsByClassName('inputText')[index].style.width = ((document.getElementById(textItem).textContent.length + 1) * 8) + 'px';
            document.getElementsByClassName('inputText')[index].value = $('#' + textItem).text();
        }
    </script>
    <div class="page-title">
        <div id="particles-js-pagetitle"></div>
        <div class="container">
            <h1><%=populateClassFromDB.GetSiteMessagesByKey("ContactUs") %></h1>
        </div>
    </div>
    <div id="contactUs">
        <fieldset>
            <legend><%=populateClassFromDB.GetSiteMessagesByKey("ContactUs") %></legend>
            <div class="formBody">
                <div class="smallInputs">
                    <div class="formRow">
                        <%--<label><%=populateClassFromDB.GetSiteMessagesByKey("Name") %> :</label>--%>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ErrorMessage='<%#populateClassFromDB.GetSiteMessagesByKey("Name") %>'
                            ControlToValidate="TextBox1"
                            Display="Dynamic"
                            SetFocusOnError="True" />
                        <asp:TextBox ID="TextBox1" runat="server" MaxLength="30"></asp:TextBox>
                    </div>
                    <div class="formRow">
                        <%--<label><%=populateClassFromDB.GetSiteMessagesByKey("Email") %> :</label>--%>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                            ErrorMessage='<%#populateClassFromDB.GetSiteMessagesByKey("Email") %>'
                            ControlToValidate="TextBox2"
                            Display="Dynamic"
                            SetFocusOnError="True" />
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                            ErrorMessage='<%#populateClassFromDB.GetSiteMessagesByKey("invalidEmail") %>'
                            Display="Dynamic"
                            ControlToValidate="TextBox2"
                            SetFocusOnError="True"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                        <asp:TextBox ID="TextBox2" runat="server" MaxLength="50"></asp:TextBox>
                    </div>
                </div>
                <div class="formRowMultiline">
                    <%--<label><%=populateClassFromDB.GetSiteMessagesByKey("Message") %> :</label>--%>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ErrorMessage='<%#populateClassFromDB.GetSiteMessagesByKey("Message") %>'
                        ControlToValidate="TextBox3"
                        Display="Dynamic"
                        SetFocusOnError="True" />
                    <asp:TextBox ID="TextBox3" runat="server" TextMode="MultiLine" Columns="17" Rows="6"
                        MaxLength="200"></asp:TextBox>
                </div>
                <asp:Button ID="ButtonSubmit" runat="server" OnClick="ButtonSubmit_Click" CssClass="buttonSend" />

                <div class="message">
                    <asp:Label ID="LabelMessage" runat="server" Text=""></asp:Label>
                    <br />

                    <label>
                        <div class="editBox editText" id="divText1">
                            <div onclick="doBlackText('divText1', 0, 'text1')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
                            <div class="saveButtonText" onclick="saveTextToDb('address')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
                            <input type="text" id="address" onkeyup="showTextInDiv(this.id, 'text1')" onkeypress="this.style.width = ((this.value.length + 1) * 16) + 'px'" class="inputText" />
                        </div>
                        <p id="text1"><%=populateClassFromDB.getReadySentencesFromDomain(8, "address") %></p>
                        <br />
                        <div class="editBox editText" id="divText2">
                            <div onclick="doBlackText('divText2', 1, 'text2')"><i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>
                            <div class="saveButtonText" onclick="saveTextToDb('mobilePhone')"><%=populateClassFromDB.GetSiteMessagesByKey("Save") %></div>
                            <input type="text" id="mobilePhone" onkeyup="showTextInDiv(this.id, 'text2')" onkeypress="this.style.width = ((this.value.length + 1) * 16) + 'px';" class="inputText" />
                        </div>
                        <p id="text2">
                            <%=populateClassFromDB.getReadySentencesFromDomain(8, "mobilePhone") %>
                        </p>
                    </label>
                </div>
            </div>
        </fieldset>
    </div>
</asp:Content>

