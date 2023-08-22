(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{3,3}\.\d{0,2}$|^E\d{3,3}\.\d{0,2}$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (str.to_re "E") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; /filename=[^\n]*\u{2e}emf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".emf/i\u{0a}")))))
; /\/images\/[a-zA-Z]\.php\?id\=[0-9]{2,3}(\.\d)?$/Ui
(assert (str.in_re X (re.++ (str.to_re "//images/") (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ".php?id=") ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; configINTERNAL\.ini\s+User-Agent\x3A\s+Host\x3ASubject\u{3a}
(assert (str.in_re X (re.++ (str.to_re "configINTERNAL.ini") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Subject:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
