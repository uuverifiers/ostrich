(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/loader\.cpl$/U
(assert (str.in_re X (str.to_re "//loader.cpl/U\u{0a}")))
; /[a-zA-Z0-9]\/[a-f0-9]{5}\.swf[\u{22}\u{27}]/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "/") ((_ re.loop 5 5) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".swf") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "/\u{0a}")))))
; body=wordHost\x3ASpediartaddrEverywareHost\x3AHost\x3A
(assert (not (str.in_re X (str.to_re "body=wordHost:SpediartaddrEverywareHost:Host:\u{0a}"))))
; wjpropqmlpohj\u{2f}lo\s+media\x2Edxcdirect\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.dxcdirect.com\u{0a}"))))
; HBand,\sHost\x3A[^\n\r]*lnzzlnbk\u{2f}pkrm\.fin
(assert (not (str.in_re X (re.++ (str.to_re "HBand,") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.fin\u{0a}")))))
(check-sat)
