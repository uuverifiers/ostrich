(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 1?[ \.\-\+]?[(]?([0-9]{3})?[)]?[ \.\-\+]?[0-9]{3}[ \.\-\+]?[0-9]{4}
(assert (str.in_re X (re.++ (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) (re.opt (str.to_re "(")) (re.opt ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re ".") (str.to_re "-") (str.to_re "+"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; weatherSubject\u{3a}X-Mailer\u{3a}TOOLBAR\x2Fnewsurfer4\x2F
(assert (str.in_re X (str.to_re "weatherSubject:X-Mailer:\u{13}TOOLBAR/newsurfer4/\u{0a}")))
; /\u{2e}ani([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.ani") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; [\u{80}-\xFF]
(assert (not (str.in_re X (re.++ (re.range "\u{80}" "\u{ff}") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
