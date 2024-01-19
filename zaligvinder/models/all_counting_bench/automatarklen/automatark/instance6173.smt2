(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/DES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//DES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}mp4/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mp4/i\u{0a}")))))
; ^\d{5}(-\d{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; </?[a-z][a-z0-9]*[^<>]*>
(assert (str.in_re X (re.++ (str.to_re "<") (re.opt (str.to_re "/")) (re.range "a" "z") (re.* (re.union (re.range "a" "z") (re.range "0" "9"))) (re.* (re.union (str.to_re "<") (str.to_re ">"))) (str.to_re ">\u{0a}"))))
; ^([A-Z]{1,2}[0-9]{1,2}|[A-Z]{3}|[A-Z]{1,2}[0-9][A-Z])( |-)[0-9][A-Z]{2}
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) ((_ re.loop 1 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.range "A" "Z")) (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.range "A" "Z"))) (re.union (str.to_re " ") (str.to_re "-")) (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
