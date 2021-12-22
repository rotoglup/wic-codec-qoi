; This setup script is compiled with Inno Setup Compiler version 5.5.9
; See: http://www.jrsoftware.org/

#define AppVersion    "1.0.0"
#define AppName       "Example WIC Codec"
#define AppPublisher  "René Slijkhuis"
#define FriendlyName  "Lisa"
#define FileExtension ".lisa"
#define MimeType      "image/lisa"
#define DecoderCLSID  "EB68FE9B-B1D7-4E76-8B68-781E5CFB5290"
#define EncoderCLSID  "79CC92AA-B204-4B11-A341-1617D9CD8A88"
#define PropertyHandlerCLSID "308BF946-3857-4083-B2B9-3D19093A7EA2"
#define ContainerFormatCLSID "91DFBD70-3D2C-440F-B297-1E2097D4A833"

[Setup]
AppName =                           "{#AppName}"
AppVerName =                        "{#AppName} {#AppVersion}"
AppCopyright =                      "Copyright © 2017 {#AppPublisher}"
AppPublisher =                      "{#AppPublisher}"
AppPublisherURL =                   "http://www.slijkhuis.org/"
AppVersion =                        "{#AppVersion}"
DefaultDirName =                    "{pf}\{#AppName}"
DirExistsWarning =                  no
DisableStartupPrompt =              yes
DisableWelcomePage =                yes
DisableDirPage =                    yes
DisableProgramGroupPage =           yes
SourceDir =                         "."
OutputBaseFilename =                "Setup-ExampleWicCodec"
OutputDir =                         "."
UninstallDisplayIcon =              "{app}\WicCodec.dll"
UninstallDisplayName =              "{#AppName}"
MinVersion =                        6.1
ArchitecturesAllowed =              x64
ArchitecturesInstallIn64BitMode =   x64
PrivilegesRequired =                admin
ChangesAssociations =               yes

[Files]
; x64
Source: "..\codec\bin\x64\Release\WicCodec.dll"; DestDir: "{app}"; Flags: ignoreversion regserver restartreplace uninsrestartdelete

; x86
Source: "..\codec\bin\Win32\Release\WicCodec.dll"; DestDir: "{pf32}\{#AppName}"; Flags: ignoreversion regserver restartreplace uninsrestartdelete

[Registry]
; WIC Registry Entries
; - https://msdn.microsoft.com/en-us/library/windows/desktop/ee719880(v=vs.85).aspx

; WIC Decoder - x64
Root: HKCR; Subkey: "CLSID\{{7ED96837-96F0-4812-B211-F13C24117ED3}\Instance\{{{#DecoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "CLSID\{{7ED96837-96F0-4812-B211-F13C24117ED3}\Instance\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "CLSID"; ValueData: "{{{#DecoderCLSID}}";
Root: HKCR; Subkey: "CLSID\{{7ED96837-96F0-4812-B211-F13C24117ED3}\Instance\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Decoder";

Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: ""; ValueData: "{#FriendlyName} Decoder";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Author"; ValueData: "{#AppPublisher}";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Description"; ValueData: "Example WIC Decoder";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "FileExtensions"; ValueData: "{#FileExtension}";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Decoder";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "ContainerFormat"; ValueData: "{{{#ContainerFormatCLSID}}";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Vendor"; ValueData: "{{E27AE9AE-D620-4AEB-AD02-E2AE03104234}";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Version"; ValueData: "{#AppVersion}";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "MimeTypes"; ValueData: "{#MimeType}";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportAnimation";  ValueData: "0";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportChromaKey";  ValueData: "0";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportLossless";   ValueData: "1";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportMultiframe"; ValueData: "0";

; GUID_WICPixelFormat8bppGray
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC908}";
; GUID_WICPixelFormat24bppRGB
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC90D}";

Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\InprocServer32";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\InprocServer32"; ValueType: string; ValueName: ""; ValueData: "{app}\WicCodec.dll";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\InprocServer32"; ValueType: string; ValueName: "ThreadingModel"; ValueData: "Both";

; WIC Encoder - x64
Root: HKCR; Subkey: "CLSID\{{AC757296-3522-4E11-9862-C17BE5A1767E}\Instance\{{{#EncoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "CLSID\{{AC757296-3522-4E11-9862-C17BE5A1767E}\Instance\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "CLSID"; ValueData: "{{{#EncoderCLSID}}";
Root: HKCR; Subkey: "CLSID\{{AC757296-3522-4E11-9862-C17BE5A1767E}\Instance\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Encoder";

Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: ""; ValueData: "{#FriendlyName} Encoder";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Author"; ValueData: "{#AppPublisher}";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Description"; ValueData: "Example WIC Encoder";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "FileExtensions"; ValueData: "{#FileExtension}";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Encoder";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "ContainerFormat"; ValueData: "{{{#ContainerFormatCLSID}}";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Vendor"; ValueData: "{{E27AE9AE-D620-4AEB-AD02-E2AE03104234}";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Version"; ValueData: "{#AppVersion}";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "MimeTypes"; ValueData: "{#MimeType}";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportAnimation";  ValueData: "0";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportChromaKey";  ValueData: "0";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportLossless";   ValueData: "1";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportMultiframe"; ValueData: "0";

; GUID_WICPixelFormat8bppGray
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC908}";
; GUID_WICPixelFormat24bppRGB
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC90D}";

Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}\InprocServer32";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}\InprocServer32"; ValueType: string; ValueName: ""; ValueData: "{app}\WicCodec.dll";
Root: HKCR; Subkey: "CLSID\{{{#EncoderCLSID}}\InprocServer32"; ValueType: string; ValueName: "ThreadingModel"; ValueData: "Both";

Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\Patterns\0";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: dword; ValueName: "Position"; ValueData: "0";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: dword; ValueName: "Length"; ValueData: "21";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: binary; ValueName: "Pattern"; ValueData: "4C 49 53 41 00 17 26 71 F7 9E CC 43 4B BC 7A 8F 21 5D 77 DE 35";
Root: HKCR; Subkey: "CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: binary; ValueName: "Mask"; ValueData: "FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF";

; WIC Decoder - x86
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{7ED96837-96F0-4812-B211-F13C24117ED3}\Instance\{{{#DecoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{7ED96837-96F0-4812-B211-F13C24117ED3}\Instance\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "CLSID"; ValueData: "{{{#DecoderCLSID}}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{7ED96837-96F0-4812-B211-F13C24117ED3}\Instance\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Decoder";

Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: ""; ValueData: "{#FriendlyName} Decoder";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Author"; ValueData: "{#AppPublisher}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Description"; ValueData: "Example WIC Decoder";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "FileExtensions"; ValueData: "{#FileExtension}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Decoder";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "ContainerFormat"; ValueData: "{{{#ContainerFormatCLSID}}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Vendor"; ValueData: "{{E27AE9AE-D620-4AEB-AD02-E2AE03104234}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "Version"; ValueData: "{#AppVersion}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: string; ValueName: "MimeTypes"; ValueData: "{#MimeType}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportAnimation";  ValueData: "0";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportChromaKey";  ValueData: "0";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportLossless";   ValueData: "1";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}"; ValueType: dword;  ValueName: "SupportMultiframe"; ValueData: "0";

; GUID_WICPixelFormat8bppGray
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC908}";
; GUID_WICPixelFormat24bppRGB
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC90D}";

Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\InprocServer32";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\InprocServer32"; ValueType: string; ValueName: ""; ValueData: "{pf32}\{#AppName}\WicCodec.dll";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\InprocServer32"; ValueType: string; ValueName: "ThreadingModel"; ValueData: "Both";

; WIC Encoder - x86
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{AC757296-3522-4E11-9862-C17BE5A1767E}\Instance\{{{#EncoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{AC757296-3522-4E11-9862-C17BE5A1767E}\Instance\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "CLSID"; ValueData: "{{{#EncoderCLSID}}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{AC757296-3522-4E11-9862-C17BE5A1767E}\Instance\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Encoder";

Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: ""; ValueData: "{#FriendlyName} Encoder";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Author"; ValueData: "{#AppPublisher}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Description"; ValueData: "Example WIC Encoder";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "FileExtensions"; ValueData: "{#FileExtension}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "FriendlyName"; ValueData: "{#FriendlyName} Encoder";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "ContainerFormat"; ValueData: "{{{#ContainerFormatCLSID}}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Vendor"; ValueData: "{{E27AE9AE-D620-4AEB-AD02-E2AE03104234}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "Version"; ValueData: "{#AppVersion}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: string; ValueName: "MimeTypes"; ValueData: "{#MimeType}";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportAnimation";  ValueData: "0";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportChromaKey";  ValueData: "0";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportLossless";   ValueData: "1";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}"; ValueType: dword;  ValueName: "SupportMultiframe"; ValueData: "0";

; GUID_WICPixelFormat8bppGray
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC908}";
; GUID_WICPixelFormat24bppRGB
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}\Formats\{{6FDDC324-4E03-4BFE-B185-3D77768DC90D}";

Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}\InprocServer32";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}\InprocServer32"; ValueType: string; ValueName: ""; ValueData: "{pf32}\{#AppName}\WicCodec.dll";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#EncoderCLSID}}\InprocServer32"; ValueType: string; ValueName: "ThreadingModel"; ValueData: "Both";

Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\Patterns\0";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: dword; ValueName: "Position"; ValueData: "0";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: dword; ValueName: "Length"; ValueData: "21";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: binary; ValueName: "Pattern"; ValueData: "4C 49 53 41 00 17 26 71 F7 9E CC 43 4B BC 7A 8F 21 5D 77 DE 35";
Root: HKCR; Subkey: "Wow6432Node\CLSID\{{{#DecoderCLSID}}\Patterns\0"; ValueType: binary; ValueName: "Mask"; ValueData: "FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF";

; PropertyHandler
Root: HKCR; Subkey: "CLSID\{{{#PropertyHandlerCLSID}}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "CLSID\{{{#PropertyHandlerCLSID}}"; ValueType: string; ValueName: ""; ValueData: "PropertyHandler";
Root: HKCR; Subkey: "CLSID\{{{#PropertyHandlerCLSID}}"; ValueType: dword; ValueName: "ManualSafeSave"; ValueData: "1";
Root: HKCR; Subkey: "CLSID\{{{#PropertyHandlerCLSID}}\InprocServer32";
Root: HKCR; Subkey: "CLSID\{{{#PropertyHandlerCLSID}}\InprocServer32"; ValueType: string; ValueName: ""; ValueData: "{app}\WicCodec.dll";
Root: HKCR; Subkey: "CLSID\{{{#PropertyHandlerCLSID}}\InprocServer32"; ValueType: string; ValueName: "ThreadingModel"; ValueData: "Apartment";

; RAW
Root: HKCR; Subkey: "{#FileExtension}"; Flags: uninsdeletekeyifempty
Root: HKCR; Subkey: "{#FileExtension}"; ValueType: string; ValueName: ""; ValueData: "ExampleWicFile"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#FileExtension}"; ValueType: string; ValueName: "Content Type"; ValueData: "{#MimeType}"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#FileExtension}"; ValueType: string; ValueName: "PerceivedType"; ValueData: "image"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#FileExtension}\OpenWithList\PhotoViewer.dll"; Flags: uninsdeletekeyifempty
Root: HKCR; Subkey: "{#FileExtension}\OpenWithProgids"; Flags: uninsdeletekeyifempty
Root: HKCR; Subkey: "{#FileExtension}\OpenWithProgids"; ValueType: string; ValueName: "ExampleWicFile"; ValueData: ""; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#FileExtension}\shellex\ContextMenuHandlers\ShellImagePreview"; Flags: uninsdeletekeyifempty
Root: HKCR; Subkey: "{#FileExtension}\shellex\ContextMenuHandlers\ShellImagePreview"; ValueType: string; ValueName: ""; ValueData: "{{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "{#FileExtension}\shellex\{{e357fccd-a995-4576-b01f-234630154e96}"; Flags: uninsdeletekeyifempty
Root: HKCR; Subkey: "{#FileExtension}\shellex\{{e357fccd-a995-4576-b01f-234630154e96}"; ValueType: string; ValueName: ""; ValueData: "{{C7657C4A-9F68-40fa-A4DF-96BC08EB3551}"; Flags: uninsdeletevalue

; Container Format
;     https://msdn.microsoft.com/en-us/library/windows/desktop/cc144133%28v=vs.85%29.aspx
;     https://msdn.microsoft.com/en-us/library/windows/desktop/dd561977%28v=vs.85%29.aspx
Root: HKCR; Subkey: "ExampleWicFile"; Flags: uninsdeletekey
Root: HKCR; Subkey: "ExampleWicFile"; ValueType: string; ValueName: ""; ValueData: "Example WIC Image"
Root: HKCR; Subkey: "ExampleWicFile"; ValueType: string; ValueName: "FullDetails"; ValueData: "prop:System.Image.HorizontalSize;System.Image.VerticalSize;System.Image.BitDepth;System.DateModified;System.DateCreated";
Root: HKCR; Subkey: "ExampleWicFile"; ValueType: string; ValueName: "PreviewDetails"; ValueData: "prop:System.Image.HorizontalSize;System.Image.VerticalSize;System.Image.BitDepth;System.Size;System.DateModified;System.DateCreated";
Root: HKCR; Subkey: "ExampleWicFile"; ValueType: string; ValueName: "TileInfo"; ValueData: "prop:System.Image.Dimensions;System.Size";
Root: HKCR; Subkey: "ExampleWicFile"; ValueType: string; ValueName: "InfoTip"; ValueData: "prop:System.Image.Dimensions;System.Image.BitDepth;System.Size;System.DateModified;System.DateCreated";

Root: HKCR; Subkey: "ExampleWicFile\shell\open";
Root: HKCR; Subkey: "ExampleWicFile\shell\open"; ValueType: expandsz; ValueName: "MuiVerb"; ValueData: "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043"

Root: HKCR; Subkey: "ExampleWicFile\shell\open\command";
Root: HKCR; Subkey: "ExampleWicFile\shell\open\command"; ValueType: expandsz; ValueName: ""; ValueData: "%SystemRoot%\System32\rundll32.exe ""%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll"", ImageView_Fullscreen %1"

Root: HKCR; Subkey: "ExampleWicFile\shell\open\DropTarget";
Root: HKCR; Subkey: "ExampleWicFile\shell\open\DropTarget"; ValueType: string; ValueName: "Clsid"; ValueData: "{{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}";

Root: HKCR; Subkey: "ExampleWicFile\shellex\ContextMenuHandlers\{{649EAC06-3FB9-42C9-BA69-88BC473130F5}";
Root: HKCR; Subkey: "ExampleWicFile\shellex\ContextMenuHandlers\{{649EAC06-3FB9-42C9-BA69-88BC473130F5}"; ValueType: string; ValueName: ""; ValueData: "ContextMenuHandler";

; Windows shell integration
;     https://msdn.microsoft.com/en-us/library/windows/desktop/cc144110%28v=vs.85%29.aspx
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Approved"; ValueType: string; ValueName: "{{{#PropertyHandlerCLSID}}"; ValueData: "{#AppName}"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\PropertySystem\PropertyHandlers\{#FileExtension}"; ValueType: string; ValueName: ""; ValueData: "{{{#PropertyHandlerCLSID}}"; Flags: uninsdeletekey

;     https://msdn.microsoft.com/en-us/library/windows/desktop/cc144136%28v=vs.85%29.aspx
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap"; ValueType: string; ValueName: "{#FileExtension}"; ValueData: "picture";