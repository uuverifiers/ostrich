(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^-?\d*(\.\d+)?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; ^[A-Z]+[A-Z0-9,\x5F]*$
(assert (not (str.in_re X (re.++ (re.+ (re.range "A" "Z")) (re.* (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re ",") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; Host\x3AHost\x3Aalertseqepagqfphv\u{2f}sfd
(assert (str.in_re X (str.to_re "Host:Host:alertseqepagqfphv/sfd\u{0a}")))
; ^(\$)?((\d{1,5})|(\d{1,3})(\,\d{3})*)(\.\d{1,2})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^(\d{5}((|-)-\d{4})?)|([A-Za-z]\d[A-Za-z][\s\.\-]?(|-)\d[A-Za-z]\d)|[A-Za-z]{1,2}\d{1,2}[A-Za-z]? \d[A-Za-z]{2}$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "--") ((_ re.loop 4 4) (re.range "0" "9"))))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.opt (re.union (str.to_re ".") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "-") (re.range "0" "9") (re.union (re.range "A" "Z") (re.range "a" "z")) (re.range "0" "9")) (re.++ ((_ re.loop 1 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.opt (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re " ") (re.range "0" "9") ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
