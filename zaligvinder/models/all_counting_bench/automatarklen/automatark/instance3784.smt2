(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\[0-9]{4}\-\[0-9]{2}\-\[0-9]{2}$
(assert (str.in_re X (re.++ (str.to_re "[0-9") ((_ re.loop 4 4) (str.to_re "]")) (str.to_re "-[0-9") ((_ re.loop 2 2) (str.to_re "]")) (str.to_re "-[0-9") ((_ re.loop 2 2) (str.to_re "]")) (str.to_re "\u{0a}"))))
; \u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax
(assert (not (str.in_re X (str.to_re "\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
