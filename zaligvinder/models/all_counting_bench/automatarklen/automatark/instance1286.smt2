(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ([0-9]|[0-9][0-9])\.\s
(assert (str.in_re X (re.++ (str.to_re ".") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}") (re.range "0" "9") (re.range "0" "9"))))
; ^L[a-zA-Z0-9]{26,33}$
(assert (not (str.in_re X (re.++ (str.to_re "L") ((_ re.loop 26 33) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^((\([2-9]\d{2}\)[ ]?)|([2-9]\d{2})[- ]?)\d{3}[- ]?\d{4}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "(") (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " "))) (re.range "2" "9") ((_ re.loop 2 2) (re.range "0" "9")))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; horoscope2Cookie\u{3a}datATTENTION\x3AKontiki
(assert (str.in_re X (str.to_re "horoscope2Cookie:datATTENTION:Kontiki\u{0a}")))
; /filename=[^\n]*\u{2e}tif/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tif/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
