(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; findX-Mailer\u{3a}User-Agent\x3Awww\.take5bingo\.comX-Mailer\u{3a}\u{04}\u{00}
(assert (not (str.in_re X (str.to_re "findX-Mailer:\u{13}User-Agent:www.take5bingo.com\u{1b}X-Mailer:\u{13}\u{04}\u{00}\u{0a}"))))
; ^[a-zA-Z]{3}[uU]{1}[0-9]{7}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.union (str.to_re "u") (str.to_re "U"))) ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (@\s*".*?")|("([^"\\]|\\.)*?")
(assert (str.in_re X (re.union (re.++ (str.to_re "@") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{0a}\u{22}") (re.* (re.union (re.++ (str.to_re "\u{5c}") re.allchar) (str.to_re "\u{22}") (str.to_re "\u{5c}"))) (str.to_re "\u{22}")))))
; ^([A-Z]|[a-z]){4} ?[0-9]{6}-?[0-9]{1}$
(assert (not (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (str.to_re " ")) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
