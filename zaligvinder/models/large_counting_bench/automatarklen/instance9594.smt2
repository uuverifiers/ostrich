(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; iepluginBrowsedOVNHost\x3A\x2Fproducts\x2Fspyblocs\x2F
(assert (str.in_re X (str.to_re "iepluginBrowsedOVNHost:/products/spyblocs/\u{13}\u{0a}")))
; ^http[s]?://([a-zA-Z0-9\-]+\.)*([a-zA-Z]{3,61}|[a-zA-Z]{1,}\.[a-zA-Z]{2})/.*$
(assert (str.in_re X (re.++ (str.to_re "http") (re.opt (str.to_re "s")) (str.to_re "://") (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-"))) (str.to_re "."))) (re.union ((_ re.loop 3 61) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re ".") ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z"))))) (str.to_re "/") (re.* re.allchar) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)