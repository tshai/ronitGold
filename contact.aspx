<%@ Page Title="רונית גולדנפלד עיצוב פנים" Language="C#" MasterPageFile="~/SiteMaster.master" %>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">

    protected void ButtonSubmit_Click(object sender, EventArgs e)
    {
        try
        {
            Contents.addUserMessage(TextBox1.Text, TextBox2.Text, TextBox3.Text);
            MailMessage mail = new MailMessage();
            mail.To.Add("ronit0573@gmail.com");
            mail.From = new MailAddress("contact@ronitgold.co.il");
            mail.Subject = "הודעה חדשה מגולש באתר";
            mail.Body = TextBox3.Text;
            //SmtpClient smtp = new SmtpClient("212.143.89.11");
			SmtpClient smtp = new SmtpClient("192.168.1.10");
            smtp.Send(mail);
            LabelMessage.ForeColor = System.Drawing.Color.Green;
            LabelMessage.Text = "ההודעה נשלחה בהצלחה";
            LabelMessage.Font.Size = 13;
        }
        catch (Exception)
        {
            LabelMessage.ForeColor = System.Drawing.Color.Red;
            LabelMessage.Text = "message not sent , try again later"; 
        }
        
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <fieldset>
 <legend>טופס יצירת קשר</legend>
<div class="formBody">
 <div class="formRow">
  <label>: שם</label> <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
      ErrorMessage="נא לרשום שם"
      ControlToValidate="TextBox1"
      Display="Dynamic"
      SetFocusOnError="True"
       /><asp:TextBox ID="TextBox1" runat="server" MaxLength="30"></asp:TextBox>
 </div>
 <div class="formRow">
  <label>: אימייל</label>
     <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
      ErrorMessage="נא לרשום אימייל"
      ControlToValidate="TextBox2"
      Display="Dynamic" 
      SetFocusOnError="True" />
     <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
      ErrorMessage="כתובת אימייל לא תקינה"
      Display="Dynamic" 
      ControlToValidate="TextBox2"
      SetFocusOnError="True" 
      ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" /><asp:TextBox ID="TextBox2" runat="server" MaxLength="50"></asp:TextBox>
 </div>
 <div class="formRowMultiline">
  <label>: הודעה</label>
     <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
      ErrorMessage="נא לרשום הודעה"
      ControlToValidate="TextBox3"
      Display="Dynamic" 
      SetFocusOnError="True" /><asp:TextBox ID="TextBox3" runat="server" 
  TextMode="MultiLine"
   Columns="17"
   Rows="6" 
   MaxLength="200"></asp:TextBox>
 </div>
    <asp:Button ID="ButtonSubmit" runat="server" Text="" CssClass="formSubmit" 
        onclick="ButtonSubmit_Click"/>

    <div class="message">
        <asp:Label ID="LabelMessage" runat="server" Text=""></asp:Label>
   <br />
  
 <label>רחוב גרושקביץ 30 קרית מוצקין<br />
נייד: 0528090116  
טלפון: 0722501660
 <br />
פקס: 0722501661 
</div>
</fieldset>
</asp:Content>

