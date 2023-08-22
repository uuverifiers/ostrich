(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\\){2})(([A-Za-z ',.;]+)(\\?)([A-Za-z ',.;]\\?)*)$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (str.to_re "\u{5c}")) (str.to_re "\u{0a}") (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";"))) (re.opt (str.to_re "\u{5c}")) (re.* (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (str.to_re " ") (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re ";")) (re.opt (str.to_re "\u{5c}")))))))
; /^(1)?(-|.)?(\()?([0-9]{3})(\))?(-|.)?([0-9]{3})(-|.)?([0-9]{4})/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") re.allchar)) (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") re.allchar)) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
