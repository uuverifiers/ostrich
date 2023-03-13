(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1}(\.\d{3})-\d{3}(\.\d{1})$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}.") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9")))))
; ^[a-zA-Z0-9]+([a-zA-Z0-9\-\.]+)?\.(com|org|net|mil|edu|COM|ORG|NET|MIL|EDU)$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.opt (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "-") (str.to_re ".")))) (str.to_re ".") (re.union (str.to_re "com") (str.to_re "org") (str.to_re "net") (str.to_re "mil") (str.to_re "edu") (str.to_re "COM") (str.to_re "ORG") (str.to_re "NET") (str.to_re "MIL") (str.to_re "EDU")) (str.to_re "\u{0a}"))))
(check-sat)
