(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^User-Agent\x3A[^\r\n]*TT-Bot/mi
(assert (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "TT-Bot/mi\u{0a}"))))
; ^[A-Z0-9a-z'&()/]{0,1}[A-Z0-9a-z'&()/]{0,1}(([A-Z0-9a-z'&()/_-])|(\\s)){0,47}[A-Z0-9a-z'&()/]{1}$
(assert (str.in_re X (re.++ (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (re.opt (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) ((_ re.loop 0 47) (re.union (str.to_re "\u{5c}s") (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/") (str.to_re "_") (str.to_re "-"))) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "0" "9") (re.range "a" "z") (str.to_re "'") (str.to_re "&") (str.to_re "(") (str.to_re ")") (str.to_re "/"))) (str.to_re "\u{0a}"))))
; ^((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*);|(0|[1-9]+[0-9]*);)*?((0|[1-9]+[0-9]*)-(0|[1-9]+[0-9]*)|(0|[1-9]+[0-9]*)){1}$
(assert (not (str.in_re X (re.++ (re.* (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")) (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re ";")))) ((_ re.loop 1 1) (re.union (re.++ (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")))) (str.to_re "-") (re.union (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "0") (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
