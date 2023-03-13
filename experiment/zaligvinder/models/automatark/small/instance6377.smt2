(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[5,6]\d{7}|^$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "5") (str.to_re ",") (str.to_re "6")) ((_ re.loop 7 7) (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; XP\d+Acme\s+\x2Fcbn\x2Fnode=Host\x3A\x3Fsearch\x3DversionContact
(assert (str.in_re X (re.++ (str.to_re "XP") (re.+ (re.range "0" "9")) (str.to_re "Acme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cbn/node=Host:?search=versionContact\u{0a}"))))
; ProAgentHost\x3ALOGSeconds\-
(assert (not (str.in_re X (str.to_re "ProAgentHost:LOGSeconds-\u{0a}"))))
; Hourspjpoptwql\u{2f}rlnjFrom\x3Asbver\u{3a}Ghost
(assert (not (str.in_re X (str.to_re "Hourspjpoptwql/rlnjFrom:sbver:Ghost\u{13}\u{0a}"))))
(check-sat)
