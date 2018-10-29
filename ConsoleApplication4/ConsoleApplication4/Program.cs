
using System;
using System.Security.Cryptography;
using System.Security.Cryptography.Xml;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Xml;

//using CryptoPro.Sharpei;
//using CryptoPro.Sharpei.Xml;

namespace Samples.Xml
{
    class SignDocument
    {
        [STAThread]
        static void Main()
        {
            string subj = "ddorkin@mail.ru";
            string xmlpath = "C:\\test\\xmlcrypto";
            string doctosign = xmlpath + "\\post1.xml";
            string docsigned = xmlpath + "\\signed1.xml";

            // Ищем сертификат для подписи.
            X509Store store = new X509Store("My", StoreLocation.CurrentUser);
            store.Open(OpenFlags.OpenExistingOnly | OpenFlags.ReadOnly);
            X509Certificate2Collection found = store.Certificates.Find(X509FindType.FindBySubjectName, subj, false);

            // Проверяем, что нашли ровно один сертификат.
            if (found.Count == 0)
            {
                Console.WriteLine("Сертификат не найден.");
                Console.ReadLine();
                return;
            }
            if (found.Count > 1)
            {
                Console.WriteLine("Найдено больше одного сертификата.");
                Console.ReadLine();
                return;
            }
            if (found.Count == 1)
            {
                Console.WriteLine("Сертификат обнаружен");
                Console.ReadLine();
            }
            X509Certificate2 Certificate = found[0];


            // Открываем ключ подписи.
            AsymmetricAlgorithm Key = Certificate.PrivateKey;
            // Подписываем файл и сохраняем его в другом файле.
            SignXmlFile(doctosign, docsigned, Key, Certificate);
            Console.WriteLine("XML подписан.");

            // Проверяем подпись под файлом.
            bool ret = VerifyXmlFile(docsigned);
            if (ret)
                Console.WriteLine("Подпись верна.");
            else
                Console.WriteLine("Подпись не верна.");
            
            Console.ReadKey();
        }

        // Подписываем XML файл и сохраняем его в новом файле.
        static void SignXmlFile(string FileName,
            string SignedFileName, AsymmetricAlgorithm Key,
            X509Certificate Certificate)
        {
            // Создаем новый XML документ.
            XmlDocument doc = new XmlDocument();

            // Форматируем документ с игнорированием пробельных символов.
            doc.PreserveWhitespace = false;

            // Читаем документ из файла.
            doc.Load(new XmlTextReader(FileName));

            // Создаем объект SignedXml по XML документу.
            SignedXml signedXml = new SignedXml(doc);

            // Добавляем ключ в SignedXml документ. 
            signedXml.SigningKey = Key;

            // Создаем ссылку на node для подписи.
            // При подписи всего документа проставляем "".
            Reference reference = new Reference();
            reference.Uri = "";

            // Явно проставляем алгоритм хеширования,
            // по умолчанию SHA1.
            reference.DigestMethod = "http://www.w3.org/2001/04/xmlenc#sha256";
//                CPSignedXml.XmlDsigGost3411Url;

            // Добавляем transform на подписываемые данные
            // для удаления вложенной подписи.
            XmlDsigEnvelopedSignatureTransform env =
                new XmlDsigEnvelopedSignatureTransform();
            reference.AddTransform(env);

            // Добавляем transform для канонизации.
            XmlDsigC14NTransform c14 = new XmlDsigC14NTransform();
            reference.AddTransform(c14);

            // Добавляем ссылку на подписываемые данные
            signedXml.AddReference(reference);

            // Создаем объект KeyInfo.
            KeyInfo keyInfo = new KeyInfo();

            // Добавляем сертификат в KeyInfo
            keyInfo.AddClause(new KeyInfoX509Data(Certificate));

            // Добавляем KeyInfo в SignedXml.
            signedXml.KeyInfo = keyInfo;

            // Можно явно проставить алгоритм подписи: ГОСТ Р 34.10.
            // Если сертификат ключа подписи ГОСТ Р 34.10
            // и алгоритм ключа подписи не задан, то будет использован
            // XmlDsigGost3410Url
            // signedXml.SignedInfo.SignatureMethod =
            //     CPSignedXml.XmlDsigGost3410Url;

            // Вычисляем подпись.
            signedXml.ComputeSignature();

            // Получаем XML представление подписи и сохраняем его 
            // в отдельном node.
            XmlElement xmlDigitalSignature = signedXml.GetXml();

            // Добавляем node подписи в XML документ.
            doc.DocumentElement.AppendChild(doc.ImportNode(
                xmlDigitalSignature, true));

            // При наличии стартовой XML декларации ее удаляем
            // (во избежание повторного сохранения)
            if (doc.FirstChild is XmlDeclaration)
            {
                doc.RemoveChild(doc.FirstChild);
            }

            // Сохраняем подписанный документ в файле.
            using (XmlTextWriter xmltw = new XmlTextWriter(SignedFileName,
                new UTF8Encoding(false)))
            {
                xmltw.WriteStartDocument();
                doc.WriteTo(xmltw);
            }
        }

        // Проверка подписи под XML документом.
        static Boolean VerifyXmlFile(String Name)
        {
            // Создаем новый XML документ в памяти.
            XmlDocument xmlDocument = new XmlDocument();

            // Сохраняем все пробельные символы, они важны при проверке 
            // подписи.
            xmlDocument.PreserveWhitespace = true;

            // Загружаем подписанный документ из файла.
            xmlDocument.Load(Name);

            // Создаем объект SignedXml для проверки подписи документа.
            SignedXml signedXml = new SignedXml(xmlDocument);

            // Ищем все node "Signature" и сохраняем их в объекте XmlNodeList
            XmlNodeList nodeList = xmlDocument.GetElementsByTagName(
                "Signature", SignedXml.XmlDsigNamespaceUrl);

            // Загружаем первую подпись в SignedXml
            signedXml.LoadXml((XmlElement)nodeList[0]);

            // Проверяем подпись.
            return signedXml.CheckSignature();

        }
    }
}
