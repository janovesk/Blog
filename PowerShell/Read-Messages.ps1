param([string]$qname,[string]$all)

if ( [System.String]::IsNullOrEmpty($qname) )
{
    write-host "You must provide a queue name"
    exit
}

[Reflection.Assembly]::LoadWithPartialName("System.Messaging") | out-null

$q = new-object System.Messaging.MessageQueue($qname)

$msgs = $q.GetAllMessages()

foreach ( $msg in $msgs )
{
    $msg.BodyStream.Position = 0
    $sr = new-object System.IO.StreamReader( $msg.BodyStream )
    $sr.ReadToEnd()
    
    if ( $all -ne "all" )
    {
        $input = read-host -prompt "Enter n for the next message, q to quit"
        
        if ( $input -eq "q" )
        {
            exit
        }
    }
}