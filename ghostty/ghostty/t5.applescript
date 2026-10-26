on run argv
  set default_directory to item 1 of argv

  tell application "Ghostty"
    if (count of windows) is 0 then return

    set frontend_config to new surface configuration
    set initial working directory of frontend_config to "/Users/shiloh.lee/appierwork/phoenix-frontend"

    set backend_config to new surface configuration
    set initial working directory of backend_config to "/Users/shiloh.lee/appierwork/phoenix-backend-all-in-one"

    set pbe2_config to new surface configuration
    set initial working directory of pbe2_config to "/Users/shiloh.lee/appierwork/pbe2"

    set default_config to new surface configuration
    set initial working directory of default_config to default_directory

    set prometheus_config to new surface configuration
    set initial working directory of prometheus_config to "/Users/shiloh.lee/workspace/prometheus"

    set target_window to front window
    set first_tab to selected tab of target_window
    set first_terminal to focused terminal of first_tab

    split first_terminal direction right with configuration frontend_config

    set backend_tab to new tab in target_window with configuration backend_config
    set backend_terminal to focused terminal of backend_tab
    split backend_terminal direction right with configuration backend_config

    set pbe2_tab to new tab in target_window with configuration pbe2_config
    set pbe2_terminal to focused terminal of pbe2_tab
    split pbe2_terminal direction right with configuration pbe2_config

    set rss_tab to new tab in target_window with configuration default_config
    set rss_terminal to focused terminal of rss_tab
    split rss_terminal direction right with configuration default_config

    set other_tab to new tab in target_window with configuration default_config
    set other_terminal to focused terminal of other_tab
    split other_terminal direction right with configuration default_config

    set prometheus_tab to new tab in target_window with configuration prometheus_config
    set prometheus_terminal to focused terminal of prometheus_tab
    split prometheus_terminal direction right with configuration prometheus_config

    select tab first_tab
  end tell
end run
