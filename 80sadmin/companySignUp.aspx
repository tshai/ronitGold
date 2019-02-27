<%@ Page Title="" Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    //private  Companies company_ = New Companies();
    protected void Page_Load(Object sender, EventArgs e)
    {
        //If (Request("EmployeeToCompanyGuid"))
        //{
        //    Guid EmployeeToCompanyGuid = Guid.Parse(Request("EmployeeToCompanyGuid"));
        //    Using (var db = New Entities())
        //    {
        //        var EmployeeToCompany_ = (From a In db.EmployeeToCompany
        //                                  Where a.EmployeeToCompanyGuid == EmployeeToCompanyGuid
        //                                  Select a).FirstOrDefault();
        //        Employees employee_ = New Employees();
        //        var q = From a In db.Employees
        //                Where a.email == EmployeeToCompany_.employeeEmail
        //                Select a;
        //        If (q.Count() == 0)
        //            email.Text = EmployeeToCompany_.employeeEmail;
        //        company_ = populateClassFromDB.getCompanyByID(EmployeeToCompany_.companyID);
        //    }
        //    email.ReadOnly = true;
        //    requestEmployee.Visible = true;
        //    newEmployee.Visible = false;
        //}

        Page.Title = populateClassFromDB.GetSiteMessagesByKey("companyRegisterTitle");
        email.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("EmailOnly"));
        RequiredFieldValidator3.Attributes.Add("Text", populateClassFromDB.GetSiteMessagesByKey("errorEmail"));
        RequiredFieldValidator3.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("errorEmail");
        RegularExpressionValidator1.Attributes.Add("Text", populateClassFromDB.GetSiteMessagesByKey("errorEmail"));
        RegularExpressionValidator1.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("errorEmail");
        password.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("Password"));
        RequiredFieldValidator2.Attributes.Add("Text", populateClassFromDB.GetSiteMessagesByKey("Password"));
        RequiredFieldValidator2.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("checkForPassword");
        RegularExpressionValidator2.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("passwordPlaceholder");
        fullName.Attributes.Add("placeholder", populateClassFromDB.GetSiteMessagesByKey("fullName"));
        //RequiredFieldValidator1.Attributes.Add("Text", populateClassFromDB.GetSiteMessagesByKey("writeFullName"));
        //RequiredFieldValidator1.ErrorMessage = populateClassFromDB.GetSiteMessagesByKey("writeFullName");
        Button1.Text = populateClassFromDB.GetSiteMessagesByKey("Registration");
    }



    protected void Button1_Click(Object sender, EventArgs e)
    {
        if(Page.IsValid == false)
        {
            Response.Write("errors in details");
            Response.End();
        }
        //if(String.IsNullOrEmpty(Request("EmployeeToCompanyGuid")) == False)
        //{
        //    var EmployeeToCompanyGuid = Guid.Parse(Request("EmployeeToCompanyGuid"));
        //    Using(var db = New Entities())
        //{
        //        var EmployeeToCompany_ = (From a In db.EmployeeToCompany
        //                                  Where a.EmployeeToCompanyGuid == EmployeeToCompanyGuid
        //                              Select a).FirstOrDefault();
        //        Employees Employees_ = New Employees();
        //        var q = From a In db.Employees
        //                Where a.email == EmployeeToCompany_.employeeEmail
        //            Select a;
        //        If(q.Any() == False)
        //    {
        //            Employees_.active = 1;
        //            Employees_.dateIn = DateTime.Now;
        //            Employees_.email = EmployeeToCompany_.employeeEmail;
        //            Employees_.password = Tools.GetHash(password.Text.Trim().ToString());
        //            Employees_.emailActivate = 1;
        //            Employees_.fullName = fullName.Text.Trim();
        //            Employees_.employeeGuid = Guid.NewGuid();
        //            Employees_.peerID = 0;
        //            Employees_.onlineStatus = 0;
        //            Employees_.lastCustomerID = 0;
        //            Employees_.currentCustomerID = 0;
        //            Employees_.lastVisit = DateTime.Now;
        //            Employees_.last_status_change = DateTime.Now;
        //            Employees_.guidRnd = Guid.NewGuid().ToString();
        //            Employees_.photo = 0;
        //            Employees_.forgetPasswordGuid = Guid.NewGuid();
        //            Employees_.ipAddress = Tools.extractUserIp();
        //            Employees_.domainListID = Session("domainsListID");
        //            db.Employees.Add(Employees_);
        //            db.SaveChanges();
        //        }
        //        Else
        //            Employees_ = q.FirstOrDefault();
        //        EmployeeLogins employeeLogin_ = New EmployeeLogins();
        //        employeeLogin_.dateIn = DateTime.Now;
        //        employeeLogin_.employeeID = Employees_.ID;
        //        employeeLogin_.customerID = 0;
        //        employeeLogin_.ipAddress = Tools.extractUserIp();

        //        db.EmployeeLogins.Add(employeeLogin_);
        //        db.SaveChanges();
        //        EmployeeToCompany_.employeeID = Employees_.ID;
        //        db.Entry(EmployeeToCompany_).State = EntityState.Modified;
        //        db.SaveChanges();
        //        activityLogs activityLogs_ = New activityLogs();
        //        activityLogs_.companyID = company_.ID;
        //        activityLogs_.companyView = 0;
        //        activityLogs_.dateIn = DateTime.Now;
        //        activityLogs_.deletedByEmployeeID = 0;
        //        activityLogs_.employeeID = 0;
        //        activityLogs_.siteLinkID = 12;
        //        activityLogs_.siteMessageID = 74;
        //        activityLogs_.externalTableID = Employees_.ID;
        //        db.activityLogs.Add(activityLogs_);
        //        db.SaveChanges();
        //        Session("employeeID") = Employees_.ID;
        //        Session("companyID") = company_.ID;
        //        Response.Redirect("/" + Session("domainName") + "/companies/createComapnySession.aspx?companyGuid=" + company_.companyGuid.ToString());
        //    }
        //}
        //Else
        using(var db = new Entities())
        {
            var q = (from a in db.Companies where a.email == email.Text.Trim() select a).FirstOrDefault();
            if(q == null)
            {
                Companies Companies_ = new  Companies();
                Companies_.email = email.Text.Trim();
                Companies_.companyGuid = Guid.NewGuid();
                Companies_.password = Tools.GetHash(password.Text.Trim().ToString());
                Companies_.dateIn = DateTime.Now;


                db.Companies.Add(Companies_);
                db.SaveChanges();
                // Session("employeeID") = Employees_.ID
                // Response.Redirect("/companies/default.aspx")\
                //databaseCon.ExecuteNonQuerySql("UPDATE EmployeeToCompany SET employeeID =" + Employees_.ID + " WHERE employeeEmail='" + Employees_.email + "'");
                //var q3 = (From a In db.EmployeeToCompany
                //          Where a.employeeID == Employees_.ID
                //              Select a).Distinct();
                //If(q3.Count() > 0)
                //    {
                //    foreach (EmployeeToCompany item in q3)
                //    {
                //        // Dim actionData As String = populateClassFromDB.GetSiteMessagesByKey("Delete")User & " " & Employees_.email & " " & populateClassFromDB.GetSiteMessagesByKey("Delete")registeredInSite
                //        // databaseCon.ExecuteNonQuerySql("insert into activityLogs(companyID,actionData,employeeID,companyView) values (" & companyID & ",N'" & actionData & "'," & Employees_.ID & ",1)")
                //        activityLogs activityLogs_ = New activityLogs();
                //        activityLogs_.companyID = item.companyID;
                //        activityLogs_.companyView = 0;
                //        activityLogs_.dateIn = DateTime.Now;
                //        activityLogs_.deletedByEmployeeID = 0;
                //        activityLogs_.employeeID = 0;
                //        activityLogs_.siteLinkID = 12;
                //        activityLogs_.siteMessageID = 74;
                //        activityLogs_.externalTableID = item.ID;
                //        db.activityLogs.Add(activityLogs_);
                //    }
                //    db.SaveChanges();
                //}

                //Mailing.companyEmailActivation(email.Text.Trim.ToLower, "live-interview.com", Employees_.employeeGuid);
                //var message = populateClassFromDB.GetSiteMessages(2);
                //admin.popUp(Page, message);
            }
            else
            {
                //var message = populateClassFromDB.GetSiteMessages(1);
                //admin.popUp(Page, message);
            }
        }
    }


</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        $(document).ready(function () {
            $("#ContentPlaceHolder1_email").keyup(function () {
                $(this).val($(this).val().replace(/\s/g, ""));
            });
            $("#ContentPlaceHolder1_password").keyup(function () {
                $(this).val($(this).val().replace(/\s/g, ""));
            });
        });





    </script>
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
 <%--                   <div class="head">
                        <div class="isw-ok">
                        </div>
                        <h2 runat="server" id="newEmployee"><%=populateClassFromDB.GetSiteMessagesByKey("companyRegister")%></h2>
                        <div runat="server" id="requestEmployee" visible="false">
                            <h2><%=populateClassFromDB.GetSiteMessagesByKey("invitationFromACompany")%> <%= company_.companyName%></h2>
                            <h2><%=populateClassFromDB.GetSiteMessagesByKey("serveAsAnInterviewer")%></h2>
                        </div>
                        <div class="clear">
                        </div>
                    </div>--%>
                    <div class="block-fluid">
                        <div class="row-form" style="display: none">
                            <div id="companySignupLoginDiv">
                                <ul id="companySignupLogin">
                                    <li class="active leftSide"><%=populateClassFromDB.GetSiteMessagesByKey("companyRegister")%></li>
                                    <li class="rightSide"><a href="companyLogin.aspx"><%=populateClassFromDB.GetSiteMessagesByKey("companyLogin")%></a></li>
                                </ul>

                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <div class="row-form">
                            <%--                        <div class="span3">
                            :</div>--%>
                            <div class="span9">
                                <asp:TextBox ID="email" runat="server" autocomplete="off" onkeyup="myFunction(this)"></asp:TextBox><span>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="email"
                                        Display="Dynamic" CssClass="errValidator" SetFocusOnError="true" />
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="email"
                                        Display="Dynamic" CssClass="errValidator" SetFocusOnError="true" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
                                </span>
                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <div class="row-form">
                            <%--                        <div class="span3">
                            <%=populateClassFromDB.GetSiteMessagesByKey("Delete")Password%>:</div>--%>
                            <div class="span9">
                                <asp:TextBox ID="password" runat="server" MaxLength="10" TextMode="Password" onkeyup="myFunction(this)"></asp:TextBox>
                                <span>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="password"
                                        Display="Dynamic" SetFocusOnError="true" CssClass="errValidator" /></span>
                                <asp:RegularExpressionValidator ControlToValidate="password" CssClass="errValidator" ID="RegularExpressionValidator2" ValidationExpression="^[a-zA-Z0-9]{6,8}$" runat="server" Display="Dynamic"></asp:RegularExpressionValidator>
                            </div>
                            <div style="color: black"><%=populateClassFromDB.GetSiteMessagesByKey("passwordPlaceholder")%></div>
                            <div class="clear">
                            </div>
                        </div>
                        <div class="row-form" style="display:none">

                            <div class="span9">
                                <asp:TextBox ID="fullName" runat="server" MaxLength="20"></asp:TextBox>
<%--                                <span>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="fullName"
                                        Display="Dynamic" SetFocusOnError="true" CssClass="errValidator" /></span>--%>

                            </div>
                            <div class="clear">
                            </div>
                        </div>
                        <div class="row-form">
                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="true" ShowValidationErrors="true" />
                            <asp:Button class="bigButton" ID="Button1" runat="server" OnClick="Button1_Click" />
                            <%--                            <a href="ForgotPassword.aspx"><%=populateClassFromDB.GetSiteMessagesByKey("Delete")forgotPassword%></a>--%>
                        </div>
                    </div>
                </div>
            </div>
            <div>
            </div>

        </div>

    </div>
</asp:Content>

