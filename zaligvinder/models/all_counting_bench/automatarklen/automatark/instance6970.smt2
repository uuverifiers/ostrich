(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^07([\d]{3})[(\D\s)]?[\d]{3}[(\D\s)]?[\d]{3}$
(assert (str.in_re X (re.++ (str.to_re "07") ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "(") (re.comp (re.range "0" "9")) (str.to_re ")") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /^\u{2f}\u{3f}xclve\u{5f}[a-zA-Z0-9]{30}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//?xclve_") ((_ re.loop 30 30) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}"))))
; iz=Referer\x3Aoffers\x2Ebullseye-network\x2Ecom
(assert (not (str.in_re X (str.to_re "iz=Referer:offers.bullseye-network.com\u{0a}"))))
; (a|A)
(assert (str.in_re X (re.++ (re.union (str.to_re "a") (str.to_re "A")) (str.to_re "\u{0a}"))))
; /\x2Fmrow\x5Fpin\x2F\x3Fid\d+[a-z]{5,}\d{5}\u{26}rnd\x3D\d+/smi
(assert (not (str.in_re X (re.++ (str.to_re "//mrow_pin/?id") (re.+ (re.range "0" "9")) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "&rnd=") (re.+ (re.range "0" "9")) (str.to_re "/smi\u{0a}") ((_ re.loop 5 5) (re.range "a" "z")) (re.* (re.range "a" "z"))))))
(assert (> (str.len X) 10))
(check-sat)
