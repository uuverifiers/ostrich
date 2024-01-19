(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^Host\u{3a}[^\u{0d}\u{0a}]+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\u{3a}\d{1,5}\u{0d}?$/mi
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 5) (re.range "0" "9")) (re.opt (str.to_re "\u{0d}")) (str.to_re "/mi\u{0a}")))))
; /\u{2e}jif([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.jif") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(\d{1}|\d{2}|\d{3})(\.\d{3})*?$
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.* (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ChildWebGuardian\d+Subject\x3A
(assert (str.in_re X (re.++ (str.to_re "ChildWebGuardian") (re.+ (re.range "0" "9")) (str.to_re "Subject:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
