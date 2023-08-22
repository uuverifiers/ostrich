(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Elookster\x2Enetnotificationuuid=qisezhin\u{2f}iqor\.ym
(assert (str.in_re X (str.to_re "www.lookster.netnotification\u{13}uuid=qisezhin/iqor.ym\u{13}\u{0a}")))
; /^.{27}/sR
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 27 27) re.allchar) (str.to_re "/sR\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
