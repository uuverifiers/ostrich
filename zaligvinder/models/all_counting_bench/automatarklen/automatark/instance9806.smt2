(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /(\u{19}\u{00}|\u{00}\x5C)\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}\.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i
(assert (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "\u{19}\u{00}") (str.to_re "\u{00}\u{5c}")) (str.to_re "\u{00}s\u{00}p\u{00}f\u{00}r\u{00}a\u{00}m\u{00}e\u{00}.\u{00}d\u{00}l\u{00}l\u{00}\u{00}\u{00}/i\u{0a}"))))
; ^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re "."))) (str.to_re ".") ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; ^((.){1,}(\d){1,}(.){0,})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ re.allchar) (re.+ (re.range "0" "9")) (re.* re.allchar)))))
; User-Agent\u{3a}User-Agent\x3A
(assert (not (str.in_re X (str.to_re "User-Agent:User-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
