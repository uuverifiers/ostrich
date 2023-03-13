(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B(\xF6\xEC\xD9\xB3\u{67}\xCF\x9E\x3D\x7B){500}/m
(assert (str.in_re X (re.++ (str.to_re "/\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={") ((_ re.loop 500 500) (str.to_re "\u{f6}\u{ec}\u{d9}\u{b3}g\u{cf}\u{9e}={")) (str.to_re "/m\u{0a}"))))
; Host\x3Aact=Host\u{3a}User-Agent\x3AUser-Agent\x3ALiteselect\x2FGet
(assert (not (str.in_re X (str.to_re "Host:act=Host:User-Agent:User-Agent:Liteselect/Get\u{0a}"))))
(check-sat)
