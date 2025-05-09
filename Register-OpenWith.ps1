<#
    .SYNOPSIS
    Register in the Windows Explorer context menu my most used tools to quickly access them.
#>

$programs = @(
    @{
        name  = "ida"
        path  = "$env:MY_TOOLBOX\ida9\ida.exe"
        types = @("exefile", "dllfile", "sysfile")
    }
    @{
        name  = "die"
        path  = "$env:MY_TOOLBOX\die\die.exe"
        types = @("exefile", "dllfile", "sysfile")
    }
    @{
        name  = "pe-bear"
        path  = "$env:MY_TOOLBOX\pebear\PE-bear.exe"
        types = @("exefile", "dllfile", "sysfile")
    }
    @{
        name  = "pestudio"
        path  = "$env:MY_TOOLBOX\pestudio\pestudio.exe"
        types = @("exefile", "dllfile", "sysfile")
    }          
    @{
        name  = "x64dbg"
        path  = "$env:MY_TOOLBOX\x64dbg\x64\x64dbg.exe"
        types = @("exefile")
    }        
    @{
        name  = "imhex"
        path  = "$env:MY_TOOLBOX\imhex\imhex.exe"
        types = @("*")
    }  
    # @{
    #     name  = "vscode"

    #     #  TODO: need to fix the path where VS Code is installed. Install for all users?
    #     path  = "C:\Users\glzbcrt\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    #     types = @("*", "Directory", "Directory\Background||%v")
    # }       
)

$programs | ForEach-Object {    
    $program = $_

    $program.types | ForEach-Object {
        $parameter = "%1"
        $id = $_

        if ($id.Contains("||")) {
            $parameter = $id.Split("||")[1]
            $id = $id.Split("||")[0]
        }

        $key = "Registry::HKEY_CLASSES_ROOT\$($id)\shell\$($program.name)"                

        New-Item -Path "$($key)\command" -Value "$($program.path) ""$($parameter)"" " -Force
        Set-ItemProperty -Path "$($key)" -Name "Icon" -Value "$($program.path)" -Force        
    }
}
