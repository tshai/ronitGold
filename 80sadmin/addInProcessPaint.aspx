<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ev"]))
            {
                hnfEventId.Value = Request.QueryString["ev"];
            }
        }
    }
    protected void ButtonAdd_Click(object sender, EventArgs e)
    {
        LabelMessage.Text = PaintsClass.addNewInProcessPaint(int.Parse(ddlInProcessid.SelectedItem.Value), txtdesc.Text, FileUploadImage);
         Response.Redirect(Request.RawUrl);
    }

    protected void ddlInProcessid_DataBound(object sender, EventArgs e)
    {
        ddlInProcessid.Items.Insert(0, new ListItem("select event", "-1"));
        ListItem i = ddlInProcessid.Items.FindByValue(Request.QueryString["ev"].ToString());
        if (i != null)
        {
            i.Selected = true;
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <h2>
        הוספת תמונה לתהליך עבודה</h2>
    <br />
    <asp:Label ID="LabelMessage" runat="server" Text="" Font-Size="X-Large" ForeColor="#339933"></asp:Label>
    <br />
    <div class="formBody">
        <div class="formRow">
            <asp:HiddenField ID="hnfEventId" runat="server" />
            <asp:Label ID="LabelName" runat="server" Text="בתהליך עבודה"></asp:Label>
            <%--<asp:TextBox ID="TextBoxEventID" runat="server"></asp:TextBox>--%>
            <asp:DropDownList ID="ddlInProcessid" runat="server" DataSourceID="sdsInProcess" DataTextField="inProcessName"
                DataValueField="inProcessID" OnDataBound="ddlInProcessid_DataBound">
            </asp:DropDownList>
            <asp:SqlDataSource ID="sdsInProcess" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
                SelectCommand="SELECT [inProcessID], [inProcessName] FROM [inProcess]"></asp:SqlDataSource>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" InitialValue="-1"
                ErrorMessage="*שדה חובה" Display="Dynamic" ControlToValidate="ddlInProcessid"></asp:RequiredFieldValidator>
        </div>
        <div class="formRow">
            <asp:Label ID="LabelEngDescription" runat="server" Text="תיאור התמונה"></asp:Label>
            <asp:TextBox ID="txtdesc" runat="server"  TextMode="MultiLine" Height="155px" Width="226px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*שדה חובה"
                Display="Dynamic" ControlToValidate="txtdesc"></asp:RequiredFieldValidator>
        </div>
        <div class="formRow">
            <asp:Label ID="LabelImage" runat="server" Text="העלאת התמונה"></asp:Label>
            <div style="float: left">
                <asp:FileUpload ID="FileUploadImage" runat="server" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*שדה חובה"
                    Display="Dynamic" ControlToValidate="FileUploadImage"></asp:RequiredFieldValidator>
            </div>
        </div>
        <div class="formRow">
            <asp:Button ID="ButtonAdd" runat="server" Text="להוסיף" OnClick="ButtonAdd_Click" />
        </div>
    </div>
    <div>
        <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
            AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
            BorderWidth="1px" CellPadding="3" DataKeyNames="inProcessID" DataSourceID="SqlDataSource1"
            EnableModelValidation="True" ForeColor="Black" GridLines="Vertical">
            <AlternatingRowStyle BackColor="#CCCCCC" />
            <Columns>
                <asp:CommandField ShowDeleteButton="True" />
                <asp:BoundField DataField="inProcessID" HeaderText="inProcessID" ReadOnly="True" SortExpression="inProcessID" />
                <asp:BoundField DataField="inProcessImage" HeaderText="inProcessImage" SortExpression="inProcessImage" />
                <asp:BoundField DataField="engDescription" HeaderText="engDescription" SortExpression="engDescription" />
                <asp:TemplateField >
                    <ItemTemplate >
                        <img src="/media/paints/large/<%#Eval("inProcessImage") %>" style="width:100px" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="#CCCCCC" />
            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
            <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConflictDetection="CompareAllValues"
            ConnectionString="<%$ ConnectionStrings:paint %>" DeleteCommand="DELETE FROM [inProcessPics] WHERE [inProcessID] = @original_inProcessID AND [inProcessImage] = @original_inProcessImage AND [engDescription] = @original_engDescription"
            InsertCommand="INSERT INTO [inProcessPics] ([inProcessID], [inProcessImage], [engDescription]) VALUES (@inProcessID, @inProcessImage, @engDescription)"
            OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [inProcessPics] where inProcessID=@inProcessID "
            UpdateCommand="UPDATE [inProcessPics] SET [inProcessImage] = @inProcessImage, [engDescription] = @engDescription WHERE [inProcessID] = @original_inProcessID AND [inProcessImage] = @original_inProcessImage AND [engDescription] = @original_engDescription">
            <DeleteParameters>
                <asp:Parameter Name="original_inProcessID" Type="Int32" />
                <asp:Parameter Name="original_inProcessImage" Type="String" />
                <asp:Parameter Name="original_engDescription" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="inProcessID" Type="Int32" />
                <asp:Parameter Name="inProcessImage" Type="String" />
                <asp:Parameter Name="engDescription" Type="String" />
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="inProcessImage" Type="String" />
                <asp:Parameter Name="engDescription" Type="String" />
                <asp:Parameter Name="original_inProcessID" Type="Int32" />
                <asp:Parameter Name="original_inProcessImage" Type="String" />
                <asp:Parameter Name="original_engDescription" Type="String" />
            </UpdateParameters>
            <SelectParameters>
                <asp:QueryStringParameter Name="inProcessID" QueryStringField="ev"  Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
