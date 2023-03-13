(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ftoolbar\x2F\d+www\x2Ericercadoppia\x2EcomPALTALKSubject\x3A
(assert (str.in_re X (re.++ (str.to_re "/toolbar/") (re.+ (re.range "0" "9")) (str.to_re "www.ricercadoppia.comPALTALKSubject:\u{0a}"))))
; /\u{28}\u{3f}\u{3d}[^)]{300}/
(assert (not (str.in_re X (re.++ (str.to_re "/(?=") ((_ re.loop 300 300) (re.comp (str.to_re ")"))) (str.to_re "/\u{0a}")))))
(check-sat)
