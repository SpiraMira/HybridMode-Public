# The following table should help us track kCUIxxxVariant mods and their effects (or side-effects)

## CoreUIHybrid Version 1.4.3 : Support for 10.14.4 (18E226)

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | 60 EF | E0 EF | better Appstore sidebar and huds   | None | Used #5 |
| 2  | **MacLight** |  | 80 EF | E0 EF | better Appstore sidebar and huds   | None | Used #5 |
| 3  | **Ultralight** |  | A0 EF | E0 EF | better Appstore sidebar and huds   | None | Used #5 |
| 4  | **MacUltralight** |  | C0 EF | E0 EF | better Appstore sidebar and huds   | None | Used #5 |
| 5  | MacDark |  | E0 EF  | " | " | NA | None |
| 6  | MacMediumDark |  | 00 F0 | " | " | NA | None |
| 7  | MacUltradark |  | 20 F0 | " | " | NA | None |
| 8  | Titlebar |  | 40 F0 | " | " | NA | None |
| 9  | [Selection] |  | 60 F0 | 60 F0 | solid | solid light grey | Used #18 WindowBackground | None
| 10 | Header |  | 80 F0 | " | " | NA | None |
| 11 | MacMediumLight |  | A0 F0 | " | " | NA | None |
| 12 | **Menu** |  | C0 F0 | 40 F0 | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | E0 F0 | | " | " | NA | None |
| 14 | **Popover** |  | 00 F1 | 40 F0 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | 20 F1 | 40 F0 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | 40 F1 | 40 F0 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | 60 F1 | 40 F0 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 80 F1 | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | A0 F1 | D0 09 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | C0 F1 | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | [SpotlightBackground] |  | D0 F1 | D0 09 | vibrant | None | Used #8 |
| 22 | NotificationCenterBackground |  | F0 F1 | " | " | NA | None |
| 23 | **Sheet** |  | 20 F2 | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | 40 F2 | " | " | NA | None |
| 25 | FullScreenUI |  | 60 F2 | " | " | NA | None |
| 26 | **UnderPageBackground** |  | 80 F2 | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | A0 F2 | D0 09 | vibrant | **Unknown** | Used #8 |
| 28 | **MenuBarMenu** |  | C0 F2 | D0 09 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlsBackground |  | E0 F2 | " | " | NA | None |
| 30 | SystemBezel |  | 00 F3 | " | " | NA | None |
| 31 | LoginWndowControl |  | 20 F3 | " | " | NA | None |
| 32 | DesktopStack |  | 40 F3 | " | " | NA | None |

## CoreUIHybrid Version 1.4.1 and 1.4.2 : Support for 10.14.2 (18C54) and 10.14.3 (18D109): same as 1.4 (below) + Selection to F0 09 + SpotLight back to vibrant

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | F0 08 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 2  | **MacLight** |  | 10 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 3  | **Ultralight** |  | 30 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 4  | **MacUltralight** |  | 50 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 5  | MacDark |  | 70 09 | " | " | NA | None |
| 6  | MacMediumDark |  | 90 09 | " | " | NA | None |
| 7  | MacUltradark |  | B0 09 | " | " | NA | None |
| 8  | Titlebar |  | D0 09 | " | " | NA | None |
| 9  | [Selection] |  | F0 09 | F0 09 | solid | solid light grey | Used #18 WindowBackground |
| 10 | Header |  | 10 0A | " | " | NA | None |
| 11 | MacMediumLight |  | 30 0A | " | " | NA | None |
| 12 | **Menu** |  | 50 0A | D0 09 | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | 70 0A | | " | " | NA | None |
| 14 | **Popover** |  | 90 0A | D0 09 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | B0 0A | D0 09 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | D0 0A | D0 09 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | F0 0A | D0 09 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 10 0B | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 30 0B | D0 09 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 50 0B | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | [SpotlightBackground] |  | 70 0B | D0 09 | vibrant | None | Used #8 |
| 22 | NotificationCenterBackground |  | 90 0B | " | " | NA | None |
| 23 | **Sheet** |  | B0 0B | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | D0 0B | " | " | NA | None |
| 25 | FullScreenUI |  | F0 0B | " | " | NA | None |
| 26 | **UnderPageBackground** |  | 10 0C | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | 30 0C | D0 09 | vibrant | **Unknown** | Used #8 |
| 28 | **MenuBarMenu** |  | 50 0C | D0 09 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlsBackground |  | 70 0C | " | " | NA | None |
| 30 | SystemBezel |  | 90 0C | " | " | NA | None |
| 31 | LoginWndowControl |  | B0 0C | " | " | NA | None |
| 32 | DesktopStack |  | D0 0C | " | " | NA | None |

## CoreUIHybrid Version 1.4 : same as 1.3 (below)

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | F0 08 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 2  | **MacLight** |  | 10 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 3  | **Ultralight** |  | 30 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 4  | **MacUltralight** |  | 50 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 5  | MacDark |  | 70 09 | " | " | NA | None |
| 6  | MacMediumDark |  | 90 09 | " | " | NA | None |
| 7  | MacUltradark |  | B0 09 | " | " | NA | None |
| 8  | Titlebar |  | D0 09 | " | " | NA | None |
| 9  | **Selection** |  | F0 09 | 10 0B | solid | solid light grey | Used #18 WindowBackground |
| 10 | Header |  | 10 0A | " | " | NA | None |
| 11 | MacMediumLight |  | 30 0A | " | " | NA | None |
| 12 | **Menu** |  | 50 0A | D0 09 | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | 70 0A | | " | " | NA | None |
| 14 | **Popover** |  | 90 0A | D0 09 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | B0 0A | D0 09 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | D0 0A | D0 09 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | F0 0A | D0 09 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 10 0B | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 30 0B | D0 09 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 50 0B | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | **SpotlightBackground** |  | 70 0B | 50 0B | normal | normal | Used #20 ContentBackground |
| 22 | NotificationCenterBackground |  | 90 0B | " | " | NA | None |
| 23 | **Sheet** |  | B0 0B | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | D0 0B | " | " | NA | None |
| 25 | FullScreenUI |  | F0 0B | " | " | NA | None |
| 26 | **UnderPageBackground** |  | 10 0C | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | 30 0C | D0 09 | vibrant | **Unknown** | Used #8 |
| 28 | **MenuBarMenu** |  | 50 0C | D0 09 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlsBackground |  | 70 0C | " | " | NA | None |
| 30 | SystemBezel |  | 90 0C | " | " | NA | None |
| 31 | LoginWndowControl |  | B0 0C | " | " | NA | None |
| 32 | DesktopStack |  | D0 0C | " | " | NA | None |

## CoreUIHybrid Version 1.3 : + Universal binary support + revert #9 + Safari menu and menu bar (search) fixes + brightness huds + search in appstore

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | F0 08 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 2  | **MacLight** |  | 10 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 3  | **Ultralight** |  | 30 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 4  | **MacUltralight** |  | 50 09 | 70 09 | better Appstore sidebar and huds   | None | Used #5 |
| 5  | MacDark |  | 70 09 | " | " | NA | None |
| 6  | MacMediumDark |  | 90 09 | " | " | NA | None |
| 7  | MacUltradark |  | B0 09 | " | " | NA | None |
| 8  | Titlebar |  | D0 09 | " | " | NA | None |
| 9  | **Selection** |  | F0 09 | 10 0B | solid | solid light grey | Used #18 WindowBackground |
| 10 | Header |  | 10 0A | " | " | NA | None |
| 11 | MacMediumLight |  | 30 0A | " | " | NA | None |
| 12 | **Menu** |  | 50 0A | D0 09 | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | 70 0A | | " | " | NA | None |
| 14 | **Popover** |  | 90 0A | D0 09 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | B0 0A | D0 09 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | D0 0A | D0 09 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | F0 0A | D0 09 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 10 0B | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 30 0B | D0 09 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 50 0B | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | **SpotlightBackground** |  | 70 0B | 50 0B | normal | normal | Used #20 ContentBackground |
| 22 | NotificationCenterBackground |  | 90 0B | " | " | NA | None |
| 23 | **Sheet** |  | B0 0B | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | D0 0B | " | " | NA | None |
| 25 | FullScreenUI |  | F0 0B | " | " | NA | None |
| 26 | **UnderPageBackground** |  | 10 0C | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | 30 0C | D0 09 | vibrant | **Unknown** | Used #8 |
| 28 | **MenuBarMenu** |  | 50 0C | D0 09 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlsBackground |  | 70 0C | " | " | NA | None |
| 30 | SystemBezel |  | 90 0C | " | " | NA | None |
| 31 | LoginWndowControl |  | B0 0C | " | " | NA | None |
| 32 | DesktopStack |  | D0 0C | " | " | NA | None |

## CoreUIHybrid Version 1.2 : + Universal binary support

## CoreUIHybrid Version 1.0 : + Better Spotlight + Better Selection +Sheet + Revert WindowBackground + Revert Bezel

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | Light |  | F0 08 | " | " | NA | None |
| 2  | MacLight |  | 10 09 | " | " | NA | None |
| 3  | Ultralight |  | 30 09 | " | " | NA | None |
| 4  | MacUltralight |  | 50 09 | " | " | NA | None |
| 5  | MacDark |  | 70 09 | " | " | NA | None |
| 6  | MacMediumDark |  | 90 09 | " | " | NA | None |
| 7  | MacUltradark |  | B0 09 | " | " | NA | None |
| 8  | Titlebar |  | D0 09 | " | " | NA | None |
| 9  | **Selection** |  | F0 09 | 10 0B | solid | solid light grey | Used #18 WindowBackground |
| 10 | Header |  | 10 0A | " | " | NA | None |
| 11 | MacMediumLight |  | 30 0A | " | " | NA | None |
| 12 | Menu |  | 50 0A | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 13 | MenuBar |  | 70 0A | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 14 | **Popover** |  | 90 0A | D0 09 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | B0 0A | D0 09 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | D0 0A | D0 09 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | F0 0A | D0 09 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 10 0B | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 30 0B | D0 09 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 50 0B | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | **SpotlightBackground** |  | 70 0B | 50 0B | normal | normal | Used #20 ContentBackground |
| 22 | NotificationCenterBackground |  | 90 0B | " | " | NA | None |
| 23 | **Sheet** |  | B0 0B | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | D0 0B | " | " | NA | None |
| 25 | FullScreenUI |  | F0 0B | " | " | NA | None |
| 26 | **UnderPageBackground** |  | 10 0C | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | 30 0C | D0 09 | vibrant | **Unknown** | Used #8 |
| 28 | **MenuBarMenu** |  | 50 0C | D0 09 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlBackground |  | 70 0C | " | " | NA | None |
| 30 | SystemBezel |  | 90 0C | " | " | NA | None |
| 31 | LoginWndowControl |  | B0 0C | " | " | NA | None |
| 32 | DesktopStack |  | D0 0C | " | " | NA | None |

## CoreUIHybrid Version 0.3 : + Menu bar search + More ToolTip + Popovers and Popover Labels

| index| variant | Description | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | Light |  | F0 08 | " | " | NA | None |
| 2  | MacLight |  | 10 09 | " | " | NA | None |
| 3  | Ultralight |  | 30 09 | " | " | NA | None |
| 4  | MacUltralight |  | 50 09 | " | " | NA | None |
| 5  | MacDark |  | 70 09 | " | " | NA | None |
| 6  | MacMediumDark |  | 90 09 | " | " | NA | None |
| 7  | MacUltradark |  | B0 09 | " | " | NA | None |
| 8  | Titlebar |  | D0 09 | " | " | NA | None |
| 9  | Selection |  | F0 09 | " | " | NA | None |
| 10 | Header |  | 10 0A | " | " | NA | None |
| 11 | MacMediumLight |  | 30 0A | " | " | NA | None |
| 12 | **Menu** |  | 50 0A | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 13 | **MenuBar** |  | 70 0A | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 14 | **Popover** |  | 90 0A | D0 09 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | B0 0A | D0 09 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | D0 0A | D0 09 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | F0 0A | D0 09 | vibrant | None | Used #8 |
| 18 | **WindowBackground** |  | 10 0B | D0 09 | enhances sidebar backgrounds  | None | Used #8 **needs more investigation** |
| 19 | **UnderWindowBackground** |  | 30 0B | D0 09 | fixes sidebar backgrounds  | None | Used #8 **needs more investigation** |
| 20 | ContentBackground |  | 50 0B | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | **SpotlightBackground** |  | 70 0B | D0 09 | vibrant | altered - not pretty | **Needs work** but spotlight may not need to be vibrant! |
| 22 | NotificationCenterBackground |  | 90 0B | " | " | NA | None |
| 23 | Sheet |  | B0 0B | " | " | NA | None |
| 24 | HUDWindow |  | D0 0B | " | " | NA | None |
| 25 | FullScreenUI |  | F0 0B | " | " | NA | None |
| 26 | **UnderPageBackground** |  | 10 0C | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | 30 0C | D0 09 | vibrant | **Unknown** | Used #8 |
| 28 | **MenuBarMenu** |  | 50 0C | D0 09 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlBackground |  | 70 0C | " | " | NA | None |
| 30 | **SystemBezel** |  | 90 0C | D0 09 | **Unknown** | **Unknown** | Used #8 |
| 31 | LoginWndowControl |  | B0 0C | " | " | NA | None |
| 32 | DesktopStack |  | D0 0C | " | " | NA | None |



## CoreUIHybrid Version 0.2 : + ToolTip + AppStore sidebar fixed

| variant | Description | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Light |  | F0 08 | " | " | NA | None |
| MacLight |  | 10 09 | " | " | NA | None |
| Ultralight |  | 30 09 | " | " | NA | None |
| MacUltralight |  | 50 09 | " | " | NA | None |
| MacDark |  | 70 09 | " | " | NA | None |
| MacMediumDark |  | 90 09 | " | " | NA | None |
| MacUltradark |  | B0 09 | " | " | NA | None |
| Titlebar |  | D0 09 | " | " | NA | None |
| Selection |  | F0 09 | " | " | NA | None |
| Header |  | 10 0A | " | " | NA | None |
| MacMediumLight |  | 30 0A | " | " | NA | None |
| Menu |  | 50 0A | " | " | NA | None |
| MenuBar |  | 70 0A | " | " | NA | None |
| Popover |  | 90 0A | " | " | NA | None |
| PopoverLabel |  | B0 0A | " | " | NA | None |
| ToolTp |  | D0 0A | D0 09 | Title Bar Swap - vibrant tooltips | None |
| Sidebar |  | F0 0A | D0 09 | Title Bar Swap - vibrant sidebar | None |
| WindowBackground |  | 10 0B | D0 09 | Title Bar Swap - sidebar rows | None |
| UnderWindowBackground |  | 30 0B | D0 09 | Title Bar Swap - sidebar rows - sidebar backgrounds | Seems to fix AppStore sidebar background |
| ContentBackground |  | 50 0B | " | " | NA | None |
| SpotlightBackground |  | 70 0B | D0 09 | Title Bar Swap - vibrant spotlight background | None |
| NotificationCenterBackground |  | 90 0B | " | " | NA | None |
| Sheet |  | B0 0B | " | " | NA | None |
| HUDWindow |  | D0 0B | " | " | NA | None |
| FullScreenUI |  | F0 0B | " | " | NA | None |
| UnderPageBackground |  | 10 0C | " | " | NA | None |
| InlineSidebar |  | 30 0C | D0 09 | Title Bar Swap - vibrant sidebar | None |
| MenuBarMenu |  | 50 0C | " | " | NA | None |
| HUDControlBackground |  | 70 0C | " | " | NA | None |
| SystemBezel |  | 90 0C | " | " | NA | None |
| LoginWndowControl |  | B0 0C | " | " | NA | None |
| DesktopStack |  | D0 0C | " | " | NA | None |


## CoreUIHybrid Version 0.1 : Sidebar and Spotlight

| variant | Description | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| Light |  | F0 08 | " | " | NA | None |
| MacLight |  | 10 09 | " | " | NA | None |
| Ultralight |  | 30 09 | " | " | NA | None |
| MacUltralight |  | 50 09 | " | " | NA | None |
| MacDark |  | 70 09 | " | " | NA | None |
| MacMediumDark |  | 90 09 | " | " | NA | None |
| MacUltradark |  | B0 09 | " | " | NA | None |
| Titlebar |  | D0 09 | " | " | NA | None |
| Selection |  | F0 09 | " | " | NA | None |
| Header |  | 10 0A | " | " | NA | None |
| MacMediumLight |  | 30 0A | " | " | NA | None |
| Menu |  | 50 0A | " | " | NA | None |
| MenuBar |  | 70 0A | " | " | NA | None |
| Popover |  | 90 0A | " | " | NA | None |
| PopoverLabel |  | B0 0A | " | " | NA | None |
| ToolTp |  | D0 0A | " | " | NA | None |
| Sidebar |  | F0 0A | D0 09 | Title Bar Swap - vibrant sidebar | None |
| WindowBackground |  | 10 0B | " | " | NA | None |
| UnderWindowBackground |  | 30 0B | " | " | NA | None |
| ContentBackground |  | 50 0B | " | " | NA | None |
| SpotlightBackground |  | 70 0B | D0 09 | Title Bar Swap - vibrant spotlight background | None |
| NotificationCenterBackground |  | 90 0B | " | " | NA | None |
| Sheet |  | B0 0B | " | " | NA | None |
| HUDWindow |  | D0 0B | " | " | NA | None |
| FullScreenUI |  | F0 0B | " | " | NA | None |
| UnderPageBackground |  | 10 0C | " | " | NA | None |
| InlineSidebar |  | 30 0C | D0 09 | Title Bar Swap - vibrant sidebar | None |
| MenuBarMenu |  | 50 0C | " | " | NA | None |
| HUDControlBackground |  | 70 0C | " | " | NA | None |
| SystemBezel |  | 90 0C | " | " | NA | None |
| LoginWndowControl |  | B0 0C | " | " | NA | None |
| DesktopStack |  | D0 0C | " | " | NA | None |


