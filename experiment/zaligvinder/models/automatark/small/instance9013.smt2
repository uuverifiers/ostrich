(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; XP\d+Acme\s+\x2Fcbn\x2Fnode=Host\x3A\x3Fsearch\x3DversionContact
(assert (str.in_re X (re.++ (str.to_re "XP") (re.+ (re.range "0" "9")) (str.to_re "Acme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cbn/node=Host:?search=versionContact\u{0a}"))))
; /[0-9A-Z]{8}\u{3a}bpass\u{0a}/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "A" "Z"))) (str.to_re ":bpass\u{0a}/\u{0a}"))))
; ppcdomain\x2Eco\x2Euk.*Spy\-Locked\s+Exploiter\w+\x2Fr\x2Fkeys\x2FkeysS\u{3a}Users\u{5c}Iterenet
(assert (not (str.in_re X (re.++ (str.to_re "ppcdomain.co.uk") (re.* re.allchar) (str.to_re "Spy-Locked") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Exploiter") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/r/keys/keysS:Users\u{5c}Iterenet\u{0a}")))))
; /new (java|org)/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/new ") (re.union (str.to_re "java") (str.to_re "org")) (str.to_re "/Ui\u{0a}")))))
; name\u{3d}Emailbadurl\x2Egrandstreetinteractive\x2EcomHost\x3Astepwww\x2Ekornputers\x2Ecom
(assert (not (str.in_re X (str.to_re "name=Emailbadurl.grandstreetinteractive.comHost:stepwww.kornputers.com\u{0a}"))))
(check-sat)
