(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[0-9a-f]+$/iU
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/iU\u{0a}"))))
; /#-START-#([A-Za-z0-9+\u{2f}]{4})*([A-Za-z0-9+\u{2f}]{2}==|[A-Za-z0-9+\u{2f}]{3}=)?#-END-#/
(assert (str.in_re X (re.++ (str.to_re "/#-START-#") (re.* ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/")))) (re.opt (re.union (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "==")) (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "=")))) (str.to_re "#-END-#/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
