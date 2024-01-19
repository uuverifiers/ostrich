(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{8,8}$|^[SC]{2,2}\d{6,6}$
(assert (not (str.in_re X (re.union ((_ re.loop 8 8) (re.range "0" "9")) (re.++ ((_ re.loop 2 2) (re.union (str.to_re "S") (str.to_re "C"))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; spyblpatHost\x3Ais\x2EphpBarFrom\x3AHost\x3Agdvsotuqwsg\u{2f}dxt\.hd
(assert (not (str.in_re X (str.to_re "spyblpatHost:is.phpBarFrom:Host:gdvsotuqwsg/dxt.hd\u{0a}"))))
; Host\x3ASubject\x3AFrom\u{3a}\u{d0}\u{c5}\u{cf}\u{a2}
(assert (not (str.in_re X (str.to_re "Host:Subject:From:\u{d0}\u{c5}\u{cf}\u{a2}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
