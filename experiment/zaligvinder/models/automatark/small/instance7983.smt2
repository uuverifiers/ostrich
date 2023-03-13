(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^(2014)|^(2149))\d{11}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "2014") (str.to_re "2149")) ((_ re.loop 11 11) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \.cfg.*spyblini\x2Eini[^\n\r]*urfiqileuq\u{2f}tjzu.*Host\x3A666password\x3B1\x3BOptixGmbHPG=SPEEDBARcuReferer\x3A
(assert (not (str.in_re X (re.++ (str.to_re ".cfg") (re.* re.allchar) (str.to_re "spyblini.ini") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "urfiqileuq/tjzu") (re.* re.allchar) (str.to_re "Host:666password;1;OptixGmbHPG=SPEEDBARcuReferer:\u{0a}")))))
; metaresults\.copernic\.comServer\u{00}
(assert (not (str.in_re X (str.to_re "metaresults.copernic.comServer\u{00}\u{0a}"))))
; ^[0-9]{2}-[0-9]{8}-[0-9]$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "-") (re.range "0" "9") (str.to_re "\u{0a}"))))
; ^.*[_A-Za-z0-9]+[\t ]+[\*&]?[\t ]*[_A-Za-z0-9](::)?[_A-Za-z0-9:]+[\t ]*\(( *[ \[\]\*&A-Za-z0-9_]+ *,? *)*\).*$
(assert (str.in_re X (re.++ (re.* re.allchar) (re.+ (re.union (str.to_re "_") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.+ (re.union (str.to_re "\u{09}") (str.to_re " "))) (re.opt (re.union (str.to_re "*") (str.to_re "&"))) (re.* (re.union (str.to_re "\u{09}") (str.to_re " "))) (re.union (str.to_re "_") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.opt (str.to_re "::")) (re.+ (re.union (str.to_re "_") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re ":"))) (re.* (re.union (str.to_re "\u{09}") (str.to_re " "))) (str.to_re "(") (re.* (re.++ (re.* (str.to_re " ")) (re.+ (re.union (str.to_re " ") (str.to_re "[") (str.to_re "]") (str.to_re "*") (str.to_re "&") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_"))) (re.* (str.to_re " ")) (re.opt (str.to_re ",")) (re.* (str.to_re " ")))) (str.to_re ")") (re.* re.allchar) (str.to_re "\u{0a}"))))
(check-sat)
