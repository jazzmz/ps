using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using AngaraNkoTest.AngaraNkoService;
using System.ServiceModel;
using System.Collections.Generic;

namespace AngaraNkoTest {

  [TestClass]
  public class AngaraNko_TerroristTest {

    /// <summary>
    /// Действующий Перечень
    /// </summary>
    [TestMethod]
    public void GetCurrentTerroristCatalogTest() {

      TerroristInfoServiceClient client = new TerroristInfoServiceClient();
      client.ClientCredentials.UserName.UserName = "login";
      client.ClientCredentials.UserName.Password = "password";
      System.Net.ServicePointManager.ServerCertificateValidationCallback += (se, cert, chain, sslerror) => {
        return true;
      };

      TerroristCatalog catalog = client.GetCurrentTerroristCatalog();
      client.Close();

      Assert.IsTrue(catalog.IdTerroristCatalog > 0);
      Assert.IsTrue(!string.IsNullOrEmpty(catalog.TerroristCatalogNumber));
      Assert.IsTrue(catalog.IsActive);
    }


    /// <summary>
    /// Список Перечней
    /// </summary>
    [TestMethod]
    public void GetTerroristCatalogsTest() {

      TerroristInfoServiceClient client = new TerroristInfoServiceClient();
      client.ClientCredentials.UserName.UserName = "login";
      client.ClientCredentials.UserName.Password = "password";
      System.Net.ServicePointManager.ServerCertificateValidationCallback += (se, cert, chain, sslerror) => {
        return true;
      };

      TerroristCatalogPage page = client.GetTerroristCatalogs(1);
      client.Close();

      Assert.IsTrue(page.TerroristCatalogs.Count > 0);
      Assert.IsTrue(page.PageIndex > 0);
      Assert.IsTrue(page.PageSize > 0);
      Assert.IsTrue(page.PagesTotal > 0);
      Assert.IsTrue(page.RecordsTotal > 0);
    }

	
	/// <summary>
    /// Получение файла Перечня
    /// </summary>
    [TestMethod]
    public void GetPortalFileTest() {
      TerroristInfoServiceClient client = new TerroristInfoServiceClient();
      client.ClientCredentials.UserName.UserName = "login";
      client.ClientCredentials.UserName.Password = "password";
      System.Net.ServicePointManager.ServerCertificateValidationCallback += (se, cert, chain, sslerror) => {
        return true;
      };
      
	  // Текущий Перечень
      TerroristCatalog catalog = client.GetCurrentTerroristCatalog();
	  
	  // Файл Перечня, о его идентификатору. В настоящее время доступны:
	  //   IdXml - идентификатор XML файла с Перечнем
	  //   IdDbf - идентификатор DBF файла с Перечнем
	  //   IdDoc - идентификатор MS Word файла с Перечнем
      PortalFile file = client.GetFile(catalog.IdXml.Value);
      client.Close();

      Assert.IsTrue(file.FileData.Length > 0);
      Assert.IsTrue(!string.IsNullOrEmpty(file.FileName));
    }
  }

}
