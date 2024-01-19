(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-fA-F]{4}|0)(\:([0-9a-fA-F]{4}|0)){7}$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "0")) ((_ re.loop 7 7) (re.++ (str.to_re ":") (re.union ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "0")))) (str.to_re "\u{0a}"))))
; /\.php\?mac\u{3d}([a-f0-9]{2}\u{3a}){5}[a-f0-9]{2}$/U
(assert (not (str.in_re X (re.++ (str.to_re "/.php?mac=") ((_ re.loop 5 5) (re.++ ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ":"))) ((_ re.loop 2 2) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; AdTools\sdownloadfile\u{2e}org\w+com\x3E[^\n\r]*as\x2Estarware\x2EcomOS\x2FSSKCstech\x2Eweb-nexus\x2Enet
(assert (str.in_re X (re.++ (str.to_re "AdTools") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "downloadfile.org") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com>") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "as.starware.comOS/SSKCstech.web-nexus.net\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
