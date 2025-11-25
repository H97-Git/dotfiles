function api --description 'Run API with Hot Reload'
    set -x DOTNET_WATCH_RESTART_ON_RUDE_EDIT true
    set -x DOTNET_WATCH_SUPPRESS_LAUNCH_BROWSER 1
    cd /mnt/SSD/Source/IANOMO/Targeting/src/api/Targeting.API/
    dotnet watch run --no-restore
end
