using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;

/// <summary>
/// Summary description for Culture
/// </summary>
public class Culture : Page
{
	protected void Page_PreInit(object sender, EventArgs e)
	{
        string domain;
        DomainsList domainList_ = new DomainsList();
        
        if (Session["domainListID"] == null)
        {
            Theme theme_ = new Theme();
            domain = Request.Url.Host.Replace("www.", "");
            domainList_ = populateClassFromDB.getDomainByUrl(domain);
            theme_ = populateClassFromDB.getThemeById(domainList_.themeID);
            Session["domainListID"] = domainList_.ID;
            Session["theme"] = theme_.name;
            Session["masterPage"] = populateClassFromDB.getMasterById(theme_.masterPageID).name;
            Session["languageID"] = populateClassFromDB.getLanguageIdByDomainId(domainList_.ID);
        }
		using (var db = new Entities())
		{
			int domainListID = int.Parse(Session["domainListID"].ToString());
			string linkName = Request.RawUrl;
			//Response.Write(linkName);
			//Response.End();
			var menuToDomain = from a in db.MenuToDomain where a.domainListID == domainListID && a.Pages.pageLink == linkName select a;
			if (menuToDomain.Any())
			{
				Page.Title = (from a in db.MenuToDomain where a.domainListID == domainListID && a.Pages.pageLink == linkName select a).First().PageTitle;
			}
		}
       
        Theme = Session["theme"].ToString();
		Page.MasterPageFile = "~/masters/" + Session["masterPage"];
        var languageID = Session["languageID"];

        //HttpContext.Current.Session["languageID"] = languageID;
	}	
}