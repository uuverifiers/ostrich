(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((\-|d|l|p|s){1}(\-|r|w|x){9})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (str.to_re "-") (str.to_re "d") (str.to_re "l") (str.to_re "p") (str.to_re "s"))) ((_ re.loop 9 9) (re.union (str.to_re "-") (str.to_re "r") (str.to_re "w") (str.to_re "x"))))))
; /filename=[^\n]*\u{2e}wk4/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wk4/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
