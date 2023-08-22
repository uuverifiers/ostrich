(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3AX-Mailer\u{3a}Host\x3Adcww\x2Edmcast\x2Ecom
(assert (str.in_re X (str.to_re "User-Agent:X-Mailer:\u{13}Host:dcww.dmcast.com\u{0a}")))
; \sKeylogging\s+ApofisToolbar
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Keylogging\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ApofisToolbar\u{0a}")))))
; ^([A-Z]|[a-z]){4} ?[0-9]{6}-?[0-9]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
