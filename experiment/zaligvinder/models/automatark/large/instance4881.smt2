(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /TimeToLive=[^&]*?(%60|\u{60})/iP
(assert (not (str.in_re X (re.++ (str.to_re "/TimeToLive=") (re.* (re.comp (str.to_re "&"))) (re.union (str.to_re "%60") (str.to_re "`")) (str.to_re "/iP\u{0a}")))))
; (\[[abiu][^\[\]]*\])([^\[\]]+)(\[/?[abiu]\])
(assert (not (str.in_re X (re.++ (re.+ (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "\u{0a}[") (re.union (str.to_re "a") (str.to_re "b") (str.to_re "i") (str.to_re "u")) (re.* (re.union (str.to_re "[") (str.to_re "]"))) (str.to_re "][") (re.opt (str.to_re "/")) (re.union (str.to_re "a") (str.to_re "b") (str.to_re "i") (str.to_re "u")) (str.to_re "]")))))
; ^([34|37]{2})([0-9]{13})$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "3") (str.to_re "4") (str.to_re "|") (str.to_re "7"))) ((_ re.loop 13 13) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [0-9]{2}-?[DF][A-Z]{2}-?[0-9]{1}|[DF][A-Z]{1}-?[0-9]{3}-?[A-Z]{1}|[DF]-?[0-9]{3}-?[A-Z]{2}|[DF][A-Z]{2}-?[0-9]{2}-?[A-Z]{1}$
(assert (str.in_re X (re.union (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.union (str.to_re "D") (str.to_re "F")) ((_ re.loop 2 2) (re.range "A" "Z")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ (re.union (str.to_re "D") (str.to_re "F")) ((_ re.loop 1 1) (re.range "A" "Z")) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "A" "Z"))) (re.++ (re.union (str.to_re "D") (str.to_re "F")) (re.opt (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "A" "Z"))) (re.++ (re.union (str.to_re "D") (str.to_re "F")) ((_ re.loop 2 2) (re.range "A" "Z")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "A" "Z")) (str.to_re "\u{0a}")))))
; /\?inf\=[0-9a-f]{8}\x2Ex\d{2}\x2E\d{8}\x2E/Ui
(assert (str.in_re X (re.++ (str.to_re "/?inf=") ((_ re.loop 8 8) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ".x") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "./Ui\u{0a}"))))
(check-sat)
