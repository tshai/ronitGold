using System;
using System.Collections.Generic;
using System.Web;
using System.Data.SqlClient;
using System.Data.Entity;
using System.Web.UI.WebControls;
using System.IO;
using ASPJPEGLib;
using System.Drawing;

/// <summary>
/// Summary description for Paints
/// </summary>
public class PaintsClass
{
	public static string addNewEventPaint(int eventID, string idesc, FileUpload img)
	{
		string result = "";
		try
		{
			using (SqlConnection con = Cms.connectToPainter())
			{
				SqlCommand cmd = new SqlCommand("INSERT INTO eventPics (eventID, eventImage ,engDescription, domainListID) VALUES (@eventID, @eventImage ,@engDescription, @domainListID)", con);
				cmd.CommandType = System.Data.CommandType.Text;
				cmd.Parameters.Add("@eventID", System.Data.SqlDbType.Int).Value = eventID;
				cmd.Parameters.Add("@domainListID", System.Data.SqlDbType.Int).Value = int.Parse(HttpContext.Current.Session["domainListID"].ToString());
				cmd.Parameters.Add("@eventImage", System.Data.SqlDbType.NVarChar, 50).Value = addPaintImage(img);
				cmd.Parameters.Add("@engDescription", System.Data.SqlDbType.NVarChar, 1000).Value = idesc;

				cmd.ExecuteNonQuery();
				result = "התמונה נוסף בהצלחה";
			}
		}
		catch (Exception ex)
		{
			result = ex.Message;
		}
		return result;
	}
	public static string addNewInProcessPaint(int inProcessID, string idesc, FileUpload img)
	{
		string result = "";
		//try
		//{
		using (SqlConnection con = Cms.connectToPainter())
		{
			SqlCommand cmd = new SqlCommand("INSERT INTO inProcessPics (inProcessID, inProcessImage ,engDescription) VALUES (@inProcessID, @inProcessImage ,@engDescription)", con);
			cmd.CommandType = System.Data.CommandType.Text;
			cmd.Parameters.Add("@inProcessID", System.Data.SqlDbType.Int).Value = inProcessID;
			cmd.Parameters.Add("@inProcessImage", System.Data.SqlDbType.NVarChar, 50).Value = addPaintImage(img);
			cmd.Parameters.Add("@engDescription", System.Data.SqlDbType.NVarChar, 1000).Value = idesc;

			cmd.ExecuteNonQuery();
			result = "התמונה נוסף בהצלחה";
		}
		//}
		//catch (Exception ex)
		//{
		//    result = ex.Message;
		//}
		return result;
	}
	public static string addNewProjectsPaint(int projectsID, string idesc, FileUpload img)
	{
		string result = "";
		try
		{
			using (SqlConnection con = Cms.connectToPainter())
			{
				SqlCommand cmd = new SqlCommand("INSERT INTO projectsPics (projectsID, projectsImage ,engDescription) VALUES (@projectsID, @projectsImage ,@engDescription)", con);
				cmd.CommandType = System.Data.CommandType.Text;
				cmd.Parameters.Add("@projectsID", System.Data.SqlDbType.Int).Value = projectsID;
				cmd.Parameters.Add("@projectsImage", System.Data.SqlDbType.NVarChar, 50).Value = addPaintImage(img);
				cmd.Parameters.Add("@engDescription", System.Data.SqlDbType.NVarChar, 1000).Value = idesc;

				cmd.ExecuteNonQuery();
				result = "התמונה נוסף בהצלחה";
			}
		}
		catch (Exception ex)
		{
			result = ex.Message;
		}
		return result;
	}
	//public static string addNewPaint(string name, string engname, string description, string engdescription, string size, FileUpload img, string remarks, bool isSold)
	//{
	//    string result = "";
	//    try
	//    {
	//        using (SqlConnection con = Cms.connectToPainter())
	//        {
	//            SqlCommand cmd = new SqlCommand("AddNewPaint", con);
	//            cmd.CommandType = System.Data.CommandType.StoredProcedure;
	//            cmd.Parameters.Add("@name", System.Data.SqlDbType.NVarChar, 50).Value = HttpContext.Current.Server.HtmlEncode(name);
	//            cmd.Parameters.Add("@description", System.Data.SqlDbType.NVarChar, 50).Value = HttpContext.Current.Server.HtmlEncode(description);
	//            cmd.Parameters.Add("@engname", System.Data.SqlDbType.NVarChar, 50).Value = HttpContext.Current.Server.HtmlEncode(engname);
	//            cmd.Parameters.Add("@engdescription", System.Data.SqlDbType.NVarChar, 50).Value = HttpContext.Current.Server.HtmlEncode(engdescription);
	//            cmd.Parameters.Add("@size", System.Data.SqlDbType.NVarChar, 10).Value = HttpContext.Current.Server.HtmlEncode(size);
	//            cmd.Parameters.Add("@img", System.Data.SqlDbType.VarChar, 50).Value = addPaintImage(img);
	//            cmd.Parameters.Add("@remarks", System.Data.SqlDbType.NVarChar, 200).Value = HttpContext.Current.Server.HtmlEncode(remarks);
	//            cmd.Parameters.Add("@isSold", System.Data.SqlDbType.Bit).Value = isSold;
	//cmd.Parameters.Add("@domainListID", System.Data.SqlDbType.Int).Value = HttpContext.Current.Session["domainListID"];
	//cmd.ExecuteNonQuery();
	//            result = "התמונה נוסף בהצלחה";
	//        }
	//    }
	//    catch (Exception ex)
	//    {
	//        result = ex.Message;
	//    }
	//    return result;
	//}
	//=============================================================================================================

	public static string addPaintImage(FileUpload fileUploadImage)
	{
		string pathL = HttpContext.Current.Server.MapPath("\\media\\paints\\large\\");
		string pathT = HttpContext.Current.Server.MapPath("\\media\\paints\\thumbs\\");
		string FileName = Guid.NewGuid().ToString() + Path.GetExtension(fileUploadImage.FileName);

		fileUploadImage.SaveAs(Path.Combine(pathL, "_" + FileName));
		//System.Drawing.Image image = System.Drawing.Image.FromFile(Path.Combine(pathL, "_"+FileName));
		//int width = image.Width;
		//int height = image.Height;
		//decimal ratio = decimal.Parse(width.ToString());
		//HttpContext.Current.Response.Write(image.GetPropertyItem(0x112).Value);
		int rotate = 0;
		using (var image = System.Drawing.Image.FromFile(Path.Combine(pathL, "_" + FileName)))
		{
			foreach (var prop in image.PropertyItems)
			{
				if (prop.Id == 0x112)
				{
					if (prop.Value[0] == 6)
						rotate = 90;
					if (prop.Value[0] == 8)
						rotate = -90;
					if (prop.Value[0] == 3)
						rotate = 180;
					prop.Value[0] = 1;
				}
			}
		}
		HttpContext.Current.Response.Write(rotate);

		//ImageResizer.ImageBuilder.Current.Build(fileUploadImage.PostedFile, Path.Combine(pathL, FileName),new ImageResizer.ResizeSettings("maxwidth=2000&maxheight=2000"));
		//System.Drawing.Image image2 = System.Drawing.Image.FromFile(Path.Combine(pathL, FileName));
		//int width2 = image2.Width;
		//int height2 = image2.Height;
		//decimal ratio2 = decimal.Parse(width2.ToString()) / decimal.Parse(height2.ToString());
		//HttpContext.Current.Response.Write(ratio2 + "<br>" + ratio);
		//HttpContext.Current.Response.Write(width + "<br>" + height + "<br>" + ratio.ToString());
		//HttpContext.Current.Response.Write(Path.Combine(pathL, "_" + FileName));

		//HttpContext.Current.Response.End();
		//if(ratio!= ratio2)
		//{
		var r = new ImageResizer.ResizeSettings();
		r.MaxWidth = 1500;
		r.MaxHeight = 1500;
		r.Rotate = rotate;
		//    //r.CropMode=
		ImageResizer.ImageBuilder.Current.Build(fileUploadImage.PostedFile, Path.Combine(pathL, FileName), r);
		File.Delete(Path.Combine(pathL, "_" + FileName));
		//}
		//ImageResizer.ImageBuilder.Current.Build(fileUploadImage.PostedFile, Path.Combine( pathL, FileName), new ImageResizer.ResizeSettings("maxwidth=2000&maxheight=2000"));
		//ImageResizer.ImageBuilder.Current.Build(fileUploadImage.PostedFile, Path.Combine(pathT, FileName), new ImageResizer.ResizeSettings("maxwidth=300&maxheight=300"));


		return FileName;
		//return fileUploadImage.FileName;
	}

	public static string addPageImage(HttpPostedFile fileUploadImage)
	{
		string pathL = HttpContext.Current.Server.MapPath("\\media\\paints\\large\\");
		string pathT = HttpContext.Current.Server.MapPath("\\media\\paints\\thumbs\\");
		string FileName = Guid.NewGuid().ToString() + Path.GetExtension(fileUploadImage.FileName);
		fileUploadImage.SaveAs(Path.Combine(pathL, "_" + FileName));
		int rotate = 0;
		using (var image = System.Drawing.Image.FromFile(Path.Combine(pathL, "_" + FileName)))
		{
			foreach (var prop in image.PropertyItems)
			{
				if (prop.Id == 0x112)
				{
					if (prop.Value[0] == 6)
						rotate = 90;
					if (prop.Value[0] == 8)
						rotate = -90;
					if (prop.Value[0] == 3)
						rotate = 180;
					prop.Value[0] = 1;
				}
			}
		}
		//HttpContext.Current.Response.Write(rotate);
		var r = new ImageResizer.ResizeSettings();
		r.MaxWidth = 1500;
		r.MaxHeight = 1500;
		r.Rotate = rotate;
		ImageResizer.ImageBuilder.Current.Build(fileUploadImage.InputStream, Path.Combine(pathL, FileName), r);
		File.Delete(Path.Combine(pathL, "_" + FileName));
		return FileName;
	}

	//public static string addPaintImage(FileUpload fileUploadImage)
	//{
	//    string result = "";
	//    string pathL = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\large\\";
	//    string pathT = HttpContext.Current.Request.PhysicalApplicationPath + "media\\paints\\thumbs\\";
	//    bool fileOK = false;
	//    string originalFileName = fileUploadImage.FileName;
	//    string newFileName = Guid.NewGuid().ToString().Replace("-", String.Empty);
	//    string fileExtension = "";
	//    string newImageName = "";

	//    // testing extension
	//    if (fileUploadImage.HasFile)
	//    {
	//        fileExtension = Path.GetExtension(fileUploadImage.FileName).ToLower();
	//        string[] allowedExtensions = { ".png", ".jpeg", ".jpg", ".gif" };
	//        for (int i = 0; i <= allowedExtensions.Length - 1; i++)
	//        {
	//            if (fileExtension == allowedExtensions[i])
	//                fileOK = true;
	//        }
	//    }

	//    if (fileOK == true)
	//    {
	//        fileUploadImage.SaveAs(pathL + originalFileName);
	//        ASPJpeg myJpg = new ASPJpeg();
	//        myJpg.Open(pathL + originalFileName);
	//        int maxsize = 600;
	//        if (myJpg.OriginalHeight < myJpg.OriginalWidth)
	//        {
	//            myJpg.Width = maxsize;
	//            myJpg.Height = myJpg.OriginalHeight * maxsize / myJpg.OriginalWidth;
	//        }
	//        else
	//        {
	//            myJpg.Height = maxsize;
	//            myJpg.Width = myJpg.OriginalWidth * maxsize / myJpg.OriginalHeight;
	//        }

	//        newImageName = newFileName + ".jpg";
	//        myJpg.Save(pathL + newImageName);
	//        myJpg.Open(pathL + originalFileName);
	//        myJpg.Interpolation = 1;
	//        myJpg.Sharpen(1, 250);
	//        myJpg.Quality = 100;
	//        int L = 110;
	//        if (myJpg.OriginalWidth > myJpg.OriginalHeight)
	//        {
	//            myJpg.Width = L;
	//            myJpg.Height = myJpg.OriginalHeight * L / myJpg.OriginalWidth;
	//        }
	//        else
	//        {
	//            myJpg.Height = L;
	//            myJpg.Width = myJpg.OriginalWidth * L / myJpg.OriginalHeight;
	//        }

	//        myJpg.Save(pathT + newImageName);
	//        File.Delete(pathL + originalFileName);
	//        result = newImageName;
	//    }
	//    else
	//    {
	//        result = "none.png";
	//    }

	//    return result;
	//}
	//=============================================================================================================
}