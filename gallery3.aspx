<%@ Page Title="רונית גולדנפלד" Language="C#" MasterPageFile="~/SiteMaster.master" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<script runat="server">

    
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div class="eventLink">
              <table cellspacing="20" border="0"><tr>
               <td><a href="gallery3.aspx" style="color:#f26522"><p class="galleryItemHeader">Still Life</p></a></td>
                </tr></table>
          </div>
    

 <div class="img_container"> 
 <asp:ListView ID="ListView1" runat="server" DataKeyNames="paintID" 
        DataSourceID="SqlDataSource1">
        <LayoutTemplate>
          <div class="galleryContainer">
           <div id="itemPlaceHolder" runat="server"></div>
          </div>
           <div class="ItemsPaginationEng">
            <asp:DataPager ID="subItemsPager" runat="server" PagedControlID="ListView1"
                                              QueryStringField="page" PageSize="15">
              <Fields>
                <asp:NumericPagerField ButtonType="Link" ButtonCount="10"
                                       NextPreviousButtonCssClass="ItemPaginationLinkEng"
                                       NumericButtonCssClass="ItemPaginationLinkEng"
                                       CurrentPageLabelCssClass="ItemPaginationActiveEng"
                                       RenderNonBreakingSpacesBetweenControls="false" />
              </Fields>
            </asp:DataPager>
        </div>
        </LayoutTemplate>
        <ItemTemplate>
            <div class="galleryItem">
                 <p class="galleryItemHeader"><%# Eval("engName") %></p>
                 <a href="paints/large/<%# Eval("paintImage") %>" rel="sexylightbox[group1]"
                    title="<%# Eval("engName") %>, <%# Eval("paintSize") %>, <%# Eval("engDescription")%>, <%# Eval("remarks")%>" >
                    
                    <img src="paints/thumbs/<%# Eval("paintImage") %>" alt="<%# Eval("engName") %>" class="galleryItemImg" />
                </a>
          </div>
        </ItemTemplate>
        
    </asp:ListView>
 
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:paint %>" 
        SelectCommand="SELECT * FROM [Paints] where category=3 order by position"></asp:SqlDataSource>
            </div> 

</asp:Content>

