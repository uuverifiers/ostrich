(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((EE|EL|DE|PT)-?)?[0-9]{9}
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "EE") (str.to_re "EL") (str.to_re "DE") (str.to_re "PT")) (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}chm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".chm/i\u{0a}")))))
; ^([a-zA-Z0-9_\-\._]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-_]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.union (re.++ (str.to_re "[") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))) (str.to_re ".")))) (re.union ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 3) (re.range "0" "9"))) (re.opt (str.to_re "]")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
