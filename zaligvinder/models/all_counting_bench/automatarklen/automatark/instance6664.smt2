(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}xul([\?\u{5c}\u{2f}]|$)/Umsi
(assert (str.in_re X (re.++ (str.to_re "/.xul") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/Umsi\u{0a}"))))
; /filename=[^\n]*\u{2e}sum/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sum/i\u{0a}"))))
; ^\w+(([-+']|[-+.]|\w+))*@\w+([-.]\w+)*\.\w+([-.]\w+)*$
(assert (not (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.union (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "-") (str.to_re "+") (str.to_re "'") (str.to_re "-") (str.to_re "+") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re ".") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (re.++ (re.union (str.to_re "-") (str.to_re ".")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (str.to_re "\u{0a}")))))
; /^udp\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (not (str.in_re X (re.++ (str.to_re "/udp|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}")))))
; ^(\+27|27)?(\()?0?([7][1-9]|[8][2-4])(\))?( |-|\.|_)?(\d{3})( |-|\.|_)?(\d{4})
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "+27") (str.to_re "27"))) (re.opt (str.to_re "(")) (re.opt (str.to_re "0")) (re.union (re.++ (str.to_re "7") (re.range "1" "9")) (re.++ (str.to_re "8") (re.range "2" "4"))) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "-") (str.to_re ".") (str.to_re "_"))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
