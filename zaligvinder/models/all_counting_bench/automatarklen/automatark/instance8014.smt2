(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[a-z]{5}\.php\?id=0\d{5}111D30[a-zA-Z0-9]{6}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 5 5) (re.range "a" "z")) (str.to_re ".php?id=0") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "111D30") ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
