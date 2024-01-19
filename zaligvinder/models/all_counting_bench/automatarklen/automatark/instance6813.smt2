(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^"|'+(.*)+"$|'$/
(assert (not (str.in_re X (re.union (str.to_re "/\u{22}") (re.++ (re.+ (str.to_re "'")) (re.+ (re.* re.allchar)) (str.to_re "\u{22}")) (str.to_re "'/\u{0a}")))))
; ^\.([rR]([aA][rR]|\d{2})|(\d{3})?)$
(assert (not (str.in_re X (re.++ (str.to_re ".") (re.union (re.++ (re.union (str.to_re "r") (str.to_re "R")) (re.union (re.++ (re.union (str.to_re "a") (str.to_re "A")) (re.union (str.to_re "r") (str.to_re "R"))) ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; (^.+\|+[A-Za-z])
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ re.allchar) (re.+ (str.to_re "|")) (re.union (re.range "A" "Z") (re.range "a" "z")))))
(assert (> (str.len X) 10))
(check-sat)
