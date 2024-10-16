-- "lua\\streamradio_core\\string_accents.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local StreamRadioLib = StreamRadioLib

local LIB = StreamRadioLib.String

--[[
Used rulesets:
    custom
    default
    custom-fonts
    austrian
    azerbaijani
    croatian
    czech
    danish
    esperanto
    estonian
    finnish
    french
    german
    hungarian
    italian
    latvian
    lithuanian
    norwegian
    polish
    portuguese-brazil
    romanian
    slovak
    swedish
    turkish
    turkmen
    vietnamese
]]

local g_accentMap = {
	[0x000040] = "a",     -- @
	[0x0000A1] = "i",     -- ¡
	[0x0000A7] = "S",     -- §
	[0x0000A9] = "C",     -- ©
	[0x0000AA] = "a",     -- ª
	[0x0000AE] = "R",     -- ®
	[0x0000AF] = "-",     -- ¯
	[0x0000B0] = "o",     -- °
	[0x0000B2] = "2",     -- ²
	[0x0000B3] = "3",     -- ³
	[0x0000B7] = ".",     -- ·
	[0x0000B9] = "1",     -- ¹
	[0x0000BA] = "o",     -- º
	[0x0000C0] = "A",     -- À
	[0x0000C1] = "A",     -- Á
	[0x0000C2] = "A",     -- Â
	[0x0000C3] = "A",     -- Ã
	[0x0000C4] = "A",     -- Ä
	[0x0000C5] = "A",     -- Å
	[0x0000C6] = "AE",    -- Æ
	[0x0000C7] = "C",     -- Ç
	[0x0000C8] = "E",     -- È
	[0x0000C9] = "E",     -- É
	[0x0000CA] = "E",     -- Ê
	[0x0000CB] = "E",     -- Ë
	[0x0000CC] = "I",     -- Ì
	[0x0000CD] = "I",     -- Í
	[0x0000CE] = "I",     -- Î
	[0x0000CF] = "I",     -- Ï
	[0x0000D0] = "Dj",    -- Ð
	[0x0000D1] = "N",     -- Ñ
	[0x0000D2] = "O",     -- Ò
	[0x0000D3] = "O",     -- Ó
	[0x0000D4] = "O",     -- Ô
	[0x0000D5] = "O",     -- Õ
	[0x0000D6] = "O",     -- Ö
	[0x0000D8] = "OE",    -- Ø
	[0x0000D9] = "U",     -- Ù
	[0x0000DA] = "U",     -- Ú
	[0x0000DB] = "U",     -- Û
	[0x0000DC] = "U",     -- Ü
	[0x0000DD] = "Y",     -- Ý
	[0x0000DE] = "TH",    -- Þ
	[0x0000DF] = "ss",    -- ß
	[0x0000E0] = "a",     -- à
	[0x0000E1] = "a",     -- á
	[0x0000E2] = "a",     -- â
	[0x0000E3] = "a",     -- ã
	[0x0000E4] = "a",     -- ä
	[0x0000E5] = "a",     -- å
	[0x0000E6] = "ae",    -- æ
	[0x0000E7] = "c",     -- ç
	[0x0000E8] = "e",     -- è
	[0x0000E9] = "e",     -- é
	[0x0000EA] = "e",     -- ê
	[0x0000EB] = "e",     -- ë
	[0x0000EC] = "i",     -- ì
	[0x0000ED] = "i",     -- í
	[0x0000EE] = "i",     -- î
	[0x0000EF] = "i",     -- ï
	[0x0000F0] = "dj",    -- ð
	[0x0000F1] = "n",     -- ñ
	[0x0000F2] = "o",     -- ò
	[0x0000F3] = "o",     -- ó
	[0x0000F4] = "o",     -- ô
	[0x0000F5] = "o",     -- õ
	[0x0000F6] = "o",     -- ö
	[0x0000F8] = "oe",    -- ø
	[0x0000F9] = "u",     -- ù
	[0x0000FA] = "u",     -- ú
	[0x0000FB] = "u",     -- û
	[0x0000FC] = "u",     -- ü
	[0x0000FD] = "y",     -- ý
	[0x0000FE] = "th",    -- þ
	[0x0000FF] = "y",     -- ÿ
	[0x000100] = "A",     -- Ā
	[0x000101] = "a",     -- ā
	[0x000102] = "A",     -- Ă
	[0x000103] = "a",     -- ă
	[0x000104] = "A",     -- Ą
	[0x000105] = "a",     -- ą
	[0x000106] = "C",     -- Ć
	[0x000107] = "c",     -- ć
	[0x000108] = "C",     -- Ĉ
	[0x000109] = "c",     -- ĉ
	[0x00010A] = "C",     -- Ċ
	[0x00010B] = "c",     -- ċ
	[0x00010C] = "C",     -- Č
	[0x00010D] = "c",     -- č
	[0x00010E] = "D",     -- Ď
	[0x00010F] = "d",     -- ď
	[0x000110] = "D",     -- Đ
	[0x000111] = "d",     -- đ
	[0x000112] = "E",     -- Ē
	[0x000113] = "e",     -- ē
	[0x000114] = "E",     -- Ĕ
	[0x000115] = "e",     -- ĕ
	[0x000116] = "E",     -- Ė
	[0x000117] = "e",     -- ė
	[0x000118] = "E",     -- Ę
	[0x000119] = "e",     -- ę
	[0x00011A] = "E",     -- Ě
	[0x00011B] = "e",     -- ě
	[0x00011C] = "G",     -- Ĝ
	[0x00011D] = "g",     -- ĝ
	[0x00011E] = "G",     -- Ğ
	[0x00011F] = "g",     -- ğ
	[0x000120] = "G",     -- Ġ
	[0x000121] = "g",     -- ġ
	[0x000122] = "G",     -- Ģ
	[0x000123] = "g",     -- ģ
	[0x000124] = "H",     -- Ĥ
	[0x000125] = "h",     -- ĥ
	[0x000126] = "H",     -- Ħ
	[0x000127] = "h",     -- ħ
	[0x000128] = "I",     -- Ĩ
	[0x000129] = "i",     -- ĩ
	[0x00012A] = "I",     -- Ī
	[0x00012B] = "i",     -- ī
	[0x00012C] = "I",     -- Ĭ
	[0x00012D] = "i",     -- ĭ
	[0x00012E] = "I",     -- Į
	[0x00012F] = "i",     -- į
	[0x000130] = "I",     -- İ
	[0x000131] = "i",     -- ı
	[0x000132] = "IJ",    -- Ĳ
	[0x000133] = "ij",    -- ĳ
	[0x000134] = "J",     -- Ĵ
	[0x000135] = "j",     -- ĵ
	[0x000136] = "K",     -- Ķ
	[0x000137] = "k",     -- ķ
	[0x000139] = "L",     -- Ĺ
	[0x00013A] = "l",     -- ĺ
	[0x00013B] = "L",     -- Ļ
	[0x00013C] = "l",     -- ļ
	[0x00013D] = "L",     -- Ľ
	[0x00013E] = "l",     -- ľ
	[0x00013F] = "L",     -- Ŀ
	[0x000140] = "l",     -- ŀ
	[0x000141] = "L",     -- Ł
	[0x000142] = "l",     -- ł
	[0x000143] = "N",     -- Ń
	[0x000144] = "n",     -- ń
	[0x000145] = "N",     -- Ņ
	[0x000146] = "n",     -- ņ
	[0x000147] = "N",     -- Ň
	[0x000148] = "n",     -- ň
	[0x000149] = "n",     -- ŉ
	[0x00014C] = "O",     -- Ō
	[0x00014D] = "o",     -- ō
	[0x00014E] = "O",     -- Ŏ
	[0x00014F] = "o",     -- ŏ
	[0x000150] = "O",     -- Ő
	[0x000151] = "o",     -- ő
	[0x000152] = "OE",    -- Œ
	[0x000153] = "oe",    -- œ
	[0x000154] = "R",     -- Ŕ
	[0x000155] = "r",     -- ŕ
	[0x000156] = "R",     -- Ŗ
	[0x000157] = "r",     -- ŗ
	[0x000158] = "R",     -- Ř
	[0x000159] = "r",     -- ř
	[0x00015A] = "S",     -- Ś
	[0x00015B] = "s",     -- ś
	[0x00015C] = "S",     -- Ŝ
	[0x00015D] = "s",     -- ŝ
	[0x00015E] = "S",     -- Ş
	[0x00015F] = "s",     -- ş
	[0x000160] = "S",     -- Š
	[0x000161] = "s",     -- š
	[0x000162] = "T",     -- Ţ
	[0x000163] = "t",     -- ţ
	[0x000164] = "T",     -- Ť
	[0x000165] = "t",     -- ť
	[0x000166] = "T",     -- Ŧ
	[0x000167] = "t",     -- ŧ
	[0x000168] = "U",     -- Ũ
	[0x000169] = "u",     -- ũ
	[0x00016A] = "U",     -- Ū
	[0x00016B] = "u",     -- ū
	[0x00016C] = "U",     -- Ŭ
	[0x00016D] = "u",     -- ŭ
	[0x00016E] = "U",     -- Ů
	[0x00016F] = "u",     -- ů
	[0x000170] = "U",     -- Ű
	[0x000171] = "u",     -- ű
	[0x000172] = "U",     -- Ų
	[0x000173] = "u",     -- ų
	[0x000174] = "W",     -- Ŵ
	[0x000175] = "w",     -- ŵ
	[0x000176] = "Y",     -- Ŷ
	[0x000177] = "y",     -- ŷ
	[0x000178] = "Y",     -- Ÿ
	[0x000179] = "Z",     -- Ź
	[0x00017A] = "z",     -- ź
	[0x00017B] = "Z",     -- Ż
	[0x00017C] = "z",     -- ż
	[0x00017D] = "Z",     -- Ž
	[0x00017E] = "z",     -- ž
	[0x00017F] = "s",     -- ſ
	[0x000183] = "g",     -- ƃ
	[0x00018F] = "E",     -- Ə
	[0x000192] = "f",     -- ƒ
	[0x0001A0] = "O",     -- Ơ
	[0x0001A1] = "o",     -- ơ
	[0x0001AF] = "U",     -- Ư
	[0x0001B0] = "u",     -- ư
	[0x0001CD] = "A",     -- Ǎ
	[0x0001CE] = "a",     -- ǎ
	[0x0001CF] = "I",     -- Ǐ
	[0x0001D0] = "i",     -- ǐ
	[0x0001D1] = "O",     -- Ǒ
	[0x0001D2] = "o",     -- ǒ
	[0x0001D3] = "U",     -- Ǔ
	[0x0001D4] = "u",     -- ǔ
	[0x0001D5] = "U",     -- Ǖ
	[0x0001D6] = "u",     -- ǖ
	[0x0001D7] = "U",     -- Ǘ
	[0x0001D8] = "u",     -- ǘ
	[0x0001D9] = "U",     -- Ǚ
	[0x0001DA] = "u",     -- ǚ
	[0x0001DB] = "U",     -- Ǜ
	[0x0001DC] = "u",     -- ǜ
	[0x0001DD] = "e",     -- ǝ
	[0x0001EB] = "q",     -- ǫ
	[0x0001FA] = "A",     -- Ǻ
	[0x0001FB] = "a",     -- ǻ
	[0x0001FC] = "AE",    -- Ǽ
	[0x0001FD] = "ae",    -- ǽ
	[0x0001FE] = "O",     -- Ǿ
	[0x0001FF] = "o",     -- ǿ
	[0x000218] = "S",     -- Ș
	[0x000219] = "s",     -- ș
	[0x00021A] = "T",     -- Ț
	[0x00021B] = "t",     -- ț
	[0x000250] = "a",     -- ɐ
	[0x000254] = "c",     -- ɔ
	[0x000259] = "e",     -- ə
	[0x00025F] = "f",     -- ɟ
	[0x000262] = "g",     -- ɢ
	[0x000265] = "h",     -- ɥ
	[0x00026A] = "i",     -- ɪ
	[0x00026F] = "m",     -- ɯ
	[0x000274] = "n",     -- ɴ
	[0x000279] = "r",     -- ɹ
	[0x00027E] = "j",     -- ɾ
	[0x000280] = "r",     -- ʀ
	[0x000285] = "S",     -- ʅ
	[0x000287] = "t",     -- ʇ
	[0x00028C] = "v",     -- ʌ
	[0x00028D] = "w",     -- ʍ
	[0x00028E] = "y",     -- ʎ
	[0x00028F] = "y",     -- ʏ
	[0x000299] = "b",     -- ʙ
	[0x00029C] = "h",     -- ʜ
	[0x00029E] = "k",     -- ʞ
	[0x00029F] = "l",     -- ʟ
	[0x0003BC] = "u",     -- μ
	[0x00043E] = "o",     -- о
	[0x000493] = "f",     -- ғ
	[0x001430] = "A",     -- ᐰ
	[0x001D00] = "a",     -- ᴀ
	[0x001D04] = "c",     -- ᴄ
	[0x001D05] = "d",     -- ᴅ
	[0x001D07] = "e",     -- ᴇ
	[0x001D09] = "i",     -- ᴉ
	[0x001D0A] = "j",     -- ᴊ
	[0x001D0B] = "k",     -- ᴋ
	[0x001D0D] = "m",     -- ᴍ
	[0x001D0F] = "o",     -- ᴏ
	[0x001D18] = "p",     -- ᴘ
	[0x001D1B] = "t",     -- ᴛ
	[0x001D1C] = "u",     -- ᴜ
	[0x001D20] = "v",     -- ᴠ
	[0x001D21] = "w",     -- ᴡ
	[0x001D22] = "z",     -- ᴢ
	[0x001E9E] = "SS",    -- ẞ
	[0x001EA0] = "A",     -- Ạ
	[0x001EA1] = "a",     -- ạ
	[0x001EA2] = "A",     -- Ả
	[0x001EA3] = "a",     -- ả
	[0x001EA4] = "A",     -- Ấ
	[0x001EA5] = "a",     -- ấ
	[0x001EA6] = "A",     -- Ầ
	[0x001EA7] = "a",     -- ầ
	[0x001EA8] = "A",     -- Ẩ
	[0x001EA9] = "a",     -- ẩ
	[0x001EAA] = "A",     -- Ẫ
	[0x001EAB] = "a",     -- ẫ
	[0x001EAC] = "A",     -- Ậ
	[0x001EAD] = "a",     -- ậ
	[0x001EAE] = "A",     -- Ắ
	[0x001EAF] = "a",     -- ắ
	[0x001EB0] = "A",     -- Ằ
	[0x001EB1] = "a",     -- ằ
	[0x001EB2] = "A",     -- Ẳ
	[0x001EB3] = "a",     -- ẳ
	[0x001EB4] = "A",     -- Ẵ
	[0x001EB5] = "a",     -- ẵ
	[0x001EB6] = "A",     -- Ặ
	[0x001EB7] = "a",     -- ặ
	[0x001EB8] = "E",     -- Ẹ
	[0x001EB9] = "e",     -- ẹ
	[0x001EBA] = "E",     -- Ẻ
	[0x001EBB] = "e",     -- ẻ
	[0x001EBC] = "E",     -- Ẽ
	[0x001EBD] = "e",     -- ẽ
	[0x001EBE] = "E",     -- Ế
	[0x001EBF] = "e",     -- ế
	[0x001EC0] = "E",     -- Ề
	[0x001EC1] = "e",     -- ề
	[0x001EC2] = "E",     -- Ể
	[0x001EC3] = "e",     -- ể
	[0x001EC4] = "E",     -- Ễ
	[0x001EC5] = "e",     -- ễ
	[0x001EC6] = "E",     -- Ệ
	[0x001EC7] = "e",     -- ệ
	[0x001EC8] = "I",     -- Ỉ
	[0x001EC9] = "i",     -- ỉ
	[0x001ECA] = "I",     -- Ị
	[0x001ECB] = "i",     -- ị
	[0x001ECC] = "O",     -- Ọ
	[0x001ECD] = "o",     -- ọ
	[0x001ECE] = "O",     -- Ỏ
	[0x001ECF] = "o",     -- ỏ
	[0x001ED0] = "O",     -- Ố
	[0x001ED1] = "o",     -- ố
	[0x001ED2] = "O",     -- Ồ
	[0x001ED3] = "o",     -- ồ
	[0x001ED4] = "O",     -- Ổ
	[0x001ED5] = "o",     -- ổ
	[0x001ED6] = "O",     -- Ỗ
	[0x001ED7] = "o",     -- ỗ
	[0x001ED8] = "O",     -- Ộ
	[0x001ED9] = "o",     -- ộ
	[0x001EDA] = "O",     -- Ớ
	[0x001EDB] = "o",     -- ớ
	[0x001EDC] = "O",     -- Ờ
	[0x001EDD] = "o",     -- ờ
	[0x001EDE] = "O",     -- Ở
	[0x001EDF] = "o",     -- ở
	[0x001EE0] = "O",     -- Ỡ
	[0x001EE1] = "o",     -- ỡ
	[0x001EE2] = "O",     -- Ợ
	[0x001EE3] = "o",     -- ợ
	[0x001EE4] = "U",     -- Ụ
	[0x001EE5] = "u",     -- ụ
	[0x001EE6] = "U",     -- Ủ
	[0x001EE7] = "u",     -- ủ
	[0x001EE8] = "U",     -- Ứ
	[0x001EE9] = "u",     -- ứ
	[0x001EEA] = "U",     -- Ừ
	[0x001EEB] = "u",     -- ừ
	[0x001EEC] = "U",     -- Ử
	[0x001EED] = "u",     -- ử
	[0x001EEE] = "U",     -- Ữ
	[0x001EEF] = "u",     -- ữ
	[0x001EF0] = "U",     -- Ự
	[0x001EF1] = "u",     -- ự
	[0x001EF2] = "Y",     -- Ỳ
	[0x001EF3] = "y",     -- ỳ
	[0x001EF4] = "Y",     -- Ỵ
	[0x001EF5] = "y",     -- ỵ
	[0x001EF6] = "Y",     -- Ỷ
	[0x001EF7] = "y",     -- ỷ
	[0x001EF8] = "Y",     -- Ỹ
	[0x001EF9] = "y",     -- ỹ
	[0x002013] = "-",     -- –
	[0x002014] = "-",     -- —
	[0x002020] = "t",     -- †
	[0x002025] = "..",    -- ‥
	[0x002026] = "...",   -- …
	[0x00203C] = "!!",    -- ‼
	[0x00203E] = "-",     -- ‾
	[0x002074] = "4",     -- ⁴
	[0x002075] = "5",     -- ⁵
	[0x002076] = "6",     -- ⁶
	[0x002077] = "7",     -- ⁷
	[0x002078] = "8",     -- ⁸
	[0x002079] = "9",     -- ⁹
	[0x00207F] = "n",     -- ⁿ
	[0x002081] = "1",     -- ₁
	[0x002082] = "2",     -- ₂
	[0x002083] = "3",     -- ₃
	[0x002084] = "4",     -- ₄
	[0x002085] = "5",     -- ₅
	[0x002086] = "6",     -- ₆
	[0x002087] = "7",     -- ₇
	[0x002088] = "8",     -- ₈
	[0x002089] = "9",     -- ₉
	[0x0020AC] = "E",     -- €
	[0x002102] = "C",     -- ℂ
	[0x002103] = "C",     -- ℃
	[0x002109] = "F",     -- ℉
	[0x00210C] = "H",     -- ℌ
	[0x00210D] = "H",     -- ℍ
	[0x00210E] = "h",     -- ℎ
	[0x002111] = "I",     -- ℑ
	[0x002115] = "N",     -- ℕ
	[0x002117] = "P",     -- ℗
	[0x002119] = "P",     -- ℙ
	[0x00211A] = "Q",     -- ℚ
	[0x00211C] = "R",     -- ℜ
	[0x00211D] = "R",     -- ℝ
	[0x002122] = "tm",    -- ™
	[0x002124] = "Z",     -- ℤ
	[0x002128] = "Z",     -- ℨ
	[0x00212D] = "C",     -- ℭ
	[0x00216C] = "L",     -- Ⅼ
	[0x002203] = "3",     -- ∃
	[0x002208] = "E",     -- ∈
	[0x00220B] = "3",     -- ∋
	[0x00220F] = "N",     -- ∏
	[0x002210] = "U",     -- ∐
	[0x002211] = "E",     -- ∑
	[0x00221E] = "oo",    -- ∞
	[0x00222B] = "S",     -- ∫
	[0x0022C0] = "A",     -- ⋀
	[0x0022C1] = "V",     -- ⋁
	[0x0022C2] = "U",     -- ⋂
	[0x0022C3] = "U",     -- ⋃
	[0x0024B6] = "A",     -- Ⓐ
	[0x0024B7] = "B",     -- Ⓑ
	[0x0024B8] = "C",     -- Ⓒ
	[0x0024B9] = "D",     -- Ⓓ
	[0x0024BA] = "E",     -- Ⓔ
	[0x0024BB] = "F",     -- Ⓕ
	[0x0024BC] = "G",     -- Ⓖ
	[0x0024BD] = "H",     -- Ⓗ
	[0x0024BE] = "I",     -- Ⓘ
	[0x0024BF] = "J",     -- Ⓙ
	[0x0024C0] = "K",     -- Ⓚ
	[0x0024C1] = "L",     -- Ⓛ
	[0x0024C2] = "M",     -- Ⓜ
	[0x0024C3] = "N",     -- Ⓝ
	[0x0024C4] = "O",     -- Ⓞ
	[0x0024C5] = "P",     -- Ⓟ
	[0x0024C6] = "Q",     -- Ⓠ
	[0x0024C7] = "R",     -- Ⓡ
	[0x0024C8] = "S",     -- Ⓢ
	[0x0024C9] = "T",     -- Ⓣ
	[0x0024CA] = "U",     -- Ⓤ
	[0x0024CB] = "V",     -- Ⓥ
	[0x0024CC] = "W",     -- Ⓦ
	[0x0024CD] = "X",     -- Ⓧ
	[0x0024CE] = "Y",     -- Ⓨ
	[0x0024CF] = "Z",     -- Ⓩ
	[0x0024D0] = "a",     -- ⓐ
	[0x0024D1] = "b",     -- ⓑ
	[0x0024D2] = "c",     -- ⓒ
	[0x0024D3] = "d",     -- ⓓ
	[0x0024D4] = "e",     -- ⓔ
	[0x0024D5] = "f",     -- ⓕ
	[0x0024D6] = "g",     -- ⓖ
	[0x0024D7] = "h",     -- ⓗ
	[0x0024D8] = "i",     -- ⓘ
	[0x0024D9] = "j",     -- ⓙ
	[0x0024DA] = "k",     -- ⓚ
	[0x0024DB] = "l",     -- ⓛ
	[0x0024DC] = "m",     -- ⓜ
	[0x0024DD] = "n",     -- ⓝ
	[0x0024DE] = "o",     -- ⓞ
	[0x0024DF] = "p",     -- ⓟ
	[0x0024E0] = "q",     -- ⓠ
	[0x0024E1] = "r",     -- ⓡ
	[0x0024E2] = "s",     -- ⓢ
	[0x0024E3] = "t",     -- ⓣ
	[0x0024E4] = "u",     -- ⓤ
	[0x0024E5] = "v",     -- ⓥ
	[0x0024E6] = "w",     -- ⓦ
	[0x0024E7] = "x",     -- ⓧ
	[0x0024E8] = "y",     -- ⓨ
	[0x0024E9] = "z",     -- ⓩ
	[0x01D400] = "A",     -- 𝐀
	[0x01D401] = "B",     -- 𝐁
	[0x01D402] = "C",     -- 𝐂
	[0x01D403] = "D",     -- 𝐃
	[0x01D404] = "E",     -- 𝐄
	[0x01D405] = "F",     -- 𝐅
	[0x01D406] = "G",     -- 𝐆
	[0x01D407] = "H",     -- 𝐇
	[0x01D408] = "I",     -- 𝐈
	[0x01D409] = "J",     -- 𝐉
	[0x01D40A] = "K",     -- 𝐊
	[0x01D40B] = "L",     -- 𝐋
	[0x01D40C] = "M",     -- 𝐌
	[0x01D40D] = "N",     -- 𝐍
	[0x01D40E] = "O",     -- 𝐎
	[0x01D40F] = "P",     -- 𝐏
	[0x01D410] = "Q",     -- 𝐐
	[0x01D411] = "R",     -- 𝐑
	[0x01D412] = "S",     -- 𝐒
	[0x01D413] = "T",     -- 𝐓
	[0x01D414] = "U",     -- 𝐔
	[0x01D415] = "V",     -- 𝐕
	[0x01D416] = "W",     -- 𝐖
	[0x01D417] = "X",     -- 𝐗
	[0x01D418] = "Y",     -- 𝐘
	[0x01D419] = "Z",     -- 𝐙
	[0x01D41A] = "a",     -- 𝐚
	[0x01D41B] = "b",     -- 𝐛
	[0x01D41C] = "c",     -- 𝐜
	[0x01D41D] = "d",     -- 𝐝
	[0x01D41E] = "e",     -- 𝐞
	[0x01D41F] = "f",     -- 𝐟
	[0x01D420] = "g",     -- 𝐠
	[0x01D421] = "h",     -- 𝐡
	[0x01D422] = "i",     -- 𝐢
	[0x01D423] = "j",     -- 𝐣
	[0x01D424] = "k",     -- 𝐤
	[0x01D425] = "l",     -- 𝐥
	[0x01D426] = "m",     -- 𝐦
	[0x01D427] = "n",     -- 𝐧
	[0x01D428] = "o",     -- 𝐨
	[0x01D429] = "p",     -- 𝐩
	[0x01D42A] = "q",     -- 𝐪
	[0x01D42B] = "r",     -- 𝐫
	[0x01D42C] = "s",     -- 𝐬
	[0x01D42D] = "t",     -- 𝐭
	[0x01D42E] = "u",     -- 𝐮
	[0x01D42F] = "v",     -- 𝐯
	[0x01D430] = "w",     -- 𝐰
	[0x01D431] = "x",     -- 𝐱
	[0x01D432] = "y",     -- 𝐲
	[0x01D433] = "z",     -- 𝐳
	[0x01D434] = "A",     -- 𝐴
	[0x01D435] = "B",     -- 𝐵
	[0x01D436] = "C",     -- 𝐶
	[0x01D437] = "D",     -- 𝐷
	[0x01D438] = "E",     -- 𝐸
	[0x01D439] = "F",     -- 𝐹
	[0x01D43A] = "G",     -- 𝐺
	[0x01D43B] = "H",     -- 𝐻
	[0x01D43C] = "I",     -- 𝐼
	[0x01D43D] = "J",     -- 𝐽
	[0x01D43E] = "K",     -- 𝐾
	[0x01D43F] = "L",     -- 𝐿
	[0x01D440] = "M",     -- 𝑀
	[0x01D441] = "N",     -- 𝑁
	[0x01D442] = "O",     -- 𝑂
	[0x01D443] = "P",     -- 𝑃
	[0x01D444] = "Q",     -- 𝑄
	[0x01D445] = "R",     -- 𝑅
	[0x01D446] = "S",     -- 𝑆
	[0x01D447] = "T",     -- 𝑇
	[0x01D448] = "U",     -- 𝑈
	[0x01D449] = "V",     -- 𝑉
	[0x01D44A] = "W",     -- 𝑊
	[0x01D44B] = "X",     -- 𝑋
	[0x01D44C] = "Y",     -- 𝑌
	[0x01D44D] = "Z",     -- 𝑍
	[0x01D44E] = "a",     -- 𝑎
	[0x01D44F] = "b",     -- 𝑏
	[0x01D450] = "c",     -- 𝑐
	[0x01D451] = "d",     -- 𝑑
	[0x01D452] = "e",     -- 𝑒
	[0x01D453] = "f",     -- 𝑓
	[0x01D454] = "g",     -- 𝑔
	[0x01D456] = "i",     -- 𝑖
	[0x01D457] = "j",     -- 𝑗
	[0x01D458] = "k",     -- 𝑘
	[0x01D459] = "l",     -- 𝑙
	[0x01D45A] = "m",     -- 𝑚
	[0x01D45B] = "n",     -- 𝑛
	[0x01D45C] = "o",     -- 𝑜
	[0x01D45D] = "p",     -- 𝑝
	[0x01D45E] = "q",     -- 𝑞
	[0x01D45F] = "r",     -- 𝑟
	[0x01D460] = "s",     -- 𝑠
	[0x01D461] = "t",     -- 𝑡
	[0x01D462] = "u",     -- 𝑢
	[0x01D463] = "v",     -- 𝑣
	[0x01D464] = "w",     -- 𝑤
	[0x01D465] = "x",     -- 𝑥
	[0x01D466] = "y",     -- 𝑦
	[0x01D467] = "z",     -- 𝑧
	[0x01D49C] = "A",     -- 𝒜
	[0x01D49E] = "C",     -- 𝒞
	[0x01D49F] = "D",     -- 𝒟
	[0x01D4A2] = "G",     -- 𝒢
	[0x01D4A5] = "J",     -- 𝒥
	[0x01D4A6] = "K",     -- 𝒦
	[0x01D4A9] = "N",     -- 𝒩
	[0x01D4AA] = "O",     -- 𝒪
	[0x01D4AB] = "P",     -- 𝒫
	[0x01D4AC] = "Q",     -- 𝒬
	[0x01D4AE] = "S",     -- 𝒮
	[0x01D4AF] = "T",     -- 𝒯
	[0x01D4B0] = "U",     -- 𝒰
	[0x01D4B1] = "V",     -- 𝒱
	[0x01D4B2] = "W",     -- 𝒲
	[0x01D4B3] = "X",     -- 𝒳
	[0x01D4B4] = "Y",     -- 𝒴
	[0x01D4B5] = "Z",     -- 𝒵
	[0x01D4B6] = "a",     -- 𝒶
	[0x01D4B7] = "b",     -- 𝒷
	[0x01D4B8] = "c",     -- 𝒸
	[0x01D4B9] = "d",     -- 𝒹
	[0x01D4BB] = "f",     -- 𝒻
	[0x01D4BD] = "h",     -- 𝒽
	[0x01D4BE] = "i",     -- 𝒾
	[0x01D4BF] = "j",     -- 𝒿
	[0x01D4C0] = "k",     -- 𝓀
	[0x01D4C1] = "l",     -- 𝓁
	[0x01D4C2] = "m",     -- 𝓂
	[0x01D4C3] = "n",     -- 𝓃
	[0x01D4C5] = "p",     -- 𝓅
	[0x01D4C6] = "q",     -- 𝓆
	[0x01D4C7] = "r",     -- 𝓇
	[0x01D4C8] = "s",     -- 𝓈
	[0x01D4C9] = "t",     -- 𝓉
	[0x01D4CA] = "u",     -- 𝓊
	[0x01D4CB] = "v",     -- 𝓋
	[0x01D4CC] = "w",     -- 𝓌
	[0x01D4CD] = "x",     -- 𝓍
	[0x01D4CE] = "y",     -- 𝓎
	[0x01D4CF] = "z",     -- 𝓏
	[0x01D504] = "A",     -- 𝔄
	[0x01D505] = "B",     -- 𝔅
	[0x01D507] = "D",     -- 𝔇
	[0x01D508] = "E",     -- 𝔈
	[0x01D509] = "F",     -- 𝔉
	[0x01D50A] = "G",     -- 𝔊
	[0x01D50D] = "J",     -- 𝔍
	[0x01D50E] = "K",     -- 𝔎
	[0x01D50F] = "L",     -- 𝔏
	[0x01D510] = "M",     -- 𝔐
	[0x01D511] = "N",     -- 𝔑
	[0x01D512] = "O",     -- 𝔒
	[0x01D513] = "P",     -- 𝔓
	[0x01D514] = "Q",     -- 𝔔
	[0x01D516] = "S",     -- 𝔖
	[0x01D517] = "T",     -- 𝔗
	[0x01D518] = "U",     -- 𝔘
	[0x01D519] = "V",     -- 𝔙
	[0x01D51A] = "W",     -- 𝔚
	[0x01D51B] = "X",     -- 𝔛
	[0x01D51C] = "Y",     -- 𝔜
	[0x01D51E] = "a",     -- 𝔞
	[0x01D51F] = "b",     -- 𝔟
	[0x01D520] = "c",     -- 𝔠
	[0x01D521] = "d",     -- 𝔡
	[0x01D522] = "e",     -- 𝔢
	[0x01D523] = "f",     -- 𝔣
	[0x01D524] = "g",     -- 𝔤
	[0x01D525] = "h",     -- 𝔥
	[0x01D526] = "i",     -- 𝔦
	[0x01D527] = "j",     -- 𝔧
	[0x01D528] = "k",     -- 𝔨
	[0x01D529] = "l",     -- 𝔩
	[0x01D52A] = "m",     -- 𝔪
	[0x01D52B] = "n",     -- 𝔫
	[0x01D52C] = "o",     -- 𝔬
	[0x01D52D] = "p",     -- 𝔭
	[0x01D52E] = "q",     -- 𝔮
	[0x01D52F] = "r",     -- 𝔯
	[0x01D530] = "s",     -- 𝔰
	[0x01D531] = "t",     -- 𝔱
	[0x01D532] = "u",     -- 𝔲
	[0x01D533] = "v",     -- 𝔳
	[0x01D534] = "w",     -- 𝔴
	[0x01D535] = "x",     -- 𝔵
	[0x01D536] = "y",     -- 𝔶
	[0x01D537] = "z",     -- 𝔷
	[0x01D538] = "A",     -- 𝔸
	[0x01D539] = "B",     -- 𝔹
	[0x01D53B] = "D",     -- 𝔻
	[0x01D53C] = "E",     -- 𝔼
	[0x01D53D] = "F",     -- 𝔽
	[0x01D53E] = "G",     -- 𝔾
	[0x01D540] = "I",     -- 𝕀
	[0x01D541] = "J",     -- 𝕁
	[0x01D542] = "K",     -- 𝕂
	[0x01D543] = "L",     -- 𝕃
	[0x01D544] = "M",     -- 𝕄
	[0x01D546] = "O",     -- 𝕆
	[0x01D54A] = "S",     -- 𝕊
	[0x01D54B] = "T",     -- 𝕋
	[0x01D54C] = "U",     -- 𝕌
	[0x01D54D] = "V",     -- 𝕍
	[0x01D54E] = "W",     -- 𝕎
	[0x01D54F] = "X",     -- 𝕏
	[0x01D550] = "Y",     -- 𝕐
	[0x01D552] = "a",     -- 𝕒
	[0x01D553] = "b",     -- 𝕓
	[0x01D554] = "c",     -- 𝕔
	[0x01D555] = "d",     -- 𝕕
	[0x01D556] = "e",     -- 𝕖
	[0x01D557] = "f",     -- 𝕗
	[0x01D558] = "g",     -- 𝕘
	[0x01D559] = "h",     -- 𝕙
	[0x01D55A] = "i",     -- 𝕚
	[0x01D55B] = "j",     -- 𝕛
	[0x01D55C] = "k",     -- 𝕜
	[0x01D55D] = "l",     -- 𝕝
	[0x01D55E] = "m",     -- 𝕞
	[0x01D55F] = "n",     -- 𝕟
	[0x01D560] = "o",     -- 𝕠
	[0x01D561] = "p",     -- 𝕡
	[0x01D562] = "q",     -- 𝕢
	[0x01D563] = "r",     -- 𝕣
	[0x01D564] = "s",     -- 𝕤
	[0x01D565] = "t",     -- 𝕥
	[0x01D566] = "u",     -- 𝕦
	[0x01D567] = "v",     -- 𝕧
	[0x01D568] = "w",     -- 𝕨
	[0x01D569] = "x",     -- 𝕩
	[0x01D56A] = "y",     -- 𝕪
	[0x01D56B] = "z",     -- 𝕫
}

function LIB.StripAccents(str, alsoStripHighUnicode)
	str = utf8.force(str)

	local stripped = {}

	for _, codepoint in utf8.codes(str) do
		local char = g_accentMap[codepoint]

		if not char then
			if alsoStripHighUnicode and codepoint > 0x7F then
				continue;
			end

			char = utf8.char(codepoint)
		end

		table.insert(stripped, char)
	end

	stripped = table.concat(stripped)

	return stripped
end

return true

