(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}ppt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ppt/i\u{0a}"))))
; ^([1-9]{0,1})([0-9]{1})((\.[0-9]{0,1})([0-9]{1})|(\,[0-9]{0,1})([0-9]{1}))?$
(assert (not (str.in_re X (re.++ (re.opt (re.range "1" "9")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ".") (re.opt (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ",") (re.opt (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; (^\d{1,9})+(,\d{1,9})*$
(assert (str.in_re X (re.++ (re.+ ((_ re.loop 1 9) (re.range "0" "9"))) (re.* (re.++ (str.to_re ",") ((_ re.loop 1 9) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; User-Agent\x3A\dBarwww\x2Eaccoona\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.range "0" "9") (str.to_re "Barwww.accoona.com\u{0a}")))))
; ^([1-9]|0[1-9]|[12][0-9]|3[01])(-|/)(([1-9]|0[1-9])|(1[0-2]))(-|/)(([0-9][0-9])|([0-9][0-9][0-9][0-9]))$
(assert (not (str.in_re X (re.++ (re.union (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (re.union (str.to_re "1") (str.to_re "2")) (re.range "0" "9")) (re.++ (str.to_re "3") (re.union (str.to_re "0") (str.to_re "1")))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9"))) (re.union (str.to_re "-") (str.to_re "/")) (re.union (re.++ (re.range "0" "9") (re.range "0" "9")) (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
(check-sat)
