(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z]\:|\\)\\([^\\]+\\)*[^\/:*?"<>|]+\.htm(l)?$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (str.to_re "\u{5c}")) (str.to_re "\u{5c}") (re.* (re.++ (re.+ (re.comp (str.to_re "\u{5c}"))) (str.to_re "\u{5c}"))) (re.+ (re.union (str.to_re "/") (str.to_re ":") (str.to_re "*") (str.to_re "?") (str.to_re "\u{22}") (str.to_re "<") (str.to_re ">") (str.to_re "|"))) (str.to_re ".htm") (re.opt (str.to_re "l")) (str.to_re "\u{0a}"))))
; [-]?[1-9]\d{0,16}\.?\d{0,2}|[-]?[0]?\.[1-9]{1,2}|[-]?[0]?\.[0-9][1-9]
(assert (str.in_re X (re.union (re.++ (re.opt (str.to_re "-")) (re.range "1" "9") ((_ re.loop 0 16) (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 0 2) (re.range "0" "9"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) (str.to_re ".") ((_ re.loop 1 2) (re.range "1" "9"))) (re.++ (re.opt (str.to_re "-")) (re.opt (str.to_re "0")) (str.to_re ".") (re.range "0" "9") (re.range "1" "9") (str.to_re "\u{0a}")))))
(check-sat)
