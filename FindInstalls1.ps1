# Define o proxy padrão para a sessão atual do .NET no PowerShell
#[System.Net.Http.HttpClient]::DefaultProxy = [System.Net.WebProxy]::GetDefaultProxy()
#[System.Net.Http.HttpClient]::DefaultProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

# Configura o Proxy para o PowerShell 5.1
[System.Net.WebRequest]::DefaultWebProxy = [System.Net.WebProxy]::GetDefaultProxy()
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

$proxyUrl = "http://seu-proxy:8080" # Substitua pelo seu proxy real

#$vscodeRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/vscode/releases/latest" `
#                                   -Proxy $proxyUrl `
#                                   -ProxyUseDefaultCredentials





# 1. Get LATEST versions from official APIs
# VS Code: Usando a API do GitHub (mais estável que o site da Microsoft)
$vscodeRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/vscode/releases/latest"
$latestVSCode = $vscodeRelease.tag_name # Retorna o número da versão puro

# WinSCP: Usando o endpoint de "melhor release" do SourceForge
# 1. Baixa o conteúdo da página como texto (não como objeto JSON)
$winScpPage = Invoke-WebRequest -Uri "https://winscp.net/eng/download.php" -UseBasicParsing

# 2. Procura pelo link do instalador e extrai a versão usando Regex
if ($winScpPage.Content -match "WinSCP-([\d\.]+)-Setup\.exe") {
    $latestWinSCP = $Matches[1]
}

# Wireshark: Buscando diretamente do arquivo de versão estável
$wiresharkData = Invoke-WebRequest "https://www.wireshark.org/download.html" -UseBasicParsing
$latestWireshark = ($wiresharkData.Links | Where-Object href -match "Wireshark-([\d\.]+)-x64.exe" | Select-Object -First 1).href -replace ".*Wireshark-", "" -replace "-x64.exe", ""

# 2. Get INSTALLED versions
$installed = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, 
                          HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,
                          HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
             Select-Object DisplayName, DisplayVersion

$currentVSCode    = ($installed | Where-Object { $_.DisplayName -like "*Visual Studio Code*" }).DisplayVersion
$currentWinSCP    = ($installed | Where-Object { $_.DisplayName -like "*WinSCP*" }).DisplayVersion
$currentWireshark = ($installed | Where-Object { $_.DisplayName -like "*Wireshark*" }).DisplayVersion

# 3. Compare and Output
$Results = @()
$Apps = @(
    @{ Name="VS Code"; Latest=$latestVSCode; Current=$currentVSCode },
    @{ Name="WinSCP";  Latest=$latestWinSCP;  Current=$currentWinSCP },
    @{ Name="Wireshark"; Latest=$latestWireshark; Current=$currentWireshark }
)

foreach ($App in $Apps) {
    # IMPORTANTE: Cast para [version] garante que 1.100 seja maior que 1.99
    $Status = if (!$App.Current) { "Not Installed" } 
              elseif (!$App.Latest) { "Version Check Failed" }
              elseif ([version]$App.Latest -gt [version]$App.Current) { "UPDATE AVAILABLE" } 
              else { "Up to Date" }
    
    $Results += [PSCustomObject]@{
        Software  = $App.Name
        Installed = $App.Current
        Latest    = $App.Latest
        Status    = $Status
    }
}

$Results | Format-Table -AutoSize
