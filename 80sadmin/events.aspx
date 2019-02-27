<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">
        protected void Button1_Click(object sender, EventArgs e)
    {
        LabelMessege.Text = Contents.addEvent(TextBoxEventName.Text, TextBoxEventPlace.Text);
        Response.Redirect(Request.RawUrl);
    }
	protected void Page_Load(object sender, EventArgs e)
	{
		if (Request["ev"] != null)
		{
			var eventID = int.Parse(Request["ev"].ToString());
			using (var db = new Entities())
			{
				var eventPics = from a in db.eventPics where a.eventID == eventID select a;
				foreach (var pic in eventPics)
				{
					var oldFilePath = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\large\\" + pic.eventImage;
					var oldFilePath2 = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\thumbs\\" + pic.eventImage;
					System.IO.File.Delete(oldFilePath);
					System.IO.File.Delete(oldFilePath2);
				}
				db.eventPics.RemoveRange(eventPics);
				db.SaveChanges();

				var events = from a in db.Events where a.eventID == eventID select a;
				db.Events.RemoveRange(events);
				db.SaveChanges();
				Response.Redirect("/80sadmin/events.aspx");
			}
		}
	}
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
       <h1>
        הוספת הדמיות</h1>
     <div class="formSection">
    <asp:Label ID="LabelMessege" runat="server" Text=""></asp:Label>
    <br />
         <div class="form1">
    <label>שם:</label>
             
    <asp:TextBox ID="TextBoxEventName" runat="server"></asp:TextBox>
    </div> 
 <div class="form1">
     <label>
    הסבר:
         </label>
    <asp:TextBox ID="TextBoxEventPlace" runat="server" TextMode="MultiLine" Height="119px" Width="206px"></asp:TextBox>
   </div> 
       <div class="form1">
    <asp:Button ID="ButtonAddEvent" runat="server" Text="הוספה" OnClick="Button1_Click" />
           </div> 
         </div> 
    <br />

    <div class="grid">
        	<h1>הדמיות</h1>
	<asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
		AutoGenerateColumns="False" BackColor="White" BorderColor="#999999" BorderStyle="Solid"
		BorderWidth="1px" CellPadding="3" DataKeyNames="eventID" DataSourceID="SqlDataSource1"
		ForeColor="Black" GridLines="Vertical" EnableModelValidation="True">
		<AlternatingRowStyle BackColor="#CCCCCC" />
		<Columns>
			<asp:CommandField ShowEditButton="True" />
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("eventID","events.aspx?ev={0}") %>'>Delete</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField DataField="eventID" HeaderText="eventID" ReadOnly="True" SortExpression="eventID"
				InsertVisible="False" />
			<asp:BoundField DataField="eventName" HeaderText="eventName" SortExpression="eventName" />
			<asp:BoundField DataField="eventPlace" HeaderText="eventPlace" SortExpression="eventPlace" />
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Eval("eventID","addEventPaint.aspx?ev={0}") %>'>Add pic</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<FooterStyle BackColor="#CCCCCC" />
		<HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
		<PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
		<SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
	</asp:GridView>
	<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
		DeleteCommand="DELETE FROM [Events] WHERE [eventID] = @original_eventID" InsertCommand="INSERT INTO [Events] ([eventName], [eventPlace], [domainListID]) VALUES (@eventName, @eventPlace, @domainListID)"
		OldValuesParameterFormatString="original_{0}" SelectCommand="SELECT * FROM [Events] where domainListID=@domainListID"
		UpdateCommand="UPDATE [Events] SET [eventName] = @eventName, [eventPlace] = @eventPlace WHERE [eventID] = @original_eventID">
		<DeleteParameters>
			<asp:Parameter Name="original_eventID" Type="Int32" />
		</DeleteParameters>
		<InsertParameters>
			<asp:Parameter Name="eventName" Type="String" />
			<asp:Parameter Name="eventPlace" Type="String" />
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</InsertParameters>
		<UpdateParameters>
			<asp:Parameter Name="eventName" Type="String" />
			<asp:Parameter Name="eventPlace" Type="String" />
			<asp:Parameter Name="original_eventID" Type="Int32" />
		</UpdateParameters>
		<SelectParameters>
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</SelectParameters>
	</asp:SqlDataSource>
        </div>
</asp:Content>
