(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([0-9]{1,2}[:][0-9]{1,2}[:]{0,2}[0-9]{0,2}[\s]{0,}[AMPamp]{0,2})
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 2) (re.range "0" "9")) ((_ re.loop 0 2) (str.to_re ":")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 2) (re.union (str.to_re "A") (str.to_re "M") (str.to_re "P") (str.to_re "a") (str.to_re "m") (str.to_re "p"))))))
; config\x2E180solutions\x2Ecom\dStable\s+Host\u{3a}\x7D\x7C
(assert (not (str.in_re X (re.++ (str.to_re "config.180solutions.com") (re.range "0" "9") (str.to_re "Stable") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:}|\u{0a}")))))
; Host\x3A\u{2c}STATSTimeTotalpassword\x3B1\x3BOptix
(assert (str.in_re X (str.to_re "Host:,STATSTimeTotalpassword;1;Optix\u{0a}")))
; [A-Za-z](\.[A-Za-z0-9]|\-[A-Za-z0-9]|_[A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9])(\.[A-Za-z0-9]|\-[A-Za-z0-9]|_[A-Za-z0-9]|[A-Za-z0-9])*
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z")) (re.union (re.++ (str.to_re ".") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "_") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")))) (re.* (re.union (re.++ (str.to_re ".") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "-") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.++ (str.to_re "_") (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
