(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Serverwjpropqmlpohj\u{2f}loHost\x3AKEY=
(assert (str.in_re X (str.to_re "Serverwjpropqmlpohj/loHost:KEY=\u{0a}")))
; /^.{27}/sR
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 27 27) re.allchar) (str.to_re "/sR\u{0a}")))))
(check-sat)
