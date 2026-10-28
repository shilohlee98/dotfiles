---@diagnostic disable: undefined-global

-- Tabs
rex.bind("alt+1", "client.tab.goto", { index = 1 })
rex.bind("alt+2", "client.tab.goto", { index = 2 })
rex.bind("alt+3", "client.tab.goto", { index = 3 })
rex.bind("alt+4", "client.tab.goto", { index = 4 })
rex.bind("alt+5", "client.tab.goto", { index = 5 })
rex.bind("alt+6", "client.tab.goto", { index = 6 })
rex.bind("alt+7", "client.tab.goto", { index = 7 })
rex.bind("alt+8", "client.tab.goto", { index = 8 })
rex.bind("alt+9", "client.tab.goto", { index = 9 })

-- Pane layout
rex.bind("ctrl+b>space", "toggle_main_pane_layout")

-- Pane focus
rex.bind("alt+h", "pane.focus", { direction = "left" })
rex.bind("alt+l", "pane.focus", { direction = "right" })
rex.bind("alt+k", "pane.focus", { direction = "up" })
rex.bind("alt+j", "pane.focus", { direction = "down" })

-- Pane resize
rex.bind("shift+left", "pane.resize", { direction = "left", amount = 1 })
rex.bind("shift+right", "pane.resize", { direction = "right", amount = 1 })
rex.bind("shift+up", "pane.resize", { direction = "up", amount = 1 })
rex.bind("shift+down", "pane.resize", { direction = "down", amount = 1 })

-- Terminal input
-- Forward Option-T as an Alt key chord instead of inserting the macOS "†" character.
rex.bind("alt+t", "pane.send_key", { key = "alt+t" })
