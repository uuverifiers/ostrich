(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xls/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xls/i\u{0a}")))))
; forum=.*Explorer\s+Host\x3Aact=Host\u{3a}User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "forum=") (re.* re.allchar) (str.to_re "Explorer") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:act=Host:User-Agent:\u{0a}")))))
; /filename\=[a-z0-9]{24}\.exe/H
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") ((_ re.loop 24 24) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".exe/H\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
