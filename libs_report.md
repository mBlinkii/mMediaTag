# Externals-Report: mMT

- **Repo-Pfad:** `D:\Dev\mMT`
- **Metadaten-Format:** `workflow`
- **Erstellt:** 30.07.2026 18:00
- **Ergebnis:** 4 erfolgreich, 0 fehlerhaft, 0 uebersprungen (von 4)

---

## Uebersicht

| Status | Zielpfad | Quelle | Ref | System |
|:---|:---|:---|:---|:---|
| OK | `Addon/!mMT_MediaPack/libs/CallbackHandler-1.0` | https://repos.curseforge.com/wow/callbackhandler/trunk/CallbackHandler-1.0 | - | svn |
| OK | `Addon/!mMT_MediaPack/libs/LibSharedMedia-3.0` | https://repos.curseforge.com/wow/libsharedmedia-3-0/trunk/LibSharedMedia-3.0 | - | svn |
| OK | `Addon/!mMT_MediaPack/libs/LibStub` | https://repos.curseforge.com/wow/libstub/trunk | - | svn |
| OK | `Addon/ElvUI_mMediaTag/lib/AceLocale-3.0` | https://repos.curseforge.com/wow/ace3/trunk/AceLocale-3.0 | - | svn |

---

## Historie (letzte 5 Eintraege je Library)

### `Addon/!mMT_MediaPack/libs/CallbackHandler-1.0`

- Quelle: https://repos.curseforge.com/wow/callbackhandler/trunk/CallbackHandler-1.0
- System: svn

| Revision | Datum | Autor | Nachricht |
|:---|:---|:---|:---|
| `r26` | 2022-12-12 | nevcairiel | Use securecallfunction instead of xpcall This allows error handlers to properly use debuglocals() when handling any potential errors in the callback. Change contributed by Meorawr |
| `r25` | 2022-12-12 | nevcairiel | Sync up style changes with Ace3 |
| `r22` | 2018-07-21 | nevcairiel | Replace generated Dispatcher with xpcall, which now supports arguments |
| `r18` | 2014-10-16 | mikk | TOC 60000 Tear out some beta-times checks that could have been removed many years ago |
| `r14` | 2010-08-09 | mikk | Ticket 5: Allow 'self or addonId' to be a thread (coroutine) |

### `Addon/!mMT_MediaPack/libs/LibSharedMedia-3.0`

- Quelle: https://repos.curseforge.com/wow/libsharedmedia-3-0/trunk/LibSharedMedia-3.0
- System: svn

| Revision | Datum | Autor | Nachricht |
|:---|:---|:---|:---|
| `r164` | 2026-01-13 | elkano | - bump TOCs - improved algorithmic complexity when registering new media files |
| `r151` | 2024-05-05 | funkehdude | The retail only safety check should no longer be needed |
| `r128` | 2022-10-26 | funkehdude | bump toc |
| `r114` | 2019-09-13 | elkano | fixes registering mp3 paths closes #23 |
| `r113` | 2019-07-14 | elkano | readded pre-8.2 compatibility for classic client |

### `Addon/!mMT_MediaPack/libs/LibStub`

- Quelle: https://repos.curseforge.com/wow/libstub/trunk
- System: svn

| Revision | Datum | Autor | Nachricht |
|:---|:---|:---|:---|
| `r109` | 2021-05-04 | kaelten | update toc version |
| `r108` | 2018-08-12 | kaelten | Updating WoW Toc Version |
| `r107` | 2017-06-17 | kaelten | update toc version for 7.2.5 |
| `r105` | 2016-08-18 | kaelten | Updating ToC for Legion. |
| `r103` | 2014-10-16 | mikk | TOC 60000 |

### `Addon/ElvUI_mMediaTag/lib/AceLocale-3.0`

- Quelle: https://repos.curseforge.com/wow/ace3/trunk/AceLocale-3.0
- System: svn

| Revision | Datum | Autor | Nachricht |
|:---|:---|:---|:---|
| `r1284` | 2022-09-25 | nevcairiel | Luacheck rules and conformance Also remove references to the old FindGlobals script, which were not maintained for ages, and the role has been taken by Luacheck now. |
| `r1035` | 2011-07-09 | kaelten | AceLocale: fixed bug when trying to edit a silent Locale from separate files. AceDB: Added locale and factionrealmregion profile keys |
| `r1005` | 2011-01-29 | mikk | AceLocale-3.0: Do not send a 2nd parameter to errorhandler. (Causes problem for Swatter.. heh why?) |
| `r1004` | 2011-01-26 | mikk | AceLocale-3.0: Aaaaand remember to bump the minor. ~slap Mikk |
| `r1003` | 2011-01-26 | mikk | AceLocale-3.0: - Change the error() on trying to register a silent locale in the wrong way to a geterrorhandler() warning. - Add tests for above. |

