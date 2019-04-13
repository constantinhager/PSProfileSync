function Initialize-PSPAuthentication
{
    [CmdletBinding()]
    param
    (
        # the github username
        [Parameter(Mandatory)]
        [string]
        $UserName,

        # the PATToken of the user
        [Parameter(Mandatory)]
        [string]
        $PATToken
    )

    # Get the configvalue for the path of the Git Authfile
    $PathAuthFile = Get-PSFConfigValue -FullName "psprofilesync.git.profilegitauthfilepath"

    # If GitAuthFile exists import It
    # If not we have to check if gist exists.
    # If thats the case we get the gist id and create a new authfile.
    # If not we have to create a new gist get the gistid and create a new authfile.
    if (Test-PSPForGitAuthFile -PathAuthFile $PathAuthFile)
    {
        $retval = Import-PSPGitAuthFile
    }
    else
    {
        # Get the GistDescription
        $GistDescription = Get-PSFConfigValue -FullName "PSProfileSync.git.gistdescription"

        # Test if gist already exist
        $Uri = ("https://api.github.com/users/{0}/gists" -f $UserName)
        $AllUserGists = Invoke-PSPGitHubApiGET -Uri $Uri -Method "GET" -PATToken $PATToken -UserName $UserName

        $GistId = Search-PSPGitHubGist -AllUserGists $AllUserGists -GistDescription $GistDescription
        if ($null -eq $GistId)
        {
            $GistId = New-PSPGitHubGist -UserName $UserName -PATToken $PATToken -GistDescription $GistDescription
            New-PSPGitAuthFile -GistId $GistId -PATToken $PATToken -UserName $UserName
        }
        else
        {
            New-PSPGitAuthFile -GistId $GistId -PATToken $PATToken -UserName $UserName
        }
    }
}