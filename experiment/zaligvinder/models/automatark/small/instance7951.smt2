(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; forum=From\u{3a}comTencentTravelerBackAtTaCkExplorer
(assert (not (str.in_re X (str.to_re "forum=From:comTencentTravelerBackAtTaCkExplorer\u{0a}"))))
; ^\$?([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(\.[0-9][0-9])?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") (re.range "0" "9") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; Password="(\{.+\}[0-9a-zA-Z]+[=]*|[0-9a-zA-Z]+)"
(assert (str.in_re X (re.++ (str.to_re "Password=\u{22}") (re.union (re.++ (str.to_re "{") (re.+ re.allchar) (str.to_re "}") (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z"))) (re.* (str.to_re "="))) (re.+ (re.union (re.range "0" "9") (re.range "a" "z") (re.range "A" "Z")))) (str.to_re "\u{22}\u{0a}"))))
; /^User-Agent\x3A[^\r\n]*TT-Bot/mi
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "TT-Bot/mi\u{0a}")))))
(check-sat)
