######### MAIL NOTIFICATION #########

# TRUE - script with mail notification
# FALSE - script without mail notification

$isMail = $true

######### SMTP SERVER #########

$SMTP = 'SMTP_SERVER_ADDRESS'

######### SENDER'S INFORMATION #########

$from = "SENDER'S MAIL"
$pass = "SENDER'S PASSWORD"
$secPass = (ConvertTo-SecureString $pass -AsPlainText -Force) # Securing password to '*****'

######### RECIPIENT'S INFORMATION #########

$to = ("recipient's email or recipient emails")

######### MESSAGE PROPERTIES #########

$props = @{

    From = $from
    To = $to
    SmtpServer = $SMTP
    UseSSl = $true
    Credential = New-Object System.Management.Automation.PSCredential ($from, $secPass)
    Encoding = 'UTF8'
}

######## BACKUP ########

$backupTarget = "BACKUP SAVE LOCATION"

$out = (wbadmin start backup -backuptarget:$backupTarget -user:"USERNAME" -password:"PASSWORD" -include:c: -allcritical)
$outString = $out | out-string

$backupDate = Get-Date # Getting date of backup 

######### SCRIPT - BACKUP SUCCEEDED #########

if ($out -contains "The backup operation successfully completed.")
{
    if ($isMail)
    {
        $subject = "BACKUP SUCCEEDED"
        $body = "Windows Backup succeeded! -> $backupDate `n`n`n $outString"
        Send-MailMessage @props -Subject $subject -Body $body
        exit 0
    }
    else {exit 0} # EXIT IF USER DOESN'T WANT TO RECEIVE EMAIL NOTIFICATION (WITHOUT ERROR)
}

######### SCRIPT - BACKUP FAILED #########

else
{
    if ($isMail) 
    {
        $subject = "BACKUP FAILED"
        $body = "Windows backup failed! -> $backupDate `n`n`n $outString"
        Send-MailMessage @props -Subject $subject -Body $body
        exit 1
    }
    else {exit 1} # EXIT IF USER DOESN'T WANT TO RECEIVE EMAIL NOTIFICATION (WITH ERROR)
}


