<%@ Page Title="" Language="C#" MasterPageFile="~/masters/1.master" Inherits="Culture" %>

<script runat="server">
	protected void Page_Load(object sender, EventArgs e)
	{
		Page.Title = populateClassFromDB.GetSiteMessagesByKey("workProcess");
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">


<!-- particles.js container -->
<%--<div id="particles-js"></div>

<!-- scripts -->
<script src="/App_Themes/1/js/particles.js"></script>
<script src="/App_Themes/1/js/app.js"></script>--%>



    <div class="page-title"><div id="particles-js-pagetitle"><canvas class="particles-js-canvas-el" width="1912" height="90" style="width: 100%; height:300px;"></canvas></div><div class="container"><h1>בית החלומות</h1><h6>Dream House</h6></div></div>
	
    <div class="img_container">
		<asp:ListView ID="ListView1" runat="server" DataKeyNames="inProcessID" DataSourceID="SqlDataSource1"
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
						<%# Eval("inProcessName") %>
					</p>
					<p class="p1">
						<%#Eval("inProcessPlace")%>
					</p>
					</div>
					<%--<p class="eventItemHeader">
						<%# Eval("inProcessName") %>
					</p>

					<p class="eventItemHeader1">
						<%#Eval("inProcessPlace")%>
					</p>--%>
					<br />
					<br />
					<p class="eventItemText">

						<br />
						<div class="img_container">
							<asp:ListView ID="ListView2" runat="server" DataKeyNames="inProcessID" DataSourceID="sdsEPic">
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
										<a href="/media/paints/large/<%# Eval("inProcessImage") %>" rel="sexylightbox[group1]" title="<%# Eval("engDescription") %>" class="imageSurrounded">
											<img src="/media/paints/large/<%# Eval("inProcessImage") %>" alt="<%# Eval("inProcessImage") %>"
												class="galleryItemImg" />
                                            <div class="masonry-item-overlay"><div class="masonry-item-overlay"><h4>Project 6</h4><ul><li><a href="#">Design</a></li><li><a href="#">Construction</a></li></ul><a href="#" class="center-holder project-arrow"><i class="fa fa-angle-right" aria-hidden="true"></i></a></div></div>
										</a>
									</div>
								</ItemTemplate>
							</asp:ListView>
							<asp:SqlDataSource ID="sdsEPic" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
								SelectCommand="SELECT inProcessID, inProcessImage, engDescription FROM inProcessPics WHERE inProcessID = @inProcessID">
								<SelectParameters>
									<asp:Parameter Name="inProcessID" />
									<%-- <asp:ControlParameter ControlID="ListView1" DefaultValue="-1" Name="eventID" PropertyName="SelectedValue" />--%>
									<%--<asp:Parameter DefaultValue="<%# Eval("eventID") %>" Name="eventID" Type="Int32" />--%>
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
			SelectCommand="SELECT * FROM [inProcess] where domainListID=@domainListID">
			<SelectParameters>
				<asp:SessionParameter SessionField="domainListID"  Name="domainListID" Type="Int32" />
			</SelectParameters>
		</asp:SqlDataSource>
	</div>
</asp:Content>

