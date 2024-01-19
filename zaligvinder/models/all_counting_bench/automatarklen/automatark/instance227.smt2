(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\w+.*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar) (str.to_re "\u{0a}"))))
; ^http://([a-zA-Z0-9_\-]+)([\.][a-zA-Z0-9_\-]+)+([/][a-zA-Z0-9\~\(\)_\-]*)+([\.][a-zA-Z0-9\(\)_\-]+)*$
(assert (not (str.in_re X (re.++ (str.to_re "http://") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (re.+ (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))))) (re.+ (re.++ (str.to_re "/") (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "~") (str.to_re "(") (str.to_re ")") (str.to_re "_") (str.to_re "-"))))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "(") (str.to_re ")") (str.to_re "_") (str.to_re "-"))))) (str.to_re "\u{0a}")))))
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}"))))
; ^\d{9}[\d|X]$
(assert (str.in_re X (re.++ ((_ re.loop 9 9) (re.range "0" "9")) (re.union (re.range "0" "9") (str.to_re "|") (str.to_re "X")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
