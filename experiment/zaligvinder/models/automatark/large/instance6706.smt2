(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; sponsor2\.ucmore\.com\s+informationHost\x3A\x2Fezsb
(assert (str.in_re X (re.++ (str.to_re "sponsor2.ucmore.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "informationHost:/ezsb\u{0a}"))))
; /[a-z]\u{3d}[a-f\d]{126}/P
(assert (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 126 126) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/P\u{0a}"))))
; KeyloggerFSWcmdldap\x3A\x2F\x2FExploiterconnection\x2Ewww\x2Eoemji\x2Ecomzopabora\x2EinfoConnection
(assert (str.in_re X (str.to_re "KeyloggerFSWcmdldap://Exploiterconnection.www.oemji.comzopabora.infoConnection\u{0a}")))
(check-sat)
