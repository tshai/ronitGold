<%@ Page Title="רונית גולדנפלד" Language="C#" MasterPageFile="~/SiteMaster.master" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<script runat="server">

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
    <div class="img_container">
        <asp:ListView ID="ListView1" runat="server" DataKeyNames="projectsID" DataSourceID="SqlDataSource1"
            OnItemDataBound="ListView1_ItemDataBound">
            <LayoutTemplate>
                <div class="projectsContainer">
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
                <div class="projectsItem">
                    <p class="projectsItemHeader">
                        <%# Eval("projectsName") %></p>
                   
                 
                    <%#Eval("projectsPlace")%>
                    <br />
                    <br />
                    <p class="projectsItemText">
                      
                    <br />
                    <div class="img_container">
                        <asp:ListView ID="ListView2" runat="server" DataKeyNames="projectsID" DataSourceID="sdsEPic">
                            <LayoutTemplate>
                                <div class="galleryContainer">
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
                                <div class="galleryItem" style="height: 110px; padding: 3px; width: 110px;">
                                    <a href="paints/large/<%# Eval("projectsImage") %>" rel="sexylightbox[group1]" title="<%# Eval("engDescription") %>">
                                        <img src="paints/thumbs/<%# Eval("projectsImage") %>" alt="<%# Eval("projectsImage") %>"
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
                <h3>
                    There are no projects at this time...</h3>
            </EmptyDataTemplate>
        </asp:ListView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:paint %>"
            SelectCommand="SELECT * FROM [projects]"></asp:SqlDataSource>
    </div>
</asp:Content>
