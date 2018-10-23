The following table should help you select the right patch for your release.
It's always a good idea to validate the checksums on your system.  Use the folowing Terminal commands to do so:

(NOTE: using AppKit as an example)

- For data sections : ```otool -d /S*/L*/Frameworks/AppKit.framework/Versions/Current/AppKit |tail -n +2 |md5 -q```
- For code sections : ```otool -t /S*/L*/Frameworks/AppKit.framework/Versions/Current/AppKit |tail -n +2 |md5 -q```

| macOS Release  | Framework | Data MD5 Checksum                | Code/Text MD5 Checksum           | Use This File           | For This Effect    | Status    |
|----------------|-----------|----------------------------------|----------------------------------|-------------------------|--------------------|-----------|
| 10.14-18A391   | HIToolbox | 8336f588fea577075d7c253992bf9eb5 | db604aab57bcde4d1cf9a806d0adbbe3 | HIToolboxMenubar-18A391 | Solid Menubar      | in beta   |
|                | AppKit    | 872e92b7423b555f3d6df4ee9e3997d8 | d7c7e7dbf127f046e858ff7bac22a487 | AppKitFlat-18A391       | Flat (no vibrancy) | in beta   |
|                | CoreUI    | TBD                              | TBD                              | CoreUIHybrid-18A391     | "hybrid" vibrancy  | in beta   |
| 10.14.1-18B45D | HIToolbox | 80e14bd4bcf222d8ae0534517b07d08c | db604aab57bcde4d1cf9a806d0adbbe3 | HIToolboxMenubar-18B45D | Solid Menubar      | in beta   |
|                | AppKit    | 3344e15f3cbb54a71d3e661fd8359ef0 | 55f25a8bba1be7bb1674ab035a6cdce3 | AppKitFlat-18B45D       | Flat (no vibrancy) | in beta   |
|                | CoreUI    | TBD                              | TBD                              | CoreUIHybrid-18B45D     | "hybrid" vibrancy  | in beta   |
