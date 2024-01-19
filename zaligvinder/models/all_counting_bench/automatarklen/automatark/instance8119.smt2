(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{6}$
(assert (str.in_re X (re.++ ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^\u{2f}[0-9a-f]+$/iU
(assert (str.in_re X (re.++ (str.to_re "//") (re.+ (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "/iU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
