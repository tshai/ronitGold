<%@ Page Title="" Language="C#" MasterPageFile="~/80sadmin/Admin.master" %>


<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<style>
		table {
			width: 1000px;
		}

		p {
			word-break: break-all;
			width: 300px;
			padding: 5px;
		}

		.message {
			width: 600px;
		}
		td, th {
			padding: 5px;
		}

		.date {
			width: 200px;
		}

	</style>
	<h1>הודעות גולשים</h1>
	<div style="width: 1000px">
		<asp:GridView ID="GridView1" runat="server" DataSourceID="SqlDataSource1" AutoGenerateColumns="false">
			<Columns>
				<asp:BoundField DataField="contactID" HeaderText="contactID" ReadOnly="True" SortExpression="contactID" />
				<asp:TemplateField HeaderText="name">
					<ItemTemplate>
						<p><%#Server.HtmlDecode(Eval("name").ToString()) %></p>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="email">
					<ItemTemplate>
						<p><%#Eval("email") %></p>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="message">
					<ItemTemplate>
						<p class="message"><%#Server.HtmlDecode(Eval("message").ToString()) %></p>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="date">
					<ItemTemplate>
						<p class="date"><%#Eval("date_in") %></p>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
	</div>

	<asp:SqlDataSource ID="SqlDataSource1" runat="server"
		ConnectionString="<%$ ConnectionStrings:paint %>"
		DeleteCommand="DELETE FROM [Contacts] WHERE [contactID] = @contactID"
		InsertCommand="INSERT INTO [Contacts] ([name], [email], [message], [date_in]) VALUES (@name, @email, @message, @date_in)"
		SelectCommand="SELECT * FROM [Contacts] where domainListID=@domainListID order by date_in desc"
		UpdateCommand="UPDATE [Contacts] SET [name] = @name, [email] = @email, [message] = @message, [date_in] = @date_in WHERE [contactID] = @contactID">
		<DeleteParameters>
			<asp:Parameter Name="contactID" Type="Int32" />
		</DeleteParameters>
		<InsertParameters>
			<asp:Parameter Name="name" Type="String" />
			<asp:Parameter Name="email" Type="String" />
			<asp:Parameter Name="message" Type="String" />
			<asp:Parameter Name="date_in" Type="DateTime" />
		</InsertParameters>
		<UpdateParameters>
			<asp:Parameter Name="name" Type="String" />
			<asp:Parameter Name="email" Type="String" />
			<asp:Parameter Name="message" Type="String" />
			<asp:Parameter Name="date_in" Type="DateTime" />
			<asp:Parameter Name="contactID" Type="Int32" />
		</UpdateParameters>
		<SelectParameters>
			<asp:SessionParameter Name="domainListID" SessionField="domainListID" Type="Int32" />
		</SelectParameters>
	</asp:SqlDataSource>
</asp:Content>

