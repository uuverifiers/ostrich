(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; badurl\x2Egrandstreetinteractive\x2EcomFilteredHost\x3Ae2give\.com\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "badurl.grandstreetinteractive.comFilteredHost:e2give.com/newsurfer4/\u{0a}"))))
; /\u{2e}js\u{3f}[a-zA-Z0-9]{9,20}=Mozilla\u{2f}/UGi
(assert (not (str.in_re X (re.++ (str.to_re "/.js?") ((_ re.loop 9 20) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "=Mozilla//UGi\u{0a}")))))
(check-sat)
