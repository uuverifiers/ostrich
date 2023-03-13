(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[2-9]\d{2}-\d{3}-\d{4}$
(assert (str.in_re X (re.++ (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[^-]{1}?[^\"\']*$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.comp (str.to_re "-"))) (re.* (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}jfif/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".jfif/i\u{0a}"))))
(check-sat)
