(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\b(29[0-9]|2[0-9][0-9]|[01]?[0-9][0-9]?)\\/(29[0-9]|2[0-9][0-9]|[01]?[0-9][0-9]?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "29") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{5c}/") (re.union (re.++ (str.to_re "29") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (re.opt (re.union (str.to_re "0") (str.to_re "1"))) (re.range "0" "9") (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}hpj/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".hpj/i\u{0a}")))))
; ^http[s]?://([a-zA-Z0-9\-]+\.)*([a-zA-Z]{3,61}|[a-zA-Z]{1,}\.[a-zA-Z]{2})/.*$
(assert (not (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))) (re.union ((_ re.loop 3 61) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "/") (re.* re.allchar) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
