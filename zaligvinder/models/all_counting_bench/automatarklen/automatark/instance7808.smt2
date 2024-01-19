(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\_\_)(.+)(\_\_)
(assert (str.in_re X (re.++ (str.to_re "__") (re.+ re.allchar) (str.to_re "__\u{0a}"))))
; ^[A-Z]\d{2}(\.\d){0,1}$
(assert (not (str.in_re X (re.++ (re.range "A" "Z") ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /^\/[a-f0-9]{8}\/[a-f0-9]{8}\/$/iU
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "//iU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
