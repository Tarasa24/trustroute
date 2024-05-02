MASTER_KEYS = [
  "91FF E070 0E80 619C EB73 235C A88E 23E3 7751 4E00",
  "D8AF DDA0 7A5B 6EDF A7D8 CCDA D6D0 55F9 2784 3F1C",
  "2AC0 A42E FB0B 5CBC 7A04 02ED 4DC9 5B6D 7BE9 892E",
  "69E6 471E 3AE0 6529 7529 832E 6BA0 F5A2 037F 4F41",
  "3572 FA2A 1B06 7F22 C58A F155 F8B8 21B4 2A6F DCD7"
]

master_keys = MASTER_KEYS.map do |key|
  puts "Seeding master key #{key}"
  Key.create_from_keyserver!("0x#{key.gsub(" ", "")}", Keyservers::KeyserverUbuntuCom)
end

DEVELOPER_KEYS = [
  "6C7F 7F22 E015 2A6F D572 8592 DAD6 F305 6C89 7266",
  "8A9B C581 9C54 FEB3 DC2A 9B48 C322 17F6 F13F F192",
  "6645 B0A8 C700 5E78 DB1D 7864 F99F FE0F EAE9 99BD",
  "8E19 9216 7465 DB5F B045 557C B028 54ED 753E 0F1F",
  "ADC8 A1FC C15E 01D4 5310 419E 9465 7AB2 0F2A 092B",
  "9674 D4ED 3DFB 6ADC C4F9 F1EA 1C73 6AEF 9640 2E7C",
  "601F 20F1 D1BB BF4A 78CF 5B6D F6B1 610B 3ECD BC9F",
  "0016 846E DD84 3226 1C62 CB63 DF38 9146 3C35 2040",
  "8AA2 213C 8464 C82D 879C 8127 D4B5 8E89 7A92 9F2E",
  "9D74 DF6F 91B7 BDAB D581 5CA8 4AC5 588F 941C 2A25",
  "14E4 6FE5 FD69 F2E2 87E2 44DB 632C 3CC0 D1C9 CAF6",
  "BE2D BCF2 B1E3 E588 AC32 5AEA A06B 4947 0F8E 620A",
  "69DA 34D7 8FE0 EFD5 96AC 6D04 9D89 3EC4 DAAF 9129",
  "CCB3 4EBB B954 1EF3 F7B3 66C1 D4A7 5346 8A5A 5B67",
  "E87E 5B39 F04A 5D88 9D8C 0147 F6D8 4143 496F 6680",
  "69F8 E5E5 E85F 7710 20A0 777C 3D30 9011 083B A25E",
  "04F7 A0E3 1E08 D3E0 8D39 AFEB D147 F943 6429 5E8C",
  "E625 4531 5B01 2B69 C8C9 4A1D 56EC 201B FC79 4362",
  "02FD 1C7A 934E 6145 4584 9F19 A623 4074 498E 9CEE",
  "F00B 96D1 5228 013F FC9C 9D03 93B1 1DAA 4C19 7E3D",
  "6DAF 7B80 8F9D F251 3962 0000 D214 61E3 DFE2 060D",
  "25AC E777 F62C 5E5A CBF2 C047 4E53 2176 DBAD 6F47",
  "6093 9E55 F6D5 ABF7 EE41 9F08 B1A1 D3C5 F2DF 9BC5",
  "8024 7D99 EABD 3A4D 1E3A 1836 E85B 8683 EB48 BC95",
  "04DC 3FB1 445F ECA8 13C2 7EFA EA4F 7B32 1A90 6AD9",
  "954A 3772 D62E F90E 4B31 FBC6 C91A 9911 192C 187A",
  "991F 6E3F 0765 CF62 9588 8586 139B 09DA 5BF0 D338",
  "86CF FCA9 18CF 3AF4 7147 5880 51E8 B148 A999 9C34",
  "5E6D 4944 8958 B384 301F 1F22 498E F247 F340 C1E0",
  "42DF AFB7 C03B 2E4E 7BBD BA69 930B 82BF C2BD A011",
  "B597 1F2C 5C10 A9A0 8C60 030F 786C 63F3 30D7 CB92",
  "3DCE 51D6 0930 EBA4 7858 BA41 46F6 33CB B0EB 4BF2",
  "CFA6 AF15 E5C7 4149 FC1D 8C08 6D16 55C1 4CE1 C13E",
  "05C7 775A 9E8B 9774 07FE 08E6 9D4C 5AA1 5426 DA0A",
  "034D 823D A205 5BEE 6A6B F0BB 25EA 6900 D9EA 5EBC",
  "ECCA C84C 1BA0 8A6C C8E6 3FBB F22F B1D7 8A77 AEAB",
  "531E CF36 44A4 4FEA 0B47 DBCD E1E3 CF05 3944 8BFF",
  "DB5B 4A95 4660 1F94 5389 C669 40AC 6F48 D55A B11D",
  "1094 15E6 9200 7609 CA7E BFE4 001C F481 0BE8 D911",
  "83BC 8889 351B 5DEB BB68 416E B8AC 0860 0F10 8CDF",
  "38ED D188 6756 924E 1224 E495 24E4 CDB0 013C 2580",
  "E499 C79F 53C9 6A54 E572 FEE1 C060 8633 7C50 773E",
  "CE53 6327 AED1 8EAB C3B9 9A17 F4AA 4E0E D256 8E87",
  "5134 EF9E AF65 F95B 6BB1 608E 50FB 9B27 3A9D 0BB5",
  "8742 F753 5E7B 394A 1B04 8163 332C 9C40 F40D 2072",
  "5C81 C9D6 C8D7 475D F65A 0C88 4FE7 F4FE AC8E BE67",
  "209A 36D4 3CE2 E87D A861 FC58 539D FD48 1351 82EF",
  "0A9D DABB 64B9 93D8 2AD4 5E4F 32EA B0A9 7693 8292",
  "535F 8C03 3945 0F05 4A4D 2827 0609 6A6A D1CE DDAC",
  "2191 B894 31BA C0A8 B96D E93D 2447 40D1 7C7F D0EC",
  "E240 B57E 2C46 30BA 768E 2F26 FC1B 547C 8D81 72C8",
  "2E36 D862 0221 482F C45C B7F2 A917 6475 9326 B440",
  "54EB 4D6D B209 862C 8945 CACC ED84 945B 35B2 555C",
  "0CAD AACF 70F6 4C65 4E13 1B31 1167 5C74 3429 DDEF",
  "56C3 E775 E72B 0C8B 1C0C 1BD0 B5DB 7740 9B11 B601",
  "9522 0BE9 9CE6 FF77 8AE0 DC67 0F65 C7D8 8150 6130",
  "F850 562F CDA3 69F8 0D33 000A E48D 0A83 26DE 47C5",
  "C100 3466 7663 4E80 C940 FB9E 9C02 FF41 9FEC BE16",
  "9731 2D5E B9D7 AE7D 0BD4 3073 51DA E9B7 C1AE 9161",
  "165E 0FF7 C48C 226E 1EC3 63A7 F834 2482 4B3E 4B90",
  "3E80 CA1A 8B89 F69C BA57 D98A 76A5 EF90 5444 9A5C",
  "1F71 56C2 AD7D 3B15 873C 5E29 4082 5C6B DD1A 4146",
  "262A 58EC 6C51 F7EA 395B 2E2D FDC3 040B 92AC A748",
  "903B AB73 640E B6D6 5533 EFF3 468F 122C E816 2295",
  "89E7 B933 1C4A E7D7 FAF7 D305 C132 2939 54BB E4AD",
  "8FC1 5A06 4950 A99D D1BD 14DD 39E4 B877 E62E B915",
  "B81B 051F 2D7F C867 AAFF 35A5 8DBD 63B8 2072 D77A",
  "54C1 FD27 3361 EA51 4A23 7793 F296 BDE5 0368 C6CE",
  "051E AD6A 6155 389D 69DA 02E5 EB76 3B4E 9DB8 87A6",
  "FE5A FA6D 5DE0 070A DFA2 1BC5 E074 B836 53CB B7BA",
  "5B7E 3FB7 1B7F 1032 9A1C 03AB 771D F662 7EDF 681F",
  "8FE6 A7D4 CC42 C83C 9BCC A8E3 2DA2 ACC3 ECE4 DCE6",
  "04CF 0CD6 F6EE 93AE 1896 F584 07D0 6351 CA5B 31BE",
  "D89F AAEB 4CEC AFD1 99A2 F5E6 12C6 F735 F7A9 A519",
  "64B1 3F71 17D6 E07D 661B BCE0 FE76 3A64 F5E5 4FD6"
]

developer_keys = DEVELOPER_KEYS.map do |key|
  puts "Seeding developer key #{key}"
  Key.create_from_keyserver!("0x#{key.gsub(" ", "")}", Keyservers::KeyserverUbuntuCom)
end

MASTER_SIGNATURES = [
  [true, true, true, true, true],
  [true, true, true, false, true],
  [true, true, false, false, false],
  [true, true, true, true, false],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, false, true, true, true],
  [false, false, false, false, false],
  [true, true, true, true, true],
  [true, false, true, true, true],
  [true, false, true, true, false],
  [true, false, true, true, true],
  [true, false, true, true, true],
  [true, false, true, true, false],
  [true, true, true, true, true],
  [false, false, false, false, false],
  [true, false, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, false],
  [true, true, true, true, true],
  [true, false, true, true, true],
  [true, false, true, true, false],
  [true, true, true, true, true],
  [true, true, true, false, false],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, false],
  [true, false, true, true, true],
  [true, true, true, true, false],
  [true, true, true, true, false],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, false, true],
  [true, true, true, false, true],
  [true, false, true, true, true],
  [true, true, true, true, false],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, false, true, false, false],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, false],
  [true, true, true, true, true],
  [true, false, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, false, true, true, true],
  [true, true, true, true, false],
  [true, true, true, true, true],
  [true, false, true, false, true],
  [true, true, true, true, true],
  [true, true, true, true, false],
  [true, true, true, true, false],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, true],
  [true, true, true, true, false],
  [true, false, true, true, true],
  [true, true, true, true, true],
  [true, true, true, false, false],
  [true, true, true, true, true],
  [true, true, true, true, false],
  [true, true, true, true, false],
  [true, false, true, true, true],
  [false, true, true, true, true],
  [true, true, true, true, true],
  [true, false, true, true, false],
  [true, true, true, false, false]
]

MASTER_SIGNATURES.each_with_index do |signature_set, developer_key_index|
  signature_set.each_with_index do |signature, master_key_index|
    next unless signature

    master_key = master_keys[master_key_index]
    developer_key = developer_keys[developer_key_index]

    puts "Vouching master key #{master_key.sha} for developer key #{developer_key.sha}"
    VouchRelationship.create!(
      from_node: master_key,
      to_node: developer_key
    )
  end
end

DEVELOPER_CROSS_SIGNATURES = [
  %w[0xD1CEDDAC 0x2072D77A],
  %w[0xD1CEDDAC 0x2072D77A],
  %w[0x2072D77A 0xD1CEDDAC],
  %w[0x3A9D0BB5 0x7C50773E],
  %w[0xDFE2060D 0x8D8172C8],
  %w[0xDFE2060D 0xE8162295],
  %w[0xE8162295 0xDFE2060D],
  %w[0xE8162295 0xF5E54FD6],
  %w[0xF5E54FD6 0xE8162295],
  %w[0x4CE1C13E 0x1A906AD9],
  %w[0xE62EB915 0x8D8172C8],
  %w[0x7C50773E 0xF5E54FD6],
  %w[0xF5E54FD6 0x7C50773E],
  %w[0x0F2A092B 0x9FECBE16],
  %w[0x0F2A092B 0x192C187A],
  %w[0xD1CEDDAC 0xB0EB4BF2],
  %w[0xB0EB4BF2 0x9FECBE16],
  %w[0xD1CEDDAC 0x30D7CB92],
  %w[0xB0EB4BF2 0x30D7CB92],
  %w[0xE62EB915 0x30D7CB92],
  %w[0xD1CEDDAC 0xDAAF9129],
  %w[0xD1CEDDAC 0x2072D77A],
  %w[0x30D7CB92 0x35B2555C],
  %w[0xB0EB4BF2 0x2072D77A],
  %w[0x30D7CB92 0x2072D77A],
  %w[0x30D7CB92 0x7C50773E],
  %w[0x30D7CB92 0x9FECBE16],
  %w[0x30D7CB92 0xB0EB4BF2],
  %w[0x2072D77A 0x30D7CB92],
  %w[0x2072D77A 0x9FECBE16],
  %w[0x2072D77A 0xB0EB4BF2],
  %w[0x192C187A 0x30D7CB92],
  %w[0x192C187A 0xB0EB4BF2],
  %w[0x192C187A 0x9FECBE16],
  %w[0x9FECBE16 0x30D7CB92],
  %w[0x9FECBE16 0xB0EB4BF2],
  %w[0x9FECBE16 0x2072D77A],
  %w[0x9FECBE16 0x0F2A092B],
  %w[0x9FECBE16 0x35B2555C],
  %w[0x53CBB7BA 0x96402E7C]
]

developer_keys_map = developer_keys.map { |key| ["0x#{key.sha.upcase}", key] }.to_h

DEVELOPER_CROSS_SIGNATURES.each do |signature_set|
  from_key = developer_keys_map[signature_set[0]]
  to_key = developer_keys_map[signature_set[1]]

  puts "Vouching developer key #{from_key.sha} for developer key #{to_key.sha}"
  VouchRelationship.create!(
    from_node: from_key,
    to_node: to_key
  )
end
