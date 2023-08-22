(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([\s\S]){1,20}([\s\.])
(assert (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
; The company delivers cakes and also online send mothers  day flowers to Delhi.
(assert (not (str.in_re X (re.++ (str.to_re "The company delivers cakes and also online send mothers  day flowers to Delhi") re.allchar (str.to_re "\u{0a}")))))
; kwd\s+User-Agent\x3Aregister\.aspUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "kwd") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:register.aspUser-Agent:\u{0a}")))))
; wjpropqmlpohj\u{2f}lo\s+media\x2Edxcdirect\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "wjpropqmlpohj/lo") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "media.dxcdirect.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
