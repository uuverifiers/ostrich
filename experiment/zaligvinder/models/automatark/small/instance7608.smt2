(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; forum=\s+\x2Ftoolbar\x2Fico\x2F
(assert (not (str.in_re X (re.++ (str.to_re "forum=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/\u{0a}")))))
; ^(000-)(\\d{5}-){2}\\d{3}$
(assert (not (str.in_re X (re.++ (str.to_re "000-") ((_ re.loop 2 2) (re.++ (str.to_re "\u{5c}") ((_ re.loop 5 5) (str.to_re "d")) (str.to_re "-"))) (str.to_re "\u{5c}") ((_ re.loop 3 3) (str.to_re "d")) (str.to_re "\u{0a}")))))
; weatherSubject\u{3a}X-Mailer\u{3a}TOOLBAR\x2Fnewsurfer4\x2F
(assert (str.in_re X (str.to_re "weatherSubject:X-Mailer:\u{13}TOOLBAR/newsurfer4/\u{0a}")))
(check-sat)
