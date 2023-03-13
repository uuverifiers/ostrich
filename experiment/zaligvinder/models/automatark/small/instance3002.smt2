(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(([-\w$%&'*+\/=?^_`{|}~.]+)@(([-a-zA-Z0-9_]+\.)*)([-a-zA-Z0-9]+\.)([a-zA-Z0-9]{2,7}))?$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.+ (re.union (str.to_re "-") (str.to_re "$") (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "*") (str.to_re "+") (str.to_re "/") (str.to_re "=") (str.to_re "?") (str.to_re "^") (str.to_re "_") (str.to_re "`") (str.to_re "{") (str.to_re "|") (str.to_re "}") (str.to_re "~") (str.to_re ".") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "@") (re.* (re.++ (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "."))) ((_ re.loop 2 7) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.+ (re.union (str.to_re "-") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "."))) (str.to_re "\u{0a}"))))
(check-sat)
