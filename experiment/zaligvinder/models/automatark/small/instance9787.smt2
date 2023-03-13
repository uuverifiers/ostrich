(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}mov([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.mov") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; Cookie\u{3a}.*Host\x3A.*ldap\x3A\x2F\x2F
(assert (not (str.in_re X (re.++ (str.to_re "Cookie:") (re.* re.allchar) (str.to_re "Host:") (re.* re.allchar) (str.to_re "ldap://\u{0a}")))))
; XP\d+Acme\s+\x2Fcbn\x2Fnode=Host\x3A\x3Fsearch\x3DversionContact
(assert (not (str.in_re X (re.++ (str.to_re "XP") (re.+ (re.range "0" "9")) (str.to_re "Acme") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/cbn/node=Host:?search=versionContact\u{0a}")))))
; ^((0[0-9])|(1[0-2])|(2[1-9])|(3[0-2])|(6[1-9])|(7[0-2])|80)([0-9]{7})$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.++ (str.to_re "2") (re.range "1" "9")) (re.++ (str.to_re "3") (re.range "0" "2")) (re.++ (str.to_re "6") (re.range "1" "9")) (re.++ (str.to_re "7") (re.range "0" "2")) (str.to_re "80")) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (str.to_re "\u{5c}")) (re.union ((_ re.loop 1 1) (str.to_re "\u{5c}")) (re.+ (re.++ ((_ re.loop 1 1) (str.to_re "\u{5c}")) (re.comp (str.to_re "\u{5c}")) (re.* (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "<") (str.to_re ">") (str.to_re "\u{22}") (str.to_re "|")))))) (str.to_re "\u{0a}")))))
(check-sat)
