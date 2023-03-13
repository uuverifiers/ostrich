(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; actualnames\.com\s+fast-look\x2Ecomwww\x2Emaxifiles\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "actualnames.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "fast-look.comwww.maxifiles.com\u{0a}")))))
; /\/[a-zA-Z0-9]{32}\.jar/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}"))))
(check-sat)
