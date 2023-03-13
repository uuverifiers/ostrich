(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}scr/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".scr/i\u{0a}")))))
; ^0$|^[1-9][0-9]*$|^[1-9][0-9]{0,2}(,[0-9]{3})$
(assert (str.in_re X (re.union (str.to_re "0") (re.++ (re.range "1" "9") (re.* (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a},") ((_ re.loop 3 3) (re.range "0" "9"))))))
(check-sat)
