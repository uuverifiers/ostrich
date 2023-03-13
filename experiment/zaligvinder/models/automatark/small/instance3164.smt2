(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; LoginHost\u{3a}\x2Ffriendship\x2Femail_thank_you\?
(assert (str.in_re X (str.to_re "LoginHost:/friendship/email_thank_you?\u{0a}")))
; ^[AHJ-NPR-UW-Z]{2}\s?[0-9]{3}\s?[AHJ-NPR-UW-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "U") (re.range "W" "Z"))) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "A") (str.to_re "H") (re.range "J" "N") (str.to_re "P") (re.range "R" "U") (re.range "W" "Z"))) (str.to_re "\u{0a}"))))
; are\s+Toolbar\s+X-Mailer\x3AInformationsearchnuggetspastb\x2Efreeprod\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "are") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "X-Mailer:\u{13}Informationsearchnugget\u{13}spastb.freeprod.com\u{0a}")))))
(check-sat)
