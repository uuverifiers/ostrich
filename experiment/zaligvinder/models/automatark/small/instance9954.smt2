(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^"[^"]+"$
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.+ (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}\u{0a}"))))
; ^(\+|-)?(\d\.\d{1,6}|[1-8]\d\.\d{1,6}|90\.0{1,6})$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.union (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (re.range "1" "8") (re.range "0" "9") (str.to_re ".") ((_ re.loop 1 6) (re.range "0" "9"))) (re.++ (str.to_re "90.") ((_ re.loop 1 6) (str.to_re "0")))) (str.to_re "\u{0a}")))))
(check-sat)
