(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ('.*$|Rem((\t| ).*$|$)|"(.|"")*?")
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "'") (re.* re.allchar)) (re.++ (str.to_re "Rem") (re.union (str.to_re "\u{09}") (str.to_re " ")) (re.* re.allchar)) (re.++ (str.to_re "\u{22}") (re.* (re.union re.allchar (str.to_re "\u{22}\u{22}"))) (str.to_re "\u{22}"))) (str.to_re "\u{0a}"))))
; ^(\d+|(\d*\.{1}\d{1,2}){1})$
(assert (str.in_re X (re.++ (re.union (re.+ (re.range "0" "9")) ((_ re.loop 1 1) (re.++ (re.* (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; ^(102[0-3]|10[0-1]\d|[1-9][0-9]{0,2}|0)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "102") (re.range "0" "3")) (re.++ (str.to_re "10") (re.range "0" "1") (re.range "0" "9")) (re.++ (re.range "1" "9") ((_ re.loop 0 2) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}")))))
; <h([1-6])>([^<]*)</h([1-6])>
(assert (not (str.in_re X (re.++ (str.to_re "<h") (re.range "1" "6") (str.to_re ">") (re.* (re.comp (str.to_re "<"))) (str.to_re "</h") (re.range "1" "6") (str.to_re ">\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
