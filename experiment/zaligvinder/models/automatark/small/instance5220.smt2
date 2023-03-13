(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\({0,1}0(2|3|7|8)\){0,1}(\ |-){0,1}[0-9]{4}(\ |-){0,1}[0-9]{4}$
(assert (str.in_re X (re.++ (re.opt (str.to_re "(")) (str.to_re "0") (re.union (str.to_re "2") (str.to_re "3") (str.to_re "7") (str.to_re "8")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[1-9]\d*\.?[0]*$
(assert (not (str.in_re X (re.++ (re.range "1" "9") (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) (re.* (str.to_re "0")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}webm/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".webm/i\u{0a}")))))
(check-sat)
