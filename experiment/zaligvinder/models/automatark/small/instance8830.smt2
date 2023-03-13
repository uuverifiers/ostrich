(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\s+|)((\(\d{3}\) +)|(\d{3}-)|(\d{3} +))?\d{3}(-| +)\d{4}( +x\d{1,4})?(\s+|)
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.+ (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-")) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.+ (str.to_re " "))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (re.+ (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.+ (str.to_re " ")) (str.to_re "x") ((_ re.loop 1 4) (re.range "0" "9")))) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; /\/DES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (str.in_re X (re.++ (str.to_re "//DES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}"))))
; /filename=[^\n]*\u{2e}xap/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xap/i\u{0a}"))))
; Pleasetvshowticketsmedia\x2Edxcdirect\x2Ecom\x2Fbar_pl\x2Fchk\.fcgi
(assert (str.in_re X (str.to_re "Pleasetvshowticketsmedia.dxcdirect.com/bar_pl/chk.fcgi\u{0a}")))
(check-sat)
