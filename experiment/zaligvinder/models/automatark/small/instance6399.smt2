(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[a-z]{5,8}\d{2,3}\.swf\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".swf\u{0d}\u{0a}/Hm\u{0a}"))))
; hirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (not (str.in_re X (str.to_re "hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}"))))
; Hello\x2E\s+ovplrichfind\x2EcomCookie\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Hello.") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ovplrichfind.comCookie:\u{0a}")))))
(check-sat)
