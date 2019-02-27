<%@ Page Title="" Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" %>

<script runat="server">
	protected void Page_Load(object sender, EventArgs e)
	{
		Page.Title = populateClassFromDB.GetSiteMessagesByKey("projects");
	}
	protected void ListView1_ItemDataBound(object sender, ListViewItemEventArgs e)
	{
		if (e.Item.ItemType == ListViewItemType.DataItem)
		{
			ListViewDataItem dataItem = (ListViewDataItem)e.Item;
			SqlDataSource objTags = (SqlDataSource)e.Item.FindControl("sdsEPic");
			Parameter parameter = objTags.SelectParameters[0];
			parameter.DefaultValue = ((System.Data.DataRowView)dataItem.DataItem).Row.ItemArray[0].ToString();  //article.ArticleID.ToString();
		}
	}
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
	<style>
	</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
	<div class="page-title">
		<div id="particles-js-pagetitle"></div>
		<div class="container">
			<h1>פרוייקטים</h1>
			<h6>Dream House</h6>
		</div>
	</div>
	<div class="img_container">
		<asp:ListView ID="ListView1" runat="server" DataKeyNames="projectsID" DataSourceID="SqlDataSource1"
			OnItemDataBound="ListView1_ItemDataBound">
			<LayoutTemplate>
				<div class="eventContainer">
					<div id="itemPlaceHolder" runat="server">
					</div>
				</div>
				<div class="ItemsPaginationEng">
					<asp:DataPager ID="subItemsPager" runat="server" PagedControlID="ListView1" QueryStringField="page"
						PageSize="4">
						<Fields>
							<asp:NumericPagerField ButtonType="Link" ButtonCount="10" NextPreviousButtonCssClass="ItemPaginationLinkEng"
								NumericButtonCssClass="ItemPaginationLinkEng" CurrentPageLabelCssClass="ItemPaginationActiveEng"
								RenderNonBreakingSpacesBetweenControls="false" />
						</Fields>
					</asp:DataPager>
				</div>
			</LayoutTemplate>
			<ItemTemplate>
				<div class="eventItem">
					<div class="explainText">
						<p>
							<%# Eval("projectsName") %>
						</p>
						<p class="p1">
							<%#Eval("projectsPlace")%>
						</p>
					</div>
					<p class="eventItemText">

						<br />
						<div class="img_container">
							<asp:ListView ID="ListView2" runat="server" DataKeyNames="projectsID" DataSourceID="sdsEPic">
								<LayoutTemplate>
									<div class="masonry">
										<div id="itemPlaceHolder" runat="server">
										</div>
									</div>
									<%--<div class="ItemsPaginationEng">
                                    <asp:DataPager ID="subItemsPagerpic" runat="server" PagedControlID="ListView2" QueryStringField="page"
                                        PageSize="3">
                                        <Fields>
                                            <asp:NumericPagerField ButtonType="Link" ButtonCount="10" NextPreviousButtonCssClass="ItemPaginationLinkEng"
                                                NumericButtonCssClass="ItemPaginationLinkEng" CurrentPageLabelCssClass="ItemPaginationActiveEng"
                                                RenderNonBreakingSpacesBetweenControls="false" />
                                        </Fields>
                                    </asp:DataPager>
                                </div>--%>
								</LayoutTemplate>
								<ItemTemplate>
									<div class="masonry-item">
										<a href="/media/paints/large/<%# Eval("projectsImage") %>" rel="sexylightbox[group1]" title="<%# Eval("engDescription") %>">
											<img src="/media/paints/large/<%# Eval("projectsImage") %>" alt="<%# Eval("projectsImage") %>"
												class="galleryItemImg" />
										</a>
									</div>
								</ItemTemplate>
							</asp:ListView>
							<asp:SqlDataSource ID="sdsEPic" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
								SelectCommand="SELECT projectsID, projectsImage, engDescription FROM projectsPics WHERE projectsID = @projectsID">
								<SelectParameters>
									<asp:Parameter Name="projectsID" />
									<%-- <asp:ControlParameter ControlID="ListView1" DefaultValue="-1" Name="projectsID" PropertyName="SelectedValue" />--%>
									<%--<asp:Parameter DefaultValue="<%# Eval("projectsID") %>" Name="projectsID" Type="Int32" />--%>
								</SelectParameters>
							</asp:SqlDataSource>
						</div>
				</div>
			</ItemTemplate>
			<EmptyDataTemplate>
				<h3><%=populateClassFromDB.GetSiteMessagesByKey("noProjects") %></h3>
			</EmptyDataTemplate>
		</asp:ListView>
		<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
			SelectCommand="SELECT * FROM [projects] where domainListID=@domainListID">
			<SelectParameters>
				<asp:SessionParameter SessionField="domainListID" Name="domainListID" Type="Int32" />
			</SelectParameters>
		</asp:SqlDataSource>
	</div>
</asp:Content>

