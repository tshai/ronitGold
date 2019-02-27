<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">
    protected void Button1_Click(object sender, EventArgs e)
    {
        LabelMessege.Text = Contents.addInProcess(TextBoxEventName.Text, TextBoxEventPlace.Text);
        Response.Redirect(Request.RawUrl);
    }
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Request["ev"] != null)
		{
			var processID = int.Parse(Request["ev"].ToString());
			using (var db = new Entities())
			{
				var processPics = from a in db.inProcessPics where a.inProcessID == processID select a;

					foreach (var pic in processPics)
				{
					var oldFilePath = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\large\\" + pic.inProcessImage;
					var oldFilePath2 = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\thumbs\\" + pic.inProcessImage;
					System.IO.File.Delete(oldFilePath);
					System.IO.File.Delete(oldFilePath2);
				}

				db.inProcessPics.RemoveRange(processPics);
				db.SaveChanges();

				var process = from a in db.inProcess where a.inProcessID == processID select a;
				db.inProcess.RemoveRange(process);
				db.SaveChanges();
				Response.Redirect("/80sadmin/inProcess.aspx");
			}
		}
	}
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <h1>בתהליך עבודה</h1>
        <h1>
        הוספת בתהליך עבודה</h1>
    <div class="formSection">
    <asp:Label ID="LabelMessege" runat="server" Text=""></asp:Label>
<div class="form1">
   <label> שם:</label>
    <asp:TextBox ID="TextBoxEventName" runat="server"></asp:TextBox>
        </div>
    <div class="form1">
   <label> הסבר:</label>
    <asp:TextBox ID="TextBoxEventPlace" runat="server" TextMode="MultiLine" Height="119px" Width="206px"></asp:TextBox>
        </div>
    <div class="form1">
    <asp:Button ID="ButtonAddEvent" runat="server" Text="הוספה" OnClick="Button1_Click" />
    </div>
        </div>
    <hr />
     <div class="grid">
	<asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
		AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
		BorderWidth="1px" CellPadding="3" DataKeyNames="inProcessID" DataSourceID="SqlDataSource1"
		ForeColor="Black" GridLines="Vertical" EnableModelValidation="True">
		<AlternatingRowStyle BackColor="#CCCCCC" />
		<Columns>
			<asp:CommandField ShowEditButton="True" />
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("inProcessID","inProcess.aspx?ev={0}") %>'>Delete</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField DataField="inProcessID" HeaderText="inProcessID" ReadOnly="True" SortExpression="inProcessID"
				InsertVisible="False" />
			<asp:BoundField DataField="inProcessName" HeaderText="inProcessName" SortExpression="inProcessName" />
			<asp:BoundField DataField="inProcessPlace" HeaderText="inProcessPlace" SortExpression="inProcessPlace" />
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl='<%# Eval("inProcessID","addInProcessPaint.aspx?ev={0}") %>'>Add pic</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<FooterStyle BackColor="#CCCCCC" />
		<HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
		<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
		<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
	</asp:GridView>
	<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
		DeleteCommand="DELETE FROM [inProcess] WHERE [inProcessID] = @inProcessID" InsertCommand="INSERT INTO [inProcess] ([inProcessName], [inProcessPlace], [domainListID]) VALUES (@inProcessName, @inProcessPlace, @domainListID)"
		SelectCommand="SELECT * FROM [inProcess] where domainListID = @domainListID"
		UpdateCommand="UPDATE [inProcess] SET [inProcessName] = @inProcessName, [inProcessPlace] = @inProcessPlace WHERE [inProcessID] = @inProcessID">
		<DeleteParameters>
			<asp:Parameter Name="inProcessID" Type="Int32" />
		</DeleteParameters>
		<InsertParameters>
			<asp:Parameter Name="inProcessName" Type="String" />
			<asp:Parameter Name="inProcessPlace" Type="String" />
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</InsertParameters>
		<UpdateParameters>
			<asp:Parameter Name="inProcessName" Type="String" />
			<asp:Parameter Name="inProcessPlace" Type="String" />
			<asp:Parameter Name="inProcessID" Type="Int32" />
		</UpdateParameters>
		<SelectParameters>
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</SelectParameters>
	</asp:SqlDataSource>
         </div> 
</asp:Content>
