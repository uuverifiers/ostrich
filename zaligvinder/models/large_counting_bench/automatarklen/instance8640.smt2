(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B(\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B){500}/m
(assert (not (str.in_re X (re.++ (str.to_re "/\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={") ((_ re.loop 500 500) (str.to_re "\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={")) (str.to_re "/m\u{0a}")))))
; www\x2Emaxifiles\x2EcomServidor\x2E
(assert (str.in_re X (str.to_re "www.maxifiles.comServidor.\u{13}\u{0a}")))
; /\u{2e}csd([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.csd") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
