# Добавляем email шаблон в [BaltBetM].[Emails].[EmailTemplates] для RestoreComAccount


$restoreComAccountTemplate = @'
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <!--[if gte mso 9]><xml>
    <o:OfficeDocumentSettings>
    <o:AllowPNG/>
    <o:PixelsPerInch>96</o:PixelsPerInch>
    </o:OfficeDocumentSettings>
    </xml><![endif]-->
    <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Восстановление пароля на сайте {regSite} </title>


    <style type="text/css" media="screen">
        /* Linked Styles */

        body {
            font-family: Arial, 'Times New Roman', sans-serif;
            padding: 0 !important;
            margin: 0 !important;
            display: block !important;
            background: #1e1e1e;
            -webkit-text-size-adjust: none;
        }

        a {
            color: #a88123;
            text-decoration: none;
        }

        p {
            padding: 0 !important;
            margin: 0 !important;
        }
    </style>
</head>

<body class="body" style="padding:0 !important; margin:0 !important; display:block !important; background-color: #ffffff; -webkit-text-size-adjust:none;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="transparent">
        <tr>
            <td align="center" valign="top">
                <!-- HEADER -->
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; min-width:100%; ">
                    <tbody>
                        <tr>
                            <td height="30" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">&nbsp;</td>
                        </tr>
                    </tbody>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">
                    <tbody>
                        <tr>
                            <td height="30" class="spacer" style="font-size:0pt; line-height:0pt; text-align:center; width:100%; min-width:100%">&nbsp;</td>
                        </tr>
                    </tbody>
                </table>
                <!-- END HEADER -->
                <!-- BODY -->
                <table width="600" border="0" cellspacing="0" cellpadding="0" class="mobile-shell" style="color: #585858;">
                    <tr>
                        <td bgcolor="#205ed0" style="padding-left: 25px; padding-right: 25px; padding-top: 25px; padding-bottom: 25px;" >

                            <table border="0" cellspacing="0" cellpadding="0" width="550">
                                <tr>
                                    <td style="text-align: center; color: #ffffff; font-size: 22px; font-family: Arial, 'Times New Roman', sans-serif;">
                                        Здравствуйте, {lastName} {firstName}!
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20"></td>
                                </tr>
                                <tr>
                                    <td style="color: #ffffff; font-size: 14px; font-family: Arial, 'Times New Roman', sans-serif; display: inline-block;">
                                        Кто-то, возможно Вы, запросил восстановление пароля на сайте <a style="color: #6ed7ff; text-decoration: underline;" href="http://{regsite}">http://{regSite}</a>.
                                    </td>
                                </tr>
                                <tr>
                                    <td height="5"></td>
                                </tr>
                                <tr>
                                    <td style="color: #ffffff; font-size: 14px; font-family: Arial, 'Times New Roman', sans-serif; display: inline-block;">
                                        IP-адрес, с которого сделан запрос: <b>{ip}</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="20"></td>
                                </tr>
                                <tr>
                                    <td style="color: #ffffff; font-size: 14px; font-family: Arial, 'Times New Roman', sans-serif; display: inline-block;">
                                        Для смены пароля Вам необходимо перейти по ссылке:
                                    </td>
                                </tr>
                                <tr>
                                    <td style="color: #ffffff; font-size: 14px; font-family: Arial, 'Times New Roman', sans-serif; display: inline-block;">
                                        <a style="color: #6ed7ff; text-decoration: underline;" href="{restoreUrl}">{restoreUrl}</a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#205ed0" style="color: #6ed7ff; padding-left:25px; font-size: 14px; font-family: Arial, 'Times New Roman', sans-serif;">
                            Свяжитесь с нами:
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#205ed0" style="color: #ffffff; padding-left:25px; font-size: 14px; font-family: Arial, 'Times New Roman', sans-serif;">
                            Email: 
                            <a href="mailto:report@sport26.com" style="color: #6ed7ff; font-size: 14px; font-family: Arial, 'Times New Roman', sans-serif;">report@sport26.com</a>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#205ed0" height="10"></td>
                    </tr>
                    <tr>
                        <td bgcolor="#53aeca" height="1"></td>
                    </tr>
                    <tr>
                        <td bgcolor="#205ed0" height="70">
                            <table>
                                <td>
                                    <img src="{cid:eighteen}" alt="Возраст" style="border: none; padding-left: 25px;" />
                                </td>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
'@

$query = "
UPDATE [BaltBetM].[Emails].[EmailTemplates] SET Body = '$($restoreComAccountTemplate -replace "'", "''")'
	    WHERE Name = 'RestoreComAccount'
"
Write-Host "[INFO] Add email template for RestoreComAccount"
Invoke-Sqlcmd -Verbose -ServerInstance $env:COMPUTERNAME -Query $query -ErrorAction continue