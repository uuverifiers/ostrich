(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/\?[a-f0-9]{32}$/U
(assert (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/U\u{0a}"))))
; (vi(v))?d
(assert (str.in_re X (re.++ (re.opt (str.to_re "viv")) (str.to_re "d\u{0a}"))))
; 12/err
(assert (not (str.in_re X (str.to_re "12/err\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
