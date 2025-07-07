# Load the Terminal icons module.
Import-Module -Name Terminal-Icons

# Load and configure the PowerShell history.
Import-Module -Name PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Start Oh My Posh.
oh-my-posh prompt init pwsh --config "$env:MY_ENV\ohmyposh.json" | Invoke-Expression

# Define some aliases for common tools and commands.
Set-Alias -Name he -Value helm
Set-Alias -Name d -Value docker
Set-Alias -Name k -Value kubectl
Set-Alias -Name g -Value git
Set-Alias -Name t -Value terraform
Set-Alias -Name vi -Value vim
Set-Alias -Name l -Value Get-ChildItem
Set-Alias -Name ll -Value Get-ChildItem
Set-Alias -Name kctx -Value kubectx
Set-Alias -Name kns -Value kubens
Set-Alias -Name ida -Value "$env:MY_TOOLBOX\ida\ida64.exe"
Set-Alias -Name die -Value "$env:MY_TOOLBOX\die\die.exe"
Set-Alias -Name pestudio -Value "$env:MY_TOOLBOX\pestudio\pestudio.exe"

# Use this function to create a debug pod using the Azure CLI image.
Function kdbgp {
    param(
        [string] $Node
    )

    if ($Node -ne "") {
        $NodeSelector = @{
            "spec" = @{
                "nodeSelector" = @{
                    "kubernetes.io/hostname" = $Node
                }
            }
        }
        
        $NodeSelectorString = $NodeSelector | ConvertTo-Json -Compress        
        kubectl run -i --tty --rm (New-Guid) --image=mcr.microsoft.com/azure-cli --overrides=$NodeSelectorString
    }
    else {
        kubectl run -i --tty --rm (New-Guid) --image=mcr.microsoft.com/azure-cli
    }
}

Function kdbgn {
    param(
        [string] $Node
    )

    if ($Node -eq "") {
        Write-Error "node name must be provided. Use kubectl get nodes to list them."
        return
    }

    kubectl debug node/$Node -it --image=mcr.microsoft.com/azure-cli    
}

# Use this function to clone a repository quickly.
Function gcl {
    param(
        [string] $Url
    )
    git clone $Url
}

# Return Git status.
Function gs {
    git status
}

# Use this function to apply a Kubernetes recipe to the current context.
Function kaf {
    param(
        [string] $File
    )
    k apply -f $File
}

# Get all pods in all namespaces or in the specified namespace.
Function kgp {
    param(
        [string] $Namespace = $null
    )

    if ($Namespace -eq $null) {
        k get pods -A
    }
    else {
        k get pods -n $Namespace
    }
}

# Use this function to get a deployment details
Function kgd {
    param(
        [string] $Deployment,
        [string] $Namespace = "default"
    )
    k get deployment -n $Namespace $Deployment
}


# Use this function to add, commit and push changes quickly.
Function gcoph {
    param(
        [string] $CommitMessage = "changes"
    )

    git add -A
    git commit -am $CommitMessage

    if ($LASTEXITCODE -eq 0) {
        git push
    }    
}

# Refresh Kubernetes credentials.
Function kcreds {
    param(
        [string] $ResourceGroup = "kubernetes",
        [string] $KubernetesCluster = "glzbcrt"
    )

    az aks get-credentials -g $ResourceGroup -n $KubernetesCluster --overwrite-existing
}

# Load Visual Studio 2022 environment.
Function vs {
    Import-Module "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"    
    Enter-VsDevShell -VsInstanceId 698d223e -Arch amd64 -HostArch amd64
}

# CTRL+B: open the current directory in Explorer.
Set-PSReadLineKeyHandler -Chord Ctrl+b -ScriptBlock {
    "explorer.exe $pwd" | Invoke-Expression
}

# CTRL+G: navigate to the projects directory.
Set-PSReadLineKeyHandler -Chord Ctrl+g -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("cd $env:DEV_ROOT\projects")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# Define my AI model providers environment variables reading directly from 1Password.
Function aienvs {
    $env:OPENAI_API_KEY = (op read "op://Private/My OpenAI Credentials/notesPlain")

    $env:AZURE_OPENAI_API_KEY = (op read "op://Private/My Azure OpenAI Credentials/apiKeyPlain")
    $env:AZURE_OPENAI_ENDPOINT = (op read "op://Private/My Azure OpenAI Credentials/endpointPlain")

    $env:ANTHROPIC_API_KEY = (op read "op://Private/My Anthropic Credentials/notesPlain")

    $env:HF_TOKEN = (op read "op://Private/My Hugging Face Credentials/notesPlain")
}

op completion powershell | Out-String | Invoke-Expression

# Create a Python virtual environment in the current directory using uv.
Function pvenv {
    uv venv
    .venv\Scripts\activate
}