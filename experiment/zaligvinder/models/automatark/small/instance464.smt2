(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [a-zA-Z][a-zA-Z0-9_\-\,\.]{5,31}
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 5 31) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re ",") (str.to_re "."))) (str.to_re "\u{0a}"))))
; \.cfg.*spyblini\x2Eini[^\n\r]*urfiqileuq\u{2f}tjzu.*Host\x3A666password\x3B1\x3BOptixGmbHPG=SPEEDBARcuReferer\x3A
(assert (str.in_re X (re.++ (str.to_re ".cfg") (re.* re.allchar) (str.to_re "spyblini.ini") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "urfiqileuq/tjzu") (re.* re.allchar) (str.to_re "Host:666password;1;OptixGmbHPG=SPEEDBARcuReferer:\u{0a}"))))
; ^(\$)?((\d{1,5})|(\d{1,3})(\,\d{3})*)(\.\d{1,2})?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
