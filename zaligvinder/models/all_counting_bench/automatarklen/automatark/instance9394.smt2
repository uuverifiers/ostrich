(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3ASpyxpsp2-Host\u{3a}Host\x3Awjpropqmlpohj\u{2f}loregister\.asp
(assert (str.in_re X (str.to_re "Host:Spyxpsp2-Host:Host:wjpropqmlpohj/loregister.asp\u{0a}")))
; (^\d{1,5}$|^\d{1,5}\.\d{1,2}$)
(assert (str.in_re X (re.++ (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
