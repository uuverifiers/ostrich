(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}ses/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ses/i\u{0a}"))))
; s_sq=aolsnssignin.*LOG\s+Host\x3ASubject\x3Aonline-casino-searcher\.com
(assert (not (str.in_re X (re.++ (str.to_re "s_sq=aolsnssignin") (re.* re.allchar) (str.to_re "LOG") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Subject:online-casino-searcher.com\u{0a}")))))
; ^(([0-9]{2})|([a-zA-Z][0-9])|([a-zA-Z]{2}))[0-9]{6}$
(assert (str.in_re X (re.++ (re.union ((_ re.loop 2 2) (re.range "0" "9")) (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.range "0" "9")) ((_ re.loop 2 2) (re.union (re.range "a" "z") (re.range "A" "Z")))) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\u{3a}\s+Host\x3A\s+proxystylesheet=Excitefhfksjzsfu\u{2f}ahm\.uqs
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "proxystylesheet=Excitefhfksjzsfu/ahm.uqs\u{0a}"))))
(check-sat)
