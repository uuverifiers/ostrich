(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Pleasetvshowticketsmedia\x2Edxcdirect\x2Ecom\x2Fbar_pl\x2Fchk\.fcgi
(assert (str.in_re X (str.to_re "Pleasetvshowticketsmedia.dxcdirect.com/bar_pl/chk.fcgi\u{0a}")))
; ^((4\d{3})|(5[1-5]\d{2})|(6011))-?\d{4}-?\d{4}-?\d{4}|3[4,7]\d{13}$
(assert (str.in_re X (re.union (re.++ (re.union (re.++ (str.to_re "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "5") (re.range "1" "5") ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re "6011")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "3") (re.union (str.to_re "4") (str.to_re ",") (str.to_re "7")) ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[0-9]{3}[-][0-9]{4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \S*?[\["].*?[\]"]|\S+
(assert (str.in_re X (re.union (re.++ (re.* (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.union (str.to_re "[") (str.to_re "\u{22}")) (re.* re.allchar) (re.union (str.to_re "]") (str.to_re "\u{22}"))) (re.++ (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
