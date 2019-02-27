<%@ Page Title="רונית גולד עיצוב פנים" Language="C#" MasterPageFile="~/SiteMaster.master" %>

<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <div class="aboutPic"></div>
 <div class="aboutText">
     <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1" 
         EnableModelValidation="True">
     <LayoutTemplate>
      <div id="itemPlaceholder" runat="server"></div>
     </LayoutTemplate>
     <ItemTemplate>
      <%#Eval("text") %>
     </ItemTemplate>
     </asp:ListView>
     <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
         ConnectionString="<%$ ConnectionStrings:paint %>" 
         SelectCommand="SELECT [text] FROM [Texts] WHERE ([textName] = @textName)">
         <SelectParameters>
             <asp:Parameter DefaultValue="about" Name="textName" Type="String" />
         </SelectParameters>
     </asp:SqlDataSource>
 </div>
</asp:Content>

