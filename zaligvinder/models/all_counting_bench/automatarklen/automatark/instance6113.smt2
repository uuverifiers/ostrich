(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; qr/(Alabama|Alaska|Arizona|Arkansas|California|Colorado|Connecticut|Delaware|Florida|Georgia|Hawaii|Idaho|Illinois|Indiana|Iowa|Kansas|Kentucky|Louisiana|Maine|Maryland|Massachusetts|Michigan|Minnesota|Mississippi|Missouri|Montana|Nebraska|Nevada|New\sHampshire|New\sJersey|New\sMexico|New\sYork|North\sCarolina|North\sDakota|Ohio|Oklahoma|Oregon|Pennsylvania|Rhode\sIsland|South\sCarolina|South\sDakota|Tennessee|Texas|Utah|Vermont|Virginia|Washington|West\sVirginia|Wisconsin|Wyoming)/
(assert (str.in_re X (re.++ (str.to_re "qr/") (re.union (str.to_re "Alabama") (str.to_re "Alaska") (str.to_re "Arizona") (str.to_re "Arkansas") (str.to_re "California") (str.to_re "Colorado") (str.to_re "Connecticut") (str.to_re "Delaware") (str.to_re "Florida") (str.to_re "Georgia") (str.to_re "Hawaii") (str.to_re "Idaho") (str.to_re "Illinois") (str.to_re "Indiana") (str.to_re "Iowa") (str.to_re "Kansas") (str.to_re "Kentucky") (str.to_re "Louisiana") (str.to_re "Maine") (str.to_re "Maryland") (str.to_re "Massachusetts") (str.to_re "Michigan") (str.to_re "Minnesota") (str.to_re "Mississippi") (str.to_re "Missouri") (str.to_re "Montana") (str.to_re "Nebraska") (str.to_re "Nevada") (re.++ (str.to_re "New") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Hampshire")) (re.++ (str.to_re "New") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Jersey")) (re.++ (str.to_re "New") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Mexico")) (re.++ (str.to_re "New") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "York")) (re.++ (str.to_re "North") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Carolina")) (re.++ (str.to_re "North") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Dakota")) (str.to_re "Ohio") (str.to_re "Oklahoma") (str.to_re "Oregon") (str.to_re "Pennsylvania") (re.++ (str.to_re "Rhode") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Island")) (re.++ (str.to_re "South") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Carolina")) (re.++ (str.to_re "South") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Dakota")) (str.to_re "Tennessee") (str.to_re "Texas") (str.to_re "Utah") (str.to_re "Vermont") (str.to_re "Virginia") (str.to_re "Washington") (re.++ (str.to_re "West") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Virginia")) (str.to_re "Wisconsin") (str.to_re "Wyoming")) (str.to_re "/\u{0a}"))))
; ^[6]\d{7}$
(assert (str.in_re X (re.++ (str.to_re "6") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^Referer\u{3a}[^\r\n]+\/[\w_]{32,}\.html\r$/Hsm
(assert (str.in_re X (re.++ (str.to_re "/Referer:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/.html\u{0d}/Hsm\u{0a}") ((_ re.loop 32 32) (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (str.to_re "_") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))))
; Wareztv\x2Eseekmo\x2Ecom\sKeyloggingTRUSTYFILES\x2ECOM
(assert (str.in_re X (re.++ (str.to_re "Wareztv.seekmo.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Keylogging\u{13}TRUSTYFILES.COM\u{0a}"))))
; Flooded\s+Host\x3A\s+AppName\x2FGRSI\|Server\|Host\x3Aorigin\x3DsidefindHost\x3AUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Flooded") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "AppName/GRSI|Server|\u{13}Host:origin=sidefindHost:User-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)