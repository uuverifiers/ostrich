(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((&#[0-9]+|&[a-zA-Z]+[0-9]*?);)
(assert (str.in_re X (re.++ (str.to_re "\u{0a};&") (re.union (re.++ (str.to_re "#") (re.+ (re.range "0" "9"))) (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.* (re.range "0" "9")))))))
; /filename=[^\n]*\u{2e}met/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".met/i\u{0a}")))))
; X-Mailer\x3A\s+Toolbar\s+supremetoolbar\.comst=Host\x3A\x5Chome\/lordofsearchMicrosoftHost\u{3a}\+The\+password\+is\x3A
(assert (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Toolbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "supremetoolbar.comst=Host:\u{5c}home/lordofsearchMicrosoftHost:+The+password+is:\u{0a}"))))
; [0-9]{5}\s?[0-9]{5}
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ([0-9]{6}|[0-9]{3}\s[0-9]{3})
(assert (str.in_re X (re.++ (re.union ((_ re.loop 6 6) (re.range "0" "9")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
