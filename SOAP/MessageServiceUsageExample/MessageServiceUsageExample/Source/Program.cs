using System;
using System.Security.Principal;
using MessageServiceUsageExample.MessageServiceReference;

namespace MessageServiceUsageExample
{
    class Program
    {
        static void Main(string[] args)
        {
            MessageServiceClient client = null;

            try
            {
                // Создание клиента сервиса
                client = new MessageServiceClient();

                // Настройки безопасности
                client.ClientCredentials.HttpDigest.ClientCredential.UserName = Properties.Settings.Default.Login;
                client.ClientCredentials.HttpDigest.ClientCredential.Password = Properties.Settings.Default.Password;
                client.ClientCredentials.HttpDigest.AllowedImpersonationLevel = TokenImpersonationLevel.Impersonation;

                // Получение идентификаторов сообщении за указанный период
                DateTime dateFrom = new DateTime(2015, 11, 15);
                DateTime dateTo = new DateTime(2015, 12, 01);
                #region Output
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine(String.Format("Получение идентификаторов сообщении за период с {0} по {1}:{2}", dateFrom.ToString("dd-MM-yyyy"), dateTo.ToString("dd-MM-yyyy"), Environment.NewLine));
                Console.ResetColor();
                #endregion
                int[] messageIds = client.GetMessageIds(dateFrom, dateTo);
                #region Output
                if (messageIds != null && messageIds.Length > 0)
                {
                    Console.ForegroundColor = ConsoleColor.DarkCyan;
                    foreach (int messageId in messageIds)
                    {
                        Console.WriteLine(messageId);
                    }
                    Console.ResetColor();

                    Console.WriteLine();
                }
                else
                {
                    Console.ForegroundColor = ConsoleColor.DarkCyan;
                    Console.WriteLine("Сообщений не найдено");
                    Console.ResetColor();
                }
                #endregion

                if (messageIds != null && messageIds.Length > 0)
                {
                    // Получение контента сообщения по его идентификатору
                    #region Output
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine(String.Format("Получение контента сообщения с идентификатором {0}:{1}", messageIds[0], Environment.NewLine));
                    Console.ResetColor();
                    #endregion
                    string messageContent = client.GetMessageContent(messageIds[0]);
                    #region Output
                    if (messageContent != null)
                    {
                        Console.ForegroundColor = ConsoleColor.DarkCyan;
                        Console.WriteLine(messageContent);
                        Console.ResetColor();

                        Console.WriteLine();
                    }
                    #endregion
                }
            }
            catch (Exception ex)
            {
                #region Output
                Console.WriteLine(String.Format("ERROR: {0}", ex.Message));
                #endregion
            }
            finally
            {
                if (client != null)
                {
                    // Закрытие соединения
                    client.Close();
                }

                Console.ReadKey();
            }
        }
    }
}