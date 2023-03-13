(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^~/[0-9a-zA-Z_][0-9a-zA-Z/_-]*\.[0-9a-zA-Z_-]+$
(assert (str.in_re X (re.++ (str.to_re "~/") (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_")) (re.* (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z") (str.to_re "_") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; ^([\+][0-9]{1,3}([ \.\-])?)?([\(]{1}[0-9]{3}[\)])?([0-9A-Z \.\-]{1,32})((x|ext|extension)?[0-9]{1,4}?)$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re "+") ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-"))))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")"))) ((_ re.loop 1 32) (re.union (re.range "0" "9") (re.range "A" "Z") (str.to_re " ") (str.to_re ".") (str.to_re "-"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "x") (str.to_re "ext") (str.to_re "extension"))) ((_ re.loop 1 4) (re.range "0" "9"))))))
(check-sat)
