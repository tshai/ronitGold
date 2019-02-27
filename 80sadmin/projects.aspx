<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">
        protected void Button1_Click(object sender, EventArgs e)
    {
        LabelMessege.Text = Contents.addProjects(TextBoxProjectsName.Text, TextBoxProjectsPlace.Text);
        Response.Redirect(Request.RawUrl);
    }
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Request["ev"] != null)
		{
			var projectID = int.Parse(Request["ev"].ToString());
			using (var db = new Entities())
			{
				var projectPics = from a in db.projectsPics where a.projectsID == projectID select a;
				foreach (var pic in projectPics)
				{
					var oldFilePath = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\large\\" + pic.projectsImage;
					var oldFilePath2 = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\thumbs\\" + pic.projectsImage;
					System.IO.File.Delete(oldFilePath);
					System.IO.File.Delete(oldFilePath2);
				}
				db.projectsPics.RemoveRange(projectPics);
				db.SaveChanges();

				var project = from a in db.projects where a.projectsID == projectID select a;
				db.projects.RemoveRange(project);
				db.SaveChanges();
				Response.Redirect("/80sadmin/projects.aspx");
			}
		}
	}
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <h1>
        הוספת פרוייקטים</h1>
     <div class="formSection">
    <asp:Label ID="LabelMessege" runat="server" Text=""></asp:Label>
    <br />
            <div class="form1">
   <label> שם:</label>
    <asp:TextBox ID="TextBoxProjectsName" runat="server"></asp:TextBox>
   </div> 
         <div class="form1">
     <label>הסבר:</label>
    <asp:TextBox ID="TextBoxProjectsPlace" runat="server"  TextMode="MultiLine" Height="119px" Width="206px"></asp:TextBox>
    </div> 
          <div class="form1">
    <asp:Button ID="ButtonAddProjects" runat="server" Text="הוספה" OnClick="Button1_Click" />
    </div>
         </div> 
    <div class="grid">
	<h1>פרוייקטים</h1>
	<asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
		AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
		BorderWidth="1px" CellPadding="3" DataKeyNames="projectsID" DataSourceID="SqlDataSource1"
		ForeColor="Black" GridLines="Vertical" EnableModelValidation="True">
		<AlternatingRowStyle BackColor="#CCCCCC" />
		<Columns>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("projectsID","projects.aspx?ev={0}") %>'>Delete</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:CommandField ShowEditButton="True" />
			<asp:BoundField DataField="projectsID" HeaderText="projectsID" ReadOnly="True" SortExpression="projectsID"
				InsertVisible="False" />
			<asp:BoundField DataField="projectsName" HeaderText="projectsName" SortExpression="projectsName" />
			<asp:BoundField DataField="projectsPlace" HeaderText="projectsPlace" SortExpression="projectsPlace" />
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("projectsID","addProjectsPaint.aspx?ev={0}") %>'>Add pic</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<FooterStyle BackColor="#CCCCCC" />
		<HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
		<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
		<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
	</asp:GridView>
	<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
	    InsertCommand="INSERT INTO [projects] ([projectsName], [projectsPlace], [domainListID]) VALUES (@projectsName, @projectsPlace,@domainListID)"
	    SelectCommand="SELECT * FROM [projects] where domainListID=@domainListID"
		UpdateCommand="UPDATE [projects] SET [projectsName] = @projectsName, [projectsPlace] = @projectsPlace WHERE [projectsID] = @projectsID">
		<DeleteParameters>
			<asp:Parameter Name="original_projectsID" Type="Int32" />
		</DeleteParameters>
		<InsertParameters>
			<asp:Parameter Name="projectsName" Type="String" />
			<asp:Parameter Name="projectsPlace" Type="String" />
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</InsertParameters>
		<UpdateParameters>
			<asp:Parameter Name="projectsName" Type="String" />
			<asp:Parameter Name="projectsPlace" Type="String" />
			<asp:Parameter Name="projectsID" Type="Int32" />
		</UpdateParameters>
		<SelectParameters>
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</SelectParameters>
	</asp:SqlDataSource>
        </div> 
</asp:Content>
