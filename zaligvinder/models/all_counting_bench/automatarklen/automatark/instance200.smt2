(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{1}$|^[1-6]{1}[0-3]{1}$|^64$|\-[1-9]{1}$|^\-[1-6]{1}[0-3]{1}$|^\-64$
(assert (not (str.in_re X (re.union ((_ re.loop 1 1) (re.range "0" "9")) (re.++ ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3"))) (str.to_re "64") (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "9"))) (re.++ (str.to_re "-") ((_ re.loop 1 1) (re.range "1" "6")) ((_ re.loop 1 1) (re.range "0" "3"))) (str.to_re "-64\u{0a}")))))
; ^(\d){7,8}$
(assert (str.in_re X (re.++ ((_ re.loop 7 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
