(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}wmx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wmx/i\u{0a}")))))
; ^(BE)[0-1]{1}[0-9]{9}$|^((BE)|(BE ))[0-1]{1}(\d{3})([.]{1})(\d{3})([.]{1})(\d{3})
(assert (not (str.in_re X (re.union (re.++ (str.to_re "BE") ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (re.union (str.to_re "BE") (str.to_re "BE ")) ((_ re.loop 1 1) (re.range "0" "1")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(check-sat)
