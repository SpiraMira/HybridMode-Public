# 32 BIT - The following table should help us track kCUIxxxVariant mods and their effects (or side-effects)

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
