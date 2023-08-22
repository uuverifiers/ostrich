(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\s+Host\x3Acdpnode=FILESIZE\x3Etoolsbar\x2Ekuaiso\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:cdpnode=FILESIZE>\u{13}toolsbar.kuaiso.com\u{0a}")))))
; Fictional[^\n\r]*v\x3B[^\n\r]*\u{22}Stealth\d+moreKontikiHost\u{3a}AcmeEvilFTPHost\x3ATOOLBARSupremePort\x2E
(assert (not (str.in_re X (re.++ (str.to_re "Fictional") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "v;") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}Stealth") (re.+ (re.range "0" "9")) (str.to_re "moreKontikiHost:AcmeEvilFTPHost:TOOLBARSupremePort.\u{0a}")))))
; /logo\.png\u{3f}(sv\u{3d}\d{1,3})?\u{26}tq\u{3d}.*?SoSEU/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/logo.png?") (re.opt (re.++ (str.to_re "sv=") ((_ re.loop 1 3) (re.range "0" "9")))) (str.to_re "&tq=") (re.* re.allchar) (str.to_re "SoSEU/smiU\u{0a}")))))
; ^0[1-9]\d{7,8}$
(assert (not (str.in_re X (re.++ (str.to_re "0") (re.range "1" "9") ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
