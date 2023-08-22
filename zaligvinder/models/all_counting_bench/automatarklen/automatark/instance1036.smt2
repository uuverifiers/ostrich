(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\d){2}-(\d){2}-(\d){2}$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}jp2([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.jp2") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; are\s+Toolbar\s+X-Mailer\x3AInformationsearchnuggetspastb\x2Efreeprod\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "are") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}Informationsearchnugget\u{13}spastb.freeprod.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
