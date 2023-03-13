(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}\u{3f}dp\u{3d}[A-Z0-9]{50}&cb\u{3d}[0-9]{9}/Ui
(assert (str.in_re X (re.++ (str.to_re "//?dp=") ((_ re.loop 50 50) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "&cb=") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "/Ui\u{0a}"))))
; asdbiz\x2Ebiz\s+informationHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "asdbiz.biz") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "informationHost:\u{0a}")))))
(check-sat)
