(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(s-|S-){0,1}[0-9]{3}\s?[0-9]{2}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "s-") (str.to_re "S-"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^0?[0-9]?[0-9]$|^(100)$
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "0")) (re.opt (re.range "0" "9")) (re.range "0" "9")) (str.to_re "100\u{0a}"))))
; http://www.scribd.com/doc/2569355/Geo-Distance-Search-with-MySQL
(assert (not (str.in_re X (re.++ (str.to_re "http://www") re.allchar (str.to_re "scribd") re.allchar (str.to_re "com/doc/2569355/Geo-Distance-Search-with-MySQL\u{0a}")))))
; /filename=[^\n]*\u{2e}aom/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".aom/i\u{0a}")))))
; \d{2}[.]{1}\d{2}[.]{1}[0-9A-Za-z]{1}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
(check-sat)
