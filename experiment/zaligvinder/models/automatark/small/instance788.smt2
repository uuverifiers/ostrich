(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-z0-9]+[.+-])*([a-z0-9]+)+@(([a-z0-9]+[.-])+([a-z]{2,})$|(([0-9]|[1-9][0-9]|1[0-9]{1,2}|2[0-4][0-9]|25[0-5])(\.|$)){4})
(assert (str.in_re X (re.++ (re.* (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.union (str.to_re ".") (str.to_re "+") (str.to_re "-")))) (re.+ (re.+ (re.union (re.range "a" "z") (re.range "0" "9")))) (str.to_re "@") (re.union (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (re.union (str.to_re ".") (str.to_re "-")))) ((_ re.loop 2 2) (re.range "a" "z")) (re.* (re.range "a" "z"))) ((_ re.loop 4 4) (re.++ (re.union (re.range "0" "9") (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "25") (re.range "0" "5"))) (str.to_re ".")))) (str.to_re "\u{0a}"))))
; www\x2Ecameup\x2Ecom\s+spyblini\x2Eini
(assert (not (str.in_re X (re.++ (str.to_re "www.cameup.com\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblini.ini\u{0a}")))))
; /filename=[^\n]*\u{2e}swf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".swf/i\u{0a}")))))
; /filename=[^\n]*\u{2e}flv/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".flv/i\u{0a}")))))
; [\+]?[1]?[-. ]?(\(\d{3}\)|\d{3})(|[-. ])?\d{3}(|[-. ])\d{4}|\d{3}(|[-. ])\d{4}
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re "1")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re " "))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re ".") (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
