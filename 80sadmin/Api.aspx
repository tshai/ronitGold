<%@ Page Language="C#" Theme="" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data.Entity" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Collections.Generic" %>

<script runat="server">
	protected void Page_Load(object sender, EventArgs e)
	{
		//requestt
		Response.Expires = 0;
		Response.AddHeader("pragma", "no-cache");
		Response.AddHeader("cache-control", "private");
		Response.CacheControl = ("no-cache");
		if (Session["companyID"] != null)
		{
			var companyID = int.Parse(Session["companyID"].ToString());
			var domainID = int.Parse(Session["domainListID"].ToString());
			IQueryable<DomainToCompanies> domainToCompany;
			using (var db = new Entities())
			{
				domainToCompany = from a in db.DomainToCompanies where a.companyID == companyID && a.domainID == domainID select a;
				if (domainToCompany.Any())
				{
					if (Request["qType"] == "1") // save image in db 
					{
						var pageID = int.Parse(Request["pageID"].ToString());
						var imageID = Request["imageID"].ToString();
						//string path = Server.MapPath("/media/images/");
						//var width = Request["width"];
						//var height = Request["height"];
						//var width = 2000;

						//var height = 2000;
						var isImageInDb = from a in db.ThemePics where a.pageID == pageID && a.imgID == imageID && a.Pages.ReadySentenses.FirstOrDefault().domainToReadySentense.FirstOrDefault().domainListID == domainID select a;
						if (isImageInDb.Any())
						{
							var themePicsExist = isImageInDb.FirstOrDefault();
							var oldFilePathL = "\\media\\paints\\large\\" + themePicsExist.fileName;
							var oldFilePathT = "\\media\\paints\\thumbs\\" + themePicsExist.fileName;
							System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathL);
							System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathT);
							foreach (string upload in Request.Files)
							{
								//try
								//{
								var file = Request.Files[upload];
								themePicsExist.fileName = PaintsClass.addPageImage(file);
								//ImageResizer.ImageBuilder.Current.Build(file, Path.Combine(path, themePicsExist.fileName), new ImageResizer.ResizeSettings("maxwidth=" + width + "&maxheight=" + height));
								//file.SaveAs(Path.Combine(path, themePicsExist.fileName));
								db.Entry(themePicsExist).State = EntityState.Modified;
								db.SaveChanges();
								Response.Write("success");
								Response.End();
								//}

								//catch (Exception ex)
								//{
								//    Response.Write(ex.InnerException);
								//    Response.End();
								//}
							}
							Response.Write("no success");
							Response.End();
						}
						else
						{
							var themePics = new ThemePics();
							themePics.imgID = imageID;
							themePics.themeID = domainToCompany.FirstOrDefault().DomainsList.themeID;
							themePics.pageID = pageID;

							foreach (string upload in Request.Files)
							{
								var file = Request.Files[upload];
								themePics.fileName = PaintsClass.addPageImage(file);
								//ImageResizer.ImageBuilder.Current.Build(file, Path.Combine(path, themePics.fileName), new ImageResizer.ResizeSettings("maxwidth=" + width + "&maxheight=" + height));
							}
							db.ThemePics.Add(themePics);
							db.SaveChanges();
							Response.Write("success");
							Response.End();
						}
					}
					else if (Request["qType"] == "2") // save text in db 
					{
						var textKey = Request["textKey"];
						var newText = Request["newText"];
						var readySentence = (from a in db.ReadySentenses where a.textKey == textKey select a).FirstOrDefault();
						var domainToReadySentence = (from a in db.domainToReadySentense where a.readySentensesID == readySentence.ID && a.domainListID == domainID select a).FirstOrDefault();
						domainToReadySentence.description = Server.HtmlEncode(newText);
						db.Entry(domainToReadySentence).State = EntityState.Modified;
						db.SaveChanges();
					}
					else if (Request["qType"] == "3") // save menuToDomain in db 
					{
						var menuToDomainID = int.Parse(Request["menuToDomainID"].ToString());
						var newText = Request["newText"];
						var isExistMenuToDomain = (from a in db.MenuToDomain where a.domainListID == domainID && a.DomainsList.DomainToCompanies.FirstOrDefault().companyID == companyID select a);
						if (isExistMenuToDomain.Any())
						{
							var menuToDomain = isExistMenuToDomain.FirstOrDefault();
							menuToDomain.linkName = Server.HtmlEncode(newText);
							db.Entry(menuToDomain).State = EntityState.Modified;
							db.SaveChanges();
						}
					}
					else if (Request["qType"] == "4") // save about image in db 
					{
						//string path = Server.MapPath("\\media\\paints\\large\\");
						//var width = 300;
						//var height = 300;
						var text = populateClassFromDB.getAboutFromDomain(int.Parse(Session["domainListID"].ToString()));

						if (text.imageFile != null)
						{
							var oldFilePathL = "\\media\\paints\\large\\" + text.imageFile;
							var oldFilePathT = "\\media\\paints\\thumbs\\" + text.imageFile;
							System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathL);
							System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathT);
						}
						foreach (string upload in Request.Files)
						{
							var file = Request.Files[upload];
							text.imageFile = PaintsClass.addPageImage(file);
							//ImageResizer.ImageBuilder.Current.Build(file, Path.Combine(path, text.imageFile), new ImageResizer.ResizeSettings("maxwidth=" + width + "&maxheight=" + height));
						}
						db.Entry(text).State = EntityState.Modified;
						db.SaveChanges();
						Response.Write("success");
						Response.End();
					}
					else if (Request["qType"] == "5") // save logo image in db 
					{
						var domainLogo = (from a in db.DomainsList where a.ID == domainID && a.logo != null select a).FirstOrDefault();
						if (domainLogo.logo != null)
						{
							var oldFilePathL = "/media/paints/large/" + domainLogo.logo;
							var oldFilePathT = "/media/paints/thumbs/" + domainLogo.logo;
							System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathL);
							System.IO.File.Delete(Request.PhysicalApplicationPath + oldFilePathT);
						}
						foreach (string upload in Request.Files)
						{
							var file = Request.Files[upload];
							domainLogo.logo = PaintsClass.addPageImage(file);
							db.Entry(domainLogo).State = EntityState.Modified;
							db.SaveChanges();
							Response.Write("success");
							Response.End();
						}
					}
				}
				else
				{
					Response.Write("no domain to compamy");
				}
			}
		}
	}
</script>

