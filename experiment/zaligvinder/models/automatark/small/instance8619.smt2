(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{28}BDLL\u{29}Googledll\x3F
(assert (str.in_re X (str.to_re "(BDLL)\u{13}Googledll?\u{0a}")))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z")))))
; www\.iggsey\.com\sX-Mailer\u{3a}[^\n\r]*on\x3Acom\x3E2\x2E41Client
(assert (not (str.in_re X (re.++ (str.to_re "www.iggsey.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "X-Mailer:\u{13}") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "on:com>2.41Client\u{0a}")))))
(check-sat)
