# 32 BIT - The following table should help us track kCUIxxxVariant mods and their effects (or side-effects)

## CoreUIHybrid Version 1.4.4 : Support for 10.14.4 (18E226)

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | 78 4F | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 2  | **MacLight** |  | 88 4F  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 3  | **Ultralight** |  | 98 4F  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 4  | **MacUltralight** |  | A8 4F  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 5  | MacDark |  | B8 4F  | " | " | NA | None |
| 6  | MacMediumDark |  | C8 4F  | " | " | NA | None |
| 7  | MacUltradark |  | D8 4F  | " | " | NA | None |
| 8  | Titlebar |  | E8 4F  | " | " | NA | None |
| 9  | [Selection] |  | F8 4F  | F8 4F | NA | NA  | None |
| 10 | Header |  | 08 50  | " | " | NA | None |
| 11 | MacMediumLight |  | 18 50 | " | " | NA | None |

| 12 | **Menu** |  | 28 50 | E8 4F | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | 38 50 | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 14 | **Popover** |  | 48 50 | E8 4F | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | 58 50 | E8 4F | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | 68 50 | E8 4F | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | 78 50 | E8 4F | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 88 50 | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 98 50 | E8 4F | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | A8 50 | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | [SpotlightBackground] |  | B8 50 | E8 4F | normal | None | Used #8 |
| 22 | NotificationCenterBackground |  | C8 50 | " | " | NA | None |
| 23 | **Sheet** |  | D8 50 | E8 4F | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | E8 50 | " | " | NA | None |
| 25 | FullScreenUI |  | F8 50 | " | " | NA | None |
| 26 | **UnderPageBackground** |  | 08 51 | E8 4F | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | 18 51 | E8 4F4 | vibrant | **Unknown** | Used #8 |

| 28 | **MenuBarMenu** |  | 28 51 | E8 4F | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlBackground |  | 38 51 | " | " | NA | None |
| 30 | SystemBezel |  | 48 51 | " | " | NA | None |
| 31 | LoginWndowControl |  | 58 51 | " | " | NA | None |
| 32 | DesktopStack |  | 68 51 | " | " | NA | None |


## CoreUIHybrid Version 1.4.1 : Fixed 1.4 regressions

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | 58 64 | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 2  | **MacLight** |  | 68 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 3  | **Ultralight** |  | 78 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 4  | **MacUltralight** |  | 88 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 5  | MacDark |  | 98 64  | " | " | NA | None |
| 6  | MacMediumDark |  | A8 64  | " | " | NA | None |
| 7  | MacUltradark |  | B8 64  | " | " | NA | None |
| 8  | Titlebar |  | C8 64  | " | " | NA | None |
| 9  | [Selection] |  | D8 64  | D8 64 | NA | NA  | None |
| 10 | Header |  | E8 64  | " | " | NA | None |
| 11 | MacMediumLight |  | F8 64 | " | " | NA | None |

| 12 | **Menu** |  | 08 65 | C8 64 | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | 18 65 | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 14 | **Popover** |  | 28 65 | C8 64 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | 38 65 | C8 64 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | 48 65 | C8 64 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | 58 65 | C8 64 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 68 65 | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 78 65 | C8 64 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 88 65 | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | [SpotlightBackground] |  | 98 65 | C8 64 | normal | None | Used #8 |
| 22 | NotificationCenterBackground |  | A8 65 | " | " | NA | None |
| 23 | **Sheet** |  | B8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | C8 65 | " | " | NA | None |
| 25 | FullScreenUI |  | D8 65 | " | " | NA | None |
| 26 | **UnderPageBackground** |  | E8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | F8 65 | C8 64 | vibrant | **Unknown** | Used #8 |

| 28 | **MenuBarMenu** |  | 08 66 | C8 64 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlBackground |  | 18 66 | " | " | NA | None |
| 30 | SystemBezel |  | 28 66 | " | " | NA | None |
| 31 | LoginWndowControl |  | 38 66 | " | " | NA | None |
| 32 | DesktopStack |  | 48 66 | " | " | NA | None |

## CoreUIHybrid Version 1.4 : Same as 1.3 but supports 10.14.2

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | 58 64 | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 2  | **MacLight** |  | 68 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 3  | **Ultralight** |  | 78 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 4  | **MacUltralight** |  | 88 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 5  | MacDark |  | 98 64  | " | " | NA | None |
| 6  | MacMediumDark |  | A8 64  | " | " | NA | None |
| 7  | MacUltradark |  | B8 64  | " | " | NA | None |
| 8  | Titlebar |  | C8 64  | " | " | NA | None |
| 9  | **Selection** |  | D8 64  | 68 65 | solid | solid light grey | Used #18 WindowBackground |
| 10 | Header |  | E8 64  | " | " | NA | None |
| 11 | MacMediumLight |  | F8 64 | " | " | NA | None |

| 12 | **Menu** |  | 08 65 | C8 64 | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | 18 65 | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 14 | **Popover** |  | 28 65 | C8 64 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | 38 65 | C8 64 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | 48 65 | C8 64 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | 58 65 | C8 64 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 68 65 | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 78 65 | C8 64 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 88 65 | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | **SpotlightBackground** |  | 98 65 | 88 65 | normal | normal | Used #20 ContentBackground |
| 22 | NotificationCenterBackground |  | A8 65 | " | " | NA | None |
| 23 | **Sheet** |  | B8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | C8 65 | " | " | NA | None |
| 25 | FullScreenUI |  | D8 65 | " | " | NA | None |
| 26 | **UnderPageBackground** |  | E8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | F8 65 | C8 64 | vibrant | **Unknown** | Used #8 |

| 28 | **MenuBarMenu** |  | 08 66 | C8 64 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlBackground |  | 18 66 | " | " | NA | None |
| 30 | SystemBezel |  | 28 66 | " | " | NA | None |
| 31 | LoginWndowControl |  | 38 66 | " | " | NA | None |
| 32 | DesktopStack |  | 48 66 | " | " | NA | None |

## CoreUIHybrid Version 1.3 : + Universal binary support + revert #9 + Safari menu and menu bar (search) fixes + brightness huds + search in appstore

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | **Light** |  | 58 64 | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 2  | **MacLight** |  | 68 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 3  | **Ultralight** |  | 78 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 4  | **MacUltralight** |  | 88 64  | 98 64  | Better SppStore sidebars and HUDs | None | Used #5 |
| 5  | MacDark |  | 98 64  | " | " | NA | None |
| 6  | MacMediumDark |  | A8 64  | " | " | NA | None |
| 7  | MacUltradark |  | B8 64  | " | " | NA | None |
| 8  | Titlebar |  | C8 64  | " | " | NA | None |
| 9  | **Selection** |  | D8 64  | 68 65 | solid | solid light grey | Used #18 WindowBackground |
| 10 | Header |  | E8 64  | " | " | NA | None |
| 11 | MacMediumLight |  | F8 64 | " | " | NA | None |

| 12 | **Menu** |  | 08 65 | C8 64 | vibrant menu in search bars like Safari  | None | Used #8 |
| 13 | MenuBar |  | 18 65 | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 14 | **Popover** |  | 28 65 | C8 64 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | 38 65 | C8 64 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | 48 65 | C8 64 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | 58 65 | C8 64 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 68 65 | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 78 65 | C8 64 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 88 65 | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | **SpotlightBackground** |  | 98 65 | 88 65 | normal | normal | Used #20 ContentBackground |
| 22 | NotificationCenterBackground |  | A8 65 | " | " | NA | None |
| 23 | **Sheet** |  | B8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | C8 65 | " | " | NA | None |
| 25 | FullScreenUI |  | D8 65 | " | " | NA | None |
| 26 | **UnderPageBackground** |  | E8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | F8 65 | C8 64 | vibrant | **Unknown** | Used #8 |

| 28 | **MenuBarMenu** |  | 08 66 | C8 64 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlBackground |  | 18 66 | " | " | NA | None |
| 30 | SystemBezel |  | 28 66 | " | " | NA | None |
| 31 | LoginWndowControl |  | 38 66 | " | " | NA | None |
| 32 | DesktopStack |  | 48 66 | " | " | NA | None |

## CoreUIHybrid Version 1.2 : + Universal binary support

## CoreUIHybrid Version 1.0 : + Better Spotlight + Better Selection +Sheet + Revert WindowBackground + Revert Bezel

| index| variant | Intent | original | patched | Effect | Dark Mode Side Effect | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | Light |  | 58 64 | " | " | NA | None |
| 2  | MacLight |  | 68 64  | " | " | NA | None |
| 3  | Ultralight |  | 78 64  | " | " | NA | None |
| 4  | MacUltralight |  | 88 64  | " | " | NA | None |
| 5  | MacDark |  | 98 64  | " | " | NA | None |
| 6  | MacMediumDark |  | A8 64  | " | " | NA | None |
| 7  | MacUltradark |  | B8 64  | " | " | NA | None |
| 8  | Titlebar |  | C8 64  | " | " | NA | None |
| 9  | **Selection** |  | D8 64  | 68 65 | solid | solid light grey | Used #18 WindowBackground |
| 10 | Header |  | E8 64  | " | " | NA | None |
| 11 | MacMediumLight |  | F8 64 | " | " | NA | None |

| 12 | Menu |  | 08 65 | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 13 | MenuBar |  | 18 65 | " | " | NA | **Could this fix the menu bar? Doesn't seem like it** |
| 14 | **Popover** |  | 28 65 | C8 64 | vibrant | None | Used #8 |
| 15 | **PopoverLabel** |  | 38 65 | C8 64 | vibrant | None |Used #8 |
| 16 | **ToolTip** |  | 48 65 | C8 64 | vibrant | None | Used #8 |
| 17 | **Sidebar** |  | 58 65 | C8 64 | vibrant | None | Used #8 |
| 18 | WindowBackground |  | 68 65 | " | "  | NA | None |
| 19 | **UnderWindowBackground** |  | 78 65 | C8 64 | fixes sidebar backgrounds  | None | Used #8 |
| 20 | ContentBackground |  | 88 65 | " | " | NA | **Caution** - weird side effects while scolling in table views dark and light |
| 21 | **SpotlightBackground** |  | 98 65 | 88 65 | normal | normal | Used #20 ContentBackground |
| 22 | NotificationCenterBackground |  | A8 65 | " | " | NA | None |
| 23 | **Sheet** |  | B8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 24 | HUDWindow |  | C8 65 | " | " | NA | None |
| 25 | FullScreenUI |  | D8 65 | " | " | NA | None |
| 26 | **UnderPageBackground** |  | E8 65 | C8 64 | **Unknown** | **Unknown** | Used #8 |
| 27 | **InlineSidebar** |  | F8 65 | C8 64 | vibrant | **Unknown** | Used #8 |

| 28 | **MenuBarMenu** |  | 08 66 | C8 64 | vibrant menu barsearch | None | Used #8 |
| 29 | HUDControlBackground |  | 18 66 | " | " | NA | None |
| 30 | SystemBezel |  | 28 66 | " | " | NA | None |
| 31 | LoginWndowControl |  | 38 66 | " | " | NA | None |
| 32 | DesktopStack |  | 48 66 | " | " | NA | None |
