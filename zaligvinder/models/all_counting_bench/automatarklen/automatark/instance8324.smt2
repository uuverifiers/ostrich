(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\u{2f}[a-f0-9]{135}/Um
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 135 135) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Um\u{0a}")))))
; www\x2Epcsentinelsoftware\x2Ecom
(assert (str.in_re X (str.to_re "www.pcsentinelsoftware.com\u{0a}")))
; ([^a-zA-Z0-9])
(assert (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
