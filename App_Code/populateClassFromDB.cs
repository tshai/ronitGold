using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

/// <summary>
/// Summary description for populateClassFromDB
/// </summary>
public class populateClassFromDB
{
	public static DomainsList getDomainByUrl(string domain)
	{
		var result = new DomainsList();
		using (var db = new Entities())
		{
			result = (from a in db.DomainsList where a.url == domain select a).FirstOrDefault();
		}
		return result;
	}
	public static Theme getThemeById(int ID)
	{
		var result = new Theme();
		using (var db = new Entities())
		{
			result = (from a in db.Theme where a.ID == ID select a).FirstOrDefault();
		}
		return result;
	}

	public static Masters getMasterById(int ID)
	{
		var result = new Masters();
		using (var db = new Entities())
		{
			result = (from a in db.Masters where a.ID == ID select a).FirstOrDefault();
		}
		return result;
	}

	public static string GetSiteMessages(int id)
	{
		using (var db = new Entities())
		{
			var languageID = int.Parse(HttpContext.Current.Session["languageID"].ToString());
			var siteMessageToLang = (from b in db.SiteMessagesToLanguages where b.siteMessageID == id && b.languageID == languageID select b).FirstOrDefault();
			if (siteMessageToLang != null)
			{
				return siteMessageToLang.message;
			}
			else
			{
				return "";
			}
		}
	}

	public static string GetSiteMessagesByKey(string key)
	{
		using (var db = new Entities())
		{
			var languageID = int.Parse(HttpContext.Current.Session["languageID"].ToString());
			var siteMessageID = (from c in db.SiteMessages where c.message == key select c.ID).First();
			var siteMessageToLang = (from d in db.SiteMessagesToLanguages where d.siteMessageID == siteMessageID && d.languageID == languageID select d).FirstOrDefault();
			if (siteMessageToLang != null)
			{
				return siteMessageToLang.message;
			}
			else
			{
				return "";
			}
		}
	}

	public static int getLanguageIdByDomainId(int domainID)
	{
		var languageID = 0;
		using (var db = new Entities())
		{
			languageID = (from a in db.DomainsList where a.ID == domainID select a).FirstOrDefault().languageID;
		}
		return languageID;
	}

	public static string getReadySentencesFromDomain(int domainID, string textKey)
	{
		var sentence = "";
		using (var db = new Entities())
		{
			sentence = (from a in db.domainToReadySentense where a.domainListID == domainID && a.ReadySentenses.textKey == textKey select a).FirstOrDefault().description;
		}
		return sentence;
	}

	public static string getSiteDirectionByLanguageID(int languageID)
	{
		var direction = "";
		using (var db = new Entities())
		{
			direction = (from a in db.Languages where a.ID == languageID select a).FirstOrDefault().direction;
		}
		return direction;
	}

	public static string getTextAlignByDirection(string direction)
	{
		var textAlign = "";
		switch (direction)
		{
			case "rtl":
				textAlign = "right";
				break;
			case "ltr":
				textAlign = "left";
				break;
			default:
				break;
		}
		return textAlign;
	}

	public static List<MenuToDomain> GetMenuByDomainID(int domainListID, int menuType)
	{
		using (var db = new Entities())
		{
			//StringBuilder sb = new StringBuilder();
			return (from a in db.MenuToDomain where a.domainListID == domainListID && a.menuType == menuType && a.visibility == 1 orderby a.apperOrder descending select a).ToList();
			//foreach(var item in x)
			//{
			//    sb.Append("<li><a href='" + item.Pages.pageLink + "'>" + item.linkName + "</a></li>");
			//}
			//return sb.ToString();
		}
	}
	public static string generateMenu(List<MenuToDomain> MenuToDomainList)
	{
		using (var db = new Entities())
		{
			StringBuilder sb = new StringBuilder();
			string link;
			var counter = 0;
			foreach (var item in MenuToDomainList)
			{
				//link = from a in db.Pages where a.ID == item.pageID select a.pageLink;
				sb.Append("<li><div class='editBox editText' id='divTextHeader" + counter + "'>" +
					"<div onclick='doBlackTextHeader(divTextHeader" + counter + ", " + counter + ", a" + counter + ")'>" +
					"<i class='fa fa-pencil-square-o' aria-hidden='true'></i></div>" +
					"<div class='saveButtonTextHeader' onclick='saveTextFromHeaderToDb("+ "\"" + item.ID + "\", $(" + "\"#" + item.linkName + "\").val())'>" +
					GetSiteMessagesByKey("Save") + "</div>" +
					"<input type ='text' id='" + item.linkName + "' onkeyup='showHeaderInDiv(this.id, a" + counter + ")'" +
					"class='inputTextHeader' runat='server' /></div>");
				sb.Append("<a id='a" + counter + "' href='" + getPages(item.pageID).pageLink + "'>" + item.linkName + "</a></li>");
				counter++;
			}
			return sb.ToString();
		}
	}
	public static Pages getPages(int pageID)
	{
		using (var db = new Entities())
		{
			return (from a in db.Pages where a.ID == pageID select a).First();
		}
	}

	public static Texts getAboutFromDomain(int domainID)
	{
		using (var db = new Entities())
		{
			return (from a in db.Texts where a.domainListID == domainID select a).First();
		}
	}
}